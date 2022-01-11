Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9030D48B5FE
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 19:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242967AbiAKSpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jan 2022 13:45:44 -0500
Received: from mout.gmx.net ([212.227.17.22]:56679 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241456AbiAKSpn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jan 2022 13:45:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1641926734;
        bh=Zbz0HDivKExJ1XZLensjZUXUhwizktoGAqZ+oLHsbDg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Os6IZHGmo3p8uefWYlgDoG9WAnTJuAonFQd6QbSxaIP4OUZZVRLM75wkNpkHSIrHf
         4RGMecJKS8w9yvgGdz5FFz4Hf8zaTHD7biex7w3HvdJBicKfQlW8ox9T03psnUl9XQ
         NbS1GHsGUJIyOxLCc/Use9K5svSfFh2/MksYE2ec=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [157.180.224.33] ([157.180.224.33]) by web-mail.gmx.net
 (3c-app-gmx-bap14.server.lan [172.19.172.84]) (via HTTP); Tue, 11 Jan 2022
 19:45:34 +0100
MIME-Version: 1.0
Message-ID: <trinity-4b35f0dc-6bc6-400a-8d4e-deb26e626391-1641926734521@3c-app-gmx-bap14>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     =?UTF-8?Q?Alvin_=C5=A0ipraga?= <ALSI@bang-olufsen.dk>
Cc:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "olteanv@gmail.com" <olteanv@gmail.com>,
        "arinc.unal@arinc9.com" <arinc.unal@arinc9.com>
Subject: Aw: Re:  Re: [PATCH net-next v4 11/11] net: dsa: realtek:
 rtl8365mb: multiple cpu ports, non cpu extint
Content-Type: text/plain; charset=UTF-8
Date:   Tue, 11 Jan 2022 19:45:34 +0100
Importance: normal
Sensitivity: Normal
In-Reply-To: <87r19e5e8w.fsf@bang-olufsen.dk>
References: <20220105031515.29276-1-luizluca@gmail.com>
 <20220105031515.29276-12-luizluca@gmail.com>
 <87ee5fd80m.fsf@bang-olufsen.dk>
 <trinity-ea8d98eb-9572-426a-a318-48406881dc7e-1641822815591@3c-app-gmx-bs62>
 <87r19e5e8w.fsf@bang-olufsen.dk>
Content-Transfer-Encoding: quoted-printable
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:SnPjfPbu4cUDhNCD+FvVehGQxlyR5SjNfUpfKG5FAosLBiadEzQDp6oZVM+NQmIRPefit
 uuIPKSvtqOzfceHLEfG1hgH+59NAKoTnOcGhzNG7xcIdV4yHCy5nX/pwsxOyPzZbGnqyMW0dVJ2j
 dOVXx2Xe57lVSqPv4A4dm16AuezAIBhiSJYIvA5hV0jiz6rsgyrY+sGptIrDyPgRph3DByjOQgy5
 85NXVhhGhT76+6lAhZYsggfmb49ramBoLuWWfnLtgTkbEQezyvYZhSlnwPFdtIni0qSNC8Obki/J
 /8=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Ipy03TIfk24=:HI4wK/7jNStHEMhwvR2DsR
 f4ulPlKDhO/we3MJszff70EZNr+RIKGEXplZPTx5PmIYaCvkfZMYtBipajs1xdyWnxCV4p/E0
 uXtp0Y7MG5QZEirBYmS4r4yJnhQlS9Wfgtg9Nam1jq/BJPk/K0hSx2CoHDVy9m09Cfury3ucp
 tv9twEefbw6aI8tiwJA4UlV/aDCMNsvlYcMTuETGShV4aGYRclY+kYgfC7rohwCHuVqinh+TV
 4YRJur7PO0JiBA/8rg9UZKRkXpT7wbT93hR0kgjrgi+8gUpEuqu6kjJsJzqshU5WzRsxKW/vJ
 QtIRCQXpohcV43m+Cu8xlrcGj0z1wowjiYme2W9c3dv20GByDvd/WQt+5mDZn/OdS5vG5BFD0
 MbLRjkwr8KFwOYPPc8aQ58VRVXeOHAM3OU5DIj8ysZH/H3Iq71+7YmDiGOoruDkboZlnMBp4I
 NsILd+58ze+dmNIuy0uOSN84K9xUYKGNxR4ziodknIsWBME4aarKo9suLMJ+svqeNVzY7/y6J
 QONV4BbY/n3Xa/5+Rc7kjjjvIZO2IxRW2T4/afCd7fxB9kPq/zQHSiMzCAm0XpXQl14d2b8/C
 INROI7FUhqOSZT6jJaxdxKEPXW/HiUOM/PdIFofizFC0MYm+hOgxjzr1oNJfDiICkwnUkUxxl
 9HimCfXdaKCkpdKzu4j05Z795VwV5LxABClv7qcw8UqtbQKPrEKfHQpoQZVyHBxh7glyHOi9w
 3XT6Q/1mKj7DQ+qlvqG/ijUxWD3EmkhI4kG+3sc2DAXEgvq0eQTo4m7dvogb8PwmtVYIGx0OH
 VXfD//z
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

> Gesendet: Dienstag, 11=2E Januar 2022 um 19:17 Uhr
> Von: "Alvin =C5=A0ipraga" <ALSI@bang-olufsen=2Edk>

> Luiz, any comments regarding this? I suppose if the chip ID/revision is
> the same for both 67S and 67RB, they should work pretty much the same,
> right?

my phy driver is same for both devices and afaik only do different RX/TX d=
elays=2E With the chip-rev-patch 0x0020 i can init the switch, but have no =
technical documentation except the phy driver code=2E

> Ping working but TCP not working is a bit strange=2E You could check the
> output of ethtool -S and see if that meets your expectations=2E If you
> have a relatively modern ethtool you can also append --all-groups to the
> comment to get a more standard output=2E

as far as i see in tcpdump (suggested by luiz) on target it is a checksum =
error where checksum is always 0x8382 (maybe some kind of fixed tag)=2E

16:39:07=2E994825 IP (tos 0x10, ttl 64, id 54002, offset 0, flags [DF], pr=
oto TCP (6), length 60)
    192=2E168=2E1=2E2=2E43284 > 192=2E168=2E1=2E1=2E22: Flags [S], cksum 0=
x8382 (incorrect -> 0xa6f6), seq 3231275121, win 64240, options [mss 1460,s=
ackOK,TS val 1615921214 ecr 0,nop,wscale 7], length 0
16:39:12=2E154790 IP (tos 0x10, ttl 64, id 54003, offset 0, flags [DF], pr=
oto TCP (6), length 60)
    192=2E168=2E1=2E2=2E43284 > 192=2E168=2E1=2E1=2E22: Flags [S], cksum 0=
x8382 (incorrect -> 0x96b6), seq 3231275121, win 64240, options [mss 1460,s=
ackOK,TS val 1615925374 ecr 0,nop,wscale 7], length 0

> You can also try adjusting the RGMII TX/RX delay and pause settings -
> that might help for the R2 where you aren't getting any packets
> through=2E

r2pro i got working by setting both delays to 0 as phy-driver does the sam=
e (after some calculation)=2E

on r64 this is a bit more tricky, because the phy driver uses  tx=3D1 and =
rx=3D3 with this calculation for reg-value

regData =3D (regData & 0xFFF0) | ((txDelay << 3) & 0x0008) | (rxDelay & 0x=
0007);

but in dts i need the values in picosends (?) and here i do not know how t=
o calculate them

regards Frank
