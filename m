Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA60619F8D
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 19:17:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbiKDSR2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 14:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230182AbiKDSR1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 14:17:27 -0400
Received: from relay9-d.mail.gandi.net (relay9-d.mail.gandi.net [217.70.183.199])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E10E43AEA;
        Fri,  4 Nov 2022 11:17:25 -0700 (PDT)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id E0B90FF80C;
        Fri,  4 Nov 2022 18:17:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1667585844;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ISRFFPjShTa523N4UQrt9CFTP3J9ZkKLKH2wGQjF6+I=;
        b=WCpFNL2Fhkhx9xLT6Oaoi8MzRECtIrJwjZkcHhqdmCWXk677VdZosfNA5mUmuykNKTkk0z
        LdPyOUTfn3jzvAUmromUGULR9hr9/4qrEdndec6tgAMUubeRWQOqtyrclVJKO/+XxcAVJ5
        5sQWSFbbeZ/TUIo6Ba5dwM/6oaADnWP2MBg0DHoRR3hnf9reKHE1MKYMnnhuiQcZMmkmwH
        EO7GW+L2IqroI8XFzz44pIcTwYiLTP9vukWpNKQglbL8Lp/D3BN4UgEr2izrvVpaD0SXs+
        Nq7QY9j52fiOaix0SBl/+j2EgZO1ayqFf8xm9x+fWtQIwfN6wmSyu4N+Y96DqA==
Date:   Fri, 4 Nov 2022 19:17:20 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>
Subject: Re: [PATCH wpan-next v2 0/3] IEEE 802.15.4: Add coordinator
 interfaces
Message-ID: <20221104191720.776d033e@xps-13>
In-Reply-To: <CAK-6q+hi1dhyfoYAGET55Ku=_in7BbNNaqWQVX2Z_iOg1+0Nyg@mail.gmail.com>
References: <20221026093502.602734-1-miquel.raynal@bootlin.com>
        <CAK-6q+jXPyruvdtS3jgzkuH=f599EiPk7vWTWLhREFCMj5ayNg@mail.gmail.com>
        <20221102155240.71a1d205@xps-13>
        <CAK-6q+hi1dhyfoYAGET55Ku=_in7BbNNaqWQVX2Z_iOg1+0Nyg@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Thu, 3 Nov 2022 20:55:38 -0400:

> Hi,
>=20
> On Wed, Nov 2, 2022 at 10:52 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Sun, 30 Oct 2022 22:20:03 -0400:
> > =20
> > > Hi,
> > >
> > > On Wed, Oct 26, 2022 at 5:35 AM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > Hello,
> > > > These three patches allow the creation of coordinator interfaces, w=
hich
> > > > were already defined without being usable. The idea behind is to use
> > > > them advertizing PANs through the beaconing feature.
> > > > =20
> > >
> > > I still don't know how exactly those "leaves" and "non-leaves" are
> > > acting here regarding the coordinator interfaces. If this is just a
> > > bit here to set in the interface I am fine with it. But yea,
> > > "relaying" feature is a project on its own, as we said previously.
> > >
> > > Another mail I was asking myself what a node interface is then,
> > > currently it is a mesh interface with none of those 802.15.4 PAN
> > > management functionality? =20
> >
> > Not "none", because I would expect a NODE to be able to perform minimal
> > management operations, such as:
> > - scanning
> > - requesting an association
> > But in no case it is supposed to:
> > - send beacons
> > - manage associations
> > - be the PAN coordinator
> > - act as a relay
> > =20
>=20
> perfect, thanks. But still there is something which I don't get.
>=20
> The split you mentioned about the functionality is for me being a
> coordinator (IEEE spec) or pan coordinator (IEEE spec) which has the
> additional functionality of "send beacons, manage assocs, act as
> relay".

I would expect any coordinator (IEEE spec) to be able to send beacons
and relay (but in this case it only makes sense to send beacons if
relaying is supported, IMHO).

The PAN coordinator (IEEE spec) only has the following additional
capability: managing assocs within the PAN. But in practice it is very
likely that it is the one with the greater computational resources and
the highest networking capabilities (it is usually the one which acts
as a bridge with eg. the internet, says the spec).

> So a coordinator (iftype) is a pan coordinator (IEEE spec) and a node
> (iftype) is a coordinator (IEEE spec), but _only_ when it's
> associated, before it is just a manually setup mesh node?

Mmmh, actually this is not how I see it. My current mental model:
- COORD (iftype) may act as:
  * a leaf device (associating with the PAN coordinator, sending data)
  * a coordinator (like above + beaconing and relaying) once associated
  * a PAN coordinator (like above + assoc management) if the device
    started the PAN or after a PAN coordinator handover.
  Note: physically, it can only be authorized on FFD.
- NODE (iftype) may only be a leaf device no matter its association
  status, this is typically a sensor that sends data.
  Note: can be authorized on any type of device (FFD or RFD).

If I understand correctly, your idea was to change the interface type
depending of the role of the device within the network. But IMHO the
interface type should only be picked up once for all in the lifetime of
the device. Of course we can switch from one to another by quickly
turning off and on again the device, but this is not a common use case.
We must keep in mind that PAN coordinator handover may happen, which
means the interface must stay on but stop acting as the PAN
coordinator. Using two different interface types for that is not
impossible, but does not seem relevant to me.

Would you agree?

> I hope it's clear when meaning iftype and when meaning IEEE spec, but
> for the manual setup thing (node iftype) there is no IEEE spec,
> although it is legal to do it in my opinion.

It's clear, no problem. In my previous e-mails, when talking about the
interfaces I used the uppercase NODE and COORD keywords, while I used
the plain english lowercase "[leaf] node", "coordinator" or "PAN
coordinator" words when talking about the IEEE definitions.

Thanks,
Miqu=C3=A8l
