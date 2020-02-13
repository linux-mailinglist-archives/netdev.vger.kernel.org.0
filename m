Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3D20515BB3F
	for <lists+netdev@lfdr.de>; Thu, 13 Feb 2020 10:11:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729712AbgBMJKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Feb 2020 04:10:51 -0500
Received: from sauhun.de ([88.99.104.3]:45284 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729515AbgBMJKv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Feb 2020 04:10:51 -0500
Received: from localhost (p54B33627.dip0.t-ipconnect.de [84.179.54.39])
        by pokefinder.org (Postfix) with ESMTPSA id 06EB52C08AC;
        Thu, 13 Feb 2020 10:10:48 +0100 (CET)
Date:   Thu, 13 Feb 2020 10:10:47 +0100
From:   Wolfram Sang <wsa@the-dreams.de>
To:     "H. Nikolaus Schaller" <hns@goldelico.com>
Cc:     Paul Cercueil <paul@crapouillou.net>,
        Paul Boddie <paul@boddie.org.uk>,
        Alex Smith <alex.smith@imgtec.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andi Kleen <ak@linux.intel.com>,
        Krzysztof Kozlowski <krzk@kernel.org>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Petr =?utf-8?Q?=C5=A0tetiar?= <ynezz@true.cz>,
        Richard Fontana <rfontana@redhat.com>,
        Allison Randal <allison@lohutok.net>,
        Stephen Boyd <swboyd@chromium.org>, devicetree@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-i2c@vger.kernel.org,
        netdev@vger.kernel.org, linux-gpio@vger.kernel.org,
        letux-kernel@openphoenux.org, kernel@pyra-handheld.com
Subject: Re: i2c: jz4780: silence log flood on txabrt
Message-ID: <20200213091047.GB2123@ninjato>
References: <cover.1581457290.git.hns@goldelico.com>
 <7facef52af9cff6ebe26ff321a7fd4f1ac640f74.1581457290.git.hns@goldelico.com>
 <20200212094628.GB1143@ninjato>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="uZ3hkaAS1mZxFaxD"
Content-Disposition: inline
In-Reply-To: <20200212094628.GB1143@ninjato>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--uZ3hkaAS1mZxFaxD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 12, 2020 at 10:46:28AM +0100, Wolfram Sang wrote:
>=20
> The printout for txabrt is way too talkative. Reduce it to the minimum,
> the rest can be gained by I2C core debugging and datasheet information.
> Also, make it a debug printout, it won't help the regular user.
>=20
> Reported-by: H. Nikolaus Schaller <hns@goldelico.com>
> Signed-off-by: Wolfram Sang <wsa@the-dreams.de>

Applied to for-current, thanks!


--uZ3hkaAS1mZxFaxD
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl5FEpcACgkQFA3kzBSg
KbaDmg/+LPu/HFCGDpbL6wSNLy+ddtuDJAdLMW+RLR22jamJt0hmY7Yq5ZkUOeXf
SxZakdTgTh2D20e4hIEePPUa/cU9TaqfFl67OoLwaIMSVxJn2drOIKKPjqnr5Wbr
bKX/GhVDAWzBDvg1tMMFZM1G056Q2t+wU5yePYnGdccwFdiak3BKE/Cve3cwSDyq
hrUIy3ktDy481Cx7q8Lls9rgNGdHEkFPp9cwwT/GkPuPeVOSVQHsZpDcpjlAcMF2
EkPOTN5o4aRLaFU2zoH+3k6vR+Mf/2KkArKvw8sR4cTVidZ/nqfJIE98Od9vOOGw
qMm6JT5bns80N9MbRG21RCZ73yDyFChPk1OthQybZrmMB9WPwGshenRXqgX4IxZh
HRK8HV3d9xRnACbbYsg1SHGtFy0W+FNzU0DEqw5Vg4gZ8P24ZTUEYMghO7BIcv25
e0qVDNa0DveRvh1zcAGkTB2y0wUDd+Ti3X4/pcIN9FKiAArG5YpGy8YJf4jgfVEP
gSeLCyfGrT0rJEzORfLo6dw4VrRqr6znBQ0Wk8IQP5++mXxXx5QN7ybNwflu+z/M
v1579VU4ne2tK8J/+PDZPgciFc8Aj+U8ncDq/zE1+0SdL6HNCXnKO0fh321KgSyK
cFOdRG+9zHBTeV67Gtr4Y/DrKCyacPDTgctE2SLT2FZXRvPwGpw=
=dZR8
-----END PGP SIGNATURE-----

--uZ3hkaAS1mZxFaxD--
