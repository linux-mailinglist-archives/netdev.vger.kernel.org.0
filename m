Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 725E8E592D
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 10:09:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfJZIJe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 04:09:34 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:36851 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725996AbfJZIJe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Oct 2019 04:09:34 -0400
Received: by mail-wm1-f67.google.com with SMTP id c22so4263157wmd.1
        for <netdev@vger.kernel.org>; Sat, 26 Oct 2019 01:09:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=M1jsTJqQrqJpNIMjJF4dpzKdXTPDMuQsKyFuLmv9Zrw=;
        b=wDf/2Qxklu53OHTOjb7Q3ytidPVHX1uOZPtbA0h28ECfFyFoOlAoq9pBZintkYmOUj
         9zJjyT+/JZdgxgv0bVIfwm7Yft9eaeWl0LKcEleW27Kc3i+I9Xhq6NrKH3CbnNb/Hpz2
         Roaxz9QHwUwY0AqpGpwiwPH5k1fpoE5LkUBHKLTab1SbPwTrnk3FyAlYn+Wq8moPJq+w
         PbK7rhQOZJdfo2mausMR0jrEVTDbESFLnqnbG/ZTINvej2i+e4LBMaB/eco9js4Y9+4a
         ZXIErkvnBD2XTPilFCgLysdV8z69PY2t43Lrp8V5ZGvmUbGA5GROm+HhRYCMPGoZLRp8
         vcxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=M1jsTJqQrqJpNIMjJF4dpzKdXTPDMuQsKyFuLmv9Zrw=;
        b=Wbc/Uo250sAS3PINgGRg4y5QtQEeVnfjyIu3sBfz9T9iWFcgEd1Fzzb6U3/ac6fGFs
         +3qPDGFmIweY4zSRqIWLN0drtDqIhObkGx47JOwZEyD7wIe81K6jxRUY8JCayjApn3Eu
         MlVLLA5in4lJWzTIwuw0zd2YCX9ovxRk1wI27mF45qTMKtea9BjeujLiKPsboT7vK20I
         o5JNbh8x1co+KOyXVUCwTl3sCTTK++rCaiGv8pxv2+52gkJTphaZfJwUWC2Qt3tKhUaP
         nBiMehjQp51bFq2K42qb/iIUjLVDsMOf224v+dPisd+bKhheenh30Jv2DHZXmpl2I6Dk
         Dp+g==
X-Gm-Message-State: APjAAAXUnf5SYJhb+ybkBl5R5NtTyvV5ePFojvjMYC7L7FjmNOJ5psjm
        ZvKnZjP90lk/gUkD5rDudYQZmQ==
X-Google-Smtp-Source: APXvYqyp/6rBvR7ThsZ6BJKtiqBJ+BtFnIVT3DF3ajYAXZJZ42T/DzY07kVVekQBw2JeUcgki+BxJA==
X-Received: by 2002:a1c:814b:: with SMTP id c72mr7284441wmd.167.1572077371918;
        Sat, 26 Oct 2019 01:09:31 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id r15sm4579844wro.20.2019.10.26.01.09.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 26 Oct 2019 01:09:31 -0700 (PDT)
Date:   Sat, 26 Oct 2019 10:09:30 +0200
From:   Simon Horman <simon.horman@netronome.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     epomozov@marvell.com, igor.russkikh@aquantia.com,
        davem@davemloft.net, dmitry.bezrukov@aquantia.com,
        sergey.samoilenko@aquantia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: aquantia: Fix build error wihtout
 CONFIG_PTP_1588_CLOCK
Message-ID: <20191026080929.GD31244@netronome.com>
References: <20191025133726.31796-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191025133726.31796-1-yuehaibing@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 25, 2019 at 09:37:26PM +0800, YueHaibing wrote:
> If PTP_1588_CLOCK is n, building fails:
> 
> drivers/net/ethernet/aquantia/atlantic/aq_ptp.c: In function aq_ptp_adjfine:
> drivers/net/ethernet/aquantia/atlantic/aq_ptp.c:279:11:
>  error: implicit declaration of function scaled_ppm_to_ppb [-Werror=implicit-function-declaration]
>            scaled_ppm_to_ppb(scaled_ppm));
> 
> Just cp scaled_ppm_to_ppb() from ptp_clock.c to fix this.
> 
> Fixes: 910479a9f793 ("net: aquantia: add basic ptp_clock callbacks")
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>

Hi YueHaibing,

thanks for your patch.

What is the motivation for not using the existing copy of this function?

> ---
>  drivers/net/ethernet/aquantia/atlantic/aq_ptp.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
> index 3ec0841..80c001d 100644
> --- a/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
> +++ b/drivers/net/ethernet/aquantia/atlantic/aq_ptp.c
> @@ -262,6 +262,26 @@ static void aq_ptp_tx_timeout_check(struct aq_ptp_s *aq_ptp)
>  	}
>  }
>  
> +static s32 scaled_ppm_to_ppb(long ppm)
> +{
> +	/*
> +	 * The 'freq' field in the 'struct timex' is in parts per
> +	 * million, but with a 16 bit binary fractional field.
> +	 *
> +	 * We want to calculate
> +	 *
> +	 *    ppb = scaled_ppm * 1000 / 2^16
> +	 *
> +	 * which simplifies to
> +	 *
> +	 *    ppb = scaled_ppm * 125 / 2^13
> +	 */
> +	s64 ppb = 1 + ppm;
> +	ppb *= 125;
> +	ppb >>= 13;
> +	return (s32) ppb;
> +}
> +
>  /* aq_ptp_adjfine
>   * @ptp: the ptp clock structure
>   * @ppb: parts per billion adjustment from base
> -- 
> 2.7.4
> 
> 
