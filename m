Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6558406FE4
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:43:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230146AbhIJQon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:44:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229466AbhIJQol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Sep 2021 12:44:41 -0400
Received: from mail-lf1-x132.google.com (mail-lf1-x132.google.com [IPv6:2a00:1450:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED78C061574;
        Fri, 10 Sep 2021 09:43:30 -0700 (PDT)
Received: by mail-lf1-x132.google.com with SMTP id t19so5208117lfe.13;
        Fri, 10 Sep 2021 09:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=CpppGfWdA8BK4TEonYP/3MMVluD0lccSfMd5MNwKeZI=;
        b=TeOEMXQv69sxAJJRBo9B4lk3fpM/E0/Egxfjkx2Whvw1euWeJGEKX/A4YT9I361Tg2
         xfx600hqLxUjGOIChRARytJCOEO6ofvlQZajymlSPvItFy3U0XczbGn2Brda8Dkhbhyq
         Lhw/5FVJXFBXM+yrMeh4stgVVSkaJxm8B4EfkmWxtnutQszIUpdlCY5bWlOa7aGP0n8v
         ehlVF96bIjqCU2F6TffATDo15AqEBg6cibUeQk8AK4vfHZGO08vrhNtoRsGG/kYZaQ/J
         SCe6RBjjYYJPiZ8W9mXymIQZpiObjeSLqbhOEZfBbQcFrMRGf/bkNGs6lIsW/FmETVJ0
         K84A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=CpppGfWdA8BK4TEonYP/3MMVluD0lccSfMd5MNwKeZI=;
        b=aVilj4OSuseeKujlaIcAL0hSh3pYpZDpC9mY6KX+HBG+aY0q/P+J30B3Lesl4UZ9QS
         K8lu8OJMmqHRsN+3H57v7T3IdbQlyGYCS2jwI/3RR7Z3R5u1efR4Wdfx5csepNKW27iu
         LPZMoi3ubCCE6pvgx4hu8J3gAQL02ouoW49usmg6Gz8LJ9szZb8HfujuN+zqPta5O55O
         UlZKlbjWP1Q+hzzydDnofRklHknXmv0EwFD2wwOUdNDQv/1j4ACsNoMuBWM248JR8+oW
         lSL+aogN0Fkt++LhW5TFnWl+UJY6DQIAymB8N/S1rDAkKNUrQYDmgtMYBrK4aVRAOos5
         BJyg==
X-Gm-Message-State: AOAM531xwtMr2QQwM6pd6KxfN2PPCI/Ge26KStl0DFOb2JzwOmTsJxOP
        4OKVzui2jyh6jWlshHOmqUQ=
X-Google-Smtp-Source: ABdhPJz7K6g1w0gHsQO3ayMRireXIkr5lTLQy7Usi5dYuUKhB2c/o2cUiEPAw4W0lHFRbegttgMqhQ==
X-Received: by 2002:a05:6512:4005:: with SMTP id br5mr4592372lfb.560.1631292208860;
        Fri, 10 Sep 2021 09:43:28 -0700 (PDT)
Received: from kari-VirtualBox ([31.132.12.44])
        by smtp.gmail.com with ESMTPSA id f20sm666074ljc.81.2021.09.10.09.43.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Sep 2021 09:43:28 -0700 (PDT)
Date:   Fri, 10 Sep 2021 19:43:26 +0300
From:   Kari Argillander <kari.argillander@gmail.com>
To:     Jerome Pouiller <Jerome.Pouiller@silabs.com>
Cc:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH 13/31] staging: wfx: update with API 3.8
Message-ID: <20210910164326.ivhlbnaq6526wcso@kari-VirtualBox>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
 <20210910160504.1794332-14-Jerome.Pouiller@silabs.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210910160504.1794332-14-Jerome.Pouiller@silabs.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 10, 2021 at 06:04:46PM +0200, Jerome Pouiller wrote:
> From: Jérôme Pouiller <jerome.pouiller@silabs.com>
> 
> API 3.8 introduces new statistic counters. These changes are backward
> compatible.

It will be obvious to some what API 3.8 is. But at least me can rise my
hand and admit that I do not. Probably wfx api but ig there is any
public info but it here. If there is not just say Wfx api 3.8.

> 
> Signed-off-by: Jérôme Pouiller <jerome.pouiller@silabs.com>
> ---
>  drivers/staging/wfx/debug.c       | 3 +++
>  drivers/staging/wfx/hif_api_mib.h | 5 ++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wfx/debug.c b/drivers/staging/wfx/debug.c
> index eedada78c25f..e67ca0d818ba 100644
> --- a/drivers/staging/wfx/debug.c
> +++ b/drivers/staging/wfx/debug.c
> @@ -109,6 +109,9 @@ static int wfx_counters_show(struct seq_file *seq, void *v)
>  
>  	PUT_COUNTER(rx_beacon);
>  	PUT_COUNTER(miss_beacon);
> +	PUT_COUNTER(rx_dtim);
> +	PUT_COUNTER(rx_dtim_aid0_clr);
> +	PUT_COUNTER(rx_dtim_aid0_set);
>  
>  #undef PUT_COUNTER
>  
> diff --git a/drivers/staging/wfx/hif_api_mib.h b/drivers/staging/wfx/hif_api_mib.h
> index ace924720ce6..b2dc47c314cc 100644
> --- a/drivers/staging/wfx/hif_api_mib.h
> +++ b/drivers/staging/wfx/hif_api_mib.h
> @@ -158,7 +158,10 @@ struct hif_mib_extended_count_table {
>  	__le32 count_rx_bipmic_errors;
>  	__le32 count_rx_beacon;
>  	__le32 count_miss_beacon;
> -	__le32 reserved[15];
> +	__le32 count_rx_dtim;
> +	__le32 count_rx_dtim_aid0_clr;
> +	__le32 count_rx_dtim_aid0_set;
> +	__le32 reserved[12];
>  } __packed;
>  
>  struct hif_mib_count_table {
> -- 
> 2.33.0
> 
