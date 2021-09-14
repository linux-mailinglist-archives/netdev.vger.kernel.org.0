Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F5DF40B317
	for <lists+netdev@lfdr.de>; Tue, 14 Sep 2021 17:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234582AbhINPbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Sep 2021 11:31:12 -0400
Received: from mail-ot1-f47.google.com ([209.85.210.47]:37716 "EHLO
        mail-ot1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233202AbhINPbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Sep 2021 11:31:12 -0400
Received: by mail-ot1-f47.google.com with SMTP id i3-20020a056830210300b0051af5666070so19012495otc.4;
        Tue, 14 Sep 2021 08:29:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hY3n620qkUe68a0lR/eM4pnBZx4xVNZn3jSpa0Q0FXI=;
        b=xOiAv1rEC2znFH0Oj5g6uK92wtj73mdct8n/1fVLldmk/mxQseA2yIDYn3KYrmPkoB
         7K/3I70FEfqLIf5fYO8PKqLsCykvOCVlyR9iYs66Uq7+3LXDAB+gqjQkEx0a5u/BwDxE
         IsUeSwRCHxWUOSecVH9lElfMgS7vhR2oAJPNCC6BzpMEDErFrFQpdPwGt86G3A9qYwWP
         l3/HBka9ZlLrAzsJrGmsskVLsmQucHImxh1f4cEcLj/s3izCDVZZRX1QoS+uEs1SJYVj
         lCzTXbfb9ZTt21Qg/psHin+TPoi0upQBLLyhKZTViQDhv11Y5R3vuiJVKOzrx5VhoCgg
         lOjw==
X-Gm-Message-State: AOAM533bLixxkYEY+MWkkAW1QOS+pXIZJYNjxiIyw3cRtfx2NiLUMrA9
        heMAPVs8JvZnaZtz75FaMo6f+/y05A==
X-Google-Smtp-Source: ABdhPJzRUZ4ZMrRc9mURnyKePfileuuXOyxTiC7JxVwjZOsKyviPYdj5t2RGvnmyMMSCPT9UPGRUrg==
X-Received: by 2002:a05:6830:241d:: with SMTP id j29mr15258826ots.47.1631633394245;
        Tue, 14 Sep 2021 08:29:54 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id q13sm2712339ota.17.2021.09.14.08.29.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 08:29:53 -0700 (PDT)
Received: (nullmailer pid 3326462 invoked by uid 1000);
        Tue, 14 Sep 2021 15:29:52 -0000
Date:   Tue, 14 Sep 2021 10:29:52 -0500
From:   Rob Herring <robh@kernel.org>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: Add bindings for IXP4xx V.35 WAN HSS
Message-ID: <YUC/8HriKjisxslU@robh.at.kernel.org>
References: <20210908221118.138045-1-linus.walleij@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210908221118.138045-1-linus.walleij@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 09, 2021 at 12:11:18AM +0200, Linus Walleij wrote:
> This adds device tree bindings for the IXP4xx V.35 WAN high
> speed serial (HSS) link.
> 
> An example is added to the NPE example where the HSS appears
> as a child.
> 
> Cc: devicetree@vger.kernel.org
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
> ---
> Currently only adding these bindings so we can describe the
> hardware in device trees.
> ---
>  ...ntel,ixp4xx-network-processing-engine.yaml |  26 ++++
>  .../bindings/net/intel,ixp4xx-hss.yaml        | 129 ++++++++++++++++++
>  2 files changed, 155 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
> 
> diff --git a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
> index c435c9f369a4..179e5dea32b0 100644
> --- a/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
> +++ b/Documentation/devicetree/bindings/firmware/intel,ixp4xx-network-processing-engine.yaml
> @@ -45,9 +45,35 @@ additionalProperties: false
>  
>  examples:
>    - |
> +    #include <dt-bindings/gpio/gpio.h>
> +
>      npe: npe@c8006000 {
>           compatible = "intel,ixp4xx-network-processing-engine";
>           reg = <0xc8006000 0x1000>, <0xc8007000 0x1000>, <0xc8008000 0x1000>;
> +         #address-cells = <1>;
> +         #size-cells = <0>;
> +
> +         hss@0 {
> +             compatible = "intel,ixp4xx-hss";
> +             reg = <0>;
> +             intel,npe-handle = <&npe 0>;
> +             queue-chl-rxtrig = <&qmgr 12>;
> +             queue-pkt-rx = <&qmgr 13>;
> +             queue-pkt-tx0 = <&qmgr 14>;
> +             queue-pkt-tx1 = <&qmgr 15>;
> +             queue-pkt-tx2 = <&qmgr 16>;
> +             queue-pkt-tx3 = <&qmgr 17>;
> +             queue-pkt-rxfree0 = <&qmgr 18>;
> +             queue-pkt-rxfree1 = <&qmgr 19>;
> +             queue-pkt-rxfree2 = <&qmgr 20>;
> +             queue-pkt-rxfree3 = <&qmgr 21>;
> +             queue-pkt-txdone = <&qmgr 22>;

Need vendor prefix on all these. Maybe some can be arrays (e.g. tx0, 
tx1, tx2, tx3)?

> +             cts-gpios = <&gpio0 10 GPIO_ACTIVE_LOW>;
> +             rts-gpios = <&gpio0 14 GPIO_ACTIVE_LOW>;
> +             dcd-gpios = <&gpio0 6 GPIO_ACTIVE_LOW>;
> +             dtr-gpios = <&gpio_74 2 GPIO_ACTIVE_LOW>;
> +             clk-internal-gpios = <&gpio_74 0 GPIO_ACTIVE_HIGH>;
> +         };
>  
>           crypto {
>               compatible = "intel,ixp4xx-crypto";
> diff --git a/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml b/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
> new file mode 100644
> index 000000000000..a5a9a14a1242
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/intel,ixp4xx-hss.yaml
> @@ -0,0 +1,129 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +# Copyright 2021 Linaro Ltd.
> +%YAML 1.2
> +---
> +$id: "http://devicetree.org/schemas/net/intel,ixp4xx-hss.yaml#"
> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
> +
> +title: Intel IXP4xx V.35 WAN High Speed Serial Link (HSS)
> +
> +maintainers:
> +  - Linus Walleij <linus.walleij@linaro.org>
> +
> +description: |
> +  The Intel IXP4xx HSS makes use of the IXP4xx NPE (Network
> +  Processing Engine) and the IXP4xx Queue Manager to process
> +  V.35 Wideband Modem (WAN) links.
> +
> +properties:
> +  compatible:
> +    const: intel,ixp4xx-hss
> +
> +  reg:
> +    maxItems: 1
> +    description: The HSS instance
> +
> +  intel,npe-handle:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the NPE this HSS instance is using
> +      and the instance to use in the second cell
> +
> +  queue-chl-rxtrig:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the RX trigger queue on the NPE
> +
> +  queue-pkt-rx:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the packet RX queue on the NPE
> +
> +  queue-pkt-tx0:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the packet TX0 queue on the NPE
> +
> +  queue-pkt-tx1:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the packet TX1 queue on the NPE
> +
> +  queue-pkt-tx2:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the packet TX2 queue on the NPE
> +
> +  queue-pkt-tx3:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the packet TX3 queue on the NPE
> +
> +  queue-pkt-rxfree0:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the packet RXFREE0 queue on the NPE
> +
> +  queue-pkt-rxfree1:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the packet RXFREE1 queue on the NPE
> +
> +  queue-pkt-rxfree2:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the packet RXFREE2 queue on the NPE
> +
> +  queue-pkt-rxfree3:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the packet RXFREE3 queue on the NPE
> +
> +  queue-pkt-txdone:
> +    $ref: '/schemas/types.yaml#/definitions/phandle-array'
> +    maxItems: 1
> +    description: phandle to the packet TXDONE queue on the NPE
> +
> +  cts-gpios:
> +    maxItems: 1
> +    description: Clear To Send (CTS) GPIO line
> +
> +  rts-gpios:
> +    maxItems: 1
> +    description: Ready To Send (RTS) GPIO line
> +
> +  dcd-gpios:
> +    maxItems: 1
> +    description: Data Carrier Detect (DCD) GPIO line
> +
> +  dtr-gpios:
> +    maxItems: 1
> +    description: Data Terminal Ready (DTR) GPIO line
> +
> +  clk-internal-gpios:
> +    maxItems: 1
> +    description: Clock internal GPIO line, driving this high will make the HSS
> +      use internal clocking as opposed to external clocking
> +
> +required:
> +  - compatible
> +  - reg
> +  - intel,npe-handle
> +  - queue-chl-rxtrig
> +  - queue-pkt-rx
> +  - queue-pkt-tx0
> +  - queue-pkt-tx1
> +  - queue-pkt-tx2
> +  - queue-pkt-tx3
> +  - queue-pkt-rxfree0
> +  - queue-pkt-rxfree1
> +  - queue-pkt-rxfree2
> +  - queue-pkt-rxfree3
> +  - queue-pkt-txdone
> +  - cts-gpios
> +  - rts-gpios
> +  - dcd-gpios
> +  - dtr-gpios
> +  - clk-internal-gpios
> +
> +additionalProperties: false
> -- 
> 2.31.1
> 
> 
