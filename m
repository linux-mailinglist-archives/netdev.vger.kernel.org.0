Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0EAD415EDD
	for <lists+netdev@lfdr.de>; Thu, 23 Sep 2021 14:53:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241096AbhIWMyg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Sep 2021 08:54:36 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:46772 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241012AbhIWMye (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Sep 2021 08:54:34 -0400
Received: by mail-ot1-f41.google.com with SMTP id o59-20020a9d2241000000b0054745f28c69so6269216ota.13;
        Thu, 23 Sep 2021 05:53:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=T5pin4HBy/8oX+1D69jVpHUNgiCC1/7/deC2d6STVN4=;
        b=zGaf4a22lvB0eEZ3DurNfF4VSm7cxd2HvZMV8J9SGVpe08OuonpyU7rpSRxuKv8YLz
         PnBLNLBhFKcbJL4fIghjX8gULk0wtrD0xO1GFfQ+Q1EETX8P+2hnenmg7+2hi0Zffml2
         cKpbWzEPPl4JbbBbfFdjpHbhUwyWpBodkWmHXDi0xYqJw/nA/5HcxRP2iFZaRfESCsEa
         5YDD40gsLqWjT/WINb7h21Jvqo2x4/HAYzg1WneMJmoU6eJP++veoPxdL5BGSGcnlASs
         rMMEKPpp24/8m/wlddUGOwVUq2lKlHqrPipKp2K5Hj++bf9+DzlipEHIRE+46iM73aaK
         lwmg==
X-Gm-Message-State: AOAM53140oL9DUhzbDEDqscK1241AjJW3xDw1tQPrh4Z3boDdzYcjJoU
        JKih5O4uOAhytcdAfda8Pg==
X-Google-Smtp-Source: ABdhPJx8/3hAVrRwReb56QdQatIrscxOfd4EPLlBYorNiziE9+o4Y1SN5nI078poAoT3V7CJC59j4w==
X-Received: by 2002:a9d:77d4:: with SMTP id w20mr3929655otl.321.1632401582959;
        Thu, 23 Sep 2021 05:53:02 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id 14sm1262633oiy.53.2021.09.23.05.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Sep 2021 05:53:02 -0700 (PDT)
Received: (nullmailer pid 2834023 invoked by uid 1000);
        Thu, 23 Sep 2021 12:53:01 -0000
Date:   Thu, 23 Sep 2021 07:53:01 -0500
From:   Rob Herring <robh@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        linux@armlinux.org.uk, f.fainelli@gmail.com,
        alexandre.belloni@bootlin.com, vladimir.oltean@nxp.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-phy@lists.infradead.org, linux-pm@vger.kernel.org
Subject: Re: [RFC PATCH net-next 08/12] dt-bindings: net: lan966x: Add
 lan966x-switch bindings
Message-ID: <YUx4rQtEw4fquxs0@robh.at.kernel.org>
References: <20210920095218.1108151-1-horatiu.vultur@microchip.com>
 <20210920095218.1108151-9-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210920095218.1108151-9-horatiu.vultur@microchip.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Sep 20, 2021 at 11:52:14AM +0200, Horatiu Vultur wrote:
> Document the lan966x switch device driver bindings
> 
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
> ---
>  .../net/microchip,lan966x-switch.yaml         | 114 ++++++++++++++++++
>  1 file changed, 114 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> new file mode 100644
> index 000000000000..53d72a65c168
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/microchip,lan966x-switch.yaml
> @@ -0,0 +1,114 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/microchip,lan966x-switch.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Microchip Lan966x Ethernet switch controller
> +
> +maintainers:
> +  - Horatiu Vultur <horatiu.vultur@microchip.com>
> +  - UNGLinuxDriver@microchip.com
> +
> +description: |
> +  The Lan966x Enterprise Ethernet switch family provides a rich set of
> +  Enterprise switching features such as advanced TCAM-based VLAN and
> +  QoS processing enabling delivery of differentiated services, and
> +  security through TCAM-based frame processing using versatile content
> +  aware processor (VCAP).
> +
> +properties:
> +  $nodename:
> +    pattern: "^switch@[0-9a-f]+$"
> +
> +  compatible:
> +    const: microchip,lan966x-switch
> +
> +  reg:
> +    items:
> +      - description: cpu target
> +      - description: devices target
> +      - description: general control block target
> +
> +  reg-names:
> +    items:
> +      - const: cpu
> +      - const: devices
> +      - const: gcb
> +
> +  interrupts:
> +    minItems: 1

Don't need minItems unless it is less than number of entries for 
'items'.

> +    items:
> +      - description: register based extraction
> +
> +  interrupt-names:
> +    minItems: 1
> +    items:
> +      - const: xtr
> +
> +  mac-address: true
> +
> +  ethernet-ports:
> +    type: object
> +    patternProperties:
> +      "^port@[0-9a-f]+$":

ethernet-port is preferred on new bindings.

> +        type: object
> +
> +        properties:
> +          '#address-cells':
> +            const: 1
> +          '#size-cells':
> +            const: 0
> +
> +          reg:
> +            description: Switch port number
> +
> +          phy-mode:
> +            description:
> +              This specifies the interface used by the Ethernet SerDes towards
> +              the PHY or SFP.
> +
> +          phy-handle:
> +            description:
> +              phandle of a Ethernet PHY.
> +
> +        required:
> +          - reg
> +          - phy-mode
> +          - phy-handle
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - interrupt-names
> +  - ethernet-ports
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
> +    switch: switch@600000000 {

Drop unused labels.

> +      compatible = "microchip,lan966x-switch";
> +      reg =  <0 0x401000>,
> +             <0x10004000 0x7fc000>,
> +             <0x11010000 0xaf0000>;
> +      reg-names = "cpu", "devices", "gcb";
> +      interrupts = <GIC_SPI 30 IRQ_TYPE_LEVEL_HIGH>;
> +      interrupt-names = "xtr";
> +      ethernet-ports {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        port0: port@0 {
> +          reg = <0>;
> +          phy-handle = <&phy0>;
> +          phy-mode = "gmii";
> +        };
> +      };
> +    };
> +
> +...
> +#  vim: set ts=2 sw=2 sts=2 tw=80 et cc=80 ft=yaml :

Ummm, no.

> -- 
> 2.31.1
> 
> 
