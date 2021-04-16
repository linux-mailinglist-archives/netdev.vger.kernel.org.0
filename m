Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87D23362857
	for <lists+netdev@lfdr.de>; Fri, 16 Apr 2021 21:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236393AbhDPTJN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Apr 2021 15:09:13 -0400
Received: from mail-oi1-f179.google.com ([209.85.167.179]:39528 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235715AbhDPTJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Apr 2021 15:09:11 -0400
Received: by mail-oi1-f179.google.com with SMTP id i81so28887326oif.6;
        Fri, 16 Apr 2021 12:08:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HF8XZwHelC1eE92Jm6APeUSvsTsRauJXAU0FhgAgx64=;
        b=Bk2o14WXuaDWGOOlvls5+5080HiuI5EPSonOISSU8rFgqZUu0+4GpL2HUyhgWkM14z
         eDEjUgPasJqS1hjoFRvwtUCFxcg8wW0pc/VBIFaN2sAW9WXm4EharhtpoMkCBn4YYjNN
         Q/4crzrgy0c/WF7f7F8iQCOHe9Q24dUykOjbDp6BgWxAmBSyc07AJs38SSP94k10H1cL
         XZ2RkI/bAw558DfuokfRes5coS3fZvCUjHWb7m0SmKVl5SY+ZWrwPQWTjLEvej3U/4gb
         Xl++trQKN8cn88aZcEwyf7bUDe0iqONaDB5awFhnCmifGHO3B9NGIUH0z3xZxbL4pLrl
         W4+A==
X-Gm-Message-State: AOAM530E4MSuRTPLDa+cc5aZkB12RLiXs3q7R4H57le1zjxpaMKqIfFa
        nfGWN8mSOC3QEQm+88wbBRkI3ljMww==
X-Google-Smtp-Source: ABdhPJzK/izyyFr+X2UOfyjfkqwvz/g8Ok0jBeZnIJYYvRQADzQZWNpRXbKx5Dh4lBHvgJuoaubNzw==
X-Received: by 2002:aca:5fc2:: with SMTP id t185mr7949520oib.64.1618600126157;
        Fri, 16 Apr 2021 12:08:46 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id g84sm1595497oia.45.2021.04.16.12.08.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Apr 2021 12:08:45 -0700 (PDT)
Received: (nullmailer pid 3772770 invoked by uid 1000);
        Fri, 16 Apr 2021 19:08:44 -0000
Date:   Fri, 16 Apr 2021 14:08:44 -0500
From:   Rob Herring <robh@kernel.org>
To:     Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@vger.kernel.org
Subject: Re: [PATCH v5 net-next 10/10] dt-bindings: net: korina: Add DT
 bindings for IDT 79RC3243x SoCs
Message-ID: <20210416190844.GA3770043@robh.at.kernel.org>
References: <20210416085207.63181-1-tsbogend@alpha.franken.de>
 <20210416085207.63181-11-tsbogend@alpha.franken.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210416085207.63181-11-tsbogend@alpha.franken.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 16, 2021 at 10:52:06AM +0200, Thomas Bogendoerfer wrote:
> Add device tree bindings for ethernet controller integrated into
> IDT 79RC3243x SoCs.
> 
> Signed-off-by: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> ---
>  .../bindings/net/idt,3243x-emac.yaml          | 74 +++++++++++++++++++
>  1 file changed, 74 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> new file mode 100644
> index 000000000000..3697af5cb66f
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/idt,3243x-emac.yaml
> @@ -0,0 +1,74 @@
> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/idt,3243x-emac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: IDT 79rc3243x Ethernet controller
> +
> +description: Ethernet controller integrated into IDT 79RC3243x family SoCs
> +
> +maintainers:
> +  - Thomas Bogendoerfer <tsbogend@alpha.franken.de>
> +
> +allOf:
> +  - $ref: ethernet-controller.yaml#
> +
> +properties:
> +  compatible:
> +    const: idt,3243x-emac
> +
> +  reg:
> +    maxItems: 3
> +
> +  reg-names:
> +    items:
> +      - const: korina_regs
> +      - const: korina_dma_rx
> +      - const: korina_dma_tx

What's korina?

In any case, just drop as it is redundant.

> +
> +  interrupts:
> +    items:
> +      - description: RX interrupt
> +      - description: TX interrupt
> +
> +  interrupt-names:
> +    items:
> +      - const: korina_rx
> +      - const: korina_tx

Just rx and tx.

> +
> +  clocks:
> +    maxItems: 1
> +
> +  clock-names:
> +    items:
> +      - const: mdioclk
> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - interrupts
> +  - interrupt-names
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +
> +    ethernet@60000 {
> +        compatible = "idt,3243x-emac";
> +
> +        reg = <0x60000 0x10000>,
> +              <0x40000 0x14>,
> +              <0x40014 0x14>;
> +        reg-names = "korina_regs",
> +                    "korina_dma_rx",
> +                    "korina_dma_tx";
> +
> +        interrupts-extended = <&rcpic3 0>, <&rcpic3 1>;
> +        interrupt-names = "korina_rx", "korina_tx";
> +
> +        clocks = <&iclk>;
> +        clock-names = "mdioclk";
> +    };
> -- 
> 2.29.2
> 
