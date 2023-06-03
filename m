Return-Path: <netdev+bounces-7726-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F0A2D721321
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 23:20:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6AB6A1C20A47
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 21:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6103101DF;
	Sat,  3 Jun 2023 21:20:01 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B3BEE568
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 21:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0A27C433D2;
	Sat,  3 Jun 2023 21:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685827199;
	bh=BZOw+FWcgu7vUswi4HFGtw5RscQe14dyxO/YQmzIq90=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=tf1JCXDk/y6nR/a7f7Y3sZINQ8/yxcAlQchx5G5mK5xQeodr6GD66wMGW4bUuzG4l
	 9IfGQFXvSKw6QU70/GBTbvm4L+OE/riXKh3Wg9PiEcPeg68aOB8KFQsiKqgEq43R+2
	 wiMaQgBuub5Pwm1jMa1TD2kuPG1KKWnYEhOKtF05hV9Hpc2hKyhPX28fdCgNiPff2E
	 Bjy39T0eTm36sh8dSCvCZ7vNEwJFFtiM0ovmwcot41TR5q0dWNEkyvTtz6/xjB5Oqk
	 S42KTOb0ziSE/LsLkuotax3aZ7cK9i8AegYA33taw+bbRJ31iB8HxzXT+PDqLQsTis
	 sfuqVonGaJt9Q==
Date: Sat, 3 Jun 2023 22:19:50 +0100
From: Conor Dooley <conor@kernel.org>
To: Varshini Rajendran <varshini.rajendran@microchip.com>
Cc: tglx@linutronix.de, maz@kernel.org, robh+dt@kernel.org,
	krzysztof.kozlowski+dt@linaro.org, conor+dt@kernel.org,
	nicolas.ferre@microchip.com, alexandre.belloni@bootlin.com,
	claudiu.beznea@microchip.com, davem@davemloft.net,
	edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
	gregkh@linuxfoundation.org, linux@armlinux.org.uk,
	mturquette@baylibre.com, sboyd@kernel.org, sre@kernel.org,
	broonie@kernel.org, arnd@arndb.de, gregory.clement@bootlin.com,
	sudeep.holla@arm.com, balamanikandan.gunasundar@microchip.com,
	mihai.sain@microchip.com, linux-kernel@vger.kernel.org,
	devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	netdev@vger.kernel.org, linux-usb@vger.kernel.org,
	linux-clk@vger.kernel.org, linux-pm@vger.kernel.org,
	Hari.PrasathGE@microchip.com, cristian.birsan@microchip.com,
	durai.manickamkr@microchip.com, manikandan.m@microchip.com,
	dharma.b@microchip.com, nayabbasha.sayed@microchip.com,
	balakrishnan.s@microchip.com
Subject: Re: [PATCH 15/21] dt-bindings: irqchip/atmel-aic5: Add support for
 sam9x7 aic
Message-ID: <20230603-fervor-kilowatt-662c84b94853@spud>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-16-varshini.rajendran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="1dJx+wkvpfCS95Xb"
Content-Disposition: inline
In-Reply-To: <20230603200243.243878-16-varshini.rajendran@microchip.com>


--1dJx+wkvpfCS95Xb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Varshini,

On Sun, Jun 04, 2023 at 01:32:37AM +0530, Varshini Rajendran wrote:
> Document the support added for the Advanced interrupt controller(AIC)
> chip in the sam9x7 soc family

Please do not add new family based compatibles, but rather use per-soc
compatibles instead.

Cheers,
Conor.

>=20
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> ---
>  .../devicetree/bindings/interrupt-controller/atmel,aic.txt      | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/Documentation/devicetree/bindings/interrupt-controller/atmel=
,aic.txt b/Documentation/devicetree/bindings/interrupt-controller/atmel,aic=
=2Etxt
> index 7079d44bf3ba..2c267a66a3ea 100644
> --- a/Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt
> +++ b/Documentation/devicetree/bindings/interrupt-controller/atmel,aic.txt
> @@ -4,7 +4,7 @@ Required properties:
>  - compatible: Should be:
>      - "atmel,<chip>-aic" where  <chip> can be "at91rm9200", "sama5d2",
>        "sama5d3" or "sama5d4"
> -    - "microchip,<chip>-aic" where <chip> can be "sam9x60"
> +    - "microchip,<chip>-aic" where <chip> can be "sam9x60", "sam9x7"
> =20
>  - interrupt-controller: Identifies the node as an interrupt controller.
>  - #interrupt-cells: The number of cells to define the interrupts. It sho=
uld be 3.
> --=20
> 2.25.1
>

--1dJx+wkvpfCS95Xb
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHuudgAKCRB4tDGHoIJi
0vFEAQCmq8GttNp1wpTMbyO6Gfr1BPoByKTMvRLusphKBGd4sQEAx9HjlwFxY0SR
H+CY7tqyRHYnRfJkrr3NkaRSCSs9NAg=
=cuRe
-----END PGP SIGNATURE-----

--1dJx+wkvpfCS95Xb--

