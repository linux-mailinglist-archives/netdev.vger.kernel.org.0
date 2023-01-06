Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E900B65FD63
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 10:16:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbjAFJQf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 04:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232518AbjAFJQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 04:16:31 -0500
Received: from out29-10.mail.aliyun.com (out29-10.mail.aliyun.com [115.124.29.10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B65B63D2A;
        Fri,  6 Jan 2023 01:16:28 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07872471|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.0430848-0.00314929-0.953766;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047202;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.Qlv4Ozn_1672996585;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.Qlv4Ozn_1672996585)
          by smtp.aliyun-inc.com;
          Fri, 06 Jan 2023 17:16:26 +0800
Message-ID: <8fa89dac-6859-af93-0dc0-ffcb42b5bb30@motor-comm.com>
Date:   Fri, 6 Jan 2023 17:17:04 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v1 1/3] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy Driver bindings
Content-Language: en-US
To:     Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     xiaogang.fan@motor-comm.com, fei.zhang@motor-comm.com,
        hua.sun@motor-comm.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org
References: <20230105073024.8390-1-Frank.Sae@motor-comm.com>
 <20230105073024.8390-2-Frank.Sae@motor-comm.com>
 <b74baadf-37a4-c9a2-c821-3c3e0143fa4a@linaro.org>
From:   "Frank.Sae" <Frank.Sae@motor-comm.com>
In-Reply-To: <b74baadf-37a4-c9a2-c821-3c3e0143fa4a@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Krzysztof Kozlowski,

On 2023/1/6 16:26, Krzysztof Kozlowski wrote:
> On 05/01/2023 08:30, Frank wrote:
>> Add a YAML binding document for the Motorcom yt8xxx Ethernet phy driver.
>>
> 
> Subject: drop second, redundant "Driver bindings".

Change Subject from
dt-bindings: net: Add Motorcomm yt8xxx ethernet phy Driver bindings
to
dt-bindings: net: Add Motorcomm yt8xxx ethernet phy
?

> 
>> Signed-off-by: Frank <Frank.Sae@motor-comm.com>
> 
> Use full first and last name. Your email suggests something more than
> only "Frank".
> 

OK , I will use  Frank.Sae <Frank.Sae@motor-comm.com>

>> ---
>>  .../bindings/net/motorcomm,yt8xxx.yaml        | 180 ++++++++++++++++++
>>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>>  MAINTAINERS                                   |   1 +
>>  3 files changed, 183 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>> new file mode 100644
>> index 000000000000..337a562d864c
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>> @@ -0,0 +1,180 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/motorcomm,yt8xxx.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: MotorComm yt8xxx Ethernet PHY
>> +
>> +maintainers:
>> +  - frank <frank.sae@motor-comm.com>
>> +
>> +description: |
>> +  Bindings for MotorComm yt8xxx PHYs.
> 
> Instead describe the hardware. No need to state the obvious that these
> are bindings.
> 

I will fix.

>> +  yt8511 will be supported later.
> 
> Bindings should be complete. Your driver support is not relevant here.

I will fix.

> 
>> +
>> +allOf:
>> +  - $ref: ethernet-phy.yaml#
>> +
>> +properties:
>> +  motorcomm,clk-out-frequency:
> 
> Use property suffixes matching the type.
> 
>> +    description: clock output in Hertz on clock output pin.
> 
> Drop "Hertz". It should be obvious from the suffix.
> 
>> +    $ref: /schemas/types.yaml#/definitions/uint32
> 
> Drop.
> 
> Anyway, does it fit standard clock-frequency property?
> 
>> +    enum: [0, 25000000, 125000000]
>> +    default: 0
>> +

Yes, I will fix.

>> +  motorcomm,rx-delay-basic:
>> +    description: |
>> +      Tristate, setup the basic RGMII RX Clock delay of PHY.
>> +      This basic delay is fixed at 2ns (1000Mbps) or 8ns (100Mbps、10Mbps).
>> +      This basic delay usually auto set by hardware according to the voltage
>> +      of RXD0 pin (low = 0, turn off;   high = 1, turn on).
>> +      If not exist, this delay is controlled by hardware.
> 
> I don't understand that at all. What "not exist"? There is no verb and
> no subject.
> 
> The type and description are really unclear.
> 
>> +      0: turn off;   1: turn on.
>> +    $ref: /schemas/types.yaml#/definitions/uint32
>> +    enum: [0, 1]
> 
> So this is bool?
> 

This basic delay can be controlled by hardware or dts.

Default value depends on power on strapping, according to the voltage
of RXD0 pin (low = 0, turn off;   high = 1, turn on).

"not exist" means that This basic delay is controlled by hardware,
and software don't change this.

I will fix.

>> +
>> +  motorcomm,rx-delay-additional-ps:
>> +    description: |
>> +      Setup the additional RGMII RX Clock delay of PHY defined in pico seconds.
>> +      RGMII RX Clock Delay = rx-delay-basic + rx-delay-additional-ps.
>> +    enum:
> 
> Best regards,
> Krzysztof
