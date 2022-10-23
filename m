Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9954360943B
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 17:06:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230273AbiJWPGd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 11:06:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiJWPGb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 11:06:31 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.18])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BE3733DE;
        Sun, 23 Oct 2022 08:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666537530;
        bh=Vaxb3gohNn5gDFD7Xa8aS1zNUOdlCxRydbcxadSnrOg=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=lMWN0J//VOs5rgDlIMb44upiGOdVV8SzWEfU7f4l8nQnGnRvomIdff0u1y7a/peFJ
         LOPXXwLLOrx362mpFL+krND/6QJn72whSez0Y59hApHeDCoSoEkh8pF1M8qgw6O9c/
         Zd1egFS33yJ5WA6Dbb6/Z5mZjHFqTZENYeZwf+lg=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.79.234] ([80.245.79.234]) by web-mail.gmx.net
 (3c-app-gmx-bs01.server.lan [172.19.170.50]) (via HTTP); Sun, 23 Oct 2022
 17:05:30 +0200
MIME-Version: 1.0
Message-ID: <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
From:   Frank Wunderlich <frank-w@public-files.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Frank Wunderlich <linux@fw-web.de>,
        linux-mediatek@lists.infradead.org,
        Alexander Couzens <lynxis@fe80.eu>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Aw: Re: Re: Re: Re: Re: Re: [PATCH v2] net: mtk_sgmii: implement
 mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 23 Oct 2022 17:05:30 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
References: <Y1LlnMdm8pGVXC6d@shell.armlinux.org.uk>
 <trinity-b567c57e-b87f-4fe8-acf7-5c9020f85aed-1666381956560@3c-app-gmx-bap55>
 <Y1MO6cyuVtFxTGuP@shell.armlinux.org.uk>
 <9BC397B2-3E0B-4687-99E5-B15472A1762B@fw-web.de>
 <Y1Ozp2ASm2Y+if3Q@shell.armlinux.org.uk>
 <trinity-4470b00b-771b-466e-9f3a-a3df72758208-1666435920485@3c-app-gmx-bs49>
 <Y1Qi55IwJZulL1X/@shell.armlinux.org.uk>
 <trinity-164dc5a6-98ce-464c-a43d-b00b91ca69e5-1666461195968@3c-app-gmx-bs49>
 <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
 <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
 <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:W9L0cP3rHccayNt+1kw2ehLieZ8Cw98286GcvK22Jx9cILS29Ohkx/9sSHK5ErWnjzYVB
 7LLmKi0ZYlAfeM8Nkzai04b8jLWWBrDOzM2jH2eaRUOnT8tOKRiXs8T/Wna8yaiOJPpT+Sa4ec4K
 0VUozsdfPsWpm+wArdQEIRHtq4a7ctwgB1J3MtDArNQurKf+oO+TR/hubPljoYPkrHGvTxM0q4Oq
 3hFF3xxLqQ0TtM+yroG8Dr9H698OAnhK4ueEDK+XHMGwzUgzzbALogweDJBJKCwWdOsn8YGpVAAR
 Xc=
X-UI-Out-Filterresults: notjunk:1;V03:K0:KeC5iPK2xYI=:tXhxX+ZlbmeVFcXGeouNEy
 5c7HdYyqicJzqNBZYO7mejZ85HZ+YDPZU3BWVAYA8nEsGRMmCe/g5336axwJmIoGa4cKdfSSF
 DdG6bldHAYRjz/XnRWmhj6b7QSlFdDxwORoWudMyG7+cYzw65W9fxW6PlHVZHCKz2+zr72Rcs
 PuLLUKSESm42PgPZlM9Edv1Y5BkMzmed6fqXm/51+Q+PYWO3oN+EVF5mlic0AZd1LpAaywFy/
 yQgcrmUv0kB6PpZJlv7mWK3RVlSXH9f2g6g8yiWuwV1GgSGpBsSbvRDQMRA6ydBRoCU5gm4Fi
 9A28G6vukkvkm1nxwJTX5hkkVrLBUera7td5V07838+7mb1Ja+UpGPinqk1vrrSVWe5BJ/bhf
 qPM9icY9TrhA+lxB2jdDikZAoBcw4ApAup7Vx4Yy0xeSms3H1i87SRAJ3fmBGHRZxd287DKBy
 KSzEaH9pAKDz0pLZJPNfVRxrEMvH3HB1k9QifB8wFP+NASFD/b93Zef1dMYGaaF6e/1vlp0IG
 rCI58LWPKAvO+qm9n+M7ImyDwk8wdgEd3oJsi/othkAZyv7qchW+M/mGizOnUhjajHAwlezOQ
 gIx0a+UpKnZSdZmyhqbGZ8vqlSQO6y1f4etuptMcnDXGP+VV0Z6vjbM3fyTAdD++vM88UZjrj
 074perP4DddVKCmqrn1JnsP4VUlKDYhDMBJF1r/EbZ7+Xt8iYoQ/6tKNODrGjsc9MKlfH1izq
 5yqty0RPlK7gQsyv7X+lovOVo5SZRcdJ63ohNGMkdmSEvwkR7YN4NeTK/KYYZ5lqGREWEFKL0
 GZGbhzFkbcLnDEpaJAi1ltsjHBxjjWHrsTjFlcTdKzmoXjVyvakSxMz5Jl8oSaz1eceJMnX5K
 wuH6OEEHx/H3K0yLT7n2jJZ4Zzh0wD4Nu/c0oIIjCxMl2hKrO3lsK7xIxuq5ij0l0X9LCzbQv
 vYAWYXWpY7PgyWs943NJYWXc+JGcStqNpOtnwy041XAQiUmBY7fs1+BDI5zsObIW4q9OarlTa
 cvuuU+pNI7oTuvOOFc/Zdw87RRO60fPyiqqnA8a7zMEFp2byFRaFi5q+p8L3445OL718JDpcE
 2NvwkaxcELbJsFKE3YDRi05b5tNvH0UBB3u59GXkRvVfEX2+6tH7w/glsp/BQm/C/UkOxb16E
 B+wa/LTWGYjTZaABE8EhKuE6xAtFU6wtuZeaZgMHXQR4jUvLX/Qd7sSeefutf0PAsRPKOmu3b
 W2SWiLoZXbbCE7Ab8USZ7Zc/sBTuJx1th/5X9hNusn/IDQ+XExqyEqgl1F0P+Wj7LSt0UODTp
 wFhApYwQlmGCcxxqPQ29ShCjFINOvA==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Sonntag, 23. Oktober 2022 um 11:43 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux.org.uk>

> On Sun, Oct 23, 2022 at 09:26:39AM +0200, Frank Wunderlich wrote:
> > > Gesendet: Samstag, 22. Oktober 2022 um 21:18 Uhr
> > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > Hi,
> > >
> > > On Sat, Oct 22, 2022 at 07:53:16PM +0200, Frank Wunderlich wrote:
> > > > > Gesendet: Samstag, 22. Oktober 2022 um 19:05 Uhr
> > > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > > > On Sat, Oct 22, 2022 at 12:52:00PM +0200, Frank Wunderlich wrote=
:
> > > > > > > Gesendet: Samstag, 22. Oktober 2022 um 11:11 Uhr
> > > > > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > >
> > > > > > this patch breaks connectivity at least on the sfp-port (eth1)=
.
> > > >
> > > > > > pcs_get_state
> > > > > > [   65.522936] offset:0 0x2c1140
> > > > > > [   65.522950] offset:4 0x4d544950
> > > > > > [   65.525914] offset:8 0x40e041a0
> > > > > > [  177.346183] offset:0 0x2c1140
> > > > > > [  177.346202] offset:4 0x4d544950
> > > > > > [  177.349168] offset:8 0x40e041a0
> > > > > > [  177.352477] offset:0 0x2c1140
> > > > > > [  177.356952] offset:4 0x4d544950
> > > > >
> > > > > Hi,
> > > > >
> > > > > Thanks. Well, the results suggest that the register at offset 8 =
is
> > > > > indeed the advertisement and link-partner advertisement register=
. So
> > > > > we have a bit of progress and a little more understanding of thi=
s
> > > > > hardware.
> > > > >
> > > > > Do you know if your link partner also thinks the link is up?
> > > >
> > > > yes link is up on my switch, cannot enable autoneg for fibre-port,=
 so port is fixed to 1000M/full flowcontrol enabled.
> > > >
> > > > > What I notice is:
> > > > >
> > > > > mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/Unknown -=
 flow control off
> > > > >
> > > > > The duplex is "unknown" which means you're not filling in the
> > > > > state->duplex field in your pcs_get_state() function. Given the
> > > > > link parter adverisement is 0x00e0, this means the link partner
> > > > > supports PAUSE, 1000base-X/Half and 1000base-X/Full. The resolut=
ion
> > > > > is therefore full duplex, so can we hack that in to your
> > > > > pcs_get_state() so we're getting that right for this testing ple=
ase?
> > > >
> > > > 0xe0 is bits 5-7 are set (in lower byte from upper word)..which on=
e is for duplex?
> > > >
> > > > so i should set state->duplex/pause based on this value (maybe com=
pare with own caps)?
> > > >
> > > > found a documentation where 5=3Dfull,6=3Dhalf, and bits 7+8 are fo=
r pause (symetric/asymetric)
> > > >
> > > > regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1+8, &val);
> > > > partner_advertising =3D (val & 0x00ff0000) >> 16;
> > >
> > > Not quite :) When we have the link partner's advertisement and the B=
MSR,
> > > we have a helper function in phylink to do all the gritty work:
> > >
> > > 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
> > > 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1 + 8, &adv);
> > >
> > > 	phylink_mii_c22_pcs_decode_state(state, bm >> 16, adv >> 16);
> > >
> > > will do all the work for you without having to care about whether
> > > you're operating at 2500base-X, 1000base-X or SGMII mode.
> > >
> > > > > Now, I'm wondering what SGMII_IF_MODE_BIT0 and SGMII_IF_MODE_BIT=
5 do
> > > > > in the SGMSYS_SGMII_MODE register. Does one of these bits set th=
e
> > > > > format for the 16-bit control word that's used to convey the
> > > > > advertisements. I think the next step would be to play around wi=
th
> > > > > these and see what effect setting or clearing these bits has -
> > > > > please can you give that a go?
> > > >
> > > > these is not clear to me...should i blindly set these and how to
> > > > verify what they do?
> > >
> > > Yes please - I don't think anyone knows what they do.
> >
> > i guess BIT0 is the SGMII_EN flag like in other sgmii implementations.
> > Bit5 is "reserved" in all docs i've found....maybe it is related to HS=
GMII
> > or for 1G vs. 2G5.
>
> "other sgmii implementations" ?

yes i googled for sgmii and found register definition for different vendor=
...
i don't know if sgmii is a standard for each vendor, afair trgmii was not.

> If this is the SGMII_EN flag, maybe SGMII_IF_MODE_BIT0 should be
> renamed to SGMII_IF_SGMII_EN ? Maybe it needs to be set for SGMII
> and clear for base-X ?
>
> > but how to check what has changed...i guess only the register itself c=
hanged
> > and i have to readout another to check whats changed.
> >
> > do we really need these 2 bits? reading/setting duplex/pause from/to t=
he register
> > makes sense, but digging into undocumented bits is much work and we st=
ill only guess.
>
> I don't know - I've no idea about this hardware, or what the PCS is,
> and other people over the years I've talked to have said "we're not
> using it, we can't help". The mediatek driver has been somewhat of a
> pain for phylink as a result.
>
> > so i would first want to get sgmii working again and then strip the pa=
use/duplex from it.
>
> I think I'd need more information on your setup - is this dev 0? Are
> you using in-band mode or fixed-link mode?

i only test with dev1 which is the sfp-port/eth1/gmac1...dev0 is the fixed=
-link to switch-chip.

> I don't think you've updated me with register values for this since
> the patch. With the link timer adjusted back to 1.6ms, that should
> result in it working again, but if not, I think there's some
> possibilities.

sorry for that, have debugged timing and it was wrong because if-condition=
 had not included 1000baseX and 2500baseX. only sgmii

> The addition of SGMII_AN_ENABLE for SGMSYS_PCS_CONTROL_1 could have
> broken your setup if there is no actual in-band signalling, which
> basically means that your firmware description is wrong - and you've
> possibly been led astray by the poor driver implementation.

disabled it, but makes no change.

but i've noticed that timing is wrong

old value: 0x186a0
new value: 0x98968

so it takes the 10000000 and not the 1600000. so it looks like interface-m=
ode is not (yet) SGMII.

debugged it and got 1000baseX (21),in dts i have
phy-mode =3D "2500base-x";
but SFP only supports 1G so mode 1000baseX is right

set the old value with your calculation, but still not working, also with =
disabled AN_ENABLE-flag ;(

root@bpi-r3:~# ip link set eth1 up
[   44.287442] mtk_soc_eth 15100000.ethernet eth1: configuring for inband/=
1000be
[   44.295902] interface-mode 21 (sgmii:4)
root@bpi-r3:~# [   44.295907] timer 0x186a0
[   44.352872] offset:0 0x2c1140
[   44.355507] offset:4 0x4d544950
[   44.358462] offset:8 0x40e041a0
[   44.361609] mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/Full=
 - flf
[   44.373042] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready

root@bpi-r3:~# ip a a 192.168.0.19/24 dev eth1
root@bpi-r3:~# ping 192.168.0.10
PING 192.168.0.10 (192.168.0.10) 56(84) bytes of data.
^C

> Can you confirm that the device on the other end for dev 0 does in
> actual fact use in-band signalling please?
>
> > > If it's interpreting a link partner advertisement of 0x00e0 using
> > > SGMII rules, then it will be looking at bits 11 and 10 for the
> > > speed, both of which are zero, which means 10Mbps - and 1000base-X
> > > doesn't operate at 10Mbps!
> >
> > so maybe this breaks sgmii? have you changed this behaviour with your =
Patch?
>
> Nope, but not setting the duplex properly is yet another buggy and poor
> quality of implementation that afficts this driver. I've said about
> setting the duplex value when reviewing your patch to add .pcs_get_state
> and I'm disappointed that you seemingly haven't yet corrected it in the
> code you're testing despite those review comments.

sorry, i thought we want to read out the values from registers to set it b=
ased on them.

currently i test only with the dev 1 (in-band-managed with 1GBit/s SFP)

[    1.088310] dev: 0 offset:0 0x40140
[    1.088331] dev: 0 offset:4 0x4d544950
[    1.091827] dev: 0 offset:8 0x1
[    1.095607] dev: 1 offset:0 0x81140
[    1.098739] dev: 1 offset:4 0x4d544950
[    1.102214] dev: 1 offset:8 0x1

after bring device up (disabled AN and set duplex to full):

[   34.615926] timer 0x98968
[   34.672888] offset:0 0x2c1140
[   34.675518] offset:4 0x4d544950
[   34.678473] offset:8 0x40e041a0

codebase:

https://github.com/frank-w/BPI-R2-4.14/commits/6.1-r3-sgmii

> If duplex remains as "unknown", then the MAC will be programmed to
> operate in _half_ _duplex_ mode (read mtk_mac_link_up()) which is not
> what you likely want. Many MACs don't support half duplex at 1G speed,
> so it's likely that without setting state->duplex, the result is that
> the MAC hardware is programmed incorrectly.

wonder why it was working with only my patch which had duplex also not set=
.

> > > So my hunch is that one of those two IF_MODE_BIT{0,5} _might_ change
> > > the way the PCS interprets the control word, but as we don't have
> > > any documentation to go on, only experimentation will answer this
> > > question.

the bits were in offset 0/4/8? are they now different than before?
if yes maybe these break it.

as offset 4 is the phy-id and 8 is the advertisement from local and far
interface i guesss IF_MODE_* is in offset 0.

> > > If these registers are MMIO, you could ensure that you have /dev/mem
> > > access enabled, and use devmem2 to poke at this register which would
> > > probably be quicker than doing a build-boot-test cycle with the
> > > kernel - this is how I do a lot of this kind of discovery when
> > > documentation is lacking.
> > >
> > > > But the timer-change can also break sgmii...

currently this is no more the case as i set the timer to old value
so something else is breaking it.

> > > SGMII mode should be writing the same value to the link timer, but
> > > looking at it now, I see I ended up with one too many zeros on the
> > > 16000000! It should be 1.6ms in nanoseconds, so 1600000. Please
> > > correct for future testing.
> >
> > tried removing 1  zero from the 16000000, but same result.
> > tried also setting duplex with ethtool, but  after read it is still un=
known.
>
> Honestly this doesn't surprise me given the poor state of the mtk_sgmii
> code. There's lots that this implementation gets wrong, but I can't fix
> it without either people willing to research and test stuff, or without
> the actual hardware in front of me.

i can test, but i do not fully understand the code nor have the exoerience
to work with devmem2. have used it long time ago but with assistance to re=
ad
which register and with expected values.

> This mtk_eth_soc driver has been a right pain for me ever since the
> half-hearted switch-over to use phylink.

i know it is huge as it covers many different SoC. but i'm not able to rew=
rite it :p

regards Frank
