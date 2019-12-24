Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E04C412A1E0
	for <lists+netdev@lfdr.de>; Tue, 24 Dec 2019 14:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfLXN5R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Dec 2019 08:57:17 -0500
Received: from mail-eopbgr00091.outbound.protection.outlook.com ([40.107.0.91]:8163
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726178AbfLXN5Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Dec 2019 08:57:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P7+KXSjmwp3P93lxow93uhao+mUHRTEFnbshEqJLiet1Wz2eHJSOaHO/wHJ2OSRIp0WWMmPWHUxXWCr2Zho9z5JClsXBL+4ilZtQaer2fhS3SmMBKUfWILn+ur0QWm4CyrGQGFr8cPq2ZvficVSEzT8RSuujqdrFp91n0ne1ki548T/TOZLLR8MiC1lRBRqpHlf4QVd/tKXoxFnGxNn8JCrAw8TJH4QqOq/kn8auMnWh3jnYfD+9IHj7lzDKgpAww+ag/iBNkNGmzYZnSw0XoVuzkaoS8UdYwpalW6g+5uifizr9ORY5eVSIiizq8UW2PAKJ2xfErOYv31FfHs0PvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tv3KeHZN/6uVmqEiJkprPztze6wLHKOY7OhQvDH9vbY=;
 b=m2rFTWIeurdU9GwCwS8KutR9AWxoESyJ/2ai9WfmgfID90bWCxU3WXcbx2HDmrr7PpxVbjz4jTRdygTH40cuCtRP7YnO+S8sjtxuqP+iEKGGBLrawJegNW3yRh+qGBlDfC/9eACyHZyJyaUd+zcY+Ty/Dy0iiaFrTK+P5NXdcv+DFqNRowPWNLCW08rET99caRf/fHJcUlIYG0EgpxT1/iIqt2H2XRgrra4miULCCPNzIXftA4RKjw21gzj8AEpbepL2KwxY3iGFSN6Wm6mmySrDnU8CSp8ra7DDPhDp5pLF3AGiRHWEm72MsEsJerOb4sSNGM8bFB/tQ5ZlXGE0BA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tv3KeHZN/6uVmqEiJkprPztze6wLHKOY7OhQvDH9vbY=;
 b=nzrXic4Bh3rmlRBGQiekfVsNhhKCyVP6ONNtLYfiSDbr6tmk5uMbDYL/ciP7N7vwZEqUQfYqZUOGEFRKuKZsLotHfmaY1nDtth4B7Z2MD/lH6B/LKOQjPSkoE+ytfYSLO5ThtFOCQvLrsuSJwHku7+EMc1NZK6K0BpQcWxHeAZg=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB4320.eurprd07.prod.outlook.com (20.176.6.12) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2581.8; Tue, 24 Dec 2019 13:57:11 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::780c:216f:7598:e572]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::780c:216f:7598:e572%6]) with mapi id 15.20.2581.007; Tue, 24 Dec 2019
 13:57:11 +0000
Subject: Re: net: dsa: mv88e6xxx: error parsing ethernet node from dts
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        rasmus.villemoes@prevas.dk,
        Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
        vivien.didelot@gmail.com
References: <27f65072-f3a1-7a3c-5e9e-0cc86d25ab51@televic.com>
 <20191204153804.GD21904@lunn.ch>
 <ccf9c80e-83e5-d207-8d09-1819cfb1cf35@televic.com>
 <20191204171336.GF21904@lunn.ch>
 <c03b1cc5-d5a9-980c-e615-af5b821b500d@televic.com>
 <20191224111929.GD3395@lunn.ch>
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
Message-ID: <307c4626-6ea3-39f2-fb34-ba8d9810f905@televic.com>
Date:   Tue, 24 Dec 2019 14:57:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
In-Reply-To: <20191224111929.GD3395@lunn.ch>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM0PR06CA0022.eurprd06.prod.outlook.com
 (2603:10a6:208:ab::35) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [IPv6:2a02:1811:b219:a500:baca:3aff:fed1:9b] (2a02:1811:b219:a500:baca:3aff:fed1:9b) by AM0PR06CA0022.eurprd06.prod.outlook.com (2603:10a6:208:ab::35) with Microsoft SMTP Server (version=TLS1_2, cipher=) via Frontend Transport; Tue, 24 Dec 2019 13:57:10 +0000
X-Originating-IP: [2a02:1811:b219:a500:baca:3aff:fed1:9b]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 995fffdd-ef86-463f-5748-08d788792c34
X-MS-TrafficTypeDiagnostic: VI1PR07MB4320:
X-Microsoft-Antispam-PRVS: <VI1PR07MB4320E7184D52A2931F63E681FF290@VI1PR07MB4320.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 0261CCEEDF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39850400004)(346002)(366004)(396003)(136003)(376002)(51914003)(199004)(189003)(16526019)(186003)(53546011)(66476007)(66556008)(2616005)(4326008)(2906002)(81156014)(81166006)(31686004)(36756003)(478600001)(52116002)(86362001)(31696002)(66946007)(6486002)(54906003)(66574012)(8936002)(8676002)(5660300002)(316002)(6916009);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB4320;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: lr7ZVL3pOsSHQdp3Epnx9Z8wT+9kr7IOBZGiS/Fm0024PhtrgOwCVpc68TPixBkLY6EHeIcDTj80DwwGuEB4Ra3qJepH2IU55J6mmJsz++q1llnizR1WvyitP5yZnlvWp9S2AOChbue/SPKQucd3EowefLSvchnSaXcZ8tlU2hthPlIG3LLSU2TEBbTosdaFEUy+curRbBm4Gplsf3I8bed88fFbagbBsJQh4wyUZt9hNyMkd71mIoVt+jji7Olb3HujnGWiWlx6Vo/rVlpPDHr5W4skcpVXeLfmp3zJCwWpCa4fuA2LFtn6b8tOePrBTwJHTDWoXV4PHS9kU3a0qn7jZsbTIjiJPpcvvgT8PpBvboC/oJnS2SmVC+jW2VRcJqvC1MHTCUVDF2+i8RM9aPxa+PQ79ceWQvJz5njREDT1iOk9CdqOfS2OpDjaJdw+HrWXwNhlBDLumgeZSDjXZYQ7Q7L8GDFcF/M6IfJmMTutTqhod0dR0RrnWjsXuO7H
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 995fffdd-ef86-463f-5748-08d788792c34
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Dec 2019 13:57:11.1012
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4wmo6ywjEMDnFXYgRvSbqalRf9WfZ6s7CYWzU8lq33N82po76+wR+smxCoLFiged8nUI/K/12aD84T4912Maug==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB4320
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/24/19 12:19 PM, Andrew Lunn wrote:
> CAUTION: This Email originated from outside Televic. Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
>
> On Tue, Dec 24, 2019 at 11:28:27AM +0100, Jürgen Lambrecht wrote:
>> On 12/4/19 6:13 PM, Andrew Lunn wrote:
>>> But returning 0x0000 is odd. Normally, if an MDIO device does not
>>> respond, you read 0xffff, because of the pull up resistor on the bus.
>>>
>>> The fact you find it ones means it is something like this, some minor
>>> configuration problem, power management, etc.
>> Hi Adrew,
>>
>> to close this issue: you were right: the Marvell clock, that comes from the iMX clocking block ENET1_REF_CLK_25M suddenly stops running:
>>
>> an oscilloscope showed that the Marvell main clock stops shortly after the first probe, and only comes back 5s later at the end of booting when the fixed-phy is configured.
>> It is not the fec that stops the clock, because if fec1 is "disabled" also the clock stops, but then does not come back.
>>
>> We did not found yet how to keep the clock enabled (independent of the fec), so if you have any hints - more than welcome.
> Let me make sure i understand your design correct.
>
> I think you are saying your switch does not have a crystal connected
> to XTAL_OUT/XTAL_IN. Instead you want the iMX to generate a 25MHz
> clock, which you are feeding to the switch?
indeed.
> All the designs i've used have the crystal connected to the
> switch. The FEC clock line is used as an input, either driven from a
> PHY connected to the other FEC port, or the clock output from the
> switch.
>
> So for your design, you need to ensure the 25MHz clock output is
> always ticking. Looking at the FEC driver, you see the optional clock
> fep->clk_enet_out. This clock is enabled when the FEC interface is
> opened, i.e. configured up. It is disabled when the FEC is closed. It
> is enabled during probe, but turned off at the end of the probe to
> save power. The FEC also has runtime suspend/resume support. This
> actually does not touch the clk_enet_out, but it does enable/disable
> clocks needed for MDIO to work. I had to fix this many years ago.
>
> It appears this clock is just a plain SOC clock.
>
> In imx7d.dtsi we see:
>
>                 clocks = <&clks IMX7D_ENET2_IPG_ROOT_CLK>,
>                         <&clks IMX7D_ENET_AXI_ROOT_CLK>,
>                         <&clks IMX7D_ENET2_TIME_ROOT_CLK>,
>                         <&clks IMX7D_PLL_ENET_MAIN_125M_CLK>,
>                         <&clks IMX7D_ENET_PHY_REF_ROOT_CLK>;
>                 clock-names = "ipg", "ahb", "ptp",
>                         "enet_clk_ref", "enet_out";
>
> The mapping between clock-names and clocks seem a bit odd. But there
> is some room for error here, since the FEC driver mostly just enables
> them all or disables them all. But you need one specific clock.
>
> What i suggest you do is add clock support to DSA. Allow DSA to look
> up a clock in DT, and call clk_prepare_enable() and
> clk_disable_unprepare(). The clock framework uses reference
> counting. So if DSA turns a clock on, it does not matter what the FEC
> does, it will stay on. It will only go off when all users of the clock
> turn it off.
>
> I'm not sure if this can be done in a generic way for all DSA drivers,
> or if you need to add it to the mv88e6xxx driver. The DSA core only
> gets involved once the probe of the switch is over. And you probably
> need the clock reliably ticking during probe. So maybe it needs to be
> in the mv88e6xxx driver.

Thanks for the hint. Now I know what to work on next year :-), because we are closed now for a week.

Jürgen

>  :-
>    Andrew


