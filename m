Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B360721BB40
	for <lists+netdev@lfdr.de>; Fri, 10 Jul 2020 18:45:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727901AbgGJQpD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jul 2020 12:45:03 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:45970 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726896AbgGJQpD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jul 2020 12:45:03 -0400
Received: by mail-io1-f68.google.com with SMTP id e64so6678223iof.12;
        Fri, 10 Jul 2020 09:45:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=NcVIqFMxSOYKqnZQ2wilEAou9p34LBdWDEjfs7eZSqw=;
        b=QSr8JFdADz5lcE32UvfIykugUV4SxzWc5xj6RA8F5FMQjZ/QshwZZHJRVX2nAdr2BN
         FVEEmDq2KXkk4vLH5FM5EjZhOyDJLReGfTaFcL/G80vjKrvVvBis3KKbGcV0n1Tuvp8S
         RGKP5hWS9LW2EuO7LkkI5tZZpgqnaW5MChbh32iJB5Pnx5o7V9dIaFscZJJDv+JpYrlM
         nSqHLQDaVD3WDN5vM1yg04LvGkc+JSg2TLxQXl2fyJlAhXSw9VlBS2TwIdlI4Oqh1aVg
         BEvIUTuxuKTHi+8UAWXrniTw9xgz5+fs8T2IjENTFRI2Bja45DGzShgmaPWeoh7yfxmm
         z05w==
X-Gm-Message-State: AOAM530HWXAlXcTCvrHvGET/mKdIT8eGUuCqFFdC3vU2JsbIlmzkXhGU
        F2sPnhLUEsqRKjSjj/e9jQ==
X-Google-Smtp-Source: ABdhPJzBtLHrDDjhTprzaUErp3U5RC1TXc/DAe4OsQ/FyL2GyTi8gDWOA1hzxKU9hsRp7+oUZUKMEQ==
X-Received: by 2002:a6b:197:: with SMTP id 145mr48209904iob.77.1594399502194;
        Fri, 10 Jul 2020 09:45:02 -0700 (PDT)
Received: from xps15 ([64.188.179.254])
        by smtp.gmail.com with ESMTPSA id r11sm3603540ilm.2.2020.07.10.09.45.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 10 Jul 2020 09:45:01 -0700 (PDT)
Received: (nullmailer pid 2786114 invoked by uid 1000);
        Fri, 10 Jul 2020 16:45:00 -0000
Date:   Fri, 10 Jul 2020 10:45:00 -0600
From:   Rob Herring <robh@kernel.org>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH v1 1/1] dt-bindings: net: dsa: Add DSA yaml binding
Message-ID: <20200710164500.GA2775934@bogus>
References: <20200710090618.28945-1-kurt@linutronix.de>
 <20200710090618.28945-2-kurt@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710090618.28945-2-kurt@linutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 10, 2020 at 11:06:18AM +0200, Kurt Kanzenbach wrote:
> For future DSA drivers it makes sense to add a generic DSA yaml binding which
> can be used then. This was created using the properties from dsa.txt. It
> includes the ports and the dsa,member property.
> 
> Suggested-by: Florian Fainelli <f.fainelli@gmail.com>
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>
> ---
>  .../devicetree/bindings/net/dsa/dsa.yaml      | 80 +++++++++++++++++++
>  1 file changed, 80 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dsa/dsa.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dsa/dsa.yaml b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> new file mode 100644
> index 000000000000..bec257231bf8
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dsa/dsa.yaml
> @@ -0,0 +1,80 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dsa/dsa.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Distributed Switch Architecture Device Tree Bindings

DSA is a Linuxism, right?

> +
> +maintainers:
> +  - Andrew Lunn <andrew@lunn.ch>
> +  - Florian Fainelli <f.fainelli@gmail.com>
> +  - Vivien Didelot <vivien.didelot@gmail.com>
> +
> +description:
> +  Switches are true Linux devices and can be probed by any means. Once probed,

Bindings are OS independent.

> +  they register to the DSA framework, passing a node pointer. This node is
> +  expected to fulfil the following binding, and may contain additional
> +  properties as required by the device it is embedded within.

Describe what type of h/w should use this binding.

> +
> +properties:
> +  $nodename:
> +    pattern: "^switch(@.*)?$"
> +
> +  dsa,member:
> +    minItems: 2
> +    maxItems: 2
> +    description:
> +      A two element list indicates which DSA cluster, and position within the
> +      cluster a switch takes. <0 0> is cluster 0, switch 0. <0 1> is cluster 0,
> +      switch 1. <1 0> is cluster 1, switch 0. A switch not part of any cluster
> +      (single device hanging off a CPU port) must not specify this property
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +
> +  ports:
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^port@[0-9]+$":

As ports and port are OF graph nodes, it would be better if we 
standardized on a different name for these. I think we've used 
'ethernet-port' some.

> +          type: object
> +          description: DSA switch ports
> +
> +          allOf:
> +            - $ref: ../ethernet-controller.yaml#

How does this and 'ethernet' both apply?

> +
> +          properties:
> +            reg:
> +              description: Port number
> +
> +            label:
> +              description:
> +                Describes the label associated with this port, which will become
> +                the netdev name
> +              $ref: /schemas/types.yaml#definitions/string
> +
> +            link:
> +              description:
> +                Should be a list of phandles to other switch's DSA port. This
> +                port is used as the outgoing port towards the phandle ports. The
> +                full routing information must be given, not just the one hop
> +                routes to neighbouring switches
> +              $ref: /schemas/types.yaml#definitions/phandle-array
> +
> +            ethernet:
> +              description:
> +                Should be a phandle to a valid Ethernet device node.  This host
> +                device is what the switch port is connected to
> +              $ref: /schemas/types.yaml#definitions/phandle
> +
> +          required:
> +            - reg
> +
> +required:
> +  - ports
> +
> +...
> -- 
> 2.20.1
> 
