Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED27136025D
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 08:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbhDOG2N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Apr 2021 02:28:13 -0400
Received: from fllv0016.ext.ti.com ([198.47.19.142]:57810 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbhDOG2M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 15 Apr 2021 02:28:12 -0400
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 13F6RSRu056407;
        Thu, 15 Apr 2021 01:27:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1618468048;
        bh=T1VGJWaSnZe1FPW2m57oyGHqhnqnwLtMvN8UhVow6dY=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=MgHlXsbXunc6B2jYzadb2+EQoQATkCj3eHcocRLODnfT0Mw4aX1II+ZWHdKY3TPQw
         +3/wW85M+pIGnHlb/ynLl7Wfx7/QlPX19e3YCSqCOUXc/dhGBtAppo7igRU0oH+5Ta
         K9N3o0Y12VdSwsu2mzWCZL8KB8r3ZVT3wGGCPOIA=
Received: from DLEE114.ent.ti.com (dlee114.ent.ti.com [157.170.170.25])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 13F6RSod078266
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 15 Apr 2021 01:27:28 -0500
Received: from DLEE101.ent.ti.com (157.170.170.31) by DLEE114.ent.ti.com
 (157.170.170.25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 15
 Apr 2021 01:27:28 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE101.ent.ti.com
 (157.170.170.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2 via
 Frontend Transport; Thu, 15 Apr 2021 01:27:28 -0500
Received: from [172.24.145.148] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id 13F6RL2o127491;
        Thu, 15 Apr 2021 01:27:22 -0500
Subject: Re: [PATCH v2 3/6] dt-bindings: phy: Add binding for TI TCAN104x CAN
 transceivers
To:     Marc Kleine-Budde <mkl@pengutronix.de>
CC:     <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <linux-phy@lists.infradead.org>,
        Chandrasekar Ramakrishnan <rcsekar@samsung.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>, <linux-can@vger.kernel.org>,
        <netdev@vger.kernel.org>, Vignesh Raghavendra <vigneshr@ti.com>,
        Lokesh Vutla <lokeshvutla@ti.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>
References: <20210414140521.11463-1-a-govindraju@ti.com>
 <20210414140521.11463-4-a-govindraju@ti.com>
 <20210414153303.yig6bguue3g25yhg@pengutronix.de>
From:   Aswath Govindraju <a-govindraju@ti.com>
Message-ID: <9a9a3b8b-f345-faae-b9bc-3961518e3d29@ti.com>
Date:   Thu, 15 Apr 2021 11:57:20 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210414153303.yig6bguue3g25yhg@pengutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

On 14/04/21 9:03 pm, Marc Kleine-Budde wrote:
> On 14.04.2021 19:35:18, Aswath Govindraju wrote:
>> Add binding documentation for TI TCAN104x CAN transceivers.
>>
>> Signed-off-by: Aswath Govindraju <a-govindraju@ti.com>
>> ---
>>  .../bindings/phy/ti,tcan104x-can.yaml         | 56 +++++++++++++++++++
>>  MAINTAINERS                                   |  1 +
>>  2 files changed, 57 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
>> new file mode 100644
>> index 000000000000..4abfc30a97d0
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/phy/ti,tcan104x-can.yaml
>> @@ -0,0 +1,56 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: "http://devicetree.org/schemas/phy/ti,tcan104x-can.yaml#"
>> +$schema: "http://devicetree.org/meta-schemas/core.yaml#"
>> +
>> +title: TCAN104x CAN TRANSCEIVER PHY
>> +
>> +maintainers:
>> +  - Aswath Govindraju <a-govindraju@ti.com>
>> +
>> +properties:
>> +  $nodename:
>> +    pattern: "^tcan104x-phy"
>> +
>> +  compatible:
>> +    enum:
>> +      - ti,tcan1042
>> +      - ti,tcan1043
> 
> Can you ensure that the 1042 has only the standby gpio and the 1043 has both?
> 

In the driver, it is the way the flags have been set for ti,tcan1042 and
ti,tcan1043.

>> +
>> +  '#phy-cells':
>> +    const: 0
>> +
>> +  standby-gpios:
>> +    description:
>> +      gpio node to toggle standby signal on transceiver
>> +    maxItems: 1
>> +
>> +  enable-gpios:
>> +    description:
>> +      gpio node to toggle enable signal on transceiver
>> +    maxItems: 1
>> +
>> +  max-bitrate:
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    description:
>> +      max bit rate supported in bps
>> +    minimum: 1
>> +
>> +required:
>> +  - compatible
>> +  - '#phy-cells'
>> +
>> +additionalProperties: false
>> +
>> +examples:
>> +  - |
>> +    #include <dt-bindings/gpio/gpio.h>
>> +
>> +    transceiver1: tcan104x-phy {
>> +      compatible = "ti,tcan1043";
>> +      #phy-cells = <0>;
>> +      max-bitrate = <5000000>;
>> +      standby-gpios = <&wakeup_gpio1 16 GPIO_ACTIVE_LOW>;
>> +      enable-gpios = <&main_gpio1 67 GPIO_ACTIVE_LOW>;
> 
> AFAICS the enable gpio is active high.
> 

I will correct this in the respin.

Thanks,
Aswath

> Marc
> 

