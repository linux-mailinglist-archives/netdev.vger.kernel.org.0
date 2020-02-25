Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8961E16EBD3
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 17:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731181AbgBYQ5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Feb 2020 11:57:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:55846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727983AbgBYQ5N (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Feb 2020 11:57:13 -0500
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B664C21927;
        Tue, 25 Feb 2020 16:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582649832;
        bh=90JBCZvuUwjkSs1Hnc3LpN1N/kPAIDcqYTB1iAObgdY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=2OT1bZXD227lBlfGSt2jsJ3rPt6z/gNKbLuKbylKTau3IUc7jhdLumNvYIIHHYJDq
         i6YDuBL/cysZRA31xcnYBbQO4vvATKpFxNsLrndeYJtf5zqLIlEwxoNSpU5EeTNjtA
         TNoO1adeYDCBYlu7+PdEgXhJOI/a6sF/0axR8Tf4=
Received: by mail-qt1-f172.google.com with SMTP id d9so96461qte.12;
        Tue, 25 Feb 2020 08:57:12 -0800 (PST)
X-Gm-Message-State: APjAAAU3RjHl+H/RQcjTIL09oKRc0kQxC+GUlD7glqe7N8TjZpoy6Ecc
        V5nk/AomzA6E5j5Y+7CN0y+oYRu1/NsbsXVnFw==
X-Google-Smtp-Source: APXvYqynQGVCaS6vsUSmY1psEfHgy4a65Fy7HlLUFGmtipR1MpihYRNwkGCOJdMOtj5iyqJoT2+ascR04bYI1hr352c=
X-Received: by 2002:ac8:5513:: with SMTP id j19mr54927970qtq.143.1582649831805;
 Tue, 25 Feb 2020 08:57:11 -0800 (PST)
MIME-Version: 1.0
References: <20200224211035.16897-1-ansuelsmth@gmail.com> <20200224211035.16897-2-ansuelsmth@gmail.com>
In-Reply-To: <20200224211035.16897-2-ansuelsmth@gmail.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Tue, 25 Feb 2020 10:57:00 -0600
X-Gmail-Original-Message-ID: <CAL_JsqL7hAX81hDg8L24n-xpJGzZLEu+kAvJfw=g2pzEo_LPOw@mail.gmail.com>
Message-ID: <CAL_JsqL7hAX81hDg8L24n-xpJGzZLEu+kAvJfw=g2pzEo_LPOw@mail.gmail.com>
Subject: Re: [PATCH v7 2/2] Documentation: devictree: Add ipq806x mdio bindings
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 24, 2020 at 3:10 PM Ansuel Smith <ansuelsmth@gmail.com> wrote:
>

typo in the subject. Use 'dt-bindings: net: ...' for the subject prefix.

> Add documentations for ipq806x mdio driver.
>
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> ---
> Changes in v7:
> - Fix dt_binding_check problem

Um, no you didn't...

>
>  .../bindings/net/qcom,ipq8064-mdio.yaml       | 55 +++++++++++++++++++
>  1 file changed, 55 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> new file mode 100644
> index 000000000000..3178cbfdc661
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/qcom,ipq8064-mdio.yaml
> @@ -0,0 +1,55 @@
> +# SPDX-License-Identifier: GPL-2.0-or-later

Dual license new bindings please:

(GPL-2.0-only OR BSD-2-Clause)

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/qcom,ipq8064-mdio.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Qualcomm ipq806x MDIO bus controller
> +
> +maintainers:
> +  - Ansuel Smith <ansuelsmth@gmail.com>
> +
> +description: |+

Don't need '|+' unless you need specific formatting.

> +  The ipq806x soc have a MDIO dedicated controller that is
> +  used to comunicate with the gmac phy conntected.
> +  Child nodes of this MDIO bus controller node are standard
> +  Ethernet PHY device nodes as described in
> +  Documentation/devicetree/bindings/net/phy.txt
> +
> +allOf:
> +  - $ref: "mdio.yaml#"
> +
> +properties:
> +  compatible:
> +    const: qcom,ipq8064-mdio

blank line between properties please.

> +  reg:
> +    maxItems: 1
> +    description: address and length of the register set for the device

That's every 'reg', you can drop this.

> +  clocks:
> +    maxItems: 1
> +    description: A reference to the clock supplying the MDIO bus controller

That's every 'clocks', you can drop this.

> +
> +required:
> +  - compatible
> +  - reg
> +  - clocks
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +examples:
> +  - |
> +    mdio0: mdio@37000000 {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        compatible = "qcom,ipq8064-mdio", "syscon";

'syscon' doesn't match the schema and is wrong.

> +        reg = <0x37000000 0x200000>;

> +        resets = <&gcc GMAC_CORE1_RESET>;
> +        reset-names = "stmmaceth";

Not documented.

> +        clocks = <&gcc GMAC_CORE1_CLK>;

You need to include the header for these defines.

> +
> +        switch@10 {
> +            compatible = "qca,qca8337";
> +            /* ... */
> +        };
> +    };
> --
> 2.25.0
>
