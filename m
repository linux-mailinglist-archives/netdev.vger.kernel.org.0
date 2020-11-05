Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44CAC2A86EB
	for <lists+netdev@lfdr.de>; Thu,  5 Nov 2020 20:18:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732091AbgKETRt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 14:17:49 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40113 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727017AbgKETRt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Nov 2020 14:17:49 -0500
Received: by mail-ot1-f67.google.com with SMTP id 79so2470468otc.7;
        Thu, 05 Nov 2020 11:17:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qVltVS4xRbJ5oOqamRg6RIBu2eNc5lyLtJjVEFCDWcw=;
        b=aYHUhudtEbcEAtu1x8il6TMMEl8qNNt8xwP3ov3f1bnbkYY659dVTvvhJJ3ot9IBCb
         d1KvC8zHSzT1KSYtcAAuEJ1LIinhoSIWahuYo/roFCXbAJfKpRLoiTCLxXj1aXSAOyy7
         2WdINqP5HheEEWiZ1rNSLxRXPr33at+DgN5NLvLQbukxWpRhmpAmqWykoSs3+KedjzFd
         dToetocTzGHazz4gNa+5E7Ad8M8NjgG9ZvxT7AroJJLIsRibZ+v3EzyaS3wgEPRRhzaL
         kUZwcrok/+NbhB+zyADjom7rvFzOweqq8WCqh7IT3RBqVi2yNVxP8ZjPDrI2H0mO87cG
         A66w==
X-Gm-Message-State: AOAM532EPADfv3XPpGKuL+a9q748WYiMw0FgGbiR/TLq3GAiRkdyZ63y
        Yr1OXTZPYhPnErBc4UO0zQ==
X-Google-Smtp-Source: ABdhPJzK1T8CXWpiwEOmLHa7iNUwPU0tvxWa/VTOiqQbBWkM9ZMxmM18EymWSKz6ITFMNCnosRq+6g==
X-Received: by 2002:a9d:5547:: with SMTP id h7mr2835685oti.248.1604603867398;
        Thu, 05 Nov 2020 11:17:47 -0800 (PST)
Received: from xps15 (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id q18sm515428otf.46.2020.11.05.11.17.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2020 11:17:46 -0800 (PST)
Received: (nullmailer pid 1659013 invoked by uid 1000);
        Thu, 05 Nov 2020 19:17:45 -0000
Date:   Thu, 5 Nov 2020 13:17:45 -0600
From:   Rob Herring <robh@kernel.org>
To:     Laurentiu Tudor <laurentiu.tudor@nxp.com>
Cc:     leoyang.li@nxp.com, corbet@lwn.net,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linuxppc-dev@lists.ozlabs.org, ioana.ciornei@nxp.com,
        Ionut-robert Aron <ionut-robert.aron@nxp.com>
Subject: Re: [PATCH 2/2] dt-bindings: misc: convert fsl,qoriq-mc from txt to
 YAML
Message-ID: <20201105191745.GB1644330@bogus>
References: <20201105141114.18161-1-laurentiu.tudor@nxp.com>
 <20201105141114.18161-2-laurentiu.tudor@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201105141114.18161-2-laurentiu.tudor@nxp.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 05, 2020 at 04:11:14PM +0200, Laurentiu Tudor wrote:
> From: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> 
> Convert fsl,qoriq-mc to YAML in order to automate the verification
> process of dts files. In addition, update MAINTAINERS accordingly
> and, while at it, add some missing files.
> 
> Signed-off-by: Ionut-robert Aron <ionut-robert.aron@nxp.com>
> [laurentiu.tudor@nxp.com: update MINTAINERS, updates & fixes in schema]
> Signed-off-by: Laurentiu Tudor <laurentiu.tudor@nxp.com>
> ---
>  .../devicetree/bindings/misc/fsl,qoriq-mc.txt | 196 ----------------
>  .../bindings/misc/fsl,qoriq-mc.yaml           | 218 ++++++++++++++++++
>  .../ethernet/freescale/dpaa2/overview.rst     |   5 +-
>  MAINTAINERS                                   |   4 +-
>  4 files changed, 225 insertions(+), 198 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
>  create mode 100644 Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml

[...]

> diff --git a/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
> new file mode 100644
> index 000000000000..9e89fd8eb635
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
> @@ -0,0 +1,218 @@
> +# SPDX-License-Identifier: (GPL-2.0 OR BSD-2-Clause)
> +# Copyright 2020 NXP
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/misc/fsl,qoriq-mc.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +maintainers:
> +  - Laurentiu Tudor <laurentiu.tudor@nxp.com>
> +
> +title: Freescale Management Complex
> +
> +description: |
> +  The Freescale Management Complex (fsl-mc) is a hardware resource
> +  manager that manages specialized hardware objects used in
> +  network-oriented packet processing applications. After the fsl-mc
> +  block is enabled, pools of hardware resources are available, such as
> +  queues, buffer pools, I/O interfaces. These resources are building
> +  blocks that can be used to create functional hardware objects/devices
> +  such as network interfaces, crypto accelerator instances, L2 switches,
> +  etc.
> +
> +  For an overview of the DPAA2 architecture and fsl-mc bus see:
> +  Documentation/networking/device_drivers/freescale/dpaa2/overview.rst
> +
> +  As described in the above overview, all DPAA2 objects in a DPRC share the
> +  same hardware "isolation context" and a 10-bit value called an ICID
> +  (isolation context id) is expressed by the hardware to identify
> +  the requester.
> +
> +  The generic 'iommus' property is insufficient to describe the relationship
> +  between ICIDs and IOMMUs, so an iommu-map property is used to define
> +  the set of possible ICIDs under a root DPRC and how they map to
> +  an IOMMU.
> +
> +  For generic IOMMU bindings, see:
> +  Documentation/devicetree/bindings/iommu/iommu.txt.
> +
> +  For arm-smmu binding, see:
> +  Documentation/devicetree/bindings/iommu/arm,smmu.yaml.
> +
> +  MC firmware binary images can be found here:
> +  https://github.com/NXP/qoriq-mc-binary
> +
> +properties:
> +  compatible:
> +    const: "fsl,qoriq-mc"

Don't need quotes.

> +    description: "Must be 'fsl,qoriq-mc'. A Freescale Management Complex

Drop                ^^^^^^^^^^^^^^^^^^^^^^^^

The schema says that.

> +                compatible with this binding must have Block Revision
> +                Registers BRR1 and BRR2 at offset 0x0BF8 and 0x0BFC in
> +                the MC control register region."
> +
> +  reg:
> +    description: "A standard property. Specifies one or two regions defining

Don't need quotes. You need '|' for a literal block to keep formatting.

But all this should be expressed as schema...

> +                the MC's registers:
> +
> +                - the first region is the command portal for the this machine
> +                  and must always be present
> +
> +                - the second region is the MC control registers. This region
> +                  may not be present in some scenarios, such as in the device
> +                  tree presented to a virtual machine."

reg:
  minItems: 1
  items:
    - description: the command portal for the this machine
    - description: MC control registers. This region may not be present 
        in some scenarios, such as in the device tree presented to a 
        virtual machine.

> +
> +  ranges:
> +    description: "A standard property. Defines the mapping between the child
> +                MC address space and the parent system address space.
> +
> +                The MC address space is defined by 3 components:
> +                <region type> <offset hi> <offset lo>
> +
> +                Valid values for region type are:
> +                  0x0 - MC portals
> +                  0x1 - QBMAN portals"
> +
> +  '#address-cells':
> +    const: 3
> +
> +  '#size-cells':
> +    const: 1
> +
> +  dpmacs:
> +    type: object
> +    description: "The fsl-mc node may optionally have dpmac sub-nodes that
> +                describe the relationship between the Ethernet MACs which belong
> +                to the MC and the Ethernet PHYs on the system board.
> +
> +                The dpmac nodes must be under a node named 'dpmacs' which
> +                contains the following properties:
> +
> +                - '#address-cells'
> +                  const: 1
> +                  description: Must be present if dpmac sub-nodes are defined
> +                              and must have a value of 1.
> +
> +                - '#size-cells'
> +                  const: 0
> +                  description: Must be present if dpmac sub-nodes are defined
> +                              and must have a value of 0."

Drop whatever description can be expressed in schemas.

> +
> +    properties:
> +      '#address-cells':
> +        const: 1
> +
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^dpmac@[0-9a-f]+$":
> +        type: object
> +
> +        description: "dpmac sub-node that describes the relationship between the
> +                    Ethernet MACs which belong to the MC and the Ethernet PHYs
> +                    on the system board."
> +
> +        properties:
> +          compatible:
> +            const: "fsl,qoriq-mc-dpmac"
> +
> +          reg:
> +            description: Specifies the id of the dpmac

Constraints on the value?

> +
> +          phy-handle:
> +            $ref: /schemas/types.yaml#definitions/phandle
> +            description: "Specifies the phandle to the PHY device node
> +                        associated with the this dpmac."
> +
> +        required:
> +        - compatible
> +        - reg
> +        - phy-handle
> +
> +  iommu-map:
> +    description: |
> +      Maps an ICID to an IOMMU and associated iommu-specifier data.
> +
> +      The property is an arbitrary number of tuples of
> +      (icid-base, iommu, iommu-base, length).
> +
> +      Any ICID i in the interval [icid-base, icid-base + length) is
> +      associated with the listed IOMMU, with the iommu-specifier
> +      (i - icid-base + iommu-base).
> +
> +  msi-map:
> +    description: |
> +      Maps an ICID to a GIC ITS and associated msi-specifier data.
> +
> +      The property is an arbitrary number of tuples of
> +      (icid-base, gic-its, msi-base, length).
> +
> +      Any ICID in the interval [icid-base, icid-base + length) is
> +      associated with the listed GIC ITS, with the msi-specifier
> +      (i - icid-base + msi-base).
> +
> +  msi-parent:
> +    deprecated: true
> +    description: "Points to the MSI controller node handling message interrupts
> +                for the MC."
> +
> +required:
> +  - compatible
> +  - reg
> +  - iommu-map
> +  - msi-map
> +  - ranges
> +  - '#address-cells'
> +  - '#size-cells'
> +
> +additionalProperties: false
> +
> +examples:
> +  - |
> +    soc {
> +      #address-cells = <2>;
> +      #size-cells = <2>;
> +
> +      smmu: iommu@5000000 {
> +        compatible = "arm,mmu-500";
> +        #global-interrupts = <1>;
> +        #iommu-cells = <1>;
> +        reg = <0 0x5000000 0 0x800000>;
> +        stream-match-mask = <0x7c00>;
> +        interrupts = <0 13 4>,
> +                     <0 146 4>, <0 147 4>,
> +                     <0 148 4>, <0 149 4>,
> +                     <0 150 4>, <0 151 4>,
> +                     <0 152 4>, <0 153 4>;
> +      };
> +
> +      fsl_mc: fsl-mc@80c000000 {
> +        compatible = "fsl,qoriq-mc";
> +        reg = <0x00000008 0x0c000000 0 0x40>,    /* MC portal base */
> +        <0x00000000 0x08340000 0 0x40000>; /* MC control reg */
> +        /* define map for ICIDs 23-64 */
> +        iommu-map = <23 &smmu 23 41>;
> +        /* define msi map for ICIDs 23-64 */
> +        msi-map = <23 &its 23 41>;
> +        #address-cells = <3>;
> +        #size-cells = <1>;
> +
> +        /*
> +        * Region type 0x0 - MC portals
> +        * Region type 0x1 - QBMAN portals
> +        */
> +        ranges = <0x0 0x0 0x0 0x8 0x0c000000 0x4000000
> +                  0x1 0x0 0x0 0x8 0x18000000 0x8000000>;
> +
> +        dpmacs {
> +          #address-cells = <1>;
> +          #size-cells = <0>;
> +
> +          dpmac@1 {
> +            compatible = "fsl,qoriq-mc-dpmac";
> +            reg = <1>;
> +            phy-handle = <&mdio0_phy0>;
> +          };
> +        };
> +      };
> +    };
> diff --git a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
> index d638b5a8aadd..b3261c5871cc 100644
> --- a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
> +++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
> @@ -28,6 +28,9 @@ interfaces, an L2 switch, or accelerator instances.
>  The MC provides memory-mapped I/O command interfaces (MC portals)
>  which DPAA2 software drivers use to operate on DPAA2 objects.
>  
> +MC firmware binary images can be found here:
> +https://github.com/NXP/qoriq-mc-binary
> +
>  The diagram below shows an overview of the DPAA2 resource management
>  architecture::
>  
> @@ -338,7 +341,7 @@ Key functions include:
>    a bind of the root DPRC to the DPRC driver
>  
>  The binding for the MC-bus device-tree node can be consulted at
> -*Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt*.
> +*Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml*.
>  The sysfs bind/unbind interfaces for the MC-bus can be consulted at
>  *Documentation/ABI/testing/sysfs-bus-fsl-mc*.
>  
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b43b59542d15..400a17c90edb 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -14409,9 +14409,11 @@ M:	Stuart Yoder <stuyoder@gmail.com>
>  M:	Laurentiu Tudor <laurentiu.tudor@nxp.com>
>  L:	linux-kernel@vger.kernel.org
>  S:	Maintained
> -F:	Documentation/devicetree/bindings/misc/fsl,qoriq-mc.txt
> +F:	Documentation/devicetree/bindings/misc/fsl,dpaa2-console.yaml
> +F:	Documentation/devicetree/bindings/misc/fsl,qoriq-mc.yaml
>  F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/overview.rst
>  F:	drivers/bus/fsl-mc/
> +F:	include/linux/fsl/mc.h
>  
>  QT1010 MEDIA DRIVER
>  M:	Antti Palosaari <crope@iki.fi>
> -- 
> 2.17.1
> 
