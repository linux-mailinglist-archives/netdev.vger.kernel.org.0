Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 460EC4086E7
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:34:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238208AbhIMIfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:35:31 -0400
Received: from mail-mw2nam08on2066.outbound.protection.outlook.com ([40.107.101.66]:47168
        "EHLO NAM04-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238667AbhIMIeq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:34:46 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=a3w5m9eItJ8a9XOVx7CUOpZMIq/72lAe92GIYUANNvrVNDb+yTLvYY6AwfkTC7ExcFFwCfPdYW8nTh5ipkyybJoFn11UgI5/RZ/QW7VGUt4YaG9XjErXl5EwBfmg6pDg5W2vef+wKE8qw0+DYXVQW9acc3X8G193mVOA0kHI8U32ciN4rfAXBQFRQGjgIg4JLg6/IEKBlyXNVCc1fvdgUWDUfzT1j3ErP5RjsPX8J6kXQL6sq00u6tIEnvYjAzpYC0D6YRbKwexIcWpeLTOVR3DXNpIYWo4EIcM4cVf2xtVxqn/P4NxNMLTYydknNNk0ecPBg6Bfdt44yadi/A1X7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=D/nDiHmFKBga19SVvGURvJf4nlMmkEyaiImUJbEKvFU=;
 b=lXykPrBepxzEcZmXT4vGoGN9U1XxYNuYLt1beErJ1JqdmXgROvUeopHKttIemv+oOHL3Iis6I6FmxmMDGwHcxdsZXkzMo2XJBWwDP6cwzyyqHKDFohtqwcdIk9nnEL88+gPxBKVohH3SEJUyQEJW2BXicB0uRdo3s4OuyMbja0gMHKHivJD3t1S+AADd4aRuiOn4u3eVK2cGDx7M97CnVVypXzr29gno+kpjIIJMDmLYkb4c0MjW22AUFezOxv55RD25JQDDbM80BLJWlR2hdhjEHz/fK9DwIQYX1G790dAjCbg7Fq/dF4tTA9hrjAkkYNb/P1k7Zs5pPeq0P6GD8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=D/nDiHmFKBga19SVvGURvJf4nlMmkEyaiImUJbEKvFU=;
 b=DUDJyvnlC2aodXLrwo5I3/vf9aCPAI4SSaf1MNoDGrn9R0W3NMx5YW8nzAb22Ih1zJR1Up3jAzSqWR84Mjj6Ni9jDCOEJJShMo10CQuVA5W88iS4XGdgUvEynSPpLvCZDzNE/9qk502SUHWL+CYUuI8PZBaBmS2tViUz6P7uVaU=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2717.namprd11.prod.outlook.com (2603:10b6:805:60::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 08:32:32 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:32:32 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 31/33] staging: wfx: indent functions arguments
Date:   Mon, 13 Sep 2021 10:30:43 +0200
Message-Id: <20210913083045.1881321-32-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3579c8be-01d2-495f-0ed8-08d97690f4b3
X-MS-TrafficTypeDiagnostic: SN6PR11MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2717B2A380B40D728E7083B593D99@SN6PR11MB2717.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:378;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: b4gFu4n+YIFqgU58MhwxSNhuEmU+4ehypM6uo5uHavhg/DNovr2LStyYsfhTxCS535sNXhvuXuFjoLXArdWGyQdJmxsHRQNUMPQWmmlAX6XfxmC8EoSntn9A07umFg/+49IC43grWjh5wKKgdXSpYg/dFR6TQDZHXw2Lpa36PBNqoYCdJTkSsBufGMFXUduTw2kDCh6ZJI8nzGt18gz0QXaXc7NNwYvN9Xeo6UvAYtnijONjNbSUeJ4kDTKhr3mOGma9rFJsSZCgpvU0pVNsO0b8CIZaTfeOOvy/nnIvRiabhADpi6I5RlFcYpA1icEjSA2WULY2QLWHUAzlE0K9oqsQ+b7PONYFT8PphitpcpnSVO9WFI8KnXoMDUBC5wYpJhYNcqFu/C6OOCpzf3ipCexcez8/LZXQxBYW7n8Vwuy2iQmyv0pSs/UA5YpkxrMMmWIaBd95EGez8RTMBPFLh7P33w3jD2DULvaiqNii9ZY/g4DuXnK4i4sg5MPFGMGGgBuqxEuiBDNQviT5EDD8wZvt+91QzOlfSJmogCn2oDHdNJ+ZBmsr364//dceVqG5kXy2lEQHKtwAJ+Yx1NdsdmqddO1vqdUc9P14uSYLBWsGhZGr9h9uoyLy4ozTxtD5WyNBNwn/TKm5E3SWSB3YB7X04TK1WHRH5mZvqp1XWLuVBjFaMX/Un6yGteKX96NvfUmTLl2vbPNx9+x7BNDbHw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(107886003)(26005)(66946007)(38100700002)(52116002)(7696005)(1076003)(956004)(36756003)(316002)(8676002)(38350700002)(186003)(8936002)(83380400001)(54906003)(66556008)(66476007)(508600001)(6486002)(5660300002)(6666004)(86362001)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cFE3c0JmYVlzaE5CZ2JRN09EWldmV2lVYXZFZHJBdWNuemdKMllvK3ozend3?=
 =?utf-8?B?b0lIYXZXakdYcWEwajdvNUxVNnc4REJ0S25NTTd4WEFEdlFhK1orUlVyeXJ1?=
 =?utf-8?B?SStFMGhPZk9oc2pNamNJeWhsaFNIRHhlY2VuQ1hobzVTdk9ueE5sS1pDb3lk?=
 =?utf-8?B?ZVNLczNlWDRZdjNueU53Tzl5c3NOSFZnbWpodStyVThjSDNnTDE5QVdGTWps?=
 =?utf-8?B?WnB5Z2hDYVppc2FHQi9INjlmQkppOEN2VGZEL1BzRXRqRXZCSnEwL054aXVN?=
 =?utf-8?B?MlBjM1hZdERxMklLRk1VOUVrNWJWeGowUFZGZUVaSkd5OXhrU1IyNXlVSGRS?=
 =?utf-8?B?dFpXdmNjTXV6dXVCTmxaNytIeFRmQzBWK0RPOVpuNGVjWUtESkFyUmxqc2pj?=
 =?utf-8?B?WXoxY3hIK3V3WUU3MmI3T3NCSkU1N2xyWU9WT2ZCNC81dDRWRk1GVUlScGtE?=
 =?utf-8?B?Q1B2a21DYWRwRktwTHdJNVlRTzJlTTU4TVJNS01mTnpRNWxZM3poRHo3QURN?=
 =?utf-8?B?Q2Ewa3Y2Z21vMmplcUs2dEpDb0UvaHRGc2owZzE2eThVbzZCS2t5Qm91ZzZX?=
 =?utf-8?B?TGFPQ1RSeW5TK2JsNlFaNVVLZ0svQWErM3ZyQmdUOWFQem5oUUg3RTEvdHpN?=
 =?utf-8?B?MWRXLzZTVi82azV3MDFiVkFkaG1lSmRPV2VseGpaSTlUZ1FhRy92RXZ5ZFJY?=
 =?utf-8?B?Q3ZCNG81T1pSREUwbXl1RUhDTnFQNlhEWVozUG5wVnBIYWZDVDl0QXVXTExt?=
 =?utf-8?B?dnJZdkdSR1pUZDVPWTBKbXB4STBKS2U3N28rY1Nkd1VCOCtvempvQ0Y1VTA5?=
 =?utf-8?B?S1BnUW1ZbUVweUt2NGJ2ODRPTUxwck1hTjd0WFdrU1RZZWlYcHdqdjhHUk1t?=
 =?utf-8?B?Ti8wWDdrdGVIamF5Z3Z6TmJ1VllkckVvcmRBV1ZBNzlZSEpaeXBZRFlrWGNB?=
 =?utf-8?B?V0ptL0JpUkxKNFVDUmdvdkoyQXhkdzM5dmlmTmtzWTdpbUpKYWExTWVyQndI?=
 =?utf-8?B?Q1JwWVdib3gzS1RjVFpTeFUzalJUVHlSRnlMdkg3YzJ0YWIwSExlVHdIWmND?=
 =?utf-8?B?Q1k5QytOR0xuaU1HV1Z1SGZlMEVTQThVWFc5MzlQa3pQcnp6ck1sdDVSWGRp?=
 =?utf-8?B?bDczbkpKS3NqUDlEZ2JZdWtkSTZnUksySjJjYnE0UnpvTzBZRDdnWDBub3JM?=
 =?utf-8?B?akFDYW1leEUvQlE1cStIbXpzUURrWkpXdjBjU0ppZ3lZZzRqSkdaUDB5d2Mz?=
 =?utf-8?B?TldCYm9iazRJN1VhcGcvS3lKMlJWYSsrbkRxcUJibEZ5VnBRMzRoYVdreHJ2?=
 =?utf-8?B?VjRUbDVKYUl2eTMvQXZQYTZ0eWNZK1ozWWFpU0g3TUdJbTFJQjEwVVRtQUhi?=
 =?utf-8?B?YytLaU1CcWdqeVZYSWlPT0F5NUozRUUya21Dam5RRlkxMmRZQWZQN1VPeTZE?=
 =?utf-8?B?bnBEY2ZlQ3k0TzJFaDNZTUh2LzRXdVI0UkY2SXR4cVlJUmZYWUNueEtObWI0?=
 =?utf-8?B?d3VyQWZXanNzcFpSamdzOFVqbVFGY2hRVHhVUmNBVHhBTXluMEcxQk1ZQTdx?=
 =?utf-8?B?bDZ3d1J6RVZpeHpUYlZIVEJUS1lzVkNMa1lreSszSUFuTjVYREdqNG1zTG1u?=
 =?utf-8?B?QW9tRnd3M25JYThOREtDeEk3d2h4U0QvRm9BK1o4MjNreW9TN3FsRlczTUE4?=
 =?utf-8?B?ZUdoOUFReTZMcmhrbUE3eWRkVzJtazJiRWszQTNIZWFnMTVGZjR2cW5JejNz?=
 =?utf-8?Q?aRoHYa+lQLlU2eOENhAwYN/9zKt9hOLdLMJGGG3?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3579c8be-01d2-495f-0ed8-08d97690f4b3
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:32:00.3598
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r9PDQcj8+yIqWRFA6gBnMkWDbvQddw4LXSQVB1oVh03/tpLkEFKVxmsRRBjlzsFqKIor2YBYcAs/GXU2kHnzoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRnVu
Y3Rpb24gYXJndW1lbnRzIG11c3QgYmUgYWxpZ25lZCB3aXRoIGZpcnN0IGFyZ3VtZW50LiBBcHBs
eSB0aGF0CnJ1bGUuCgpTaWduZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBv
dWlsbGVyQHNpbGFicy5jb20+Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfdHhfbWliLmMg
fCAgMiArLQogZHJpdmVycy9zdGFnaW5nL3dmeC9rZXkuYyAgICAgICAgfCAyNiArKysrKysrKysr
KysrLS0tLS0tLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxNCBpbnNlcnRpb25zKCspLCAxNCBk
ZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIu
YyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX3R4X21pYi5jCmluZGV4IDQ1ZTUzMWQ5OTZiZC4u
OTdlOTYxZTZiY2Y2IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIu
YworKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hpZl90eF9taWIuYwpAQCAtNzUsNyArNzUsNyBA
QCBpbnQgaGlmX2dldF9jb3VudGVyc190YWJsZShzdHJ1Y3Qgd2Z4X2RldiAqd2RldiwgaW50IHZp
Zl9pZCwKIAl9IGVsc2UgewogCQlyZXR1cm4gaGlmX3JlYWRfbWliKHdkZXYsIHZpZl9pZCwKIAkJ
CQkgICAgSElGX01JQl9JRF9FWFRFTkRFRF9DT1VOVEVSU19UQUJMRSwgYXJnLAotCQkJCXNpemVv
ZihzdHJ1Y3QgaGlmX21pYl9leHRlbmRlZF9jb3VudF90YWJsZSkpOworCQkJCSAgICBzaXplb2Yo
c3RydWN0IGhpZl9taWJfZXh0ZW5kZWRfY291bnRfdGFibGUpKTsKIAl9CiB9CiAKZGlmZiAtLWdp
dCBhL2RyaXZlcnMvc3RhZ2luZy93Zngva2V5LmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2tleS5j
CmluZGV4IDUxYTUyODEwMjAxNi4uNjUxMzRhMTc0NjgzIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2tleS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngva2V5LmMKQEAgLTMxLDcg
KzMxLDcgQEAgc3RhdGljIHZvaWQgd2Z4X2ZyZWVfa2V5KHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LCBp
bnQgaWR4KQogfQogCiBzdGF0aWMgdTggZmlsbF93ZXBfcGFpcihzdHJ1Y3QgaGlmX3dlcF9wYWly
d2lzZV9rZXkgKm1zZywKLQkJCSAgICAgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1
OCAqcGVlcl9hZGRyKQorCQkJc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1OCAqcGVl
cl9hZGRyKQogewogCVdBUk4oa2V5LT5rZXlsZW4gPiBzaXplb2YobXNnLT5rZXlfZGF0YSksICJp
bmNvbnNpc3RlbnQgZGF0YSIpOwogCW1zZy0+a2V5X2xlbmd0aCA9IGtleS0+a2V5bGVuOwpAQCAt
NDEsNyArNDEsNyBAQCBzdGF0aWMgdTggZmlsbF93ZXBfcGFpcihzdHJ1Y3QgaGlmX3dlcF9wYWly
d2lzZV9rZXkgKm1zZywKIH0KIAogc3RhdGljIHU4IGZpbGxfd2VwX2dyb3VwKHN0cnVjdCBoaWZf
d2VwX2dyb3VwX2tleSAqbXNnLAotCQkJICAgICAgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAq
a2V5KQorCQkJIHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSkKIHsKIAlXQVJOKGtleS0+
a2V5bGVuID4gc2l6ZW9mKG1zZy0+a2V5X2RhdGEpLCAiaW5jb25zaXN0ZW50IGRhdGEiKTsKIAlt
c2ctPmtleV9pZCA9IGtleS0+a2V5aWR4OwpAQCAtNTEsNyArNTEsNyBAQCBzdGF0aWMgdTggZmls
bF93ZXBfZ3JvdXAoc3RydWN0IGhpZl93ZXBfZ3JvdXBfa2V5ICptc2csCiB9CiAKIHN0YXRpYyB1
OCBmaWxsX3RraXBfcGFpcihzdHJ1Y3QgaGlmX3RraXBfcGFpcndpc2Vfa2V5ICptc2csCi0JCQkg
ICAgICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksIHU4ICpwZWVyX2FkZHIpCisJCQkg
c3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1OCAqcGVlcl9hZGRyKQogewogCXU4ICpr
ZXlidWYgPSBrZXktPmtleTsKIApAQCAtNjgsOSArNjgsOSBAQCBzdGF0aWMgdTggZmlsbF90a2lw
X3BhaXIoc3RydWN0IGhpZl90a2lwX3BhaXJ3aXNlX2tleSAqbXNnLAogfQogCiBzdGF0aWMgdTgg
ZmlsbF90a2lwX2dyb3VwKHN0cnVjdCBoaWZfdGtpcF9ncm91cF9rZXkgKm1zZywKLQkJCSAgICAg
ICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksCi0JCQkgICAgICAgc3RydWN0IGllZWU4
MDIxMV9rZXlfc2VxICpzZXEsCi0JCQkgICAgICAgZW51bSBubDgwMjExX2lmdHlwZSBpZnR5cGUp
CisJCQkgIHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSwKKwkJCSAgc3RydWN0IGllZWU4
MDIxMV9rZXlfc2VxICpzZXEsCisJCQkgIGVudW0gbmw4MDIxMV9pZnR5cGUgaWZ0eXBlKQogewog
CXU4ICprZXlidWYgPSBrZXktPmtleTsKIApAQCAtOTMsNyArOTMsNyBAQCBzdGF0aWMgdTggZmls
bF90a2lwX2dyb3VwKHN0cnVjdCBoaWZfdGtpcF9ncm91cF9rZXkgKm1zZywKIH0KIAogc3RhdGlj
IHU4IGZpbGxfY2NtcF9wYWlyKHN0cnVjdCBoaWZfYWVzX3BhaXJ3aXNlX2tleSAqbXNnLAotCQkJ
ICAgICAgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1OCAqcGVlcl9hZGRyKQorCQkJ
IHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSwgdTggKnBlZXJfYWRkcikKIHsKIAlXQVJO
KGtleS0+a2V5bGVuICE9IHNpemVvZihtc2ctPmFlc19rZXlfZGF0YSksICJpbmNvbnNpc3RlbnQg
ZGF0YSIpOwogCWV0aGVyX2FkZHJfY29weShtc2ctPnBlZXJfYWRkcmVzcywgcGVlcl9hZGRyKTsK
QEAgLTEwMiw4ICsxMDIsOCBAQCBzdGF0aWMgdTggZmlsbF9jY21wX3BhaXIoc3RydWN0IGhpZl9h
ZXNfcGFpcndpc2Vfa2V5ICptc2csCiB9CiAKIHN0YXRpYyB1OCBmaWxsX2NjbXBfZ3JvdXAoc3Ry
dWN0IGhpZl9hZXNfZ3JvdXBfa2V5ICptc2csCi0JCQkgICAgICAgc3RydWN0IGllZWU4MDIxMV9r
ZXlfY29uZiAqa2V5LAotCQkJICAgICAgIHN0cnVjdCBpZWVlODAyMTFfa2V5X3NlcSAqc2VxKQor
CQkJICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksCisJCQkgIHN0cnVjdCBpZWVlODAy
MTFfa2V5X3NlcSAqc2VxKQogewogCVdBUk4oa2V5LT5rZXlsZW4gIT0gc2l6ZW9mKG1zZy0+YWVz
X2tleV9kYXRhKSwgImluY29uc2lzdGVudCBkYXRhIik7CiAJbWVtY3B5KG1zZy0+YWVzX2tleV9k
YXRhLCBrZXktPmtleSwga2V5LT5rZXlsZW4pOwpAQCAtMTE0LDcgKzExNCw3IEBAIHN0YXRpYyB1
OCBmaWxsX2NjbXBfZ3JvdXAoc3RydWN0IGhpZl9hZXNfZ3JvdXBfa2V5ICptc2csCiB9CiAKIHN0
YXRpYyB1OCBmaWxsX3NtczRfcGFpcihzdHJ1Y3QgaGlmX3dhcGlfcGFpcndpc2Vfa2V5ICptc2cs
Ci0JCQkgICAgICBzdHJ1Y3QgaWVlZTgwMjExX2tleV9jb25mICprZXksIHU4ICpwZWVyX2FkZHIp
CisJCQkgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LCB1OCAqcGVlcl9hZGRyKQogewog
CXU4ICprZXlidWYgPSBrZXktPmtleTsKIApAQCAtMTI5LDcgKzEyOSw3IEBAIHN0YXRpYyB1OCBm
aWxsX3NtczRfcGFpcihzdHJ1Y3QgaGlmX3dhcGlfcGFpcndpc2Vfa2V5ICptc2csCiB9CiAKIHN0
YXRpYyB1OCBmaWxsX3NtczRfZ3JvdXAoc3RydWN0IGhpZl93YXBpX2dyb3VwX2tleSAqbXNnLAot
CQkJICAgICAgIHN0cnVjdCBpZWVlODAyMTFfa2V5X2NvbmYgKmtleSkKKwkJCSAgc3RydWN0IGll
ZWU4MDIxMV9rZXlfY29uZiAqa2V5KQogewogCXU4ICprZXlidWYgPSBrZXktPmtleTsKIApAQCAt
MTQzLDggKzE0Myw4IEBAIHN0YXRpYyB1OCBmaWxsX3NtczRfZ3JvdXAoc3RydWN0IGhpZl93YXBp
X2dyb3VwX2tleSAqbXNnLAogfQogCiBzdGF0aWMgdTggZmlsbF9hZXNfY21hY19ncm91cChzdHJ1
Y3QgaGlmX2lndGtfZ3JvdXBfa2V5ICptc2csCi0JCQkJICAgc3RydWN0IGllZWU4MDIxMV9rZXlf
Y29uZiAqa2V5LAotCQkJCSAgIHN0cnVjdCBpZWVlODAyMTFfa2V5X3NlcSAqc2VxKQorCQkJICAg
ICAgc3RydWN0IGllZWU4MDIxMV9rZXlfY29uZiAqa2V5LAorCQkJICAgICAgc3RydWN0IGllZWU4
MDIxMV9rZXlfc2VxICpzZXEpCiB7CiAJV0FSTihrZXktPmtleWxlbiAhPSBzaXplb2YobXNnLT5p
Z3RrX2tleV9kYXRhKSwgImluY29uc2lzdGVudCBkYXRhIik7CiAJbWVtY3B5KG1zZy0+aWd0a19r
ZXlfZGF0YSwga2V5LT5rZXksIGtleS0+a2V5bGVuKTsKLS0gCjIuMzMuMAoK
