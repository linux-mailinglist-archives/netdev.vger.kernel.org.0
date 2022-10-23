Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A64760919F
	for <lists+netdev@lfdr.de>; Sun, 23 Oct 2022 09:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230116AbiJWH1a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Oct 2022 03:27:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230111AbiJWH11 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Oct 2022 03:27:27 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4890560503;
        Sun, 23 Oct 2022 00:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1666509999;
        bh=TBP4iOY9tjkCxnRBE9igXp4oZM6sQ2L6B0wuAA1Mwgc=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=dJ172UiEEjI+ecsVuMEq+4o+dn2FK9TvJqshgTVXF+4K2rA9uxwkZAvBW3oBHYtOA
         5q8YB3b0LQyW2rOZylhksPoMHzoPS3ZqP3zJ05+mPuvnycNcMe1+3b2WYpkYsHsNHk
         2/ZZEvrsG+k5FncYijst8nenyTmj+YIq83LJgHUU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [80.245.79.234] ([80.245.79.234]) by web-mail.gmx.net
 (3c-app-gmx-bap20.server.lan [172.19.172.90]) (via HTTP); Sun, 23 Oct 2022
 09:26:39 +0200
MIME-Version: 1.0
Message-ID: <trinity-ff9bb15b-b10c-46d6-8af2-09a03563c3c8-1666509999435@3c-app-gmx-bap20>
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
Subject: Aw: Re: Re: Re: Re: Re: [PATCH v2] net: mtk_sgmii: implement
 mtk_pcs_ops
Content-Type: text/plain; charset=UTF-8
Date:   Sun, 23 Oct 2022 09:26:39 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
References: <Y1JhEWU5Ac6kd2ne@shell.armlinux.org.uk>
 <trinity-e60759de-3f0f-4b1e-bc0f-b33c4f8ac201-1666374467573@3c-app-gmx-bap55>
 <Y1LlnMdm8pGVXC6d@shell.armlinux.org.uk>
 <trinity-b567c57e-b87f-4fe8-acf7-5c9020f85aed-1666381956560@3c-app-gmx-bap55>
 <Y1MO6cyuVtFxTGuP@shell.armlinux.org.uk>
 <9BC397B2-3E0B-4687-99E5-B15472A1762B@fw-web.de>
 <Y1Ozp2ASm2Y+if3Q@shell.armlinux.org.uk>
 <trinity-4470b00b-771b-466e-9f3a-a3df72758208-1666435920485@3c-app-gmx-bs49>
 <Y1Qi55IwJZulL1X/@shell.armlinux.org.uk>
 <trinity-164dc5a6-98ce-464c-a43d-b00b91ca69e5-1666461195968@3c-app-gmx-bs49>
 <Y1RCA+l2OHkrFfhB@shell.armlinux.org.uk>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:fFpMM08aDl7L3vJnHWI9VzJxzjSaqFYWnegZeGXcufbN2HSYZTKGL29DMoGoorA2ESYtf
 3ig4K3+MW+7vFLe4lJiGBlZX1TvVACfYMzSs65M09dU5NrSK+qvKX43ydGTi8aHMdvJNwXFytE9B
 Hxdxcy7s7UvDLUy2gUI9d205cs/rBHT2A810JkA9U5OHNgozV1Ge5t53b/Js8RVb8xjPUlKRFlOM
 dAdgDO14Lylc157PdNIPBl7ti5X9NvgBp8H7mHq0pKrA15yNqenwg54PWxheraeaCA6B/azGR6ir
 lI=
X-UI-Out-Filterresults: notjunk:1;V03:K0:+D3LZqzXfm0=:DTybMHmw8WUh42tKrj2BCc
 XSvY72QQo5BivLO3AR+F3KVvkeQbJaGJTEmslVVChr4n0Jz2ubOboOo23LfWHKlD+mXKHXr+N
 CklAroo7LZDbRwkDnqApFIKFicAfrEr9bNTRPVoErklKnqgAjyYJ0kA6X8eLLI5GPj/4AopwV
 cxyL6Vx0UUa+wiLCZKJe5VC0uX8dRgoyUgb4bjXvwPwMXm3ppuKDF/PRThLLNdV+CKySc/sZy
 8DQLdt3ZCcEYGDu9HmILORoKzE0s10txv/iWKOC2P1AMYufZw3ZK9e4aTA3q7v+rCP4p0cwEg
 wwAv8Jg4PLgK9f6rj6ncLEf2CszxQxJVf3/s5wkrECEMNRqWL9qnhq9YrSuQjtKORL0NEMlnM
 HNuYHpYFsJHcGu+4kj9Gs9I6beHMCXYmvxpTfRFkkLQ4H/A84CzBlo4iPaN+E+mFJHZHlPwte
 1maIINWadY0xL6wfmmljUxEhIZRTd3luK1pNxBiWBgPN/zwxP+4OKZ7TVIpbsgnByWtcCvllS
 a8+JwhmVS+gWmzypZfmPSNX16wGpFbnyz6pvqkHamsg8kTQQs0h+S9JRMbLrkAtNS5xY0+dq9
 am2EWBV0AnYxnYV1wa4jUAq623mRSESZuJUdTXQNRtN26hOKrKGmgocBdP8WwmkRwFLwKMnSD
 qKbU2PWVnsjBaKmklfHF2EE3iEOKv5LXKiid1U6P3+1xN8JHD2Pgcs1iE2WsqEKaHl7I6eaYX
 en8X1mJHFo1p/IOI3jBojJd4j0HNp8AdUee6itvs1G+eW+CD0OXZXKboMf5X1belk/SGbIddu
 eNasLJMD1KE+59uVwhFMCpF4XWnGKcWSvL59P5sPTDIev34XJzWmm75BW8SO2UtBSdNY3K2ZY
 GSaXiHZXdULx/dF7J8yqdJh7EJOjNiQxOYMuyk24oKqgUPvvrj7oXZ3JKc3qkxQkzlcPTw9XP
 LahaGh6kVS81dUlbl9PVb2/d/s8QP9gMuiQQlrR9PYHCAtdA69nkmvfBrXN+VseIVzYDQBSVC
 gEJVvenhGH4lJ+1uOQDdzE4RzD8i6tIWmeyqorMc/kU4+7VfQB40NKtTsR/L02jwFYXFjAuW1
 bz0jhIUjGlvEWqBfv2whxmoTpZ7XU+xUpg+bUd7F8e4zwFG9N0pdpNE9madBPONKGPhehc1Cr
 /cplgytuO4u5bZ4QNgFm/ghVYsuLsl5b+fLsiGKE5hkGn6IAFaX3yYjfo9nmGkmn8xyp9N2LE
 1Ss/CTg/4krH2edo3Vur5rviAgcOPCkXQuPCWnW5R32h7F/0eoVprk1VMZIueDWRbYbaIKpDf
 DYR//5eV
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Gesendet: Samstag, 22. Oktober 2022 um 21:18 Uhr
> Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> An: "Frank Wunderlich" <frank-w@public-files.de>
> Cc: "Frank Wunderlich" <linux@fw-web.de>, linux-mediatek@lists.infradead=
.org, "Alexander Couzens" <lynxis@fe80.eu>, "Felix Fietkau" <nbd@nbd.name>=
, "John Crispin" <john@phrozen.org>, "Sean Wang" <sean.wang@mediatek.com>,=
 "Mark Lee" <Mark-MC.Lee@mediatek.com>, "David S. Miller" <davem@davemloft=
.net>, "Eric Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel=
.org>, "Paolo Abeni" <pabeni@redhat.com>, "Matthias Brugger" <matthias.bgg=
@gmail.com>, netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,=
 linux-kernel@vger.kernel.org
> Betreff: Re: Re: Re: Re: Re: [PATCH v2] net: mtk_sgmii: implement mtk_pc=
s_ops
>
> Hi,
>
> On Sat, Oct 22, 2022 at 07:53:16PM +0200, Frank Wunderlich wrote:
> > > Gesendet: Samstag, 22. Oktober 2022 um 19:05 Uhr
> > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> > > On Sat, Oct 22, 2022 at 12:52:00PM +0200, Frank Wunderlich wrote:
> > > > > Gesendet: Samstag, 22. Oktober 2022 um 11:11 Uhr
> > > > > Von: "Russell King (Oracle)" <linux@armlinux.org.uk>
> >
> > > > this patch breaks connectivity at least on the sfp-port (eth1).
> >
> > > > pcs_get_state
> > > > [   65.522936] offset:0 0x2c1140
> > > > [   65.522950] offset:4 0x4d544950
> > > > [   65.525914] offset:8 0x40e041a0
> > > > [  177.346183] offset:0 0x2c1140
> > > > [  177.346202] offset:4 0x4d544950
> > > > [  177.349168] offset:8 0x40e041a0
> > > > [  177.352477] offset:0 0x2c1140
> > > > [  177.356952] offset:4 0x4d544950
> > >
> > > Hi,
> > >
> > > Thanks. Well, the results suggest that the register at offset 8 is
> > > indeed the advertisement and link-partner advertisement register. So
> > > we have a bit of progress and a little more understanding of this
> > > hardware.
> > >
> > > Do you know if your link partner also thinks the link is up?
> >
> > yes link is up on my switch, cannot enable autoneg for fibre-port, so =
port is fixed to 1000M/full flowcontrol enabled.
> >
> > > What I notice is:
> > >
> > > mtk_soc_eth 15100000.ethernet eth1: Link is Up - 1Gbps/Unknown - flo=
w control off
> > >
> > > The duplex is "unknown" which means you're not filling in the
> > > state->duplex field in your pcs_get_state() function. Given the
> > > link parter adverisement is 0x00e0, this means the link partner
> > > supports PAUSE, 1000base-X/Half and 1000base-X/Full. The resolution
> > > is therefore full duplex, so can we hack that in to your
> > > pcs_get_state() so we're getting that right for this testing please?
> >
> > 0xe0 is bits 5-7 are set (in lower byte from upper word)..which one is=
 for duplex?
> >
> > so i should set state->duplex/pause based on this value (maybe compare=
 with own caps)?
> >
> > found a documentation where 5=3Dfull,6=3Dhalf, and bits 7+8 are for pa=
use (symetric/asymetric)
> >
> > regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1+8, &val);
> > partner_advertising =3D (val & 0x00ff0000) >> 16;
>
> Not quite :) When we have the link partner's advertisement and the BMSR,
> we have a helper function in phylink to do all the gritty work:
>
> 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1, &bm);
> 	regmap_read(mpcs->regmap, SGMSYS_PCS_CONTROL_1 + 8, &adv);
>
> 	phylink_mii_c22_pcs_decode_state(state, bm >> 16, adv >> 16);
>
> will do all the work for you without having to care about whether
> you're operating at 2500base-X, 1000base-X or SGMII mode.
>
> > > Now, I'm wondering what SGMII_IF_MODE_BIT0 and SGMII_IF_MODE_BIT5 do
> > > in the SGMSYS_SGMII_MODE register. Does one of these bits set the
> > > format for the 16-bit control word that's used to convey the
> > > advertisements. I think the next step would be to play around with
> > > these and see what effect setting or clearing these bits has -
> > > please can you give that a go?
> >
> > these is not clear to me...should i blindly set these and how to
> > verify what they do?
>
> Yes please - I don't think anyone knows what they do.

i guess BIT0 is the SGMII_EN flag like in other sgmii implementations.
Bit5 is "reserved" in all docs i've found....maybe it is related to HSGMII
or for 1G vs. 2G5.

but how to check what has changed...i guess only the register itself chang=
ed
and i have to readout another to check whats changed.

do we really need these 2 bits? reading/setting duplex/pause from/to the r=
egister
makes sense, but digging into undocumented bits is much work and we still =
only guess.

so i would first want to get sgmii working again and then strip the pause/=
duplex from it.

> > is network broken because of wrong duplex/pause setting? do not
> > fully understand your Patch.
>
> I suspect not having the duplex correct _could_ break stuff, but I
> also wonder whether the PCS is trying to decode the advertisements
> itself and coming out with the wrong settings.
>
> If it's interpreting a link partner advertisement of 0x00e0 using
> SGMII rules, then it will be looking at bits 11 and 10 for the
> speed, both of which are zero, which means 10Mbps - and 1000base-X
> doesn't operate at 10Mbps!

so maybe this breaks sgmii? have you changed this behaviour with your Patc=
h?

> So my hunch is that one of those two IF_MODE_BIT{0,5} _might_ change
> the way the PCS interprets the control word, but as we don't have
> any documentation to go on, only experimentation will answer this
> question.
>
> If these registers are MMIO, you could ensure that you have /dev/mem
> access enabled, and use devmem2 to poke at this register which would
> probably be quicker than doing a build-boot-test cycle with the
> kernel - this is how I do a lot of this kind of discovery when
> documentation is lacking.
>
> > But the timer-change can also break sgmii...
>
> SGMII mode should be writing the same value to the link timer, but
> looking at it now, I see I ended up with one too many zeros on the
> 16000000! It should be 1.6ms in nanoseconds, so 1600000. Please
> correct for future testing.

tried removing 1  zero from the 16000000, but same result.
tried also setting duplex with ethtool, but  after read it is still unknow=
n.
and i get no traffic working...i wonder because duplex was not set before =
your
patch too, but interface was working.

> Many thanks for your patience.

i do what i can, but i'm limited in time.

Frank
