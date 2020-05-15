Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E7E81D486B
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 10:34:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728150AbgEOIeO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 04:34:14 -0400
Received: from mail-dm6nam11on2053.outbound.protection.outlook.com ([40.107.223.53]:55808
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727933AbgEOIeM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 May 2020 04:34:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqFYdv/fg2ZKWoXNDrcfkdi5RIRF8LvCnIC+DIOTncwJ3yu+JtklFj1Vle5fBX8UzOMNQIiD3UApy3aaeKHmPE77xoiyOTBeGXIp27u+JBcYUx/G7es4EThg8ani016UI+oD+qtdCLbbgQcYu0Hvo20UueoACPXWcLmaHshLqIqEKF7+miFo5jksrjLcbmL1MzNiBMpwJYcNumtMA9eCu16Unw+KUtjQRIdL6f6Mi7kdZOgCyfaBpY47hwn3BUzWryfr7JyhVAfM4gVVlkexRS3OkskTbnBINvxDgzb33mZRVIW1+auctU/sFS3A3TURi+Bj4JXOMtY9j43j/EUQBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiJtijyQah2+739rbh2zhSH+M8adLOJAGFU/ENZT2Y8=;
 b=TuasE0BrNYBkALJK12VQ9CG2YdQPjUjO0XRY9OfqQ++AA1J74JsaEZRHou1bm4uaat86dv4gd42aXFtR6xlEB2mHlG3982Vbl72FJ6M5BJdUm1K3s1iK38aeHqY4UM2MbW0plBdBKnBCsh+TD0U96DTdTueRURuwXsb9PpTJonniLVJ18oqdfDAXBKYd8UODLfdRy6DcBo78lzzQnwfdYocppIOoX2JUECYltN7PbiuQf8N2I+mk95LDrfGTpfwjzVJsb59j55eO6btaUTcdQWmujydkz9CHKMA4qgE0i4im262tjuv8v+lzAPSx/fY+KrOAEo86in0uo7t4d7KCXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XiJtijyQah2+739rbh2zhSH+M8adLOJAGFU/ENZT2Y8=;
 b=K4Ooj/T4n8odZGet5ajA1Ixc/SoBUUGemmNKqp4jbqLQjF/N4VhgjnZXCdLvWozam0vV9uRCIQbj4HuZZIzo3g6SE0sMrTo/+ZOWUJW7LyD0m7+MBUuqiNC/n1W3ewmS0o8KDF+tsIa/VFLzfaGDPSVwVhUeBdQSJTKlYJZZZic=
Authentication-Results: driverdev.osuosl.org; dkim=none (message not signed)
 header.d=none;driverdev.osuosl.org; dmarc=none action=none
 header.from=silabs.com;
Received: from MWHPR11MB1775.namprd11.prod.outlook.com (2603:10b6:300:10e::14)
 by MWHPR11MB1310.namprd11.prod.outlook.com (2603:10b6:300:28::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2979.26; Fri, 15 May
 2020 08:34:00 +0000
Received: from MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da]) by MWHPR11MB1775.namprd11.prod.outlook.com
 ([fe80::e055:3e6d:ff4:56da%5]) with mapi id 15.20.3000.022; Fri, 15 May 2020
 08:33:59 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 06/19] staging: wfx: fix indentation
Date:   Fri, 15 May 2020 10:33:12 +0200
Message-Id: <20200515083325.378539-7-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
References: <20200515083325.378539-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:18::16) To MWHPR11MB1775.namprd11.prod.outlook.com
 (2603:10b6:300:10e::14)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.home (82.67.86.106) by PR0P264CA0076.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:18::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.24 via Frontend Transport; Fri, 15 May 2020 08:33:58 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [82.67.86.106]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 383b1453-9c77-419e-0bd2-08d7f8aab70e
X-MS-TrafficTypeDiagnostic: MWHPR11MB1310:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR11MB13107B77B2F93416A6CB142993BD0@MWHPR11MB1310.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:393;
X-Forefront-PRVS: 04041A2886
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xk4dHKn9cmNl6JzkMt5Vc9WVmYaixg5/h2AaP7vdJ8hGPAqE5GQIfaPWfCTtF7LYRfbispBNpXJpQJDLkXJPNEV18yEqSZkGQci/uoeHtc79Qp8BQP2eJAmNMEi5om36Zhi1iKwSObfR+f0wE5DWdZoqLPHk8svWmXIJXbmVxCXdO3+qa6S3KpOnLDG+2Pl+eedQacKC/LUDw2HVBqmvk+jtsLr1fHfpRhqy1e9MqKUCJ0Z+9AIV8QO8GryqGB80kI4rKRBe8d+RZwm4wt5DOMMo16lI28vNIZ5fbBOdCo+dQJbr4jJEUsjddmaZvtkxKip8eRY2zm5vrRg0T5YeVLwx1VqgHxEO0cu9KA8BKWBVt9TY3Xftq18HtrFBfAPU74GT5b0nC1ImrrqpOVAh9rInaPeG7dEXfDMAXv88R14NcOUGP9tLtwZQlUfJp4IF
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR11MB1775.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(346002)(136003)(376002)(366004)(39850400004)(396003)(8886007)(66556008)(186003)(6512007)(4744005)(66946007)(6506007)(36756003)(316002)(66476007)(26005)(52116002)(16526019)(6666004)(54906003)(2906002)(2616005)(478600001)(107886003)(956004)(8936002)(86362001)(8676002)(6486002)(5660300002)(4326008)(1076003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: bt7jtJu/POM4ecK+ORrJbc+dY6phZKB+U0AXX5R65Ox5KMPlX494do8L3K4AyO2WAdjIaFRTSiVGSld6cQFInI9ht3meknYCWwrYn2e1B4FAzZPfBtuvYab+tbrCOfXKehybKck2KP5tQK7QivxiUwu/9r2E2An7X8gyo0aMSyPaxnM8GOtGImRxCHp319WdlP6hz2Dn/bNmXLFapW4w2XlqSCnvCVDRN6I2/3b34EZZtNLJEcuITcbdNMCAFyj8y8U0qR+1BQlZFgBhm2w/4SCFH4My2xEEw9wCBRa9Vxju3f/OjGfk/9ggC7yNPGIjfPqbozOrdePIxD0xhyHJm2pzEM7RlfKuKGTIUv+Yj69XoP4N/hiixX4WAH74zyZKwWl7qUzOb2JJRo20ur6FszUL+gtwO58P8BRPCkPwW+Rt00LWpIfDnpoM++2Y1kO1NZNWvAFj68zuXDB0IN+TEhCXj/vkAgLDOMvFENFxYbc=
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 383b1453-9c77-419e-0bd2-08d7f8aab70e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2020 08:33:59.8253
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Uwni32SPb4yzAUI1EHRc6Mh7eA63MPAwXLsUR9IK4LB8jAvMFnWrugMSeKR3VVskt6AuYXILd0Ajtm9712Rtkg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1310
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKRml4
IGluZGVudGlvbiBvZiB3Znhfc2tiX2R0b3IoKS4KClNpZ25lZC1vZmYtYnk6IErDqXLDtG1lIFBv
dWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBkcml2ZXJzL3N0YWdpbmcv
d2Z4L2RhdGFfdHguYyB8IDYgKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCsp
LCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90
eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMKaW5kZXggY2FjOGM5ZWNiYzM0Li5h
MTI1OTAyMTRhNWQgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCisr
KyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBAIC00ODQsOSArNDg0LDkgQEAgc3Rh
dGljIHZvaWQgd2Z4X3NrYl9kdG9yKHN0cnVjdCB3ZnhfZGV2ICp3ZGV2LAogCXN0cnVjdCBoaWZf
bXNnICpoaWYgPSAoc3RydWN0IGhpZl9tc2cgKilza2ItPmRhdGE7CiAJc3RydWN0IGhpZl9yZXFf
dHggKnJlcSA9IChzdHJ1Y3QgaGlmX3JlcV90eCAqKWhpZi0+Ym9keTsKIAlzdHJ1Y3Qgd2Z4X3Zp
ZiAqd3ZpZiA9IHdkZXZfdG9fd3ZpZih3ZGV2LCBoaWYtPmludGVyZmFjZSk7Ci0JdW5zaWduZWQg
aW50IG9mZnNldCA9IHNpemVvZihzdHJ1Y3QgaGlmX3JlcV90eCkgKwotCQkJCXNpemVvZihzdHJ1
Y3QgaGlmX21zZykgKwotCQkJCXJlcS0+ZGF0YV9mbGFncy5mY19vZmZzZXQ7CisJdW5zaWduZWQg
aW50IG9mZnNldCA9IHNpemVvZihzdHJ1Y3QgaGlmX21zZykgKworCQkJICAgICAgc2l6ZW9mKHN0
cnVjdCBoaWZfcmVxX3R4KSArCisJCQkgICAgICByZXEtPmRhdGFfZmxhZ3MuZmNfb2Zmc2V0Owog
CiAJV0FSTl9PTighd3ZpZik7CiAJc2tiX3B1bGwoc2tiLCBvZmZzZXQpOwotLSAKMi4yNi4yCgo=
