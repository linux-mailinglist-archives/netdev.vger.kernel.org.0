Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 316F96278B4
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 10:08:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236776AbiKNJIT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 04:08:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236797AbiKNJHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 04:07:50 -0500
Received: from phobos.denx.de (phobos.denx.de [85.214.62.61])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755815581
        for <netdev@vger.kernel.org>; Mon, 14 Nov 2022 01:06:52 -0800 (PST)
Received: from wsk (85-222-111-42.dynamic.chello.pl [85.222.111.42])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: lukma@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id CB77C82A76;
        Mon, 14 Nov 2022 10:06:50 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1668416811;
        bh=qIWD8Gzcja6P5yxB0JQEuPr02TjjGMzkuvEXzZ9DSSs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GgqX42af6Ckus+oQzOxrhKy6GiADGKsbtnyafbbq4PD+o+ogUg9/bUOhDpTWyU73v
         e8xNGOtkDl2qeCZKRLTzjTLE6xkgr9XJJfMnMu394rKDVkHfNjEqifEVUWLrSDdiXf
         Cn5Wj6r3sKZb9xI7jeDJcwUiVAC0hEKCc7zWA1cMZiDfddS94rCQhZ47mS4Q2xlbZM
         oqROz6O1cCNjIqN4+M19fSF1KQ2HbqczqBU9rBEtDomPkvHSbanuWJ8RZKMAotObeb
         wNRT44N1mgNCsBO5vsBDYim7jCIWwLlt5xOYVOHbhGBc83Qe1LMPXETTND5Pj5Tfsy
         M1BkTScRLiHMw==
Date:   Mon, 14 Nov 2022 10:06:43 +0100
From:   Lukasz Majewski <lukma@denx.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org
Subject: Re: [PATCH 7/9] net: dsa: mv88e6071: Define max frame size (2048
 bytes)
Message-ID: <20221114100643.14ec2dc6@wsk>
In-Reply-To: <Y213NdYv3357ndij@lunn.ch>
References: <20221108082330.2086671-1-lukma@denx.de>
        <20221108082330.2086671-8-lukma@denx.de>
        <Y2pecZmradpWbtOn@lunn.ch>
        <20221110164236.5d24383d@wsk>
        <Y213NdYv3357ndij@lunn.ch>
Organization: denx.de
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="Sig_/+Rly=VAXV=q_lN_R20v1Z8_";
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

--Sig_/+Rly=VAXV=q_lN_R20v1Z8_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

> On Thu, Nov 10, 2022 at 04:42:36PM +0100, Lukasz Majewski wrote:
> > Hi Andrew,
> >  =20
> > > On Tue, Nov 08, 2022 at 09:23:28AM +0100, Lukasz Majewski wrote: =20
> > > > Accroding to the documentation - the mv88e6071 can support
> > > > frame size up to 2048 bytes.   =20
> > >=20
> > > Since the mv88e6020 is in the same family, it probably is the
> > > same? =20
> >=20
> > Yes it is 2048 B
> >  =20
> > > And what about the mv88e66220? =20
> >=20
> > You mean mv88e6220 ? =20
>=20
> Upps, sorry, yes.
>=20
> >=20
> > IIRC they are from the same family of ICs, so my guess :-) is that
> > they also have the same value. =20
>=20
> My point being, you created a new _ops structure when i don't think it
> is needed.

This was mostly my precaution to not introduce regression for other
supported ICs.

However, this shall not be the problem as long as the max supported
frame size is set for each of it. Then calling set_max_frame_size()
callback will always provide correct value.

>=20
>    Andrew




Best regards,

Lukasz Majewski

--

DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-59 Fax: (+49)-8142-66989-80 Email: lukma@denx.de

--Sig_/+Rly=VAXV=q_lN_R20v1Z8_
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEgAyFJ+N6uu6+XupJAR8vZIA0zr0FAmNyBSMACgkQAR8vZIA0
zr3QiQgAy0ilicDNtOfW7nSC+RTp02Mc1K4Jvx5lL49X7ilsdR8ZbC7LZ+oieYsx
LbE7hS9OfQoTB/05YqBBw/ey6y8HsDLYzh9XDU98+mGHEH0o3aVFsfnriVsbn7+1
i5mTWkXGIBXcO7bF/gS12CsxD0e1Scyf2JzYMfT3DbEd9M/IKJ5TB8dDnFWHpQbp
biO6D4n4UyO8bnSKR9oBk8vgjMavAIMvMKfpW6g1FNu6L3saClhGwOdAbFeb/IcT
v48k1Dbfrt9un85zyldB+yPneF8VkEwLyypyGvNV40D6yc3bOePwvQfJCUadnhIV
h6V1+VaCuwt3wlBXkCrYBV8FzqPyzw==
=/GLy
-----END PGP SIGNATURE-----

--Sig_/+Rly=VAXV=q_lN_R20v1Z8_--
