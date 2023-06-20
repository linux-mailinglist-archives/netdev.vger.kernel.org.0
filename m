Return-Path: <netdev+bounces-12104-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id B1664736208
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 05:10:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4449F280F2A
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 03:10:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7089DED5;
	Tue, 20 Jun 2023 03:10:08 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C8415A8
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 03:10:07 +0000 (UTC)
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61050119;
	Mon, 19 Jun 2023 20:10:03 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
	by fd01.gateway.ufhost.com (Postfix) with ESMTP id 1DB288109;
	Tue, 20 Jun 2023 11:09:56 +0800 (CST)
Received: from EXMBX062.cuchost.com (172.16.6.62) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 20 Jun
 2023 11:09:56 +0800
Received: from [192.168.120.43] (171.223.208.138) by EXMBX062.cuchost.com
 (172.16.6.62) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Tue, 20 Jun
 2023 11:09:55 +0800
Message-ID: <15eb4ffe-ea12-9a2c-ae9d-c34860384b60@starfivetech.com>
Date: Tue, 20 Jun 2023 11:09:52 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v3 1/2] dt-bindings: net: motorcomm: Add pad driver
 strength cfg
Content-Language: en-US
From: Guo Samin <samin.guo@starfivetech.com>
To: Andrew Lunn <andrew@lunn.ch>, Conor Dooley <conor@kernel.org>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<netdev@vger.kernel.org>, Peter Geis <pgwipeout@gmail.com>, Frank
	<Frank.Sae@motor-comm.com>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>, Andrew Lunn <andrew@lunn.ch>, "Heiner
 Kallweit" <hkallweit1@gmail.com>, Russell King <linux@armlinux.org.uk>,
	Yanhong Wang <yanhong.wang@starfivetech.com>
References: <20230526090502.29835-1-samin.guo@starfivetech.com>
 <20230526090502.29835-2-samin.guo@starfivetech.com>
 <20230526-glutinous-pristine-fed571235b80@spud>
 <1dbf113c-7592-68bd-6aaf-05ff1d8c538c@starfivetech.com>
In-Reply-To: <1dbf113c-7592-68bd-6aaf-05ff1d8c538c@starfivetech.com>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS062.cuchost.com (172.16.6.22) To EXMBX062.cuchost.com
 (172.16.6.62)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net


Re: [PATCH v3 1/2] dt-bindings: net: motorcomm: Add pad driver strength c=
fg
From: Guo Samin <samin.guo@starfivetech.com>
to: Conor Dooley <conor@kernel.org>; Andrew Lunn <andrew@lunn.ch>
data: 2023/5/29

> Re: [PATCH v3 1/2] dt-bindings: net: motorcomm: Add pad driver strength=
 cfg
> From: Conor Dooley <conor@kernel.org>
> to: Samin Guo <samin.guo@starfivetech.com>
> data: 2023/5/27
>=20
>> On Fri, May 26, 2023 at 05:05:01PM +0800, Samin Guo wrote:
>>> The motorcomm phy (YT8531) supports the ability to adjust the drive
>>> strength of the rx_clk/rx_data, the value range of pad driver
>>> strength is 0 to 7.
>>>
>>> Signed-off-by: Samin Guo <samin.guo@starfivetech.com>
>>> ---
>>>  .../devicetree/bindings/net/motorcomm,yt8xxx.yaml    | 12 ++++++++++=
++
>>>  1 file changed, 12 insertions(+)
>>>
>>> diff --git a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.y=
aml b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>>> index 157e3bbcaf6f..29a1997a1577 100644
>>> --- a/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>>> +++ b/Documentation/devicetree/bindings/net/motorcomm,yt8xxx.yaml
>>> @@ -52,6 +52,18 @@ properties:
>>>        for a timer.
>>>      type: boolean
>>> =20
>>> +  motorcomm,rx-clk-driver-strength:
>>> +    description: drive strength of rx_clk pad.
>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
>>
>> I think you should use minimum & maximum instead of these listed out
>> enums.
>=20
> Thanks Conor, This can be improved in the next version.
>=20
>  You have also had this comment since v1 & were reminded of it on
>> v2 by Krzysztof: "What do the numbers mean? What are the units? mA?"
>>
>=20
>=20
> The good news is that we just got some data about units from Motorcomm.=
=20
> Maybe I can post the data show of the unit later after I get the comple=
te data.
>

Hi Andrew & Conor,

Sorry, haven't updated in a while.
I just got the detailed data of Driver Strength(DS) from Motorcomm , whic=
h applies to both rx_clk and rx_data.

|----------------------|
|     ds map table     |
|----------------------|
| DS(3b) | Current (mA)|
|--------|-------------|
|   000  |     1.20    |
|   001  |     2.10    |
|   010  |     2.70    |
|   011  |     2.91    |
|   100  |     3.11    |
|   101  |     3.60    |
|   110  |     3.97    |
|   111  |     4.35    |
|--------|-------------|

Since these currents are not integer values and have no regularity, it is=
 not very good to use in the drive/dts in my opinion.

Therefore, I tend to continue to use DS(0-7) in dts/driver, and adding a =
description of the current value corresponding to DS in dt-bindings.=20

Like This:

+  motorcomm,rx-clk-driver-strength:
+    description: drive strength of rx_clk pad.
+      |----------------------|
+      | rx_clk ds map table  |
+      |----------------------|
+      | DS(3b) | Current (mA)|
+      |   000  |     1.20    |
+      |   001  |     2.10    |
+      |   010  |     2.70    |
+      |   011  |     2.91    |
+      |   100  |     3.11    |
+      |   101  |     3.60    |
+      |   110  |     3.97    |
+      |   111  |     4.35    |
+      |--------|-------------|
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
+    default: 3
+
+  motorcomm,rx-data-driver-strength:
+    description: drive strength of rx_data/rx_ctl rgmii pad.
+      |----------------------|
+      | rx_data ds map table |
+      |----------------------|
+      | DS(3b) | Current (mA)|
+      |   000  |     1.20    |
+      |   001  |     2.10    |
+      |   010  |     2.70    |
+      |   011  |     2.91    |
+      |   100  |     3.11    |
+      |   101  |     3.60    |
+      |   110  |     3.97    |
+      |   111  |     4.35    |
+      |--------|-------------|
+    $ref: /schemas/types.yaml#/definitions/uint32
+    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
+    default: 3
+


Or use minimum & maximum instead of these listed out enums(Suggested by C=
onor)

+  motorcomm,rx-clk-driver-strength:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 3
+    minimum: 0
+    maximum: 7
+    description: drive strength of rx_clk pad.
+      |----------------------|
+      | rx_clk ds map table  |
+      |----------------------|
+      | DS(3b) | Current (mA)|
+      |   000  |     1.20    |
+      |   001  |     2.10    |
+      |   010  |     2.70    |
+      |   011  |     2.91    |
+      |   100  |     3.11    |
+      |   101  |     3.60    |
+      |   110  |     3.97    |
+      |   111  |     4.35    |
+      |--------|-------------|
+
+  motorcomm,rx-data-driver-strength:
+    $ref: /schemas/types.yaml#/definitions/uint32
+    default: 3
+    minimum: 0
+    maximum: 7
+    description: drive strength of rx_data/rx_ctl rgmii pad.
+      |----------------------|
+      | rx_data ds map table |
+      |----------------------|
+      | DS(3b) | Current (mA)|
+      |   000  |     1.20    |
+      |   001  |     2.10    |
+      |   010  |     2.70    |
+      |   011  |     2.91    |
+      |   100  |     3.11    |
+      |   101  |     3.60    |
+      |   110  |     3.97    |
+      |   111  |     4.35    |
+      |--------|-------------|
+


Looking forward to your suggestions.


Best regards,
Samin

>=20
>=20
>> This information should go into the binding, not sit in a thread on a
>> mailing list that noone will look at when trying to write a DT :(
>>
>> Thanks,
>> Conor.
>>
>=20
> Yes=EF=BC=8Cwhen we have the complete 'unit' data, it will be placed in=
 DT.
>=20
> Best regards,
> Samin
> =20
>>> +    default: 3
>>> +
>>> +  motorcomm,rx-data-driver-strength:
>>> +    description: drive strength of rx_data/rx_ctl rgmii pad.
>>> +    $ref: /schemas/types.yaml#/definitions/uint32
>>> +    enum: [ 0, 1, 2, 3, 4, 5, 6, 7 ]
>>> +    default: 3
>>> +
>>>    motorcomm,tx-clk-adj-enabled:
>>>      description: |
>>>        This configuration is mainly to adapt to VF2 with JH7110 SoC.
>>> --=20
>>> 2.17.1
>>>

