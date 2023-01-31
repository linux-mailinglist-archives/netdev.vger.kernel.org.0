Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 856D16822B1
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 04:19:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230086AbjAaDTn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 22:19:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjAaDTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 22:19:41 -0500
Received: from out28-196.mail.aliyun.com (out28-196.mail.aliyun.com [115.124.28.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E9F35B0;
        Mon, 30 Jan 2023 19:19:39 -0800 (PST)
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1931266|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_regular_dialog|0.00821912-0.000205457-0.991575;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=frank.sae@motor-comm.com;NM=1;PH=DS;RN=17;RT=17;SR=0;TI=SMTPD_---.R5azWh9_1675135174;
Received: from 10.0.2.15(mailfrom:Frank.Sae@motor-comm.com fp:SMTPD_---.R5azWh9_1675135174)
          by smtp.aliyun-inc.com;
          Tue, 31 Jan 2023 11:19:35 +0800
Message-ID: <af6beebc-0a70-16f5-e0e9-5f4cbeea8955@motor-comm.com>
Date:   Tue, 31 Jan 2023 11:19:33 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH net-next v3 1/5] dt-bindings: net: Add Motorcomm yt8xxx
 ethernet phy
Content-Language: en-US
To:     Rob Herring <robh@kernel.org>
Cc:     Peter Geis <pgwipeout@gmail.com>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        yanhong.wang@starfivetech.com, xiaogang.fan@motor-comm.com,
        fei.zhang@motor-comm.com, hua.sun@motor-comm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20230130063539.3700-1-Frank.Sae@motor-comm.com>
 <20230130063539.3700-2-Frank.Sae@motor-comm.com>
 <20230130224158.GA3655289-robh@kernel.org>
From:   "Frank.Sae" <Frank.Sae@motor-comm.com>
In-Reply-To: <20230130224158.GA3655289-robh@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Rob,

On 2023/1/31 06:41, Rob Herring wrote:
> On Mon, Jan 30, 2023 at 02:35:35PM +0800, Frank Sae wrote:
>>  Add a YAML binding document for the Motorcom yt8xxx Ethernet phy driver.
> 
> Bindings are for h/w devices, not drivers.
> 
>>  
>> Signed-off-by: Frank Sae <Frank.Sae@motor-comm.com>
>> ---
>>  .../bindings/net/motorcomm,yt8xxx.yaml        | 102 ++++++++++++++++++
>>  .../devicetree/bindings/vendor-prefixes.yaml  |   2 +
>>  MAINTAINERS                                   |   1 +
>>  3 files changed, 105 insertions(+)
>>  create mode 100644 Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>>
>> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>> new file mode 100644
>> index 000000000000..8527576c15b3
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>> @@ -0,0 +1,102 @@
>> +# SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
>> +%YAML 1.2
>> +---
>> +$id: http://devicetree.org/schemas/net/motorcomm,yt8xxx.yaml#
>> +$schema: http://devicetree.org/meta-schemas/core.yaml#
>> +
>> +title: MotorComm yt8xxx Ethernet PHY
>> +
>> +maintainers:
>> +  - frank sae <frank.sae@motor-comm.com>
>> +
>> +allOf:
>> +  - $ref: ethernet-phy.yaml#
> 
> This schema doesn't work because there is no way to determine whether to 
> apply it or not. You need a compatible for your phy.
> 

 I don't understand how to add a compatible for my phy.

compatible:
    oneOf:
      - enum:
          - fsl,imx25-fec
          - fsl,imx27-fec

compatible usually like this, but it is usually for mac or mdio.


phy id list:
YT8511	0x0000010a
YT8521	0x0000011A
YT8531  0x4f51e91b

motorcomm,yt8xxx.yaml

    mdio0 {
        ...
        ethernet-phy@5 {
            compatible = "ethernet-phy-id0000.010a",
                         "ethernet-phy-id0000.011a",
                         "ethernet-phy-id4f51.e91b",
                         "ethernet-phy-ieee802.3-c22";
            reg = <5>;
            ...
        };
    };

 Should i add compatible like this ? 
 If above is error, please give me an example, thanks!

> Rob
