Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2BCD406F10
	for <lists+netdev@lfdr.de>; Fri, 10 Sep 2021 18:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232776AbhIJQLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Sep 2021 12:11:03 -0400
Received: from mail-bn8nam11on2056.outbound.protection.outlook.com ([40.107.236.56]:31936
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S233050AbhIJQI7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Sep 2021 12:08:59 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NPKjQ5WXf/EeCL1r9Pn22BQCWK0SzREnVjo0V7/xNayXEUu+2su5v6FrNX4igaPGrzDEPnUiucnb48oHM9pFsyZaG1GAH4yv1k13cfiviaMnEAJ76Pk60F3mGW/TCzeGl2v6mV9hcIgBZmrpxrgHM0JrKdIS2HVpBp5+dc4a0Ge6UUNbbSu4At7UPw6w43xTQwwKp5eiMCzhPf9eh4VkghMNa6QiqwYU4HMQRKXdC5hnmnNH1rFXSvEWVGD+a7UA4FUuxb/aAkQT+NxL1Kezpi8DImAjx0eMBx/l1wHlcRu9XX8azv7mjUN0pErHOVB0Q1+vO5G6dQ4fssf743vNIQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=xN4+7gc0FnJx3MvoIvCbVWojWzEUHWgpv9NIeAgt6mU=;
 b=SY+2VLtfaNlKyzK3tzJmRtmsTmPvsz/i5gEBbEBb/6YYAh47SxaudynqrqSRbkT2hFyqPsh2htNcBR/JDVRimdh2EbC2HBPfGW3r4Rolh4tYqJ9b0Raf7lRUaGw7ws3XlRmCdtePy7ZH8vKMR99nYr/L7Ho8XeZ473dZYpGZAw2qw2v1Ah6vIaj3WMq0HJbdZaC2M84FiWm3LiPmoH0Kzyze9vvv4cUnMBbXW+OidALdyRJaWv63KZPbWaLjgrhA3oK7y41SmtjdiGxkjHQqB1F0XpOayW/6ppEmAdASkLE5sxv5dU32anyzVGYScRAS6jmUn5qJ/knljsRvrs6o6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xN4+7gc0FnJx3MvoIvCbVWojWzEUHWgpv9NIeAgt6mU=;
 b=U79gSkbPpXZHxHjPRXPCf+JNdTZLCa6xNEC618fTACCEOga/8NNgpJJ9/Rbg5fmziH2ctCVPiUkLt/+9/YkeQ54IP03ldq/BMAT+GWrTRo8R2CWO6FCPgnKaVRrG2aTVNBfxC+LUt7RmZ2VHWJp3mRmlSJep9/R7fXnWSbI8JTY=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SA2PR11MB5099.namprd11.prod.outlook.com (2603:10b6:806:f9::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.17; Fri, 10 Sep
 2021 16:07:00 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Fri, 10 Sep 2021
 16:07:00 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 31/31] staging: wfx: indent functions arguments
Date:   Fri, 10 Sep 2021 18:05:04 +0200
Message-Id: <20210910160504.1794332-32-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
References: <20210910160504.1794332-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: SN4PR0601CA0006.namprd06.prod.outlook.com
 (2603:10b6:803:2f::16) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (2a01:e34:ecb5:66a0:9876:e1d7:65be:d294) by SN4PR0601CA0006.namprd06.prod.outlook.com (2603:10b6:803:2f::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.15 via Frontend Transport; Fri, 10 Sep 2021 16:06:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4cd6e4b2-150e-4d82-7e1b-08d97474f447
X-MS-TrafficTypeDiagnostic: SA2PR11MB5099:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR11MB5099E9E6646DAC7F1632E54A93D69@SA2PR11MB5099.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:378;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OWPrUOMDWre9YfY3QGE1Ty9OJYN04Im6w6V4FTNWqAylM6wWgi/n0dEn3fRyttPIMcdtUEqvLQteH9O4n44kLDxU3PhOVIxJiYdJoB6HinPcKKZ1Sgk4gGv1PDZVaKeh/Wej5CUeud2u/jEIPY77EZlgcQARdkrka0gv94CTa66szanlafA+Yp1XaQ/VNFHFUfrv5ks0DHUjN6oc6CmqT7Ieb6wvKVWPitd+Ys1wHaHUyk6ryq8f0g4YLhfP0hWNw4J9z4vTf0YsObgIYLmREIIkT3JyhUsPMqq29ravkCArD0iXj4Q8pSf9L9wpShIHvIPpmuKodoGmBnKJKa1fp78t1qslIfo0nBOWRYTQUgAahWtS5VkpdhjINHtX6HL0DnMkMYhVKN5TLvG5U/k1QxnH9b/Bs+7u8TNcv1mtt+obXnEa39dudDS9cJeGRpQbaLGHc7cpnQPTDY1l+3ynohEXIKAM8ZPPgA1C3j9HANBrgDaAtlsMNHswkD3sYK3Qqhfo9YSZetitDca3pYZkLyBEwhdahcUvbh8Hvj1KYEpuTxKmdgIDZkvE0KXK2gnwW4tilxdH4vmoVPtfhY6FMik7927FBk4nkLQ+ZtIijhxk+0kSDAD5ymE6+B0LLx63Q9aYwrV+SosxMSb/mYyhnw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(39850400004)(396003)(136003)(346002)(83380400001)(316002)(66556008)(2906002)(6666004)(6486002)(86362001)(66946007)(54906003)(36756003)(1076003)(5660300002)(38100700002)(186003)(8936002)(2616005)(4326008)(8676002)(66476007)(478600001)(52116002)(7696005)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmduc0FhY0w5TGZhYXB4aG1vdEE5RXEycEM2UmcweHVkL0dpU1FOcGNhV253?=
 =?utf-8?B?S3hzSTlKWFJSMEVGczN3R0lWUWZJTDBUWTVPbVVXMzFtK1NadDMwaGFyVnlr?=
 =?utf-8?B?U3pFbm9ocG9oYThQYllDNE4rKzJGMld0ejI4YnA5TVM2aFhJc045bHRiUkZZ?=
 =?utf-8?B?bmYzL1lsNmlNUHdEcFFVUHZEVlRHMXNhbEVYWlpoa3QzTWtsbDl2TnI0a3Rh?=
 =?utf-8?B?WFI4UUJFbTlPcnd0cDVsbVNUVGs3eG4ycGp4bXk2Z2tueFJpTlJsL3phWndy?=
 =?utf-8?B?NWVXTmlUOHU2WmFwR2o4UVJQTmY3ZDRoUTk4ZVBoTUgyRTUrUldzNllzcTMz?=
 =?utf-8?B?K2c0QXpiMmpWc3EzNFRnbEVUUDltS1IvQ3ZZOTJBT0JTMUhHVTJiMVZsdStZ?=
 =?utf-8?B?WkFtVzBHaHpUU3JFZzRZY3ExWDBuZ0g1S2dRaHhsMEZ6RWFaeGtSTWYvd1Q3?=
 =?utf-8?B?Ri8rWFpyMjRVN3IxTjJscWFZdDlBSk51RUV5cHpsODB4cjF1UW9ld29sSGVr?=
 =?utf-8?B?cEY5VXpGUm1rWUdXaWhOZGVOQkVmaTkrRVkwcjZrb2VuQWVaQ2lHSXd5aWRP?=
 =?utf-8?B?Z1hKSkMyQUFNalhZazZJY0NRQXVRbzhpM2YzMC80a1BiaTZkVlRVeDRENTdw?=
 =?utf-8?B?UElJMzR4dXRBSGdJc25GOEs1UC8zRkZrK0R6MHZnMEVzTXR6K2pkYnZEdnhW?=
 =?utf-8?B?TmpnTzlPVnhhQ29JL3YrSzIrdkpnR1FRU2lLSWIvcFl0dGpSekhTYjFWeGho?=
 =?utf-8?B?alB6RnBSM3FpaFVOUVc2b2NWWFpTb2dzR0JIS2ZrK3NoUmZSNDN5N2RsZ1RY?=
 =?utf-8?B?dkx3Mk1McEpkeE52R09YNXgvY1VsOTh1MzZQQzBzM1Uwa3d5TGFPWENZRVhD?=
 =?utf-8?B?U1A4RXp5Y2FvM3ZDWnBINmpkRTl2WHZBcExrNmM4eFNQRTNuT3JaTWxEdVJ5?=
 =?utf-8?B?N2FkRTgxTEs0Y0pkaW96M2p0ekVYMFlwaXRoa214bHdjZzZ5emlHSkJUbmh2?=
 =?utf-8?B?UXpnSUJLTHp1U2tQVGhURWkwamliM0JTYnd4ZTFpNEQvRVB4a2R6VzdVZXhn?=
 =?utf-8?B?TUJvTWQrTndjWURiR0FrZ0FnNVFyeVQwOHZaaTZ2Q1l0SXhYNCtVTkVmeUJr?=
 =?utf-8?B?c1FKOHJPMXhKbmtKNHdjY3R6dEVuaTFtOG5oZ0NSOFlEZE9qMFdEdGg2OUtC?=
 =?utf-8?B?ODI5RGZDZWZTQUc2VTNkOGJaKzhMTjU3c3hvMENEK0NMMURxeHRhMnV0azlV?=
 =?utf-8?B?WG5EcmkwSXFTKytMc21GQVRQN2p3R1VFTVpycHRoSG5GTlp4TWJUNWRKc002?=
 =?utf-8?B?dmtBODIzNTJBLzh1NHpFL1YwR2RCTk91NWhiNmovM2UxTlZmdC9MbThxeHYw?=
 =?utf-8?B?d1JvZU4rNE82bFpiaFdscjFvd1ZZSitsOUI5cnQrdHBlNG9vekZKUitqUEhW?=
 =?utf-8?B?bGVXK0lDY0RUT2lwclVXZWFFS0NTQ3VXVUR0VDhUL1VKMStBNU5ZNnhIWVpR?=
 =?utf-8?B?blB0dVZGOUJGdyt3cFhkYXNtNFdReWt0cVM1RGpsS29ienNtYnlqZkxpdjV6?=
 =?utf-8?B?bHMyUjRQQ1hISXBwTUYvUVVOZmlCY1hBTUFQcHdHRllWclpCcC8vU3FWbWRq?=
 =?utf-8?B?OGVLRTdZLzZBRFAraTJ6NlRzY1J4QmlGanh4TE9OSTRHQ05meFEzZ1dscklK?=
 =?utf-8?B?Q0krMVM4N2JaUnNrUnNRT1pYM1gxeG83NWJnc2NNMDMzZGpFcGtEeGZVQTZH?=
 =?utf-8?B?RG01ZFFyd2VqSVZlR0h2UWVjTWFqNkFITXhEU2R6UDBWSWw2amNFTytYaTNo?=
 =?utf-8?B?QWlYUzZlYzVKb256SCtRS25OamxyZWoyZjdBaWsxeFZDVStseFMyOWFOY0Na?=
 =?utf-8?Q?Zq1b6n7dyRbpA?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4cd6e4b2-150e-4d82-7e1b-08d97474f447
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Sep 2021 16:06:31.5568
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: UzOTUTYpu/kLQcX7gdqFEdPBjHP0MG80UT1hUFrVLecN3CmhxFxWI0LnRuPSaFywgSqJDSQzzY8KNqEt5K7DPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB5099
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRnVu
Y3Rpb24gYXJndW1lbnRzIG11c3QgYmUgYWxpZ25lZCB3aXRoIGxlZnQgcGFyZW50aGVzaXMuIEFw
cGx5IHRoYXQKcnVsZS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUu
cG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIu
YyB8ICAyICstCiBkcml2ZXJzL3N0YWdpbmcvd2Z4L2tleS5jICAgICAgICB8IDI2ICsrKysrKysr
KysrKystLS0tLS0tLS0tLS0tCiAyIGZpbGVzIGNoYW5nZWQsIDE0IGluc2VydGlvbnMoKyksIDE0
IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMKaW5kZXggNDVlNTMxZDk5NmJk
Li45N2U5NjFlNmJjZjYgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21p
Yi5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jCkBAIC03NSw3ICs3NSw3
IEBAIGludCBoaWZfZ2V0X2NvdW50ZXJzX3RhYmxlKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBpbnQg
dmlmX2lkLAogCX0gZWxzZSB7CiAJCXJldHVybiBoaWZfcmVhZF9taWIod2RldiwgdmlmX2lkLAog
CQkJCSAgICBISUZfTUlCX0lEX0VYVEVOREVEX0NPVU5URVJTX1RBQkxFLCBhcmcsCi0JCQkJc2l6
ZW9mKHN0cnVjdCBoaWZfbWliX2V4dGVuZGVkX2NvdW50X3RhYmxlKSk7CisJCQkJICAgIHNpemVv
ZihzdHJ1Y3QgaGlmX21pYl9leHRlbmRlZF9jb3VudF90YWJsZSkpOwogCX0KIH0KIApkaWZmIC0t
Z2l0IGEvZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuYyBiL2RyaXZlcnMvc3RhZ2luZy93Zngva2V5
LmMKaW5kZXggNTFhNTI4MTAyMDE2Li42NTEzNGExNzQ2ODMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMv
c3RhZ2luZy93Zngva2V5LmMKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuYwpAQCAtMzEs
NyArMzEsNyBAQCBzdGF0aWMgdm9pZCB3ZnhfZnJlZV9rZXkoc3RydWN0IHdmeF9kZXYgKndkZXYs
IGludCBpZHgpCiB9CiAKIHN0YXRpYyB1OCBmaWxsX3dlcF9wYWlyKHN0cnVjdCBoaWZfd2VwX3Bh
aXJ3aXNlX2tleSAqbXNnLAotCQkJICAgICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXks
IHU4ICpwZWVyX2FkZHIpCisJCQlzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksIHU4ICpw
ZWVyX2FkZHIpCiB7CiAJV0FSTihrZXktPmtleWxlbiA+IHNpemVvZihtc2ctPmtleV9kYXRhKSwg
ImluY29uc2lzdGVudCBkYXRhIik7CiAJbXNnLT5rZXlfbGVuZ3RoID0ga2V5LT5rZXlsZW47CkBA
IC00MSw3ICs0MSw3IEBAIHN0YXRpYyB1OCBmaWxsX3dlcF9wYWlyKHN0cnVjdCBoaWZfd2VwX3Bh
aXJ3aXNlX2tleSAqbXNnLAogfQogCiBzdGF0aWMgdTggZmlsbF93ZXBfZ3JvdXAoc3RydWN0IGhp
Zl93ZXBfZ3JvdXBfa2V5ICptc2csCi0JCQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25m
ICprZXkpCisJCQkgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5KQogewogCVdBUk4oa2V5
LT5rZXlsZW4gPiBzaXplb2YobXNnLT5rZXlfZGF0YSksICJpbmNvbnNpc3RlbnQgZGF0YSIpOwog
CW1zZy0+a2V5X2lkID0ga2V5LT5rZXlpZHg7CkBAIC01MSw3ICs1MSw3IEBAIHN0YXRpYyB1OCBm
aWxsX3dlcF9ncm91cChzdHJ1Y3QgaGlmX3dlcF9ncm91cF9rZXkgKm1zZywKIH0KIAogc3RhdGlj
IHU4IGZpbGxfdGtpcF9wYWlyKHN0cnVjdCBoaWZfdGtpcF9wYWlyd2lzZV9rZXkgKm1zZywKLQkJ
CSAgICAgIHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSwgdTggKnBlZXJfYWRkcikKKwkJ
CSBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksIHU4ICpwZWVyX2FkZHIpCiB7CiAJdTgg
KmtleWJ1ZiA9IGtleS0+a2V5OwogCkBAIC02OCw5ICs2OCw5IEBAIHN0YXRpYyB1OCBmaWxsX3Rr
aXBfcGFpcihzdHJ1Y3QgaGlmX3RraXBfcGFpcndpc2Vfa2V5ICptc2csCiB9CiAKIHN0YXRpYyB1
OCBmaWxsX3RraXBfZ3JvdXAoc3RydWN0IGhpZl90a2lwX2dyb3VwX2tleSAqbXNnLAotCQkJICAg
ICAgIHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSwKLQkJCSAgICAgICBzdHJ1Y3QgaWVl
ZTgwMjExX2tleV9zZXEgKnNlcSwKLQkJCSAgICAgICBlbnVtIG5sODAyMTFfaWZ0eXBlIGlmdHlw
ZSkKKwkJCSAgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LAorCQkJICBzdHJ1Y3QgaWVl
ZTgwMjExX2tleV9zZXEgKnNlcSwKKwkJCSAgZW51bSBubDgwMjExX2lmdHlwZSBpZnR5cGUpCiB7
CiAJdTggKmtleWJ1ZiA9IGtleS0+a2V5OwogCkBAIC05Myw3ICs5Myw3IEBAIHN0YXRpYyB1OCBm
aWxsX3RraXBfZ3JvdXAoc3RydWN0IGhpZl90a2lwX2dyb3VwX2tleSAqbXNnLAogfQogCiBzdGF0
aWMgdTggZmlsbF9jY21wX3BhaXIoc3RydWN0IGhpZl9hZXNfcGFpcndpc2Vfa2V5ICptc2csCi0J
CQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksIHU4ICpwZWVyX2FkZHIpCisJ
CQkgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1OCAqcGVlcl9hZGRyKQogewogCVdB
Uk4oa2V5LT5rZXlsZW4gIT0gc2l6ZW9mKG1zZy0+YWVzX2tleV9kYXRhKSwgImluY29uc2lzdGVu
dCBkYXRhIik7CiAJZXRoZXJfYWRkcl9jb3B5KG1zZy0+cGVlcl9hZGRyZXNzLCBwZWVyX2FkZHIp
OwpAQCAtMTAyLDggKzEwMiw4IEBAIHN0YXRpYyB1OCBmaWxsX2NjbXBfcGFpcihzdHJ1Y3QgaGlm
X2Flc19wYWlyd2lzZV9rZXkgKm1zZywKIH0KIAogc3RhdGljIHU4IGZpbGxfY2NtcF9ncm91cChz
dHJ1Y3QgaGlmX2Flc19ncm91cF9rZXkgKm1zZywKLQkJCSAgICAgICBzdHJ1Y3QgaWVlZTgwMjEx
X2tleV9jb25mICprZXksCi0JCQkgICAgICAgc3RydWN0IGllZWU4MDIxMV9rZXlfc2VxICpzZXEp
CisJCQkgIHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSwKKwkJCSAgc3RydWN0IGllZWU4
MDIxMV9rZXlfc2VxICpzZXEpCiB7CiAJV0FSTihrZXktPmtleWxlbiAhPSBzaXplb2YobXNnLT5h
ZXNfa2V5X2RhdGEpLCAiaW5jb25zaXN0ZW50IGRhdGEiKTsKIAltZW1jcHkobXNnLT5hZXNfa2V5
X2RhdGEsIGtleS0+a2V5LCBrZXktPmtleWxlbik7CkBAIC0xMTQsNyArMTE0LDcgQEAgc3RhdGlj
IHU4IGZpbGxfY2NtcF9ncm91cChzdHJ1Y3QgaGlmX2Flc19ncm91cF9rZXkgKm1zZywKIH0KIAog
c3RhdGljIHU4IGZpbGxfc21zNF9wYWlyKHN0cnVjdCBoaWZfd2FwaV9wYWlyd2lzZV9rZXkgKm1z
ZywKLQkJCSAgICAgIHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSwgdTggKnBlZXJfYWRk
cikKKwkJCSBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksIHU4ICpwZWVyX2FkZHIpCiB7
CiAJdTggKmtleWJ1ZiA9IGtleS0+a2V5OwogCkBAIC0xMjksNyArMTI5LDcgQEAgc3RhdGljIHU4
IGZpbGxfc21zNF9wYWlyKHN0cnVjdCBoaWZfd2FwaV9wYWlyd2lzZV9rZXkgKm1zZywKIH0KIAog
c3RhdGljIHU4IGZpbGxfc21zNF9ncm91cChzdHJ1Y3QgaGlmX3dhcGlfZ3JvdXBfa2V5ICptc2cs
Ci0JCQkgICAgICAgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5KQorCQkJICBzdHJ1Y3Qg
aWVlZTgwMjExX2tleV9jb25mICprZXkpCiB7CiAJdTggKmtleWJ1ZiA9IGtleS0+a2V5OwogCkBA
IC0xNDMsOCArMTQzLDggQEAgc3RhdGljIHU4IGZpbGxfc21zNF9ncm91cChzdHJ1Y3QgaGlmX3dh
cGlfZ3JvdXBfa2V5ICptc2csCiB9CiAKIHN0YXRpYyB1OCBmaWxsX2Flc19jbWFjX2dyb3VwKHN0
cnVjdCBoaWZfaWd0a19ncm91cF9rZXkgKm1zZywKLQkJCQkgICBzdHJ1Y3QgaWVlZTgwMjExX2tl
eV9jb25mICprZXksCi0JCQkJICAgc3RydWN0IGllZWU4MDIxMV9rZXlfc2VxICpzZXEpCisJCQkg
ICAgICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksCisJCQkgICAgICBzdHJ1Y3QgaWVl
ZTgwMjExX2tleV9zZXEgKnNlcSkKIHsKIAlXQVJOKGtleS0+a2V5bGVuICE9IHNpemVvZihtc2ct
PmlndGtfa2V5X2RhdGEpLCAiaW5jb25zaXN0ZW50IGRhdGEiKTsKIAltZW1jcHkobXNnLT5pZ3Rr
X2tleV9kYXRhLCBrZXktPmtleSwga2V5LT5rZXlsZW4pOwotLSAKMi4zMy4wCgo=
