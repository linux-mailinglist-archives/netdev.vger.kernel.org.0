Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34E1A48D3EF
	for <lists+netdev@lfdr.de>; Thu, 13 Jan 2022 09:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbiAMIzq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jan 2022 03:55:46 -0500
Received: from mail-co1nam11on2053.outbound.protection.outlook.com ([40.107.220.53]:51425
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S231279AbiAMIzo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jan 2022 03:55:44 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lQvgUYl+218BjRMAkbIpt17OGBN0onC33ng+421vOAsWfl+/LT8ARLyjMuN/XTe5wsGtKfOsLrKro32mFqKoAZ5xPD70ArRjaFgX6mniYE5SbhJoShwFrl7y7OJZd0xCMv03/K9jl10FG00izCyggolzmdH2Jh7NbPCJXael1YAo67MLOsfPyz6HJ6LeBJg1K6gH72JAtccr+3Uv27Jm2rx1dZqvXh7pO8U4DlDSEaoAo2NaitWQkPoJfY5GCf6OdzH/IRy77LbqsyFmFYT0JUaGSRR0aiHbudyuBRoSzyFVUsc56Ar6R7yei4OWNNn+SOEKNRaWt7evxoHHsxpZzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=l30U1H71UcMYJ6LwwkDjsO8dH6ApnFIMyzZZREg7NAw=;
 b=X20NsU1GabZ85I+TpAF9fqSPJGlbg0gY77HLR8oZBslk7wg8h5biqoa0l/FTtBIHSmJyedZy5RD2z3BPOMvaNRomfD3MoI5tUvBLQLyGmwUgmJ+oc2v9LQQ99zdbcc/pF5KHdJnwzpBvHW5cz6Fzycukppmwtg+Dm3oXHgb6PICRurc2HIucT69qCF4szCmsinaOA5qDmz2xLuayG/gH03lSOVsRi8KtluHbM1UsxFMe8sphnjcEl4fl+QBvJn5DvOQezvUvLBbmExxDQeq3ueah/JffFCB4nHVDbELV0UIUIJBp+b7RoEK2ljNCG17fMb3kjJLIpt1bWqetgjy6gg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=l30U1H71UcMYJ6LwwkDjsO8dH6ApnFIMyzZZREg7NAw=;
 b=fc4TRm7mPxhAnGrMoCNTPhimwfIi0Wq222SyEftkkwF9vYQa6BGjCAdkwUqadd4hWtIHife/FhdPEZSq2OdbPCuvzpH02cdBfCaBrWp6qX5TGtet+8PUxrhkp7dgBGCkn6PbIg35z3z9aFprK0x07F2GvE9mYOehZ3imzzyZJOc=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=silabs.com;
Received: from PH0PR11MB5657.namprd11.prod.outlook.com (2603:10b6:510:ee::19)
 by BY5PR11MB4040.namprd11.prod.outlook.com (2603:10b6:a03:186::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4888.10; Thu, 13 Jan
 2022 08:55:42 +0000
Received: from PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4]) by PH0PR11MB5657.namprd11.prod.outlook.com
 ([fe80::d031:da9e:71a:73e4%5]) with mapi id 15.20.4888.011; Thu, 13 Jan 2022
 08:55:42 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 02/31] staging: wfx: fix HIF API license
Date:   Thu, 13 Jan 2022 09:54:55 +0100
Message-Id: <20220113085524.1110708-3-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
References: <20220113085524.1110708-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SA0PR11CA0117.namprd11.prod.outlook.com
 (2603:10b6:806:d1::32) To PH0PR11MB5657.namprd11.prod.outlook.com
 (2603:10b6:510:ee::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 46af4525-a2e3-49d2-c60c-08d9d6727a79
X-MS-TrafficTypeDiagnostic: BY5PR11MB4040:EE_
X-Microsoft-Antispam-PRVS: <BY5PR11MB4040DE821ECCF91641D6F2C593539@BY5PR11MB4040.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: AZ3KjFcg+t96yasmM5stP7emdT09hBbUvz4z1GUB/+rZyppn03OGTQQAFP03zPIksFqxaJ4GYp9pBCOFifFodSwK0VbFhLzIOwlVAHTTyfehGH5W+IWeCS7sSYd+suhfEulZDPU9O3hCEQKc9FbLEEnm4xAwCdRw8cCmu4l6iGCJ0h18ttTQv7MlmhangAXK1Qclr0MQWRyXk2QQu8ofTPJL4G2cI+KR95AbIMx1mdACfvoDvPhnM9T3I0/UPUmu1gUuGYp43OQzcMINyYtQMiA4EfaEIQVT5GXpdv15F7aPyoceMMCsVrmhRoarBFMTYmwaLXX2fu5iRtN6Ns7foVGA/tAzgXOCYlEMUS6ITyXx+q06KskztumTj3E0LdUt/u8m3GqMNozymHSVp4SEBAz87+I/iMIJtUdlpVdzY9DY2dxyTCNoTWplh9qhAyXtzFGVPgUzWKOqkVu3Iu5DVWnXQyyE9kVFArMnzo4vC5qRFZ1fUekwhJV2oJJiYyqtEuX8A6o53096at7eoShjIZecco5x5tkn92s0fERYZnS84aQKHYwnoyj2emacTh3eJLxi5Do7q4382yxUIKkvJLDZ5YqIQNqkpP2aK9SJ+x0SyTcMcK9fKnlM7TSskDk5L6tTUSYydiHbIOugO4iD0w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR11MB5657.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6506007)(508600001)(186003)(38100700002)(4326008)(8936002)(6512007)(6666004)(66946007)(83380400001)(1076003)(2616005)(54906003)(86362001)(66556008)(2906002)(66476007)(316002)(52116002)(36756003)(5660300002)(8676002)(6486002)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QUVSWG9FejVSMS9MRkVCUnZGTXJvdytMc2EwSHFDY3JpQzM4UStCOVE0Ykh6?=
 =?utf-8?B?b0ZGNzJULzVTcXFLVUhrUnJFL3RHcWVqY3M1RDJXRDR4R3luSVFUM3EyNzIv?=
 =?utf-8?B?QkJiNUIwb2Q0VmlKL1JtcDF4alRCSmVacXhXaGdHbFFwUDJBaVQ0c003UWNi?=
 =?utf-8?B?RnRadEw5M1psRVJIcWdNRjVEOEd5Yno0RjlUNDhVc2hLRTcyYVdnZVZ1R3dM?=
 =?utf-8?B?aEFwZHJzSENoczRkWjB2RG1YOU5CWnk4dlg5RFNVQTBvd05VVVU5NkxTdVJz?=
 =?utf-8?B?bHVDK0NpcWNUb2tnNld5dERreHFWRHRhSFV3VDNYT3NHRzh3RzhmOXBVUnZC?=
 =?utf-8?B?bTdsa3dkeXBDZktneDJhS0REcFlPRGx3cndoRVFGemU0b1JTS0pGak9OYjFP?=
 =?utf-8?B?eXZkSTdXSHBBQ0U4QXZoVGlHeUhMRTZZWktrbUxYWEFFTGZLcnBKUnNoRVlE?=
 =?utf-8?B?WDU2ZzNZTTNuWGlHZU5FMU5iamk2S3BKM2puREZ1WEdsR1ZKamNYYWVrMk1j?=
 =?utf-8?B?cE5YSnpRTytoNysyVUhrWU9pQXR0OG4vZnJ0WGE2YUVKNG1oUGZuaHdJa0ZN?=
 =?utf-8?B?aHdtb0hpdXllVzY5MmZSYU9IcTFHaVhaL0hZM0w0S0dPdno5b3o1R2hLbkxJ?=
 =?utf-8?B?UEwwMytnb3h5VzRjTEJEdzg1N2Y0QnlYMk9nSlY4ZWNDTGhRODRqdzVpSEtC?=
 =?utf-8?B?VE4xY04wbHR4M0s1MWhZanB1OXNndlQra2RnNlpOSXVlMEl1VWRVdytSOVJt?=
 =?utf-8?B?WUNiN2JTbjVPTWdoY1NVcDkreUsvVlcrTzNSRWZacGdzdS9tbDF4OWJuTnFs?=
 =?utf-8?B?ZnJwRlJwcjdacDRhMG5uVEg5OE9OejVXS1pyRUo0cmhSWEhyLzJ2OTBWdnlT?=
 =?utf-8?B?WTR3dldlMThFQlkxUklWd3VMbUhwT1VTa0hhbnU1TDFHS0p2UmxYL1QzVnA4?=
 =?utf-8?B?TnFobmRZeWdqbG1aWkVsTmRreGFyejB6Ums4dVVEZVNKeUxPOXpicTdWSGxX?=
 =?utf-8?B?OHhjbDIyM29oVG5mdW40SzQ0eHV2OTFHQ2xqbWw2cU5qM05aUUwyQXp6OFhp?=
 =?utf-8?B?NWhrUU9ud3E0b1dXSlJJMlZrd25ROFhzQnRPbFVtRHI1SUR5a1RiQXZOOVR6?=
 =?utf-8?B?L0svNlJBS1R0M1ZkeWc5a0RlMC9wajk3U1F0aXRIbW5YZmZYVUNrSHROK01L?=
 =?utf-8?B?andTa2FLcTBIcXNwaWlKc09wSkFDbmxqSTEyblhKaytobXJ4NXcrcW5mbTBG?=
 =?utf-8?B?ZHo4M1ZoQm5ma0tkeVhGZTVuU1gvQ0NJK2pFaXlDQXhybGRMdkdEWUxUM2pM?=
 =?utf-8?B?TjlmZngyTDdXYmVGV2dJRWN5MkQ3YWdVMTNkNURDa1dpQm00ZUZabFlLR3I5?=
 =?utf-8?B?SUpYaDlwZnBwZzhwc1ppR3N3dDNQQjR1R0RsSWZOYTM1UCt3TDZzdFVvNmRN?=
 =?utf-8?B?REFjWHlCRlhqOG1SNkEzMW1MWVpYWi9QUTduTW5DeU10ZHJaTUFnZ1lkcVh6?=
 =?utf-8?B?K1pSVHlqQjJBQ0tlbjBYM3N2ZXpONGpWZjVSWWNZRU4vU1JzRGV6NEZnenRt?=
 =?utf-8?B?S0dFbmg0Vlo5NkR0RDlmWjBZNVZYekpXeEtBNTlBUVVHZ2JVRExpU21pNWx2?=
 =?utf-8?B?V0laRFhxclJHNmt2RERqaU9rTzdQdnB0aGdGMjBLVDJUeCtVdW1lMlZmNDJW?=
 =?utf-8?B?NGwyU05nZFhnb1ExaU5ITHlUTzFvUTdJWjJGQmQ0WnFNdEEzc212VzNGcW1u?=
 =?utf-8?B?VW80UlRLaG9Mekw5R1ZnQldzaVlOUGczWlh0MVhyZ3I4UENPWUNQNTJ6RXlH?=
 =?utf-8?B?ZWVyTHM5elVFb2NVMFJBVWUrdkZCNlo5NE9qbmc3dU1STm41WUdPQUFUMExC?=
 =?utf-8?B?ZFdsQmlCUnhDNENFemxacUhadHJDeU5wTW5pSFk1NjVoNVdndEdCWGpFemFJ?=
 =?utf-8?B?STBrZzRSZGpOdWIwb2MxSGcrQXRFQk4yaldENWY0TEtCU3pXMmxxYUtFaUlp?=
 =?utf-8?B?MU11aytJbEl2Q052L0dXVEZ1WDZ2aVFmaHZJV2YrdVlIc3NoeDJnVUNzaGg2?=
 =?utf-8?B?Um1VbkhSakEzc2V1UEkyOEg4elF0bzk0dzYzeG1YYm5qSlQzSG4vZ0tHTWNi?=
 =?utf-8?B?MkU4VS9CSTZ4RThjS2hHV2xscEs2TmRzWkVscmhlNG9lbEo1NU1YbjlZZG5n?=
 =?utf-8?B?R1Z5MUt1WERJY3BqRit1ZlRXZjJ6b3RudkNmeXUwR25VUDU3d2NmNXBTYnpI?=
 =?utf-8?Q?OgRpFHycKJFbOUnBhN6q8kXfUAqnoVA04YdKRxIb2k=3D?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46af4525-a2e3-49d2-c60c-08d9d6727a79
X-MS-Exchange-CrossTenant-AuthSource: PH0PR11MB5657.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2022 08:55:42.1396
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t42d1sonoPDmrMj9kIDmdI+TNmyuR0mDjU0YJTJM049P5JSXw8DdASouKHJVV+bVLyN9BXikt+NQRbO6L5Mzvw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR11MB4040
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQXBh
Y2hlLTIuMCBpcyBub3QgYWxsb3dlZCBpbiB0aGUga2VybmVsLgoKU2lnbmVkLW9mZi1ieTogSsOp
csO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMv
c3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCAgICAgfCAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl9hcGlfZ2VuZXJhbC5oIHwgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21p
Yi5oICAgICB8IDIgKy0KIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAzIGRlbGV0
aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaCBi
L2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaAppbmRleCBiMGFhMTNiMjNhNTEuLmIx
ODI5ZDAxYTVkOSAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2NtZC5o
CisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9jbWQuaApAQCAtMSw0ICsxLDQgQEAK
LS8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBBcGFjaGUtMi4wICovCisvKiBTUERYLUxpY2Vu
c2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5IG9yIEFwYWNoZS0yLjAgKi8KIC8qCiAgKiBXRjIw
MCBoYXJkd2FyZSBpbnRlcmZhY2UgZGVmaW5pdGlvbnMKICAqCmRpZmYgLS1naXQgYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
YXBpX2dlbmVyYWwuaAppbmRleCA1Zjc0ZjgyOWI3ZGYuLjNlNWM5MmUxMmQzNSAxMDA2NDQKLS0t
IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaAorKysgYi9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl9hcGlfZ2VuZXJhbC5oCkBAIC0xLDQgKzEsNCBAQAotLyogU1BEWC1MaWNl
bnNlLUlkZW50aWZpZXI6IEFwYWNoZS0yLjAgKi8KKy8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVy
OiBHUEwtMi4wLW9ubHkgb3IgQXBhY2hlLTIuMCAqLwogLyoKICAqIFdGMjAwIGhhcmR3YXJlIGlu
dGVyZmFjZSBkZWZpbml0aW9ucwogICoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93Zngv
aGlmX2FwaV9taWIuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaAppbmRleCBk
YTUzNGYyNDQ3NTcuLmJlNzZlMjc2Njg4MCAxMDA2NDQKLS0tIGEvZHJpdmVycy9zdGFnaW5nL3dm
eC9oaWZfYXBpX21pYi5oCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9taWIuaApA
QCAtMSw0ICsxLDQgQEAKLS8qIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBBcGFjaGUtMi4wICov
CisvKiBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5IG9yIEFwYWNoZS0yLjAg
Ki8KIC8qCiAgKiBXRjIwMCBoYXJkd2FyZSBpbnRlcmZhY2UgZGVmaW5pdGlvbnMKICAqCi0tIAoy
LjM0LjEKCg==
