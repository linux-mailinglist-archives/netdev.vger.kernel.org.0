Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5961C1D5757
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726592AbgEORRQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:17:16 -0400
Received: from www.zeus03.de ([194.117.254.33]:51166 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgEORRP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 13:17:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=AMR5jXEokMZ/3kQZjTX3bu3Iy5KP
        19A2jn+GsTxjF4c=; b=LP/syxtyG+nb5JwbKx0hlFDzR3GZ5hOhQ9+1Ux6AI8D5
        ZubTmfoBF/LyI0jHWjAh7xRWUY9oexhNARw6/PyUCai8e6AKFD+efTi1rz6TPyW0
        13wiXhMtQb9kiZS58cPPzU7VqQ8k5j4XVEqJquja1GlEt5nsjrUgCpZEOlYz3kk=
Received: (qmail 70421 invoked from network); 15 May 2020 19:10:32 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 15 May 2020 19:10:32 +0200
X-UD-Smtp-Session: l3s3148p1@+BUH5LKlRqogAwDPXwnHAMSqtBM6FBGP
Date:   Fri, 15 May 2020 19:10:31 +0200
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
Subject: Re: [PATCH 03/17] ARM: dts: r8a7742: Add I2C and IIC support
Message-ID: <20200515171031.GB19423@ninjato>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="IrhDeMKUP4DT/M7F"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-4-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--IrhDeMKUP4DT/M7F
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:43PM +0100, Lad Prabhakar wrote:
> Add the I2C[0-3] and IIC[0-3] devices nodes to the R8A7742 device tree.
>=20
> Automatic transmission for PMIC control is not available on IIC3 hence
> compatible string "renesas,rcar-gen2-iic" and "renesas,rmobile-iic" is
> not added to iic3 node.

Makes sense.

However, both versions (with and without automatic transmission) are
described with the same "renesas,iic-r8a7742" compatible. Is it possible
to detect the reduced variant at runtime somehow?

My concern is that the peculiarity of this SoC might be forgotten if we
describe it like this and ever add "automatic transmissions" somewhen.


--IrhDeMKUP4DT/M7F
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl6+zQcACgkQFA3kzBSg
KbYmEg//Sy08rxbE7CQJWmifMe+J/n/a+aH2CCs3cvFNsRE3DPGOOJCs9jLX87oy
qwsccQ5z/QlX6QZv/jrGh4Tn9Tu+4F8iA9K5JzmtjeNKULwiHHzVjb2vk3vcxHDq
EXdRjCwXJ0XJbxRwLXyDYZh4TOMhKeoNKcmN8oFEj6VtE6dL64m/F69wyyXdJTez
ZhIxL1MjQELN+vlbZkA+J4Zo+ugNyTZ3diSL+s9xI5de2fWBJv3IzdeKWoHWG9Su
ExUWRIs/Y0dBapuAx78sq1FDauAUSer8d4llopIoXN6Snpr0ijJUh4R7VVoZsK+c
PTZkqlgYBfYWdUZiUBaM2oINk69ef1Y/wqOt9iMxJDXq7cTw/rb3UBd/va6MFbb/
vOBb4Z2FVai4cseNkkgcLHgz229gkloRr7f+HKGL8r42LRUfMBko0W0D/WEN+DKW
8Y/0MCRTd7+h1I3SkuVT7fjbPiw+lTkwZhsJrZRrqiqeq+m2J2325tZI+A5hq0qu
uX27BdGRPS5jaA/i+UQSySuoWvORKCKwAjJIElt/UOOPHQDEWKRH8QoJ8wFkgN2k
sCrKHi9sS3XcVvIy5ieiF5rf8zEV4mNLtkZV/CzvjqTzMfh5f5eWmoC1tkkkakRc
KaTrT/4T46ZpQdog7U8GfYXUujn6nRN+X+qnVFOc7MNmGd00yk4=
=AO2d
-----END PGP SIGNATURE-----

--IrhDeMKUP4DT/M7F--
