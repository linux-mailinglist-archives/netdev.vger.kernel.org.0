Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D622285387
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 22:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727407AbgJFU4i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 16:56:38 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:43978 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727333AbgJFU4i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 16:56:38 -0400
Received: by mail-oi1-f196.google.com with SMTP id l85so14136733oih.10;
        Tue, 06 Oct 2020 13:56:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=r1EDS9hP94pSaepHlZqoGv/Cu3THmPsqinmN68CAVG8=;
        b=s0FPGaIaYXFK/71T5LJNWTMtNLSx/zfc3QC1SKSu0rDYDOuwg2KkuZWDXu1r51q7EE
         cHHu0vDrN/65LmkO3xB+IzZ5zvxdJLbvpyRntZbB6woBn+BtGcrxIWoUwtb5agT/akUT
         CFC/KvBuYTt9zl/o3PON31AX2m9ywm2xdTmUX9oxhp+Iun9lYHCOX3oTPcKQFf4zG53W
         SE+L9Dw2CXHfI8aI+lmeK2KPlxN2LZ0yA19Lei3vQEhGd9dxn3ne7dJHRisM4Od6lLIk
         /19JOhHtyvaCYULxB9ghd74rFVcw6LVT+yxceHuT/YHuaFsaQY0Nbaj50MSvOX6s8XSe
         IIhw==
X-Gm-Message-State: AOAM530PG2JIxcLzCR0wBISY1O9/tcz8UfsL70xGngUDgDdB6YOMkKQL
        jRHCdksLS8ZeVAZD7lkWZA==
X-Google-Smtp-Source: ABdhPJy8srMSpakwQkHXvvBvJMUOwLH/IgDfxY6lJ4nNDWohsqtQ1w+RXjIULZLVY5P5s3xRLzAIPQ==
X-Received: by 2002:aca:b206:: with SMTP id b6mr103714oif.54.1602017796955;
        Tue, 06 Oct 2020 13:56:36 -0700 (PDT)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id p8sm1766340oip.29.2020.10.06.13.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Oct 2020 13:56:36 -0700 (PDT)
Received: (nullmailer pid 2824764 invoked by uid 1000);
        Tue, 06 Oct 2020 20:56:35 -0000
Date:   Tue, 6 Oct 2020 15:56:35 -0500
From:   Rob Herring <robh@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, shawnguo@kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 01/10] dt-bindings: net: add the dpaa2-mac
 DTS definition
Message-ID: <20201006205635.GA2810492@bogus>
References: <20201002210737.27645-1-ioana.ciornei@nxp.com>
 <20201002210737.27645-2-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201002210737.27645-2-ioana.ciornei@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 03, 2020 at 12:07:28AM +0300, Ioana Ciornei wrote:
> Add a documentation entry for the DTS bindings needed and supported by
> the dpaa2-mac driver.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
> ---
> Changes in v2:
>  - new patch
> 
>  .../devicetree/bindings/net/dpaa2-mac.yaml    | 55 +++++++++++++++++++

Use the compatible string for the filename.

>  1 file changed, 55 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/dpaa2-mac.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/dpaa2-mac.yaml b/Documentation/devicetree/bindings/net/dpaa2-mac.yaml
> new file mode 100644
> index 000000000000..744b0590278d
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/dpaa2-mac.yaml
> @@ -0,0 +1,55 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/dpaa2-mac.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: DPAA2 MAC bindings
> +
> +maintainers:
> +  - Ioana Ciornei <ioana.ciornei@nxp.com>
> +
> +description:
> +  This binding represents the DPAA2 MAC objects found on the fsl-mc bus and
> +  located under the 'dpmacs' node for the fsl-mc bus DTS node.

Need $ref to ethernet-controller.yaml

> +
> +properties:
> +  compatible:
> +    const: "fsl,qoriq-mc-dpmac"

Don't need quotes.

> +
> +  reg:
> +    maxItems: 1
> +    description: The DPMAC number
> +
> +  phy-handle: true
> +
> +  phy-connection-type: true
> +
> +  phy-mode: true
> +
> +  pcs-handle:
> +    $ref: /schemas/types.yaml#definitions/phandle
> +    description:
> +      A reference to a node representing a PCS PHY device found on
> +      the internal MDIO bus.

Perhaps use the 'phys' binding? (Too many PHYs with ethernet...)

This would be the on-chip XAUI/SerDes phy? That's typically 'phys' where 
as 'phy-handle' is ethernet PHY. 

> +
> +  managed: true
> +
> +required:
> +  - reg

addtionalProperties: false

> +
> +examples:
> +  - |
> +    dpmacs {
> +      #address-cells = <1>;
> +      #size-cells = <0>;
> +
> +      dpmac@4 {

ethernet@4

> +        compatible = "fsl,qoriq-mc-dpmac";
> +        reg = <0x4>;
> +        phy-handle = <&mdio1_phy6>;
> +        phy-connection-type = "qsgmii";
> +        managed = "in-band-status";
> +        pcs-handle = <&pcs3_1>;
> +      };
> +    };
> -- 
> 2.28.0
> 
