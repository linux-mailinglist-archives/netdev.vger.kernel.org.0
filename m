Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BBA12A75B2
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 03:42:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388370AbgKECmq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Nov 2020 21:42:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732450AbgKECmq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Nov 2020 21:42:46 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19382C0613CF;
        Wed,  4 Nov 2020 18:42:46 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f38so229847pgm.2;
        Wed, 04 Nov 2020 18:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=2S1vFq4HZEtg7Kety/Ftf1BBZfbH4KJoly9r6aIwXR0=;
        b=BBgrUCQYGb8qktqi/bmzdZggaR8uA0X0X1nCXdyAOF1ZmXi7mNHPnzs0I1P6vx/pkO
         AYWuKABw2Jm5k76Ru3n32GoMMD1dgkrLFuhw5n4+RGEOpdxOTRNsjdaY99lXggdcg/VC
         TgRVuqDu7Tgs5Z8GIqGu/poGCv8vU5+GKT/rgkow4iAXqVh/ymla3zfhlr6/FpM6FImM
         45vLZ27bk4oW1KlKJRc2CyWmK9cd78SsJxb7qHbrtIviecxwIf5XMWJS2my4kUdI0CsR
         7cc4fNx3cGUJ1ngxRbmww6kpH0ds+0H3ZffzyOocYEDsJ6i+9VVPEW5VzlCRRzArrxTI
         ZnXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=2S1vFq4HZEtg7Kety/Ftf1BBZfbH4KJoly9r6aIwXR0=;
        b=JyKCnZ1ACtuKYBlTIixFDyQc6CZr7sllzNASZTUeEuexmtV8ysuZDcZfLC+K/xKvd4
         +xewi80Z2XDi2Mt/6/RD13up89OKjuRVGFzn4MVppEWhbf5IvJTfIGVxJGfPxDgUXwlK
         +IHkKZAJ92MflQAZQqB3n0idPqwVQUXjM1meOtWoYAAZwvFuNdQhkxYbqQPNmu4SpjrH
         xNrxp9eh93DglKESXbT2uYHR+bqKnYt04LopV83FPsesDp6IfrNVN85PhAiu9iqnJqSV
         euJUenUQkh03Ba4+VosKLi1GjIcJg/UC5S7ch0+UW6oeFNcvHhDdcQA2qxN804nwAGNG
         Rsjg==
X-Gm-Message-State: AOAM5316ZyxoCJXvKVNAEeGdtggBx92CNWnXIhaAggIUkNEWaUlrN+K2
        okXHzbwKd80a1h8wdMq+7CV5kV8kYEI=
X-Google-Smtp-Source: ABdhPJyMwSUn2Vd8ow9HdTR0rPiAkm2v9yCzDkdAwleWdoBcf9/eBzVLA+a3wVs705XkyibDV/sAdQ==
X-Received: by 2002:a63:4f02:: with SMTP id d2mr381428pgb.46.1604544165129;
        Wed, 04 Nov 2020 18:42:45 -0800 (PST)
Received: from [10.230.28.234] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y23sm64725pju.35.2020.11.04.18.42.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Nov 2020 18:42:44 -0800 (PST)
Subject: Re: [PATCH net-next v3 1/4] ethtool: Add 10base-T1L link mode entries
To:     Dan Murphy <dmurphy@ti.com>, davem@davemloft.net, andrew@lunn.ch,
        hkallweit1@gmail.com, robh@kernel.org
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20201030172950.12767-1-dmurphy@ti.com>
 <20201030172950.12767-2-dmurphy@ti.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <03eff57e-f584-6f76-7e31-f846fd8b367b@gmail.com>
Date:   Wed, 4 Nov 2020 18:42:42 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201030172950.12767-2-dmurphy@ti.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/30/2020 10:29 AM, Dan Murphy wrote:
> Add entries for the 10base-T1L full and half duplex supported modes.
> 
> $ ethtool eth0
>         Supported ports: [ TP ]
>         Supported link modes:   10baseT1L/Half 10baseT1L/Full
>         Supported pause frame use: Symmetric Receive-only
>         Supports auto-negotiation: Yes
>         Supported FEC modes: Not reported
>         Advertised link modes:  10baseT1L/Half 10baseT1L/Full
>         Advertised pause frame use: No
>         Advertised auto-negotiation: No
>         Advertised FEC modes: Not reported
>         Speed: 10Mb/s
>         Duplex: Full
>         Auto-negotiation: on
>         Port: MII
>         PHYAD: 1
>         Transceiver: external
>         Supports Wake-on: gs
>         Wake-on: d
>         SecureOn password: 00:00:00:00:00:00
>         Current message level: 0x00000000 (0)
> 
>         Link detected: yes
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
