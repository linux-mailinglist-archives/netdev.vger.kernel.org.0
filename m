Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C14E434149
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 00:24:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbhJSW0P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 18:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbhJSW0O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Oct 2021 18:26:14 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e3e3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A620C06161C;
        Tue, 19 Oct 2021 15:24:00 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: sre)
        with ESMTPSA id 859311F43E76
Received: by earth.universe (Postfix, from userid 1000)
        id 0842C3C0CA7; Wed, 20 Oct 2021 00:23:57 +0200 (CEST)
Date:   Wed, 20 Oct 2021 00:23:56 +0200
From:   Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        =?utf-8?Q?Beno=C3=AEt?= Cousson <bcousson@baylibre.com>,
        Tony Lindgren <tony@atomide.com>,
        Russell King <linux@armlinux.org.uk>,
        David Lechner <david@lechnology.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: dts: motorola-mapphone: Drop second ti,wlcore
 compatible value
Message-ID: <20211019222356.ybx2dn6oaogichtv@earth.universe>
References: <cover.1634646975.git.geert+renesas@glider.be>
 <84f8e477015d73ce7fca7b8abdd1099f505ad972.1634646975.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="dtqfs7bs4eb7ghau"
Content-Disposition: inline
In-Reply-To: <84f8e477015d73ce7fca7b8abdd1099f505ad972.1634646975.git.geert+renesas@glider.be>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--dtqfs7bs4eb7ghau
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Oct 19, 2021 at 02:43:11PM +0200, Geert Uytterhoeven wrote:
> The TI wlcore DT bindings specify using a single compatible value for
> each variant, and the Linux kernel driver matches against the first
> compatible value since commit 078b30da3f074f2e ("wlcore: add wl1285
> compatible") in v4.13.

Reviewed-by: Sebastian Reichel <sebastian.reichel@collabora.com>

-- Sebastian

>  arch/arm/boot/dts/motorola-mapphone-common.dtsi | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/arch/arm/boot/dts/motorola-mapphone-common.dtsi b/arch/arm/b=
oot/dts/motorola-mapphone-common.dtsi
> index a4423ff0df39264b..c7a1f3ffc48ca58e 100644
> --- a/arch/arm/boot/dts/motorola-mapphone-common.dtsi
> +++ b/arch/arm/boot/dts/motorola-mapphone-common.dtsi
> @@ -310,7 +310,7 @@ &mmc3 {
>  	#address-cells =3D <1>;
>  	#size-cells =3D <0>;
>  	wlcore: wlcore@2 {
> -		compatible =3D "ti,wl1285", "ti,wl1283";
> +		compatible =3D "ti,wl1285";
>  		reg =3D <2>;
>  		/* gpio_100 with gpmc_wait2 pad as wakeirq */
>  		interrupts-extended =3D <&gpio4 4 IRQ_TYPE_LEVEL_HIGH>,
> --=20
> 2.25.1
>=20

--dtqfs7bs4eb7ghau
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE72YNB0Y/i3JqeVQT2O7X88g7+poFAmFvRXkACgkQ2O7X88g7
+prCPw//aKM8e080CfIvvBYQqetwGG+1nS3TMtHR6VDiMOsEHjCGjsKX3W0ilf6s
+QUixW6xyIiuJDwpFsoVW0trtYVjfCdoDUgF1D8/0Kb+Q3aTwtqqaUqQLzCflXPT
aO8nClN8JrLX1ewNkxjAE+tXa+Z0tEWun0avnRoXbaSYnUFN7OAnEzNY9RuksYiW
xnaaGStczuIpsAZnTzOROxH9/yny+SM9XiZPl+dsCvAcjYOfF2F8H2eIjYzUI5dP
B1lqo0GT11NrzUVBxLxZdWy7BbA8frRUw13wBcaQFt+GoJjcdsiU1pvssmg5FA7o
FAM8xL3gx4k1QvtqpaVKw4usSC29wNYsL2DpsDAiN/T+lCvIWWPL8HuvB17nL2cv
Wzui2ikkfkpAUQuSXpzeyETV2aH4xfWxTZTSC1FGPbcZptRQ5vyMWySfEo60OBW6
+E1pV6kWjmKnMiXIjUuqIASDTJq+JW9jk8FWCGRcHf8phCVnmkGxCRh9nAbQQ7QX
LB8DhwA/LwqZ2wfcxm/DI+DjIQUSEynslvAdDtkod8i8py5HUN/+6fzR62Vmnc/T
DzBdCmLMzZPqwBOAl4L46UUhkbjnvU7zRVLjUioTU9/TmtYpIjYcwU9giFYhhPto
ZgNs5Y8R/kgWvMk4txkAIz8p1cyBWLfuScZ0Db8v+UMX3MnyTWU=
=3UNY
-----END PGP SIGNATURE-----

--dtqfs7bs4eb7ghau--
