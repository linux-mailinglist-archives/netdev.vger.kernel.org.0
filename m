Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A7B8CFF5
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:46:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfHNJqG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:46:06 -0400
Received: from sauhun.de ([88.99.104.3]:46980 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725265AbfHNJqG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 05:46:06 -0400
Received: from localhost (p54B33326.dip0.t-ipconnect.de [84.179.51.38])
        by pokefinder.org (Postfix) with ESMTPSA id 902EF2C311C;
        Wed, 14 Aug 2019 11:46:03 +0200 (CEST)
Date:   Wed, 14 Aug 2019 11:46:03 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S . Miller" <davem@davemloft.net>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        linux-can@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] can: rcar_can: Remove unused platform data support
Message-ID: <20190814094603.GB1511@ninjato>
References: <20190814092221.12959-1-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SkvwRMAIpAhPCcCJ"
Content-Disposition: inline
In-Reply-To: <20190814092221.12959-1-geert+renesas@glider.be>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SkvwRMAIpAhPCcCJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 14, 2019 at 11:22:21AM +0200, Geert Uytterhoeven wrote:
> All R-Car platforms use DT for describing CAN controllers.
> R-Car CAN platform data support was never used in any upstream kernel.
>=20
> Move the Clock Select Register settings enum into the driver, and remove
> platform data support and the corresponding header file.
>=20
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Not tested on HW, but double-checked there are no users in-tree, there
is no dangling pdata pointer left in the driver, visual review of the
moved block, and build-tested.

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--SkvwRMAIpAhPCcCJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl1T2FoACgkQFA3kzBSg
KbYgsxAAoYdxzJnOyenR92qQswpVrJibp9k656vQXf/t3C5LdbpCDryOU9QOJ9/P
XznxB/fQkAMI0Xkt8t14bZux9euO9LB+zTvAPKr8wwrjaqVQPqGw1J8xchvTBlY0
1PLNrk0g+06teky5cWcqgDC7TUGplpH0oMZChfPDAmYocEU2qskLE8U+PfgpwhT/
okyO8N9ve/jUpn4CjqFdVANCSHWuhg8O4jo+776gq5VoFT3NEl3dRHU+Mq2RI8fz
6Mt89ohdbSv5Ujb5RSgJsOKmI0UijvQ8Y48ig+TZhphfHYxVvYW9PVU9MXOQWDEL
gv0cJwcHL/hzJcxg8cOTv7EcmRjqq8HHZp1ypmRGqfjE3BnhYu5cmhDei3EccMmC
afLNEX03YC2lJffupgVlMIx7O2XPuJRBCzok9ueN2hsmxBCFy++Aj9pl2wwwIWJc
Yb0IKvZofzeQnIl/RrR91xbfexAScQwL9FEmox1tnKxTQY4RtKlEE2Y+NI46c9Bj
K3ZIbkgAxYfu4eVVPwG7YcbA9f8H+xkIcuTi7CWKx7s4rHzTU22IShGuFIGk8AGa
rh6PD9ivSf14usYTMZvigdF1sB3PBh1pAu0MYj66Kuw2gu0UXpLXZl8jr4mRFH6I
806iNlAze67mdl0qJUQf2s2EIVyaX3j5KrXycFf7lcEBFU+wEWk=
=62lr
-----END PGP SIGNATURE-----

--SkvwRMAIpAhPCcCJ--
