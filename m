Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 488E5E17BB
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 12:22:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404261AbfJWKWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 06:22:18 -0400
Received: from perceval.ideasonboard.com ([213.167.242.64]:36866 "EHLO
        perceval.ideasonboard.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403810AbfJWKWR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 06:22:17 -0400
Received: from pendragon.ideasonboard.com (143.121.2.93.rev.sfr.net [93.2.121.143])
        by perceval.ideasonboard.com (Postfix) with ESMTPSA id 613D5814;
        Wed, 23 Oct 2019 12:22:13 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ideasonboard.com;
        s=mail; t=1571826133;
        bh=eGJOH1VGLoVHmq/1QUJrrmrQnHMBekaXv4x5beDzUns=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hNt1lFgV/RYMyeFBPXTgQiKb3GwPw/Wa344JMMSZWnwFmLvL/ZwSc8yFopTSs7O3V
         3BEcvANOutiE3Uqo9EUjLPvIH0XYH9JeysLU4k3odp1PfhlVV0P9EFVjba6AUVEZTx
         Bg5kiEXBNGIQl2WjyNDPL8rSeOPgyZ4CMk60KXUs=
Date:   Wed, 23 Oct 2019 13:22:07 +0300
From:   Laurent Pinchart <laurent.pinchart@ideasonboard.com>
To:     Mark Salyzyn <salyzyn@android.com>
Cc:     linux-kernel@vger.kernel.org, kernel-team@android.com,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?utf-8?B?S8O2bmln?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        VMware Graphics <linux-graphics-maintainer@vmware.com>,
        Thomas Hellstrom <thellstrom@vmware.com>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Alexander Aring <alex.aring@gmail.com>,
        Jukka Rissanen <jukka.rissanen@linux.intel.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>,
        Ingo Molnar <mingo@kernel.org>,
        Matthew Garrett <matthewgarrett@google.com>,
        Hans de Goede <hdegoede@redhat.com>,
        hersen wu <hersenxs.wu@amd.com>, Roman Li <Roman.Li@amd.com>,
        Maxim Martynov <maxim@arista.com>,
        David Ahern <dsahern@gmail.com>,
        Francesco Ruggeri <fruggeri@arista.com>,
        Linus =?utf-8?Q?L=C3=BCssing?= <linus.luessing@c0d3.blue>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Feng Tang <feng.tang@intel.com>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Rafael Aquini <aquini@redhat.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-efi@vger.kernel.org,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-media@vger.kernel.org, linux-nfs@vger.kernel.org,
        linux-bluetooth@vger.kernel.org, linux-wpan@vger.kernel.org
Subject: Re: [PATCH] Cleanup: replace prefered with preferred
Message-ID: <20191023102207.GB4763@pendragon.ideasonboard.com>
References: <20191022214208.211448-1-salyzyn@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20191022214208.211448-1-salyzyn@android.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mark,

Thank you for the patch.

On Tue, Oct 22, 2019 at 02:41:45PM -0700, Mark Salyzyn wrote:
> Replace all occurrences of prefered with preferred to make future
> checkpatch.pl's happy.  A few places the incorrect spelling is
> matched with the correct spelling to preserve existing user space API.
> 
> Signed-off-by: Mark Salyzyn <salyzyn@android.com>
> ---
>  Documentation/networking/ip-sysctl.txt        |   2 +-
>  .../firmware/efi/libstub/efi-stub-helper.c    |   2 +-
>  .../gpu/drm/amd/display/dc/inc/compressor.h   |   4 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.c           |   2 +-
>  drivers/gpu/drm/vmwgfx/vmwgfx_kms.h           |   2 +-
>  drivers/media/usb/uvc/uvc_video.c             |   6 +-
>  fs/nfs/nfs4xdr.c                              |   2 +-
>  include/linux/ipv6.h                          |   2 +-
>  include/net/addrconf.h                        |   4 +-
>  include/net/if_inet6.h                        |   2 +-
>  include/net/ndisc.h                           |   8 +-
>  include/uapi/linux/if_addr.h                  |   5 +-
>  include/uapi/linux/ipv6.h                     |   4 +-
>  include/uapi/linux/sysctl.h                   |   4 +-
>  include/uapi/linux/usb/video.h                |   5 +-
>  kernel/sysctl_binary.c                        |   3 +-
>  net/6lowpan/ndisc.c                           |   4 +-
>  net/ipv4/devinet.c                            |  20 ++--
>  net/ipv6/addrconf.c                           | 113 ++++++++++--------
>  19 files changed, 112 insertions(+), 82 deletions(-)

[snip]

> diff --git a/drivers/media/usb/uvc/uvc_video.c b/drivers/media/usb/uvc/uvc_video.c
> index 8fa77a81dd7f..0096e6aacdb4 100644
> --- a/drivers/media/usb/uvc/uvc_video.c
> +++ b/drivers/media/usb/uvc/uvc_video.c
> @@ -276,13 +276,13 @@ static int uvc_get_video_ctrl(struct uvc_streaming *stream,
>  	if (size >= 34) {
>  		ctrl->dwClockFrequency = get_unaligned_le32(&data[26]);
>  		ctrl->bmFramingInfo = data[30];
> -		ctrl->bPreferedVersion = data[31];
> +		ctrl->bPreferredVersion = data[31];
>  		ctrl->bMinVersion = data[32];
>  		ctrl->bMaxVersion = data[33];
>  	} else {
>  		ctrl->dwClockFrequency = stream->dev->clock_frequency;
>  		ctrl->bmFramingInfo = 0;
> -		ctrl->bPreferedVersion = 0;
> +		ctrl->bPreferredVersion = 0;
>  		ctrl->bMinVersion = 0;
>  		ctrl->bMaxVersion = 0;
>  	}
> @@ -325,7 +325,7 @@ static int uvc_set_video_ctrl(struct uvc_streaming *stream,
>  	if (size >= 34) {
>  		put_unaligned_le32(ctrl->dwClockFrequency, &data[26]);
>  		data[30] = ctrl->bmFramingInfo;
> -		data[31] = ctrl->bPreferedVersion;
> +		data[31] = ctrl->bPreferredVersion;
>  		data[32] = ctrl->bMinVersion;
>  		data[33] = ctrl->bMaxVersion;
>  	}

[snip]

> diff --git a/include/uapi/linux/usb/video.h b/include/uapi/linux/usb/video.h
> index d854cb19c42c..59167f0ed5c1 100644
> --- a/include/uapi/linux/usb/video.h
> +++ b/include/uapi/linux/usb/video.h
> @@ -448,7 +448,10 @@ struct uvc_streaming_control {
>  	__u32 dwMaxPayloadTransferSize;
>  	__u32 dwClockFrequency;
>  	__u8  bmFramingInfo;
> -	__u8  bPreferedVersion;
> +	union {
> +		__u8 bPreferredVersion;
> +		__u8 bPreferedVersion __attribute__((deprecated)); /* NOTYPO */
> +	} __attribute__((__packed__));

Quite interestingly this typo is part of the USB device class definition
for video devices (UVC) specification. I thus think we should keep using
the field name bPreferedVersion through the code, otherwise it wouldn't
match the spec.

>  	__u8  bMinVersion;
>  	__u8  bMaxVersion;
>  } __attribute__((__packed__));

[snip]

-- 
Regards,

Laurent Pinchart
