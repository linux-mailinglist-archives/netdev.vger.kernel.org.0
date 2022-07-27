Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E6575831E1
	for <lists+netdev@lfdr.de>; Wed, 27 Jul 2022 20:22:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233914AbiG0SW1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jul 2022 14:22:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233708AbiG0SWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Jul 2022 14:22:05 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D453F1D91
        for <netdev@vger.kernel.org>; Wed, 27 Jul 2022 10:21:27 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oGkiX-0007R4-EQ; Wed, 27 Jul 2022 19:21:05 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 1F27FBC4BE;
        Wed, 27 Jul 2022 17:21:02 +0000 (UTC)
Date:   Wed, 27 Jul 2022 19:21:01 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Dario Binacchi <dario.binacchi@amarulasolutions.com>
Cc:     linux-kernel@vger.kernel.org, linux-can@vger.kernel.org,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        michael@amarulasolutions.com,
        Amarula patchwork <linux-amarula@amarulasolutions.com>,
        Jeroen Hofstee <jhofstee@victronenergy.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        netdev@vger.kernel.org,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Max Staudt <max@enpas.org>
Subject: Re: [RFC PATCH v3 8/9] can: slcan: add support to set bit time
 register (btr)
Message-ID: <20220727172101.iw3yiynni6feft4v@pengutronix.de>
References: <20220726210217.3368497-1-dario.binacchi@amarulasolutions.com>
 <20220726210217.3368497-9-dario.binacchi@amarulasolutions.com>
 <20220727113054.ffcckzlcipcxer2c@pengutronix.de>
 <CABGWkvrmbQcCHdZ_ANb+_196d9HsAxAHc4QS94R19v5STHcbiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="qb4zgbo6zcj7rdiz"
Content-Disposition: inline
In-Reply-To: <CABGWkvrmbQcCHdZ_ANb+_196d9HsAxAHc4QS94R19v5STHcbiA@mail.gmail.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--qb4zgbo6zcj7rdiz
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 27.07.2022 17:55:10, Dario Binacchi wrote:
> Hello Marc,
>=20
> On Wed, Jul 27, 2022 at 1:31 PM Marc Kleine-Budde <mkl@pengutronix.de> wr=
ote:
> >
> > On 26.07.2022 23:02:16, Dario Binacchi wrote:
> > > It allows to set the bit time register with tunable values.
> > > The setting can only be changed if the interface is down:
> > >
> > > ip link set dev can0 down
> > > ethtool --set-tunable can0 can-btr 0x31c
> > > ip link set dev can0 up
> >
> > As far as I understand, setting the btr is an alternative way to set the
> > bitrate, right?
>=20
> I thought of a non-standard bitrate or, in addition to the bitrate, the
> possibility of enabling some specific CAN controller options. Maybe Oliver
> could help us come up with the right answer.
>=20
> This is the the slcan source code:
> https://github.com/linux-can/can-utils/blob/cad1cecf1ca19277b5f5db39f8ef6=
f8ae426191d/slcand.c#L331
> btr case cames after speed but they don't seem to be considered alternati=
ve.
>=20
> > I don't like the idea of poking arbitrary values into a
> > hardware from user space.
>=20
> However this is already possible through the slcand and slcan_attach
> applications.
> Furthermore, the driver implements the LAWICEL ASCII protocol for CAN
> frame transport over serial lines,
> and this is one of the supported commands.
>=20
> >
> > Do you have a use case for this?
>=20
> I use the applications slcand and slcan_attach as a reference, I try to m=
ake the
> driver independent from them for what concerns the CAN setup. And the bit=
 time
> register setting is the last dependency.

Ok - We avoided writing bit timing registers from user space into the
hardware for all existing drivers. If there isn't a specific use case,
let's skip this patch. If someone comes up with a use case we can think
of a proper solution.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--qb4zgbo6zcj7rdiz
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmLhc/oACgkQrX5LkNig
013Q0wf+OetFqVIdpnKJrgEcaRpfWuVRTy1mYAAfQqf4fWGUm34tGLcMabzW4wzi
Fgv2S2BILslBLV588C1qtPNMPDP3aGZuUWR6e1NTRHKpHanNT9iVt4GZg7vphc4S
LMk8hlAIVWYCMe8ORjCAmFx7bMR8X3n8S9LupuSFBXncD2PaCkMd3EMs2H5bAGis
VwYwL063/10IcfSPgG59l7zQxz104wphrYoK4qDC9LH9ebfXTkuBuwkqjmSvykXM
EuMsoy3KW7NLKe2tEfl31DEiPaET29Gbpo9K/NsGpPRPj/BvRRo5E9eFsybDKY+M
J0/bsEjYG/WOaxmx9GjfCDA4LXlxdQ==
=Yfkr
-----END PGP SIGNATURE-----

--qb4zgbo6zcj7rdiz--
