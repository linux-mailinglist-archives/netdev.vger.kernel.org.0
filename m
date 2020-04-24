Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1D4A1B7F6A
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 21:56:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729437AbgDXTzz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 15:55:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729419AbgDXTzy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 24 Apr 2020 15:55:54 -0400
Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86228215A4;
        Fri, 24 Apr 2020 19:55:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587758153;
        bh=XyAZQ+e0o7lKduytKo6lvmMqRCZ1EqfQCzwTnAq96HM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=fV8hXCcw3sdoVZvyT2ycb3P/w1YU7ELr4Hxd9Un8zFJ8TB3zwtrJ9iPol/89Q4z9F
         ZLYdcJdtFLdPS9FCtOahiG5HXdIX7ycnQbUXUS0XXdqLY2xw0KdQHPDw6HsaJ1+tG1
         cqkMSsJhYHantVRmxqg7qv57CTejZPcFSiT4r/ZE=
Received: by mail-qv1-f46.google.com with SMTP id fb4so5310871qvb.7;
        Fri, 24 Apr 2020 12:55:53 -0700 (PDT)
X-Gm-Message-State: AGi0PuYP157vDYmJ2xU5xTvW5md0cc49fmUYDV4/r/LDqY2uDLawKIbV
        o6OBcLp6Ppf/HcN6BEwZU5WIFuwJjhGbzm2dcg==
X-Google-Smtp-Source: APiQypL6QVP34OIZcFjfLZaCQy58J6loPgHHO+jJmV1P6s/hngLJU56sMwG2qfl9h0lCetvcQovdru7JCgkvs7MOHI0=
X-Received: by 2002:a0c:a986:: with SMTP id a6mr10586552qvb.79.1587758152580;
 Fri, 24 Apr 2020 12:55:52 -0700 (PDT)
MIME-Version: 1.0
References: <1587732391-3374-1-git-send-email-florinel.iordache@nxp.com> <1587732391-3374-3-git-send-email-florinel.iordache@nxp.com>
In-Reply-To: <1587732391-3374-3-git-send-email-florinel.iordache@nxp.com>
From:   Rob Herring <robh+dt@kernel.org>
Date:   Fri, 24 Apr 2020 14:55:40 -0500
X-Gmail-Original-Message-ID: <CAL_Jsq+7zpDDcVzTKSufzuCWnRcLZ0h+y0TpsJE=G+pbuhWtvw@mail.gmail.com>
Message-ID: <CAL_Jsq+7zpDDcVzTKSufzuCWnRcLZ0h+y0TpsJE=G+pbuhWtvw@mail.gmail.com>
Subject: Re: [PATCH net-next v2 2/9] dt-bindings: net: add backplane dt bindings
To:     Florinel Iordache <florinel.iordache@nxp.com>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        devicetree@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Shawn Guo <shawnguo@kernel.org>,
        Yang-Leo Li <leoyang.li@nxp.com>,
        "Madalin Bucur (OSS)" <madalin.bucur@oss.nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 7:46 AM Florinel Iordache
<florinel.iordache@nxp.com> wrote:
>
> Add ethernet backplane device tree bindings

For a new, common binding, you've got to do better than this. Bindings
need to stand on their own. I need a h/w block diagram or something
because I know little about "ethernet backplane".

>
> Signed-off-by: Florinel Iordache <florinel.iordache@nxp.com>
> ---
>  .../bindings/net/ethernet-controller.yaml          |  3 +-
>  .../devicetree/bindings/net/ethernet-phy.yaml      | 50 +++++++++++++++++++++
>  .../devicetree/bindings/net/serdes-lane.yaml       | 51 ++++++++++++++++++++++
>  Documentation/devicetree/bindings/net/serdes.yaml  | 44 +++++++++++++++++++
>  4 files changed, 147 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/devicetree/bindings/net/serdes-lane.yaml
>  create mode 100644 Documentation/devicetree/bindings/net/serdes.yaml
>
> diff --git a/Documentation/devicetree/bindings/net/ethernet-controller.yaml b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> index ac471b6..541cee5 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-controller.yaml
> @@ -93,8 +93,9 @@ properties:
>        - rxaui
>        - xaui
>
> -      # 10GBASE-KR, XFI, SFI
> +      # 10GBASE-KR, 40GBASE-KR4, XFI, SFI
>        - 10gbase-kr
> +      - 40gbase-kr4
>        - usxgmii
>
>    phy-mode:
> diff --git a/Documentation/devicetree/bindings/net/ethernet-phy.yaml b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> index 5aa141c..436b5a7 100644
> --- a/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> +++ b/Documentation/devicetree/bindings/net/ethernet-phy.yaml
> @@ -161,6 +161,42 @@ properties:
>      description:
>        Specifies a reference to a node representing a SFP cage.
>
> +  eq-algorithm:
> +    description:
> +      Specifies the desired equalization algorithm to be used
> +      by the KR link training
> +    oneOf:
> +      - const: fixed
> +        description:
> +          Backplane KR using fixed coefficients meaning no
> +          equalization algorithm
> +      - const: bee
> +        description:
> +          Backplane KR using 3-Taps Bit Edge Equalization (BEE)
> +          algorithm
> +
> +  eq-init:

eq-coefficients?

> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    minItems: 3
> +    maxItems: 3
> +    description:
> +      Triplet of KR coefficients. Specifies the initialization
> +      values for standard KR equalization coefficients used by
> +      the link training (pre-cursor, main-cursor, post-cursor)

items:
  - description: pre-cursor
  - description: main-cursor
  ...

Is 0-2^32 valid data? If not, add some constraints.

> +
> +  eq-params:
> +    $ref: /schemas/types.yaml#/definitions/uint32-array
> +    description:
> +      Variable size array of KR parameters. Specifies the HW
> +      specific parameters used by the link training.

DT is not a dumping ground for magic register values.

eq-init vs. eq-params is pretty vague as to what they are.

I fail to see how these properties are related to $subject. Should be
a separate patch.

> +
> +  lane-handle:
> +    $ref: /schemas/types.yaml#definitions/phandle
> +    description:
> +      Specifies a reference (or array of references) to a node
> +      representing the desired SERDES lane (or lanes) used in
> +      backplane mode.
> +
>  required:
>    - reg
>
> @@ -183,3 +219,17 @@ examples:
>              reset-deassert-us = <2000>;
>          };
>      };
> +  - |
> +    ethernet {
> +        #address-cells = <1>;
> +        #size-cells = <0>;
> +
> +        ethernet-phy@0 {
> +            compatible = "ethernet-phy-ieee802.3-c45";
> +            reg = <0x0>;
> +            lane-handle = <&lane_d>;
> +            eq-algorithm = "fixed";
> +            eq-init = <0x2 0x29 0x5>;
> +            eq-params = <0>;
> +        };
> +    };
> diff --git a/Documentation/devicetree/bindings/net/serdes-lane.yaml b/Documentation/devicetree/bindings/net/serdes-lane.yaml
> new file mode 100644
> index 0000000..ce3581e
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/serdes-lane.yaml
> @@ -0,0 +1,51 @@
> +# SPDX-License-Identifier: GPL-2.0

Dual license new bindings:

(GPL-2.0-only OR BSD-2-Clause)

> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/serdes-lane.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Serdes Lane Binding
> +
> +maintainers:
> +  - Florinel Iordache <florinel.iordache@nxp.com>
> +
> +properties:
> +  $nodename:
> +    pattern: "^lane(@[a-f0-9]+)?$"
> +
> +  compatible:
> +    oneOf:
> +      - const: lane-10g
> +        description: Lane part of a 10G SerDes module
> +      - const: lane-28g
> +        description: Lane part of a 28G SerDes module
> +
> +  reg:
> +    description:
> +      Registers memory map offset and size for this lane
> +
> +  reg-names:
> +    description:
> +      Names of the register map given in "reg" node.
> +
> +examples:
> +  - |
> +    serdes1: serdes@1ea0000 {
> +        compatible = "serdes-10g";

Do you have a datasheet for this device as bindings describe devices?
I assume not because serdes is a protocol, not a device. AFAIK,
there's no standard programming interface for 'serdes' as that is
about the only time we have any sort of genericish compatible strings.
The compatible string at a minimum should tell me what the programming
model for the registers are.

> +        reg = <0x0 0x1ea0000 0 0x00002000>;
> +        reg-names = "serdes", "serdes-10g";

The default address and sizes are 1 cell. So you have addr 0 with size
0x1ea0000 and then addr 0 with size 0x2000.

> +        little-endian;
> +
> +        #address-cells = <1>;
> +        #size-cells = <1>;
> +        lane_a: lane@800 {
> +            compatible = "lane-10g";
> +            reg = <0x800 0x40>;
> +            reg-names = "lane", "serdes-lane";

Not valid. You have 1 entry (with a addr and size) for reg, but 2
entries for reg-names.

40G is made up of 4 10G lanes, right? Do all 40G serdes phys have
separate register regions for each lane? You can't assume lanes and DT
nodes are 1-1.

As lanes have to be child nodes, these 2 schemas should be 1. Though I
don't think lane nodes will survive.

> +        };
> +        lane_b: lane@840 {
> +            compatible = "lane-10g";
> +            reg = <0x840 0x40>;
> +            reg-names = "lane", "serdes-lane";
> +        };
> +    };
> diff --git a/Documentation/devicetree/bindings/net/serdes.yaml b/Documentation/devicetree/bindings/net/serdes.yaml
> new file mode 100644
> index 0000000..fd3da85
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/serdes.yaml
> @@ -0,0 +1,44 @@
> +# SPDX-License-Identifier: GPL-2.0
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/serdes.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: Serdes Module Binding
> +
> +maintainers:
> +  - Florinel Iordache <florinel.iordache@nxp.com>
> +
> +properties:
> +  $nodename:
> +    pattern: "^serdes(@[a-f0-9]+)?$"
> +
> +  compatible:
> +    oneOf:
> +      - const: serdes-10g
> +        description: SerDes module type of 10G
> +      - const: serdes-28g
> +        description: SerDes module type of 28G
> +
> +  reg:
> +    description:
> +      Registers memory map offset and size for this serdes module
> +
> +  reg-names:
> +    description:
> +      Names of the register map given in "reg" node.
> +
> +  little-endian:
> +    description:
> +      Specifies the endianness of serdes module
> +      For complete definition see
> +      Documentation/devicetree/bindings/common-properties.txt
> +
> +examples:
> +  - |
> +    serdes1: serdes@1ea0000 {
> +        compatible = "serdes-10g";
> +        reg = <0x0 0x1ea0000 0 0x00002000>;
> +        reg-names = "serdes", "serdes-10g";
> +        little-endian;
> +    };
> --
> 1.9.1
>
