Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D77F112FDB
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 17:20:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728629AbfLDQUK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Dec 2019 11:20:10 -0500
Received: from mail-eopbgr00112.outbound.protection.outlook.com ([40.107.0.112]:4486
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727008AbfLDQUJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Dec 2019 11:20:09 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZV+0OjINrNyU2lna73spVh5wPv3W5gylpGSlDmkrH/hsicNwJxXG2RwKitZmLc1khDcqbyatZ5RXz6MeVn2/kTg7FcjLoH+UXFUpmnQaiFMSqpqzccMqzUPNQSWu+Ye4l6vZLnavHaY5mIjHACtv7gUjzHVSRQFAJfwDUMNIoDm/7kd7NM3vuLilz7HBaG5JcvRE+DmyWe/t1rjabCfJOtKOEARDd9LVyCTqNmKUKExggRfplABBIhDlkyR94oLtIlsJqOJ9jD/jTdI0ItjU9NoH2uqPvN+RAcjOkWIepHP+az+MM4/56Fy139Hye6xLWaafcsrLsavk1xfah9kG/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmLEAIKGH3jIQx77sL+LCiGPDd4a/fKM3/DI+wX3UmI=;
 b=jSOu+6h/JFAxi9XTxOhr/2ZB+PtJGnNv9jVqMDU/j5Pv/gYBOTyvIyNhx9pKNJjuM11cLnB1U4Wf6XOjeT9v2hJh6+N1WJZ9kW7DCzROP8U7FiLwAKi/iInTVHMptIcwtBjZyZR7JPPZv+PE009v7SX08U1CVJxr0j53gKv0BMp8f5xQ7Fi1CRFA2ZKv1QWzMev2WpNC6Ki+0cFGxK6T8eIfCzom5N0Sa+O0VBMAcJMEyQUZM7NMtuC0xwJpBtu/LR+5yvqYWqTz19bFYLL+WFhzoLGMwrld52kLQTvsRRlT+DJl1rRyt5coeP0/XgCII+wGbxn57AnP05X1///rzw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UmLEAIKGH3jIQx77sL+LCiGPDd4a/fKM3/DI+wX3UmI=;
 b=NKTSQanidF84wgInEhgr9oUZIv8K4B/Xq9URFIZlaBb34IZrsbdaZdKpvqROc7PqKimtbub3y1vQaxz/oHZO//45nKXVqI76JaI2VgdP9jULj2CTLRwTciQc3ZTt0tFxSVVM0KITzKsw7P7izd8Y3BIFUaoSsjaz874gxL0sjb0=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB4655.eurprd07.prod.outlook.com (20.177.57.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.6; Wed, 4 Dec 2019 16:20:06 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::1512:231a:ef92:4af0]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::1512:231a:ef92:4af0%5]) with mapi id 15.20.2516.003; Wed, 4 Dec 2019
 16:20:06 +0000
Subject: Re: net: dsa: mv88e6xxx: error parsing ethernet node from dts
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rasmus.villemoes@prevas.dk,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        vivien.didelot@gmail.com
References: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
 <20191204153804.GD21904@lunn.ch>
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
Message-ID: <ccf9c80e-83e5-d207-8d09-1819cfb1cf35@televic.com>
Date:   Wed, 4 Dec 2019 17:20:04 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
In-Reply-To: <20191204153804.GD21904@lunn.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM4PR0101CA0084.eurprd01.prod.exchangelabs.com
 (2603:10a6:200:41::52) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [IPv6:2a02:1811:b219:a500:baca:3aff:fed1:9b] (2a02:1811:b219:a500:baca:3aff:fed1:9b) by AM4PR0101CA0084.eurprd01.prod.exchangelabs.com (2603:10a6:200:41::52) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Wed, 4 Dec 2019 16:20:05 +0000
X-Originating-IP: [2a02:1811:b219:a500:baca:3aff:fed1:9b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c5b6eefe-135f-4b57-05c1-08d778d5d311
X-MS-TrafficTypeDiagnostic: VI1PR07MB4655:
X-Microsoft-Antispam-PRVS: <VI1PR07MB4655668C2D98B375F6A47E67FF5D0@VI1PR07MB4655.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0241D5F98C
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(346002)(366004)(376002)(396003)(136003)(39850400004)(189003)(199004)(5660300002)(50466002)(229853002)(8936002)(76176011)(6486002)(8676002)(478600001)(22746008)(66574012)(23746002)(52116002)(2616005)(11346002)(6436002)(36756003)(81156014)(31696002)(6116002)(86362001)(7736002)(14444005)(5024004)(66476007)(65956001)(66946007)(305945005)(6246003)(31686004)(66556008)(4326008)(25786009)(316002)(6916009)(81166006)(54906003)(53546011)(58126008)(2906002)(2870700001)(186003)(16526019);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB4655;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SszZr/pFgZg6LYapQ38LMlHeq69J//MnRq8ZiZ+KEY6p7+7lfa/q9DD6x5eSoSC2S/aieeATKxVPvq4ZRiSsYZjZizhABCbzpz8TVIJyzo6AaWlCDU3yaqS9vmlxkMuvjrUeJ0hAzmJNRGfqGFabiRLeXCACrOmvlJ+3LXEFM3oBAnn7GRHiWf4K20pxmDqVN4fYRhhfItGT+38jTtTszNzbPxsjlsuK3pXnxhIEQouZ3IjZuvxiwMvb2VaefnIG7g7fZVWDWIigTF6nbY0eOt0c1hpWQpRrve7t5phCUvvJMZwTq2K7LkHUcme40W05V29yiY+Asw714aZZu/dTbUc814GBMVDRivv/Uw7CBl46XeirAahlE2zz5NdEg8g0G7/uBZRKAUlsPios5cmIutEPIm4aKrMKgvqCXXWjYztvIPSzvaDUWoX3d6LLpgOT
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c5b6eefe-135f-4b57-05c1-08d778d5d311
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Dec 2019 16:20:06.2069
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SGt4Mn5O+CRAkHhhEUuT+lyxpphGz7VWU7HTgmspf8kutFhUJTJxk5dI5O/tSDS/zUYLvsH6rszAsCBxHvTggQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB4655
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/4/19 4:38 PM, Andrew Lunn wrote:
>> Here parts of dmesg (no error reported):
>>
>> [    1.992342] libphy: Fixed MDIO Bus: probed
>> [    2.009532] pps pps0: new PPS source ptp0
>> [    2.014387] libphy: fec_enet_mii_bus: probed
>> [    2.017159] mv88e6085 2188000.ethernet-1:00: switch 0x710 detected: Marvell 88E6071, revision 5
>> [    2.125616] libphy: mv88e6xxx SMI: probed
>> [    2.134450] fec 2188000.ethernet eth0: registered PHC device 0
>> ...
>> [   11.366359] Generic PHY fixed-0:00: attached PHY driver [Generic PHY] (mii_bus:phy_addr=fixed-0:00, irq=POLL)
>> [   11.366722] fec 2188000.ethernet eth0: Link is Up - 100Mbps/Full - flow control off
>>
>> When I enable debugging in the source code, I see that mv88e6xxx_probe() fails, because *'of_find_net_device_by_node(ethernet);'* fails. But why?,
> That always happens the first time. There is a chicken/egg
> problem. The MDIO bus is registered by the FEC driver, the switch is
> probed, and the DSA core looks for the ethernet interface. But the FEC
> driver has not yet registered the interface, it is still busy
> registering the MDIO bus. So you get an EPRODE_DEFFER from the switch
> probe. The FEC then completes its probe, registering the
> interface. Sometime later Linux retries the switch probe, and this
> time it works.
>
> What you are seeing here is the first attempt. There should be a
> second go later in the log.
>
>        Andrew

Indeed, but that also fails because this second time, reading the switch ID (macreg 3 at addr 8) fails, it returns 0x0000!??

Last register read/write was 800ms before, disabling interrupts.

Shortly after the first ID read (that succeeded 1 second before), all MAC ports have been disabled (macreg 4, PortState from forwarding to disabled). But that should have no influence on reading the ID. FYI, The switch is configured in CPU attached mode.

Any ideas?

Tomorrow I will try to run a user-space program to read/write the registers.

Thanks a lot for clarifying this,

Jürgen

