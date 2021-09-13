Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9D34086FE
	for <lists+netdev@lfdr.de>; Mon, 13 Sep 2021 10:36:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238319AbhIMIeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Sep 2021 04:34:06 -0400
Received: from mail-mw2nam12on2084.outbound.protection.outlook.com ([40.107.244.84]:62366
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238265AbhIMIdT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 Sep 2021 04:33:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=aMtLxSlBkwhKdEq2mkSYaYenzNfBRRjdyMuln2TgjKS0LnSnpNstctSWgCtbukKqbC2h1PV4bLNj6ZelbQWzEuBfswCeIX2PjiJS47yCKPrr2+XVxshD+wLaopmjODaV/U6zfQVWvD+h5ncRu5aneujYwAd4WwDfYWNKE/g/f7th98/+bWu2gVrAtnL8BLNmyd2+p7damn4NNeyvWUeAU2L+LzhMbzkEghrK1vILtzGMOuVuSWawERIt32xITuKEMDdqFlcKlxfdd9Xygh4sAmw4Di+0swxLxO1TagNFzE788NdkzCvv5C9bdNBk/E7xFp7yP5jS+E4tUuanpZh93Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=HcjC0x4GRAxwfKkA5UMWXqZtFAOXbrjpXeRYZIftO60=;
 b=ORTlXl5e7l8t2oTpJBja2pVMMCVotv6lCGq+fAVDky4HPQ7z6IpgNp8yGRXzC06AkR5Aw/DjNvZ54UWN9WB8GmJ/GLUNif2P6JAylmmUEhEoJkWSqRspsZ6BkpTN0ssa3X4JohUprDiGm4UCQlODxpi0TJz/AAScveZLa2Eq3gM3wNmVTrMmqNQ1UF6rkMe0Q09laDSUdWP2fHm0xGZ5mko1fdcWVtyMEP+UvE5vOFDxPLbLjTIV0/jqQEjHhYlTNnaLDzPA3efgTrBZ+ATxjP7OJ9Z+tfCC0czsugsB9xOHaEpAUOPJbd36BP3CnF6Hr2/mhmtdBKfQ9t01Xjw9Dg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HcjC0x4GRAxwfKkA5UMWXqZtFAOXbrjpXeRYZIftO60=;
 b=kfUwQABpihYsUrpyYO7vdylGzZwQ7Mwy5uL/FN7p4nGWYoYz8UuJXfCYhPhTFBgeN0Odn6QXUI6OcRq0Htd67/UFUpo/LmN0ze0cAjzb9+PRTqVx2fHrSomSQTcQR7I5xHfGb1I3gJigAn2Vb2CdI8he2TOoRrdrqTMzBd+eTuk=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from SN6PR11MB2718.namprd11.prod.outlook.com (2603:10b6:805:63::18)
 by SN6PR11MB2717.namprd11.prod.outlook.com (2603:10b6:805:60::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Mon, 13 Sep
 2021 08:31:58 +0000
Received: from SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd]) by SN6PR11MB2718.namprd11.prod.outlook.com
 ([fe80::7050:a0a:415:2ccd%7]) with mapi id 15.20.4500.017; Mon, 13 Sep 2021
 08:31:58 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH v2 21/33] staging: wfx: remove unused definition
Date:   Mon, 13 Sep 2021 10:30:33 +0200
Message-Id: <20210913083045.1881321-22-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
References: <20210913083045.1881321-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:1fd::10) To SN6PR11MB2718.namprd11.prod.outlook.com
 (2603:10b6:805:63::18)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PAZP264CA0067.FRAP264.PROD.OUTLOOK.COM (2603:10a6:102:1fd::10) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14 via Frontend Transport; Mon, 13 Sep 2021 08:31:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 39edc353-aa0f-42df-cb79-08d97690e9a6
X-MS-TrafficTypeDiagnostic: SN6PR11MB2717:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SN6PR11MB2717BEADE81D06F6570C52B393D99@SN6PR11MB2717.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: OoDPjuSa8oj5fqyU+OVS8QlXQQ/HpMNuuhYU9ogV7Z0GwQjKqZaKtZkgwbLTVSS/8uD/dCkY7jjSkU4MKFprwiMa5MqF1josQhAksRgBo/JODXS6F3lGTwTQgGyIkH/GmMcnxYAzPpLPnY94fnfpEH71XZabr3HHnowMuDT1wzTjpq+cNJOdJr6qVamfrHtW9AC5oA9wUQYHrQ5ZkVpURDKY5CRMV4nTMnnovebBW5bv51FTTavpMCHIFyo5pfi3c9s2lTPqJws8xa8SInpGdkQdAYlIsa/VokD3cZc3IA5iaxcf9RN0vCZ6WwePoBQ44G5yDYEyz8kLVHsM+P0y745sfVZGWnFmm0Wwv9oYD9UL80cccjjiIFNrLjVCf4ki0CmKaJsbp9DPVuirRUmZv8aG7q8/OlipMr2Co6p2ARzyyqML+TKntVrT10KFqptJCBpgupQMukyf3OGbNXGjZvlGeTz3dzetNwVsMPdTjpzFWsMed0IhI3Rte0V4A8JzStUnntmYuMrV80rOyrrX4UGLUurZju9tPhlGDBODCtvKZkPAXVQrvbpUi+CFRDbdTCXv1ivzm8Vmk/z/SpwN5JPoZJpqH+G1o4YjfwU7wNK8IUf1UGeckuMmYlsRAB3+oeSNgN2IvhJ+EJKNgo+eVo7KOzRNWo/ZR+Rdaa9xiyDnTodEcuEcJjqgiza9zR4K
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB2718.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(4326008)(2906002)(107886003)(26005)(66946007)(38100700002)(52116002)(7696005)(1076003)(956004)(36756003)(316002)(8676002)(38350700002)(186003)(8936002)(83380400001)(54906003)(66556008)(66476007)(508600001)(6486002)(5660300002)(6666004)(86362001)(2616005)(4744005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ekMyMzhHazQ3UWlMZVYzSUQ5TWd1dStuWFZ3UWpPK3FySXNKYTQwUU1EeE50?=
 =?utf-8?B?cE80MExGakN5Yjk5T3A3V2FlamlGR2d6TjVEcjdYa09ja1Z1SHAyRkdJWnRI?=
 =?utf-8?B?M1Z4YlVnRVJFelJXMkwyTDVadFArakd1ZmNQYjAvMUV4QUp2dFVXYzRtSEM0?=
 =?utf-8?B?eUVRNjc5bFh2Unc0Ni9ZTlBZb2VjUlNUZS9NTkJlaDJGQU95bEM4SDVUN3lX?=
 =?utf-8?B?UDlpOU8rQmM1ZXV1dnpjbXN5bU5BbWxvMEJIZ2dlV2dEcVRwNlAydjBDdG5W?=
 =?utf-8?B?Y0xEc3M1eEhEc001bGtTREJOdXFacGUwa01XZTJ4bm4vUHEyZWNjcm1YUXZP?=
 =?utf-8?B?OWM5S0ZZV0ZRcVhBOG9yRGxybDU2d3hUZjNBSzZralB2aTY0ajBMTVdJZ2VT?=
 =?utf-8?B?bU52Wjc0NENxMDFFeHorME40d0lLajRNRWppSWw1cDVGaFZYUVg0VlNjd2Fo?=
 =?utf-8?B?OTFQZWE5QXBBcGZ3aHlOa2xLWU1uZ0FOUnlOeDZYVzduUThLLzZFd1NvRmdU?=
 =?utf-8?B?bEFmQ3RHSUh2Z3IrRHdJdXZRTExLMHVFMU9URzN4TC84KzJlTmgzVHZ4TVlj?=
 =?utf-8?B?TzlDUUU5UU40Y1lRWHhFY3hTUlpqVldsaEpPU3BLM2ZPTEUvVStvbFNSYnl6?=
 =?utf-8?B?RGQza2YydmFSTE5FTGwzVTlCWGZQa29wVUQ5OXYrSGZBMkc0SVdjaTJEWmRn?=
 =?utf-8?B?QytxS1ZHY0w0VE02K25JMFM4ZytKZmxyZk5ZOEI1ZmViMmxnUjNEOVk5S3lw?=
 =?utf-8?B?M2xsOFliNzdOVS9NT0ZSdGZZdTlTeEd6WG9ZNVE0YWNIMlZMOFU1aGFRajB4?=
 =?utf-8?B?Z0dSamFrYlRaUkJlRXlyVmhBNi91K3FGUmROL0NUa011YnBLRnQrZ0dERUIw?=
 =?utf-8?B?aWdWdWJaRmtIbGR1UlNHVTJNSEgzZGE2OTlVYktWQXBOVUx6eDJZRGE5RDNz?=
 =?utf-8?B?WHE1QjcxclM0UmNYd053cmFDdTBDcDFrUFBNeitzUFBJS0F0dEdjSmxqWEJs?=
 =?utf-8?B?L0c2ZXBpbnFrek9ITkEvL0IySHAyK3ZOZjFMQVZyS3orcXMzNTVjeVdGTW1G?=
 =?utf-8?B?UURyMzloUXlGTkhvVGl0ODRybE5BamFKUFY2blAxM1BrOWlyTVdOM293Ukw2?=
 =?utf-8?B?R2QzT0tVMkQ2V1NHcm4yRG1zakhKZ1hoMWRPVjVPdlF5bTN1OE9idVE1T2M2?=
 =?utf-8?B?c3BCa1podXlkN05QNS9OYmJwRmIrNlREdzlDd2w2bkZhZDJFUGl4YWJLVUdj?=
 =?utf-8?B?TEhTYWxRMWxKa0ZlUk5mMDlObmJhaGpPU0d2Q1kzeWJLUWxxTUJuTWd0SUlj?=
 =?utf-8?B?aTltY1FhRFkxTk1tdEE2dm94a3YxM043Y2tLWDVBcVNxQ1E3TTV0T2s3aXBh?=
 =?utf-8?B?S09ybHAzbU9xZHBzRkEzdTBtTld5MzVOaGJsdzNTUE1Ndk5NOCtRYVpMUENE?=
 =?utf-8?B?dDFUUGZRWkV1Y3RBaEhrbDJLMWY1dUxGVTFlNU5xYW5Td3U5N2JiSTFudEtR?=
 =?utf-8?B?dTNxbFdGMzlJYnk4bGU3SXU4M3VYcyt0TlpPUDNNUHhLNGQzYmt0Zk5aRkli?=
 =?utf-8?B?UGFTcWd5TmhXdkZrZHpNKzk1bXFyUzJXcHBaQytaNXdQOEs1TWVjamdSdUta?=
 =?utf-8?B?c3ZRdHhTVDhrbWpxSW95SGpUMTM0Zk94UUp4NHVMc3NiWVMxRndLTzIreHYx?=
 =?utf-8?B?S2kxTFVpc2Vmbk9CbXpaZHpZVHRWYVdKcGJuL0EwZ0hGVU5zTWVLZ3RaOE5k?=
 =?utf-8?Q?6x5tR2qOJ9wfqFilkVpfoqPL9djEHlbkmFb/Tz9?=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 39edc353-aa0f-42df-cb79-08d97690e9a6
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB2718.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Sep 2021 08:31:41.9315
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DE1ceCGjKWhNW/SgS+w5BfbsraWB5IFux1qd/vKpePKj6SE7vIhBXFn54qfuFSqTk2tBvhAd/jrFTtwxuRV5oA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB2717
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGVudW0gaGlmX2Z3X3R5cGUgaXMgbmV2ZXIgdXNlZCBpbiB0aGUgZHJpdmVyLiBEcm9wIGl0LgoK
U2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMu
Y29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmggfCA2IC0tLS0t
LQogMSBmaWxlIGNoYW5nZWQsIDYgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaCBiL2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2Fw
aV9nZW5lcmFsLmgKaW5kZXggMjQxODg5NDU3MThkLi43NzAzMGNlY2YxMzQgMTAwNjQ0Ci0tLSBh
L2RyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmgKKysrIGIvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaApAQCAtMTEzLDEyICsxMTMsNiBAQCBlbnVtIGhpZl9h
cGlfcmF0ZV9pbmRleCB7CiAJQVBJX1JBVEVfTlVNX0VOVFJJRVMgICAgICAgPSAyMgogfTsKIAot
ZW51bSBoaWZfZndfdHlwZSB7Ci0JSElGX0ZXX1RZUEVfRVRGICA9IDB4MCwKLQlISUZfRldfVFlQ
RV9XRk0gID0gMHgxLAotCUhJRl9GV19UWVBFX1dTTSAgPSAweDIKLX07Ci0KIHN0cnVjdCBoaWZf
aW5kX3N0YXJ0dXAgewogCS8vIEFzIHRoZSBvdGhlcnMsIHRoaXMgc3RydWN0IGlzIGludGVycHJl
dGVkIGFzIGxpdHRsZSBlbmRpYW4gYnkgdGhlCiAJLy8gZGV2aWNlLiBIb3dldmVyLCB0aGlzIHN0
cnVjdCBpcyBhbHNvIHVzZWQgYnkgdGhlIGRyaXZlci4gV2UgcHJlZmVyIHRvCi0tIAoyLjMzLjAK
Cg==
