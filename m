Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 031DC6436DE
	for <lists+netdev@lfdr.de>; Mon,  5 Dec 2022 22:29:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232604AbiLEV32 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Dec 2022 16:29:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230246AbiLEV30 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Dec 2022 16:29:26 -0500
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47EBD1DDE6;
        Mon,  5 Dec 2022 13:29:26 -0800 (PST)
Received: by mail-oo1-f46.google.com with SMTP id j1-20020a4ad181000000b0049e6e8c13b4so1900487oor.1;
        Mon, 05 Dec 2022 13:29:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vC4tdvbf2E2K4ti6yOrkzWwYWETV/yDk+VqUvTEIAnI=;
        b=VK1qTcwmD0hKHOUYj4nUfU/W271HFyeWSwkfHDl+naEk0C02ghHIoxlpD87JcQK/IX
         eJZlvnL+DnyvMnUwk6X7LgZ1mLUXsKtBx4XlFlEMQJ2QesfSJj8HASARmpB/iUyKHE+K
         qMUa/XmyTTp4vHMT5Ywtbh5LJpxzQ8Wae22PxkyQljfAZtKOeG4thlrv1CJ1NU+fc73q
         nY0Ze+2ETsG5DAUCQlhJo/aWrs4wll1oFgYoabVo8Ybx5LnBfmyb8m3gP+YIfrnA+SfG
         5EOhDXScqrl8D0m5noPaKjuhf1yZRo9Pv4wZ1v9zC/Appu+LTweIFC8ivyiI/m6jDCyy
         6dBQ==
X-Gm-Message-State: ANoB5pmOLJzphTFbcScqI3Q4vbNTNngCET6cW3agj+M3g0dKbuJytBfC
        /7VXY0abgJ+jHddjmPUxb6QjUA2QYQ==
X-Google-Smtp-Source: AA0mqf5OZgz/MQPOz+i5saP+kvL6ekR7h8OYa1bu+t7jVzYObokIaPmTsxi/ttXdbBE/P1yurFQvKg==
X-Received: by 2002:a4a:9563:0:b0:4a0:62e4:a192 with SMTP id n32-20020a4a9563000000b004a062e4a192mr14335344ooi.78.1670275765442;
        Mon, 05 Dec 2022 13:29:25 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t26-20020a05683014da00b0066cb9069e0bsm8351772otq.42.2022.12.05.13.29.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Dec 2022 13:29:24 -0800 (PST)
Received: (nullmailer pid 2657326 invoked by uid 1000);
        Mon, 05 Dec 2022 21:29:24 -0000
Date:   Mon, 5 Dec 2022 15:29:24 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Xu Liang <lxu@maxlinear.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/4] dt-bindings: net: phy: add MaxLinear
 GPY2xx bindings
Message-ID: <20221205212924.GA2638223-robh@kernel.org>
References: <20221202151204.3318592-1-michael@walle.cc>
 <20221202151204.3318592-4-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221202151204.3318592-4-michael@walle.cc>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 02, 2022 at 04:12:03PM +0100, Michael Walle wrote:
> Add the device tree bindings for the MaxLinear GPY2xx PHYs.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
> 
> Is the filename ok? I was unsure because that flag is only for the GPY215
> for now. But it might also apply to others. Also there is no compatible
> string, so..
> 
>  .../bindings/net/maxlinear,gpy2xx.yaml        | 47 +++++++++++++++++++
>  1 file changed, 47 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
> new file mode 100644
> index 000000000000..d71fa9de2b64
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/maxlinear,gpy2xx.yaml
> @@ -0,0 +1,47 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/maxlinear,gpy2xx.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: MaxLinear GPY2xx PHY
> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Michael Walle <michael@walle.cc>
> +
> +allOf:
> +  - $ref: ethernet-phy.yaml#
> +
> +properties:
> +  maxlinear,use-broken-interrupts:
> +    description: |
> +      Interrupts are broken on some GPY2xx PHYs in that they keep the
> +      interrupt line asserted even after the interrupt status register is
> +      cleared. Thus it is blocking the interrupt line which is usually bad
> +      for shared lines. By default interrupts are disabled for this PHY and
> +      polling mode is used. If one can live with the consequences, this
> +      property can be used to enable interrupt handling.

Just omit the interrupt property if you don't want interrupts and add it 
if you do.

> +
> +      Affected PHYs (as far as known) are GPY215B and GPY215C.
> +    type: boolean
> +
> +dependencies:
> +  maxlinear,use-broken-interrupts: [ interrupts ]
> +
> +unevaluatedProperties: false
> +
> +examples:
> +  - |
> +    ethernet {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        ethernet-phy@0 {
> +            reg = <0>;
> +            interrupts-extended = <&intc 0>;
> +            maxlinear,use-broken-interrupts;

This is never actually checked by be schema because there is nothing to 
match on. If you want custom properties, then you need a compatible. 

> +        };
> +    };
> +
> +...
> -- 
> 2.30.2
> 
> 
