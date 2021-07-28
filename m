Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E2793D92FE
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 18:16:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbhG1QQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 12:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230086AbhG1QO6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 12:14:58 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F8DAC061757;
        Wed, 28 Jul 2021 09:14:56 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ca5so5853517pjb.5;
        Wed, 28 Jul 2021 09:14:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XHepTzgLwPqN65zA0CSOOZE8+p0qfXTLJsI6vX6GqUc=;
        b=Qzw46NPHcQ03Zrp6maKJ20fbf0gQJDFibVuqn2kO0VIUCtMYrDLC/QJyV8Ba2QRq96
         rD/C0lyrwL741Lw/xmBGiDt1JL0O8F89cVUoMrHutfu+ua6FN2np25wvSci2F3/lhxTo
         HNkFXs2L204rfSW4f6DxCJdzDMouNlryVIFKOmAzLfFhkNCGrpzSwMZUsMkQT87lthiW
         5a9Gwyb5k533QBLGS9Yw54omPEEMwxYiaHZFpD2NMSy+9DhF8faFFSkNIrPQ6aaKeaLG
         6MGolIfirTDGteRiZooDfERU69ptJT8c2GmPSLVC43XbUpZKkaAy53OfVkUzbtx320oN
         ikuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XHepTzgLwPqN65zA0CSOOZE8+p0qfXTLJsI6vX6GqUc=;
        b=ccmrkqz6WLdO8ldSpHVY3oek2wMfP2kgJDWb7i4ejWU+8/BzuhcyY7xm3d89oIBt1I
         x7wTU//bSomD6ipOjbpVTALywhRgMkJWaloXkEsxGIAdZomPVI11tReNG48qqseRfJIu
         xvsLH6t2uFXjxbEfZBEeJe4+6vZHjF0Ka2MabyU3V2qyuRMc6tfPpYOnYqs/71A0EOl1
         e0yijMjUHVVzI75U8lZadXxMVWKy5fHA50rT1Z7DCFewpi8zzmeVqQ3O6pLRemSK1X/R
         9JwdbWW/dlDxYgbSHT/l1otFcvH+ceAyXfZwXwvNjMXKNIZ2q5EyhrzTK22xVD8iwz6P
         usRQ==
X-Gm-Message-State: AOAM5306WNQMHCP66YTnUad6xbgrRm+SPY53p0CvNIzrsy8Q823ZugWl
        PUsyOFH5mJEC925lxozV4/c=
X-Google-Smtp-Source: ABdhPJzvYuXRjdX0pq4KCIAjjqbLq43MJBGO9FZNEDJv5hyI1cNk5s+7D+9tBmZK0IfNSgCTdXHoOQ==
X-Received: by 2002:a17:90b:d8f:: with SMTP id bg15mr10129888pjb.152.1627488895725;
        Wed, 28 Jul 2021 09:14:55 -0700 (PDT)
Received: from [192.168.1.121] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id x30sm445779pfh.126.2021.07.28.09.14.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jul 2021 09:14:55 -0700 (PDT)
Subject: Re: [PATCH] bcm63xx_enet: remove needless variable definitions
To:     Tang Bin <tangbin@cmss.chinamobile.com>, davem@davemloft.net,
        kuba@kernel.org, bcm-kernel-feedback-list@broadcom.com
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Zhang Shengju <zhangshengju@cmss.chinamobile.com>
References: <20210728132456.2540-1-tangbin@cmss.chinamobile.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fe95911f-b701-f241-c5a2-af8042c9b238@gmail.com>
Date:   Wed, 28 Jul 2021 09:14:53 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728132456.2540-1-tangbin@cmss.chinamobile.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/28/2021 6:24 AM, Tang Bin wrote:
> In the function bcm_enetsw_probe(), 'ret' will be assigned by
> bcm_enet_change_mtu(), so 'ret = 0' make no sense.

You are not removing the variable definition or declaration, you are 
removing a redundant assignment which is a different thing. I do agree 
with the rationale however, so please fix up the subject and I will add 
my Acked-by to this patch. Thanks!
> 
> Signed-off-by: Zhang Shengju <zhangshengju@cmss.chinamobile.com>
> Signed-off-by: Tang Bin <tangbin@cmss.chinamobile.com>
> ---
>   drivers/net/ethernet/broadcom/bcm63xx_enet.c | 1 -
>   1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/net/ethernet/broadcom/bcm63xx_enet.c b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> index 916824cca..509e10013 100644
> --- a/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> +++ b/drivers/net/ethernet/broadcom/bcm63xx_enet.c
> @@ -2646,7 +2646,6 @@ static int bcm_enetsw_probe(struct platform_device *pdev)
>   	if (!res_mem || irq_rx < 0)
>   		return -ENODEV;
>   
> -	ret = 0;
>   	dev = alloc_etherdev(sizeof(*priv));
>   	if (!dev)
>   		return -ENOMEM;
> 

-- 
Florian
