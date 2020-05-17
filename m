Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C0751D6D2F
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 22:59:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbgEQU7R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 16:59:17 -0400
Received: from sauhun.de ([88.99.104.3]:33472 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgEQU7Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 16:59:16 -0400
Received: from localhost (p5486C87C.dip0.t-ipconnect.de [84.134.200.124])
        by pokefinder.org (Postfix) with ESMTPSA id 952EA2C2059;
        Sun, 17 May 2020 22:59:13 +0200 (CEST)
Date:   Sun, 17 May 2020 22:59:13 +0200
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
Subject: Re: [PATCH 11/17] dt-bindings: net: renesas,ether: Document R8A7742
 SoC
Message-ID: <20200517205913.GF1370@kunai>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="Il7n/DHsA0sMLmDu"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-12-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--Il7n/DHsA0sMLmDu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:51PM +0100, Lad Prabhakar wrote:
> Document RZ/G1H (R8A7742) SoC bindings.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--Il7n/DHsA0sMLmDu
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7BpaEACgkQFA3kzBSg
KbbGaBAAnja06QWDz+YytY62tge8WuUV4s+xaSNhh8pbJQxXssP2DyVPxiSKkN1l
6z1qRglhlByPx/wgTy9Jfy5BmdXa9mZ3gzE8sXNcqVoy643N9MSYIJVWz3d8OpxK
HPt08tvLwWFWK5w8HC9TDz/Tssy/9LsPIlDiLlZ+hYhpbLISz9OvQ9YTPYbfnquk
a/pE2sbf0q7I0K3mi7fLfbu64+SIC/KhwhC9DQ9QZxTwBCCukSYCcQfMBHoV2Xfr
e+uqxYLIW+4Nc9gRMBmdG3cQEfz712iXyrCqmqplPkOTUIVyuVOZFHa3JHKZcSzu
2KcOGovIjJ+BECS5iilixIEkpXGgfn+H6QSjye1bIHMHtjn5DGslDS7IrarU5byQ
WMzel5GOqS/iWR6O/ScBzMVYEcgBMvlNw+VWp0cSqKfjmTzfLWtJddEKHK6ffUhb
gOpGTVKghxgjObe9Qi6GGdfc38x/P/jDQQrobYAgok2aMiczSdkJBQgYJblScBdv
Y38B4cwD7uTzRXvSrKLl+EHcd2xVvtC+Sm+pnkJqMivgrhlPHjsaMUxARleyTEAn
i0CBLydsJ2lNzPGPmsuz86fp6pJS85WmMc89CDbZ83vShm/Mb4veVWJUVCDyuX5L
dkkGd8fQI/7tibgZv7TiA4Iuns52I18S8vyOMgT+IFEoduaXhpE=
=EnDg
-----END PGP SIGNATURE-----

--Il7n/DHsA0sMLmDu--
