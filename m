Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 622CE636CDD
	for <lists+netdev@lfdr.de>; Wed, 23 Nov 2022 23:11:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229483AbiKWWLw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 17:11:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbiKWWLd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 17:11:33 -0500
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF41B1001C5;
        Wed, 23 Nov 2022 14:10:23 -0800 (PST)
Received: by mail-il1-f176.google.com with SMTP id q13so60326ild.3;
        Wed, 23 Nov 2022 14:10:23 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nCaLtE08habEVniuFmPFJHMdD+Pf/zJZeM63tCW6jHM=;
        b=5fI2iL6mc2nATc6lgr9V2NFiyXYwVujdZpyqjKrgFDeqbTCquV+0mgz7J7rnVhYqyc
         8c6oL5XZbjpnHxHLiPePFicK2vQHw4UfRSwj5MSDitzrgybgDKZ3oIqrAhL5eZyhRUOW
         JAkU3a4y2A7hsuMUtHK2OxpQ7uoFkzvmsJdtTj1O8W4o/N8lDQf+d9JERI0vfsKz7ZR9
         3DaoC21TR8ZMhXrOb68Yvuhbbn/OKi5LtYy5JAN7lxegBUrx+HXHvL5ebI19UqNvVt0x
         8XpSIf1MYW+6E+6ZHPxIsyOw0oPhSqPwGQY7AbdBaC8LGyeFZtBIcs2ivjZ2B7yW+RMv
         ZBpA==
X-Gm-Message-State: ANoB5pnCYbAwP6aaZTCRLfNx4CDxZA5eFVBDoovK6WqMLDqVZDxH24Iv
        FFE0oOuulU2DxeM5iqLs3rlZvB/QeQ==
X-Google-Smtp-Source: AA0mqf55gvn9mSnbj2YpBRikSZvZRRF+3G0E2+9mjPlS85JPCMjYBesXvKVZkN2rR6sPv5vzWUHxhw==
X-Received: by 2002:a05:6e02:1d8c:b0:300:da4a:f8f6 with SMTP id h12-20020a056e021d8c00b00300da4af8f6mr5113975ila.99.1669241422955;
        Wed, 23 Nov 2022 14:10:22 -0800 (PST)
Received: from robh_at_kernel.org ([64.188.179.252])
        by smtp.gmail.com with ESMTPSA id y18-20020a92d212000000b002ffbf49a0d2sm6094613ily.84.2022.11.23.14.10.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 14:10:22 -0800 (PST)
Received: (nullmailer pid 2594310 invoked by uid 1000);
        Wed, 23 Nov 2022 22:10:23 -0000
Date:   Wed, 23 Nov 2022 16:10:23 -0600
From:   Rob Herring <robh@kernel.org>
To:     Miquel Raynal <miquel.raynal@bootlin.com>
Cc:     Krzysztof Kozlowski <krzk+dt@kernel.org>,
        devicetree@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Marcin Wojtas <mw@semihalf.com>,
        Russell King <linux@armlinux.org.uk>,
        Taras Chornyi <tchornyi@marvell.com>,
        linux-kernel@vger.kernel.org,
        Robert Marko <robert.marko@sartura.hr>,
        Luka Perkov <luka.perkov@sartura.hr>,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        Michael Walle <michael@walle.cc>
Subject: Re: [PATCH 2/6] dt-bindings: net: marvell,dfx-server: Convert to yaml
Message-ID: <20221123221023.GA2582938-robh@kernel.org>
References: <20221117215557.1277033-1-miquel.raynal@bootlin.com>
 <20221117215557.1277033-3-miquel.raynal@bootlin.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221117215557.1277033-3-miquel.raynal@bootlin.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 17, 2022 at 10:55:53PM +0100, Miquel Raynal wrote:
> Even though this description is not used anywhere upstream (no matching
> driver), while on this file I decided I would try a conversion to yaml
> in order to clarify the prestera family description.
> 
> I cannot keep the nodename dfx-server@xxxx so I switched to dfx-bus@xxxx
> which matches simple-bus.yaml. Otherwise I took the example context from
> the only user of this compatible: armada-xp-98dx3236.dtsi, which is a
> rather old and not perfect DT.
> 
> Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
> ---
> I am fine dropping this file entirely as well, if judged useless.
> ---
>  .../bindings/net/marvell,dfx-server.yaml      | 60 +++++++++++++++++++
>  .../bindings/net/marvell,prestera.txt         | 18 ------
>  2 files changed, 60 insertions(+), 18 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml b/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
> new file mode 100644
> index 000000000000..72151a78396f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/marvell,dfx-server.yaml
> @@ -0,0 +1,60 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/marvell,dfx-server.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Marvell Prestera DFX server
> +
> +maintainers:
> +  - Miquel Raynal <miquel.raynal@bootlin.com>
> +
> +select:
> +  properties:
> +    compatible:
> +      contains:
> +        const: marvell,dfx-server
> +  required:
> +    - compatible
> +
> +properties:
> +  compatible:
> +    items:
> +      - const: marvell,dfx-server
> +      - const: simple-bus
> +
> +  reg: true

How many entries?

> +
> +  ranges: true
> +
> +  '#address-cells':
> +    const: 1
> +
> +  '#size-cells':
> +    const: 1
> +
> +required:
> +  - compatible
> +  - reg
> +  - ranges
> +
> +# The DFX server may expose clocks described as subnodes
> +additionalProperties: true

addtionalProperties:
  type: object

So that only nodes can be added.

> +
> +examples:
> +  - |
> +
> +    #define MBUS_ID(target,attributes) (((target) << 24) | ((attributes) << 16))
> +    bus@0 {
> +        reg = <0 0>;
> +        #address-cells = <2>;
> +        #size-cells = <1>;
> +
> +        dfx-bus@ac000000 {
> +            compatible = "marvell,dfx-server", "simple-bus";
> +            #address-cells = <1>;
> +            #size-cells = <1>;
> +            ranges = <0 MBUS_ID(0x08, 0x00) 0 0x100000>;
> +            reg = <MBUS_ID(0x08, 0x00) 0 0x100000>;
> +        };
> +    };
