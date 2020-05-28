Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BD4E1E5B0D
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 10:41:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgE1Ikz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 04:40:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727076AbgE1Ikz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 04:40:55 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1CE2C05BD1E
        for <netdev@vger.kernel.org>; Thu, 28 May 2020 01:40:54 -0700 (PDT)
Received: from pty.hi.pengutronix.de ([2001:67c:670:100:1d::c5])
        by metis.ext.pengutronix.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ore@pengutronix.de>)
        id 1jeE5s-0007EX-Ln; Thu, 28 May 2020 10:40:52 +0200
Received: from ore by pty.hi.pengutronix.de with local (Exim 4.89)
        (envelope-from <ore@pengutronix.de>)
        id 1jeE5s-0000jg-5l; Thu, 28 May 2020 10:40:52 +0200
Date:   Thu, 28 May 2020 10:40:52 +0200
From:   Oleksij Rempel <o.rempel@pengutronix.de>
To:     Amit Cohen <amitc@mellanox.com>
Cc:     "andrew@lunn.ch" <andrew@lunn.ch>, mlxsw <mlxsw@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Link down reasons
Message-ID: <20200528084052.n7yeo2nu2vq4eibv@pengutronix.de>
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="tfpyp7njgzy3jrhi"
Content-Disposition: inline
In-Reply-To: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com>
X-Sent-From: Pengutronix Hildesheim
X-URL:  http://www.pengutronix.de/
X-IRC:  #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 10:35:23 up 194 days, 23:53, 197 users,  load average: 0.09, 0.06,
 0.03
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: 2001:67c:670:100:1d::c5
X-SA-Exim-Mail-From: ore@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--tfpyp7njgzy3jrhi
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, May 27, 2020 at 03:41:22PM +0000, Amit Cohen wrote:
> Hi Andrew,
> We are planning to send a set that exposes link-down reason in ethtool.
> It seems that the ability of your set "Ethernet cable test support" can b=
e integrated with link-down reason.
>=20
> The idea is to expose reason and subreason (if there is):
> $ ethtool ethX
> ...
> Link detected: no (No cable) // No sub reason
>=20
> $ ethtool ethY
> Link detected: no (Autoneg failure, No partner detected)
>=20
> Currently we have reason "cable issue" and subreasons "unsupported cable"=
 and "shorted cable".
> The mechanism of cable test can be integrated and allow us report "cable =
issue" reason and "shorted cable" subreason.
>=20
> However, the way the kernel reports the results of the cable test (cable-=
test, some seconds, get-result) may be problematic with link-down reason co=
ncept.
> We can ignore this information when reporting link-down reason, or report=
 only if testing cable have a result,
> or maybe start testing cable and meanwhile report something like "discove=
ry in progress". But all the options are not perfect.
>=20
> We would like to know your opinion about it.

I would add some more reasons:
- master slave resolution issues: both link partners are master or
  slave.
- signal quality drop. In this case driver should be extended to notify
  the system if SQI is under some configurable limit.


Regards,
Oleksij
--=20
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--tfpyp7njgzy3jrhi
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEERBNZvwSgvmcMY/T74omh9DUaUbMFAl7PePsACgkQ4omh9DUa
UbOVCA/+ProMkhgRXNeff+0WPcS5m4iiojcXg/WiX7nZqrH+jhPHsxSDSSArNhf/
heMMCzaBblBcQz5JWkeloEKcLhKrmGx9oz3G7Yx605KMidZSSWO2T94/2+eJWD6k
/sX/GkBK3306jEvwb0MLJlXz8sLJTpkJWfQFQCkNenlf59zY3qISnUvll3RUiKTC
nJarGoegSbYb2/YZP3g5lTPPkcowOSSmyrsBk5JO8POofH8OrCuJDzeYGDLTpBWy
Lde/zm5M8cjOQwUtL3gU8ooxKEZb4HlDebrKa/e3QK804ZMm+XV7FN76fXfQm3Ci
zxVeXTHg3nqTwwEo7WtyXxk8X1KSIsS9umaBGIlrR4PXJhz7MWx1OaAGGA+SMILc
OPdyNixBODaR06YD9y1Zf8nGoCRmVcFZT3uf8VahOEiBTQwyCPt+u8PVrcodiSQ2
kN+S26lyEtqemBPFqBj7cSJSYw7PGt5E2zxT6heP5ETSPvWHAWuFAJ4jdSO9j4Ft
j+OS67m6ih9lOaEeUe57I1Mf4kgdIsCvmr/wbPRIqmivAmSE2OEhZRsmysXI35JW
Vr2MlmJ937eWmKMul1U2TWlLw47ZTKtYjjgXfkrC10sVNtIlIYdgbmWqxBjytaEh
2dLKgZz0mP9fgwL4XY5nHFz8cqTidHEb0fd6PfG+kHANU3o2a+Y=
=SX/H
-----END PGP SIGNATURE-----

--tfpyp7njgzy3jrhi--
