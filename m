Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45AE31167D6
	for <lists+netdev@lfdr.de>; Mon,  9 Dec 2019 08:58:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727160AbfLIH6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 02:58:12 -0500
Received: from mail-eopbgr70111.outbound.protection.outlook.com ([40.107.7.111]:42310
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727329AbfLIH6M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 9 Dec 2019 02:58:12 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ikoRh7GTzH9bZGsa3WMc+O+8p6CttGLGnXGTu4lHuxYTuQpwn9hWy6/mjM0vfaPyA7b/VGExb9HraMIvUAtNEgB+/Q5GqwzBZzEQ7T5QMNQyDX39uPLMc6AxRBxb+M2jGMfn+yRuoGTlRulWUe/dALtHheT8MtRx0BMxYezvVDV1vYDco2rk4nMcVqmSJFl6sK9bY1+NYBM373khDpEtyawF9RNMS5yD5+lynrdDw71pOxzNPZL2q0M9oaP5uNPz94UW5ChiPyCgfiH/giqRCbd7KVxRiBUidrEpIUOZiiJ7klmPqW677KHTHH3T2g7giqh+ge3JHFpcqLQEGnTIZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVKCW3Iw4ZfwYsnR9fSmHSC/6RSX5DXMJPkNgogmuOQ=;
 b=n1C0HSekyOrY3Gz/1oW4nUrKW5VtwF+X0WxNK0ueY0D3EWF0vJpDSppa4z8upFYo9gPXw5glwFqtsAErhBYUQinjYAsah7Xp4wNZgHzybjlsmVUyx3YLgtfZb0enyHXvKSH6b+V+jnBjCGMHp7zA1B1fS2TMgv8VDBBnAci3Se/quYQ4vZY6kK4etgycooaToVvzQqKRQP/lftSSgQ2mxGjrwq5cxzeajC/W3VsJx2ByWSNOldJ4nDQyDqu7ydI+MuahYMU1omb+W+5mLkWNFhPZH9/MjpTtowJXs4UluKL70EKWPNP+PzLO0f2CthoY0zjxG+KrR+yMmifZfuOptA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=CVKCW3Iw4ZfwYsnR9fSmHSC/6RSX5DXMJPkNgogmuOQ=;
 b=CyFY+2cDhI2KXPpq9iFZBvO8ktHrjGxx2u7rTwazSlaTfrG5m5XrUcTi2P3O8I5an+4kkkva1NGApl0rGsd7ltt1gGTnE9tkJk+JT/HhV+6Hf4q6nNSK0+qI4b0VvrwMEY3yOYwGeaSzY626Xt9mkQhZ2FfZF4Z45689K4BwEPM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB5360.eurprd07.prod.outlook.com (20.178.11.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.6; Mon, 9 Dec 2019 07:57:26 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::780c:216f:7598:e572]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::780c:216f:7598:e572%6]) with mapi id 15.20.2538.012; Mon, 9 Dec 2019
 07:57:25 +0000
Subject: Re: net: dsa: mv88e6xxx: error parsing ethernet node from dts
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rasmus.villemoes@prevas.dk,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        vivien.didelot@gmail.com,
        =?UTF-8?Q?Antoine_T=c3=a9nart?= <antoine.tenart@bootlin.com>
References: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
 <20191204153804.GD21904@lunn.ch>
 <ccf9c80e-83e5-d207-8d09-1819cfb1cf35@televic.com>
 <20191204171336.GF21904@lunn.ch>
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
Message-ID: <5851b137-2a3f-f8b3-cd0a-6efc2b7df67d@televic.com>
Date:   Mon, 9 Dec 2019 08:57:24 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20191204171336.GF21904@lunn.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR0402CA0010.eurprd04.prod.outlook.com
 (2603:10a6:208:15::23) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [10.40.216.140] (84.199.255.188) by AM0PR0402CA0010.eurprd04.prod.outlook.com (2603:10a6:208:15::23) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Mon, 9 Dec 2019 07:57:25 +0000
X-Originating-IP: [84.199.255.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 908f3501-e85a-4666-312a-08d77c7d6e28
X-MS-TrafficTypeDiagnostic: VI1PR07MB5360:
X-Microsoft-Antispam-PRVS: <VI1PR07MB5360CD5174E3C582BBEFE1AFFF580@VI1PR07MB5360.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 02462830BE
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(39840400004)(346002)(376002)(136003)(366004)(189003)(199004)(305945005)(8676002)(81166006)(81156014)(50466002)(66556008)(66476007)(66946007)(5660300002)(65956001)(36756003)(2870700001)(2906002)(6486002)(31686004)(478600001)(6916009)(229853002)(66574012)(316002)(86362001)(52116002)(53546011)(956004)(186003)(58126008)(16526019)(2616005)(54906003)(31696002)(16576012)(4326008)(26005)(8936002)(76176011);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB5360;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tJtSYmjM7MXHRVUOV9BrkyAlIWAvyWUIrDNKdMLk00LhE56FLkSZ2YAv6oFFE5CNPC1Mk6oY3wdQ1OXekZNDqVtyExCQ4MkQWmM/Lx6FQMju9ue6lPUX8jryjhRB2U8MpL7IYVBqRGIiCkBpBQsBtcoz/QgVgJCAEOsSMzgsb+ydW6/VtSM7KQyztNm6dVr2JsdSnmNW3Qfwkpt5s45rvfMlWSzBQAIqlimi/QI/Nhjd4eP0ql8J8njV+4i+K7si6MeAvT10pnlA8v7uWnw7lmbHXzOZyz3R6atzFS9WSDxk1FLJkEnP6Y1bIZN4E4UDZFic8nrBZLC6OBUAaaoY2SRI5tAqgJZDqinM9vzxyhLKJN+TTq7PhyJlMe92pA6Amb928KL80ZNhQBOonw0Cb3itFr2rn8M2HBiiaIs8HTzhYA0auY4ZTZevcmgYRjiu
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 908f3501-e85a-4666-312a-08d77c7d6e28
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Dec 2019 07:57:25.9057
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: tzStYYqEZqlA+wY8OGWVvd48J8/nH0XiY9xRjvwhl+UIzOMXViyJZGCbzyLgqpd03meOylkudyItBlctuVoY/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB5360
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/19 6:13 PM, Andrew Lunn wrote:
> CAUTION: This Email originated from outside Televic. Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
>
> On Wed, Dec 04, 2019 at 05:20:04PM +0100, Jürgen Lambrecht wrote:
>> On 12/4/19 4:38 PM, Andrew Lunn wrote:
>>>> Here parts of dmesg (no error reported):
>>>>
>>>> [    1.992342] libphy: Fixed MDIO Bus: probed
>>>> [    2.009532] pps pps0: new PPS source ptp0
>>>> [    2.014387] libphy: fec_enet_mii_bus: probed
>>>> [    2.017159] mv88e6085 2188000.ethernet-1:00: switch 0x710 detected: Marvell 88E6071, revision 5
>>>> [    2.125616] libphy: mv88e6xxx SMI: probed
>>>> [    2.134450] fec 2188000.ethernet eth0: registered PHC device 0
>>>> ...
>>>> [   11.366359] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
>>>> [   11.366722] fec 2188000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
>>>>
>>>> When I enable debugging in the source code, I see that mv88e6xxx_probe() fails, because *'of_find_net_device_by_node(ethernet);'* fails. But why?,
>>> That always happens the first time. There is a chicken/egg
>>> problem. The MDIO bus is registered by the FEC driver, the switch is
>>> probed, and the DSA core looks for the ethernet interface. But the FEC
>>> driver has not yet registered the interface, it is still busy
>>> registering the MDIO bus. So you get an EPRODE_DEFFER from the switch
>>> probe. The FEC then completes its probe, registering the
>>> interface. Sometime later Linux retries the switch probe, and this
>>> time it works.
>>>
>>> What you are seeing here is the first attempt. There should be a
>>> second go later in the log.
>>>
>>>        Andrew
>> Indeed, but that also fails because this second time, reading the
>> switch ID (macreg 3 at addr 8) fails, it returns 0x0000!??
> So this is the real problem.
>
> Try removing the reset GPIO line from DT. If there is an EEPROM, and
> the EEPROM contains a lot of instructions, we have seen it take a long
> time to reset, load the EEPROM, and then start responding on the MDIO
> bus. If you take away the GPIO, it will only do a software reset,
> which is much faster. Even if you don't have an EEPROM, it is worth a
> try.
No didn't help
>
> But returning 0x0000 is odd. Normally, if an MDIO device does not
> respond, you read 0xffff, because of the pull up resistor on the bus.
Indeed
>
> The fact you find it once means it is something like this, some minor
> configuration problem, power management, etc.
>
>          Andrew

Thanks. I will have to look further in that direction. There must be sth obvious that I don't see.

A strange thing to me however is why - in my dts and in vf610-zii-ssmb-spu3.dts - there is 2 times a 'fixed-link' declaration? Moreover, when I omit the first declaration, the kernel crashes (oops).

I have the impression the first 'fixed-link' is used at the end of booting (at 11s, see first email) to configure the kernel in a fixed-phy configuration without a switch in between - and maybe that is the obvious that I don't see: why that fixed-phy config happens there, and even more, why does the kernel crash if it cannot config when I omit the info from dts?

I checked the kernel menuconfig, and there are fixed-phy configs enabled, but I cannot disable them, because they are selected by the DSA and freescale configs:

FIXED_PHY <= OF_MDIO [=y] && OF [=y] && PHYLIB [=y]
  PHYLIB <= FEC ... & ARCH_MXC
         <= PHYLINK && NETDEVICES
              PHYLINK <= NET_DSA && NET && HAVE_NET_DSA

Kind regards,

Jürgen


