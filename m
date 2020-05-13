Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9641D09AC
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 09:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732134AbgEMHOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 03:14:32 -0400
Received: from mail-vi1eur05on2065.outbound.protection.outlook.com ([40.107.21.65]:31865
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731804AbgEMHOc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 03:14:32 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jYRsDSZ3c6xAc1OLmZR11qlf8hQHfdBIrzz5yEi9RdDsADhhWQ7hr1RTU5O2JydadY1dPr+UpoHD2v/M7/Ydky2FoirymLQ8yH2ZyjbvaX4QAgH3dyNTUXxrufpYkKUi64zUV1Z3iZrIqIDOV6juADkJyW9t/IZtHCuFe/RgZJgrrr45gD5Yrky1EnvUdPBIjqSu8B/2r8VGZSTRViFumfe33feh9mA26ftbs1Gf7dKnS08ZNoWwUdIZl4LQjmGa4MC/gZ0VhAvsjeSq1DXovwgdHAj6W11WwfPwbn46n9jsW3y619llE8i9Thw72YvtL7vzkUYwAb+u4vzv5YJXBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjejlYf42U6ct2uvJfDL58t3RXYcOBAeelMRbIXTpPc=;
 b=KXBSL8SBLitCM7Cck7ug1Sxj5jodEnxQAsaZ3KSCa0of/+k8XZjf5mLxUbF/AQiVx9SIMpWTCy/45f+b6c7WfJtgzuaQWzPs9awVHs6D40K7r+4zLCJ8DdPB3Rw9HYnFt3oayIt0iKgNVsOXkPrDRifScp+TSyA3wS7ZkKgCD444zb0mNdqzlcm7Z2XVVt77XXgZ1O3dt0BILyjhP4/vEbHKFwLFPBrje4MtRSLdLVeNaMapgPa19Ik36OSrvVMv9esNFOag/4XVIqZkdMAhsydEdPd3Q645TBGa3yRGD46kOL/rruhmsp7GsrWaH8o/I8YAHquiey6A//VxYeFMyw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=orolia.com; dmarc=pass action=none header.from=orolia.com;
 dkim=pass header.d=orolia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=orolia.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WjejlYf42U6ct2uvJfDL58t3RXYcOBAeelMRbIXTpPc=;
 b=RfT6/Kn7jsGdGE3+dzoHXXwpbvvLlb7zkssYyzee65JTHOYix/Kf5JkFH8T5f6W9l3An1EuQG2yvWc72DJ0BY2tIgAm3JN9AMy3cBqixFLiGCTttx5qyfAnbi/XcvQt2zNyy704Mk244v6n8iU8y4Ab2CUxw5JNVVPTWk0Xowco=
Authentication-Results: bootlin.com; dkim=none (message not signed)
 header.d=none;bootlin.com; dmarc=none action=none header.from=orolia.com;
Received: from AM0PR0602MB3380.eurprd06.prod.outlook.com
 (2603:10a6:208:24::13) by AM0PR0602MB3682.eurprd06.prod.outlook.com
 (2603:10a6:208:2::27) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.33; Wed, 13 May
 2020 07:14:26 +0000
Received: from AM0PR0602MB3380.eurprd06.prod.outlook.com
 ([fe80::3d36:ab20:7d3b:8368]) by AM0PR0602MB3380.eurprd06.prod.outlook.com
 ([fe80::3d36:ab20:7d3b:8368%7]) with mapi id 15.20.2979.033; Wed, 13 May 2020
 07:14:26 +0000
Subject: Re: net: phylink: supported modes set to 0 with genphy sfp module
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Antoine Tenart <antoine.tenart@bootlin.com>
References: <0ee8416c-dfa2-21bc-2688-58337bfa1e2a@orolia.com>
 <20200511182954.GV1551@shell.armlinux.org.uk>
 <4894f014-88ed-227a-7563-e3bf3b16e00c@gmail.com>
 <1b0a20fa-b2ee-e7fa-fdfb-dedabe81b03f@orolia.com>
 <20200512122844.GA1551@shell.armlinux.org.uk>
From:   Julien Beraud <julien.beraud@orolia.com>
Message-ID: <b7b371e1-da07-29f9-44cb-f184377774c4@orolia.com>
Date:   Wed, 13 May 2020 09:14:24 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
In-Reply-To: <20200512122844.GA1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR0P264CA0066.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1d::30) To AM0PR0602MB3380.eurprd06.prod.outlook.com
 (2603:10a6:208:24::13)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2a01:cb00:862c:3100:f406:ebd3:1008:85ef] (2a01:cb00:862c:3100:f406:ebd3:1008:85ef) by PR0P264CA0066.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1d::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.20 via Frontend Transport; Wed, 13 May 2020 07:14:26 +0000
X-Originating-IP: [2a01:cb00:862c:3100:f406:ebd3:1008:85ef]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1b7c94f1-4bda-415a-8f55-08d7f70d453f
X-MS-TrafficTypeDiagnostic: AM0PR0602MB3682:
X-Microsoft-Antispam-PRVS: <AM0PR0602MB3682073E272E0C227B27171899BF0@AM0PR0602MB3682.eurprd06.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0402872DA1
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I1J+LqV3CzQKCn54G7Rc2gc3qW2eFqPUxjZzrGgQANucDMl7SGxJ+fXmQ/yBKp/002yaDsfcTdhr4RclvjwQ6SVfLR3IB+9wCVonanYLE1jEjDPHPHwZUOAKYBrJro+Bg8i1ynLx50Pfp5jGyLMRwSwMp7vRp1vdMJjAE8cV89pQ4ce2VvfwDEPEQiyr33pAXfnrmCYKr7Fk+VQkmXprXVDi9raX6Ih1Gl7s7XrHIuIWoiDC1xeiVXpmjaJsNa/DSOkg7qWbkiXuLNkZShO3kwEXhdLKirBOs7hBp6ZMAK0OLH+QCDydsaUHv3ACDEsThHQf+9isnEUDVZDJS3xB8wRQl98TvfhXnrlyApeAK7rNmq2eZqNyIBjHEJ+yJcy6Wuj1GMuA+RuQRweVEN9oEwnxqT9XtLnveD/I057qO8n5WmlmNfcEf0V5Af6zNOBef//x6KUw0Sofrgldut3nouaYlozWIwP/lU71kpQqPtA5ufaDUAW6zL8cJPhGRTxCs6wngki7udaah8FOa5wzmK57wEZA/egDWvPnVCdtQB0QgyNGoElpSpHaBmsovr3h
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0602MB3380.eurprd06.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(136003)(396003)(376002)(366004)(39850400004)(33430700001)(8676002)(2616005)(31686004)(53546011)(8936002)(2906002)(54906003)(36756003)(6916009)(316002)(66946007)(16526019)(44832011)(66556008)(186003)(66476007)(6486002)(52116002)(5660300002)(86362001)(4326008)(33440700001)(478600001)(31696002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: UhvRk/v2gNlK4F7DqX7NQ4QcSJ9cX+rYedTR084HRjTtrf9EhT7qqU06ZlLbw6FiYji8bUwUskRkMtaS2XZdIKe3gwplXDYECdWw5SDM5yzIsckv2QDd9FWzKLpmJqKHDlwTxF7IBhM04iSri0pE84bA+ksxZ9ZgU+f16l1NlGfF+r2DwN2opVnq6B8Rfs8fNAaePmrbMzQ444nJC8RuYHky3M/emHNF28+dyRbqd7eiIDacAaxgi4jjegiDRoeWE+kaaKKxfOXNQsRPs4wLQMLQv7a6+y6/ufHPEESVkZ8sk6yAzMcDq7qB2qrbDc8LYKYXwhh4ZCvaS36HNLcqvjF1ZypeJnuSNumMKETmqXLi/1SyI579quIuxcBduI8GIvT9K+TV6MaZMh3MIOj6MBnaD0Hm+Co9nJUCyu9o+774fxm8Su0E4ejX+5wneJr9bqymDXDN/fVz53jY/PwRNTirtkOzN67zMTktw2me4NRm1ImyYilexNbWuJxK6aHfeqD/Ak0ugdHueykQKbmZSD0u6f5yMQWEPKJjapVwSgkdsr3GgiJDM7VmYVIr9Qk0
X-OriginatorOrg: orolia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1b7c94f1-4bda-415a-8f55-08d7f70d453f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2020 07:14:26.6052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a263030c-9c1b-421f-9471-1dec0b29c664
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: N9QoI11LMTUozFmUi8npNrW6rmeQlf0MTXK1peWGIgyJd8dKZwMHvKggFueX3D34rJfOzQLXY9UL49JIgEiAY/tjgbLeMO9oQN31pPzxLpA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0602MB3682
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 12/05/2020 14:28, Russell King - ARM Linux admin wrote:
> On Tue, May 12, 2020 at 11:28:40AM +0200, Julien Beraud wrote:
>>
>>
>> On 11/05/2020 21:06, Florian Fainelli wrote:
>>>
>>>
>>> On 5/11/2020 11:29 AM, Russell King - ARM Linux admin wrote:
>>>> On Mon, May 11, 2020 at 05:45:02PM +0200, Julien Beraud wrote:
>>>>> Following commit:
>>>>>
>>>>> commit 52c956003a9d5bcae1f445f9dfd42b624adb6e87
>>>>> Author: Russell King <rmk+kernel@armlinux.org.uk>
>>>>> Date:   Wed Dec 11 10:56:45 2019 +0000
>>>>>
>>>>>       net: phylink: delay MAC configuration for copper SFP modules
>>>>>
>>>>>
>>>>> In function phylink_sfp_connect_phy, phylink_sfp_config is called before
>>>>> phylink_attach_phy.
>>>>>
>>>>> In the case of a genphy, the "supported" field of the phy_device is filled
>>>>> by:
>>>>> phylink_attach_phy->phy_attach_direct->phy_probe->genphy_read_abilities.
>>>>>
>>>>> It means that:
>>>>>
>>>>> ret = phylink_sfp_config(pl, mode, phy->supported, phy->advertising);
>>>>> will have phy->supported with no bits set, and then the first call to
>>>>> phylink_validate in phylink_sfp_config will return an error:
>>>>>
>>>>> return phylink_is_empty_linkmode(supported) ? -EINVAL : 0;
>>>>>
>>>>> this results in putting the sfp driver in "failed" state.
>>>>
>>>> Which PHY is this?
>>
>> The phy seems to be Marvell 88E1111, so the simple solution is to just add the driver for this PHY to my config.
>> That said, if for some reason someone plugs a module for which no phy driver is found the issue will happen again.
> 
> Right, please use the specific PHY driver for modules that contain the
> 88E1111 to avoid any surprises, otherwise things can end up being
> misconfigured - for example, the PHY using 1000base-X and the host
> using SGMII, which may work or may lead to problems.
> 
I'll do that, thanks.

>>> Using the generic PHY with a copper SFP module does not sound like a
>>> great idea because without a specialized PHY driver (that is, not the
>>> Generic PHY driver) there is not usually much that can happen.
>> Thanks for the info. I don't have an advice on whether it is a good idea to use a copper sfp without a specialized driver,
>> but before commit 52c956003a9d5bcae1f445f9dfd42b624adb6e87, it used to work and I could at least get a network connection.
>>
>> Moreover, this commit didn't explicitely intend to forbid this behavior and the error is not explicit either.
>>
>> If phylink+sfp still supports using genphy as a fallback, It may be good to fix the current behavior.
>> If not, maybe adding an explicit warning or error would be preferrable.
> 
> The commit is designed to increase the range of modules that can be
> used, especially when the module supports higher rates than the MAC.
> 
> The downside is that we _must_ know the PHYs capabilities before
> attaching to it, so that we can choose an appropriate interface to
> _attach_ to it with.  It's a chicken and egg problem.
> 
> For this to work reliably in cases such as those you've identified,
> I need phylib to always give me that information earlier than it
> currently seems to for the genphy fallback - but the problem is the
> genphy fallback only happens after attaching to it.  So again,
> another chicken and egg problem.
> 
> Subsituting the SFP modules capabilities seems like a workaround,
> but those are also a guess from poor information in the SFP EEPROM.
> It is what we were doing before however...
> 

Thank you very much for the explanations.
I'll try this patch for now.

Regards,
Julien

