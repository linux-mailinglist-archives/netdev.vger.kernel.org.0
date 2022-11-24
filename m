Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6947F637CF4
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 16:27:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229729AbiKXP1y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Nov 2022 10:27:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbiKXP1w (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Nov 2022 10:27:52 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A0389E94C
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 07:27:51 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1oyE8Y-0001nV-OM; Thu, 24 Nov 2022 16:27:38 +0100
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:5507:4aba:5e0a:4c27])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 51C90128789;
        Thu, 24 Nov 2022 15:27:37 +0000 (UTC)
Date:   Thu, 24 Nov 2022 16:27:35 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Yasushi SHOJI <yasushi.shoji@gmail.com>
Cc:     Yasushi SHOJI <yashi@spacecubics.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, remigiusz.kollataj@mobica.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] can: mcba_usb: Fix termination command argument
Message-ID: <20221124152735.s6ee6rvhlrbrubeh@pengutronix.de>
References: <20221124152504.125994-1-yashi@spacecubics.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="4uayrxpa5u2ozlxg"
Content-Disposition: inline
In-Reply-To: <20221124152504.125994-1-yashi@spacecubics.com>
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


--4uayrxpa5u2ozlxg
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 25.11.2022 00:25:03, Yasushi SHOJI wrote:
> Microchip USB Analyzer can activate the internal termination resistors
> by setting the "termination" option ON, or OFF to to deactivate them.
> As I've observed, both with my oscilloscope and captured USB packets
> below, you must send "0" to turn it ON, and "1" to turn it OFF.
>=20
> From the schematics in the user's guide, I can confirm that you must
> drive the CAN_RES signal LOW "0" to activate the resistors.
>=20
> Reverse the argument value of usb_msg.termination to fix this.
>=20
> These are the two commands sequence, ON then OFF.
>=20
> > No.     Time           Source                Destination           Prot=
ocol Length Info
> >       1 0.000000       host                  1.3.1                 USB =
     46     URB_BULK out
> >
> > Frame 1: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> > USB URB
> > Leftover Capture Data: a80000000000000000000000000000000000a8
> >
> > No.     Time           Source                Destination           Prot=
ocol Length Info
> >       2 4.372547       host                  1.3.1                 USB =
     46     URB_BULK out
> >
> > Frame 2: 46 bytes on wire (368 bits), 46 bytes captured (368 bits)
> > USB URB
> > Leftover Capture Data: a80100000000000000000000000000000000a9
>=20
> Signed-off-by: Yasushi SHOJI <yashi@spacecubics.com>

Applied to linux-can.

Thanks,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--4uayrxpa5u2ozlxg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmN/jWQACgkQrX5LkNig
011YHAf+L6ZiRh5zN7h7uP1yl1axD9FauNK2FXSwj7rSyK0XWhaSxQITgL4ELlEp
sWovjpIVvJdznn+rOQRyNfXqnB3eY0PjdkW2DvVZYiwDmq7cwqAoZCbWxfhlbeB1
a0pNe2jxZwgCOo1r5aTk/BWO0D2h0d2Pk5bz1pOsZ/2RgQLzUJFZVfz4uAMNSwnn
Bxut78hJKg7LTsSP5kBT42hKg6zTE3g3BBW8GgPuZXaLvyrh+cwZ9yTpkEMX0n0V
pf1a2RwL+xpcDjwJu35m+oK7dBAMN1ANPKYjRxYhfcmvBbJ1cX68MPOD/UwiUwk7
Pda9OiY44Q0lyoWv0VYa2lpKml3j2A==
=oAtK
-----END PGP SIGNATURE-----

--4uayrxpa5u2ozlxg--
