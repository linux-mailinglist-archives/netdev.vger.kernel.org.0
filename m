Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C4335F7E4
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:48:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350483AbhDNPdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350347AbhDNPdp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:33:45 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E30C061574
        for <netdev@vger.kernel.org>; Wed, 14 Apr 2021 08:33:23 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=bjornoya.blackshift.org)
        by metis.ext.pengutronix.de with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <mkl@pengutronix.de>)
        id 1lWhVr-0004Ij-Pa; Wed, 14 Apr 2021 17:33:07 +0200
Received: from pengutronix.de (unknown [IPv6:2a03:f580:87bc:d400:69d2:43d8:822b:d361])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (Client did not present a certificate)
        (Authenticated sender: mkl-all@blackshift.org)
        by smtp.blackshift.org (Postfix) with ESMTPSA id B6BBF60EA4F;
        Wed, 14 Apr 2021 15:33:04 +0000 (UTC)
Date:   Wed, 14 Apr 2021 17:33:03 +0200
From:   Marc Kleine-Budde <mkl@pengutronix.de>
To:     Aswath Govindraju <a-govindraju@ti.com>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-phy@lists.infradead.org,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
Subject: Re: [PATCH v2 3/6] dt-bindings: phy: Add binding for TI TCAN104x CAN
 transceivers
Message-ID: <20210414153303.yig6bguue3g25yhg@pengutronix.de>
References: <20210414140521.11463-1-a-govindraju@ti.com>
 <20210414140521.11463-4-a-govindraju@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="ye5l67gk7hz5picn"
Content-Disposition: inline
In-Reply-To: <20210414140521.11463-4-a-govindraju@ti.com>
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: mkl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ye5l67gk7hz5picn
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 14.04.2021 19:35:18, Aswath Govindraju wrote:
> Add binding documentation for TI TCAN104x CAN transceivers.
>=20
> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
> ---
>  .../bindings/phy/ti,tcan104x-can.yaml         | 56 +++++++++++++++++++
>  MAINTAINERS                                   |  1 +
>  2 files changed, 57 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/phy/ti,tcan104x-can=
=2Eyaml
>=20
> diff --git a/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml b=
/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> new file mode 100644
> index 000000000000..4abfc30a97d0
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
> @@ -0,0 +1,56 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/phy/ti,tcan104x-can.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: TCAN104x CAN TRANSCEIVER PHY
> +
> +maintainers:
> +  - Aswath Govindraju <a-govindraju@ti.com>
> +
> +properties:
> +  $nodename:
> +    pattern: "^tcan104x-phy"
> +
> +  compatible:
> +    enum:
> +      - ti,tcan1042
> +      - ti,tcan1043

Can you ensure that the 1042 has only the standby gpio and the 1043 has bot=
h?

> +
> +  '#phy-cells':
> +    const: 0
> +
> +  standby-gpios:
> +    description:
> +      gpio node to toggle standby signal on transceiver
> +    maxItems: 1
> +
> +  enable-gpios:
> +    description:
> +      gpio node to toggle enable signal on transceiver
> +    maxItems: 1
> +
> +  max-bitrate:
> +    $ref: /schemas/types.yaml#/definitions/uint32
> +    description:
> +      max bit rate supported in bps
> +    minimum: 1
> +
> +required:
> +  - compatible
> +  - '#phy-cells'
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    transceiver1: tcan104x-phy {
> +      compatible =3D "ti,tcan1043";
> +      #phy-cells =3D <0>;
> +      max-bitrate =3D <5000000>;
> +      standby-gpios =3D <&wakeup_gpio1 16 GPIO_ACTIVE_LOW>;
> +      enable-gpios =3D <&main_gpio1 67 GPIO_ACTIVE_LOW>;

AFAICS the enable gpio is active high.

Marc

--=20
Pengutronix e.K.                 | Marc Kleine-Budde           |
Embedded Linux                   | https://www.pengutronix.de  |
Vertretung West/Dortmund         | Phone: +49-231-2826-924     |
Amtsgericht Hildesheim, HRA 2686 | Fax:   +49-5121-206917-5555 |

--ye5l67gk7hz5picn
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCgAdFiEEK3kIWJt9yTYMP3ehqclaivrt76kFAmB3Cy0ACgkQqclaivrt
76mT/Af/WbnwgQ+a+aRsKHyfyTWezRr8G7s1RJjQLJFVegSR6EulxFLwmut1kluw
rSVTQwfdgixY+aZeufAxAcz7NrIJb80Lmc5iNj+ClFYPb/nVagJ2ctjiddJilJ56
df3vL1M2b4CUoE0fQN9MyfHeVKz81LY69QtXSOOdcgE+oTSOWUUpNFfpyVgtJHjN
ZV8VGlxIt81gly02Gu1HZ2E0TDhRw9yy3dvGgh4hsckCaxCwwCon2MOOtmHRVKuF
WqlJjpfd8jtdjG2WkKr/MnD4eqQR93nbnVzvBbyPxgqan/bN5vzXSAr+pwNRB0sS
ejLqSWJS+Owu4gPtn1wDwDMyTz5jvA==
=S3kp
-----END PGP SIGNATURE-----

--ye5l67gk7hz5picn--
