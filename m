Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 672D918DB5B
	for <lists+netdev@lfdr.de>; Fri, 20 Mar 2020 23:56:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727527AbgCTW4D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Mar 2020 18:56:03 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:36059 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbgCTW4C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Mar 2020 18:56:02 -0400
Received: by mail-il1-f196.google.com with SMTP id h3so7218470ils.3;
        Fri, 20 Mar 2020 15:56:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=16V2PA006Te0JwlEk0mhuUcYVDotlcL0klCaZu/h5A8=;
        b=ZIlaihbxeF9DPXWKqEkNsdYL2umAWkwGVBa4IA8S4w/kPa4+OVs67ezIG79pcbt9T7
         Gripk9F8vucKMRm9Qxyr29tQ2l7tbrQJjtDh9PZ8lGt3DUHj0FfHT4s3EXlh17oPttjv
         ELTcTfUBhFh4bW80CzQq+wvFmlzv1pediT/nKq17EYULngzRQC3tgwinGygR2QsxIdql
         d/cwDFrtPm1C6cQflaRtvlZEN8oH+DlTSPAm+LCHoVM8q9SGoRC7NPLYuH9VR84lB+QA
         sSxWc3M5xDj9H2rEcrYZ794nMRm2tC/KCT0+5dufcSQpuwLvlzGPAAXZK1NUvFZLEOmd
         EhOA==
X-Gm-Message-State: ANhLgQ0/wFpuh2cuDssQY5oSuodTQDu+2v4QpJoTVSy7NWlsd2KYKk3k
        LZsSKF0j5UaWyZxTJZI9qr9LEWg=
X-Google-Smtp-Source: ADFU+vvtRrebZOPJbmnpUIwVYfdBNmdgRTWv+rpWOHXT/pBibD5UObIfTV5Gk7Hqqyt6YoTnNzZJ7w==
X-Received: by 2002:a92:58d0:: with SMTP id z77mr9859903ilf.67.1584744959682;
        Fri, 20 Mar 2020 15:55:59 -0700 (PDT)
Received: from rob-hp-laptop ([64.188.179.250])
        by smtp.gmail.com with ESMTPSA id g69sm1593099ile.3.2020.03.20.15.55.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Mar 2020 15:55:58 -0700 (PDT)
Received: (nullmailer pid 23774 invoked by uid 1000);
        Fri, 20 Mar 2020 22:55:56 -0000
Date:   Fri, 20 Mar 2020 16:55:56 -0600
From:   Rob Herring <robh@kernel.org>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Tero Kristo <t-kristo@ti.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        devicetree@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net-next v5 05/11] dt-binding: ti: am65x: document mcu
 cpsw nuss
Message-ID: <20200320225556.GA12084@bogus>
References: <20200319162806.25705-1-grygorii.strashko@ti.com>
 <20200319162806.25705-6-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200319162806.25705-6-grygorii.strashko@ti.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 06:28:00PM +0200, Grygorii Strashko wrote:
> Document device tree bindings for The TI AM654x/J721E SoC Gigabit Ethernet MAC
> (Media Access Controller - CPSW2G NUSS). The CPSW NUSS provides Ethernet packet
> communication for the device.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Tested-by: Murali Karicheri <m-karicheri2@ti.com>
> ---
>  .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   | 226 ++++++++++++++++++
>  1 file changed, 226 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> 
> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> new file mode 100644
> index 000000000000..c28b5c925377
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
> @@ -0,0 +1,226 @@
> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
> +%YAML 1.2
> +---
> +$id: http://devicetree.org/schemas/net/ti,k3-am654-cpsw-nuss.yaml#
> +$schema: http://devicetree.org/meta-schemas/core.yaml#
> +
> +title: The TI AM654x/J721E SoC Gigabit Ethernet MAC (Media Access Controller) Device Tree Bindings
> +
> +maintainers:
> +  - Grygorii Strashko <grygorii.strashko@ti.com>
> +  - Sekhar Nori <nsekhar@ti.com>
> +
> +description:
> +  The TI AM654x/J721E SoC Gigabit Ethernet MAC (CPSW2G NUSS) has two ports
> +  (one external) and provides Ethernet packet communication for the device.
> +  CPSW2G NUSS features - the Reduced Gigabit Media Independent Interface (RGMII),
> +  Reduced Media Independent Interface (RMII), the Management Data
> +  Input/Output (MDIO) interface for physical layer device (PHY) management,
> +  new version of Common Platform Time Sync (CPTS), updated Address Lookup
> +  Engine (ALE).
> +  One external Ethernet port (port 1) with selectable RGMII/RMII interfaces and
> +  an internal Communications Port Programming Interface (CPPI5) (Host port 0).
> +  Host Port 0 CPPI Packet Streaming Interface interface supports 8 TX channels
> +  and one RX channels and operating by TI AM654x/J721E NAVSS Unified DMA
> +  Peripheral Root Complex (UDMA-P) controller.
> +  The CPSW2G NUSS is integrated into device MCU domain named MCU_CPSW0.
> +
> +  Additional features
> +  priority level Quality Of Service (QOS) support (802.1p)
> +  Support for Audio/Video Bridging (P802.1Qav/D6.0)
> +  Support for IEEE 1588 Clock Synchronization (2008 Annex D, Annex E and Annex F)
> +  Flow Control (802.3x) Support
> +  Time Sensitive Network Support
> +  IEEE P902.3br/D2.0 Interspersing Express Traffic
> +  IEEE 802.1Qbv/D2.2 Enhancements for Scheduled Traffic
> +  Configurable number of addresses plus VLANs
> +  Configurable number of classifier/policers
> +  VLAN support, 802.1Q compliant, Auto add port VLAN for untagged frames on
> +  ingress, Auto VLAN removal on egress and auto pad to minimum frame size.
> +  RX/TX csum offload
> +
> +  Specifications can be found at
> +    http://www.ti.com/lit/ug/spruid7e/spruid7e.pdf
> +    http://www.ti.com/lit/ug/spruil1a/spruil1a.pdf
> +
> +properties:
> +  "#address-cells": true
> +  "#size-cells": true
> +
> +  compatible:
> +    oneOf:
> +      - const: ti,am654-cpsw-nuss
> +      - const: ti,j721e-cpsw-nuss
> +
> +  reg:
> +    maxItems: 1
> +    description:
> +       The physical base address and size of full the CPSW2G NUSS IO range
> +
> +  reg-names:
> +    items:
> +      - const: cpsw_nuss
> +
> +  ranges: true
> +
> +  dma-coherent: true
> +
> +  clocks:
> +    description: CPSW2G NUSS functional clock
> +
> +  clock-names:
> +    items:
> +      - const: fck
> +
> +  power-domains:
> +    maxItems: 1
> +
> +  dmas:
> +    minItems: 9

Drop this. maxItems is enough.

> +    maxItems: 9
> +
> +  dma-names:
> +    items:
> +      - const: tx0
> +      - const: tx1
> +      - const: tx2
> +      - const: tx3
> +      - const: tx4
> +      - const: tx5
> +      - const: tx6
> +      - const: tx7
> +      - const: rx
> +
> +  pinctrl-names: true

Don't need this. It is implicitly allowed.

> +
> +  ethernet-ports:
> +    type: object
> +    properties:
> +      '#address-cells':
> +        const: 1
> +      '#size-cells':
> +        const: 0
> +
> +    patternProperties:
> +      "^port@[0-9]+$":

reg must be 1, but unit-address can be any number (though it should be 
hex)?

> +          type: object
> +          description: CPSW2G NUSS external ports
> +
> +          allOf:
> +            - $ref: ethernet-controller.yaml#
> +
> +          properties:
> +            reg:
> +              items:
> +                - const: 1
> +              description: CPSW port number
> +
> +            phys:
> +              maxItems: 1
> +              description:  phandle on phy-gmii-sel PHY
> +
> +            label:
> +              description: label associated with this port
> +
> +            ti,mac-only:
> +              $ref: /schemas/types.yaml#definitions/flag
> +              description:
> +                Specifies the port works in mac-only mode.
> +
> +            ti,syscon-efuse:
> +              $ref: /schemas/types.yaml#definitions/phandle-array
> +              description:
> +                Phandle to the system control device node which provides access
> +                to efuse IO range with MAC addresses
> +
> +          required:
> +            - reg
> +            - phys

ethernet-ports needs an 'additionalProperties: false'

> +
> +  mdio:
> +    type: object
> +    allOf:
> +      - $ref: "ti,davinci-mdio.yaml#"
> +    description:
> +      CPSW MDIO bus.
> +
> +patternProperties:
> +  "^pinctrl-[0-9]+$": true

Can drop this.

> +
> +required:
> +  - compatible
> +  - reg
> +  - reg-names
> +  - ranges
> +  - clocks
> +  - clock-names
> +  - power-domains
> +  - dmas
> +  - dma-names
> +  - '#address-cells'
> +  - '#size-cells'

Add: 

additionalProperties: false

> +
> +examples:
> +  - |
> +    #include <dt-bindings/pinctrl/k3.h>
> +    #include <dt-bindings/soc/ti,sci_pm_domain.h>
> +    #include <dt-bindings/net/ti-dp83867.h>
> +
> +    mcu_cpsw: ethernet@46000000 {
> +        compatible = "ti,am654-cpsw-nuss";
> +        #address-cells = <2>;
> +        #size-cells = <2>;
> +        reg = <0x0 0x46000000 0x0 0x200000>;
> +        reg-names = "cpsw_nuss";
> +        ranges = <0x0 0x0 0x46000000 0x0 0x200000>;
> +        dma-coherent;
> +        clocks = <&k3_clks 5 10>;
> +        clock-names = "fck";
> +        power-domains = <&k3_pds 5 TI_SCI_PD_EXCLUSIVE>;
> +        pinctrl-names = "default";
> +        pinctrl-0 = <&mcu_cpsw_pins_default &mcu_mdio_pins_default>;
> +
> +        dmas = <&mcu_udmap 0xf000>,
> +               <&mcu_udmap 0xf001>,
> +               <&mcu_udmap 0xf002>,
> +               <&mcu_udmap 0xf003>,
> +               <&mcu_udmap 0xf004>,
> +               <&mcu_udmap 0xf005>,
> +               <&mcu_udmap 0xf006>,
> +               <&mcu_udmap 0xf007>,
> +               <&mcu_udmap 0x7000>;
> +        dma-names = "tx0", "tx1", "tx2", "tx3", "tx4", "tx5", "tx6", "tx7",
> +                    "rx";
> +
> +        ethernet-ports {
> +              #address-cells = <1>;
> +              #size-cells = <0>;
> +
> +              cpsw_port1: port@1 {
> +                    reg = <1>;
> +                    ti,mac-only;
> +                    label = "port1";
> +                    ti,syscon-efuse = <&mcu_conf 0x200>;
> +                    phys = <&phy_gmii_sel 1>;
> +
> +                    phy-mode = "rgmii-rxid";
> +                    phy-handle = <&phy0>;
> +              };
> +        };
> +
> +        davinci_mdio: mdio@f00 {
> +              compatible = "ti,cpsw-mdio","ti,davinci_mdio";
> +              reg = <0x0 0xf00 0x0 0x100>;
> +              #address-cells = <1>;
> +              #size-cells = <0>;
> +              clocks = <&k3_clks 5 10>;
> +              clock-names = "fck";
> +              bus_freq = <1000000>;
> +
> +              phy0: ethernet-phy@0 {
> +                    reg = <0>;
> +                    ti,rx-internal-delay = <DP83867_RGMIIDCTL_2_00_NS>;
> +                    ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
> +              };
> +        };
> +    };
> -- 
> 2.17.1
> 
