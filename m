Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B48CD1D6D00
	for <lists+netdev@lfdr.de>; Sun, 17 May 2020 22:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726721AbgEQUx5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 May 2020 16:53:57 -0400
Received: from sauhun.de ([88.99.104.3]:33272 "EHLO pokefinder.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726313AbgEQUx4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 May 2020 16:53:56 -0400
Received: from localhost (p5486C87C.dip0.t-ipconnect.de [84.134.200.124])
        by pokefinder.org (Postfix) with ESMTPSA id CB6052C049C;
        Sun, 17 May 2020 22:53:52 +0200 (CEST)
Date:   Sun, 17 May 2020 22:53:52 +0200
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
Subject: Re: [PATCH 06/17] ARM: dts: r8a7742: Add SDHI nodes
Message-ID: <20200517205352.GA1370@kunai>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-7-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:46PM +0100, Lad Prabhakar wrote:
> Add the SDHI devices nodes to the R8A7742 device tree.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--pf9I7BMVVzbSWLtt
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl7BpFsACgkQFA3kzBSg
KbYmzg/+LfyPZH+2Xfvqm98T/YgjrXFgYlvaudnznG5k4WKw8eE6beap59uIEvyH
/pxajrNijQtvChZTT1lNirQfdWo3bDZjI89Qy97K5IL8AuITQnFlMbbQhArmonjR
aWaltkG1oSP/klPzqU41Y7QEGCusffp6UpLg/i3peCvzdBMtxI5VD7elA3lUH/Kv
/lSPeWKH0tgsh/Ca24X0IatlKnoiv88oe9f+ny+IWu81qe8K/7ZK2RxttXJWW7Cr
earVX3v+SfOEhb2TQpSEpC/uSDNr8GeIIkX/Z3+EG8/KpAYPXT2W74c42mw4ELui
4t6TR67bcfoeableOCiXN/mxtxSChNa8qq/I86Y1IxLmylvAoFq0yQt+rzA9rTK1
WW27wu0YUTlrlooC/LRK0qU0EZMf22x/HcMvqvXPMFwnzHmUnhdKRXfZjsOBaHlz
DtDP7k2bMRP+Fi2Hv6ixVT3jD5W5FviHenexFEYmHGNaovxthukE1fPyxMQgUkpz
ft4MzIM1WqMkVXSY0m5XY3dP0A8tre2puottV7eoZwisoBA/Y7k2EEK1RHt6fLvZ
ylmnS/M6253Cj2F/M0OdCgVVekVBSc4WCy5U/qe/mfQPT+eGIQTqk1adGbLc3GuU
Xlwj2EafqLI4YzI+BsXvLqCz5acxYme57Rif+kB0d8zLdrzhFMc=
=RyxU
-----END PGP SIGNATURE-----

--pf9I7BMVVzbSWLtt--
