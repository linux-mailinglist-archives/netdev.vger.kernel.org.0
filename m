Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0EA76C83B4
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 18:50:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231645AbjCXRul (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 13:50:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231671AbjCXRub (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 13:50:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88DE11A67B
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 10:50:00 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pflWy-0001Xe-J2; Fri, 24 Mar 2023 18:48:48 +0100
Received: from pengutronix.de (unknown [IPv6:2a01:4f8:1c1c:29e9:22:41ff:fe00:1400])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id F120019BAE9;
        Fri, 24 Mar 2023 17:48:46 +0000 (UTC)
Date:   Fri, 24 Mar 2023 18:48:46 +0100
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Frank Jungclaus <frank.jungclaus@esd.eu>
Cc:     linux-can@vger.kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
        Stefan =?utf-8?B?TcOkdGpl?= <stefan.maetje@esd.eu>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] can: esd_usb: Improve code readability by means of
 replacing struct esd_usb_msg with a union
Message-ID: <20230324174846.izruwh6evo2yvn7j@pengutronix.de>
References: <20230222163754.3711766-1-frank.jungclaus@esd.eu>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="bvdrty76npd6pz24"
Content-Disposition: inline
In-Reply-To: <20230222163754.3711766-1-frank.jungclaus@esd.eu>
X-SA-Exim-Connect-IP: 2a0a:edc0:0:b01:1d::7b
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
X-Spam-Status: No, score=-2.3 required=5.0 tests=RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--bvdrty76npd6pz24
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 22.02.2023 17:37:54, Frank Jungclaus wrote:
> As suggested by Vincent Mailhol, declare struct esd_usb_msg as a union
> instead of a struct. Then replace all msg->msg.something constructs,
> that make use of esd_usb_msg, with simpler and prettier looking
> msg->something variants.
>=20
> Link: https://lore.kernel.org/all/CAMZ6RqKRzJwmMShVT9QKwiQ5LJaQupYqkPkKjh=
RBsP=3D12QYpfA@mail.gmail.com/
> Suggested-by: Vincent MAILHOL <mailhol.vincent@wanadoo.fr>
> Signed-off-by: Frank Jungclaus <frank.jungclaus@esd.eu>

Applied to linux-can-next.

regards,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129  |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--bvdrty76npd6pz24
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQd4nsACgkQvlAcSiqK
BOh5CQgArhe7G5ZaiycZsxZx7Oq7wIPTZUb/Vc9ALgHmWuun4UfFWv7vyG9hJ5FE
Nyx/4pleb8dtRQcEZFjjaVze1lLQP0zk686k3YMGHfqvSyHGZnPUID9YDc67aN55
FLaO3pL1P0Rnp56+yKKSIkQzGbB11+Vf2KFnjIilchfoM8jGXdnyrscbNRlj1Z5A
5S3BiLVhV8ZlufYh5WLyjL7mIdV3UFJy2EypDfnGK9NjpD1KGHreRiKUeLOqgeKI
gctb7vSV3+RNwi9xGmLoTEIxhbgNfhDAGP0dDEoi1ysIsyTdfwbfhxt/dkPpws4b
c91YHigS0OSF9VGm9KheQbUJ+bN+GQ==
=KgKF
-----END PGP SIGNATURE-----

--bvdrty76npd6pz24--
