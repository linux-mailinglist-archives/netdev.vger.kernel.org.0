Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E493399644
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 16:20:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387858AbfHVOUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 10:20:36 -0400
Received: from fllv0015.ext.ti.com ([198.47.19.141]:37622 "EHLO
        fllv0015.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732693AbfHVOUg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 10:20:36 -0400
Received: from lelv0265.itg.ti.com ([10.180.67.224])
        by fllv0015.ext.ti.com (8.15.2/8.15.2) with ESMTP id x7MEKOU4130908;
        Thu, 22 Aug 2019 09:20:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1566483624;
        bh=amKlG2IVK/AlYef9CbdzVUck10xnAYyxWrzHwzN9Okc=;
        h=Subject:To:CC:References:From:Date:In-Reply-To;
        b=TxGYKEJZHIJ5HyjcrPhdNq7xJLFAtzavONZP8av4iQ29PWP7OV8PlElv3T9vsRGo1
         dqzVjpiSEat7GFuwJ7BZsM3ICYJeT/UCHXc4fJbMQYoMK505lS/rZeYPVRbeAdxTLj
         yYGpyWIpMXBS+HRrtxMg3ksTsBbY8i6bAeN6kmQ0=
Received: from DLEE103.ent.ti.com (dlee103.ent.ti.com [157.170.170.33])
        by lelv0265.itg.ti.com (8.15.2/8.15.2) with ESMTPS id x7MEKOUY063221
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 22 Aug 2019 09:20:24 -0500
Received: from DLEE115.ent.ti.com (157.170.170.26) by DLEE103.ent.ti.com
 (157.170.170.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5; Thu, 22
 Aug 2019 09:20:24 -0500
Received: from lelv0327.itg.ti.com (10.180.67.183) by DLEE115.ent.ti.com
 (157.170.170.26) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1713.5 via
 Frontend Transport; Thu, 22 Aug 2019 09:20:23 -0500
Received: from [10.250.65.13] (ileax41-snat.itg.ti.com [10.172.224.153])
        by lelv0327.itg.ti.com (8.15.2/8.15.2) with ESMTP id x7MEKNnV076638;
        Thu, 22 Aug 2019 09:20:23 -0500
Subject: Re: [PATCH v12 3/5] dt-bindings: can: tcan4x5x: Add DT bindings for
 TCAN4x5X driver
To:     Marc Kleine-Budde <mkl@pengutronix.de>, <wg@grandegger.com>,
        <davem@davemloft.net>
CC:     <linux-can@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20190509161109.10499-1-dmurphy@ti.com>
 <20190509161109.10499-3-dmurphy@ti.com>
 <bdf06ead-a2e8-09a9-8cdd-49b54ec9da72@pengutronix.de>
From:   Dan Murphy <dmurphy@ti.com>
Message-ID: <ff9e007b-6e39-3d64-b62b-93c281d69113@ti.com>
Date:   Thu, 22 Aug 2019 09:20:22 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <bdf06ead-a2e8-09a9-8cdd-49b54ec9da72@pengutronix.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Marc

On 8/16/19 4:38 AM, Marc Kleine-Budde wrote:
> On 5/9/19 6:11 PM, Dan Murphy wrote:
>> DT binding documentation for TI TCAN4x5x driver.
>>
>> Signed-off-by: Dan Murphy <dmurphy@ti.com>
>> ---
>>
>> v12 - No changes - https://lore.kernel.org/patchwork/patch/1052300/
>>
>> v11 - No changes - https://lore.kernel.org/patchwork/patch/1051178/
>> v10 - No changes - https://lore.kernel.org/patchwork/patch/1050488/
>> v9 - No Changes - https://lore.kernel.org/patchwork/patch/1050118/
>> v8 - No Changes - https://lore.kernel.org/patchwork/patch/1047981/
>> v7 - Made device state optional - https://lore.kernel.org/patchwork/patch/1047218/
>> v6 - No changes - https://lore.kernel.org/patchwork/patch/1042445/
>>
>>   .../devicetree/bindings/net/can/tcan4x5x.txt  | 37 +++++++++++++++++++
>>   1 file changed, 37 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/can/tcan4x5x.txt
>>
>> diff --git a/Documentation/devicetree/bindings/net/can/tcan4x5x.txt b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
>> new file mode 100644
>> index 000000000000..c388f7d9feb1
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/can/tcan4x5x.txt
>> @@ -0,0 +1,37 @@
>> +Texas Instruments TCAN4x5x CAN Controller
>> +================================================
>> +
>> +This file provides device node information for the TCAN4x5x interface contains.
>> +
>> +Required properties:
>> +	- compatible: "ti,tcan4x5x"
>> +	- reg: 0
>> +	- #address-cells: 1
>> +	- #size-cells: 0
>> +	- spi-max-frequency: Maximum frequency of the SPI bus the chip can
>> +			     operate at should be less than or equal to 18 MHz.
>> +	- data-ready-gpios: Interrupt GPIO for data and error reporting.
>> +	- device-wake-gpios: Wake up GPIO to wake up the TCAN device.
>> +
>> +See Documentation/devicetree/bindings/net/can/m_can.txt for additional
>> +required property details.
>> +
>> +Optional properties:
>> +	- reset-gpios: Hardwired output GPIO. If not defined then software
>> +		       reset.
>> +	- device-state-gpios: Input GPIO that indicates if the device is in
>> +			      a sleep state or if the device is active.
>> +
>> +Example:
>> +tcan4x5x: tcan4x5x@0 {
>> +		compatible = "ti,tcan4x5x";
>> +		reg = <0>;
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		spi-max-frequency = <10000000>;
>> +		bosch,mram-cfg = <0x0 0 0 32 0 0 1 1>;
>> +		data-ready-gpios = <&gpio1 14 GPIO_ACTIVE_LOW>;
> Can you convert this into a proper interrupt property? E.g.:

OK.  Do you want v13 or do you want patches on top for net-next?

Dan


>
>>                  interrupt-parent = <&gpio4>;
>>                  interrupts = <13 0x2>;
> See:
> https://elixir.bootlin.com/linux/latest/source/Documentation/devicetree/bindings/net/can/microchip,mcp251x.txt#L21
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/tree/drivers/net/can/spi/mcp251x.c?h=mcp251x#n945

This second link says it invalid

Dan

>
>> +		device-state-gpios = <&gpio3 21 GPIO_ACTIVE_HIGH>;
>> +		device-wake-gpios = <&gpio1 15 GPIO_ACTIVE_HIGH>;
>> +		reset-gpios = <&gpio1 27 GPIO_ACTIVE_LOW>;
>> +};
> Marc
>
