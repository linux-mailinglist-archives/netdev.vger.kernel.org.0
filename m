Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 268273EC5CD
	for <lists+netdev@lfdr.de>; Sun, 15 Aug 2021 00:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbhHNW1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Aug 2021 18:27:05 -0400
Received: from perseus.uberspace.de ([95.143.172.134]:49402 "EHLO
        perseus.uberspace.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbhHNW1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Aug 2021 18:27:04 -0400
Received: (qmail 24316 invoked from network); 14 Aug 2021 22:26:33 -0000
Received: from localhost (HELO localhost) (127.0.0.1)
  by perseus.uberspace.de with SMTP; 14 Aug 2021 22:26:33 -0000
Subject: Re: [PATCH 1/2] dt-bindings: net: add RTL8152 binding documentation
To:     Heiner Kallweit <hkallweit1@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, robh+dt@kernel.org, Pavel Machek <pavel@ucw.cz>
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
References: <20210814181107.138992-1-mail@david-bauer.net>
 <74795336-e3fa-422f-0004-a8cb180d84bc@gmail.com>
From:   David Bauer <mail@david-bauer.net>
Message-ID: <96f1d554-647b-fc75-8c5c-60bc20d79c80@david-bauer.net>
Date:   Sun, 15 Aug 2021 00:26:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <74795336-e3fa-422f-0004-a8cb180d84bc@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Heiner,

On 8/14/21 8:33 PM, Heiner Kallweit wrote:
> On 14.08.2021 20:11, David Bauer wrote:
>> Add binding documentation for the Realtek RTL8152 / RTL8153 USB ethernet
>> adapters.
>>
>> Signed-off-by: David Bauer <mail@david-bauer.net>
>> ---
>>   .../bindings/net/realtek,rtl8152.yaml         | 43 +++++++++++++++++++
>>   1 file changed, 43 insertions(+)
>>   create mode 100644 Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml b/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
>> new file mode 100644
>> index 000000000000..ab760000b3a6
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/realtek,rtl8152.yaml
>> @@ -0,0 +1,43 @@
>> +# SPDX-License-Identifier: GPL-2.0-only OR BSD-2-Clause
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/realtek,rtl8152.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: Realtek RTL8152/RTL8153 series USB ethernet
>> +
>> +maintainers:
>> +  - David Bauer <mail@david-bauer.net>
>> +
>> +properties:
>> +  compatible:
>> +    oneOf:
>> +      - items:
>> +          - enum:
>> +              - realtek,rtl8152
>> +              - realtek,rtl8153
>> +
>> +  reg:
>> +    description: The device number on the USB bus
>> +
>> +  realtek,led-data:
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    description: Value to be written to the LED configuration register.
>> +
> 
> +Pavel as LED subsystem maintainer
> 
> There's an ongoing discussion (with certain decisions taken already) about
> how to configure network device LEDs.

Thanks, I didn't knew about this.

Is there any place where i can read up specifics about
this topic?

Best
David

> 
>> +required:
>> +  - compatible
>> +  - reg
>> +
>> +examples:
>> +  - |
>> +    usb@100 {
>> +      reg = <0x100 0x100>;
>> +      #address-cells = <1>;
>> +      #size-cells = <0>;
>> +
>> +      usb-eth@2 {
>> +        compatible = "realtek,rtl8153";
>> +        reg = <0x2>;
>> +        realtek,led-data = <0x87>;
>> +      };
>> +    };
>>
> 
