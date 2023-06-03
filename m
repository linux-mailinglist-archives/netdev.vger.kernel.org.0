Return-Path: <netdev+bounces-7728-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B23B1721334
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 23:36:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 62602281734
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 21:36:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636E3101EC;
	Sat,  3 Jun 2023 21:36:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0213E568
	for <netdev@vger.kernel.org>; Sat,  3 Jun 2023 21:36:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30E18C433EF;
	Sat,  3 Jun 2023 21:36:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685828169;
	bh=yIeiVTnh/Ift8tK1dxozK/NMJ5hgTSuFRUDlnSNC+iw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=pOy4jZdpnPUzdeDQ7IaQ5f5zeZo9Lf3IzXSm+kxfh/WmFkrYRIazkCNWIfC1ZWTSN
	 O4DjJZl2rVtl4fCfs3yheut6STzxMMxbmP1a56eOaAcxxciiImZfKqKxsaEe38vqqf
	 7KHKQufS5oLsIz6YMp6iuTVTdCUYCl0iJldho5jQ20QqaUHQVlyu7GsgjIVs4DGSc3
	 1eIVjb4QikDkT8bbaGkcLu+QjTd50ICfsjW2CFAYhEU+CXckf39hyll2iSLHCotZLI
	 jWjfSZQyXcgTFSbrR0pxKiiTlc26TkcZ/XmuISCS16f4592A9QdTt/+CcSvYD9efHf
	 tdIVaE5ezoD1g==
Date: Sat, 3 Jun 2023 22:35:59 +0100
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
Subject: Re: [PATCH 04/21] ARM: dts: at91: sam9x7: add device tree for soc
Message-ID: <20230603-resource-decode-47167e7e199a@spud>
References: <20230603200243.243878-1-varshini.rajendran@microchip.com>
 <20230603200243.243878-5-varshini.rajendran@microchip.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="DOAMUR2naNx1jPwl"
Content-Disposition: inline
In-Reply-To: <20230603200243.243878-5-varshini.rajendran@microchip.com>


--DOAMUR2naNx1jPwl
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hey Varshini,

On Sun, Jun 04, 2023 at 01:32:26AM +0530, Varshini Rajendran wrote:
> Add device tree file for SAM9X7 SoC family
>=20
> Signed-off-by: Varshini Rajendran <varshini.rajendran@microchip.com>
> [nicolas.ferre@microchip.com: add support for gmac to sam9x7]

Please just replace these [] things with a Co-developed-by.

> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
> [balamanikandan.gunasundar@microchip.com: Add device node csi2host and is=
c]
> Signed-off-by: Balamanikandan Gunasundar <balamanikandan.gunasundar@micro=
chip.com>
> ---
>  arch/arm/boot/dts/sam9x7.dtsi | 1333 +++++++++++++++++++++++++++++++++
>  1 file changed, 1333 insertions(+)
>  create mode 100644 arch/arm/boot/dts/sam9x7.dtsi
>=20
> diff --git a/arch/arm/boot/dts/sam9x7.dtsi b/arch/arm/boot/dts/sam9x7.dtsi
> new file mode 100644
> index 000000000000..f98160182fe6
> --- /dev/null
> +++ b/arch/arm/boot/dts/sam9x7.dtsi
> @@ -0,0 +1,1333 @@
> +// SPDX-License-Identifier: (GPL-2.0+ OR MIT)
> +/*
> + * sam9x7.dtsi - Device Tree Include file for Microchip SAM9X7 SoC family
> + *
> + * Copyright (C) 2022 Microchip Technology Inc. and its subsidiaries
> + *
> + * Author: Varshini Rajendran <varshini.rajendran@microchip.com>
> + */
> +
> +#include <dt-bindings/clock/at91.h>
> +#include <dt-bindings/dma/at91.h>
> +#include <dt-bindings/gpio/gpio.h>
> +#include <dt-bindings/interrupt-controller/arm-gic.h>
> +#include <dt-bindings/interrupt-controller/irq.h>
> +#include <dt-bindings/mfd/atmel-flexcom.h>
> +#include <dt-bindings/pinctrl/at91.h>
> +
> +/ {
> +	#address-cells =3D <1>;
> +	#size-cells =3D <1>;
> +	model =3D "Microchip SAM9X7 SoC";
> +	compatible =3D "microchip,sam9x7";

Unless I am mistaken, sam9x7 is a family, not an soc. I'll have to
defer to Nicolas or someone that actually properly understands the
naming scheme here though! It's certainly odd to use sam9x7 here, when
the file is filled with references to sam9x60, which is a soc-specific
compatible.

Either way, the compatible is undocumented as far as I can tell and I
assume that this was not actually tested, since there doesn't appear
to be any dts including this file and therefore no way to build it?

> +	interrupt-parent =3D <&aic>;
> +
> +	aliases {
> +		serial0 =3D &dbgu;
> +		gpio0 =3D &pioA;
> +		gpio1 =3D &pioB;
> +		gpio2 =3D &pioC;
> +		gpio3 =3D &pioD;
> +	};
> +
> +	cpus {
> +		#address-cells =3D <1>;
> +		#size-cells =3D <0>;
> +
> +		cpu@0 {
> +			compatible =3D "arm,arm926ej-s";
> +			device_type =3D "cpu";
> +			reg =3D <0>;
> +		};
> +	};
> +
> +	clocks {
> +		slow_xtal: slow_xtal {
> +			compatible =3D "fixed-clock";
> +			#clock-cells =3D <0>;
> +		};
> +
> +		main_xtal: main_xtal {
> +			compatible =3D "fixed-clock";
> +			#clock-cells =3D <0>;
> +		};
> +	};
> +
> +	sram: sram@300000 {
> +		compatible =3D "mmio-sram";
> +		reg =3D <0x300000 0x10000>;
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges =3D <0 0x300000 0x10000>;
> +	};
> +
> +	ahb {
> +		compatible =3D "simple-bus";
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		ranges;
> +
> +		usb0: gadget@500000 {
> +			compatible =3D "microchip,sam9x60-udc";

This is not a sam9x60, so it should not only have that SoC's compatible
here. Ideally, "microchip,sam9x7{0,2,5}" with the sam9x60 one as a
fallback.

> +			reg =3D <0x500000 0x100000>,
> +			      <0xf803c000 0x400>;
> +			#address-cells =3D <1>;
> +			#size-cells =3D <0>;
> +			interrupts =3D <23 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks =3D <&pmc PMC_TYPE_PERIPHERAL 23>, <&pmc PMC_TYPE_CORE PMC_UTM=
I>;
> +			clock-names =3D "pclk", "hclk";
> +			assigned-clocks =3D <&pmc PMC_TYPE_CORE PMC_UTMI>;
> +			assigned-clock-rates =3D <480000000>;
> +			status =3D "disabled";
> +		};
> +
> +		ohci0: usb@600000 {
> +			compatible =3D "atmel,at91rm9200-ohci", "usb-ohci";

Ditto here.

> +			reg =3D <0x600000 0x100000>;
> +			interrupts =3D <22 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks =3D <&pmc PMC_TYPE_PERIPHERAL 22>, <&pmc PMC_TYPE_PERIPHERAL 2=
2>, <&pmc PMC_TYPE_SYSTEM 6>;
> +			clock-names =3D "ohci_clk", "hclk", "uhpck";
> +			status =3D "disabled";
> +		};
> +
> +		ehci0: usb@700000 {
> +			compatible =3D "atmel,at91sam9g45-ehci", "usb-ehci";

And here.

> +			reg =3D <0x700000 0x100000>;
> +			interrupts =3D <22 IRQ_TYPE_LEVEL_HIGH 2>;
> +			clocks =3D <&pmc PMC_TYPE_CORE PMC_UTMI>, <&pmc PMC_TYPE_PERIPHERAL 2=
2>;
> +			clock-names =3D "usb_clk", "ehci_clk";
> +			assigned-clocks =3D <&pmc PMC_TYPE_CORE PMC_UTMI>;
> +			assigned-clock-rates =3D <480000000>;
> +			status =3D "disabled";
> +		};
> +
> +		sdmmc0: sdio-host@80000000 {
> +			compatible =3D "microchip,sam9x60-sdhci";

And here.

> +			reg =3D <0x80000000 0x300>;
> +			interrupts =3D <12 IRQ_TYPE_LEVEL_HIGH 0>;
> +			clocks =3D <&pmc PMC_TYPE_PERIPHERAL 12>, <&pmc PMC_TYPE_GCK 12>;
> +			clock-names =3D "hclock", "multclk";
> +			assigned-clocks =3D <&pmc PMC_TYPE_GCK 12>;
> +			assigned-clock-rates =3D <100000000>;
> +			status =3D "disabled";
> +		};
> +
> +		sdmmc1: sdio-host@90000000 {
> +			compatible =3D "microchip,sam9x60-sdhci";

There's no point me typing it every time, but ditto the whole way
through this file ;)

Cheers,
Conor.

--DOAMUR2naNx1jPwl
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQRh246EGq/8RLhDjO14tDGHoIJi0gUCZHuyPwAKCRB4tDGHoIJi
0hSgAP9MoJHwyaSHta2fqHpzmQVjWJYXHIJ8IYUrjnHVS9xzdwD/SDyZtvGEuEbB
aul/eSJSrczxyawcSZXHv/xvMzCmVws=
=60V/
-----END PGP SIGNATURE-----

--DOAMUR2naNx1jPwl--

