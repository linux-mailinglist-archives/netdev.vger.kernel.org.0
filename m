Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695696EFEA6
	for <lists+netdev@lfdr.de>; Thu, 27 Apr 2023 02:51:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242920AbjD0AvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Apr 2023 20:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241692AbjD0AvG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Apr 2023 20:51:06 -0400
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3873E136;
        Wed, 26 Apr 2023 17:51:00 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
        (using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
        by fd01.gateway.ufhost.com (Postfix) with ESMTP id 1C93980ED;
        Thu, 27 Apr 2023 08:50:52 +0800 (CST)
Received: from EXMBX162.cuchost.com (172.16.6.72) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 27 Apr
 2023 08:50:52 +0800
Received: from [192.168.120.42] (171.223.208.138) by EXMBX162.cuchost.com
 (172.16.6.72) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 27 Apr
 2023 08:50:51 +0800
Message-ID: <05071579-4cf9-c5ac-49cd-213a76966943@starfivetech.com>
Date:   Thu, 27 Apr 2023 08:50:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v1 1/2] dt-bindings: net: motorcomm: Add pad driver
 strength cfg
Content-Language: en-US
To:     Frank Sae <Frank.Sae@motor-comm.com>,
        <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
        <netdev@vger.kernel.org>, Peter Geis <pgwipeout@gmail.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        "Heiner Kallweit" <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230426063541.15378-1-samin.guo@starfivetech.com>
 <20230426063541.15378-2-samin.guo@starfivetech.com>
 <04f4e968-946e-cbf0-3d78-cfe6cb17afb3@motor-comm.com>
From:   Guo Samin <samin.guo@starfivetech.com>
In-Reply-To: <04f4e968-946e-cbf0-3d78-cfe6cb17afb3@motor-comm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS066.cuchost.com (172.16.6.26) To EXMBX162.cuchost.com
 (172.16.6.72)
X-YovoleRuleAgent: yovoleflag
X-Spam-Status: No, score=-3.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Re: [PATCH v1 1/2] dt-bindings: net: motorcomm: Add pad driver strength cfg
From: Frank Sae <Frank.Sae@motor-comm.com>
to: Samin Guo <samin.guo@starfivetech.com>, <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>, <netdev@vger.kernel.org>, Peter Geis <pgwipeout@gmail.com>
data: 2023/4/26

> 
> 
> On 2023/4/26 14:35, Samin Guo wrote:
>> The motorcomm phy (YT8531) supports the ability to adjust the drive
>> strength of the rx_clk/rx_data, the value range of pad driver
>> strength is 0 to 7.
>>
>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>> ---
>>  .../devicetree/bindings/net/motorcomm,yt8xxx.yaml      | 10 ++++++++++
>>  1 file changed, 10 insertions(+)
>>
>> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>> index 157e3bbcaf6f..e648e486b6d8 100644
>> --- a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>> @@ -18,6 +18,16 @@ properties:
>>        - ethernet-phy-id4f51.e91a
>>        - ethernet-phy-id4f51.e91b
>>  
>> +  rx-clk-driver-strength:
>> +    description: drive strength of rx_clk pad.
>> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
>> +    default: 3
>> +
>> +  rx-data-driver-strength:
>> +    description: drive strength of rxd/rx_ctl rgmii pad.
>> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
>> +    default: 3
>> +
> 
> rx-clk-driver-strength and rx-data-driver-strength are not standard, so please add "motorcomm,".
> rx-clk-driver-strength => motorcomm,rx-clk-driver-strength
>

Thanks, I will fix it next version.


Best regards,
Samin
 
> 
>>    rx-internal-delay-ps:
>>      description: |
>>        RGMII RX Clock Delay used only when PHY operates in RGMII mode with


