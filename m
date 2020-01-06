Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC12130DE0
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 08:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgAFHLc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 02:11:32 -0500
Received: from mail-db8eur05on2108.outbound.protection.outlook.com ([40.107.20.108]:9505
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726494AbgAFHLc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jan 2020 02:11:32 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JiCGdGAhffQQTPYpUUDhfizknfczMy54X5XjkXgYajRTi64TZAUjOXGvu80RYIv+yYnm1EUDsHDpl2Xoba0dRIaj/6Ql/iyWV3Hyb70x6wX3LTbLRYJiiyPlMLQCAQQbOwQFx9vGMAjt1uWFe7iKAEvZcL+XpTU1whoQIswEgKYo4S+/PZMfNlOEy1sn+fKD9De3vcR888F4NPUB9slyqj92WeY/y8/szaoft2LktKvIOKyTIE25dY65DAdTxDj0XlcQgyxtk+Hr7pxA0OQ1fDtBS65PWxTEo7biasIywYJtWVOWSJSD9pXIKzNnIv2KkS56K7DGsSTxsHjsbS34vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oF/lTK4CREly8gnMYymeKAiU2NM1wGW0X5Gw0G2hRE=;
 b=lbpTgJiMr+pl27lJOTdtHbCzagQnMY/ONXozSfT/9VWgVcE7Le16FqazK5+iWQwbH5nWs2NVVAaxufBSVF6gGqYPFx3Om/GpV5kedZcbEd3NCnO1gv7o7XI+9KLSnjgXruZzNDqLdF1XDiDUPNIx8hcuSn9yJFSRyj/o8usCVfqRaENWBBGOZCejXRe2Qr88XgbhjLu1TEvXcukfdRkLHls4f6FKW8Olh9HlEwHqZT3CkAwi/WTh48dDLCxaR1Uz5DdTS/OuEGIxSdGIeXGoB0CvhqnvmqYyY4RJWgT/bAd+1djnjb8DTlHSUBYr3BVKvvxp3FBU0UkIdiStOWLxRg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5oF/lTK4CREly8gnMYymeKAiU2NM1wGW0X5Gw0G2hRE=;
 b=QXxzpIKb8h8sXAL/xRJ1HDMnoGsvGi5eipQuPw8KS6b9grzdmrFGjdeqL5oTXB78WmERZdbIS7NjVZTfMtUjXB/j9bELQHrUyE5WM3XQkAVG34klhhiFqjFlPmtklmsW/T/1gUCwO/PWmbE/C20KQTetJ1PKx7Z9gnZBaqLllMk=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB4733.eurprd07.prod.outlook.com (20.177.56.96) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.7; Mon, 6 Jan 2020 07:11:27 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349%5]) with mapi id 15.20.2623.008; Mon, 6 Jan 2020
 07:11:27 +0000
Subject: Re: net: dsa: mv88e6xxx: error parsing ethernet node from dts
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rasmus.villemoes@prevas.dk,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        vivien.didelot@gmail.com, Pieter Cardoen <P.Cardoen@TELEVIC.com>
References: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
 <20191204153804.GD21904@lunn.ch>
 <ccf9c80e-83e5-d207-8d09-1819cfb1cf35@televic.com>
 <20191204171336.GF21904@lunn.ch>
 <c03b1cc5-d5a9-980c-e615-af5b821b500d@televic.com>
 <20191224111929.GD3395@lunn.ch>
 <307c4626-6ea3-39f2-fb34-ba8d9810f905@televic.com>
Message-ID: <b69cfda2-5e70-3bf9-fb48-cfea1f9629dd@televic.com>
Date:   Mon, 6 Jan 2020 08:11:25 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
In-Reply-To: <307c4626-6ea3-39f2-fb34-ba8d9810f905@televic.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM3PR03CA0056.eurprd03.prod.outlook.com
 (2603:10a6:207:5::14) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [10.40.216.140] (84.199.255.188) by AM3PR03CA0056.eurprd03.prod.outlook.com (2603:10a6:207:5::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2602.10 via Frontend Transport; Mon, 6 Jan 2020 07:11:26 +0000
X-Originating-IP: [84.199.255.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4ddd6b85-ca51-4012-7229-08d79277a576
X-MS-TrafficTypeDiagnostic: VI1PR07MB4733:|VI1PR07MB4733:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR07MB4733D063CD53DB6ECEEA1E48FF3C0@VI1PR07MB4733.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-Forefront-PRVS: 0274272F87
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(366004)(136003)(346002)(376002)(39840400004)(189003)(199004)(66574012)(66556008)(66476007)(66946007)(6916009)(31686004)(8936002)(5660300002)(107886003)(6486002)(4326008)(8676002)(81166006)(81156014)(478600001)(52116002)(31696002)(26005)(53546011)(86362001)(36756003)(2906002)(16576012)(316002)(956004)(186003)(16526019)(54906003)(2616005);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB4733;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sJADZckj3qDs4gHtoiMjkG5x6lCmWvm+ElWTBVVx5VSM/Hxi2Hx4IkUijJw+wc6h4yxxVmWk4o0WeIk12NS/1veFJ/oRgG4K+E4itJY3N27mXlpASa/0cVQ1VsHX2Lqz4yr6IeRZ1gHvc4wqarTY8lukJq9jiSLoVo5Q884TLv+Lb63S/uDht1xY0ecsAJ6opmFVZCjgjaInTnLHo/xLJ1bgZgyuFgd0OPeL6BDxRIS2KAB8SVRzX3jJBe2qC9NTtKg8s9rWrpR7oy15/moWZLI8bQt9ztoeg007cz9cS6nlL20iPCvQiJCxwDi2waT65p+bZYywm/dz2T877013+8W2L6iXioDjlAqph4IenGWbr+MyPJqZEw03IYOnvU6wtquPssWDiyQd+FSY2/fWscv8h9tt71dO9opTcrbpo9SYKxQzP2WvvazEtttxaXTY
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4ddd6b85-ca51-4012-7229-08d79277a576
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Jan 2020 07:11:27.3809
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: p285BRg9zOxN0Lkz+G28l5M3Ee1ZFwb7F84AN1LM4s7YuONfM9P3o7TuSVQ7g8ONJ4n5c8AYFZl7S8tAdM+Zxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB4733
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/24/19 2:57 PM, Jürgen Lambrecht wrote:
> CAUTION: This Email originated from outside Televic. Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
>
> On 12/24/19 12:19 PM, Andrew Lunn wrote:
>> CAUTION: This Email originated from outside Televic. Do not click links or open attachments unless you recognize the sender and know the content is safe.
>>
>>
>> On Tue, Dec 24, 2019 at 11:28:27AM +0100, Jürgen Lambrecht wrote:
>>> On 12/4/19 6:13 PM, Andrew Lunn wrote:
>>>> But returning 0x0000 is odd. Normally, if an MDIO device does not
>>>> respond, you read 0xffff, because of the pull up resistor on the bus.
>>>>
>>>> The fact you find it ones means it is something like this, some minor
>>>> configuration problem, power management, etc.
>>> Hi Adrew,
>>>
>>> to close this issue: you were right: the Marvell clock, that comes from the iMX clocking block ENET1_REF_CLK_25M suddenly stops running:
>>>
>>> an oscilloscope showed that the Marvell main clock stops shortly after the first probe, and only comes back 5s later at the end of booting when the fixed-phy is configured.
>>> It is not the fec that stops the clock, because if fec1 is "disabled" also the clock stops, but then does not come back.
>>>
>>> We did not found yet how to keep the clock enabled (independent of the fec), so if you have any hints - more than welcome.
>> Let me make sure i understand your design correct.
>>
>> I think you are saying your switch does not have a crystal connected
>> to XTAL_OUT/XTAL_IN. Instead you want the iMX to generate a 25MHz
>> clock, which you are feeding to the switch?
> indeed.
>> All the designs i've used have the crystal connected to the
>> switch. The FEC clock line is used as an input, either driven from a
>> PHY connected to the other FEC port, or the clock output from the
>> switch.
>>
>> So for your design, you need to ensure the 25MHz clock output is
>> always ticking. Looking at the FEC driver, you see the optional clock
>> fep->clk_enet_out. This clock is enabled when the FEC interface is
>> opened, i.e. configured up. It is disabled when the FEC is closed. It
>> is enabled during probe, but turned off at the end of the probe to
>> save power. The FEC also has runtime suspend/resume support. This
>> actually does not touch the clk_enet_out, but it does enable/disable
>> clocks needed for MDIO to work. I had to fix this many years ago.

You mean you added then the code that touches clk_enet_out: 'ret = clk_prepare_enable(fep->clk_enet_out);' and 'clk_disable_unprepare(fep->clk_enet_out);' ?

For the PHY, this can be the PHY chip clock, so it must be running for MDIO to work.
(and for us it is the switch clock)

>>
>> It appears this clock is just a plain SOC clock.
>>
>> In imx7d.dtsi we see:
>>
>>                 clocks = <&clks IMX7D_ENET2_IPG_ROOT_CLK>,
>>                         <&clks IMX7D_ENET_AXI_ROOT_CLK>,
>>                         <&clks IMX7D_ENET2_TIME_ROOT_CLK>,
>>                         <&clks IMX7D_PLL_ENET_MAIN_125M_CLK>,
>>                         <&clks IMX7D_ENET_PHY_REF_ROOT_CLK>;
>>                 clock-names = "ipg", "ahb", "ptp",
>>                         "enet_clk_ref", "enet_out";
>>
>> The mapping between clock-names and clocks seem a bit odd. But there
>> is some room for error here, since the FEC driver mostly just enables
>> them all or disables them all. But you need one specific clock.
>>
>> What i suggest you do is add clock support to DSA. Allow DSA to look
>> up a clock in DT, and call clk_prepare_enable() and
>> clk_disable_unprepare(). The clock framework uses reference
>> counting. So if DSA turns a clock on, it does not matter what the FEC
>> does, it will stay on. It will only go off when all users of the clock
>> turn it off.
>>
>> I'm not sure if this can be done in a generic way for all DSA drivers,
>> or if you need to add it to the mv88e6xxx driver. The DSA core only
>> gets involved once the probe of the switch is over. And you probably
>> need the clock reliably ticking during probe. So maybe it needs to be
>> in the mv88e6xxx driver.

We could do that, but actually, we prefer that the master clock of the switch chip is running always, independently of any kernel code.

So we would like to add support to be able to specify in DTS a clock output that should be always running. Because on our board that Ethernet clock output of the iMX6 is used to clock the switch, but it could also be used to clock any other chip that needs 25MHz.
We already tested such a driver and it works fine now.
What do you think?

I would then send a patch proposal to the arm mailing list.

(FYI: it has no use to remove that clock from the fec1 entry in imx6ul.dtsi, because then (after a patch) the clock is not touched anymore, but the power-management puts the clocking block in power-down when MDIO finishes and its clock is turned off, but the same block generates several clocks, so it is not possible to ignore the kernel because the bootloader already enables the clock.)

Kind regards,

Jürgen

