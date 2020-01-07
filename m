Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D0C713303F
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 21:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728729AbgAGUEI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 15:04:08 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36058 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728358AbgAGUEI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 15:04:08 -0500
Received: from [167.98.27.226] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1iov59-0002jq-C1; Tue, 07 Jan 2020 20:04:03 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1iov58-006ywd-Bs; Tue, 07 Jan 2020 20:04:02 +0000
Message-ID: <bc4aa741a1da2e4929af072c93566c20729eb687.camel@decadent.org.uk>
Subject: Re: Please backport "mwifiex: Fix NL80211_TX_POWER_LIMITED" to
 stable branches
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Adrian Bunk <bunk@kernel.org>, netdev@vger.kernel.org
Cc:     Amitkumar Karwar <amitkarwar@gmail.com>,
        Nishant Sarmukadam <nishants@marvell.com>,
        Ganapathi Bhat <gbhat@marvell.com>,
        Xinming Hu <huxinming820@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 07 Jan 2020 20:04:01 +0000
In-Reply-To: <20191122172431.GA24156@localhost>
References: <20191122172431.GA24156@localhost>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-74YX61Llp/MokHE9JvDf"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 167.98.27.226
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--=-74YX61Llp/MokHE9JvDf
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-11-22 at 19:24 +0200, Adrian Bunk wrote:
> Please backport commit 65a576e27309120e0621f54d5c81eb9128bd56be
> "mwifiex: Fix NL80211_TX_POWER_LIMITED" to stable branches.
>=20
> It is a non-CVE kind of security issue when a wifi adapter
> exceeds the configured TX power limit.
>=20
> The commit applies and builds against all branches from 3.16 to 4.19,=20
> confirmed working with 4.14. It is already included in kernel 5.3.

Queued up for 3.16, thanks.

Ben.

--=20
Ben Hutchings
Larkinson's Law: All laws are basically false.



--=-74YX61Llp/MokHE9JvDf
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4U5DEACgkQ57/I7JWG
EQk2dxAAmPYtcxPbw0b9aGdDzzHzY6kP+toPYhl9H01J+fy+0zqENAKzTrSKm0Rp
JEiLmSF2y/HRCvy1CKAvZjpfa/32yo9HWyeyYemQkLCJChNP8An4CUoQQKaf+EF0
yIq3ZNDpJLv6fL1EeyWMSmBVRSJmFbDpJt2R6OiO1UlnaCgpGRbyW1GgyRf2Iy0a
d5NujUUrFU6PNNHaP1aUUvVl7cEPQsxg9glmURz9dGZ6I2vAjZAHksYThJ9Cp/EQ
5N5QeYaAP+VPFIwrHD8PbBt3QqaB/qN6mKVYJQ0jon5WmN4v+3+Ps9oVy/d3hv0L
IARiS+Z0G4MzZJzgfebA2HvhCgAcars6iWWdHKd3a+Xa/cr/lscLfSh5LUZWL8Dw
lNk7jUPjZJMGHKu+e3hX9QxJS7NIik83W2noHHezCwneVpKZrB+1ACqT61AlZ6+c
Hrs2zAODLqx9Iu2zi8lyRUDVmqBx8rsuVjayGBTd/ulMoOJrA9+t5DyyAPGKOTB8
e/Z8iP8qBhxMGU/ddLlImeXdOx0nfTpEIuvPMQIbpYYLdxes+Epfr+o3OY+k8R59
ZMvCvPcXMknXbOajYCWG7I6k0eForw8oI6zjQgQ/PWg9fPfi1lEfgcIG5MjIh/iq
kJlNb2lpDOcuPM3ULqIEbwCDtI4DnEXGgw7BoA+G5qvvG+ShR74=
=sTMY
-----END PGP SIGNATURE-----

--=-74YX61Llp/MokHE9JvDf--
