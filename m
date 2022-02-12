Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F9F94B3635
	for <lists+netdev@lfdr.de>; Sat, 12 Feb 2022 17:04:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236839AbiBLQEV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Feb 2022 11:04:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235884AbiBLQEU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Feb 2022 11:04:20 -0500
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B1CCB9
        for <netdev@vger.kernel.org>; Sat, 12 Feb 2022 08:04:17 -0800 (PST)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nIuse-0003ic-Pd; Sat, 12 Feb 2022 17:04:12 +0100
Received: from pengutronix.de (unknown [195.138.59.174])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 5A21C31CF2;
        Sat, 12 Feb 2022 16:04:11 +0000 (UTC)
Date:   Sat, 12 Feb 2022 17:04:08 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     netdev@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        linux-can@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH iproute2] iplink_can: print_usage: typo fix, add missing
 spaces
Message-ID: <20220212160408.onqpa3epiyqmlfmp@pengutronix.de>
References: <20220212132727.3710-1-mailhol.vincent@wanadoo.fr>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="6m6j62kqilyrg552"
Content-Disposition: inline
In-Reply-To: <20220212132727.3710-1-mailhol.vincent@wanadoo.fr>
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


--6m6j62kqilyrg552
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 12.02.2022 22:27:27, Vincent Mailhol wrote:
> The can help menu misses three spaces for the TDCV, TDCO and TDCF
> parameters, making the closing curly bracket unaligned.
>=20
> For reference, before this patch:
>=20
> | $ ip link help can
> | Usage: ip link set DEVICE type can
> | 	[ bitrate BITRATE [ sample-point SAMPLE-POINT] ] |
> | 	[ tq TQ prop-seg PROP_SEG phase-seg1 PHASE-SEG1
> |  	  phase-seg2 PHASE-SEG2 [ sjw SJW ] ]
> |
> | 	[ dbitrate BITRATE [ dsample-point SAMPLE-POINT] ] |
> | 	[ dtq TQ dprop-seg PROP_SEG dphase-seg1 PHASE-SEG1
> |  	  dphase-seg2 PHASE-SEG2 [ dsjw SJW ] ]
> | 	[ tdcv TDCV tdco TDCO tdcf TDCF ]
> |
> | 	[ loopback { on | off } ]
> | 	[ listen-only { on | off } ]
> | 	[ triple-sampling { on | off } ]
> | 	[ one-shot { on | off } ]
> | 	[ berr-reporting { on | off } ]
> | 	[ fd { on | off } ]
> | 	[ fd-non-iso { on | off } ]
> | 	[ presume-ack { on | off } ]
> | 	[ cc-len8-dlc { on | off } ]
> | 	[ tdc-mode { auto | manual | off } ]
> |
> | 	[ restart-ms TIME-MS ]
> | 	[ restart ]
> |
> | 	[ termination { 0..65535 } ]
> |
> | 	Where: BITRATE	:=3D { NUMBER in bps }
> | 		  SAMPLE-POINT	:=3D { 0.000..0.999 }
> | 		  TQ		:=3D { NUMBER in ns }
> | 		  PROP-SEG	:=3D { NUMBER in tq }
> | 		  PHASE-SEG1	:=3D { NUMBER in tq }
> | 		  PHASE-SEG2	:=3D { NUMBER in tq }
> | 		  SJW		:=3D { NUMBER in tq }
> | 		  TDCV		:=3D { NUMBER in tc}
> | 		  TDCO		:=3D { NUMBER in tc}
> | 		  TDCF		:=3D { NUMBER in tc}
> | 		  RESTART-MS	:=3D { 0 | NUMBER in ms }
>=20
> ... and after this patch:
>=20
> | $ ip link help can
> | Usage: ip link set DEVICE type can
> | 	[ bitrate BITRATE [ sample-point SAMPLE-POINT] ] |
> | 	[ tq TQ prop-seg PROP_SEG phase-seg1 PHASE-SEG1
> |  	  phase-seg2 PHASE-SEG2 [ sjw SJW ] ]
> |
> | 	[ dbitrate BITRATE [ dsample-point SAMPLE-POINT] ] |
> | 	[ dtq TQ dprop-seg PROP_SEG dphase-seg1 PHASE-SEG1
> |  	  dphase-seg2 PHASE-SEG2 [ dsjw SJW ] ]
> | 	[ tdcv TDCV tdco TDCO tdcf TDCF ]
> |
> | 	[ loopback { on | off } ]
> | 	[ listen-only { on | off } ]
> | 	[ triple-sampling { on | off } ]
> | 	[ one-shot { on | off } ]
> | 	[ berr-reporting { on | off } ]
> | 	[ fd { on | off } ]
> | 	[ fd-non-iso { on | off } ]
> | 	[ presume-ack { on | off } ]
> | 	[ cc-len8-dlc { on | off } ]
> | 	[ tdc-mode { auto | manual | off } ]
> |
> | 	[ restart-ms TIME-MS ]
> | 	[ restart ]
> |
> | 	[ termination { 0..65535 } ]
> |
> | 	Where: BITRATE	:=3D { NUMBER in bps }
> | 		  SAMPLE-POINT	:=3D { 0.000..0.999 }
> | 		  TQ		:=3D { NUMBER in ns }
> | 		  PROP-SEG	:=3D { NUMBER in tq }
> | 		  PHASE-SEG1	:=3D { NUMBER in tq }
> | 		  PHASE-SEG2	:=3D { NUMBER in tq }
> | 		  SJW		:=3D { NUMBER in tq }
> | 		  TDCV		:=3D { NUMBER in tc }
> | 		  TDCO		:=3D { NUMBER in tc }
> | 		  TDCF		:=3D { NUMBER in tc }
> | 		  RESTART-MS	:=3D { 0 | NUMBER in ms }
>=20
> Fixes: 0c263d7c36ff ("iplink_can: add new CAN FD bittiming parameters:
> Transmitter Delay Compensat ion (TDC)")
> Signed-off-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Acked-by: Marc Kleine-Budde <mkl@pengutronix.de>

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--6m6j62kqilyrg552
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmIH2nUACgkQrX5LkNig
011TgQf/bVnlJ/0EpsF6KsZdi8xj0YUk/ATmgwTH9E3fN5RRwBqsI7F2MJo05g9a
3BxZffX2QbZ4MjQ3BqxzA1Ocn1GFv1eAlujQWzgyXCx1WGN3mpqhovsScjuk3j8G
dd5BGx6GxutdNpAhRrUCSkEXKoQVldrFxMH43lFH2ufykmVW0nqvAw92YeS3ELxO
fFUONQ5SC/bQctvgWPkgeVGrzC4ctqIu2/2IsIZBBoWT9T+ThTlDfwRL0bqrSgrK
EZQb3BBn0kwYFX0vXHrkXHkmz+I3go/kT7kzk7HKRGkKVBQIej8YgphHbErgCqkt
1HbXNV6r3bYSu01ie3Enaojp/zt/jA==
=Wh+y
-----END PGP SIGNATURE-----

--6m6j62kqilyrg552--
