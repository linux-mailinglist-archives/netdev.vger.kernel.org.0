Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB9DE53DB49
	for <lists+netdev@lfdr.de>; Sun,  5 Jun 2022 12:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351039AbiFEKjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Jun 2022 06:39:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349170AbiFEKjT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Jun 2022 06:39:19 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D41E820F5A
        for <netdev@vger.kernel.org>; Sun,  5 Jun 2022 03:39:17 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nxnf5-00017S-Im; Sun, 05 Jun 2022 12:39:11 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 8C80D8C79B;
        Sun,  5 Jun 2022 10:39:09 +0000 (UTC)
Date:   Sun, 5 Jun 2022 12:39:09 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
Cc:     linux-can@vger.kernel.org, linux-kernel@vger.kernel.org,
        Max Staudt <max@enpas.org>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        netdev@vger.kernel.org
Subject: Re: [PATCH v4 0/7] can: refactoring of can-dev module and of Kbuild
Message-ID: <20220605103909.5on3ep7lzorc35th@pengutronix.de>
References: <20220513142355.250389-1-mailhol.vincent@wanadoo.fr>
 <20220603102848.17907-1-mailhol.vincent@wanadoo.fr>
 <20220604114603.hi4klmu2hwrvf75x@pengutronix.de>
 <CAMZ6RqJpJCAudv89YqFFQH80ei7WiAshyk1RtbEv=aXSyxo3hQ@mail.gmail.com>
 <20220604135541.2ki2eskyc7gsmrlu@pengutronix.de>
 <CAMZ6RqJ7qvXyxNVUK-=oJnK_oq7N94WABOb3pqeYf9Fw3G6J9A@mail.gmail.com>
 <20220604151859.hyywffrni4vo6gdl@pengutronix.de>
 <CAMZ6RqK45r-cqXvorUzRV-LA_C+mk6hNSA1b+0kLs7C-oTcDCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6hnz6wqmawmym7kp"
Content-Disposition: inline
In-Reply-To: <CAMZ6RqK45r-cqXvorUzRV-LA_C+mk6hNSA1b+0kLs7C-oTcDCA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--6hnz6wqmawmym7kp
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 05.06.2022 01:32:15, Vincent MAILHOL wrote:
> On Sun. 5 juin 2022 at 00:18, Marc Kleine-Budde <mkl@pengutronix.de> wrot=
e:
> > On 04.06.2022 23:59:48, Vincent MAILHOL wrote:
> > > > > Fine, but I need a bit of guidance here. To provide a tag, I need=
 to
> > > > > have my own git repository hosted online, right?
> > > >
> > > > That is one option.
> > >
> > > This suggests that there are other options? What would be those other
> > > options?
> >
> > 2. git.kernel.org (most preferred)
> > 3. github.com (have to ask Davem/Jakub)
> >
> > > > > Is GitHub OK or should I create one on https://git.kernel.org/?
> > > >
> > > > Some maintainers don't like github, let's wait what Davem and Jakub=
 say.
> > > > I think for git.kernel.org you need a GPG key with signatures of 3 =
users
> > > > of git.kernel.org.
> > >
> > > Personally, I would also prefer getting my own git.kernel.org account.
> >
> > See https://korg.docs.kernel.org/accounts.html
>=20
> Thanks for the link. I will have a look at it tomorrow (or the day
> after tomorrow in the worst case).
>=20
> Meanwhile, I will send the v5 which should address all your comments.

/me just realized that merged are independent of pull requests. I can
create a local branch and merge it, as Davem and Jakub do it. I've added
your v5 to can-next/master as a merge and I'll include this in my next
PR to net-next if Davem and Jakub are OK with merges in my branch.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6hnz6wqmawmym7kp
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKch8oACgkQrX5LkNig
012XGggAqD1LicAikRC3JMuxfXUK3p7048Ew7fkyIXL9bCcTwyPl6HSIfZocNtBt
utW+h3IxWv1/fKBnHiMZC1RF8x+CcWp2IZxqIDDx53ERZL3MUUTBuqG/tdUGzVHo
mBDRlEohb1K2RBrQggmuKQfAuZZ5+P3OD/F/X1tyBbnffyvJgiAkM0xa2EScP8Kh
13bQrHT/xZR4oPHDTFEpK1SF8SCtuRCIer99cRHAapbcdRHqVl+txsSk90fkQsxR
cQkReSm7R+c4EACo8u723jce4LAPlJL7PoAsux3YVEcZ/ZCRJLHnqxr7QbiiwcSE
3KL0opkdhjvnlIPRk2su5ZclADj/og==
=I4dL
-----END PGP SIGNATURE-----

--6hnz6wqmawmym7kp--
