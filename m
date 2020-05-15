Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C3CB01D5782
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:21:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726492AbgEORVc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:21:32 -0400
Received: from www.zeus03.de ([194.117.254.33]:52616 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726444AbgEORV3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 13:21:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=adq9LskloBWVxoGaRkbsd6/tuspv
        SCX7tBocarJTm3I=; b=zJ47LGm/c+BK0ZeuYIT/Q9653g8YWowJHaCZe/diPaL7
        SH1/ofbLOnUC87vezrTIoiuNp/6MKpoKytqrgaRXWzM25eqVsf/X4+sWE9NnJCsa
        fNBRLEN1Kgx3uL0uTfxWXfj8vr4tKskgs0mErFE00hQLHCai/XE5TwyANyOJrgg=
Received: (qmail 71890 invoked from network); 15 May 2020 19:14:47 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 15 May 2020 19:14:47 +0200
X-UD-Smtp-Session: l3s3148p1@kYtF87KlSqogAwDPXwnHAMSqtBM6FBGP
Date:   Fri, 15 May 2020 19:14:47 +0200
From:   Wolfram Sang <wsa+renesas@sang-engineering.com>
To:     Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
Cc:     Geert Uytterhoeven <geert+renesas@glider.be>,
        Jens Axboe <axboe@kernel.dk>, Rob Herring <robh+dt@kernel.org>,
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
Subject: Re: [PATCH 02/17] dt-bindings: i2c: renesas,iic: Document r8a7742
 support
Message-ID: <20200515171447.GD19423@ninjato>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="fOHHtNG4YXGJ0yqR"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-3-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--fOHHtNG4YXGJ0yqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:42PM +0100, Lad Prabhakar wrote:
> Document IIC controller for RZ/G1H (R8A7742) SoC, which is compatible
> with R-Car Gen2 SoC family.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

Reviewed-by: Wolfram Sang <wsa+renesas@sang-engineering.com>


--fOHHtNG4YXGJ0yqR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl6+zgcACgkQFA3kzBSg
KbYzsA//QsjVzJAZQj+6VEysYmA8plfS9mhsmesCIT6gyU6eHkb4i96kpae0gleW
7xwPR4lUBC2SVzNgrXfSQGJ2+C/PziGa6/Zqn3Ajt5jhl3qAsQx4O4ou3+t6znCJ
xEbZ3Yra+L3g97XCnzBeQzFlPl4P1QpyxOQQVMFLKEHTOL9HCmAf7WIjmNBg2RKf
1JNgFOHTy5DZ3O1GCTwYlaBQnDricRwu9447KJFA6l+un43sJD1VKXMIG+MFHBHC
arwJeBGo2KnofZ71eSycnE0LfXAQZPmGXAWt/qgXFs+J7/Inn6C5eHb56ues4wtJ
5XlWAwilp8xN2OPwrA1bhNYZHGS6yTZEzP2lBfZL1jdPQEpjyWNe4QEcUujn69ZR
W1z58T5rvJ7SPHYwoiiEEae94SqHZETU7Mj3CWkMiOnRq3v34cFjdj4MH3Wfc03C
FfmwAuxgHTf2AT63lDNj9zC28C2B2X5kaXYnt20r2rF2bXix37wYUiC/jJE5XeTV
LbnswsyXmUjmGS7bitEs9w48y0UAcCIaMXRRuvtKCiSsffcUaHDYG799VHRKJ+5K
6gnOtHQN9e3dzOXCBwhz0ZwEggSAJfxKj2SzlpDFd6F/zaYoa6/4At/dilJNoD70
bru3nGV2PiIFvXZbnPC/ExSez1futM0jpgy4vAKptDSaZRp8tYU=
=2wZ0
-----END PGP SIGNATURE-----

--fOHHtNG4YXGJ0yqR--
