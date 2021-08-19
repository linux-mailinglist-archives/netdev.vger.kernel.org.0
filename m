Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A896E3F14A3
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237001AbhHSH5l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:57:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236814AbhHSH5k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 03:57:40 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F294C061756
        for <netdev@vger.kernel.org>; Thu, 19 Aug 2021 00:57:04 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1mGcv1-0005Gs-Hd; Thu, 19 Aug 2021 09:56:55 +0200
Received: from pengutronix.de (unknown [IPv6:2a02:810a:8940:aa0:5b60:c5f4:67f4:2e1e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id 68B0D66A457;
        Thu, 19 Aug 2021 07:56:52 +0000 (UTC)
Date:   Thu, 19 Aug 2021 09:56:50 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        David Jander <david@protonic.nl>
Subject: Re: [PATCH v2 0/3] can: provide GPIO based termination
Message-ID: <20210819075650.xc6qkbos6znasyax@pengutronix.de>
References: <20210818071232.20585-1-o.rempel@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pl7hawpdzdrcfg4j"
Content-Disposition: inline
In-Reply-To: <20210818071232.20585-1-o.rempel@pengutronix.de>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pl7hawpdzdrcfg4j
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 18.08.2021 09:12:29, Oleksij Rempel wrote:
> changes v3:
> - use u32 instead of u16 for termination-ohms
> - extend error handling
>=20
> changes v2:
> - add CAN_TERMINATION_GPIO_MAX
> - remove fsl,scu-index from yaml example. It is not used on imx6q
>=20
> Oleksij Rempel (3):
>   dt-bindings: can-controller: add support for termination-gpios
>   dt-bindings: can: fsl,flexcan: enable termination-* bindings
>   can: dev: provide optional GPIO based termination support

Applied to linux-can-next/testing

Thanks,
Marc
--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--pl7hawpdzdrcfg4j
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmEeDsAACgkQqclaivrt
76mSfwf/dfvCL7pDwDqDSoM7OVCAM4dONYFMYDBg241hlE0YRCsH2Kgym0rG71EQ
Z44O3yuvXqzQWNNNdrqOmmrNt3J6H9kpo955cfwElfgFrAI+GkrUC/TLdg1TwZXh
l9gZqnp6Dq4Kis6FPkiRIsvHWTfwsRUzDCVz5IZiAlOryoKIij7yX7ljXAgvLmxn
3dbBSku0TFuz7HJ6iX/uWpbtZ2/t9hmUyntPXv7C9XWqKgueyKy3fEOLYzXAd5K9
FIuT6tfqn3cAUgIyFoO/3eKJFInhfNYBTLF7Dk+5YDuDkjVlcaEa+XntRSo6S842
GFASKuVSLM2kkSYU7Gy6jjYif1JOQA==
=PcYP
-----END PGP SIGNATURE-----

--pl7hawpdzdrcfg4j--
