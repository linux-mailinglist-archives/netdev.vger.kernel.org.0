Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2DCA1D6D64
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 23:08:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726700AbgEQVIk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 17:08:40 -0400
Received: from sauhun.de ([88.99.104.3]:33722 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726288AbgEQVIk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 17:08:40 -0400
Received: from localhost (p5486C87C.dip0.t-ipconnect.de [84.134.200.124])
        by pokefinder.org (Postfix) with ESMTPSA id 59E902C049C;
        Sun, 17 May 2020 23:08:37 +0200 (CEST)
Date:   Sun, 17 May 2020 23:08:37 +0200
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
Subject: Re: [PATCH 17/17] ARM: dts: r8a7742: Add RWDT node
Message-ID: <20200517210837.GL1370@kunai>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-18-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="L1EIGrW/+75u5Nmw"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-18-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--L1EIGrW/+75u5Nmw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:57PM +0100, Lad Prabhakar wrote:
> Add a device node for the Watchdog Timer (RWDT) controller on the Renesas
> RZ/G1H (r8a7742) SoC.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

The DTS change looks fine, I checked it against similar SoCs (like the
previous patched). So, for that:

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>

However, just to make sure, have you checked the WDT (especially reboot)
with SMP and multiple CPU cores enabled? Some early Gen2 SoCs had issues
there.


--L1EIGrW/+75u5Nmw
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7Bp9UACgkQFA3kzBSg
KbYEshAAosauCUFrzQlQlXv4wH1aOYquXgPvrPAxwbdOQrOJ3fJxzVrUgTiaPyGq
yNcpBusF53fs7P2kVCRY7N3shXgrF8Ypa3C+JuY1Yb6xYATbfF3+XNMLfggcBThs
htV0h0//jTN88J/2HYCalL31c73sMwBF7ItAMS/EU3KqzAKDMXJ2Sc4MV2FlU+3C
MyvJKNgdjXYqOj/tdzkcB4BM4MCp9nHwkyS8sWx1jUaLwtenNVHtnJrNaLn5CFo0
Q0YGgiM9shefCoMpqcuHNdxCT7qBjc+3dz0vYqwtPqthA+uYdkawI6bDMOFwI83n
3O2Qgf1xeRY/JoI/kGcQies+09BaDN4HZ0NflEtWfetZ3DsIcQBuZ6menbYu8oG+
D/h2oC9JeamOLn3deWz4Lfhnb8f7HDgzAHDrooFjqHgFetzOgZuj4QLoQH/Tz1T2
4jRGfiN5qub1LnAI/D/joDp+VAV4UltJTCfM60OtToXX6fV04IWl2tLnCRLwoAIY
rbRXQba9CBkGQZcerCI+jyy5df+flRx7WUND0lgdcgL8Qwqdz4KOGlSeE7yOZIV5
zA37gqwG34M0PWpcFTbby4Wjjf99QY9uCvIrgWEqPd7bnouS6CtdGLWxW8KD5CwO
k0nK6so1jXOIZ0L4XVO2n1muTpw6KN9GmNtOIi2A3nuYHlGROs8=
=DE4O
-----END PGP SIGNATURE-----

--L1EIGrW/+75u5Nmw--
