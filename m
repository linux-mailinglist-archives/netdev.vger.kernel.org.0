Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1460C1E310D
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 23:19:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403746AbgEZVTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 17:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391346AbgEZVTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 17:19:32 -0400
Received: from mail-pj1-x1042.google.com (mail-pj1-x1042.google.com [IPv6:2607:f8b0:4864:20::1042])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208A0C061A0F;
        Tue, 26 May 2020 14:19:32 -0700 (PDT)
Received: by mail-pj1-x1042.google.com with SMTP id ci23so371735pjb.5;
        Tue, 26 May 2020 14:19:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=tflds9lYgkRTCGEIVSNFrqCgnj1THo5AXvPo++hjhfA=;
        b=rQOm8i+hgoURevvJAnsP3HJpL2bZT1RPQDmVOt6RR+Ae9FOq5gLMbqGIO5HeftAwZq
         rzL5TtlLLAio00xaxDM7D49+gPU3V4Ph9ifY4nueRv4ZR0aRHJz2DjZ/zxcfv6gr5jzw
         LSyypBkAN62gR/uPSOFg5BBFK2xUW3oy8AYG5bBo7rq9ZiSRT8VQAOPUVcavhsuTYmEU
         8IgBFgato6UnpGQ4m8OjkWiAyNFKeIUubcm24QXDmB5YHYR0TuzBNWXuW8Ey5SAAyhh7
         iqYJUjnxu1LNOYOC6RW5R5XT9eNDe1IPP68IKkvIOEJ+LNUsYyIsuk2aov02siTQGSTB
         2YeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=tflds9lYgkRTCGEIVSNFrqCgnj1THo5AXvPo++hjhfA=;
        b=k7Od1v13K2u25GBFbXTdxNvbDLe3u1Wrihy5catVJyOcJNeiIuA/OfR1mbEQHfwrx9
         05/XfTZ9Ufja3UXvdbKaoVMHvALL+mSaYVjP6Zz9cydL4jfuh22FEKHI02vWVBzdze6M
         BB1fkNNHhoRAahkl5xOmlg1K9pm8+r6cEyiqyiAW5pA1GAM2/4wa1o9X7mZx1HxJxFUb
         QpH0+eeleKWyfFrDkhWysIU11wCNabxHuT8eYPsVNxjUoMnMpa5jZnQ/MuAu9vL3rZ3r
         gKZj99vxFvLfn/BklOz02SRCyOV6MOp2Oo3OWdRFis5ZqLJOLF1ECzwk6VqvRlwIMwnT
         W4Fg==
X-Gm-Message-State: AOAM532wWvz9gxZmkIAi9crAHLcH2pvLX7/scvAKk0T3HUWtz7gSAe5b
        HHHeJw6a6VwSNZnN6mOXeYM=
X-Google-Smtp-Source: ABdhPJyDOzhVg8VKPNMZbo3CQexzCd4MrRif1RwOU6HQSDgR7clJRviqqf81yMsX5sCjMf2zFy0TxQ==
X-Received: by 2002:a17:902:9e0c:: with SMTP id d12mr2979707plq.29.1590527971195;
        Tue, 26 May 2020 14:19:31 -0700 (PDT)
Received: from [10.230.188.43] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id hb3sm361891pjb.57.2020.05.26.14.19.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 14:19:30 -0700 (PDT)
Subject: Re: [PATCH net-next 2/4] net: phy: mscc-miim: remove redundant
 timeout check
To:     Antoine Tenart <antoine.tenart@bootlin.com>, davem@davemloft.net,
        andrew@lunn.ch, hkallweit1@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        alexandre.belloni@bootlin.com, thomas.petazzoni@bootlin.com,
        allan.nielsen@microchip.com
References: <20200526162256.466885-1-antoine.tenart@bootlin.com>
 <20200526162256.466885-3-antoine.tenart@bootlin.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fefda2fe-4841-8146-7ecf-e8b3b29fbd1e@gmail.com>
Date:   Tue, 26 May 2020 14:19:28 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200526162256.466885-3-antoine.tenart@bootlin.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/26/2020 9:22 AM, Antoine Tenart wrote:
> readl_poll_timeout already returns -ETIMEDOUT if the condition isn't
> satisfied, there's no need to check again the condition after calling
> it. Remove the redundant timeout check.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@bootlin.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
