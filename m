Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 12EA429487C
	for <lists+netdev@lfdr.de>; Wed, 21 Oct 2020 08:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395140AbgJUGwG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Oct 2020 02:52:06 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:38764 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2395119AbgJUGwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Oct 2020 02:52:06 -0400
From:   Kurt Kanzenbach <kurt.kanzenbach@linutronix.de>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1603263123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3DA2W6vONxoN9s5vqfqOZvlKIoZcBviB17UCXqX1bAs=;
        b=Ysv1FtWcKnStFkLJTmaKmAgtMdkcyomNhjq6a4E3Z8bkYXirbAQZHFmnfMnqvL1McoQCTj
        zTp1GUKEAhU0ah9royDWEdtYYkD+wMhdvqVBixvOg77GgVdadX6q7pownaagZ84QR4+yX4
        uR1VI8OMIYmbOU1HPierMyjVU2++MW3Jcqi61D1uQHaDVjD0tdQAa0fMdBi8Hx9qq7pnEX
        C38+dbWdPURHWOcEWSPKlnZjkUna8rQ33sbbdnnXhJRODph8I3RL1ZWo9/Eis0i3wb92Qp
        dc6xEJWuxZCAjrdYMPNqcSD/ehP8g2z2UCyUxNDCLJegFzF/8ZN/41flK1GVYw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1603263123;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3DA2W6vONxoN9s5vqfqOZvlKIoZcBviB17UCXqX1bAs=;
        b=SlXCOLUz2Iai99z6ip9Z/Q0xwi/TZd3X1DRnW1jfKUzRzQF2GTF975mqjZOjwEtQDAC8AT
        1Ebz6vXCIxjfOjCw==
To:     Christian Eggers <ceggers@arri.de>,
        Vladimir Oltean <olteanv@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Cc:     Helmut Grohne <helmut.grohne@intenta.de>,
        Paul Barker <pbarker@konsulko.com>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        George McCollister <george.mccollister@gmail.com>,
        Marek Vasut <marex@denx.de>,
        Tristram Ha <Tristram.Ha@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Christian Eggers <ceggers@arri.de>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH net-next 1/9] dt-bindings: net: dsa: convert ksz bindings document to yaml
In-Reply-To: <20201019172435.4416-2-ceggers@arri.de>
References: <20201019172435.4416-1-ceggers@arri.de> <20201019172435.4416-2-ceggers@arri.de>
Date:   Wed, 21 Oct 2020 08:52:01 +0200
Message-ID: <87lfg0rrzi.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Mon Oct 19 2020, Christian Eggers wrote:
> Convert the bindings document for Microchip KSZ Series Ethernet switches
> from txt to yaml.

A few comments/questions below.

> diff --git a/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml
> new file mode 100644
> index 000000000000..f93c3bdd0b83
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/microchip,ksz.yaml

Currently the bindings don't have the company names in front of it.

> @@ -0,0 +1,147 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/microchip,ksz.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microchip KSZ Series Ethernet switches
> +
> +maintainers:
> +  - Marek Vasut <marex@denx.de>
> +  - Woojung Huh <Woojung.Huh@microchip.com>
> +
> +properties:
> +  # See Documentation/devicetree/bindings/net/dsa/dsa.yaml for a list of additional
> +  # required and optional properties.

Don't you need to reference the dsa.yaml binding somehow?

> +  compatible:
> +    enum:
> +      - "microchip,ksz8765"
> +      - "microchip,ksz8794"
> +      - "microchip,ksz8795"
> +      - "microchip,ksz9477"
> +      - "microchip,ksz9897"
> +      - "microchip,ksz9896"
> +      - "microchip,ksz9567"
> +      - "microchip,ksz8565"
> +      - "microchip,ksz9893"
> +      - "microchip,ksz9563"
> +      - "microchip,ksz8563"
> +
> +  reset-gpios:
> +    description:
> +      Should be a gpio specifier for a reset line.
> +    maxItems: 1
> +
> +  microchip,synclko-125:
> +    $ref: /schemas/types.yaml#/definitions/flag
> +    description:
> +      Set if the output SYNCLKO frequency should be set to 125MHz instead of 25MHz.
> +
> +required:
> +  - compatible
> +  - reg
> +
> +examples:
> +  - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
> +    // Ethernet switch connected via SPI to the host, CPU port wired to eth0:
> +    eth0 {
> +        fixed-link {
> +            speed = <1000>;
> +            full-duplex;
> +        };
> +    };
> +
> +    spi0 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        pinctrl-0 = <&pinctrl_spi_ksz>;
> +        cs-gpios = <&pioC 25 0>;
> +        id = <1>;
> +
> +        ksz9477: ksz9477@0 {

The node names should be switch. See dsa.yaml.

> +            compatible = "microchip,ksz9477";
> +            reg = <0>;
> +            reset-gpios = <&gpio5 0 GPIO_ACTIVE_LOW>;
> +
> +            spi-max-frequency = <44000000>;
> +            spi-cpha;
> +            spi-cpol;
> +
> +            ports {

ethernet-ports are preferred.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl+P2pEACgkQeSpbgcuY
8KaczA/6AzfALZkpZ9DZNbpbtJpFlf1VULgRs+Dya20BxFssdpsN6f3PzJZUQ109
HzYIE6/24kmWuG4LZS+y8MvZMXia1fndb6jjraKsUsMgCOvDs5wruUMvNjohHVZC
4q0N8h0jPuw62aW2BLB6OL//h7+EKA3FrYaPW+1WTZ7z/VrcIAESOp2EP1szwucz
VEoE3kZVltQQYUDDxr8/UdTujpVF4/1gck3iM1wrAmIHH5i3XMy3VDLqM4msRkF1
LtEqAkniRxqAXPrM5ibhQZPBxNXr93kHrmr6KnmcOxzVZYojB01Lu8kDUbpSF0p7
PWh8FM9hj2DpeTjISgj3amH9knCcVa5duBMPSAXHlcYpXW0jEt9b0GCW2j6ec+wm
zxlPwhS2LYE6DSmQSwzDhJQw2Oc7zIyt4B5kSfPk4IPhLv7KHqRJOd7+FN6wFyFP
kmjGRXCruqz2pxlZFSDtCno5FoiMZy1/E49Sy+vRAaK2cEXkTPs1di8Zb50wyiJV
OnPDjfA7YP+v+YrDDStj5Odc6BpYwgQC3widdMLguLbQyvj9w9hnX2C2vKhGTqho
DK6SUts2p+OqJF+aDAOqqcU0r9yPqweF1tqJPWXdgPMF+r4I68MzOW9AhwQqzDsD
Qk2J9lMADEJxELGL4s+6qqxIQlezRgy9pziZ+x+7da64DqEITJA=
=jU8i
-----END PGP SIGNATURE-----
--=-=-=--
