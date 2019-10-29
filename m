Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA6DE8FEE
	for <lists+netdev@lfdr.de>; Tue, 29 Oct 2019 20:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbfJ2T1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 15:27:07 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:43809 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725880AbfJ2T1G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Oct 2019 15:27:06 -0400
Received: by mail-ot1-f66.google.com with SMTP id b19so8452484otq.10;
        Tue, 29 Oct 2019 12:27:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=wIe3a78xxOiZpmSWcABZA1DuxeudDH5yZ7C5sebUB98=;
        b=H5BYzx843sQoOm9ejNJvIwZ86Sr3SiyGJ7EAj0A0RTNdQOAijKFbms90G3tl224sFg
         2Ld89OpBXPIWCeFNPmK0taWbBgo8W8yRgNOlObkKItNZEDruNurU+ICm/fg2z44813Kk
         0C2V6tVCE+eHN701cnfcMnyq1wu8YcJwDCaTTvRH/IMzvNm4I4mJkPqWRpWeAwUriicG
         pKw+ZPP/W8YdArOjcMOVx5MovYadFSPZF/Z3b26jqBDEcs37N78upCJhZtYpb/KTO42S
         AkK1rGApLMxU5AN9X7lbdouiPnH5n5+tBQpRD1ghaKIuJpaCr/TFAxYXdvBFvDyp60EI
         +5mg==
X-Gm-Message-State: APjAAAUD9UX3W9bMm2nzIzssM/5F+ok3aDfYadkW408T80pILuRrLII/
        B17DVFxz0OL7IkrEx4n+7GXZ3cQ=
X-Google-Smtp-Source: APXvYqzds4JPWsZE/QgA7kTo06go3N6teX/SzoqJvwPkpm5FAgxusldC7Fz7DV/nTeC04pkisPA/lQ==
X-Received: by 2002:a05:6830:11d2:: with SMTP id v18mr3351848otq.116.1572377225861;
        Tue, 29 Oct 2019 12:27:05 -0700 (PDT)
Received: from localhost (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id z25sm4915181otp.1.2019.10.29.12.27.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2019 12:27:05 -0700 (PDT)
Date:   Tue, 29 Oct 2019 14:27:04 -0500
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Sekhar Nori <nsekhar@ti.com>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [RFC PATCH] dt-bindings: net: davinci-mdio: convert bindings to
 json-schema
Message-ID: <20191029192704.GA24097@bogus>
References: <20191024104730.17708-1-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191024104730.17708-1-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 01:47:30PM +0300, Grygorii Strashko wrote:
> Now that we have the DT validation in place, let's convert the device tree
> bindings for the TI SoC Davinci/OMAP/Keystone2 MDIO Controllerr over to a
> YAML schemas.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
> This my first attempt to work with YAML schemas, hence RFC.

No problems validating this schema, but the example in mdio.yaml isn't 
happy:

/builds/robherring/linux-dt-review/Documentation/devicetree/bindings/net/mdio.example.dt.yaml: 
mdio@5c030000: 'bus_freq' is a required property

> 
>  .../bindings/net/ti,davinci-mdio.yaml         | 64 +++++++++++++++++++
>  1 file changed, 64 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml

Convert implies deleting the old binding...

> 
> diff --git a/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> new file mode 100644
> index 000000000000..e51054d2e0fa
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,davinci-mdio.yaml
> @@ -0,0 +1,64 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ti,davinci-mdio.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: TI SoC Davinci/Keystone2 MDIO Controller
> +
> +maintainers:
> +  - Grygorii Strashko <grygorii.strashko@ti.com>
> +
> +description:
> +  TI SoC Davinci/Keystone2 MDIO Controller Device Tree Bindings
> +
> +allOf:
> +  - $ref: "mdio.yaml#"
> +
> +properties:
> +  compatible:
> +    oneOf:
> +       - const: ti,davinci_mdio
> +       - items:
> +         - const: ti,keystone_mdio
> +         - const: ti,davinci_mdio
> +       - items:
> +         - const: ti,cpsw-mdio
> +         - const: ti,davinci_mdio
> +       - items:
> +         - const: ti,am4372-mdio
> +         - const: ti,cpsw-mdio
> +         - const: ti,davinci_mdio
> +
> +  reg:
> +    maxItems: 1
> +
> +  bus_freq:
> +      maximum: 2500000
> +      description:
> +        Mdio Bus frequency
> +
> +  ti,hwmods:
> +    description: TI hwmod name
> +    deprecated: true
> +    allOf:
> +      - $ref: /schemas/types.yaml#/definitions/string-array
> +      - items:
> +          const: davinci_mdio
> +
> +required:
> +  - compatible
> +  - reg
> +  - bus_freq
> +  - "#address-cells"
> +  - "#size-cells"
> +
> +examples:
> +  - |
> +    davinci_mdio: mdio@4a101000 {
> +         compatible = "ti,davinci_mdio";
> +         #address-cells = <1>;
> +         #size-cells = <0>;
> +         reg = <0x4A101000 0x1000>;

Lowercase hex please.

> +         bus_freq = <1000000>;
> +    };
> -- 
> 2.17.1
> 
