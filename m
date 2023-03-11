Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDC46B5C9D
	for <lists+netdev@lfdr.de>; Sat, 11 Mar 2023 15:10:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229641AbjCKOJ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Mar 2023 09:09:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229956AbjCKOJx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Mar 2023 09:09:53 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9EDA02BB;
        Sat, 11 Mar 2023 06:09:52 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id j3so5172078wms.2;
        Sat, 11 Mar 2023 06:09:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678543791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gCBO1BOGc+gpZPFsXFe7s7eySat3RMIoHMBOKQxhii8=;
        b=Lmi5jlO/TN7FhmYnwjoz/ZHpojzzKxOHrgJnr1cAbEGOKGBuXro0tUNdmMD1EX3XPa
         4ZV4Ij6UNKvrmiCHza97eWmex9L5el0z2OXzO0/UUsdtX7MCU87Qd+Q1dNS0MsvpnTAR
         cstcY1aCKj7chxXZoZZI8/AIPIGq3k/CB4R1CMUMHc3WVRiLv5Qu/2UC6QWeAMyvSFJ9
         Z0iDXjbH7SMo95LK8jSu0E2PjkbFfCbNG6R6RvP2/eZd813HzzT3rNtYasKwhN7cP/kC
         VbWhxvNXZLr9U3/esnBfAe7CtH1Q4XXTcWQHB8nKJuuD9Huag7Ab61eWfv3u6CNxUnqx
         M8hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678543791;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gCBO1BOGc+gpZPFsXFe7s7eySat3RMIoHMBOKQxhii8=;
        b=phCQyYtEdqP2aG22XwcOyPEBvEAEImW8HaMqC7vRTjUBuWas4dnWJTN1jcwOFmA5+h
         ygjGRnhBjpSpDFNt7XhTw0tWqkx81iPiKHkzSFNslxxp09d8HEtHaPvujL9fF0a6OWvG
         RuCHT2BbAZtpxZjis3N2E6IFS9p1q2Q1FM6/c5nhun3zTFmhzyqdKK09XWxdvBbGvUwl
         PRdK7FiByzgi41x/FAIfr8ghI5M5O9ObiFLVFzJrIufgPRJjW5kRNIhO4Jk0Lhverpnu
         B9sU6K+YACGT8ZJwe6dtnusIz5AkuNqsiud5Lh0tOQ4FEnlQFhTKOTesDV2zTBpxCPlm
         4weA==
X-Gm-Message-State: AO0yUKUf6TrmHQtKFvD9+M/h7NiX19Z52omvZXXq2t4EuOBso168+QHL
        /f382oggx5tlrKlS6rc0Mw0=
X-Google-Smtp-Source: AK7set+TEixJO4w7KLuOsc6WmFAXS+b/OLRARH6dptmq1uxzMLeA0gLMuagwnrZbIZVSla3HzzIqYQ==
X-Received: by 2002:a05:600c:4751:b0:3ea:f0d6:5d36 with SMTP id w17-20020a05600c475100b003eaf0d65d36mr6153712wmo.29.1678543790898;
        Sat, 11 Mar 2023 06:09:50 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id d12-20020a05600c3acc00b003e2052bad94sm2906135wms.33.2023.03.11.06.09.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Mar 2023 06:09:50 -0800 (PST)
Date:   Sat, 11 Mar 2023 17:09:37 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Sumitra Sharma <sumitraartsy@gmail.com>
Cc:     outreachy@lists.linux.dev, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, coiby.xu@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        linux-staging@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: qlge: Remove parenthesis around single condition
Message-ID: <e4caf380-bac5-4df3-bb98-529f5703a410@kili.mountain>
References: <20230311140409.GA22831@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230311140409.GA22831@ubuntu>
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 11, 2023 at 06:04:09AM -0800, Sumitra Sharma wrote:
> At line #354 checkpatch.pl:
> CHECK: Unnecessary parentheses around 'i == 0x00000114'
> CHECK: Unnecessary parentheses around 'i == 0x00000118'
> CHECK: Unnecessary parenthesis around 'i == 0x00000140'
> CHECK: Unnecessary parentheses around 'i == 0x0000013c'
> 

Greg likes the extra parentheses so don't bother sending these sorts of
patches to staging.

> Signed-off-by: Sumitra Sharma <sumitraartsy@gmail.com>
> ---
>  drivers/staging/qlge/qlge_dbg.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/qlge/qlge_dbg.c b/drivers/staging/qlge/qlge_dbg.c
> index 66d28358342f..b190a2993033 100644
> --- a/drivers/staging/qlge/qlge_dbg.c
> +++ b/drivers/staging/qlge/qlge_dbg.c
> @@ -351,10 +351,10 @@ static int qlge_get_xgmac_regs(struct qlge_adapter *qdev, u32 *buf,
>  		/* We're reading 400 xgmac registers, but we filter out
>  		 * several locations that are non-responsive to reads.
>  		 */
> -		if ((i == 0x00000114) ||
> -		    (i == 0x00000118) ||
> -			(i == 0x0000013c) ||
> -			(i == 0x00000140) ||
> +		if (i == 0x00000114 ||
> +		    i == 0x00000118 ||
> +			i == 0x0000013c ||
> +			i == 0x00000140 ||

The weirder thing about this code is the indenting.  It should be:
[tab][tab][space][space][space][space](i ==.

regards,
dan carpenter

