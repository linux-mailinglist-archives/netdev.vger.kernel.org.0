Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 37DFA757D8
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 21:27:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbfGYT1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 15:27:07 -0400
Received: from sauhun.de ([88.99.104.3]:55094 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726597AbfGYT1H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 15:27:07 -0400
Received: from localhost (p5486CDF3.dip0.t-ipconnect.de [84.134.205.243])
        by pokefinder.org (Postfix) with ESMTPSA id 0AFF54A1209;
        Thu, 25 Jul 2019 21:27:04 +0200 (CEST)
Date:   Thu, 25 Jul 2019 21:27:04 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Edward Cree <ecree@solarflare.com>
Cc:     David Miller <davem@davemloft.net>,
        wsa+renesas@sang-engineering.com, linux-i2c@vger.kernel.org,
        linux-net-drivers@solarflare.com, mhabets@solarflare.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: sfc: falcon: convert to i2c_new_dummy_device
Message-ID: <20190725192704.GB1440@kunai>
References: <20190722172635.4535-1-wsa+renesas@sang-engineering.com>
 <20190724.154739.72147269285837223.davem@davemloft.net>
 <72968faa-e260-3640-99be-9c63bc79ad5e@solarflare.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="p4qYPpj5QlsIQJ0K"
Content-Disposition: inline
In-Reply-To: <72968faa-e260-3640-99be-9c63bc79ad5e@solarflare.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--p4qYPpj5QlsIQJ0K
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> >> Move from i2c_new_dummy() to i2c_new_dummy_device(). So, we now get an
> >> ERRPTR which we use in error handling.
> >>
> >> Signed-off-by: Wolfram Sang <wsa+renesas@sang-engineering.com>
>=20
> Subject & description are incomplete, you're also changing i2c_new_device=
()
>  to i2c_new_client_device().

Right, this was an anomaly with this patch to have both code paths
returning an ERRPTR. The big conversion for i2c_new_device will come
later in a seperate series.

> Other than that,
> Acked-by: Edward Cree <ecree@solarflare.com>

Thanks!


--p4qYPpj5QlsIQJ0K
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl06AogACgkQFA3kzBSg
KbbqPw/+I8J47byhVJzk1I9WnVJH6a4uo6kzDKO3hB3ESzbKzRKhyP4Xfb9KNV/Z
e2tkr2/0GRgJRiPEVmnHmeFf365heKGNovJ2uDqC/kXJzzg3o3Nr1Xv01x36s2uD
zkuna+fb03fD9UaIrrDhnmwCNJfPM4wy/0EF43nbeknyIOpmJhnPysE4vlVpUZcR
VANt4BYUTxcdf96/AWlCgdSJ/blDAeDQ7vMxRGEXEq6OaHS/uKSb3GuOMeb4dCZR
dqMcyosih7qcaqyZCRR4ChIvAXxUzxP1AqxaVyBtMsJ0ruqJ+S+vMZ3k9qbLS750
47kSU2sq2ttR4BhgQczpcq+aft2FTcreXbk3U+zQjMGnPZEnSnWC3Usyr5TU3kLv
DLK5+HvGYe222qmnoTWJrdBIBNqIy0989PbHSwzKDo8wsMpzOW5MGQUVISc1OVhr
qiOaQ9sfxsw++veEuwgjbx63Gto7RLYoCleJy8bdj/4sVPsuStEr+7jtuSFsDmuM
WFulVRG4TCVYDf+Lp6mWvil3nX7lfsA7BCXeDgTZes4Ro5AJcMQ8s8dtW3Vjgcb6
D81f76OaRrJ2l6691GNoa92L95V3H8RoWbJZuVTRhnzDHFtmZ2kRtoDkCRrzq0Oe
K2jAhc4XUA6gDswN5Mi7F785gXnO5626gYnvxt3twlYuHyVEpOs=
=/BXX
-----END PGP SIGNATURE-----

--p4qYPpj5QlsIQJ0K--
