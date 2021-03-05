Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1F032E059
	for <lists+netdev@lfdr.de>; Fri,  5 Mar 2021 05:04:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229592AbhCEEDy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 23:03:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbhCEEDx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Mar 2021 23:03:53 -0500
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC4CFC061574
        for <netdev@vger.kernel.org>; Thu,  4 Mar 2021 20:03:52 -0800 (PST)
Received: by mail-oi1-x232.google.com with SMTP id i21so1088290oii.2
        for <netdev@vger.kernel.org>; Thu, 04 Mar 2021 20:03:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qy+49UERUnQgX3OFYzgPC3L0DOPLQ08jf6F1tpFsi8g=;
        b=dz+z4DIR0CdXh5nz4aXv6kigpxoTFAb67Y5G2TXeINWTt4n7/eUU9iODqeW0NgD7Aw
         wXGgZmxnC0AS/4ZO62HWGJG9wjq2t5nDoWS7PBTbWJDY5yMn4NXGANIFnaN9QF74HlUW
         1ZLwzs5Njv4sy7FLClE1VnJLW1fJK0pAtZwODcEjQeIOGpSq6/SAp2lMNCRTCOOi4+ww
         luEOcgFi1HxZqJCCioSF/m/BxCAdyBR8jxm5UQdWKAqZvKti91OsgSoOWq06+jDcGiGq
         vURBLSst+aJZNTDOUDKHzrOMk2Gv8OKvcDkB63sFIBlnw1iMxuxzhOlkkeUDnq2UPtTl
         s7cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qy+49UERUnQgX3OFYzgPC3L0DOPLQ08jf6F1tpFsi8g=;
        b=pjhtpZgi6xKxTwWkRuBCxSAVWBnbA7NtNqOIMNQT6kWCIO8AKeeR66fx+wVEDcPzzi
         8lgIbawuS/+m6RvdN6E4i25xPcvKQGbCJZ1gLDNIGRV6zMS2Ma0bvUsTDeA6lsGNUPeN
         kNlLARmVrLJ9WnSd8xtdIUFjLC/jYk94Mck0nWLCHiOzwGh70D3kGC1bcZGPcII14nWw
         n2WP6dezp70wRglhk2fK60rz6xVIZDyTFDIm3gb+/wQUxr/0UO4aR4nQPR8UVpIX9BpS
         XIaQVayu7XxTymcmIS6MlmVXBon4eoi8Y3kPBew3gPryaz6Fry6HScp3WRggN0DAigAe
         ogWw==
X-Gm-Message-State: AOAM530pFWv/PjfM4cwG2ewUJf6Vn0PtfSjAWihQHiVXL6qCyIvQ8j3x
        iPti+SZylS23uksDBAq9PKGaCQ==
X-Google-Smtp-Source: ABdhPJxRQFMzR/Euq/TWa8ATlfsRU6jAFLI1bRsK4pHICaxnwbSE69cxqeZl4+bmU+Htd/VBqrwLzw==
X-Received: by 2002:aca:3a42:: with SMTP id h63mr5569017oia.101.1614917031367;
        Thu, 04 Mar 2021 20:03:51 -0800 (PST)
Received: from builder.lan (104-57-184-186.lightspeed.austtx.sbcglobal.net. [104.57.184.186])
        by smtp.gmail.com with ESMTPSA id w23sm313159oow.25.2021.03.04.20.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:03:51 -0800 (PST)
Date:   Thu, 4 Mar 2021 22:03:49 -0600
From:   Bjorn Andersson <bjorn.andersson@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, sharathv@codeaurora.org,
        evgreen@chromium.org, cpratapa@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] net: qualcomm: rmnet: mark trailer field
 endianness
Message-ID: <YEGtpapsfaAaGu95@builder.lan>
References: <20210304223431.15045-1-elder@linaro.org>
 <20210304223431.15045-2-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210304223431.15045-2-elder@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu 04 Mar 16:34 CST 2021, Alex Elder wrote:

> The fields in the checksum trailer structure used for QMAP protocol
> RX packets are all big-endian format, so define them that way.
> 
> It turns out these fields are never actually used by the RMNet code.
> The start offset is always assumed to be zero, and the length is
> taken from the other packet headers.  So making these fields
> explicitly big endian has no effect on the behavior of the code.
> 
> Signed-off-by: Alex Elder <elder@linaro.org>

Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>

Regards,
Bjorn

> ---
>  include/linux/if_rmnet.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/linux/if_rmnet.h b/include/linux/if_rmnet.h
> index 9661416a9bb47..8c7845baf3837 100644
> --- a/include/linux/if_rmnet.h
> +++ b/include/linux/if_rmnet.h
> @@ -32,8 +32,8 @@ struct rmnet_map_dl_csum_trailer {
>  #else
>  #error	"Please fix <asm/byteorder.h>"
>  #endif
> -	u16 csum_start_offset;
> -	u16 csum_length;
> +	__be16 csum_start_offset;
> +	__be16 csum_length;
>  	__be16 csum_value;
>  } __aligned(1);
>  
> -- 
> 2.20.1
> 
