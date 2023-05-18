Return-Path: <netdev+bounces-3532-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 52F0D707C0E
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 10:30:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 73179280D87
	for <lists+netdev@lfdr.de>; Thu, 18 May 2023 08:30:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B743DAD46;
	Thu, 18 May 2023 08:30:09 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A505EAD42
	for <netdev@vger.kernel.org>; Thu, 18 May 2023 08:30:09 +0000 (UTC)
Received: from fd01.gateway.ufhost.com (fd01.gateway.ufhost.com [61.152.239.71])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F92D198A;
	Thu, 18 May 2023 01:30:06 -0700 (PDT)
Received: from EXMBX165.cuchost.com (unknown [175.102.18.54])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(Client CN "EXMBX165", Issuer "EXMBX165" (not verified))
	by fd01.gateway.ufhost.com (Postfix) with ESMTP id 3F3347FFD;
	Thu, 18 May 2023 16:29:58 +0800 (CST)
Received: from EXMBX062.cuchost.com (172.16.6.62) by EXMBX165.cuchost.com
 (172.16.6.75) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 18 May
 2023 16:29:58 +0800
Received: from [192.168.120.43] (171.223.208.138) by EXMBX062.cuchost.com
 (172.16.6.62) with Microsoft SMTP Server (TLS) id 15.0.1497.42; Thu, 18 May
 2023 16:29:57 +0800
Message-ID: <492b3874-7fcd-f7c1-bbe1-594c2d795854@starfivetech.com>
Date: Thu, 18 May 2023 16:29:55 +0800
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v2 2/2] net: phy: motorcomm: Add pad drive strength cfg
 support
Content-Language: en-US
From: Guo Samin <samin.guo@starfivetech.com>
To: Andrew Lunn <andrew@lunn.ch>
CC: <linux-kernel@vger.kernel.org>, <devicetree@vger.kernel.org>,
	<netdev@vger.kernel.org>, Peter Geis <pgwipeout@gmail.com>, Frank
	<Frank.Sae@motor-comm.com>, "David S . Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni
	<pabeni@redhat.com>, Rob Herring <robh+dt@kernel.org>, Krzysztof Kozlowski
	<krzysztof.kozlowski+dt@linaro.org>, Heiner Kallweit <hkallweit1@gmail.com>,
	Russell King <linux@armlinux.org.uk>, Yanhong Wang
	<yanhong.wang@starfivetech.com>
References: <20230505090558.2355-1-samin.guo@starfivetech.com>
 <20230505090558.2355-3-samin.guo@starfivetech.com>
 <fc516e65-cde2-4a65-a3c5-bd8c939e7eb1@lunn.ch>
 <f2b54fc5-81a6-45ae-0218-193a993333ab@starfivetech.com>
In-Reply-To: <f2b54fc5-81a6-45ae-0218-193a993333ab@starfivetech.com>
Content-Type: text/plain; charset="UTF-8"
X-Originating-IP: [171.223.208.138]
X-ClientProxiedBy: EXCAS064.cuchost.com (172.16.6.24) To EXMBX062.cuchost.com
 (172.16.6.62)
X-YovoleRuleAgent: yovoleflag
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,NICE_REPLY_A,
	SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Re: [PATCH v2 2/2] net: phy: motorcomm: Add pad drive strength cfg suppor=
t
From: Guo Samin <samin.guo@starfivetech.com>
to: Andrew Lunn <andrew@lunn.ch>
data: 2023/5/6

>=20
> Re: [PATCH v2 2/2] net: phy: motorcomm: Add pad drive strength cfg supp=
ort
> From: Andrew Lunn <andrew@lunn.ch>
> to: Samin Guo <samin.guo@starfivetech.com>
> data: 2023/5/5
>=20
>>>  #define YTPHY_DTS_OUTPUT_CLK_DIS		0
>>> @@ -1495,6 +1504,7 @@ static int yt8531_config_init(struct phy_device=
 *phydev)
>>>  {
>>>  	struct device_node *node =3D phydev->mdio.dev.of_node;
>>>  	int ret;
>>> +	u32 ds, val;
>>
>> Reverse Christmas tree.  Sort these longest first, shortest last.
>>
> Thanks, will fix.
>> Otherwise this looks O.K.
>>
>> The only open question is if real unit should be used, uA, not some
>> magic numbers. Lets see what the DT Maintainers say.
>>
>>       Andrew
>=20
> Hi Andrew,
>=20
> As I communicated with Frank, Motorcomm doesn't give specific units on =
their datasheet, except for magic numbers.
> Tried to ask Motorcomm last week, but it seems that they themselves do =
not know what the unit is and have no response so far.
>=20
>=20
> Below is all the relevant information I found=EF=BC=9A
>=20
> Pad Drive Strength Cfg (EXT_0xA010)
>=20
> Bit   |  Symbol           |  Access |  Default |  Description
> 15:13 |  Rgmii_sw_dr_rx   |  RW     |  0x3     |  Drive strenght of rx_=
clk pad.
>                                                |  3'b111: strongest; 3'=
b000: weakest.
>=20
> 12    |  Rgmii_sw_dr[2]   |  RW     |  0x0     |  Bit 2 of Rgmii_sw_dr[=
2:0], refer to ext A010[5:4]
>=20
> 5:4   |  Rgmii_sw_dr[1:0] |  RW     |  0x3     |  Bit 1 and 0 of Rgmii_=
sw_dr, Drive strenght of rxd/rx_ctl rgmii pad.
>                                                |  3'b111: strongest; 3'=
b000: weakest
>=20
>=20
>=20
> Best regards,
> Samin

Hi Andrew,

We tried contacting motorcomm again, but so far we haven't been able to g=
et any more information about unit.
Also, I found a similar configuration in Documentation/devicetree/binding=
s/net/qca,ar803x.yaml, and they also
used the 'magic numbers':

  qca,clk-out-strength:
    description: Clock output driver strength.
    $ref: /schemas/types.yaml#/definitions/uint32
    enum: [0, 1, 2]


Best regards,
Samin

