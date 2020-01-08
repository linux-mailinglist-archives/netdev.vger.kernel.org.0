Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A485134222
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 13:48:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728116AbgAHMsH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 07:48:07 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:38013 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727263AbgAHMsH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 07:48:07 -0500
Received: from mail-qt1-f176.google.com ([209.85.160.176]) by
 mrelayeu.kundenserver.de (mreue109 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1M9Frd-1ijxQY3vYF-006PIq for <netdev@vger.kernel.org>; Wed, 08 Jan 2020
 13:48:06 +0100
Received: by mail-qt1-f176.google.com with SMTP id 5so2667949qtz.1
        for <netdev@vger.kernel.org>; Wed, 08 Jan 2020 04:48:05 -0800 (PST)
X-Gm-Message-State: APjAAAXfuShFPniNxd3Bo+SBtZtilZ9ctXENkpoqymSjs6frHcjRRcoc
        l9PubSgLJeazRtnqifJQ0rRviYoqytbeRbuUE1U=
X-Google-Smtp-Source: APXvYqzU86lGl2uOpnf5M31Gjk5qCxfJJ9JEzc0E9lE8ULGsqh4jKVlQA2OuIVHlk/5xcoPyohe+WUyC41OkV5fZXcg=
X-Received: by 2002:ac8:768d:: with SMTP id g13mr3386012qtr.7.1578487684840;
 Wed, 08 Jan 2020 04:48:04 -0800 (PST)
MIME-Version: 1.0
References: <20200106013417.12154-1-olteanv@gmail.com> <20200106013417.12154-10-olteanv@gmail.com>
In-Reply-To: <20200106013417.12154-10-olteanv@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 8 Jan 2020 13:47:48 +0100
X-Gmail-Original-Message-ID: <CAK8P3a2On4gF-_Ad3wxU4UQO0kAvYiipxCsM_DOgPWFPP3Bf2w@mail.gmail.com>
Message-ID: <CAK8P3a2On4gF-_Ad3wxU4UQO0kAvYiipxCsM_DOgPWFPP3Bf2w@mail.gmail.com>
Subject: Re: [PATCH v5 net-next 9/9] net: dsa: felix: Add PCS operations for PHYLINK
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        alexandru.marginean@nxp.com,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        xiaoliang.yang_1@nxp.com, yangbo lu <yangbo.lu@nxp.com>,
        Networking <netdev@vger.kernel.org>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        horatiu.vultur@microchip.com, UNGLinuxDriver@microchip.com,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:NgD1ZU9GgESCaTiEbl+u1xpcXJJHICur1z+1OEPOjcCWa5NMY+z
 sNu7MqXZq1vOv2FjrARzP4l6lqu7EFIbBFAhDKEHC3H1HuxudCaMjLBk7kJfnCzApcbUYbZ
 3l/i0vbw80bAT8QRTbFgjOzXkJFyVOc98dWwUgIGx1nEgO6cM+9AAdiQkO362tShNYXfy7s
 F7ETcIxuSaNrQsvMLxuUA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LObkb+AUMcs=:29d+wDLSWsGWfhPXdUmEHD
 LMiR5hlzcUx0pkt7Xrt1fizPdm5jg4f30xjSmIGuFV+wLR+NmGdKwGtB3Z5+HDUjtnoEf32ra
 nStbFyBEf88wBrn1PeFOLarSL72+/EWiCSFkEun496LOYtK9N1+ggfuqvdF6OKFfdhp6oIjjR
 bgOOgk8U9uQC817q0sDjGScQkSWrADdmCVcvZLZoiqO3AjFiJeXlTKVOJw8imWNLtZJ8z53LP
 yw4y2Vw0AiM03d+3BohEykBlUfZygl5G0ZI7Gk8fHV/AAPQeJ82NVO52fBlrrQpV5OE2Ba18k
 7kKXlP13CtzjrdKIf/V4graRzOl5F2P1vG/WueSqQ0olLj6mN93dHHYyoc33Kj43zU9yMWfxO
 Okk8U/0S5kOmY2J2Br/ddj6mNGXQsLvge42FS82Rra5gY4d2YHzrhdie9teMo9TCrecnNlzAC
 ohW1b4KGsE4PLi4/OFXI5xLnomPmL2Qz5Wk3QJZffsFBS34Qhdsu0xUIp/kcj0zYOuKoTOtTL
 e4BZaUJBLXq0YT8xIlfEeppq5MIApidDg4UDWrD4zNHk/87tuv9cn65nnrnYocjFvVK6hNoy5
 5y+8AjiWly9vCEaK/6xqERlau//jUr/yo3yVswZqqXy9hMehk1jZ/S2M+iMYXZmBUceySrN4E
 bri5hlIAqkAT+GBGToxTxhJvA6AoBuYrvzVAT5Rjst5dcqcjDS7G/NtC6zosOfjVIT8xC1R/s
 IOsqv2+UU8Blu762ltkWBNwnLdC8xkzlyVZhbn9WpwIE1co7k9lqa56Ss59nYA3BOr+R/3KBj
 Oh8cpwG95xQa/uy0FwxC1CbUaPZzkuNC61+a9DzXWEI+ybZxLyxWxQPU19q6dFsBkQyZrtK+C
 3Yt6IZP2D9MoJhn8mNDQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 6, 2020 at 2:37 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
>
> Layerscape SoCs traditionally expose the SerDes configuration/status for
> Ethernet protocols (PCS for SGMII/USXGMII/10GBase-R etc etc) in a register
> format that is compatible with clause 22 or clause 45 (depending on
> SerDes protocol). Each MAC has its own internal MDIO bus on which there
> is one or more of these PCS's, responding to commands at a configurable
> PHY address. The per-port internal MDIO bus (which is just for PCSs) is
> totally separate and has nothing to do with the dedicated external MDIO
> controller (which is just for PHYs), but the register map for the MDIO
> controller is the same.

I get randconfig build failures after this patch:

drivers/net/dsa/ocelot/felix_vsc9959.o: In function `vsc9959_mdio_bus_alloc':
felix_vsc9959.c:(.text+0x19c): undefined reference to `enetc_hw_alloc'
felix_vsc9959.c:(.text+0x1d1): undefined reference to `enetc_mdio_read'
felix_vsc9959.c:(.text+0x1d8): undefined reference to `enetc_mdio_write'

I'll send a patch after a bit more testing

       Arnd
