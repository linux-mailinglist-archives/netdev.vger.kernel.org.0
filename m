Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D5031D5762
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 19:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbgEORR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 13:17:58 -0400
Received: from www.zeus03.de ([194.117.254.33]:51418 "EHLO mail.zeus03.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726278AbgEORR5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 13:17:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=sang-engineering.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=k1; bh=tAJU7taF11lwsgMZCnNGLZ/hRQyk
        hHP1i8TYZ9hJlgs=; b=PIHIz5OD3mMQYyGfl+/oV/b+3uOn2f0S8kWWw7Z//anj
        VKd8GPrEZ/NvUtCZm5VBD4CS8EA/G+hYzcw9jJxfVtA3cZN1hGQdXF3RqsSjtd3Z
        h2xBfAlVOC6ZhK+9/1QBuiQ5ANecPirOcgXsiAqOMeN3QPa4yyGyE7/1qFpjQgI=
Received: (qmail 72963 invoked from network); 15 May 2020 19:17:54 +0200
Received: by mail.zeus03.de with ESMTPSA (TLS_AES_256_GCM_SHA384 encrypted, authenticated); 15 May 2020 19:17:54 +0200
X-UD-Smtp-Session: l3s3148p1@i2xt/rKlTqogAwDPXwnHAMSqtBM6FBGP
Date:   Fri, 15 May 2020 19:17:54 +0200
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
Subject: Re: [PATCH 05/17] mmc: renesas_sdhi_sys_dmac: Add support for
 r8a7742 SoC
Message-ID: <20200515171754.GF19423@ninjato>
References: <1589555337-5498-1-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
 <1589555337-5498-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="SxgehGEc6vB0cZwN"
Content-Disposition: inline
In-Reply-To: <1589555337-5498-6-git-send-email-prabhakar.mahadev-lad.rj@bp.renesas.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--SxgehGEc6vB0cZwN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 15, 2020 at 04:08:45PM +0100, Lad Prabhakar wrote:
> Add support for r8a7742 SoC. Renesas RZ/G1H (R8A7742) SDHI is identical to
> the R-Car Gen2 family.
>=20
> Signed-off-by: Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
> Reviewed-by: Marian-Cristian Rotariu <marian-cristian.rotariu.rb@bp.renes=
as.com>

I think we can skip this because of the generic fallback? The other
entries come from a time when we had a different policy IIRC.

> ---
>  drivers/mmc/host/renesas_sdhi_sys_dmac.c | 1 +
>  1 file changed, 1 insertion(+)
>=20
> diff --git a/drivers/mmc/host/renesas_sdhi_sys_dmac.c b/drivers/mmc/host/=
renesas_sdhi_sys_dmac.c
> index 13ff023..dbfcbc2 100644
> --- a/drivers/mmc/host/renesas_sdhi_sys_dmac.c
> +++ b/drivers/mmc/host/renesas_sdhi_sys_dmac.c
> @@ -75,6 +75,7 @@ static const struct of_device_id renesas_sdhi_sys_dmac_=
of_match[] =3D {
>  	{ .compatible =3D "renesas,sdhi-r7s72100", .data =3D &of_rz_compatible,=
 },
>  	{ .compatible =3D "renesas,sdhi-r8a7778", .data =3D &of_rcar_gen1_compa=
tible, },
>  	{ .compatible =3D "renesas,sdhi-r8a7779", .data =3D &of_rcar_gen1_compa=
tible, },
> +	{ .compatible =3D "renesas,sdhi-r8a7742", .data =3D &of_rcar_gen2_compa=
tible, },
>  	{ .compatible =3D "renesas,sdhi-r8a7743", .data =3D &of_rcar_gen2_compa=
tible, },
>  	{ .compatible =3D "renesas,sdhi-r8a7745", .data =3D &of_rcar_gen2_compa=
tible, },
>  	{ .compatible =3D "renesas,sdhi-r8a7790", .data =3D &of_rcar_gen2_compa=
tible, },
> --=20
> 2.7.4
>=20

--SxgehGEc6vB0cZwN
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEOZGx6rniZ1Gk92RdFA3kzBSgKbYFAl6+zsIACgkQFA3kzBSg
Kbavxw/5ASj0ysFzi+t9TCWf40CX4RN71FBZfm9Av3vQKK5R4HtL4W2gRXSPslgW
u0tXjoDL50k+dlzbLKsRyFiW7616nm4JhNQX1YvgYlnTueDa36yRFjaN6hEusujO
d4oAYuORud2Fyy9s/WT5vPL2ziSy+z9on/bDw2OOS9weSs4dIpqQLhR5zA8BEqrD
JpM+Cr+/NfDaWwUTs5T1Qygc/1lgBQrejGLPMzWjn+IroyRBh6amG496dcb27zuA
9Hln6t+NLrtP0ilpYyGw3zQ55ZT3HyxIHNglfRHL66CpdTVNFrRj7hgqW32aPSMg
h71YDH60ZMmIMJJcYRHURcck2Mv39w+eXv5AF7XI6hopQ7K+ys4yJYX9qy+2EzoY
DH3j0a/0pgydpwKL4KiJHVPsy7YzKqYrZUQTfPcQ21gEZMV6X3aiXkxTGQKbdX1O
ULCWZN+HWkr6jFDN0wxzneP3l1NvB+pzRmlBxodg5bx0jrnAmcAv934inwg0yovp
f/b1f2arn13sImX64Me3P5sV7SM8bbAcDEvy8XsrPkWABDjlba4KJFouArzPJO/A
M6XEwNEqAXWG8tnWrxlm6VgceZPPA/t6iMW39Kem04WA1nESDm+f86/whSJdXgc+
vN8ymqYx3M099298eg1Gc+1lda+hJQ8rZyCKjth3iDcKu/YCW5A=
=y+4+
-----END PGP SIGNATURE-----

--SxgehGEc6vB0cZwN--
