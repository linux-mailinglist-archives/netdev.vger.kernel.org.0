Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 575AA8FF2A
	for <lists+netdev@lfdr.de>; Fri, 16 Aug 2019 11:38:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbfHPJip (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Aug 2019 05:38:45 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:37825 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726753AbfHPJin (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Aug 2019 05:38:43 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1hyYgv-0008Nu-4x; Fri, 16 Aug 2019 11:38:37 +0200
Received: from [IPv6:2001:67c:670:202:595f:209f:a34b:fbc1] (unknown [IPv6:2001:67c:670:202:595f:209f:a34b:fbc1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256
         client-signature RSA-PSS (4096 bits) client-digest SHA256)
        (Client CN "mkl@blackshift.org", Issuer "StartCom Class 1 Client CA" (not verified))
        (Authenticated sender: mkl@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id C1F0B4466F4;
        Fri, 16 Aug 2019 09:38:33 +0000 (UTC)
To:     Dan Murphy <dmurphy@ti.com>, wg@grandegger.com, davem@davemloft.net
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20190509161109.10499-1-dmurphy@ti.com>
 <20190509161109.10499-3-dmurphy@ti.com>
From:   Marc Kleine-Budde <mkl@pengutronix.de>
Openpgp: preference=signencrypt
Autocrypt: addr=mkl@pengutronix.de; prefer-encrypt=mutual; keydata=
 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
Subject: Re: [PATCH v12 3/5] dt-bindings: can: tcan4x5x: Add DT bindings for
 TCAN4x5X driver
Message-ID: <bdf06ead-a2e8-09a9-8cdd-49b54ec9da72@pengutronix.de>
Date:   Fri, 16 Aug 2019 11:38:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190509161109.10499-3-dmurphy@ti.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="aBUzk5kBxcksCMQiGzZKo8fIFHJb9btJx"
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--aBUzk5kBxcksCMQiGzZKo8fIFHJb9btJx
Content-Type: multipart/mixed; boundary="q6QniM5YBwprqSKHFOCHjmzVW0QcEIZcF";
 protected-headers="v1"
From: Marc Kleine-Budde <mkl@pengutronix.de>
To: Dan Murphy <dmurphy@ti.com>, wg@grandegger.com, davem@davemloft.net
Cc: linux-can@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org
Message-ID: <bdf06ead-a2e8-09a9-8cdd-49b54ec9da72@pengutronix.de>
Subject: Re: [PATCH v12 3/5] dt-bindings: can: tcan4x5x: Add DT bindings for
 TCAN4x5X driver
References: <20190509161109.10499-1-dmurphy@ti.com>
 <20190509161109.10499-3-dmurphy@ti.com>
In-Reply-To: <20190509161109.10499-3-dmurphy@ti.com>

--q6QniM5YBwprqSKHFOCHjmzVW0QcEIZcF
Content-Type: text/plain; charset=utf-8
Content-Language: de-DE
Content-Transfer-Encoding: quoted-printable

On 5/9/19 6:11 PM, Dan Murphy wrote:
> DT binding documentation for TI TCAN4x5x driver.
>=20
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>=20
> v12 - No changes - https://lore.kernel.org/patchwork/patch/1052300/
>=20
> v11 - No changes - https://lore.kernel.org/patchwork/patch/1051178/
> v10 - No changes - https://lore.kernel.org/patchwork/patch/1050488/
> v9 - No Changes - https://lore.kernel.org/patchwork/patch/1050118/
> v8 - No Changes - https://lore.kernel.org/patchwork/patch/1047981/
> v7 - Made device state optional - https://lore.kernel.org/patchwork/pat=
ch/1047218/
> v6 - No changes - https://lore.kernel.org/patchwork/patch/1042445/
>=20
>  .../devicetree/bindings/net/can/tcan4x5x.txt  | 37 +++++++++++++++++++=

>  1 file changed, 37 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/can/tcan4x5x.=
txt
>=20
> diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/D=
ocumentation/devicetree/bindings/net/can/tcan4x5x.txt
> new file mode 100644
> index 000000000000..c388f7d9feb1
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
> @@ -0,0 +1,37 @@
> +Texas Instruments TCAN4x5x CAN Controller
> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> +
> +This file provides device node information for the TCAN4x5x interface =
contains.
> +
> +Required properties:
> +	- compatible: "ti,tcan4x5x"
> +	- reg: 0
> +	- #address-cells: 1
> +	- #size-cells: 0
> +	- spi-max-frequency: Maximum frequency of the SPI bus the chip can
> +			     operate at should be less than or equal to 18 MHz.
> +	- data-ready-gpios: Interrupt GPIO for data and error reporting.
> +	- device-wake-gpios: Wake up GPIO to wake up the TCAN device.
> +
> +See Documentation/devicetree/bindings/net/can/m_can.txt for additional=

> +required property details.
> +
> +Optional properties:
> +	- reset-gpios: Hardwired output GPIO. If not defined then software
> +		       reset.
> +	- device-state-gpios: Input GPIO that indicates if the device is in
> +			      a sleep state or if the device is active.
> +
> +Example:
> +tcan4x5x: tcan4x5x@0 {
> +		compatible =3D "ti,tcan4x5x";
> +		reg =3D <0>;
> +		#address-cells =3D <1>;
> +		#size-cells =3D <1>;
> +		spi-max-frequency =3D <10000000>;
> +		bosch,mram-cfg =3D <0x0 0 0 32 0 0 1 1>;
> +		data-ready-gpios =3D <&gpio1 14 GPIO_ACTIVE_LOW>;

Can you convert this into a proper interrupt property? E.g.:

>                 interrupt-parent =3D <&gpio4>;
>                 interrupts =3D <13 0x2>;

See:
https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/b=
indings/net/can/microchip,mcp251x.txt#L21
https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/tr=
ee/drivers/net/can/spi/mcp251x.c?h=3Dmcp251x#n945

> +		device-state-gpios =3D <&gpio3 21 GPIO_ACTIVE_HIGH>;
> +		device-wake-gpios =3D <&gpio1 15 GPIO_ACTIVE_HIGH>;
> +		reset-gpios =3D <&gpio1 27 GPIO_ACTIVE_LOW>;
> +};

Marc

--=20
Pengutronix e.K.                  | Marc Kleine-Budde           |
Industrial Linux Solutions        | Phone: +49-231-2826-924     |
Vertretung West/Dortmund          | Fax:   +49-5121-206917-5555 |
Amtsgericht Hildesheim, HRA 2686  | http://www.pengutronix.de   |


--q6QniM5YBwprqSKHFOCHjmzVW0QcEIZcF--

--aBUzk5kBxcksCMQiGzZKo8fIFHJb9btJx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEmvEkXzgOfc881GuFWsYho5HknSAFAl1WeZYACgkQWsYho5Hk
nSBTlwf/UKOIilK+QTWjdNPICt6931qej73qUpCyoXPrpGem3p9JQ75TWAnwtpoH
JrzeqtaAkV2BuGWkF22JtdALqQWlLXniKBBr8jvYK7oVBP51eFm1Yu70ta5lztOo
Pr8SsTNW0/ey/4b8hygkpmQnuQIlOYWo1v+YK4IccEz9EbkyOVrg2aj/dvGzaVga
TMWmmKtpAjB8Cy0Rn1Ygf/zxs8AvCKFhMRnz2jabe/dxUAsxw3lKiW3fiJ8I6OMv
6Ra0kKf9nlZibQ70TUu/LX6X4rAf7U+SZ/IWAk1LoOtiySC6hn0r4pn9Oxvary2i
AVXO0fgo63K2OiIFDldCsTiyluylJA==
=0DaQ
-----END PGP SIGNATURE-----

--aBUzk5kBxcksCMQiGzZKo8fIFHJb9btJx--
