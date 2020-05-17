Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8711D6D1B
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 22:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726675AbgEQU5S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 16:57:18 -0400
Received: from sauhun.de ([88.99.104.3]:33384 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726299AbgEQU5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 16:57:16 -0400
Received: from localhost (p5486c87c.dip0.t-ipconnect.de [84.134.200.124])
        by pokefinder.org (Postfix) with ESMTPSA id F000D2C049C;
        Sun, 17 May 2020 22:57:13 +0200 (CEST)
Date:   Sun, 17 May 2020 22:57:13 +0200
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
Subject: Re: [PATCH 09/17] ARM: dts: r8a7742: Add sata nodes
Message-ID: <20200517205713.GD1370@kunai>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-10-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="WChQLJJJfbwij+9x"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-10-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--WChQLJJJfbwij+9x
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:49PM +0100, Lad Prabhakar wrote:
> Add the sata devices nodes to the R8A7742 device tree.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--WChQLJJJfbwij+9x
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7BpSkACgkQFA3kzBSg
KbbWmQ//S0wyjr4Y65XUbx1QahJLOl+oGTTOg1Q3cVvlGaIJkT/zZGX025bPbz9x
fYSibxpIY+goL6viu0BZL3Hf1SFdo4lHi2gcE2bRCwZ1lUNOF67UZ7imHoBFH/la
zl/9I71bNrDbNVD48QYfkJmO4ItGt73tZeuUg3cFh/rb9d/Il87WRNbOFeoJsrCl
MTBUbjSws3zWt0DVJDVZGrWxsgc2395SWXBM5VF0BkgPWSsKEV/VnKdmGZUa3Xt5
l8IlyXKJirTQI0FBKlZdqNFh4GcOV6E9hPapHTo1BZJmceqU/zHZscbceaLhx75z
CfkgSkWei4x+8hobqZm83UVj5ZoIoYIAzJYO1NusUbKzMRQrNB+TImcRO4pE17M7
VEWT3cwr13zTUDrJYyn2MdxLcUfQJ+NQC4bVDrmFpgqZ9av8+R3AXrcS85Z2CWiD
bFXA+W5oNGnQnyjZPMtyYepUIk5hhw6Rm+nvJOBL/FaT8hqBsEFWKpPzN79FBEAT
X4xIBp+WDX5b20OEPAvBiR261GrVIm9oRlH/O63bNESOqokeSlL1jLW30d3Hz1ZW
4czjl/9qv7ihvu+EbD1vP/Bqk5cIFJAgEgob64nNbbTskG68HppTBJ0pfPgGAm9w
KJVlH09sioghDYQf01QRacvd5RW26hOUKKF4wcObYiMiJo9nTmQ=
=cU3J
-----END PGP SIGNATURE-----

--WChQLJJJfbwij+9x--
