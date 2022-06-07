Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37AD5540390
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 18:16:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344816AbiFGQQi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 12:16:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344804AbiFGQQh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 12:16:37 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::225])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 701A4101739;
        Tue,  7 Jun 2022 09:16:14 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 45C9D1C000D;
        Tue,  7 Jun 2022 16:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654618572;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZkAbXoXs2t8ugzNXMaQPGeM/Hio1skCbepGCuzCcvq8=;
        b=bT6KFVzefthNneJOZl8xkCHji1l5Zdj785++E0Brf8YKQwn0d6bDo1pkl/PZZTbwDDubHj
        l3TDI4TaVPxxjSYrBrr3sg46UvL7WtKG09Gi1cAfr4UFxTv8LosEeHyhxMl0K8nMTso4jB
        n4GX0PVEeB9YRe2XK7sAy4Lx7U4RHo/RKrtDOQ0ZikzT1zZu5m9y5t9ZFYEFxkEfUCMzYH
        Hu5JWhFumTWtj/wI806sUrMay3awejAwhYEIPaY56zU95b8N2wHQtXbg3RzLPRLTiXa9NG
        +2zy012ZyN66XybvqfOkVsoVDOajM/NNk0F3GSuYaVDHnvfkg3Mxmxuy0Ym7Xw==
Date:   Tue, 7 Jun 2022 18:16:08 +0200
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan - ML <linux-wpan@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next 1/6] net: ieee802154: Drop coordinator
 interface type
Message-ID: <20220607181608.609429cb@xps-13>
In-Reply-To: <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
        <20220603182143.692576-2-miquel.raynal@bootlin.com>
        <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
        <20220606174319.0924f80d@xps-13>
        <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alex,

aahringo@redhat.com wrote on Mon, 6 Jun 2022 23:04:06 -0400:

> Hi,
>=20
> On Mon, Jun 6, 2022 at 11:43 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Fri, 3 Jun 2022 22:01:38 -0400:
> > =20
> > > Hi,
> > >
> > > On Fri, Jun 3, 2022 at 2:34 PM Miquel Raynal <miquel.raynal@bootlin.c=
om> wrote: =20
> > > >
> > > > The current enum is wrong. A device can either be an RFD, an RFD-RX=
, an
> > > > RFD-TX or an FFD. If it is an FFD, it can also be a coordinator. Wh=
ile
> > > > defining a node type might make sense from a strict software point =
of
> > > > view, opposing node and coordinator seems meaningless in the ieee
> > > > 802.15.4 world. As this enumeration is not used anywhere, let's just
> > > > drop it. We will in a second time add a new "node type" enumeration
> > > > which apply only to nodes, and does differentiates the type of devi=
ces
> > > > mentioned above.
> > > > =20
> > >
> > > First you cannot say if this is not used anywhere else. =20
> >
> > Mmmh, that's tricky, I really don't see how that might be a
> > problem because there is literally nowhere in the kernel that uses this
> > type, besides ieee802154_setup_sdata() which would just BUG() if this
> > type was to be used. So I assumed it was safe to be removed.
> > =20
>=20
> this header is somehow half uapi where we copy it into some other
> software e.g. wpan-tools as you noticed.
>=20
> > > Second I have
> > > a different opinion here that you cannot just "switch" the role from
> > > RFD, FFD, whatever. =20
> >
> > I agree with this, and that's why I don't understand this enum.
> >
> > A device can either be a NODE (an active device) or a MONITOR (a
> > passive device) at a time. We can certainly switch from one to
> > another at run time.
> >
> > A NODE can be either an RFD or an FFD. That is a static property which
> > cannot change.
> >
> > However being a coordinator is just an additional property of a NODE
> > which is of type FFD, and this can change over time.
> >
> > So I don't get what having a coordinator interface would bring. What
> > was the idea behind its introduction then?
> > =20
>=20
> There exists arguments which I have in my mind right now:
>=20
> 1. frame parsing/address filter (which is somehow missing in your patches)
>=20
> The parsing of frames is different from other types (just as monitor
> interfaces). You will notice that setting up the address filter will
> require a parameter if coordinator or not.

I think this is something that I completely missed until now, can you
point me to where/how this is expected to be done? I don't see anything
wpan specific filtering implementation. What is expected on this area
and is there code that I missed already?

> Changing the address
> filterung during runtime of an interface is somehow _not_ supported.
> The reason is that the datasheets tell you to first set up an address
> filter and then switch into receiving mode. Changing the address
> filter during receive mode (start()/stop()) is not a specified
> behaviour. Due to bus communication it also cannot be done atomically.
> This might be avoidable but is a pain to synchronize if you really
> depend on hw address filtering which we might do in future. It should
> end in a different receiving path e.g. node_rx/monitor_rx.

Got it.

>=20
> 2. HardMAC transceivers
>=20
> The add_interface() callback will be directly forwarded to the driver
> and the driver will during the lifetime of this interface act as a
> coordinator and not a mixed mode which can be disabled and enabled
> anytime. I am not even sure if this can ever be handled in such a way
> from hardmac transceivers, it might depend on the transceiver
> interface but we should assume some strict "static" handling. Static
> handling means here that the transceiver is unable to switch from
> coordinator and vice versa after some initialization state.

Okay. I just completely missed the "interface add" command. So your
advice is to treat the "PAN coordinator" property as a static property
for a given interface, which seems reasonable.

For now I will assume the same treatment when adding the interface is
required compared to a NODE, but if something comes to your mind,
please let me know.

By the way, is there a mechanism limiting the number of interfaces on a
device? Should we prevent the introduction of a coordinator iface if
there is a node iface active?

> 3. coordinator (any $TYPE specific) userspace software
>=20
> May the main argument. Some coordinator specific user space daemon
> does specific type handling (e.g. hostapd) maybe because some library
> is required. It is a pain to deal with changing roles during the
> lifetime of an interface and synchronize user space software with it.
> We should keep in mind that some of those handlings will maybe be
> moved to user space instead of doing it in the kernel. I am fine with
> the solution now, but keep in mind to offer such a possibility.
>=20
> I think the above arguments are probably the same why wireless is
> doing something similar and I would avoid running into issues or it's
> really difficult to handle because you need to solve other Linux net
> architecture handling at first.

Yep.

> > > You are mixing things here with "role in the network" and what the
> > > transceiver capability (RFD, FFD) is, which are two different things.=
 =20
> >
> > I don't think I am, however maybe our vision differ on what an
> > interface should be.
> > =20
> > > You should use those defines and the user needs to create a new
> > > interface type and probably have a different extended address to act
> > > as a coordinator. =20
> >
> > Can't we just simply switch from coordinator to !coordinator (that's
> > what I currently implemented)? Why would we need the user to create a
> > new interface type *and* to provide a new address?
> >
> > Note that these are real questions that I am asking myself. I'm fine
> > adapting my implementation, as long as I get the main idea.
> > =20
>=20
> See above.

That's okay for me. I will adapt my implementation to use the interface
thing. In the mean time additional details about what a coordinator
interface should do differently (above question) is welcome because
this is not something I am really comfortable with.

Thanks,
Miqu=C3=A8l
