Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E32F437F6B5
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 13:29:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233341AbhEMLat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 07:30:49 -0400
Received: from mail-dm6nam11on2062.outbound.protection.outlook.com ([40.107.223.62]:7296
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233379AbhEMLal (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 07:30:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aO5mgl8VG5khDGhBMj4vAc/YRTleGa4/8mN3oRWciTKzGwAX7YwKTFXOmIUpR/ks/r1gehVfK1HzMnwrEU29erd1FhWruFr80AuMcEvBqCGw+D2Gg17scaCAlGbsqyzkTgQawJqQSIaT3Ppk18Gx0/wBgm6N/eEq3bLqnXN8z04Lg6p0BvgUVq3qnPm9WJ3NW2CTjsa1+HWiPLvAE8FZIcsUspFYLrtisOZ27mnPpsH5E2wc+3IBo+4HQNiV9YBc7KyPx4oZo8l/vLjwe6GZJqr+1Yzffz1720OOfcow1mmO8ov6SAkBPdnauni2O/2JUi7B5yd1CsUOi8B+aFhPEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1E/lC5Sf5SIPVMoorqPSt74xMA/vuk13tqjIEYp1Ao=;
 b=UOChtaAvOInjyaN7soTR8lBunPs4/qJiUJVD13O7wEN/9QT1awfdRt/P+sexTxf3uYtnW5IynVEDMlcgTZ5nYbwuwuCTxrTrbcFycSD/Lq4DTjUKWYqd8Ih9Q60VQstKmIw+4cHY8AxFsBrs0vWdET/e+39iumiOjfL/1erTpbxf/Q/cDlTOB9kyr+xSV0Vo6m6K6hIIHaXDStZOWPBgOuyJazz6MXZDMHWQvXFla3hH7+I2ZuV0utiRH/HfGPWSTUDkoQPikMb5dyjTM7jEBYCyffxER9gN+qJ81qVrAjqIRVQ/+iHP3xr4KNGPGGlT04G/IbDg3DFk1YWJBQVWzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Z1E/lC5Sf5SIPVMoorqPSt74xMA/vuk13tqjIEYp1Ao=;
 b=lcRgzbgUtgWm8bViz1d3Obhh05CCRTNiFsUD4uDgR0mHtpAUF8xWOLN9r3dQFHvrDDtdXOJzCT9GVI5NxD6hFqJaXsXWntl9UCHAnD3n7koyIFqa8TPfnn9r6/H3VmHVGafU0ALwmJpP02yyRQuio9+GCOgiUdHS/hCH6tSorUUOvgI1R2sMZTRyBgRTxTVFDb3HkJ4y3nodr7Jv0oiGE3tE8yowtWNZTys46wQC09Nrm7IdLZxyMqDj9xUkJ0oCdVCVQz8AHunmdSJ2cYTUtr3QJj3dtEdmheJEoD3/De4ozOPM4fQlU/ptRAGASnDTegIvkosOLAjfhlU3BnzL8Q==
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=nvidia.com;
Received: from DM4PR12MB5278.namprd12.prod.outlook.com (2603:10b6:5:39e::17)
 by DM8PR12MB5399.namprd12.prod.outlook.com (2603:10b6:8:34::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4129.26; Thu, 13 May 2021 11:29:26 +0000
Received: from DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f]) by DM4PR12MB5278.namprd12.prod.outlook.com
 ([fe80::d556:5155:7243:5f0f%6]) with mapi id 15.20.4129.026; Thu, 13 May 2021
 11:29:26 +0000
Subject: Re: [net-next v3 01/11] net: bridge: mcast: rename multicast router
 lists and timers
To:     =?UTF-8?Q?Linus_L=c3=bcssing?= <linus.luessing@c0d3.blue>,
        netdev@vger.kernel.org
Cc:     Roopa Prabhu <roopa@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20210512231941.19211-1-linus.luessing@c0d3.blue>
 <20210512231941.19211-2-linus.luessing@c0d3.blue>
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
Message-ID: <2e58a4ab-1e40-d11c-d84e-798dd36ad679@nvidia.com>
Date:   Thu, 13 May 2021 14:29:19 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
In-Reply-To: <20210512231941.19211-2-linus.luessing@c0d3.blue>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [213.179.129.39]
X-ClientProxiedBy: ZR0P278CA0146.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:910:41::7) To DM4PR12MB5278.namprd12.prod.outlook.com
 (2603:10b6:5:39e::17)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.21.241.170] (213.179.129.39) by ZR0P278CA0146.CHEP278.PROD.OUTLOOK.COM (2603:10a6:910:41::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25 via Frontend Transport; Thu, 13 May 2021 11:29:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: da65ec41-970b-4c76-6708-08d916025d5c
X-MS-TrafficTypeDiagnostic: DM8PR12MB5399:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM8PR12MB5399F897F1F4A3B127F819A7DF519@DM8PR12MB5399.namprd12.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vYMWq1ugInQfOe2SzrfZ/tQ3N2SsMbeaRYxb8eXrtNaxycDqTBGeESVLu351z571xalGvOG9yMWqq+A4fhcvBzGB803LOEp7tTKQUKtRcBWZsXCd6fp2hXy/7LAmEDix18uqLxgm38BDgJd6Tyz/N86pCEiU8ESyQkMB3HMz395qJ/TvuV/QT+X2D9VtqmAK5hyS1O2aIkI4SZ73E/9ef5gT4WUkqw8CvIuf5FwciZSifaHF58nG9g9C6N8DzP1FYnvMqmW28/sKNMRsp1j2qCPrLmQrbBVsaIwr5J/kzIYXUG4FygGHuGUy5z3P4KhsPQYIVsto9YgsJucDBUc+V/Vdw40d7VRMFbfR9liF+MqO7uxsZeHW1hNfBKoEH5vnOYoSvdxZA7MJw9r1CPR69BR8ZrSlltzLl49+a46yVsD4qgApkcq+r9CZhKD3hsndCEoew6roak4FZG4bi6OFtSV95xv1ztEBlt6UN2jc4J0kC1OUBDjF5kR1n4FrdgaVQvEvNtu1DX1ZMPhEenHTXR+dZ66MNHllva8pgLcmEROkpmqGoWnjPHbWSX3ikAJdFK7PCyKz+BeP8Yw2YPt3wdSpbbBwhGFv6qcpslrrFBp9UuhEXvUVTOBoS/lBExJcogNkLBZ6jiO3zv+5rd0RFJ6lS4paj34DlBeHU7Q3UCOz98rgLr7HChjG/vhOEGx7
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR12MB5278.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(39860400002)(376002)(136003)(346002)(396003)(8676002)(38100700002)(4326008)(26005)(4744005)(6666004)(478600001)(186003)(36756003)(53546011)(2906002)(31686004)(8936002)(6486002)(66946007)(54906003)(16576012)(31696002)(66556008)(83380400001)(86362001)(66574015)(66476007)(316002)(5660300002)(16526019)(956004)(2616005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MGthSWp5SGhNdWNzVUxySERsOTluZWw3UHlzUWFaMEl0Wjl6Rm51VEFabCtl?=
 =?utf-8?B?UE1QZXVzSE40YmtNeHBBK3IrL2dVMUFQdEhjUlpwMXQxSVlJek0zWlgrUzdE?=
 =?utf-8?B?S3ZFc1p1YU5xM1c5dnRONWtPQk9lcVlHYnlYQ050OGVsNFQxR3Z6MjIyUThP?=
 =?utf-8?B?MlR1OTRUdW9Cd3cyUkxTYThFd1lEUElXODU3UjdzYkl4TzQyZEVnL2htZWlk?=
 =?utf-8?B?M1RWSHlRMzJleUttNWZMWmVSZXFiR3JpN0loRFRFVW9XYXQvWUpFVkV1c2du?=
 =?utf-8?B?SzM1Y0hxNXd5aHlXaWgzdi9qSHdDOEk1NG5FZHFQeVQ3Umc0czBTT0lidnZM?=
 =?utf-8?B?NnpndkcrdW1EUzRoWnNQbFNxK2VYZ1FHWXlBZ0wrMkdSYjhRMzVXeTgxQXFy?=
 =?utf-8?B?MjVYa0xhUk5lRmVvbE9YanV4b1JkMkM3b3o4N21aRGxlVlVxZnUxclNFRllL?=
 =?utf-8?B?RSs3T2ZNR3Zvb25rMGo1YUtmd1dwcm1GdG0zVElBVVZRQjZKRmU5R29paWli?=
 =?utf-8?B?OXpoTk1QMDloYWJROFA3M2sxNEV6aE9nUGRUczFySEtQT1UrdEVtMWxvblVI?=
 =?utf-8?B?TlNuQnFnaHNSV2ZQNjNRdC80UlJrTm1kc21KbWRVTEZuRFRhd2c5OFJvdnJo?=
 =?utf-8?B?WmNGSUd6d2ltZ05FUDg2d1gvTjJMUGkwcEc1aFIwSFNSdWN0T05RMnV3eEly?=
 =?utf-8?B?VFZTVEVxbnUrcGVJcUhpdHpuVXFiU0huRURnclNDWkpSRnVpK0RwVWlvVDAr?=
 =?utf-8?B?Z1lTOFg5L0VrenFoWWp4NzNUaHlSL1NGOVVBNXoxenQwWjloNGQvN1pkczNi?=
 =?utf-8?B?d29seXFwR28wbmwweEV2L2FVNFRRcjN5Nml2N2dESmYxMStKMHNINS8vdmV2?=
 =?utf-8?B?K09nVmE5ZHU3VVpNdVM3Y0tsa1ZwMFNhVWo0TDRhS2ZaLzV0UEdJbFdpcDF5?=
 =?utf-8?B?RGx3bkY1QUcxTXNxVisvbmlZeXIzc0tvYVZCWnVoVjIzNUFMY2MxdHlKV0JM?=
 =?utf-8?B?bjJ6N2pUT3VoZVc5THNPelNmYVJQZlpoQUlvMEEvd28wL0hPOERIcE9xN0JK?=
 =?utf-8?B?NExkMlhVWnJ1d01XS2REa0pseTVNYjVnZWlSZitMNW5PWmtRMm9ZTzczL2RB?=
 =?utf-8?B?ekJYaU92WlR4TVNPOVE3NURzSDF0WXNKcDdYM0tPSUpjVVBKOTBBNjZ3ekxz?=
 =?utf-8?B?amxhWWc4emowS0pyQ0lkOGFWRGtLQjZudVhtcE9aakVrOW5ZMnBOMzc5WnBB?=
 =?utf-8?B?enlSS3cySVhDTnY4LzR3TEFFNm5LRzROVGhuM3Ayay96M0ZXV0hpR3djUFNz?=
 =?utf-8?B?clZQS1BkRnVLNVUrSUpUdXBnWHNYaU1oT2JNeHFUVDcyL0hBd0d1OU9GTkF1?=
 =?utf-8?B?K3VPSFo2dTRVY0ZFaGpuSVAyQWMwZDF6L2lzSE1HWnNtQ2dIanJyay9TZWxu?=
 =?utf-8?B?SkM2L0x1Uk13VGVwdTZ6ZWpoZjREa1RVdE1OU1VCM25ZbER1OEM2M2dCT0Uv?=
 =?utf-8?B?THVIcTFSY3lJR21WS0xkd1Iva1VoVTJKc3dDU0x0VWtlRlc2aTJJa21nVVQ2?=
 =?utf-8?B?d1Y0SmNLak1sc0tLOTVUSllZdjYxc003VXlPRUR1dzEwa2k1UStCUjk1Y1lI?=
 =?utf-8?B?bVhEUFNhNXA3bGxwNDFIWWw5bXVYWGllN2VaaUJYVkIzV3dvaXoyOWF3U1di?=
 =?utf-8?B?elFnK1FvZEp1OVhLNVN1NFFDanA3dE4vbUl5blJSeVI1OFJPTFV3NEtPc0Nl?=
 =?utf-8?Q?uCXS4oaUDtXChquJg1JjxCbNeds2q2UtbkuCobw?=
X-OriginatorOrg: Nvidia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: da65ec41-970b-4c76-6708-08d916025d5c
X-MS-Exchange-CrossTenant-AuthSource: DM4PR12MB5278.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 11:29:26.4157
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 74dYOofyEtGY1A99bYA5/xUwKGgthxd70UICQH8Br8APrDgG2FhRFHvXxr0obZlNBfEdwtgHa5HXStpnck0h5Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR12MB5399
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 13/05/2021 02:19, Linus Lüssing wrote:
> In preparation for the upcoming split of multicast router state into
> their IPv4 and IPv6 variants, rename the affected variable to the IPv4
> version first to avoid some renames in later commits.
> 
> Signed-off-by: Linus Lüssing <linus.luessing@c0d3.blue>
> ---
>  net/bridge/br_forward.c   |  4 ++--
>  net/bridge/br_mdb.c       |  6 ++---
>  net/bridge/br_multicast.c | 48 +++++++++++++++++++--------------------
>  net/bridge/br_private.h   | 10 ++++----
>  4 files changed, 34 insertions(+), 34 deletions(-)
> 

Acked-by: Nikolay Aleksandrov <nikolay@nvidia.com>


