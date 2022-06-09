Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 74ED95449CC
	for <lists+netdev@lfdr.de>; Thu,  9 Jun 2022 13:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235094AbiFILPI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jun 2022 07:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234050AbiFILPH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jun 2022 07:15:07 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9655E30F5F
        for <netdev@vger.kernel.org>; Thu,  9 Jun 2022 04:15:06 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1nzG7p-0000Bd-Tr; Thu, 09 Jun 2022 13:14:53 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 625239005B;
        Thu,  9 Jun 2022 11:14:51 +0000 (UTC)
Date:   Thu, 9 Jun 2022 13:14:50 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Srinivas Neeli <srinivas.neeli@xilinx.com>
Cc:     wg@grandegger.com, davem@davemloft.net, edumazet@google.com,
        srinivas.neeli@amd.com, neelisrinivas18@gmail.com,
        appana.durga.rao@xilinx.com, sgoud@xilinx.com,
        michal.simek@xilinx.com, kuba@kernel.org, pabeni@redhat.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        git@xilinx.com, Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Subject: Re: [PATCH V4] can: xilinx_can: Add Transmitter delay compensation
 (TDC) feature support
Message-ID: <20220609111450.3xzujeaotuxhiynn@pengutronix.de>
References: <20220609103157.1425730-1-srinivas.neeli@xilinx.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="exsvwmuiszhj5uie"
Content-Disposition: inline
In-Reply-To: <20220609103157.1425730-1-srinivas.neeli@xilinx.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--exsvwmuiszhj5uie
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 09.06.2022 16:01:57, Srinivas Neeli wrote:
> Added Transmitter delay compensation (TDC) feature support.
> In the case of higher measured loop delay with higher baud rates,
> observed bit stuff errors. By enabling the TDC feature in
> CANFD controllers, will compensate for the measure loop delay in
> the receive path.
>=20
> Signed-off-by: Srinivas Neeli <srinivas.neeli@xilinx.com>
> Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>

Applied to linux-can-next.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--exsvwmuiszhj5uie
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKh1igACgkQrX5LkNig
013GGAgAkDEQ2tJEeQl8XtbET8qwGIPJ7RtH/bhnaB6f/ezsWnF3aVUMJLULn1YJ
JrPx7iKrTCLtrdwc4woL2GN9p+mCe1qHGElUIDIyUf36XD2X8yKKESSqOJ2Slxo7
70evg11a2DfXrHgKLZCn1c/8MPHL+iJc/chl93KrZdJ1fn3Yr4Pe29sB0I0zakko
aOfyA1ae7SGRUC0DK37zD6xqMmVAfuAhEF62AC0U8PnBcsRbH+FfyuNlvuvdg4GD
xZSvh6jl+zvmGjHwEnP/Uzor0pdd4UpFFo7aNJyeIRcEKSSEWLMXpIe3x8XXDeR9
qFiPAgUwuCqA+vxFcliIWfV6BLPyCA==
=Dm2/
-----END PGP SIGNATURE-----

--exsvwmuiszhj5uie--
