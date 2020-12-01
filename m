Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1364C2C93BC
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 01:15:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730271AbgLAAOg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 19:14:36 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:43000 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbgLAAOf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Nov 2020 19:14:35 -0500
Received: by mail-io1-f68.google.com with SMTP id q137so10151085iod.9;
        Mon, 30 Nov 2020 16:14:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=J2Bb/DGEU59ID0I1yu+Ty12fNud+2TMEJ9OnlDR+Pyk=;
        b=my9z4rYOJF26IoCKKb76dA0VlQeLFcuyaH/HL9t/h06/yH3Na8ruWjvhx7tYSFAsko
         MoLFLRsgk/omKHTerqweI8iS+E7AKnW7982w90Ka1RolzdjVBAh7Q6JQHhGES6h/Fnq0
         4unD7W61cgJ+MlRXot6l1Bd7+R31B2oZ1f3N6rIJiEUXDkGS+0l/uHAKsNKLKYk4sFjG
         4ZPOjknlZaItPZCDr/3ju0RirF82O67OHf8hegZuq4aEIHIpj2qwhhkOwF0U71qlmlru
         CgS4q1oKC5Ah3xWY/t78w64+z8tVLZi7DRIuVivZgqC5QVfynIWpUfUqT36xIAS20leW
         wOPQ==
X-Gm-Message-State: AOAM532e/+xDXH0nOhQTnuYMxvRfoJlezESXUniKjLIp8trqSoqw3AoX
        6T7e0P5iJxXeF2PCTXFq1A==
X-Google-Smtp-Source: ABdhPJwaK7q88mv2geaFyacMh+hTtMxdNocxVnhcxhWh7u79E8m8YJseXiGOimQ1zC8gLTT6FTGPSg==
X-Received: by 2002:a02:2e52:: with SMTP id u18mr306280jae.29.1606781634329;
        Mon, 30 Nov 2020 16:13:54 -0800 (PST)
Received: from xps15 ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id o12sm103316ilj.55.2020.11.30.16.13.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Nov 2020 16:13:53 -0800 (PST)
Received: (nullmailer pid 3315444 invoked by uid 1000);
        Tue, 01 Dec 2020 00:13:51 -0000
Date:   Mon, 30 Nov 2020 17:13:51 -0700
From:   Rob Herring <robh@kernel.org>
To:     Dan Murphy <dmurphy@ti.com>
Cc:     davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, ciorneiioana@gmail.com,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v4 3/4] dt-bindings: dp83td510: Add binding for
 DP83TD510 Ethernet PHY
Message-ID: <20201201001351.GA3297586@robh.at.kernel.org>
References: <20201117201555.26723-1-dmurphy@ti.com>
 <20201117201555.26723-4-dmurphy@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117201555.26723-4-dmurphy@ti.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 02:15:54PM -0600, Dan Murphy wrote:
> The DP83TD510 is a 10M single twisted pair Ethernet PHY
> 
> Signed-off-by: Dan Murphy <dmurphy@ti.com>
> ---
>  .../devicetree/bindings/net/ti,dp83td510.yaml | 64 +++++++++++++++++++
>  1 file changed, 64 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,dp83td510.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,dp83td510.yaml b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
> new file mode 100644
> index 000000000000..d3c97bb4d820
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,dp83td510.yaml
> @@ -0,0 +1,64 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +# Copyright (C) 2020 Texas Instruments Incorporated
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/ti,dp83td510.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: TI DP83TD510 ethernet PHY
> +
> +allOf:
> +  - $ref: "ethernet-controller.yaml#"
> +  - $ref: "ethernet-phy.yaml#"
> +
> +maintainers:
> +  - Dan Murphy <dmurphy@ti.com>
> +
> +description: |
> +  The PHY is an twisted pair 10Mbps Ethernet PHY that support MII, RMII and
> +  RGMII interfaces.
> +
> +  Specifications about the Ethernet PHY can be found at:
> +    http://www.ti.com/lit/ds/symlink/dp83td510e.pdf
> +
> +properties:
> +  reg:
> +    maxItems: 1
> +
> +  tx-fifo-depth:
> +    description: |
> +       Transmitt FIFO depth for RMII mode.  The PHY only exposes 4 nibble
> +       depths. The valid nibble depths are 4, 5, 6 and 8.
> +    enum: [ 4, 5, 6, 8 ]
> +    default: 5
> +
> +  rx-internal-delay-ps:
> +    description: |
> +       Setting this property to a non-zero number sets the RX internal delay
> +       for the PHY.  The internal delay for the PHY is fixed to 30ns relative
> +       to receive data.

I'm confused. The delay is 30ns +/- whatever is set here?

> +
> +  tx-internal-delay-ps:
> +    description: |
> +       Setting this property to a non-zero number sets the TX internal delay
> +       for the PHY.  The internal delay for the PHY has a range of -4 to 4ns
> +       relative to transmit data.

Sounds like constraints?

We do have a problem handling negative values though. Addressing in dtc 
was rejected, so we'll need to fixup the schema with unsigned values. 
But here it should just be negative values.

> +
> +unevaluatedProperties: false
> +
> +required:
> +  - reg
> +
> +examples:
> +  - |
> +    mdio0 {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +      ethphy0: ethernet-phy@0 {
> +        reg = <0>;
> +        tx-rx-output-high;
> +        tx-fifo-depth = <5>;
> +        rx-internal-delay-ps = <1>;
> +        tx-internal-delay-ps = <1>;
> +      };
> +    };
> -- 
> 2.29.2
> 
