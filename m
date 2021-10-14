Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58BA242D058
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 04:25:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbhJNC1i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 22:27:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNC1h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 22:27:37 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E03F4C061570;
        Wed, 13 Oct 2021 19:25:33 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id y207so6482784oia.11;
        Wed, 13 Oct 2021 19:25:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=XVDadRSdzCzv3kHe6SlSHXjGcrqIBTMqjlHx87FKbfU=;
        b=O9dBkWzeD8GcLXmRRzMSBqNnC/fmokt0pZfjtEqY3atLMUY6YVJMviYeKzAT/Hxsj9
         +tsXqAx/VEefImVwLYyUIDzn4Abub2scigOtq2Xeiq3RUmDoKVaKRUBC/QR3Tgfm2toq
         54/6NLRLj20axH1Xq9DKeBsDhRV3HRGeC+XmQFfYffp/DvopHvVeWQhBLDoLONsHG5xP
         qEw+cKQWFhesSEuWgLGOi74Fco5rYI+R1NDY0g2ZyrLoSikXSgfn/TSSwY5TJFCXHSlq
         ErpPcEwjraDGMiHvrQSrdRyfmB4iQ1R+Bu0sEn2gk3Sc3nanGHQv0V09zpPvFPEvI/lV
         1CVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=XVDadRSdzCzv3kHe6SlSHXjGcrqIBTMqjlHx87FKbfU=;
        b=44j22xnptoEZij/bByDmPar3foHAkJmaAQmFXvZ6ZuILAWXc/xEhwwm5bqv3DvZCEa
         O6RXOal18tPWMKiUm+DBvzoypRdSdRQSOQJeYN6iiaAfqyuWBqVMMAdwM6hFqiqVXZeX
         G7qbsm+anoiGmqHfizWC7GOJe3Uz1wgemArNhkFKtlAgsvleGMy7Cb8vLTg1Uo93OeEE
         xWdoBEKUXuy5TVAA0zuC5I13rT0VRPKuk33/r0ecZvlP6azA7MWsqIyq+yZSBHjO8vQ7
         DomQBVTDFs4eZEZvbN2Jtz7I4BPuyA6SPoHZemBOsnK+b3H1P/VkngqCfiGRT+cOSxu5
         uvLQ==
X-Gm-Message-State: AOAM533p9Um34FR1vQkGnjfo2c1g6sWSi2x3Ntg5ELqJDurDcJwAiTMu
        DL3i08o/2VLpFfwSV0Bu6kE=
X-Google-Smtp-Source: ABdhPJzQY/wDx2FMp3v5hOgLqwIqZVLDQ1UqldL81XvZUekipihp6y0veYIX2a6TP6bU5dRk0NbCzg==
X-Received: by 2002:a05:6808:2310:: with SMTP id bn16mr2049872oib.159.1634178333173;
        Wed, 13 Oct 2021 19:25:33 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:c875:f7ef:73a9:7098? ([2600:1700:dfe0:49f0:c875:f7ef:73a9:7098])
        by smtp.gmail.com with ESMTPSA id s206sm319237oia.33.2021.10.13.19.25.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 19:25:32 -0700 (PDT)
Message-ID: <d029f2c3-920b-e052-a097-3837b03644f6@gmail.com>
Date:   Wed, 13 Oct 2021 19:25:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 net-next 5/6] net: dsa: realtek-smi: add rtl8365mb
 subdriver for RTL8365MB-VC
Content-Language: en-US
To:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alvin@pqrs.dk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Cc:     =?UTF-8?Q?Alvin_=c5=a0ipraga?= <alsi@bang-olufsen.dk>,
        Michael Rasmussen <mir@bang-olufsen.dk>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211013145040.886956-1-alvin@pqrs.dk>
 <20211013145040.886956-6-alvin@pqrs.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211013145040.886956-6-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2021 7:50 AM, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> This patch adds a realtek-smi subdriver for the RTL8365MB-VC 4+1 port
> 10/100/1000M switch controller. The driver has been developed based on a
> GPL-licensed OS-agnostic Realtek vendor driver known as rtl8367c found
> in the OpenWrt source tree.
> 
> Despite the name, the RTL8365MB-VC has an entirely different register
> layout to the already-supported RTL8366RB ASIC. Notwithstanding this,
> the structure of the rtl8365mb subdriver is based on the rtl8366rb
> subdriver and makes use of the rtl8366 helper library for setup of the
> SMI interface and handling of MIB counters. Like the 'rb, it establishes
> its own irqchip to handle cascaded PHY link status interrupts.
> 
> The RTL8365MB-VC switch is capable of offloading a large number of
> features from the software, but this patch introduces only the most
> basic DSA driver functionality. The ports always function as standalone
> ports, with bridging handled in software.
> 
> One more thing. Realtek's nomenclature for switches makes it hard to
> know exactly what other ASICs might be supported by this driver. The
> vendor driver goes by the name rtl8367c, but as far as I can tell, no
> chip actually exists under this name. As such, the subdriver is named
> rtl8365mb to emphasize the potentially limited support. But it is clear
> from the vendor sources that a number of other more advanced switches
> share a similar register layout, and further support should not be too
> hard to add given access to the relevant hardware. With this in mind,
> the subdriver has been written with as few assumptions about the
> particular chip as is reasonable. But the RTL8365MB-VC is the only
> hardware I have available, so some further work is surely needed.
> 
> Co-developed-by: Michael Rasmussen <mir@bang-olufsen.dk>
> Signed-off-by: Michael Rasmussen <mir@bang-olufsen.dk>
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>

Nice work! If you happen to spin a v3, maybe consider moving the IRQ 
chip setup to an earlier point in the driver probe since it is a path 
that can return -EPROBE_DEFER?
-- 
Florian
