/*
 * Copyright (C) 2006 Apple Computer, Inc.
 *
 * Portions are Copyright (C) 2001-6 mozilla.org
 *
 * Other contributors:
 *   Stuart Parmenter <stuart@mozilla.com>
 *
 * Copyright (C) 2007-2009 Torch Mobile, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301  USA
 *
 * Alternatively, the contents of this file may be used under the terms
 * of either the Mozilla Public License Version 1.1, found at
 * http://www.mozilla.org/MPL/ (the "MPL") or the GNU General Public
 * License Version 2.0, found at http://www.fsf.org/copyleft/gpl.html
 * (the "GPL"), in which case the provisions of the MPL or the GPL are
 * applicable instead of those above.  If you wish to allow use of your
 * version of this file only under the terms of one of those two
 * licenses (the MPL or the GPL) and not to allow others to use your
 * version of this file under the LGPL, indicate your decision by
 * deletingthe provisions above and replace them with the notice and
 * other provisions required by the MPL or the GPL, as the case may be.
 * If you do not delete the provisions above, a recipient may use your
 * version of this file under any of the LGPL, the MPL or the GPL.
 */

#include "config.h"
#include "platform/image-decoders/gif/GIFImageDecoder.h"
#include "platform/PlatformInstrumentation.h"

#if CPU(BIG_ENDIAN) || CPU(MIDDLE_ENDIAN)
#error Blink assumes a little-endian target.
#endif

namespace blink
{
    BRCMIMAGE_T* GIFImageDecoder::m_decoder=NULL;
    BRCMIMAGE_REQUEST_T GIFImageDecoder::m_dec_request;

    BYTE gifSignature[] = {'G', 'I', 'F'};

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    GIFImageDecoder::GIFImageDecoder(ImageSource::AlphaOption alphaOption,
                                       ImageSource::GammaAndColorProfileOption gammaAndColorProfileOption,
                                       size_t maxDecodedBytes)
        : RPIImageDecoder(alphaOption, gammaAndColorProfileOption, maxDecodedBytes)
    {
        if (!m_decoder)
        {
            BRCMIMAGE_STATUS_T status = brcmimage_create(BRCMIMAGE_TYPE_DECODER, MMAL_ENCODING_GIF, &m_decoder);
            if (status != BRCMIMAGE_SUCCESS)
            {
                log("could not create HW GIF decoder");
                brcmimage_release(m_decoder);
                m_decoder = NULL;
            }
            else
            {
                log("HW GIF decoder created (%x)", m_decoder);
            }

        }
    }

    ///////////////////////////////////////////////////////////////////////////////////////////////////
    GIFImageDecoder::~GIFImageDecoder()
    {
    }


    ///////////////////////////////////////////////////////////////////////////////////////////////////
    bool GIFImageDecoder::readSize(unsigned int &width, unsigned int &height)
    {
        BYTE* dataptr = (BYTE*)m_data->data();
        memcpy(&m_header, dataptr, sizeof(m_header));

        // check PNG signature
        if (strncmp((const char*)&m_header, (const char*)gifSignature, 3))
        {
            log("GIF signature check failed. (%d %d %d)",
                    dataptr[0], dataptr[1], dataptr[2]);
            return false;
        }

        width = m_header.width[1] + (m_header.width[0] << 8);
        height = m_header.height[1] + (m_header.height[0] << 8);

        return true;
    }
}
