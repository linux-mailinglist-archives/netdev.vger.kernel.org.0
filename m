Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED94E42D042
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 04:17:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229949AbhJNCTZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Oct 2021 22:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbhJNCTY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Oct 2021 22:19:24 -0400
Received: from mail-qt1-x82e.google.com (mail-qt1-x82e.google.com [IPv6:2607:f8b0:4864:20::82e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4B71C061570;
        Wed, 13 Oct 2021 19:17:20 -0700 (PDT)
Received: by mail-qt1-x82e.google.com with SMTP id t16so4527474qto.5;
        Wed, 13 Oct 2021 19:17:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xYsQ8sB/qKBKDNBS6QDOxoGAScTd8v2OU7Cyj2b6JzE=;
        b=dYPiXmjPj2pvB8G5qKs+7zAHyYOeXYc7E0LOZ5f460icm2MkKEWKcnu/BwPr91yw8O
         cjQjhCXQuJ9TQtDGSGODEapUVVhwtD7T2LbMnEUarwPA9Q8pzoVmrokipyBpqLJJZQxa
         gF5P2pUmlrkwpIJ94lhG+Q5nz2U+/vfUREyOjEM4SbCzxQZfwaIRmnvbHzfei1cgT16U
         VcoGoc+rg0y7IOa0KPUi9QFH7gJj1hrBzi4chyqZArofMd7ZYIXXSFaA0kQ1m1nXkZXR
         TkLS/kef/sW/lgQnx+U6lT3uJpOMJerGbdGpNj/u+TxPTdVhG1fSYXuuk2TjdSZ73OFD
         GpcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xYsQ8sB/qKBKDNBS6QDOxoGAScTd8v2OU7Cyj2b6JzE=;
        b=VlrtAygmzyileKrZZlt8xHfCG2iNdW1ecEVL9AfCSgchvUoakb7Dux9Bfb4CXWOc2O
         IArtSiw1TPsVvuaeCTG+uyB6lhnG9OHiQ3NH2rkt10hY+Pnk3exiRlQoePB+2JZLS1GH
         6osbMXBCkX1HDhzzhN89tQUrG/Tv47lW4ZQbFVZm0PWtLAbVHiPoqlyGaBbC3hk6vXYc
         C5HiltwFggaQcJgY8TSh2NLc2iOX0KIksUzsuNWBEXSbcVCxjDtdTz0paPa/c6EpTOWt
         nGJi+RMoBOSsbI+Wwq2ymbltgMuljZ6rWxH2xajDSvolXW2xDqQCINl7J4ySv4Idpa08
         0wHg==
X-Gm-Message-State: AOAM533VbPurOSEkDapvSDWNmyrVfTyt4wAdP+/5OFG8PUe05N07zDXv
        uIm1ePdw00bK2x6miZHEnlsxkgPTJS8u2g==
X-Google-Smtp-Source: ABdhPJza20QPScVCtPB6D881Ls1+eaOPc062gw9Kj6Ve9zLg/NTKY7CnKh6phfO3880NaI2lJOL6yA==
X-Received: by 2002:a05:622a:1c8:: with SMTP id t8mr3481985qtw.72.1634177839467;
        Wed, 13 Oct 2021 19:17:19 -0700 (PDT)
Received: from ?IPV6:2600:1700:dfe0:49f0:c875:f7ef:73a9:7098? ([2600:1700:dfe0:49f0:c875:f7ef:73a9:7098])
        by smtp.gmail.com with ESMTPSA id t9sm1019763qtx.47.2021.10.13.19.17.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 13 Oct 2021 19:17:18 -0700 (PDT)
Message-ID: <f4c23285-1cde-183b-87fa-3b5d5a015276@gmail.com>
Date:   Wed, 13 Oct 2021 19:17:16 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH v2 net-next 1/6] ether: add EtherType for proprietary
 Realtek protocols
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
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211013145040.886956-1-alvin@pqrs.dk>
 <20211013145040.886956-2-alvin@pqrs.dk>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20211013145040.886956-2-alvin@pqrs.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 10/13/2021 7:50 AM, Alvin Šipraga wrote:
> From: Alvin Šipraga <alsi@bang-olufsen.dk>
> 
> Add a new EtherType ETH_P_REALTEK to the if_ether.h uapi header. The
> EtherType 0x8899 is used in a number of different protocols from Realtek
> Semiconductor Corp [1], so no general assumptions should be made when
> trying to decode such packets. Observed protocols include:
> 
>    0x1 - Realtek Remote Control protocol [2]
>    0x2 - Echo protocol [2]
>    0x3 - Loop detection protocol [2]
>    0x4 - RTL8365MB 4- and 8-byte switch CPU tag protocols [3]
>    0x9 - RTL8306 switch CPU tag protocol [4]
>    0xA - RTL8366RB switch CPU tag protocol [4]
> 
> [1] https://lore.kernel.org/netdev/CACRpkdYQthFgjwVzHyK3DeYUOdcYyWmdjDPG=Rf9B3VrJ12Rzg@mail.gmail.com/
> [2] https://www.wireshark.org/lists/ethereal-dev/200409/msg00090.html
> [3] https://lore.kernel.org/netdev/20210822193145.1312668-4-alvin@pqrs.dk/
> [4] https://lore.kernel.org/netdev/20200708122537.1341307-2-linus.walleij@linaro.org/
> 
> Suggested-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
