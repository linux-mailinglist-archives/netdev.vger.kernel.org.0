Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60DDC3919E4
	for <lists+netdev@lfdr.de>; Wed, 26 May 2021 16:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234607AbhEZOVi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 May 2021 10:21:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:48136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233656AbhEZOVe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 May 2021 10:21:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4527D613D7
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 14:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622038803;
        bh=hDglKVObgOcSEVb1KrOuahhVfm4jLoy+K7i3uJw+v10=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WMw48H5pOwYAZwjal0JYKIMylJfeePx8fWeAwGEN1B87VzgVPbFHEsKWaZ8IXnhir
         Tydbb+n2oGLvLv4kbJcDuZkPPAmr0Pn1nrrQZan78uxtfYUK2Rk6853pdzXDBjLIui
         9pc/JkRDPo/InsylXTafDSBn3oT/XoEgHvtM68CRlpRyc0NkHzpCCkkNixXBhKkgcc
         SFaE0xRuUx5h70WFii7/obapqrBzXXJoN9en4mlCYxlhW/phze3R9QYBQsgos2WYNj
         3Ol3kZrm46zpColZc/YorHqS3honLA2RfhWUredHo8b6++m9pMz+pqCJNjnGKcnYhS
         yhSSEsgDo3OAA==
Received: by mail-ed1-f53.google.com with SMTP id j10so1719247edw.8
        for <netdev@vger.kernel.org>; Wed, 26 May 2021 07:20:03 -0700 (PDT)
X-Gm-Message-State: AOAM5337TrbZBDP5c+v3zm77m74hjlCA/KFUnKi8pnea9RG2IoBQYzGv
        OcDvPg1h433dp504XAqgXDjIRenvFBY77UCV9A==
X-Google-Smtp-Source: ABdhPJxEEwNKOmU5hRySNaiX0+Awa/6kFx2hyOVtiJ/2nhF1bbH+tw+x+GDzicgkMiQHqhAxaBiMZ5gYnWZeeSVimEI=
X-Received: by 2002:aa7:cd83:: with SMTP id x3mr37311416edv.373.1622038801924;
 Wed, 26 May 2021 07:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <20210526135535.2515123-1-vladimir.oltean@nxp.com> <20210526135535.2515123-11-vladimir.oltean@nxp.com>
In-Reply-To: <20210526135535.2515123-11-vladimir.oltean@nxp.com>
From:   Rob Herring <robh@kernel.org>
Date:   Wed, 26 May 2021 09:19:49 -0500
X-Gmail-Original-Message-ID: <CAL_JsqJA1cjozmKVA2jW_n5AKrWnGsbtMRfxj9eh+xUZZrNZQw@mail.gmail.com>
Message-ID: <CAL_JsqJA1cjozmKVA2jW_n5AKrWnGsbtMRfxj9eh+xUZZrNZQw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 linux-next 10/14] dt-bindings: net: dsa: sja1105:
 add SJA1110 bindings
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 26, 2021 at 8:56 AM Vladimir Oltean <olteanv@gmail.com> wrote:
>
> There are 4 variations of the SJA1110 switch which have a different set
> of MII protocols supported per port. Document the compatible strings.
>
> Also, the SJA1110 optionally supports 2 internal MDIO buses for 2
> different types of Ethernet PHYs. Document a container node called
> "mdios" which has 2 subnodes "mdio@0" and "mdio@1", identifiable via
> compatible string, under which the driver finds the internal PHYs.
>
> Cc: Rob Herring <robh@kernel.org>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
> Changes in v2:
> Patch is new.
>
>  .../bindings/net/dsa/nxp,sja1105.yaml         | 43 +++++++++++++++++++
>  1 file changed, 43 insertions(+)

Please use get_maintainers.pl and resend to the right lists.
Specifically, the DT list in this case.

> diff --git a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> index c1f18849a54a..640da65b0f59 100644
> --- a/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> +++ b/Documentation/devicetree/bindings/net/dsa/nxp,sja1105.yaml
> @@ -28,10 +28,53 @@ properties:
>            - nxp,sja1105q
>            - nxp,sja1105r
>            - nxp,sja1105s
> +          - nxp,sja1110a
> +          - nxp,sja1110b
> +          - nxp,sja1110c
> +          - nxp,sja1110d
>
>    reg:
>      maxItems: 1
>
> +  # Optional container node for the 2 internal MDIO buses of the SJA1110
> +  # (one for the internal 100base-T1 PHYs and the other for the single
> +  # 100base-TX PHY). The "reg" property does not have physical significance.
> +  # The PHY addresses to port correspondence is as follows: for 100base-T1,
> +  # port 5 has PHY 1, port 6 has PHY 2 etc, while for 100base-TX, port 1 has
> +  # PHY 1.
> +  mdios:
> +    type: object
> +
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^mdio@[0-1]$":
> +        type: object
> +
> +        allOf:
> +          - $ref: "http://devicetree.org/schemas/net/mdio.yaml#"
> +
> +        properties:
> +          compatible:
> +            oneOf:
> +              - enum:

Don't need oneOf when there is only 1 entry.


> +                  - nxp,sja1110-base-t1-mdio
> +                  - nxp,sja1110-base-tx-mdio
> +
> +          reg:
> +            oneOf:
> +              - enum:
> +                - 0
> +                - 1
> +
> +        required:
> +          - compatible
> +          - reg
> +
>  patternProperties:
>    "^(ethernet-)?ports$":
>      type: object
> --
> 2.25.1
>
