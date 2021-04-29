Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 399E436F2E4
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 01:32:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbhD2Xcz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 19:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229519AbhD2Xcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 19:32:55 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CDCEC06138B;
        Thu, 29 Apr 2021 16:32:08 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id y22-20020a17090a8b16b0290150ae1a6d2bso795377pjn.0;
        Thu, 29 Apr 2021 16:32:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=eTT0JjyHTNK+HUwEt1vOt0ko87TGIxLuDLOETsVrMNQ=;
        b=NL22mth4obNH9bwhyoRdPTGW5NDTt137bEw6yVVrYx9o5GEqU/tX6+bP1iv0mAo0/0
         +lO/8Ok3gD48/bcyyBQFenVT7d85a/IDaoGQxjK6UbO2CvX7KujRjv9x/qbzjR+rsl5U
         8xVENRKUEPwMkE5OaITnGU8/mesD1sS1xbntJo5XKVGQSaodiwIxnbY9NEAafYv0rmG3
         B6r5KsZmqBSX82/9kIAch/rFVugWbjKVYX/0BhHWAmzeaMWnZvcIxPJmmaY8FrgkiJzC
         aRtTSv2Vk7M468JbEXeRLRXEcPKKnVfrAEHaO4xuXmuem56bGqAtE38xqgEr5hugqPUM
         dTwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=eTT0JjyHTNK+HUwEt1vOt0ko87TGIxLuDLOETsVrMNQ=;
        b=qzkpQpVSp08PhuJ7wuW3b25i03+f46HzIuRnjzjPx5YYdCA4iN5bVKOrdW4H0Cbcb7
         VTldWVkFDPsPqhaSX6tiozBNniHYQEx4gCUnq5qnlQ8U3dOilcN4mE1asjWQmPmTw4Zb
         jjCC9ctPthHcglhDrwMYhZpkOTqbyk2wv03z0KepdKvA7xEUBKAOVGh6wBsVtscNX//O
         WRVImKyJ5o79P4S8VjVJvzCx7TG0uWlVp9GAWtc38+uVLvU9bZ7UAhH60dVOmzBjFvYk
         yzEGo63uVrkNbv495FE6yiMrNAN/aX1kcekyCprVIt/pqAzqoXKqpE/87Q7vtuQFo2W+
         kUcg==
X-Gm-Message-State: AOAM531lmsp88G54sg6TCTEob1LkjZ9A2vUwxFs7FPV2ECVQdqAPmY0x
        2CdufGB1lB2SeKHWSNyR4Es=
X-Google-Smtp-Source: ABdhPJw6edmhEYsj/llH0BJ5N2LSx83oGegeqtY4EIlysM8uGKAKrfXAv1fBajAw5w1BLje8hcyPuQ==
X-Received: by 2002:a17:90a:a4c7:: with SMTP id l7mr2284100pjw.147.1619739127543;
        Thu, 29 Apr 2021 16:32:07 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id lb2sm8041195pjb.53.2021.04.29.16.32.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Apr 2021 16:32:07 -0700 (PDT)
Subject: Re: [PATCH net-next 3/4] dt-bindings: net: dsa: add MT7530 interrupt
 controller binding
To:     DENG Qingfang <dqfext@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Sean Wang <sean.wang@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sergio Paracuellos <sergio.paracuellos@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-staging@lists.linux.dev, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     Weijie Gao <weijie.gao@mediatek.com>,
        Chuanhong Guo <gch981213@gmail.com>,
        =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marc Zyngier <maz@kernel.org>
References: <20210429062130.29403-1-dqfext@gmail.com>
 <20210429062130.29403-4-dqfext@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <46c30868-fc01-2022-f6ed-c61432d5760f@gmail.com>
Date:   Thu, 29 Apr 2021 16:31:59 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210429062130.29403-4-dqfext@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 4/28/2021 11:21 PM, DENG Qingfang wrote:
> Add device tree binding to support MT7530 interrupt controller.
> 
> Signed-off-by: DENG Qingfang <dqfext@gmail.com>
> ---
> RFC v4 -> PATCH v1:
> - No changes.
> 
>  Documentation/devicetree/bindings/net/dsa/mt7530.txt | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/mt7530.txt b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> index de04626a8e9d..892b1570c496 100644
> --- a/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> +++ b/Documentation/devicetree/bindings/net/dsa/mt7530.txt
> @@ -81,6 +81,12 @@ Optional properties:
>  - gpio-controller: Boolean; if defined, MT7530's LED controller will run on
>  	GPIO mode.
>  - #gpio-cells: Must be 2 if gpio-controller is defined.
> +- interrupt-controller: Boolean; Enables the internal interrupt controller.
> +
> +If interrupt-controller is defined, the following property is required.

s/is/are/

It would be good to follow up with a converstion of this binding file to
YAML eventually.

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
