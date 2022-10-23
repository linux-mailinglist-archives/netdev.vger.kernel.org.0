Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 317216094D0
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 18:42:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230428AbiJWQmd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 12:42:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230431AbiJWQmb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 12:42:31 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.15])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 517DD6E883;
        Sun, 23 Oct 2022 09:42:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666543305;
        bh=q6SI4/nsMKXjbdqs1nVCqSG1prarl1EYNgcg/WkuA+Q=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=HogXH6aOeEZKlfiF4/EM1mtF67KKZ6GqrLL96lYQQfvSlDjjUOY53oYgIneLcPWU1
         h5MpkwYbM8xZo6M8hQ48Zh50PCoC0weEqJZuP91Az4bDxU7AVBZGxTCHBS9xzt6O6y
         FszFmqcBh/w9rkFNqgwafovX50MOnOU0KW7w+eFo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.79.234] ([80.245.79.234]) by web-mail.gmx.net
 (3c-app-gmx-bs01.server.lan [172.19.170.50]) (via HTTP); Sun, 23 Oct 2022
 18:41:45 +0200
MIME-Version: 1.0
Message-ID: <trinity-1d4cc306-d1a4-4ccf-b853-d315553515ce-1666543305596@3c-app-gmx-bs01>
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
Subject: Aw: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 23 Oct 2022 18:41:45 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
References: <Y1MO6cyuVtFxTGuP@shell.armlinux.org.uk>
 <9BC397B2-3E0B-4687-99E5-B15472A1762B@fw-web.de>
 <Y1Ozp2ASm2Y+if3Q@shell.armlinux.org.uk>
 <trinity-4470b00b-771b-466e-9f3a-a3df72758208-1666435920485@3c-app-gmx-bs49>
 <Y1Qi55IwJZulL1X/@shell.armlinux.org.uk>
 <trinity-164dc5a6-98ce-464c-a43d-b00b91ca69e5-1666461195968@3c-app-gmx-bs49>
 <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
 <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
 <Y1UMrvk2A9aAcjo5@shell.armlinux.org.uk>
 <trinity-5350c2bc-473d-408f-a25a-16b34bbfcba7-1666537529990@3c-app-gmx-bs01>
 <Y1Vh5U96W2u/GCnx@shell.armlinux.org.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:66XN6DlcYq99+lW8EOJzF5dVREx7NPfgB4OTCBUUKRlQAqqGEhqw7feueZj5Know5ZfNJ
 3LUjh7L6qsZ+5qonf2WzO/cvHRwTbLcnB3F6r8XJIToXYZOGgTzXMBRpRoxSMS9/pWD3HO2xY0oi
 qIbW8QQtHuQc236NGM7kgtEN2RgGlQZKHR+mZBGDNN1Wuo7CTDKsrQQrVRRgQWbAwkwqCt6UDWGu
 tk2V+/Bwo2I5NMsenA5pv28PS2prUc7Yzn6ZLlLRxmVP6wfkoktXUY6HCeGunO2eIwdYLn9l1NRJ
 7U=
X-UI-Out-Filterresults: notjunk:1;V03:K0:cNR4JS+SeFQ=:3aI37E82A5JmQ7H/802phb
 q8zHchdRnFnKujBD7CxhrbUrySCRZf4XqvSJrHjOPFNgEQGNG5uPibtUKOI4y5FhcTvFybero
 jX6YoPbAhM5IiJPQen2H0PJJ7liSH/EJi9UX5HH2iXHokmuPPoXrimcfQXt9HZ8gOKQVxQ3o7
 SrEbagz3sfzlV44cp1ox045fBJ/JcA2LEFXsKuJuggrkGC33Pap6PEnahm3M4Yk6l+/EoTwNN
 IzH5bD7Ox4FqK9ipmnOxlRDP8HURRXR7vagLa61txFiGCGHeLzkrTKJWbQEbFSfgnCJFiVYaV
 Ffezzg1uOk9eJ5nwOBEh6fu39F26I3/mO6dNF5TYH4ykWSxXX6XqdvQv+7D7hCozmtx9eK6eF
 Ii0LAoYenlEY9A2nF16XLROqWF64+WriI5LD+fHQxVFNVYxuhgQRhFZrllYhGF/IqV8LZptBB
 AcfGhwJH2F2ej0lJb+0RIkbOkSjj2Ub0nWgZ5HG0cqRh6EhPrRSGqcCwHf5yfkItn6k33YJck
 px2SuDfJsxZ7Ck9K1ltKTWM8XS93r+I6hvG4Mb5qjKY/wlvyWwp0IwO0t2vkBl7pJRzaCd9zu
 55g4qPGSFQo7gh9QbFYMmsEHJKWgS9IB7rzJkWmwXuRVFv1H3u0NSz30sgIPctCGiVSvF5Ywd
 lAUKG1RKA3ao98Zskyzid27b5LqWGeXItERwwYsiWuSrTY3Lc+Dl4DHa7NYWI8I8dvGzdrLpC
 oJPJO9UWnQNf89zPvedsp9G3wESEcSCkTH4wnSn2rCFZwQNVvw2Ne5xVRyrQi7NN9Pxwp+7Sz
 f0uJBndw7Ha5aZ79bu/3XFRtIxilrWXaXw0ehzCEoORoiTfh9mTTz39MBychfqucSPFce1mwo
 gQfap45H4pbnPhqbQ9xfyAVVb5G278ZH82JqdUAQu8Hu1qM6zWK4T0t/tewULIDJwiXltZzjT
 ymLO+Uv0bfu4T7EcbV9yuv4SMcM1ML5ORyZRP0zWaBWszLft+s5/t13sobqSEkwxXfd6vmhK+
 iAsvmMkKXeEY3dEGAWH5qskg70TSQpAmU2eq5LvASYjKz+7FWjVU5v1duq6zDYEjMmPVbOUyA
 kUCFyZT3hn2wnX6P3o7JpZ2V5+n/Fjr4045g9e9w9YLhY4c8OeYuovYXfS9ex1+de6MB8iIXb
 A3T7wAjih1MI7MaKwyYxroE80tlXf72jNtb8Z5WOS7bZfUJ6Rk+mPep6yAY8MomV/vjbJIjkj
 dmCBTcoOGAr0t7lyuYyiZaCBGk3YSxACRs+Vah9cTIjAtLK81WmSHDfw63VyPkzJPbK0Zlj1H
 Xvo2BnX3uA5B1aUyviYJDYInoJ2dhQ==
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Sonntag, 23. Oktober 2022 um 17:46 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> On Sun, Oct 23, 2022 at 05:05:30PM +0200, Frank Wunderlich wrote:
> > > Gesendet: Sonntag, 23. Oktober 2022 um 11:43 Uhr
> > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> >
> > > On Sun, Oct 23, 2022 at 09:26:39AM +0200, Frank Wunderlich wrote:
> > > > > Gesendet: Samstag, 22. Oktober 2022 um 21:18 Uhr
> > > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > > > Hi,
> > > > >
> > > > > On Sat, Oct 22, 2022 at 07:53:16PM +0200, Frank Wunderlich wrote=
:
> > > > > > > Gesendet: Samstag, 22. Oktober 2022 um 19:05 Uhr
> > > > > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > > > > > On Sat, Oct 22, 2022 at 12:52:00PM +0200, Frank Wunderlich w=
rote:
> > > > > > > > > Gesendet: Samstag, 22. Oktober 2022 um 11:11 Uhr
> > > > > > > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > > > >
> > > > > > > > this patch breaks connectivity at least on the sfp-port (e=
th1).
> > > > > >
> > > > > > > > pcs_get_state
> > > > > > > > [   65.522936] offset:0 0x2c1140
> > > > > > > > [   65.522950] offset:4 0x4d544950
> > > > > > > > [   65.525914] offset:8 0x40e041a0
> > > > > > > > [  177.346183] offset:0 0x2c1140
> > > > > > > > [  177.346202] offset:4 0x4d544950
> > > > > > > > [  177.349168] offset:8 0x40e041a0
> > > > > > > > [  177.352477] offset:0 0x2c1140
> > > > > > > > [  177.356952] offset:4 0x4d544950
> > > > > > >
> > > > > > > Hi,
> > > > > > >
> > > > > > > Thanks. Well, the results suggest that the register at offse=
t 8 is
> > > > > > > indeed the advertisement and link-partner advertisement regi=
ster. So
> > > > > > > we have a bit of progress and a little more understanding of=
 this
> > > > > > > hardware.
> > > > > > >
> > > > > > > Do you know if your link partner also thinks the link is up?
> > > > > >
> > > > > > yes link is up on my switch, cannot enable autoneg for fibre-p=
ort, so port is fixed to 1000M/full flowcontrol enabled.
> > > > > >
> > > > > > > What I notice is:
> > > > > > >
> > > > > > > mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/Unkno=
wn - flow control off
> > > > > > >
> > > > > > > The duplex is "unknown" which means you're not filling in th=
e
> > > > > > > state->duplex field in your pcs_get_state() function. Given =
the
> > > > > > > link parter adverisement is 0x00e0, this means the link part=
ner
> > > > > > > supports PAUSE, 1000base-X/Half and 1000base-X/Full. The res=
olution
> > > > > > > is therefore full duplex, so can we hack that in to your
> > > > > > > pcs_get_state() so we're getting that right for this testing=
 please?
> > > > > >
> > > > > > 0xe0 is bits 5-7 are set (in lower byte from upper word)..whic=
h one is for duplex?
> > > > > >
> > > > > > so i should set state->duplex/pause based on this value (maybe=
 compare with own caps)?
> > > > > >
> > > > > > found a documentation where 5=3Dfull,6=3Dhalf, and bits 7+8 ar=
e for pause (symetric/asymetric)
> > > > > >
> > > > > > regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1+8, &val);
> > > > > > partner_advertising =3D (val & 0x00ff0000) >> 16;
> > > > >
> > > > > Not quite :) When we have the link partner's advertisement and t=
he BMSR,
> > > > > we have a helper function in phylink to do all the gritty work:
> > > > >
> > > > > 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
> > > > > 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1 + 8, &adv);
> > > > >
> > > > > 	phylink_mii_c22_pcs_decode_state(state, bm >> 16, adv >> 16);
> > > > >
> > > > > will do all the work for you without having to care about whethe=
r
> > > > > you're operating at 2500base-X, 1000base-X or SGMII mode.
> > > > >
> > > > > > > Now, I'm wondering what SGMII_IF_MODE_BIT0 and SGMII_IF_MODE=
_BIT5 do
> > > > > > > in the SGMSYS_SGMII_MODE register. Does one of these bits se=
t the
> > > > > > > format for the 16-bit control word that's used to convey the
> > > > > > > advertisements. I think the next step would be to play aroun=
d with
> > > > > > > these and see what effect setting or clearing these bits has=
 -
> > > > > > > please can you give that a go?
> > > > > >
> > > > > > these is not clear to me...should i blindly set these and how =
to
> > > > > > verify what they do?
> > > > >
> > > > > Yes please - I don't think anyone knows what they do.
> > > >
> > > > i guess BIT0 is the SGMII_EN flag like in other sgmii implementati=
ons.
> > > > Bit5 is "reserved" in all docs i've found....maybe it is related t=
o HSGMII
> > > > or for 1G vs. 2G5.
> > >
> > > "other sgmii implementations" ?
> >
> > yes i googled for sgmii and found register definition for different ve=
ndor...
> > i don't know if sgmii is a standard for each vendor, afair trgmii was =
not.
> >
> > > If this is the SGMII_EN flag, maybe SGMII_IF_MODE_BIT0 should be
> > > renamed to SGMII_IF_SGMII_EN ? Maybe it needs to be set for SGMII
> > > and clear for base-X ?
> > >
> > > > but how to check what has changed...i guess only the register itse=
lf changed
> > > > and i have to readout another to check whats changed.
> > > >
> > > > do we really need these 2 bits? reading/setting duplex/pause from/=
to the register
> > > > makes sense, but digging into undocumented bits is much work and w=
e still only guess.
> > >
> > > I don't know - I've no idea about this hardware, or what the PCS is,
> > > and other people over the years I've talked to have said "we're not
> > > using it, we can't help". The mediatek driver has been somewhat of a
> > > pain for phylink as a result.
> > >
> > > > so i would first want to get sgmii working again and then strip th=
e pause/duplex from it.
> > >
> > > I think I'd need more information on your setup - is this dev 0? Are
> > > you using in-band mode or fixed-link mode?
> >
> > i only test with dev1 which is the sfp-port/eth1/gmac1...dev0 is the f=
ixed-link to switch-chip.
>
> Okay, so when you're using SGMII, how are you testing it? With a copper
> SFP plugged in?
>
> > > I don't think you've updated me with register values for this since
> > > the patch. With the link timer adjusted back to 1.6ms, that should
> > > result in it working again, but if not, I think there's some
> > > possibilities.
> >
> > sorry for that, have debugged timing and it was wrong because if-
> > condition had not included 1000baseX and 2500baseX. only sgmii
>
> SGMII's link timer is specified to be 1.6ms - the SGMII v1.8 spec
> doesn't specify the margins for this.
>
> 802.3z (1000base-X) is 10ms +10ms -0s.
>
> This is what we should be using, and what I tried to implement.
>
> The hex values programmed into the register should be 0x186A0 for
> SGMII and 0x98968 for 1000base-X and 2500base-X - both values
> should fit because the link timer is apparently 20 bits wide.
>
> > > The addition of SGMII_AN_ENABLE for SGMSYS_PCS_CONTROL_1 could have
> > > broken your setup if there is no actual in-band signalling, which
> > > basically means that your firmware description is wrong - and you've
> > > possibly been led astray by the poor driver implementation.
> >
> > disabled it, but makes no change.
> >
> > but i've noticed that timing is wrong
> >
> > old value: 0x186a0
> > new value: 0x98968
> >
> > so it takes the 10000000 and not the 1600000. so it looks like interfa=
ce-mode is not (yet) SGMII.
> >
> > debugged it and got 1000baseX (21),in dts i have
> > phy-mode =3D "2500base-x";
> > but SFP only supports 1G so mode 1000baseX is right
> >
> > set the old value with your calculation, but still not working, also w=
ith disabled AN_ENABLE-flag ;(
>
> I'm getting the impression that there's some confusing terminology going
> on here... can we clear this up please?
>
> SGMII is a proprietary modification of the 802.3z 1000base-X standard
> which:
> - reduces the link timer from 10ms to 1.6ms
> - implements data replication by 10x and 100x to achieve 100M and 10M
>   speeds over a link operating at a fixed speed of 1.25Gbaud.
> - changes the control word format to allow a SGMII PHY to signal to the
>   MAC in a timely manner which speed it is operating at.
>
> So, if you're using a fibre SFP to another device that is operating in
> 1000base-X mode, then you're wanting 1000base-X and not SGMII, and
> referring to this as SGMII is technically misleading.
>
> > root@bpi-r3:~# ip link set eth1 up
> > [   44.287442] mtk_soc_eth 15100000.ethernet eth1: configuring for inb=
and/1000be
> > [   44.295902] interface-mode 21 (sgmii:4)
> > root@bpi-r3:~# [   44.295907] timer 0x186a0
> > [   44.352872] offset:0 0x2c1140
> > [   44.355507] offset:4 0x4d544950
> > [   44.358462] offset:8 0x40e041a0
> > [   44.361609] mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/=
Full - flf
> > [   44.373042] IPv6: ADDRCONF(NETDEV_CHANGE): eth1: link becomes ready
> >
> > root@bpi-r3:~# ip a a 192.168.0.19/24 dev eth1
> > root@bpi-r3:~# ping 192.168.0.10
> > PING 192.168.0.10 (192.168.0.10) 56(84) bytes of data.
> > ^C
>
> This is where I postulated that the PCS is trying to interpret the
> advertisements as if they are SGMII formatted control words rather than
> 1000base-X formatted control words - and by doing so, it is trying to
> operate at 10Mbps (100x data replication) with the remote end trying to
> operate at 1000Mbps. If that is what it is doing, then you will have
> link-up but no communication.
>
> The solution to this is likely trying to find a bit that tells the
> PCS whether it should be expecting a 1000base-X (or 802.3z) formatted
> control word (aka 1000base-X mode) or a SGMII formatted control word.
>
> You mentioned that bit 0 in SGMSYS_SGMII_MODE is a "SGMII_EN" bit.
> Any ideas exactly what this bit does? Does it enable the PCS as a
> whole, or could that be the bit which switches between 1000base-X
> mode and SGMII mode? (More on this below).
>
> Note that the "old way" used to work because even in 1000base-X
> mode, the code would (technically incorrectly) force the PCS to
> use a fixed configuration of 1000Mbps and force the duplex bit -
> basically no 802.3 specified autonegotiation.
>
> However, 1000base-X with in-band signalling _should_ be using
> the autonegotiation - as everything else that uses phylink does.
>
> > > Can you confirm that the device on the other end for dev 0 does in
> > > actual fact use in-band signalling please?
> > >
> > > > > If it's interpreting a link partner advertisement of 0x00e0 usin=
g
> > > > > SGMII rules, then it will be looking at bits 11 and 10 for the
> > > > > speed, both of which are zero, which means 10Mbps - and 1000base=
-X
> > > > > doesn't operate at 10Mbps!
> > > >
> > > > so maybe this breaks sgmii? have you changed this behaviour with y=
our Patch?
> > >
> > > Nope, but not setting the duplex properly is yet another buggy and p=
oor
> > > quality of implementation that afficts this driver. I've said about
> > > setting the duplex value when reviewing your patch to add .pcs_get_s=
tate
> > > and I'm disappointed that you seemingly haven't yet corrected it in =
the
> > > code you're testing despite those review comments.
> >
> > sorry, i thought we want to read out the values from registers to set =
it based on them.
> >
> > currently i test only with the dev 1 (in-band-managed with 1GBit/s SFP=
)
> >
> > [    1.088310] dev: 0 offset:0 0x40140
> > [    1.088331] dev: 0 offset:4 0x4d544950
> > [    1.091827] dev: 0 offset:8 0x1
> > [    1.095607] dev: 1 offset:0 0x81140
> > [    1.098739] dev: 1 offset:4 0x4d544950
> > [    1.102214] dev: 1 offset:8 0x1
> >
> > after bring device up (disabled AN and set duplex to full):
> >
> > [   34.615926] timer 0x98968
> > [   34.672888] offset:0 0x2c1140
> > [   34.675518] offset:4 0x4d544950
> > [   34.678473] offset:8 0x40e041a0
> >
> > codebase:
> >
> > https://github.com/frank-w/BPI-R2-4.14/commits/6.1-r3-sgmii
>
> I think it would also be useful to print the register at offset 32
> as well, which is the SGMSYS_SGMII_MODE register, so we can discover
> what the initial and current values of these IF_MODE_BITs are. I
> may then be able to provide you an updated patch.
>
> > > If duplex remains as "unknown", then the MAC will be programmed to
> > > operate in _half_ _duplex_ mode (read mtk_mac_link_up()) which is no=
t
> > > what you likely want. Many MACs don't support half duplex at 1G spee=
d,
> > > so it's likely that without setting state->duplex, the result is tha=
t
> > > the MAC hardware is programmed incorrectly.
> >
> > wonder why it was working with only my patch which had duplex also not=
 set.
>
> It depends entirely on the MAC implementation and why the manufacturer
> decides to state that 1000 half-duplex isn't supported by the hardware!
> I don't think we can guess. However, configuring the hardware correctly
> eliminates potential issues.
>
> It is in entirely possible for devices configured with dissimilar
> duplex settings to communicate, but there will be packet loss - since
> the end operating in full duplex will transmit while the receiving
> end could also be transmitting, and the receving end could interpret
> that as a collision.
>
> > > > > So my hunch is that one of those two IF_MODE_BIT{0,5} _might_ ch=
ange
> > > > > the way the PCS interprets the control word, but as we don't hav=
e
> > > > > any documentation to go on, only experimentation will answer thi=
s
> > > > > question.
> >
> > the bits were in offset 0/4/8? are they now different than before?
> > if yes maybe these break it.
> >
> > as offset 4 is the phy-id and 8 is the advertisement from local and fa=
r
> > interface i guesss IF_MODE_* is in offset 0.
>
> They're in the register at offset 32:
>
> /* Register to control remote fault */
> #define SGMSYS_SGMII_MODE               0x20
> #define SGMII_IF_MODE_BIT0              BIT(0)
> ...
> #define SGMII_IF_MODE_BIT5              BIT(5)
>
> So, I think the first step should be to print the value of this register
> along side the other three you've been providing me and update me with
> its value. I'll then provide you a replacement patch to try.

here it is (AN again enabled, changes pushed to tree above):

bootup:

[    1.098876] dev: 1 offset:0 0x81140
[    1.102699] dev: 1 offset:4 0x4d544950
[    1.106180] dev: 1 offset:8 0x1
[    1.109914] dev: 1 offset:32 0x3112001b

after putting eth1 up:

[   32.566099] timer 0x186a0
[   32.623021] offset:0 0x2c1140
[   32.625653] offset:4 0x4d544950
[   32.628614] offset:8 0x40e041a0
[   32.631746] offset:32 0x3112011b

regards Frank
