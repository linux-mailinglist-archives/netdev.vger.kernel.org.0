Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5760014B2B9
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 11:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726233AbgA1Kfq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 05:35:46 -0500
Received: from mail-eopbgr40111.outbound.protection.outlook.com ([40.107.4.111]:20103
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726142AbgA1Kfp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jan 2020 05:35:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FhnPIUd4pf4wcumgJxm/7EaTrviDIJ+5zBTdpfSxed7wfeiSi3NJyyQ1Ow+fS1bDclLpXuiZ+Siw4AvHSWomg61p8xolc+KTN+mmwqP8QvR+7ZWyXbgg3CPpoXt+sLdQxM4wAQhT5rtUtjbv5hp/q9d6ukMLSuhxUillj0nMjQvJxc9CyMVmLtoofUqarm2tAZ0WB6rgQQq1iO5yreo1I3kGTqX3u9ZmRTKq5eSJNeFjR+iWWDNGldgmvQwXAV//J1plyibnHbsQ/6yVE4iLuR1P2JHbsPrpLbGqiS9HiDCyghH4iSoVw+8fCuatEaJjOoABo5W2QuRBSphKvZTYmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hP7bh6/USdKlEIf1iYj5wl/My/uWSKPZYQVGiy6lOU=;
 b=E5HHyiMuL+WbL5l/jm85tDXLJUaeqMpOh6OKmiqm1U2cwjCvcbd0GyXxay75mgCPcybZcuHi/o/AHSsWvXxrN4/+8p/EONj/YvHhpfdPqtXaph/51TA6Ox0ml2VE7o5/fM+4Z2kuZ5sFw6/isdYh8/0ZRHULutVXkFtK+F90A4eYk4GMA15sYWCXOPl9XEFu8QR5Qif+6SxBlhoRmsKUpHwS1l6siUECAH8lZr6AsYcaY/t1dSGlTSyzBB+99+41lKDdtUtW/6UeFvv0a6BlrgtuAdXzXVg781e7IXtBOuUxvgfk3Xg8choWKX50UfSC/3B173jD1ExW40UxDH5uzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=televic.com; dmarc=pass action=none header.from=televic.com;
 dkim=pass header.d=televic.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=televic.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0hP7bh6/USdKlEIf1iYj5wl/My/uWSKPZYQVGiy6lOU=;
 b=EKbvIpKwRFnrquktAaU/1L6PolaVrC4vJJmOsGoZ2GfwZyRCRkPH8cdckjBH3zOuDfwe6l0lNsC3WECSHE15uxx/T9GZQ3N4KwyWgGwoc0I2DKTC2Q9cbcor0sLdzkbHm6PRr0BzUa8X4uvm+OFW6XmbsHR9hOoYXmJjhUaZ7PY=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=J.Lambrecht@TELEVIC.com; 
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com (20.177.203.77) by
 VI1PR07MB4269.eurprd07.prod.outlook.com (20.176.2.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2686.15; Tue, 28 Jan 2020 10:35:36 +0000
Received: from VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349]) by VI1PR07MB5085.eurprd07.prod.outlook.com
 ([fe80::6591:ac75:8bbf:2349%5]) with mapi id 15.20.2686.019; Tue, 28 Jan 2020
 10:35:36 +0000
Subject: Re: [RFC net-next v3 00/10] net: bridge: mrp: Add support for Media
 Redundancy Protocol (MRP)
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>
Cc:     Horatiu Vultur <horatiu.vultur@microchip.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bridge@lists.linux-foundation.org, jiri@resnulli.us,
        ivecera@redhat.com, davem@davemloft.net, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, anirudh.venkataramanan@intel.com,
        olteanv@gmail.com, andrew@lunn.ch, jeffrey.t.kirsher@intel.com,
        UNGLinuxDriver@microchip.com
References: <20200124161828.12206-1-horatiu.vultur@microchip.com>
 <20200124203406.2ci7w3w6zzj6yibz@lx-anielsen.microsemi.net>
 <87zhecimza.fsf@linux.intel.com>
 <20200125094441.kgbw7rdkuleqn23a@lx-anielsen.microsemi.net>
 <87imkz1bhq.fsf@intel.com>
From:   =?UTF-8?Q?J=c3=bcrgen_Lambrecht?= <j.lambrecht@televic.com>
Message-ID: <83f98a49-d5b6-c5d8-9ca3-4c5eea8fb312@televic.com>
Date:   Tue, 28 Jan 2020 11:35:34 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
In-Reply-To: <87imkz1bhq.fsf@intel.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-ClientProxiedBy: AM6P193CA0128.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:209:85::33) To VI1PR07MB5085.eurprd07.prod.outlook.com
 (2603:10a6:803:9d::13)
MIME-Version: 1.0
Received: from [10.40.216.140] (84.199.255.188) by AM6P193CA0128.EURP193.PROD.OUTLOOK.COM (2603:10a6:209:85::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2665.22 via Frontend Transport; Tue, 28 Jan 2020 10:35:35 +0000
X-Originating-IP: [84.199.255.188]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8ab37b3f-a9c9-4e59-455f-08d7a3ddcf93
X-MS-TrafficTypeDiagnostic: VI1PR07MB4269:
X-Microsoft-Antispam-PRVS: <VI1PR07MB426988D5BA313C7049945D8BFF0A0@VI1PR07MB4269.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 029651C7A1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(396003)(346002)(136003)(39850400004)(366004)(376002)(189003)(199004)(81166006)(8676002)(31696002)(81156014)(16526019)(186003)(31686004)(8936002)(53546011)(16576012)(7416002)(316002)(478600001)(52116002)(86362001)(966005)(26005)(110136005)(36756003)(66574012)(956004)(2616005)(4326008)(66946007)(5660300002)(2906002)(66556008)(66476007)(6486002);DIR:OUT;SFP:1102;SCL:1;SRVR:VI1PR07MB4269;H:VI1PR07MB5085.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: TELEVIC.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bVACnxu7rteSkYplAOg17zmvziUA7q9PD/bJhIPjLCnsweea7CQ5OvTMr6/dWbA4bQUPGAW3ehQQKm36yirBr3hrlm2IgEe+1+UZ0kXwp/RsuyI7AVQFXmcB9wE5nWimVYlAcrqexlyGWwW87w+FvfY0cwvz2qStbLvR81O4qAIjshktA14PeX+yW83OcFDLGNTuVTduQQG26+Z+j2HXx5o/4ZySeh6V6JCXiaCwRgWkJKqfEiTWCLAbNN3I06c2AsxdVeFhKCNVCKAZg0sRRf8RyogzrRrpfFcNLwdLaXb5PQPuSgyb2d0cH4KoUW+ZThloMPig6rs915Lm3rp6pOydxZTb1/JMjmFS3cAj7XtYSbBo+EpbgXHqG5mJpvA8KK6c+u13YoDIWqDvc0Yc40FsuyU21jQ1wLGQUzpb4FH2bJsBFJ/I6yARC/r1kDztopC61eRNuq+YicBncRj3OR00cUxJmWcYmr/J+e97tokyTrY9YWoiDgSLuJ/u5jIyFxzCYbcFjTT8A8SWVnptKA==
X-MS-Exchange-AntiSpam-MessageData: qBXb6zTzWKLBEmmLqCWTrrFPZQS+eQ//Ga0quMoLNcrtzL9qoNMw0hmPM76jP0Zbb7lQsFj4w5UYntTH5w6U7hHBN5LCK+mqWDaferGhqmiQOrCrP2TJv5FhrOFpC3LKQGxfdj2gPj1n0bIEnqMVAA==
X-OriginatorOrg: televic.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8ab37b3f-a9c9-4e59-455f-08d7a3ddcf93
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2020 10:35:36.4008
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 68a8593e-d1fc-4a6a-b782-1bdcb0633231
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: uKTR1UiQU4wA9/IveeVaX6YNgtTJCLh0NXNUr4FZs9+nF6ToQ1Lqko6RX/TurRO8RY2drA0Pk+hlYZK9Ofbs0Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR07MB4269
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/25/20 10:18 PM, Vinicius Costa Gomes wrote:
> CAUTION: This Email originated from outside Televic. Do not click links or open attachments unless you recognize the sender and know the content is safe.
>
>
> Hi,
>
> "Allan W. Nielsen" <allan.nielsen@microchip.com> writes:
>
>> Hi Vinicius,
>>
>> On 24.01.2020 13:05, Vinicius Costa Gomes wrote:
>>> I have one idea and one question.
>> Let me answer the question before dicussing the idea.
>>
>>> The question that I have is: what's the relation of IEC 62439-2 to IEEE
>>> 802.1CB?
>> HSR and 802.1CB (often called FRER - Frame Replication and Elimination
>> for Reliability) shares a lot of functionallity. It is a while since I
>> read the 802.1CB standard, and I have only skimmed the HSR standard, but
>> as far as I understand 802.1CB is a super set of HSR. Also, I have not
>> studdied the HSR implementation.
>> Both HSR and 802.1CB replicate the frame and eliminate the additional
>> copies. If just 1 of the replicated fraems arrives, then higher layer
>> applications will not see any traffic lose.
>>
>> MRP is different, it is a ring protocol, much more like ERPS defined in
>> G.8032 by ITU. Also, MRP only make sense in switches, it does not make
>> sense in a host (like HSR does).
>>
>> [snip MPR explanation]
>>
>> Sorry for the long explanation, but it is important to understand this
>> when discussion the design.
> Not at all, thanks a lot. Now it's clear to me that MRP and 802.1CB are
> really different beasts, with different use cases/limitations:
>
>  - MRP: now that we have a ring, let's break the loop, and use the
>    redudancy provided by the ring to detect the problem and "repair" the
>    network if something bad happens;
indeed. MRP is IEC 62439-2
>
>  - 802.1CB: now that we have a ring, let's send packets through
>    two different paths, and find a way to discard duplicated ones, so
>    even if something bad happens the packet will reach its destination;

Not exactly, 802.1CB is independent of the network layout, according to the abstract on https://ieeexplore.ieee.org/document/8091139.

The IEC 62439-3 standard mentions 2 network layouts: 2 parallel paths and a ring:

- IEC 62439-3.4 Parallel Redundancy Protocol (PRP): this runs on 2 separated parallel paths in the network

- IEC 62439-3.5 HSR (High availability seamless redundancy): this runs on a ring: each host sends all data in 2 directions, and when it receives its own data back, it discards it (to avoid a loop).

(and it is better to implement IEEE, because the standard costs only 151$, and the IEC ones cost 2x410$)

Kind regards,

Jürgen

