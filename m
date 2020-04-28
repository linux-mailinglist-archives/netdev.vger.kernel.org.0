Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0857F1BC6CC
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 19:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728678AbgD1RaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 13:30:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727957AbgD1RaT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 13:30:19 -0400
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1116A21973;
        Tue, 28 Apr 2020 17:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588095018;
        bh=UEPvdsFLZuxyXGyDFPNcLESa54VFBSMo+Mr0GQ+Emqo=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bTFHh/WIuvmbk/bSvwY0RZBHITiBmfMDCNwRZr/A2ND5VmZKjSjqAEtdky2yZP42w
         JKPiC7uW7weGpoSSIFlMSSD4ZneQloxCwEthChbGal5DO/aZwYtKaLZ4FZYp0ABBLK
         Fk4jMLxqWqMXQJdae5AMmJ39KU59h/y15LP5vc18=
Received: by mail-ot1-f54.google.com with SMTP id z17so34111172oto.4;
        Tue, 28 Apr 2020 10:30:18 -0700 (PDT)
X-Gm-Message-State: AGi0Pua6UWBc2NuiN1vvtApJk07dCxjto0vTc+gEiAH41JlEuC9eocMi
        gsCWHe9l4ZG5AeXZd3enA3vOhimRVdevJ1dnSw==
X-Google-Smtp-Source: APiQypKv4FZ4K30K1NKNMGZpRnvlNr6wl7/ahmDYwJQ8Fs5dLgV7nH6WSJzRl/GzUE+ZEIPP7UAqPT4U6z5DbwsJBAI=
X-Received: by 2002:a9d:1441:: with SMTP id h59mr23779737oth.192.1588095017244;
 Tue, 28 Apr 2020 10:30:17 -0700 (PDT)
MIME-Version: 1.0
References: <20200313052252.25389-1-o.rempel@pengutronix.de> <20200313052252.25389-2-o.rempel@pengutronix.de>
In-Reply-To: <20200313052252.25389-2-o.rempel@pengutronix.de>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 28 Apr 2020 12:30:06 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJgwKjWnTETB1pDc+aXVYp0c-cYOE6gz_KYOn5byQOKpA@mail.gmail.com>
Message-ID: <CAL_JsqJgwKjWnTETB1pDc+aXVYp0c-cYOE6gz_KYOn5byQOKpA@mail.gmail.com>
Subject: Re: [PATCH v4 1/4] dt-bindings: net: phy: Add support for NXP TJA11xx
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Marek Vasut <marex@denx.de>,
        David Jander <david@protonic.nl>, devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 13, 2020 at 12:23 AM Oleksij Rempel <o.rempel@pengutronix.de> wrote:
>
> Document the NXP TJA11xx PHY bindings.

Given the discussion, I'd marked this one as "changes requested"
expecting a new version to review the schema. And gmail decided to
make a new thread due to the extra 'RE:'. So it fell off my radar.

This schema is fundamentally broken as there's no way to match for
when to apply this schema. How do we find a NXP TJA11xx PHY? I suppose
we can look for 'ethernet-phy' with a child node 'ethernet-phy', but
then that would apply to any phy like this one. This needs a
compatible string IMO given it is non-standard.

>
> Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
> ---
>  .../devicetree/bindings/net/nxp,tja11xx.yaml  | 61 +++++++++++++++++++
>  1 file changed, 61 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> new file mode 100644
> index 000000000000..42be0255512b
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/nxp,tja11xx.yaml
> @@ -0,0 +1,61 @@
> +# SPDX-License-Identifier: GPL-2.0+

Dual license new bindings:

(GPL-2.0-only OR BSD-2-Clause)

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/nxp,tja11xx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: NXP TJA11xx PHY
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Heiner Kallweit <hkallweit1@gmail.com>
> +
> +description:
> +  Bindings for NXP TJA11xx automotive PHYs

Perhaps some information about how this phy is special.

> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#

Not needed here as ethernet-phy.yaml already has a 'select' condition to apply.

> +
> +patternProperties:
> +  "^ethernet-phy@[0-9a-f]+$":
> +    type: object
> +    description: |
> +      Some packages have multiple PHYs. Secondary PHY should be defines as
> +      subnode of the first (parent) PHY.
> +
> +    properties:
> +      reg:
> +        minimum: 0
> +        maximum: 31
> +        description:
> +          The ID number for the child PHY. Should be +1 of parent PHY.
> +
> +    required:
> +      - reg
> +
> +examples:
> +  - |
> +    mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        tja1101_phy0: ethernet-phy@4 {
> +            reg = <0x4>;
> +        };
> +    };
> +  - |
> +    mdio {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        tja1102_phy0: ethernet-phy@4 {
> +            reg = <0x4>;

> +            #address-cells = <1>;
> +            #size-cells = <0>;

These aren't documented.

> +
> +            tja1102_phy1: ethernet-phy@5 {
> +                reg = <0x5>;
> +            };
> +        };
> +    };
> --
> 2.25.1
>
