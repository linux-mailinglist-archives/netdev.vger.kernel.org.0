Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44C1A1C5A55
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 17:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729736AbgEEPBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 11:01:23 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:42488 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729596AbgEEPBV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 11:01:21 -0400
Received: from fllv0035.itg.ti.com ([10.64.41.0])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 045F1C1I031325;
        Tue, 5 May 2020 10:01:12 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1588690872;
        bh=ZZFdDWeTsz/9HB3a494CXlZiESp5CsosOcPmdUx8LtM=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=qcqHS2nY07j+wCv1M/3KTC3g2EnGG+DAHPwI6xaz6xzFjZBgJlPPcwr+SQsCA/4NA
         rcEv6GYE3ng2zJbpGIZH0eMfh1894sij91bQhmv3VM6BLU8xpGCrhGpg4ZECZoE48O
         mZcUTMmb6b4PUddR00Nq+YADYKiT1o42bxMCryA4=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by fllv0035.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045F1CHI017837;
        Tue, 5 May 2020 10:01:12 -0500
Received: from DFLE114.ent.ti.com (10.64.6.35) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3; Tue, 5 May
 2020 10:01:11 -0500
Received: from lelv0326.itg.ti.com (10.180.67.84) by DFLE114.ent.ti.com
 (10.64.6.35) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1979.3 via
 Frontend Transport; Tue, 5 May 2020 10:01:12 -0500
Received: from [10.250.100.73] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0326.itg.ti.com (8.15.2/8.15.2) with ESMTP id 045F16vw000319;
        Tue, 5 May 2020 10:01:08 -0500
Subject: Re: [PATCH net-next 1/7] dt-binding: ti: am65x: document common
 platform time sync cpts module
To:     Rob Herring <robh@kernel.org>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Tero Kristo <t-kristo@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>, <netdev@vger.kernel.org>,
        Sekhar Nori <nsekhar@ti.com>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, Nishanth Menon <nm@ti.com>
References: <20200501205011.14899-1-grygorii.strashko@ti.com>
 <20200501205011.14899-2-grygorii.strashko@ti.com>
 <20200505040419.GA8509@bogus>
From:   Grygorii Strashko <grygorii.strashko@ti.com>
Message-ID: <b8bb1076-e345-5146-62d3-e1da1d35da4f@ti.com>
Date:   Tue, 5 May 2020 18:01:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200505040419.GA8509@bogus>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 05/05/2020 07:04, Rob Herring wrote:
> On Fri, May 01, 2020 at 11:50:05PM +0300, Grygorii Strashko wrote:
>> Document device tree bindings for TI AM654/J721E SoC The Common Platform
>> Time Sync (CPTS) module. The CPTS module is used to facilitate host control
>> of time sync operations. Main features of CPTS module are:
>>    - selection of multiple external clock sources
>>    - 64-bit timestamp mode in ns with ppm and nudge adjustment.
>>    - control of time sync events via interrupt or polling
>>    - hardware timestamp of ext. events (HWx_TS_PUSH)
>>    - periodic generator function outputs (TS_GENFx)
>>    - PPS in combination with timesync router
>>    - Depending on integration it enables compliance with the IEEE 1588-2008
>> standard for a precision clock synchronization protocol, Ethernet Enhanced
>> Scheduled Traffic Operations (CPTS_ESTFn) and PCIe Subsystem Precision Time
>> Measurement (PTM).
>>
>> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
>> ---
>>   .../bindings/net/ti,k3-am654-cpsw-nuss.yaml   |   7 +
>>   .../bindings/net/ti,k3-am654-cpts.yaml        | 152 ++++++++++++++++++
>>   2 files changed, 159 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> index 78bf511e2892..0f3fde45e200 100644
>> --- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
>> @@ -144,6 +144,13 @@ patternProperties:
>>       description:
>>         CPSW MDIO bus.
>>   
>> +  "^cpts$":

ok

> 
> Fixed strings go under 'properties'.
> 
>> +    type: object
>> +    allOf:
>> +      - $ref: "ti,am654-cpts.yaml#"
>> +    description:
>> +      CPSW Common Platform Time Sync (CPTS) module.
>> +
>>   required:
>>     - compatible
>>     - reg
>> diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
>> new file mode 100644
>> index 000000000000..1b535d41e5c6
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
>> @@ -0,0 +1,152 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/ti,am654-cpts.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: The TI AM654x/J721E Common Platform Time Sync (CPTS) module Device Tree Bindings
>> +
>> +maintainers:
>> +  - Grygorii Strashko <grygorii.strashko@ti.com>
>> +  - Sekhar Nori <nsekhar@ti.com>
>> +
>> +description: |+
>> +  The TI AM654x/J721E CPTS module is used to facilitate host control of time
>> +  sync operations.
>> +  Main features of CPTS module are
>> +  - selection of multiple external clock sources
>> +  - Software control of time sync events via interrupt or polling
>> +  - 64-bit timestamp mode in ns with PPM and nudge adjustment.
>> +  - hardware timestamp push inputs (HWx_TS_PUSH)
>> +  - timestamp counter compare output (TS_COMP)
>> +  - timestamp counter bit output (TS_SYNC)
>> +  - periodic Generator function outputs (TS_GENFx)
>> +  - Ethernet Enhanced Scheduled Traffic Operations (CPTS_ESTFn) (TSN)
>> +  - external hardware timestamp push inputs (HWx_TS_PUSH) timestamping
>> +
>> +   Depending on integration it enables compliance with the IEEE 1588-2008
>> +   standard for a precision clock synchronization protocol, Ethernet Enhanced
>> +   Scheduled Traffic Operations (CPTS_ESTFn) and PCIe Subsystem Precision Time
>> +   Measurement (PTM).
>> +
>> +  TI AM654x/J721E SoCs has several similar CPTS modules integrated into the
>> +  different parts of the system which could be synchronized with each other
>> +  - Main CPTS
>> +  - MCU CPSW CPTS with IEEE 1588-2008 support
>> +  - PCIe subsystem CPTS for PTM support
>> +
>> +  Depending on CPTS module integration and when CPTS is integral part of
>> +  another module (MCU CPSW for example) "compatible" and "reg" can
>> +  be omitted - parent module is fully responsible for CPTS enabling and
>> +  configuration.
> 
> That's fine, but you should still have compatible and reg.

I'll add reg as below. But compatible is an issue, because
k3-am654-cpsw-nuss call of_platform_populate() to create mdio device.
But for CPTS I do not want to create device as k3-am654-cpsw-nuss uses direct
function calls to CPTS.

Will it be correct to switch to of_platform_device_create() instead of
of_platform_populate()?

> 
>> +
>> +properties:
>> +  $nodename:
>> +    pattern: "^cpts(@.*|-[0-9a-f])*$"
>> +
>> +  compatible:
>> +    oneOf:
>> +      - const: ti,am65-cpts
>> +      - const: ti,j721e-cpts
>> +
>> +  reg:
>> +    maxItems: 1
>> +    description:
>> +       The physical base address and size of CPTS IO range
> 
> Wrong indentation.
> 
>> +
>> +  reg-names:
>> +    items:
>> +      - const: cpts
> 
> Don't really need *-names when there's only one and you haven't picked
> very meaningful names.

Could I keep it if you don't mind?

> 
>> +
>> +  clocks:
>> +    description: CPTS reference clock
>> +
>> +  clock-names:
>> +    items:
>> +      - const: cpts
>> +
>> +  interrupts-extended:
> 
> Use 'interrupts' here, the tooling will fixup things to allow both.
> 

[...]

>> +
>> +examples:
>> +  - |
>> +    #include <dt-bindings/interrupt-controller/irq.h>
>> +    #include <dt-bindings/interrupt-controller/arm-gic.h>
>> +
>> +    cpts@310d0000 {
>> +         compatible = "ti,am65-cpts";
>> +         reg = <0x0 0x310d0000 0x0 0x400>;
>> +         reg-names = "cpts";
>> +         clocks = <&main_cpts_mux>;
>> +         clock-names = "cpts";
>> +         interrupts-extended = <&k3_irq 163 0 IRQ_TYPE_LEVEL_HIGH>;
>> +         interrupt-names = "cpts";
>> +         ti,cpts-periodic-outputs = <6>;
>> +         ti,cpts-ext-ts-inputs = <8>;
>> +
>> +         main_cpts_mux: refclk-mux {
>> +               #clock-cells = <0>;
>> +               clocks = <&k3_clks 118 5>, <&k3_clks 118 11>,
>> +                        <&k3_clks 157 91>, <&k3_clks 157 77>,
>> +                        <&k3_clks 157 102>, <&k3_clks 157 80>,
>> +                        <&k3_clks 120 3>, <&k3_clks 121 3>;
>> +               assigned-clocks = <&main_cpts_mux>;
>> +               assigned-clock-parents = <&k3_clks 118 11>;
>> +         };
>> +    };
>> +  - |
>> +
>> +    cpts {
>> +             clocks = <&k3_clks 18 2>;
>> +             clock-names = "cpts";
>> +             interrupts-extended = <&gic500 GIC_SPI 858 IRQ_TYPE_LEVEL_HIGH>;
>> +             interrupt-names = "cpts";
>> +             ti,cpts-ext-ts-inputs = <4>;
>> +             ti,cpts-periodic-outputs = <2>;
> 
> How is this example accessed?

I'll move it in .../bindings/net/ti,k3-am654-cpsw-nuss.yaml as below

--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpsw-nuss.yaml
@@ -143,7 +143,7 @@ patternProperties:
      description:
        CPSW MDIO bus.
  
-  "^cpts$":
+  "^cpts(@.*|-[0-9a-f])*$":
      type: object
      allOf:
        - $ref: "ti,am654-cpts.yaml#"
@@ -170,6 +170,8 @@ examples:
      #include <dt-bindings/pinctrl/k3.h>
      #include <dt-bindings/soc/ti,sci_pm_domain.h>
      #include <dt-bindings/net/ti-dp83867.h>
+    #include <dt-bindings/interrupt-controller/irq.h>
+    #include <dt-bindings/interrupt-controller/arm-gic.h>
  
      mcu_cpsw: ethernet@46000000 {
          compatible = "ti,am654-cpsw-nuss";
@@ -228,4 +230,14 @@ examples:
                      ti,fifo-depth = <DP83867_PHYCR_FIFO_DEPTH_4_B_NIB>;
                };
          };
+
+       cpts@3d000 {
+             reg = <0x0 0x3d000 0x0 0x400>;
+             clocks = <&k3_clks 18 2>;
+             clock-names = "cpts";
+             interrupts-extended = <&gic500 GIC_SPI 858 IRQ_TYPE_LEVEL_HIGH>;
+             interrupt-names = "cpts";
+             ti,cpts-ext-ts-inputs = <4>;
+             ti,cpts-periodic-outputs = <2>;
+       };
      };
diff --git a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
index 1b535d41e5c6..1f7fdbab3191 100644
--- a/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
+++ b/Documentation/devicetree/bindings/net/ti,k3-am654-cpts.yaml
@@ -140,13 +140,3 @@ examples:
                 assigned-clock-parents = <&k3_clks 118 11>;
           };
      };
-  - |
-
-    cpts {
-             clocks = <&k3_clks 18 2>;
-             clock-names = "cpts";
-             interrupts-extended = <&gic500 GIC_SPI 858 IRQ_TYPE_LEVEL_HIGH>;
-             interrupt-names = "cpts";
-             ti,cpts-ext-ts-inputs = <4>;
-             ti,cpts-periodic-outputs = <2>;
-    };




-- 
Best regards,
grygorii
