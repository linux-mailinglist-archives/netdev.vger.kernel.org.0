Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2926F58F94
	for <lists+netdev@lfdr.de>; Fri, 28 Jun 2019 03:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfF1BQO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 21:16:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:50542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726579AbfF1BQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 21:16:14 -0400
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 79C5A215EA;
        Fri, 28 Jun 2019 01:16:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561684573;
        bh=Z9yocx8qQWhLGVeHQQwWu+OcwqV+thBQlAOsCplTlCk=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=A1BokdVi10ZhUBO/HUkH3Y4ylk6a6ZBSyja4sDiAtoFTq3CS+UOmoclUJewcAKtvV
         ud48/RJ5R10WnjQBJeaQw5vsMjXmvNOp8nmhJesOK58bXRaIx4cR2bhgBsA2+nv7N0
         WDv0wkzrT7CQAgA+GgUZ1UNUcartqHNWWrb7YkQY=
Received: by mail-qt1-f175.google.com with SMTP id j19so4559062qtr.12;
        Thu, 27 Jun 2019 18:16:13 -0700 (PDT)
X-Gm-Message-State: APjAAAXS+Y1ylQSTkKNHtvPRNEa3Ox38KdFwYy4L8roO2S5/UZJVfxJj
        iCAKImtdYF5qcidNboUUSqVOdhHcvaPV6S+n9A==
X-Google-Smtp-Source: APXvYqy3SrNqxnKgSsphHt1HwJRh2CjKXy+obFOvY+TpNLf1WKgrdAvAlOo5bMvYt0Olym7oKFynePl1OSb37uMLnUw=
X-Received: by 2002:aed:3fb0:: with SMTP id s45mr6010512qth.136.1561684572669;
 Thu, 27 Jun 2019 18:16:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.e80da8845680a45c2e07d5f17280fdba84555b8a.1561649505.git-series.maxime.ripard@bootlin.com>
 <945e54f02cc36a543b4c0bfd960475147359f7ff.1561649505.git-series.maxime.ripard@bootlin.com>
In-Reply-To: <945e54f02cc36a543b4c0bfd960475147359f7ff.1561649505.git-series.maxime.ripard@bootlin.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Thu, 27 Jun 2019 19:16:01 -0600
X-Gmail-Original-Message-ID: <CAL_JsqJ0-p2w77OyaN07=DEdMzmUpPmPPMyqYj3jZJX+PV8LiA@mail.gmail.com>
Message-ID: <CAL_JsqJ0-p2w77OyaN07=DEdMzmUpPmPPMyqYj3jZJX+PV8LiA@mail.gmail.com>
Subject: Re: [PATCH v4 02/13] dt-bindings: net: Add a YAML schemas for the
 generic PHY options
To:     Maxime Ripard <maxime.ripard@bootlin.com>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Frank Rowand <frowand.list@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Chen-Yu Tsai <wens@csie.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        netdev <netdev@vger.kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Maxime Chevallier <maxime.chevallier@bootlin.com>,
        =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@bootlin.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 27, 2019 at 9:32 AM Maxime Ripard <maxime.ripard@bootlin.com> wrote:
>
> The networking PHYs have a number of available device tree properties that
> can be used in their device tree node. Add a YAML schemas for those.
>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> Reviewed-by: Rob Herring <robh@kernel.org>
> Signed-off-by: Maxime Ripard <maxime.ripard@bootlin.com>
> ---
>  Documentation/devicetree/bindings/net/ethernet-phy.yaml | 179 +++++++++-
>  Documentation/devicetree/bindings/net/phy.txt           |  80 +----
>  2 files changed, 180 insertions(+), 79 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/ethernet-phy.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> new file mode 100644
> index 000000000000..81d2016d7232
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -0,0 +1,179 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ethernet-phy.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Ethernet PHY Generic Binding
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Heiner Kallweit <hkallweit1@gmail.com>
> +
> +# The dt-schema tools will generate a select statement first by using
> +# the compatible, and second by using the node name if any. In our
> +# case, the node name is the one we want to match on, while the
> +# compatible is optional.
> +select:
> +  properties:
> +    $nodename:
> +      pattern: "^ethernet-phy(@[a-f0-9]+)?$"
> +
> +  required:
> +    - $nodename
> +
> +properties:
> +  $nodename:
> +    pattern: "^ethernet-phy(@[a-f0-9]+)?$"
> +
> +  compatible:
> +    oneOf:
> +      - const: ethernet-phy-ieee802.3-c22
> +        description: PHYs that implement IEEE802.3 clause 22
> +      - const: ethernet-phy-ieee802.3-c45
> +        description: PHYs that implement IEEE802.3 clause 45
> +      - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
> +        description:
> +          If the PHY reports an incorrect ID (or none at all) then the
> +          compatible list may contain an entry with the correct PHY ID
> +          in the above form.
> +          The first group of digits is the 16 bit Phy Identifier 1
> +          register, this is the chip vendor OUI bits 3:18. The
> +          second group of digits is the Phy Identifier 2 register,
> +          this is the chip vendor OUI bits 19:24, followed by 10
> +          bits of a vendor specific ID.
> +      - items:
> +          - pattern: "^ethernet-phy-id[a-f0-9]{4}\\.[a-f0-9]{4}$"
> +          - const: ethernet-phy-ieee802.3-c45
> +
> +  reg:
> +    maxItems: 1
> +    minimum: 0
> +    maximum: 31
> +    description:
> +      The ID number for the PHY.

Mixing array and scalar properties is something we shouldn't be doing,
so I dropped maxItems as that is implied. I have a meta-schema check
for this once a couple of occurrences are fixed in the tree.

Rob
