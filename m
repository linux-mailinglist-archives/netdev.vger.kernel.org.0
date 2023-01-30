Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3143F680CAD
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 12:58:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236685AbjA3L6T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 06:58:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54936 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236605AbjA3L6E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 06:58:04 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E524D36082;
        Mon, 30 Jan 2023 03:57:42 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 745F7844F5;
        Mon, 30 Jan 2023 12:57:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1675079859;
        bh=M0nxgQtc49Zq2Qdw8ptTWPVK+nanBZ7OlWXYVpOCCOc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xp1oHyS1VCjMfI6TQ7Y/2DCaW8GB0b/GuvkP81vAj9kel5I2zFUO8KWSt/UTLmtzm
         i/J7d6laIiPd2RxEcd8ZeERxuxtX5NQq1b57F65er+2EAYa4qUSqdKC2pGI/1gK/iA
         QUUMLlZnng5my9rrJxTkE8Al/LKyYmN3V0+bzPydlKkWq1o3R6cilo1cmiPOBin37+
         W4cm3M6/KLAnfBC/UivHxkCxpOE2j37LqJklA0eSt/ri6V81fs/Mfni4nj97ivCusk
         88qHZZ8A4LLhgHMXg4FHQZj4HPWmShPFOTniljoFrErtSeSf2Qx5GFGmEiar2XBtFn
         g2TQ7Owge2OlA==
Date:   Mon, 30 Jan 2023 12:57:31 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, Vladimir Oltean <olteanv@gmail.com>,
        Eric Dumazet <edumazet@google.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/3] dsa: marvell: Provide per device information
 about max frame size
Message-ID: <20230130125731.7dd6dcee@wsk>
In-Reply-To: <Y9FG5PxOq7qsfvtz@shell.armlinux.org.uk>
References: <20230106101651.1137755-1-lukma@denx.de>
        <Y8Fno+svcnNY4h/8@shell.armlinux.org.uk>
        <20230116105148.230ef4ae@wsk>
        <20230125122412.4eb1746d@wsk>
        <Y9FG5PxOq7qsfvtz@shell.armlinux.org.uk>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/ieEpn67f4HDuCCrIqxES7qG";
 protocol="application/pgp-signature"; micalg=pgp-sha512
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--Sig_/ieEpn67f4HDuCCrIqxES7qG
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Russell,

> On Wed, Jan 25, 2023 at 12:24:12PM +0100, Lukasz Majewski wrote:
> > Hi,
> >  =20
> > > Hi Russell,
> > >  =20
> > > > On Fri, Jan 06, 2023 at 11:16:49AM +0100, Lukasz Majewski
> > > > wrote:   =20
> > > > > Different Marvell DSA switches support different size of max
> > > > > frame bytes to be sent. This value corresponds to the memory
> > > > > allocated in switch to store single frame.
> > > > >=20
> > > > > For example mv88e6185 supports max 1632 bytes, which is now
> > > > > in-driver standard value. On the other hand - mv88e6250
> > > > > supports 2048 bytes. To be more interresting - devices
> > > > > supporting jumbo frames - use yet another value (10240 bytes)
> > > > >=20
> > > > > As this value is internal and may be different for each
> > > > > switch IC, new entry in struct mv88e6xxx_info has been added
> > > > > to store it.
> > > > >=20
> > > > > This commit doesn't change the code functionality - it just
> > > > > provides the max frame size value explicitly - up till now it
> > > > > has been assigned depending on the callback provided by the
> > > > > IC driver (e.g. .set_max_frame_size, .port_set_jumbo_size).
> > > > >   =20
> > > >=20
> > > > I don't think this patch is correct.
> > > >=20
> > > > One of the things that mv88e6xxx_setup_port() does when
> > > > initialising each port is:
> > > >=20
> > > >         if (chip->info->ops->port_set_jumbo_size) {
> > > >                 err =3D chip->info->ops->port_set_jumbo_size(chip,
> > > > port, 10218); if (err)
> > > >                         return err;
> > > >         }
> > > >=20
> > > > There is one implementation of this, which is
> > > > mv88e6165_port_set_jumbo_size() and that has the effect of
> > > > setting port register 8 to the largest size. So any chip that
> > > > supports the port_set_jumbo_size() method will be programmed on
> > > > initialisation to support this larger size.
> > > >=20
> > > > However, you seem to be listing e.g. the 88e6190 (if I'm
> > > > interpreting the horrid mv88e6xxx_table changes correctly)   =20
> > >=20
> > > Those changes were requested by the community. Previous versions
> > > of this patch were just changing things to allow correct
> > > operation of the switch ICs on which I do work (i.e. 88e6020 and
> > > 88e6071).
> > >=20
> > > And yes, for 88e6190 the max_frame_size =3D 10240, but (by mistake)
> > > the same value was not updated for 88e6190X.
> > >=20
> > > The question is - how shall I proceed?=20
> > >=20
> > > After the discussion about this code - it looks like approach
> > > from v3 [1] seems to be the most non-intrusive for other ICs.
> > >  =20
> >=20
> > I would appreciate _any_ hints on how shall I proceed to prepare
> > those patches, so the community will accept them... =20
>=20

Thanks for a very detailed reply.

> What I'm concerned about, and why I replied, is that setting the
> devices to have a max frame size of 1522 when we program them to use
> a larger frame size means we break those switches for normal sized
> packets.
>=20
> The current logic in mv88e6xxx_get_max_mtu() is:
>=20
> 	If the chip implements port_set_jumbo_size, then packet sizes
> of up to 10240 are supported.
> 	(ops: 6131, 6141, 6171, 6172, 6175, 6176, 6190, 6190x, 6240,
> 6320, 6321, 6341, 6350, 6351, 6352, 6390, 6390x, 6393x)
> 	If the chip implements set_max_frame_size, then packet sizes
> of up to 1632 are supported.
> 	(ops: 6085, 6095, 6097, 6123, 6161, 6185)
> 	Otherwise, packets of up to 1522 are supported.
>=20
> Now, going through the patch, I see:
>=20
> 	88e6085 has 10240 but currently has 1632
> 	88e6095 has 1632 (no change)
> 	88e6097 has 1632 (no change)
> 	88e6123 has 10240 but currently has 1632
> 	88e6131 has 10240 (no change)
> 	88e6141 has 10240 (no change)
> 	88e6161 has 1632 but currently has 10240
> 	88e6165 has 1632 but currently has 1522
> 	88e6171 has 1522 but currently has 10240
> 	88e6172 has 10240 (no change)
> 	88e6175 has 1632 but currently has 10240
> 	88e6176 has 10240 (no change)
> 	88e6185 has 1632 (no change)
> 	88e6190 has 10240 (no change)
> 	88e6190x has 10240 (no change)
> 	88e6191 has 10240 but currently has 1522
> 	88e6191x has 1522 but currently has 10240
> 	88e6193x has 1522 but currently has 10240
> 	88e6220 has 2048 but currently has 1522
> 	88e6240 has 10240 (no change)
> 	88e6250 has 2048 but currently has 1522
> 	88e6290 has 10240 but currently has 1522
> 	88e6320 has 10240 (no change)
> 	88e6321 has 10240 (no change)
> 	88e6341 has 10240 (no change)
> 	88e6350 has 10240 (no change)
> 	88e6351 has 10240 (no change)
> 	88e6352 has 10240 (no change)
> 	88e6390 has 1522 but currently has 10240
> 	88e6390x has 1522 but currently has 10240
> 	88e6393x has 1522 but currently has 10240
>=20
> My point is that based on the above, there's an awful lot of changes
> that this one patch brings, and I'm not sure many of them are
> intended.

As I only have access to mv88e60{20|71} SoCs I had to base on the code
to deduce which max frame is supported.

>=20
> All the ones with "but currently has 10240", it seems they implement
> port_set_jumbo_size() which, although the switch may default to a
> smaller frame size, we configure it to be higher. Maybe these don't
> implement the field that configures those? Maybe your patch is wrong?
> I don't know.
>=20
> Similarly for the ones with "but currently has 1632", it seems they
> implement set_max_frame_size(), but this is only called via
> mv88e6xxx_change_mtu(), and I haven't worked out whether that will
> be called during initialisation by the networking layer.
>=20
> Now, what really concerns me is the difficulty in making this change.
> As we can see from the above, there's a lot of changes going on here,
> and it's not obvious which are intentional and which may be bugs.

I'm also quite surprised about the impact of this patch.

>=20
> So, I think it would be far better to introduce the "max_frame_size"
> field using the existing values, and then verify that value during
> initialisation time for every entry in mv88e6xxx_table[] using the
> rules that mv88e6xxx_get_max_mtu() was using. Boot that kernel, and
> have it run that verification, and state that's what's happened and
> was successful in the commit message.
>=20
> In the next commit, change mv88e6xxx_get_max_mtu() to use those
> verified values and remove the verification code.
>=20
> Then in the following commit, update the "max_frame_size" values with
> the changes you intend to make.
>=20
> Then, we can (a) have confidence that each of the new members were
> properly initialised, and (b) we can also see what changes you're
> intentionally making.
>=20

If I understood you correctly - the approach would be to "simulate" and
obtain each max_frame_size assigned in mv88e6xxx_get_max_mtu() to be
sure that we do preserve current (buggy or not) behaviour.

Then I shall just add those two extra values for mv88e60{20|71}.

> Right now, given that at least two of the "max_frame_size" values are
> wrong in this patch, I think we can say for certain that we've proven
> that trying to introduce this new member and use it in a single patch
> is too error prone.

I do agree here - the code for getting max frame size for each
supported SoC is quite convoluted and difficult to deduce the right
value from the outset.

>=20
> Thanks.
>=20




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Erika Unter
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/ieEpn67f4HDuCCrIqxES7qG
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmPXsKsACgkQAR8vZIA0
zr1AiggAlLqY0+puC0LByLsgqzuGJmmPd3gdPT/HhhXjgmlcyfpIet/Rf589p8oP
Mb1cAws/3yOES7A7lyI9e8q9NUd+NXF26lrcpdIza5M5r51WTJNaQdhyMtxdlPef
PNYsGLsa2qewnYHfF8m2j/JPZr2Z62cdHfAQjYrzcpy3X0ElRnvs3+PdY2PPkrbS
bc3lhjDq/qWPYpBnW4LmfbG4O9SX5M2CMeWyj0q07YZ9IT7+aCqA9amBVkipjTN3
psw4wTajnxCN/jehdiCYm33k1FDqFQ4PcnaY8Ekjrdjzi1BG/ckCMzrWoJN2tDNu
yW/y7LN0JuKarJIawW9QvlDlCR1eSQ==
=AM2e
-----END PGP SIGNATURE-----

--Sig_/ieEpn67f4HDuCCrIqxES7qG--
