Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A48435C923
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 16:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242338AbhDLOta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 10:49:30 -0400
Received: from mail-eopbgr50049.outbound.protection.outlook.com ([40.107.5.49]:30208
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S237526AbhDLOt3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 10:49:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=OVjHI4JdxdoqJOEhSaziRuHo3rAqp2wHg5MXhvpPTFwpVM0ZBgrIs5O15gYv8oxfej3m2aiu5/yKglSPg1XjIYrE8juKw3c47jcW4whCf0tiAPoU4u11zrTvcZ6kXfcasmPPKlhz4tiqPrhshuHD4jPdDuSiU+BPKuDnMhxjYvLJDkO6ZfmgX0XrIHHc1/OekAJGUlLYy1tTBAYYjwOPE0VRgBEbN8fg6fExNXEdhGuVouF0Ks6MGmqi4CdpaP8Iw3ssbZOiueDNvsVZQDH/ho/1Ov18muLnXC7cudT31+SlPtD8kqXcdKNWb0M4hM5U+q9BuL7USzWRVCDFo9MyvQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjYQtT/hAN43aLOBZPs3shSrIxPRtoLLYR6iIvcw8Qw=;
 b=GTjytHwI9RGNO2aZmgDYHPmKJLJiHnhZNWjLtTCNgc8IoJNXJDusBFZF3KW3BsDMM7YIwbo8RcYH2zELIW4GcePGP1e4DWsK2VRZ4AyU5c2f0O1syjFQmQut1PIHGslFGEEpvUhOHa/2KzXc2ccwBjLR/s2KIaPHMqavQpsa+TLzHl81JeK6iTpUkw0JEw+gKtAXGQtcFSuyGfoJheAJJVELGzcyyckVEu/N4GaRNU12kwXtI+mnLUaUeoXjmua5XH8I2Nfldbhmaa19QFLaRWBwHUx1e8Aijmy1mUYuM9oqeM68404sugkrcP3xf3y1GRozjkY4eA0CVoPUk8ZPoA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oss.nxp.com; dmarc=pass action=none header.from=oss.nxp.com;
 dkim=pass header.d=oss.nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=NXP1.onmicrosoft.com;
 s=selector2-NXP1-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FjYQtT/hAN43aLOBZPs3shSrIxPRtoLLYR6iIvcw8Qw=;
 b=C2SS9bYm3ZhvnSgyjUevQpgdivjklb0GJSL2JMlhQU3sH4Jb2HLMUHgun7555rTqiNs5fuGAqeI5DtD3p5Z+3FDOXMxCaVWkGuop/Tox2bZVILkNU89sR7FpQDIFhj8mCJBgDQaA8dd0ElgDnMPW6L4XyS15ZM7e0ZKWdsqep3Y=
Authentication-Results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=oss.nxp.com;
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com (2603:10a6:803:5f::31)
 by VI1PR04MB2992.eurprd04.prod.outlook.com (2603:10a6:802:9::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16; Mon, 12 Apr
 2021 14:49:08 +0000
Received: from VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945]) by VI1PR04MB5101.eurprd04.prod.outlook.com
 ([fe80::1d18:6e9:995c:1945%6]) with mapi id 15.20.4020.018; Mon, 12 Apr 2021
 14:49:08 +0000
Message-ID: <82741edede173f50a5cae54e68cf51f6b8eb3fe3.camel@oss.nxp.com>
Subject: Re: [PATCH] phy: nxp-c45: add driver for tja1103
From:   "Radu Nicolae Pirea (NXP OSS)" <radu-nicolae.pirea@oss.nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date:   Mon, 12 Apr 2021 17:49:04 +0300
In-Reply-To: <YHRX7x0Nm9Kb0Kai@lunn.ch>
References: <20210409184106.264463-1-radu-nicolae.pirea@oss.nxp.com>
         <YHCsrVNcZmeTPJzW@lunn.ch>
         <64e44d26f45a4fcfc792073fe195e731e6f7e6d9.camel@oss.nxp.com>
         <YHRDtTKUI0Uck00n@lunn.ch>
         <111528aed55593de83a17dc8bd6d762c1c5a3171.camel@oss.nxp.com>
         <YHRX7x0Nm9Kb0Kai@lunn.ch>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.4 
Content-Transfer-Encoding: 8bit
X-Originating-IP: [89.45.21.213]
X-ClientProxiedBy: AM0PR01CA0136.eurprd01.prod.exchangelabs.com
 (2603:10a6:208:168::41) To VI1PR04MB5101.eurprd04.prod.outlook.com
 (2603:10a6:803:5f::31)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.141] (89.45.21.213) by AM0PR01CA0136.eurprd01.prod.exchangelabs.com (2603:10a6:208:168::41) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.17 via Frontend Transport; Mon, 12 Apr 2021 14:49:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0cbd8edd-42ea-4cc1-8a67-08d8fdc22091
X-MS-TrafficTypeDiagnostic: VI1PR04MB2992:
X-MS-Exchange-SharedMailbox-RoutingAgent-Processed: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB29922EBFE11714BDE8EA9F859F709@VI1PR04MB2992.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8Yb0YdTZCGb0CbScKtqsrw+c8hobqX4MDM8vAyzZTR+gR+DLN6dkt5XRRunUvYHwolqx5SHJ1QaOFfvdG/6kLCNRkflk1UApFuaHFqMZKA0Xc47fm+NkBAs9GIXuL7MtvSBxfgNThHoe/rfpL4m45mz2rGFXCP1YZRSS/Z83C/GjUEAVy3E0FCDqJz/lkVzO4fwK9DNoQvLJNCLTYSTkVhO9pEuILaSurQ+oyj8SusDVlxkwAmn/olTmwrdZ2bKOTlO/i/yBg4HDYp2bBogWCpqDdKnz1I/vqw6OFRUdX2Inden+Rfr8CMh8oBkS+80uK61ddHVTNRK08peLjtEZgwoR7eeDDdUTQI6GC+5UaKKi554i8XlfWC4djtzfMX0Sq2IuRblw46vjZjmd0LJptfLw6bWjqUH+2gKunEb2GzHB8Syq0UuQstMtucUjTHCVN65M66IEg+3k9COTV6gV8ZcWsaix6vIku0w8dlELo5BDqm0UaBD16uyuNx5vuaLnNvAeTQtBqeSWozMgyr9xn98Z1Zn1HQyNi93gRAQ3Su/8y0azBOaaresHjc7EYxdgZMvGTVqse8MJJElIkQYusDdFVHVki1z1W5hmMogOoTCA02s8GkqcE1lI4yp7vfwJEeztiYy6SronsUErzRyml1Q6BZQ/6VTrTSpKdynOm0Y283EvGGYhtF/WPh0v9bw5md1fXiomQWI+zPynMsf937YWSApZLGXzpzcWqJ6b6jg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5101.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(346002)(366004)(376002)(396003)(39830400003)(2906002)(66476007)(66556008)(8936002)(86362001)(956004)(6666004)(508600001)(2616005)(6916009)(4744005)(4326008)(66946007)(26005)(6486002)(8676002)(34490700003)(16576012)(52116002)(38100700002)(16526019)(5660300002)(38350700002)(186003)(41350200001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?N1doRk5PWFZrZEVSckY1R20xNHM5MTFWcDlrZWhySEp4eFQyczNyVUxldU11?=
 =?utf-8?B?UWVQL0wxRjNmZ3FEeUJ1cjBjSENVTHE4U1VnQXYrOTJMQTRvWVowTEdUd25u?=
 =?utf-8?B?NGhuSGRDdVNCNjJseHZ4c05lYXlBeUdPSFNDQ2ZFYjU0WTc0VzdraHdsUDJ2?=
 =?utf-8?B?eGp3TmhDc1NCbzJsWGk1bHVQKzFoVjdhYlBKKzYzSERheHRtbnZWVklmdjJL?=
 =?utf-8?B?OWdWeHZxNGtKZFRCWkJEbGVDZDc1T3ZOakhrdDZxalR4bTNUS0QvQWZZRnVp?=
 =?utf-8?B?ZDhtLy9mS1RDbk5xKzUxYm1FUmFVaWE2c21kREZ4cVJLVENHcklHTjA3bS83?=
 =?utf-8?B?UCtqWGg1QnFTSHZvT0dIZE9HajhYRTQxTWYvY0xJZ1VFWWFvTWkvQWNmZ3pt?=
 =?utf-8?B?SDVWRHNmaisrMkszdVZjYjZEeXJUdjBrV1hHTXdRZHUxcVg1YlM1RU9mV29X?=
 =?utf-8?B?NDlLdTZFL0pSOTRYVWk1TTBpQnpyNERJOFpKL3hWakpTNC9FQ0RYUXQwQ2x3?=
 =?utf-8?B?S2lVUG5OcVBQMTExeWRmZHRxa0RXV2tYSFNnU3B0N2grb3RzWUNQZXZpei84?=
 =?utf-8?B?eXZIbzZjblYzSFJFKzJyZmhGcW1zUU4zbFFzcTFZelhldXhUdjJXcTRpblYx?=
 =?utf-8?B?WmplN25XTkFuY1oydllucnJ4RGZEMndqZVFOdjVreTE5K2FpRXRhdGhTTmdD?=
 =?utf-8?B?Q0JadFhxS1RyZ2pmT2tBbDc2YlFRWnZNbzc2SlJVaUdmS29tYjE0dXczcmtT?=
 =?utf-8?B?ZWQ1T3JtQVY3clIvOHFrZmN4WTBJKzA4U2ltT014NndBS05jckEwN1BjbVVq?=
 =?utf-8?B?Vkhrd010VGxaeTJrdnV4endmblA5K2xzb0RyOGczOTlobXZYRlVjZ1p1OG9t?=
 =?utf-8?B?L1pPQUtkRFFuSFRUVXJHM0Y1N1B1UU1vYjZpaHpISCs3dmYrcnpkZUZYc2lX?=
 =?utf-8?B?Q2xjSUlxUnZmdmdadEtmcGEwT0hXYlp5amVVWWdNN052VTN6b1gwcHg0WUNB?=
 =?utf-8?B?YW1EdzcvUE5SYTR0Q0t1TlByc1JXUXFMTjB6U0JycDJZc214cEpDMWE4V1RQ?=
 =?utf-8?B?TkhUeE9jVW1lYmNuUy9qa3hoUU1RdzE4SVJZKzZPak5YeG5hZkx2dUdGcm5z?=
 =?utf-8?B?OVpONGxZRDU0cjRSdSsrNG9sNGhITHVLOEpqak1Kei9NVGhIZGlNZ0xKU05z?=
 =?utf-8?B?OW5JaWowNlNHTEU4dU91MTRpWUkyZXJEdUJEYitVQnpSQnJoTG9YbUtoNWZr?=
 =?utf-8?B?aXRXUno1S0FseHFpTjc3bUZobnlDRzk1SlVnMEFkVXUwUVVhT2E1VDdQVmVa?=
 =?utf-8?B?cFFNNG1ZbnNSU3o2ZThWVkdCZC8xWEtzUVF0bm5PU0JoTit1czVCdk1PN2dn?=
 =?utf-8?B?aU5RSG5tdmpzSU9YZzFGT01iVnlMeVdSLzAwb2RPWGtJdkUxN05zaUhLREpa?=
 =?utf-8?B?TmR1QW5SNTNMRnkyVkg1TTFXcFNCeFB4eHg0Z0hETFpsZm5POHV3b3hRQ3M3?=
 =?utf-8?B?OUZSeEpzSHdwRTBUczZTTmU3T0FQdHAwcE0zVTRXSlQ3Q3BOWVI0WHRJcEQr?=
 =?utf-8?B?RGNYd2NvNzk3dk5aYVBmem04QWh1OTJBRzZERU9velIzSEwvN1NFL2NWS0N5?=
 =?utf-8?B?ZjNwL0MwaWJCOGJoUkFLNXpEbzdFYXNSMmZpUXdrcGxVUDdodEs2d1FLR3M1?=
 =?utf-8?B?bTBFaWlBSW9PY0ppRzgyVTRXNnpoWitnNEZZOWFyaFI1UlROZmVOa3BjVW00?=
 =?utf-8?Q?IRlSElSVl2E7XrzfhHUPllpk9Y2dianGLNfXEWE?=
X-OriginatorOrg: oss.nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0cbd8edd-42ea-4cc1-8a67-08d8fdc22091
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5101.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Apr 2021 14:49:08.6885
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mLUcK8s7SwPsqCrTOzt/LCq3ZV1in1y3ei+lkUwnEOis5WHPaqs4avBK0iuTXCtrCeNy+3dCOhuWzET3EyVAPc7tqZUu2SBpjB3ZV2oKi84=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB2992
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 2021-04-12 at 16:23 +0200, Andrew Lunn wrote:
> > It is purely a C45 device.
> 
> > Even if the PHY will be based on the same IP or not, if it is a C45
> > PHY, it will be supported by this driver. We are not talking about
> > 2 or
> > 3 PHYs. This driver will support all future C45 PHYs. That's why we
> > named it "NXP C45".
> 
> So if in future you produce C45 multi-gige PHYs, which have nothing
> in
> common with the T1 automative PHY, it will still be in this driver?
Yes. C45 is robust and, if the PHY interface is standard, you can
support Base-T, Base-T1, and so on in the same register interface.
> 
>        Andrew


