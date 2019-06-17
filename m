Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C2A764950A
	for <lists+netdev@lfdr.de>; Tue, 18 Jun 2019 00:19:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728699AbfFQWTS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Jun 2019 18:19:18 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:47069 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfFQWTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Jun 2019 18:19:18 -0400
Received: by mail-wr1-f68.google.com with SMTP id n4so11670785wrw.13;
        Mon, 17 Jun 2019 15:19:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dg0quVLxabap42buoJF/GKpH+xHHpW70TEb5weAZWjY=;
        b=Z//uftwzMgdsZL7DPHh7JLxPXda6KnS7PQYhcEKjcbkvwLPM+n5YyXgDkWtJjBVHCU
         JEjdb2JTqA42esRjij5qQwgmUJ6BgGYkI/nvUl+OoQuKx5rbjF8MDoicu0BIIeyT0Ick
         DuRcy5eTVgBxevsnOEAX5mqhhpkhza/2irzJjI+wD/Y2WdUEBk7oJyUYl0xZ84Yluj0U
         AcIILi8e/GZkQG6gXxBw+6fJn0Pj7+K/X4TTmmZVdd90L8ewQquH6j2EU4Mf8TC0dNvH
         6+Usw0FWl02D2HIDLSkZqv6rHD6csxTafHVsp3uW1L8wqghIgCgTlNhyu7OorzTzJs6R
         J9lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Dg0quVLxabap42buoJF/GKpH+xHHpW70TEb5weAZWjY=;
        b=hBwtTC3Gi4H2mCuZXFWHIlq37fS09HDl80Yl+jvEmv8ybcfcL1B1PtbqqHTuL1iLkf
         YAAeLQp/IBpzI4fXAMLP1GsP3NEOxoxOPK0F0NXEqryGICsgKqNA0h/BwoJ+lu8gH0ur
         fVIUN9TAizJwLDqMdQBX3S5DoUoayQwfZ4E5XXdAkoWb+861pU9MHFqh2FTkFtwRo2OH
         EaLlx5xaqzcwjCTDZA9wwjDhECbqvTnmVY35WZ5ERf7Pza3uo8T4cHvj81+2qEBtiSDJ
         EJlC7MERQ5B9yuKU0dYKAIItMZciUvoBEZAQlosD1EK349m+HmLhzLH532YOuTdow2qw
         BFRg==
X-Gm-Message-State: APjAAAVmPgPQcDTO4/mZtZAzn+1PuFLca1mBH/V34EalXQfQWxezd9qE
        Xn1oXDkmtCsuXme6gQDIL9PhdqJm
X-Google-Smtp-Source: APXvYqwbL9AnWzGcWqPGDp0f5v9TIepdPMwOT2DSE4gan1wqbL4jhG2bAj5PIybtcfbCMYzjYI6NTA==
X-Received: by 2002:a5d:518c:: with SMTP id k12mr79312720wrv.322.1560809954560;
        Mon, 17 Jun 2019 15:19:14 -0700 (PDT)
Received: from [10.67.49.123] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a84sm971161wmf.29.2019.06.17.15.19.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 17 Jun 2019 15:19:14 -0700 (PDT)
Subject: Re: [PATCH net-next 0/2] net: mediatek: Add MT7621 TRGMII mode
 support
To:     =?UTF-8?Q?Ren=c3=a9_van_Dorst?= <opensource@vdorst.com>,
        Andrew Lunn <andrew@lunn.ch>
Cc:     Sean Wang <sean.wang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        netdev@vger.kernel.org, john@phrozen.org,
        linux-mediatek@lists.infradead.org, linux-mips@vger.kernel.org
References: <20190616182010.18778-1-opensource@vdorst.com>
 <20190617140223.GC25211@lunn.ch>
 <20190617213312.Horde.fcb9-g80Zzfd-IMC8EQy50h@www.vdorst.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 M5kY0ACeNhCZJvZ5g4C2Lc9fcTHu8jxmEkI=
Message-ID: <8d115e83-f249-6f51-6bf3-a9af6a5535de@gmail.com>
Date:   Mon, 17 Jun 2019 15:19:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
In-Reply-To: <20190617213312.Horde.fcb9-g80Zzfd-IMC8EQy50h@www.vdorst.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/17/19 2:33 PM, René van Dorst wrote:
> Quoting Andrew Lunn <andrew@lunn.ch>:
> 
>> On Sun, Jun 16, 2019 at 08:20:08PM +0200, René van Dorst wrote:
>>> Like many other mediatek SOCs, the MT7621 SOC and the internal MT7530
>>> switch both
>>> supports TRGMII mode. MT7621 TRGMII speed is 1200MBit.
>>
>> Hi René
>>
> 
> Hi Andrew,
> 
>> Is TRGMII used only between the SoC and the Switch? Or does external
>> ports of the switch also support 1200Mbit/s? If external ports support
>> this, what does ethtool show for Speed?
> 
> Only the first GMAC of the SOC and port 6 of the switch supports this mode.
> The switch can be internal in the SOC but also a separate chip.
> 
> PHYLINK and ethertool reports the link as 1Gbit.
> The link is fixed-link with speed = 1000.
> 
> dmesg output with unposted PHYLINK patches:
> [    5.236763] mt7530 mdio-bus:1f: configuring for fixed/trgmii link mode
> [    5.249813] mt7530 mdio-bus:1f: phylink_mac_config:
> mode=fixed/trgmii/1Gbps/Full adv=00,00000000,00000220 pause=12 link=1 an=1
> [    6.389435] mtk_soc_eth 1e100000.ethernet eth0: phylink_mac_config:
> mode=fixed/trgmii/1Gbps/Full adv=00,00000000,00000220 pause=12 link=1 an=1
> 
> # ethtool eth0
> Settings for eth0:
>          Supported ports: [ MII ]
>          Supported link modes:   1000baseT/Full
>          Supported pause frame use: No
>          Supports auto-negotiation: No
>          Supported FEC modes: Not reported
>          Advertised link modes:  1000baseT/Full
>          Advertised pause frame use: No
>          Advertised auto-negotiation: No
>          Advertised FEC modes: Not reported
>          Speed: 1000Mb/s
>          Duplex: Full
>          Port: MII
>          PHYAD: 0
>          Transceiver: internal
>          Auto-negotiation: on
>          Current message level: 0x000000ff (255)
>                                 drv probe link timer ifdown ifup rx_err
> tx_err
>          Link detected: yes
> 
> 
> 
> I already have report from a MT7623 user that this patch gives issues.
> 
> I send v2 of the patch if I fixed that issue.
> 
> Also I think it is better to add a XTAL frequency check.
> The PLL values are only valid with a 40MHz crystal.
> 
> Any other comments for v2?

Looks good to me otherwise.
-- 
Florian
