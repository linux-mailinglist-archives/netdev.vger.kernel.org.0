Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 142BB6D65C7
	for <lists+netdev@lfdr.de>; Tue,  4 Apr 2023 16:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232227AbjDDOwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Apr 2023 10:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230319AbjDDOwb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Apr 2023 10:52:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57DD83A9C
        for <netdev@vger.kernel.org>; Tue,  4 Apr 2023 07:52:30 -0700 (PDT)
Received: from moin.white.stw.pengutronix.de ([2a0a:edc0:0:b01:1d::7b] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1pji1H-0000It-Kj; Tue, 04 Apr 2023 16:52:23 +0200
Received: from pengutronix.de (unknown [172.20.34.65])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id EEB7D1A67E5;
        Tue,  4 Apr 2023 14:52:21 +0000 (UTC)
Date:   Tue, 4 Apr 2023 16:52:20 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, linux-can@vger.kernel.org,
        kernel@pengutronix.de
Subject: Re: [PATCH net-next 0/10] pull-request: can-next 2023-04-04
Message-ID: <20230404-recopy-bullfight-fa4ff40fdbac@pengutronix.de>
References: <20230404113429.1590300-1-mkl@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="jo2hsbldwlo5zlej"
Content-Disposition: inline
In-Reply-To: <20230404113429.1590300-1-mkl@pengutronix.de>
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


--jo2hsbldwlo5zlej
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 04.04.2023 13:34:19, Marc Kleine-Budde wrote:
> Hello netdev-team,

Please ignore this PR, as there is a typo in one of the subjects.

Sorry for the noise,
Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde          |
Embedded Linux                   | https://www.pengutronix.de |
Vertretung N=C3=BCrnberg              | Phone: +49-5121-206917-129 |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-9   |

--jo2hsbldwlo5zlej
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEDs2BvajyNKlf9TJQvlAcSiqKBOgFAmQsOaIACgkQvlAcSiqK
BOg+rQf9GCElINXEJNYkC/ckiAaBK/hX/QaMDOxhnjU0KM248+eFBCwv4syCGMaD
9tgfWW6K1XSI1cukuOY4ffF1d9B4WuJ0LxUUjECH/90VZ3jnSNnActnxZ2qFg/Sz
Z3z3zOJmmSkdcHPg82Yz8rbHyhPpcHENSqGDT0tLrSeL6izl+ybXZosqXz4yH4Fc
9gQfDfy28mNXfrLTqWtRsCK+yicaYgC9PJHF6/pRA3Y8l4nxFhEalw4kRoNLN3Aq
xP7kOLg+qmrR6GUBFgJXQ84xVFUVxJc+wcwLJW/DZH95+FDrWOKZtSgVYYFicsmC
XboEj94uM+WKLxBYTUH+W0b1zC0XdA==
=B9h4
-----END PGP SIGNATURE-----

--jo2hsbldwlo5zlej--
