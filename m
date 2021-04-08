Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EBD358BB0
	for <lists+netdev@lfdr.de>; Thu,  8 Apr 2021 19:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232552AbhDHRtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 13:49:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232144AbhDHRtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Apr 2021 13:49:21 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 728FAC061760;
        Thu,  8 Apr 2021 10:49:09 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id z24-20020a1cf4180000b029012463a9027fso1666036wma.5;
        Thu, 08 Apr 2021 10:49:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=MyEL4PboLUhGdh3p4KXswTqL/U8W/AIK31/lE2Mqens=;
        b=XXaYuIJccE/mEVgv+nt7i2lcz81GXPpLqv4PsUTMvrusZOcnBFej08CXfmDI8JYg9F
         sjZf/Qv4QrCS9zGeFk0BM2z/YNaii6uex1EhZHNHdleZbSLJ12aHSxEcyILL4+M5J0+h
         KIZGZB9FHA4jsCr+S1/6ktXYIn0XdpluWqZT4tzjDiaccUTwmuczq3oCSbazbvf0rX//
         rwgdfMn7/RUYFXocFnVzpIF0Ph9FispqHJRDXD/soq+QB0noR3dkQKW2/okk+tz3Pgja
         5iFNmh7v/MaQD39iT3Y/jgVShrF0bVaYvkYS7qDyEEslI0OEE72c19/qfmaUI4TkQkWR
         FQuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=MyEL4PboLUhGdh3p4KXswTqL/U8W/AIK31/lE2Mqens=;
        b=MRtIaxsX5fzFtgh8X+9hGe51S5+bJFkb6bFunR5DXzhzBbxNFb+raf/7qH18fE+oUu
         ieKV+xR36Tu37vCIjEDY98mcLOOcZagIPJHtaDPUZ3ckIpRS19PDIh3NKXi+gnxrpVVG
         01CxMJxx1uMpElCWn4Pt64SVnch+CAX2YbuRF+NPdWLaDjBfw7wgneyTE0jFxgDWRlZk
         nQ6gD/dX7fyV43Zn2FoYekKKXrn63owMokURxmmXdJzeW+k5rXsvK8UJmwArscxVbh2P
         ETRWYlwsqGaAVw7mf5nKTvjka+mGWcyRCAiFXPEinUN7qP8zuLR3v9pRABhdbqN+JQ8E
         8NOA==
X-Gm-Message-State: AOAM530i2m/JPABYPPUfGlw/Lgme+kVnjaOCyiyfo0muznQenIOsOLyR
        dtzLkmQqjEYT8hCRjp6aOvxNwK7r2I2k5Q==
X-Google-Smtp-Source: ABdhPJxu0VisAr/nhnRnlxm0z/GgercnjZRDNaZOhvMvnNljSwPBTxRHxNS7ma0mLr12/dBgG4n7SQ==
X-Received: by 2002:a05:600c:4f89:: with SMTP id n9mr10147735wmq.133.1617904147917;
        Thu, 08 Apr 2021 10:49:07 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f38:4600:6dfe:cdb3:c4f9:2744? (p200300ea8f3846006dfecdb3c4f92744.dip0.t-ipconnect.de. [2003:ea:8f38:4600:6dfe:cdb3:c4f9:2744])
        by smtp.googlemail.com with ESMTPSA id v18sm50270232wru.85.2021.04.08.10.49.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 10:49:07 -0700 (PDT)
Subject: Re: [PATCH net v1] Revert "lan743x: trim all 4 bytes of the FCS; not
 just 2"
To:     Sven Van Asbroeck <thesven73@gmail.com>,
        Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>
Cc:     UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210408172353.21143-1-TheSven73@gmail.com>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <42bca8b7-863c-bc2d-7628-075ca18157af@gmail.com>
Date:   Thu, 8 Apr 2021 19:49:00 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
MIME-Version: 1.0
In-Reply-To: <20210408172353.21143-1-TheSven73@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 08.04.2021 19:23, Sven Van Asbroeck wrote:
> From: Sven Van Asbroeck <thesven73@gmail.com>
> 
> This reverts commit 3e21a10fdea3c2e4e4d1b72cb9d720256461af40.
> 
> The reverted patch completely breaks all network connectivity on the
> lan7430. tcpdump indicates missing bytes when receiving ping
> packets from an external host:
> 
> host$ ping $lan7430_ip
> lan7430$ tcpdump -v
> IP truncated-ip - 2 bytes missing! (tos 0x0, ttl 64, id 21715,
>     offset 0, flags [DF], proto ICMP (1), length 84)
> 
> Fixes: 3e21a10fdea3 ("lan743x: trim all 4 bytes of the FCS; not just 2")
> Signed-off-by: Sven Van Asbroeck <thesven73@gmail.com>
> ---
> 
> To: Bryan Whitehead <bryan.whitehead@microchip.com>
> To: "David S. Miller" <davem@davemloft.net>
> To: Jakub Kicinski <kuba@kernel.org>
> To: George McCollister <george.mccollister@gmail.com>
> Cc: UNGLinuxDriver@microchip.com
> Cc: netdev@vger.kernel.org
> Cc: linux-kernel@vger.kernel.org
> 
>  drivers/net/ethernet/microchip/lan743x_main.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
> index 1c3e204d727c..dbdfabff3b00 100644
> --- a/drivers/net/ethernet/microchip/lan743x_main.c
> +++ b/drivers/net/ethernet/microchip/lan743x_main.c
> @@ -2040,7 +2040,7 @@ lan743x_rx_trim_skb(struct sk_buff *skb, int frame_length)
>  		dev_kfree_skb_irq(skb);
>  		return NULL;
>  	}
> -	frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 4);
> +	frame_length = max_t(int, 0, frame_length - RX_HEAD_PADDING - 2);
>  	if (skb->len > frame_length) {
>  		skb->tail -= skb->len - frame_length;
>  		skb->len = frame_length;
> 

Can't we use frame_length - ETH_FCS_LEN direcctly here?
