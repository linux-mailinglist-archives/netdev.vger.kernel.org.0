Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CED09406F21
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbhIJQLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:11:21 -0400
Received: from mail-mw2nam10on2088.outbound.protection.outlook.com ([40.107.94.88]:56865
        "EHLO NAM10-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S232210AbhIJQJP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:09:15 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gtadyz3ujk3Ml2uVZr63mS0bnX4Axf47K95RYZB4Col/z6jd1XOdWnQxF8JG0w6uWsAzW/lnReemj3n1699o4j08aRHYGiLjI3XhRMBkUfARQDQ5S+IlAWbqMvjxBomHw1F2yO7tkORzLyedWE/3MDvWs5KAKYOH82OrAJBXoSSGDKKRE2F9vyU9hglPSOZNjP9DTS4oMafNZ960tn9R8lll4GuATsZVUV17dJ8GfQfLhPfFmPyb4Za0CRRut+MORqXnD+X2qjgFlApkgIjVafLnPShMAVexXLPfnfRmr4au/f6gzsJQewzkBL3LXqoyQrYvK0hgxSY4f2KIoZfIjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=5yO9jprjZNkhQCYRoSpaN34aTVyTrM/LB8hLxADBD2g=;
 b=Vaw37k1pgL+gmvlGCsULHfkeaaNY3dB6C+vYAwe3I85EasUlx11eOu09DEaoWThVKlC7oDi7mvraHvFSWEPj5Fj45nM9Iiku0y3MlmjKhHSlk6ZO/zigWLaqZLDyfatUxc+O0BfveGOxqux4SUN8nvhakheyKKN/zEitTX1s0kIpOV7d2JQefWWa4oUxfEy2sSpdBYXyejCbILJ3UtHE2Zl8U4qJhmOckcxAxEOCNUgM0oR8S3OlwSABJRYCl6nD53XMyvSF9XI1dMew5Aw5ci4rrI76ZxpPPWGkRkHswdLauW+/Xr8VNuyX200nRQ9mcEPSlwADfhZE/WBGb8D4KQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5yO9jprjZNkhQCYRoSpaN34aTVyTrM/LB8hLxADBD2g=;
 b=l/YBThAKrWPwmr8+ZwNnNiCWpHTqRj6rZNGGFoToyGkBF6SNCk71XK8iOsKYChfUoNF/zGZ9KA0iEOHbU8ccV/TN9H9ASXkb0GcZs/zWIpMWy+R+5Gt/dupVmmLciPFhWr0LhY76eRkF/jpJByq4uc2tVAW9o0yYrP0n0PdiMjI=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5002.namprd11.prod.outlook.com (2603:10b6:806:fb::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4478.25; Fri, 10 Sep
 2021 16:06:22 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:06:22 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 26/31] staging: wfx: reformat comment
Date:   Fri, 10 Sep 2021 18:04:59 +0200
Message-Id: <20210910160504.1794332-27-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b4c48ac6-fc56-42fd-b685-08d97474ee90
X-MS-TrafficTypeDiagnostic: SA2PR11MB5002:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB50022137A84B5310201EF90793D69@SA2PR11MB5002.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:551;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eHjvsVGC8OXeP8PJO7UhbEOIAVYp9C8BZhN6AfN6ohokhq35Ixosb6fIhGmle5M0iMJyotNHUS7qc+gu+crUE38TLnPiWjSnDlgmC/2pzLlmdGZIzwX0pBPPyy4kavHAQGqPDNc9b91KKO/kGDJPVjCpzVU1440Ycf+UkD/FlQJZ8cJ+7L6bVsmbbL8X2MgsqeoxuXpKbyS/glBz1NZYcatA/cxHcItoIpjiisRYNFY9IdDDMUB3sHMApNl6oHicOrBm0L5FD0J8onWvlBLkNYGGAiLvIz7vF/bmGU/1hW+ar6sNcNT5xjLdqO39N96ldEXtMVLZsSng8b3X9DUjoEMr4ANdbEpOQRzG9mqdsVyJhXDFFR5yvxbv5ydLpfSFa+T5km28PdJ66siid7RS/t2JzEAtZ6eh1aErf5B1vS75m4JsjmyWJ574U4bYnM0JtVleGSGl1CgnR8Ph8hwZajp6CJtT7UBxzUPno8yDIDk71fIGGb3ATxv5LqCk1eX+BIigKlJYSWRijVV/aExJoOAd+E9ONGNC0yqI4xI4veNOkAg8Z9UbhXlsQCwd5K604ttUwIaPY8D3S02T6qvUIFrcpkIPxqI08N43eMtrrnVS36NHZbnffFBb8Gwtc8yQwcmMMdHlIEt+n2NV08xbMg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(6486002)(52116002)(86362001)(38100700002)(8936002)(186003)(66574015)(7696005)(4326008)(508600001)(8676002)(4744005)(36756003)(2616005)(6666004)(66556008)(316002)(66476007)(83380400001)(54906003)(66946007)(2906002)(1076003)(107886003)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cmI1MU1Wcm5DVGgzOExPbTRzU0dUbDFKNUpJSWZydHl4YWkrRFBVL2UvNE55?=
 =?utf-8?B?UkdEN01yRmltcVRlaE5LYjk3QUYzSFo5ZEVQNXNjbFU1dVpFeU1zUFRxbzdL?=
 =?utf-8?B?Z2ZGYkdqUkQ1TVlJNkJRUDhUMVFYcFdRWllqb0hCTEo5NStYaE00bDV0MXMz?=
 =?utf-8?B?YnVabVlNZmVjUjB6aTBNa0RmZndHR0JMNSs4Q2FHdWVFNW9pakllRkYrb3NT?=
 =?utf-8?B?N2FWeU1oTG1rQVZ0aDZSaC9FSFN6ZnNpcUhpR1VYMWRGMFZtTktuVExROGN0?=
 =?utf-8?B?OGtaSVJUOCtHQ3ZEZExxR0xWZHFBL3dtZW81VEt4S2dKM2xwSTVOajBsdEw4?=
 =?utf-8?B?alcwa2RiRUM5TTBZVUpFa1ZrcFczN1hRTEQ1eU1GbTlvTDljR0Z0VXFJc1dr?=
 =?utf-8?B?OHZyUWthZ2hza3Yvc0VJcDNGc2RIa0xpYXdQK2x4NUwwdy85U3NQZlJTT05S?=
 =?utf-8?B?cmJXejh6MFhZOWViaWtRN0FUdVVkaTBVU3RYM0pZT2hLdHVZZml4MVc0eGVy?=
 =?utf-8?B?SlJEMkdxNGM1ZEpLQ3FKei9WcFppUmxZTXNQT0JCTm1uSWFITnNVbGZJdWNV?=
 =?utf-8?B?eEVUakpNSTgwUVFqU0V3TXRxQ0N5Y3BMdHdhOTZsaUN1TXRBb0ZrVmFmb3Z2?=
 =?utf-8?B?SndXRDQyTWo0cVpZN1htQ3d4TXphYmQrNjVLK0pVeWFNTC9aU1IzdzZQa0Ji?=
 =?utf-8?B?UjhUZEg1SXNGKzVrUHJGOXRXRVBJZ1dWb3QyUjcvSEtINUVPMnJ5K0dsRkJB?=
 =?utf-8?B?Zk52bEtGZ2RhTmV0Ry9QSkZQMHVJRTFybXVtdnJCMy9qMFdwczdxc01qWGhl?=
 =?utf-8?B?S1dRbVRKd29qdWlkY0ZQREt0dVMvKzl3dVAxMjY5Uk1HN0lKSzRVbjVONEFJ?=
 =?utf-8?B?ZzQzamZ6b0JWbzltdHRlVG5aYkRHNnNrdEZQOUx3NHNDNVh4cVFIMUZzSHJK?=
 =?utf-8?B?T2FZN2MwOTJpalFsa295dmJhRzlRdjdCSmVidGxiVHp3QTVaZnV4L0x5RE4r?=
 =?utf-8?B?ckJ1VFJBYXFzR2FIRW55OFBIVUFzTm1TVVdId0JZVHJnUG9PdENNTjZHdWtB?=
 =?utf-8?B?MS9RWTdzZkh6TEtkbllnOEFmN28zTzlyQTFDNnBsdmV3eFIzTUpXUFJIbmhB?=
 =?utf-8?B?aFVqMFZjV0JybUFSTW82ZzN3UWkzSHphTkZRWkxsbXU4YVZrY3J6QjFlSEdK?=
 =?utf-8?B?WVZkSmpSMkYvUXVkRk1LbndocTZndXFDNEhzUUpvS1FkcGVEN3ZDdGN3bXFH?=
 =?utf-8?B?WDROdFF2bVJFR1p3Q2ZsRWYxU0MrSG1CY1JRUVRqcGRncUlRL0xGZGNzNjRp?=
 =?utf-8?B?RU4vcHpYWGJQTVpwSk14bmlOQmtqZEpLVGVpam1KdDFwUXN4MVFsMmFoWnNm?=
 =?utf-8?B?TG5MMTQ1blpJSEVJZXlBM2ZRRmhrUkl3Z2VIYlJXVDJubUYyMUNPSUhkRjla?=
 =?utf-8?B?aWtFbGM1N0NkSlVhd1E0N0s2bXpCUHZ6KytkTkc2R3RPdmppdFRlTFlQZXAx?=
 =?utf-8?B?ekx4MDBEMEdTS3RpTjR3V04vVUtMTTgrc1R0OHdnSi9XSkhyVC9pUERyVlJk?=
 =?utf-8?B?UWVNeURlZFFRTnF6SG5xYVRsNDlUNUs0aVY4ajBOQUhBNEF5Z1dzUm1IVThC?=
 =?utf-8?B?NWV3YkZGU29pVmtzWFJQZEQvRUI0Ynd6V0srUWdoOFAzUnlodTJTUkdTNmMw?=
 =?utf-8?B?Ri9aZ3YvbFEyc295SlpUZitkeEhBSHI0QkJ2d1piV2J6b0VEakViZy9TbUxE?=
 =?utf-8?B?WEFYMURpcDc0VVhUKzRKN1hPRk9wcVpBVklxR3B0alVObFRKOUM4YmVOYlFC?=
 =?utf-8?B?V014WUV0VGhycG5HU3VGUU5RbWJ3MXZyejR5N0lOOWtVQm9vbTZoMWVSOUwr?=
 =?utf-8?Q?KPmZeo0jVLuC1?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b4c48ac6-fc56-42fd-b685-08d97474ee90
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:21.9514
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nf8YkzUUtfzzl7QM/BpLjwMKUXCbTJwrd6nYRxcPYD9iucJxfnRRNGkU52Z4FKfUO8VaIpzkjHxJF2wCpGFUwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5002
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IG5ldyBjb21tZW50IHRha2VzIG9ubHkgb25lIGxpbmUgaW5zdGVhZCBvZiB0aHJlZS4KClNpZ25l
ZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4K
LS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jIHwgNCArLS0tCiAxIGZpbGUgY2hhbmdlZCwg
MSBpbnNlcnRpb24oKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9zdGEuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKaW5kZXggZDY0NDc2YjQ4
ODgxLi4wZjQ4ZGFiMTA1ZTkgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMK
KysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9zdGEuYwpAQCAtNTk5LDkgKzU5OSw3IEBAIHN0YXRp
YyBpbnQgd2Z4X3VwZGF0ZV90aW0oc3RydWN0IHdmeF92aWYgKnd2aWYpCiAJdGltX3B0ciA9IHNr
Yi0+ZGF0YSArIHRpbV9vZmZzZXQ7CiAKIAlpZiAodGltX29mZnNldCAmJiB0aW1fbGVuZ3RoID49
IDYpIHsKLQkJLyogSWdub3JlIERUSU0gY291bnQgZnJvbSBtYWM4MDIxMToKLQkJICogZmlybXdh
cmUgaGFuZGxlcyBEVElNIGludGVybmFsbHkuCi0JCSAqLworCQkvKiBGaXJtd2FyZSBoYW5kbGVz
IERUSU0gY291bnRlciBpbnRlcm5hbGx5ICovCiAJCXRpbV9wdHJbMl0gPSAwOwogCiAJCS8qIFNl
dC9yZXNldCBhaWQwIGJpdCAqLwotLSAKMi4zMy4wCgo=
