Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC1EF545143
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 17:52:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239599AbiFIPwZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 11:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233090AbiFIPwY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 11:52:24 -0400
Received: from relay10.mail.gandi.net (relay10.mail.gandi.net [217.70.178.230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F9AF11C3A;
        Thu,  9 Jun 2022 08:52:22 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id BA26824000B;
        Thu,  9 Jun 2022 15:52:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1654789940;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ButUhoJCBvOI4ergqvqDaez7x5i4Ao+w0QSlSNpu3Lk=;
        b=D30e1Zx1kuhkeGAUy/dTeA0a47r+1XL+dDQN7A90KUyMeWqwZWNzPl1wcsNw/T/5g+MhUJ
        iiKb6cHaP2cu/YdAF/KBVIwt6+PYLE2CotDjGLDS85E0S76H42Y/zicVwGHTF7t97NuhT1
        oBkqlvlniADHmC+EVtOSgIhJ1ED0SCco3YXKDtILV1bNUZrYYo8pyqpCvgUijhDIIWMu0Z
        4ZLVfqcXfZ+8bi/yPh2Y5TTFd7ObzOMeU3c+yRVhAxCXuMatH1NSnao/yuBKR0m20uvKWI
        BqYZydZ6ZazW8cneKHzrmgLKfKcbDYaZhcW8yQPzbMv+5XHE5zLL5UwFCHUpgw==
Date:   Thu, 9 Jun 2022 17:52:17 +0200
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
Message-ID: <20220609175217.21a9acee@xps-13>
In-Reply-To: <CAK-6q+iOG+r8fFa6_x4egHBUxxGLE+sYf2fKvPkY5T-MvvGiCQ@mail.gmail.com>
References: <20220603182143.692576-1-miquel.raynal@bootlin.com>
        <20220603182143.692576-2-miquel.raynal@bootlin.com>
        <CAK-6q+hAZMqsN=S9uWAm4rTN+uZwz7_L42=emPHz7+MvfW6ZpQ@mail.gmail.com>
        <20220606174319.0924f80d@xps-13>
        <CAK-6q+itswJrmy-AhZ5DpnHH0UsfAeTPQTmX8WfG8=PteumVLg@mail.gmail.com>
        <20220607181608.609429cb@xps-13>
        <20220608154749.06b62d59@xps-13>
        <CAK-6q+iOG+r8fFa6_x4egHBUxxGLE+sYf2fKvPkY5T-MvvGiCQ@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Wed, 8 Jun 2022 21:56:53 -0400:

> Hi,
>=20
> On Wed, Jun 8, 2022 at 9:47 AM Miquel Raynal <miquel.raynal@bootlin.com> =
wrote:
> >
> > Hi Alex,
> > =20
> > > > 3. coordinator (any $TYPE specific) userspace software
> > > >
> > > > May the main argument. Some coordinator specific user space daemon
> > > > does specific type handling (e.g. hostapd) maybe because some libra=
ry
> > > > is required. It is a pain to deal with changing roles during the
> > > > lifetime of an interface and synchronize user space software with i=
t.
> > > > We should keep in mind that some of those handlings will maybe be
> > > > moved to user space instead of doing it in the kernel. I am fine wi=
th
> > > > the solution now, but keep in mind to offer such a possibility.
> > > >
> > > > I think the above arguments are probably the same why wireless is
> > > > doing something similar and I would avoid running into issues or it=
's
> > > > really difficult to handle because you need to solve other Linux net
> > > > architecture handling at first. =20
> > >
> > > Yep. =20
> >
> > The spec makes a difference between "coordinator" and "PAN
> > coordinator", which one is the "coordinator" interface type supposed to
> > picture? I believe we are talking about being a "PAN coordinator", but
> > I want to be sure that we are aligned on the terms.
> > =20
>=20
> I think it depends what exactly the difference is. So far I see for
> address filtering it should be the same. Maybe this is an interface
> option then?

The difference is that the PAN coordinator can decide to eg. refuse an
association, while the other coordinators, are just FFDs with no
specific decision making capability wrt the PAN itself, but have some
routing capabilities available for the upper layers.

The most I look into this, the less likely it is that the Linux stack
will drive an RFD. Do you think it's worth supporting them? Because if
we don't:
* NODE =3D=3D FFD which acts as coordinator
* COORD =3D=3D FFD which acts as the PAN coordinator

> > > > > > You are mixing things here with "role in the network" and what
> > > > > > the transceiver capability (RFD, FFD) is, which are two
> > > > > > different things. =20
> > > > >
> > > > > I don't think I am, however maybe our vision differ on what an
> > > > > interface should be.
> > > > > =20
> > > > > > You should use those defines and the user needs to create a new
> > > > > > interface type and probably have a different extended address
> > > > > > to act as a coordinator. =20
> > > > >
> > > > > Can't we just simply switch from coordinator to !coordinator
> > > > > (that's what I currently implemented)? Why would we need the user
> > > > > to create a new interface type *and* to provide a new address?
> > > > >
> > > > > Note that these are real questions that I am asking myself. I'm
> > > > > fine adapting my implementation, as long as I get the main idea.
> > > > > =20
> > > >
> > > > See above. =20
> > >
> > > That's okay for me. I will adapt my implementation to use the
> > > interface thing. In the mean time additional details about what a
> > > coordinator interface should do differently (above question) is
> > > welcome because this is not something I am really comfortable with. =
=20
> >
> > I've updated the implementation to use the IFACE_COORD interface and it
> > works fine, besides one question below.
> >
> > Also, I read the spec once again (soon I'll sleep with it) and
> > actually what I extracted is that:
> >
> > * A FFD, when turned on, will perform a scan, then associate to any PAN
> >   it found (algorithm is beyond the spec) or otherwise create a PAN ID
> >   and start its own PAN. In both cases, it finishes its setup by
> >   starting to send beacons.
> > =20
>=20
> What does it mean "algorithm is beyond the spec" - build your own?

This is really what is in the spec, I suppose it means "do what you
want in your use case".

What I have in mind: when a device is powered on and detects two PANs,
well, it can join whichever it wants, but perhaps we should make the
decision based on the LQI information we have (the closer the better).

> > * A RFD will behave more or less the same, without the PAN creation
> >   possibility of course. RFD-RX and RFD-TX are not required to support
> >   any of that, I'll assume none of the scanning features is suitable
> >   for them.
> >
> > I have a couple of questions however:
> >
> > - Creating an interface (let's call it wpancoord) out of wpan0 means
> >   that two interfaces can be used in different ways and one can use
> >   wpan0 as a node while using wpancoord as a PAN coordinator. Is that
> >   really allowed? How should we prevent this from happening?
> > =20
>=20
> When the hardware does not support it, it should be forbidden. As most
> transceivers have only one address filter it should be forbidden
> then... but there exists a way to indeed have such a setup (which you
> probably don't need to think about). It's better to forbid something
> now, with the possibility later allowing it. So it should not break
> any existing behaviour.

Done, thanks to the pointer you gave in the other mail.

>=20
> > - Should the device always wait for the user(space) to provide the PAN
> >   to associate to after the scan procedure right after the
> >   add_interface()? (like an information that must be provided prior to
> >   set the interface up?)
> >
> > - How does an orphan FFD should pick the PAN ID for a PAN creation?
> >   Should we use a random number? Start from 0 upwards? Start from
> >   0xfffd downwards? Should the user always provide it?
> > =20
>=20
> I think this can be done all with some "fallback strategies" (build
> your own) if it's not given as a parameter.

Ok, In case no PAN is found, and at creation no PAN ID is provided, we
can default to 0.

> > - Should an FFD be able to create its own PAN on demand? Shall we
> >   allow to do that at the creation of the new interface?
> > =20
>=20
> I thought the spec said "or otherwise"? That means if nothing can be
> found, create one?

Ok, so we assume this is only at startup, fine. But then how to handle
the set_pan_id() call? I believe we can forbid any set_pan_id() command
to be run while the interface is up. That would ease the handling.
Unless I am missing something?

Thanks,
Miqu=C3=A8l
