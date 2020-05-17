Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 215461D6D35
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 23:01:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgEQVBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 17:01:02 -0400
Received: from sauhun.de ([88.99.104.3]:33516 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgEQVBC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 17:01:02 -0400
Received: from localhost (p5486C87C.dip0.t-ipconnect.de [84.134.200.124])
        by pokefinder.org (Postfix) with ESMTPSA id 4F1FB2C049C;
        Sun, 17 May 2020 23:00:59 +0200 (CEST)
Date:   Sun, 17 May 2020 23:00:58 +0200
From:   Wolfram Sang <wsa@the-dreams.de>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
        Wolfram Sang <wsa+renesas@sang-engineering.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        "David S. Miller" <davem@davemloft.net>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Guenter Roeck <linux@roeck-us.net>, linux-ide@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-mmc@vger.kernel.org,
        netdev@vger.kernel.org, linux-renesas-soc@vger.kernel.org,
        linux-watchdog@vger.kernel.org,
        Prabhakar <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH 12/17] ARM: dts: r8a7742: Add Ethernet AVB support
Message-ID: <20200517210058.GG1370@kunai>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-13-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IuhbYIxU28t+Kd57"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-13-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IuhbYIxU28t+Kd57
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:52PM +0100, Lad Prabhakar wrote:
> Add Ethernet AVB support for R8A7742 SoC.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--IuhbYIxU28t+Kd57
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7BpgoACgkQFA3kzBSg
KbbuDg/+JR8UKngUF0xAZKlU4HYqgE25eGks8AOBKzA75IcU2YvzDNmE9y9vnArX
KnBLUOA2QVxnx0WVEJ49NbId/ieFVXO9zuV0TEIP2ld4XYsnNymXB7ffzatAMYGc
G6sIXIXAtcUTx+tD5M9n2PoYBnBEYAmaNA8rOTDHINlyRus1BiyiZGOzBs+ol7Iv
b+zzkV3njJ0ajEGce8/jBTIvAYlRwwGjwJsjpnomCFzcWTGtOun471a9jou6bFcv
Utlwl0Z58jjEKj9MhB9wgSUsx3QBGeu3M6R+P2oTbWuqjagqN7EvwteSEEjRQyCY
nvPn02yN06F4a89rIgIK9c4/aFCgW7n2SH/S/Z40Em1bOdzkVjef08qXDTkQ8Mdt
D8iL/6mYiLEvKgbFHfe/dv8QfH/RXZ5U4Bs7HpqIl6o1sR/OCPeaD38UuR82ujAc
33ZkkNfy+FH05HVFQ+uyuT3DIHczKkr9SHp1D/KCz08jBgZLJDjqw8hIKL+gAnCI
7PfBoyYpLw/JbKzJh+JLYZLxbq+POlhon9DJGKPMCK66ze2hDZyxGC1xMm5la47I
oVm8HTWKSmDJqT8UFn10m5cZCRFXFiEdUvFar4JeY9xUAstzSiXoGzKMAzXzlsb0
AnQziR907qXpL7wQgzyNDt2MbhcA+RVzPjEsU4uDGB4MjXawTkA=
=2rVA
-----END PGP SIGNATURE-----

--IuhbYIxU28t+Kd57--
