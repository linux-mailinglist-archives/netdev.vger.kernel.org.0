Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B936F1D6D4F
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 23:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726937AbgEQVDI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 17:03:08 -0400
Received: from sauhun.de ([88.99.104.3]:33594 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726297AbgEQVDI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 17:03:08 -0400
Received: from localhost (p5486C87C.dip0.t-ipconnect.de [84.134.200.124])
        by pokefinder.org (Postfix) with ESMTPSA id 175B92C049C;
        Sun, 17 May 2020 23:03:04 +0200 (CEST)
Date:   Sun, 17 May 2020 23:03:04 +0200
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
Subject: Re: [PATCH 15/17] ARM: dts: r8a7742: Add APMU nodes
Message-ID: <20200517210304.GJ1370@kunai>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-16-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="P6YfpwaDcfcOCJkJ"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-16-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--P6YfpwaDcfcOCJkJ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:55PM +0100, Lad Prabhakar wrote:
> Add DT nodes for the Advanced Power Management Units (APMU), and use the
> enable-method to point out that the APMU should be used for SMP support.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--P6YfpwaDcfcOCJkJ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7BpogACgkQFA3kzBSg
KbacdBAApy3Ari8o4nHza97uK9AUkww47BDpruE4xT8e3N9+CuBXoGtK1k0846Ob
jlZhgntHKeogYZMFECScfAALweIlMW0xQkFDM2Jb5MjYvzbrNmZic93LWzNQ7YH+
2naSvM6pZLz9A3Pt6PkqbI3dePMJMMqlZCGu+hElynEFyC+qk6rPuHVXBg1xsXaf
Ly0n/u3mnDV2wA+E1gvwY9USTGmurZAZxG8loFZrGqdFm9GgxIG3Aefubg7R21cS
3kOlEA6wU0Rkm/aiUNaAwPBh+BqhuHdBBCjs7oyWtNvZzOlRWa4Jp9/kI75Xbpkt
s6V76XGcQtvwb5DWOQtVH0kxN6qczVoByRThmFHs3NhcSD70QRXYj60P2PLbz+Ag
bG63kvaTiaJx5H9F/n24zlcIR++uwmkU30vQEyB8M7tKoN0jFD1OpUNasBS+mKWi
wyX9+ROK2SKnccTAocS536Ny7Jxyr2uf1/GFIkvWXyiqg7T8j4Q3PYrauvfy2bvg
OB2+wx4xnWqh5C1/I/YU7xIHPVy+MUjgr9SB/gNhRwqY2NHoE2MoegB4I1FvP925
qQKpP8PtiXcxV1OVjXZdZhlCBRrZtQP/xj8xLXqdL3Djk23Dm2jWjlG4G8Ie5MbB
YhJ3RCBOMtQUr7tODnLRTLY9jasdx2asW9StL5IinXHdIIML3cA=
=Kjd5
-----END PGP SIGNATURE-----

--P6YfpwaDcfcOCJkJ--
