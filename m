Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F0463669A
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 18:08:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239251AbiKWRIy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 12:08:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57674 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239254AbiKWRIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 12:08:31 -0500
Received: from relay8-d.mail.gandi.net (relay8-d.mail.gandi.net [IPv6:2001:4b98:dc4:8::228])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81D535ADC6;
        Wed, 23 Nov 2022 09:07:49 -0800 (PST)
Received: (Authenticated sender: miquel.raynal@bootlin.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 1D76C1BF209;
        Wed, 23 Nov 2022 17:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
        t=1669223268;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=23xIh5NSQsiW7+QGI9jS3DDoQkdL28rWViunnKHDSAw=;
        b=OFePkfgT16Es93Wv9kGeRDZCyf7CUYBdJvekMmttzwJcE0v7yCAwtlvhWHJBEfljZ4Lj9w
        J93u1zVKbSuJSxJ9XhhMx+tLKq8Q5Bq+QufwfQMoi389GPvJbvq70M1UyCKxirjCcqPlYs
        8h1nMQQlNXCkGoCi4SA0IQKYZEaRZAWdUkwO4szHbwlIjmRDUwktQKxmgZj7Fo39NvVOm3
        eAXrhTEIU+2wESyt48k015loXvntR94yjCtIVCWNmgDDWpSGAqBT+El81KqMdkGXfKWrHY
        Y0RWiJFTlibUSSQNPtOAyXPnQQJZ+w7DofPFvf+U4ORARH9U/FFfBDxTcn7oHg==
Date:   Wed, 23 Nov 2022 18:07:40 +0100
From:   Miquel Raynal <miquel.raynal@bootlin.com>
To:     Alexander Aring <aahringo@redhat.com>
Cc:     Alexander Aring <alex.aring@gmail.com>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        linux-wpan@vger.kernel.org,
        David Girault <david.girault@qorvo.com>,
        Romuald Despres <romuald.despres@qorvo.com>,
        Frederic Blain <frederic.blain@qorvo.com>,
        Nicolas Schodet <nico@ni.fr.eu.org>,
        Guilhem Imberton <guilhem.imberton@qorvo.com>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org
Subject: Re: [PATCH wpan-next 1/3] ieee802154: Advertize coordinators
 discovery
Message-ID: <20221123180740.75415c83@xps-13>
In-Reply-To: <CAK-6q+g9XghJsH+Yh-7qRV1BAhC1J9GkOHOqBrpRerkQMn1sMw@mail.gmail.com>
References: <20221102151915.1007815-1-miquel.raynal@bootlin.com>
        <20221102151915.1007815-2-miquel.raynal@bootlin.com>
        <CAK-6q+iSzRyDDiNusXiRWvUsS5dSS5bSzAtNjSLTt6kgaxtbHg@mail.gmail.com>
        <20221118230443.2e5ba612@xps-13>
        <CAK-6q+jJKoFy359_Pd4_d+EfqLw4PTdG4F7H4u+URD=UKu9k6w@mail.gmail.com>
        <20221121100539.75e13069@xps-13>
        <CAK-6q+g9XghJsH+Yh-7qRV1BAhC1J9GkOHOqBrpRerkQMn1sMw@mail.gmail.com>
Organization: Bootlin
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

aahringo@redhat.com wrote on Mon, 21 Nov 2022 18:54:31 -0500:

> Hi,
>=20
> On Mon, Nov 21, 2022 at 4:05 AM Miquel Raynal <miquel.raynal@bootlin.com>=
 wrote:
> >
> > Hi Alexander,
> >
> > aahringo@redhat.com wrote on Sun, 20 Nov 2022 19:57:31 -0500:
> > =20
> > > Hi,
> > >
> > > On Fri, Nov 18, 2022 at 5:04 PM Miquel Raynal <miquel.raynal@bootlin.=
com> wrote: =20
> > > >
> > > > Hi Alexander,
> > > >
> > > > aahringo@redhat.com wrote on Sun, 6 Nov 2022 21:01:35 -0500:
> > > > =20
> > > > > Hi,
> > > > >
> > > > > On Wed, Nov 2, 2022 at 11:20 AM Miquel Raynal <miquel.raynal@boot=
lin.com> wrote: =20
> > > > > >
> > > > > > Let's introduce the basics for advertizing discovered PANs and
> > > > > > coordinators, which is:
> > > > > > - A new "scan" netlink message group.
> > > > > > - A couple of netlink command/attribute.
> > > > > > - The main netlink helper to send a netlink message with all the
> > > > > >   necessary information to forward the main information to the =
user.
> > > > > >
> > > > > > Two netlink attributes are proactively added to support future =
UWB
> > > > > > complex channels, but are not actually used yet.
> > > > > >
> > > > > > Co-developed-by: David Girault <david.girault@qorvo.com>
> > > > > > Signed-off-by: David Girault <david.girault@qorvo.com>
> > > > > > Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> > > > > > ---
> > > > > >  include/net/cfg802154.h   |  20 +++++++
> > > > > >  include/net/nl802154.h    |  44 ++++++++++++++
> > > > > >  net/ieee802154/nl802154.c | 121 ++++++++++++++++++++++++++++++=
++++++++
> > > > > >  net/ieee802154/nl802154.h |   6 ++
> > > > > >  4 files changed, 191 insertions(+)
> > > > > >
> > > > > > diff --git a/include/net/cfg802154.h b/include/net/cfg802154.h
> > > > > > index e1481f9cf049..8d67d9ed438d 100644
> > > > > > --- a/include/net/cfg802154.h
> > > > > > +++ b/include/net/cfg802154.h
> > > > > > @@ -260,6 +260,26 @@ struct ieee802154_addr {
> > > > > >         };
> > > > > >  };
> > > > > >
> > > > > > +/**
> > > > > > + * struct ieee802154_coord_desc - Coordinator descriptor
> > > > > > + * @coord: PAN ID and coordinator address
> > > > > > + * @page: page this coordinator is using
> > > > > > + * @channel: channel this coordinator is using
> > > > > > + * @superframe_spec: SuperFrame specification as received
> > > > > > + * @link_quality: link quality indicator at which the beacon w=
as received
> > > > > > + * @gts_permit: the coordinator accepts GTS requests
> > > > > > + * @node: list item
> > > > > > + */
> > > > > > +struct ieee802154_coord_desc {
> > > > > > +       struct ieee802154_addr *addr; =20
> > > > >
> > > > > Why is this a pointer? =20
> > > >
> > > > No reason anymore, I've changed this member to be a regular structu=
re.
> > > > =20
> > >
> > > ok.
> > > =20
> > > > > =20
> > > > > > +       u8 page;
> > > > > > +       u8 channel;
> > > > > > +       u16 superframe_spec;
> > > > > > +       u8 link_quality;
> > > > > > +       bool gts_permit;
> > > > > > +       struct list_head node;
> > > > > > +};
> > > > > > +
> > > > > >  struct ieee802154_llsec_key_id {
> > > > > >         u8 mode;
> > > > > >         u8 id;
> > > > > > diff --git a/include/net/nl802154.h b/include/net/nl802154.h
> > > > > > index 145acb8f2509..cfe462288695 100644
> > > > > > --- a/include/net/nl802154.h
> > > > > > +++ b/include/net/nl802154.h
> > > > > > @@ -58,6 +58,9 @@ enum nl802154_commands {
> > > > > >
> > > > > >         NL802154_CMD_SET_WPAN_PHY_NETNS,
> > > > > >
> > > > > > +       NL802154_CMD_NEW_COORDINATOR,
> > > > > > +       NL802154_CMD_KNOWN_COORDINATOR,
> > > > > > + =20
> > > > >
> > > > > NEW is something we never saw before and KNOWN we already saw bef=
ore?
> > > > > I am not getting that when I just want to maintain a list in the =
user
> > > > > space and keep them updated, but I think we had this discussion
> > > > > already or? Currently they do the same thing, just the command is
> > > > > different. The user can use it to filter NEW and KNOWN? Still I a=
m not
> > > > > getting it why there is not just a start ... event, event, event =
....
> > > > > end. and let the user decide if it knows that it's new or old fro=
m its
> > > > > perspective. =20
> > > >
> > > > Actually we already discussed this once and I personally liked more=
 to
> > > > handle this in the kernel, but you seem to really prefer letting the
> > > > user space device whether or not the beacon is a new one or not, so
> > > > I've updated both the kernel side and the userspace side to act like
> > > > this.
> > > > =20
> > >
> > > I thought there was some problem about when the "scan-op" is running
> > > and there could be the case that the discovered PANs are twice there,
> > > but this looks more like handling UAPI features as separate new and
> > > old ones? I can see that there can be a need for the first case? =20
> >
> > I don't think there is a problem handling this on one side or the
> > other, both should work identically. I've done the change anyway in v2
> > :)
> > =20
>=20
> ok.
>=20
> > > > > >         /* add new commands above here */
> > > > > >
> > > > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > > > > @@ -133,6 +136,8 @@ enum nl802154_attrs {
> > > > > >         NL802154_ATTR_PID,
> > > > > >         NL802154_ATTR_NETNS_FD,
> > > > > >
> > > > > > +       NL802154_ATTR_COORDINATOR,
> > > > > > +
> > > > > >         /* add attributes here, update the policy in nl802154.c=
 */
> > > > > >
> > > > > >  #ifdef CONFIG_IEEE802154_NL802154_EXPERIMENTAL
> > > > > > @@ -218,6 +223,45 @@ enum nl802154_wpan_phy_capability_attr {
> > > > > >         NL802154_CAP_ATTR_MAX =3D __NL802154_CAP_ATTR_AFTER_LAS=
T - 1
> > > > > >  };
> > > > > >
> > > > > > +/**
> > > > > > + * enum nl802154_coord - Netlink attributes for a coord
> > > > > > + *
> > > > > > + * @__NL802154_COORD_INVALID: invalid
> > > > > > + * @NL802154_COORD_PANID: PANID of the coordinator (2 bytes)
> > > > > > + * @NL802154_COORD_ADDR: coordinator address, (8 bytes or 2 by=
tes)
> > > > > > + * @NL802154_COORD_CHANNEL: channel number, related to @NL8021=
54_COORD_PAGE (u8)
> > > > > > + * @NL802154_COORD_PAGE: channel page, related to @NL802154_CO=
ORD_CHANNEL (u8)
> > > > > > + * @NL802154_COORD_PREAMBLE_CODE: Preamble code used when the =
beacon was received,
> > > > > > + *     this is PHY dependent and optional (u8)
> > > > > > + * @NL802154_COORD_MEAN_PRF: Mean PRF used when the beacon was=
 received,
> > > > > > + *     this is PHY dependent and optional (u8)
> > > > > > + * @NL802154_COORD_SUPERFRAME_SPEC: superframe specification o=
f the PAN (u16)
> > > > > > + * @NL802154_COORD_LINK_QUALITY: signal quality of beacon in u=
nspecified units,
> > > > > > + *     scaled to 0..255 (u8)
> > > > > > + * @NL802154_COORD_GTS_PERMIT: set to true if GTS is permitted=
 on this PAN
> > > > > > + * @NL802154_COORD_PAYLOAD_DATA: binary data containing the ra=
w data from the
> > > > > > + *     frame payload, (only if beacon or probe response had da=
ta)
> > > > > > + * @NL802154_COORD_PAD: attribute used for padding for 64-bit =
alignment
> > > > > > + * @NL802154_COORD_MAX: highest coordinator attribute
> > > > > > + */
> > > > > > +enum nl802154_coord {
> > > > > > +       __NL802154_COORD_INVALID,
> > > > > > +       NL802154_COORD_PANID,
> > > > > > +       NL802154_COORD_ADDR,
> > > > > > +       NL802154_COORD_CHANNEL,
> > > > > > +       NL802154_COORD_PAGE,
> > > > > > +       NL802154_COORD_PREAMBLE_CODE, =20
> > > > >
> > > > > Interesting, if you do a scan and discover pans and others answer=
s I
> > > > > would think you would see only pans on the same preamble. How is =
this
> > > > > working? =20
> > > >
> > > > Yes this is how it is working, you only see PANs on one preamble at=
 a
> > > > time. That's why we need to tell on which preamble we received the
> > > > beacon.
> > > > =20
> > >
> > > But then I don't know how you want to change the preamble while
> > > scanning? =20
> >
> > Just to be sure: here we are talking about reporting the beacons that
> > were received and the coordinators they advertise. Which means we
> > _need_ to tell the user on which preamble code it was, but we don't yet
> > consider any preamble code changes here on the PHY.
> > =20
>=20
> but there is my question, how coordinators can advertise they are
> running on a different preamble as they sent on the advertisement.

Well same as a channel change? I don't expect them to constantly
change. But if they do, the next scan will report it.

> And
> what I thought was that the preamble is a non changeable thing, more
> specifically 4 octet all zero (preamble) followed by 0xA7 (SFD)). I
> know there are transceivers to change at least the SFD value, but then
> I was assuming you were running out of spec (some people doing that to
> ehm... "fake secure" their 802.15.4 communication as I heard).

I have not taken into account advanced/out-of-spec preamble code
handling, for now I consider them to be an integer (very much like the
channels actually).

At least for what I can see, it should be enough.

If this field bothers you for now I can drop the field and
we will later add it at the end of the list. To be fully transparent,
it works only in simulation. I haven't yet tested it on UWB hardware but
this is in the pipe. Let me know what you prefer.=20

> > > I know there are registers for changing the preamble and I
> > > thought that is a vendor specific option. However I am not an expert
> > > to judge if it's needed or not, but somehow curious how it's working.=
 =20
> >
> > I guess this is a problem that we must delegate to the drivers, very
> > much like channel changes, no?
> > =20
>=20
> yes.
>=20
> - Alex
>=20


Thanks,
Miqu=C3=A8l
