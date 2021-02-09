Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95BB31499A
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 08:39:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhBIHjS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 02:39:18 -0500
Received: from mail-eopbgr60130.outbound.protection.outlook.com ([40.107.6.130]:22862
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229669AbhBIHi7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Feb 2021 02:38:59 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m8PtBvI5xACUIEebx+tTUuKvNgytAAX9dkhUFABcGlAahJszfNb7GKbinBbeWrpYPj6bYi5H8iDP/0njW+hMv39GPWbKEcbjwwwLBV8dtKErkcj0QpdqOlig8trzRljg/icmDe7Pw4z8XxdDvJBRLsubVtO4wE3vakTpSqRnUHsjAoZ4Ds9w50mt9Qo2SGw/RVcsW1UkJg8PnzZltWcKekUHjbKR232xa8K5rPPkSVcdZEXVj18PF7eDLyxs1qryDrH2oijt1kN/h7Lx9GLOyzNSy8FJs2f+2Knkh8m6NAp1/jyeeg/CxfdpEBGnWP6UAyWSMo14QWrg5gzaeg8ntw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfEcprzb9pmLbsZ71aA6Z4Mf+YdFEouclDmvmJT40Fs=;
 b=IX0HRn/FAUR0R1sGu0/rnTB2+OR/g0tGWr7To1F3vQMaqap6XAUhyRDgmRV7M9cqcpm8SKX6Afes/glSCiP8OJniVs7Ox0LI8DNO/EC94I14P/qiBbRIU0vrba6X8HsGvnilEcFKZdPPMVwEYpQ/J5/eAGx6A6pHalt+DMK/Y8RVYEEeZPr1ECewOha4NT7YYstUJ1LQIM924hVa8IjZmLu9A8Pl+mlBWbvdTT/KwdFbta3o/+GpEdPuidnOTp2NwZu30czW0ILrwvo3w/iP5YBiy07Hgp8auHp9OmMw5Au44Abn9UOnjKHRjW7EXBimPZDfwqcoPmHNjQiKYkhzKw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=prevas.dk; dmarc=pass action=none header.from=prevas.dk;
 dkim=pass header.d=prevas.dk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=prevas.dk;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LfEcprzb9pmLbsZ71aA6Z4Mf+YdFEouclDmvmJT40Fs=;
 b=DojVcqPNf5t2wp7nPn/jR3YL6wDEaTSdR7ou0W2k12OWdtcXLpILLauTzrmJCnwHIbU77bUbLKLGfVXQ9gjkgBfyIH4fOpY4joPa64vZAO1DI1RFjVw4tiAukNuw0tLKnKy6mSMm+yJhuTE9rEcXRIAUrXCqplLyRQefM55nSDI=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=prevas.dk;
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:3f::10)
 by AM0PR10MB3009.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:208:160::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19; Tue, 9 Feb
 2021 07:38:09 +0000
Received: from AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a]) by AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::58b2:6a2a:b8f9:bc1a%3]) with mapi id 15.20.3846.025; Tue, 9 Feb 2021
 07:38:09 +0000
Subject: Re: [PATCH net 2/2] switchdev: mrp: Remove
 SWITCHDEV_ATTR_ID_MRP_PORT_STAT
To:     Horatiu Vultur <horatiu.vultur@microchip.com>, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, kuba@kernel.org,
        roopa@nvidia.com, nikolay@nvidia.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bridge@lists.linux-foundation.org
References: <20210206214734.1577849-1-horatiu.vultur@microchip.com>
 <20210206214734.1577849-3-horatiu.vultur@microchip.com>
From:   Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Message-ID: <9fe710dc-79c3-6161-6bfa-917239d4eba9@prevas.dk>
Date:   Tue, 9 Feb 2021 08:38:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
In-Reply-To: <20210206214734.1577849-3-horatiu.vultur@microchip.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [5.186.115.188]
X-ClientProxiedBy: AM5PR0601CA0074.eurprd06.prod.outlook.com
 (2603:10a6:206::39) To AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:208:3f::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.149] (5.186.115.188) by AM5PR0601CA0074.eurprd06.prod.outlook.com (2603:10a6:206::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Tue, 9 Feb 2021 07:38:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ced7d05-35ae-49bb-660d-08d8cccda5ca
X-MS-TrafficTypeDiagnostic: AM0PR10MB3009:
X-Microsoft-Antispam-PRVS: <AM0PR10MB3009DC4CE91959EB43101F07938E9@AM0PR10MB3009.EURPRD10.PROD.OUTLOOK.COM>
X-MS-Oob-TLC-OOBClassifiers: OLM:1247;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HWyG9CEs+plaVRIWz0gO0+1OvZAYno2zcd3ofxI0P3hCrgJNQkr93jqNwv5xBcigRX3DZYiyDklDqiFgZFW3grjzbGnRyNgR2qi46yF4faqQ/8s5pw5oPlm061JICcQTKpAkobe/IO7L/nca9/WP7HtI7TEMq/IjH8oHRkH4jMRiDyUvInIuQIXh63W9p0nRubQb8jNfENpDJqo2ql2tFh61FydJERDf7FPk0pM02NINBFusfZEnhUgyLalsGQ6MjEQqtCkP1cNzvokGJNmXYIPqmC6wuJWeMzRa6u4kfhAWnyy2SFqmZ1keX0l+uV8kWidDmafEOlnEBsPKSvkHkxl2tsAEasqMJFxxQzllq1PKL6bcV2YdidHxOwecZC//88MLNjJ40IzuAHT4A4AWoHqtPBplNWFjYKimyVfP2fqBqphMWKDypvcI7LWBGnK6JIX3tPNE8mrSKSDnQSE5UUsPukeO9oRlV2nyyO9vuT96mCCBFe4GVRWZU4v2fKAefKsK8aMOIZ/BfXcmTzovrdk4WNcLJSGb/vpebFii5gNo2GxkI8TG+R/o8nsg6HECR/dC+cLzN7YBqaMW7tBLA6ZHSRLL4PN0QBzdAkh+b4bD7/9/JrLuYpWvAvMcuQfd
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(136003)(39840400004)(478600001)(7416002)(316002)(186003)(16526019)(2616005)(16576012)(2906002)(8676002)(6486002)(66946007)(31686004)(66556008)(66476007)(36756003)(44832011)(86362001)(52116002)(5660300002)(8936002)(4744005)(8976002)(921005)(26005)(31696002)(956004)(45980500001)(43740500002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData: =?Windows-1252?Q?PsV5DrbRQfUsfoC+IdRFlBjazWhwruBjVZ3S0PahTCKGzNkAAu1VFDCR?=
 =?Windows-1252?Q?feU2HZXQeAXwWLSEqoB+xzTmdLHSkM5dJjLQBmEpcLXLVcOgqjmeOLBN?=
 =?Windows-1252?Q?kTpWuz/Xl+qaDNXK+UajZFpMuGq5NduqWTmApM6RIpnB0a2Of2CC7BnD?=
 =?Windows-1252?Q?JMdiWDECROr+uGdY8E9ogfYx0aJVfYewhA9L6R8MkunXKTaqapFvUI0A?=
 =?Windows-1252?Q?rEGcojxLH6u0WTR/OzMXw0vZA7zug1LiRfVVk8Rrya9181Lo5hrqx9S7?=
 =?Windows-1252?Q?b/BOTZ4n/DI84LsFmSsS5XmstLV0eWRCXtSY2d6ATX+zLexZVNV+hzOa?=
 =?Windows-1252?Q?yRCQsfbHJgysr3JRK0JbOVupQL/+y755YQtg89d9o36Q4TvjRr8Hyl6H?=
 =?Windows-1252?Q?ZMw91sVV2Eb+8JfMl5+MukzJ+WvbC+qJGqX+AVTf2/GSLpR/scyQ4ceN?=
 =?Windows-1252?Q?pEbwAaiXHUSME7geswedi7aiLDULPyyvXEE1RmzyyhOXQ+6ArrZLAPLF?=
 =?Windows-1252?Q?hvwy3R0AhHG4f3OWqSRS3R6gbKQcsqqnN6ZsM0yW+hLOtGUjGksEnCiG?=
 =?Windows-1252?Q?jwmqTUTYaD9hmbSBai+C5/DVt6X06SsAgb4n/+/huiRTW63SCWBT6FXq?=
 =?Windows-1252?Q?Kh4gQpzIFuMDw1KREnoK/EsGf9XP7vfVmN7R/dgPoeRSGQRJ+NQfypvD?=
 =?Windows-1252?Q?O8zuUc1zl6Nazvkv5b9zKOqudKQdlqPfdePxZhUwRCOyb+nhMqKHy4xk?=
 =?Windows-1252?Q?5q2f6SREpRMnKII6vSx8tg/3MKlQLqy1cege96dTeOwrprhdoXwCsJCz?=
 =?Windows-1252?Q?LisGnlRnSV0ngyOEeP3aeKYbhMRJoUUM9y1KHALf+Dcn/XB4KUbaL9ik?=
 =?Windows-1252?Q?rHw45Kw4BEG3ttZjGhiGIu16uBiyY/WknU90pHaNDEbqL+0GmOkt+yXf?=
 =?Windows-1252?Q?biSK4uMsoatzY/YLwnhoL06c9cyTDnMxmYcbGsniAI4krbvCncyOewki?=
 =?Windows-1252?Q?au2+E/ycGdFvS25dGTLPQXfGOk9wn7t50tZKma3DU1gBzjcoI3dlZY6V?=
 =?Windows-1252?Q?cHMJiR6cp9RCMYLAR+A1vfRw3X0JQ3MN3bNzybtTsHSlhw8lEAb8ryVM?=
 =?Windows-1252?Q?GpyMnVN0/lO0MCN64TDwvvBKB6k9td0mramXeFd+1IsXzcT/0x5CbOd4?=
 =?Windows-1252?Q?0E2uRigk+Bnafvb9mwKR2zZ/hKS2i/mFt8+kSzR4hLHmP9Ej5IcPGF1y?=
 =?Windows-1252?Q?7mbh7y5q6tWH7lzIEMgkMNS1+BsLxCsudVM3XiIZcy2Ba7SsqwEnRvzD?=
 =?Windows-1252?Q?zvkVhuNFxmivpxurB2zU7CCflgO0i3ftomXTTQv2SKcvRxTemULP5apf?=
 =?Windows-1252?Q?jF1qz/8gHrvWXYwPgfYU5uAM0EiHebMs7EwFWBYVdggMTO9M4z2Qtcvq?=
X-OriginatorOrg: prevas.dk
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ced7d05-35ae-49bb-660d-08d8cccda5ca
X-MS-Exchange-CrossTenant-AuthSource: AM0PR10MB1874.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 07:38:09.5921
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: d350cf71-778d-4780-88f5-071a4cb1ed61
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7VWCR1OEnEZA3v+tHc2nCoI7NhM2uGwRR0N6y947lzhKP+xKzBnm2xhyZgo7u7lNmT2ByS4FJwwhmq2kQ2nEFCFI3EoLe0mTGw8WcCQavOo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR10MB3009
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/02/2021 22.47, Horatiu Vultur wrote:
> Now that MRP started to use also SWITCHDEV_ATTR_ID_PORT_STP_STATE to
> notify HW, then SWITCHDEV_ATTR_ID_MRP_PORT_STAT is not used anywhere
> else, therefore we can remove it.
> 
> Fixes: c284b545900830 ("switchdev: mrp: Extend switchdev API to offload MRP")
> Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>

Acked-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
