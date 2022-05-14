Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC74C5273FB
	for <lists+netdev@lfdr.de>; Sat, 14 May 2022 22:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235107AbiENUbv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 May 2022 16:31:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235108AbiENUbu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 May 2022 16:31:50 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A652B2F00D
        for <netdev@vger.kernel.org>; Sat, 14 May 2022 13:31:48 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1npyQR-0002Vj-Fx; Sat, 14 May 2022 22:31:43 +0200
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 2C2287E43A;
        Sat, 14 May 2022 20:31:42 +0000 (UTC)
Date:   Sat, 14 May 2022 22:31:41 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Matej Vasilevski <matej.vasilevski@seznam.cz>
Cc:     devicetree@vger.kernel.org, linux-can@vger.kernel.org,
        pisa@cmp.felk.cvut.cz, ondrej.ille@gmail.com,
        netdev@vger.kernel.org, martin.jerabek01@gmail.com
Subject: Re: [RFC PATCH 1/3] can: ctucanfd: add HW timestamps to RX and error
 CAN frames
Message-ID: <20220514203141.6fnk7d2zbrleh3rn@pengutronix.de>
References: <20220512232706.24575-1-matej.vasilevski@seznam.cz>
 <20220512232706.24575-2-matej.vasilevski@seznam.cz>
 <20220513114135.lgbda6armyiccj3o@pengutronix.de>
 <20220514091741.GA203806@hopium>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="d3q7pr7umtzohi4e"
Content-Disposition: inline
In-Reply-To: <20220514091741.GA203806@hopium>
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


--d3q7pr7umtzohi4e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.05.2022 11:18:08, Matej Vasilevski wrote:
> I have nothing substantial to say on this matter, the discussion should
> continue in Pavel's thread.
> I don't mind implementing the .ndo_eth_ioctl.

It's the SIOCSHWTSTAMP ioctl, see:

| https://elixir.bootlin.com/linux/v5.17.7/source/drivers/net/ethernet/free=
scale/dpaa/dpaa_eth.c#L3135

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--d3q7pr7umtzohi4e
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEBsvAIBsPu6mG7thcrX5LkNig010FAmKAEagACgkQrX5LkNig
012eWgf/ULLvb/BCTyvG7U/ijVe+NgCUMf5GgF7AhHmAiTZts9Pt6ap7fNX274hr
qrCwPsz0PEtKMuRWaTkuwysy8+lEKlWxjIvqXL2javwSkjzwTofEsUSOCZOkib0C
Jp9k48LaxwCKI0x4oddCMVTzokUkFAfvEZp8yNYLrx9Nb6F1BISlRsbhzZPAzl4L
Ebr1i/WAvOTayPg7Z9ZGbcb/D8Dt3K4lyHfxlj+KQNIuBjEEEZhCYFTXSKTk19wd
XAN0MUlAFRyZ6vRboMGH5qV99wW49/WiXwXx3dTgVLhKH615YGh9J09zuobcfmAq
FA7RXGaL3TWBBW9FQ+kaWjRbN3jYJQ==
=0aGJ
-----END PGP SIGNATURE-----

--d3q7pr7umtzohi4e--
