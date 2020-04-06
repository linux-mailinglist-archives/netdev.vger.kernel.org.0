Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E052719F450
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgDFLSi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:18:38 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:6126
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727125AbgDFLSh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 07:18:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pnc5S1Jo2POCp1in+u8SKrm23SQeGRYtnkssCxLKy8LQYYf1LNrgonPYld9rSZ0JroWij1XmnKG1l3oCDF2uRIyNgIe3MrHGKu0am4Z/sHlMDyeLLRny7DtDI8nNViDfA7vMGQwdn2bZGysPDZ5TmA4Z+SSdlxtbK4ljodLEjtUI1CdtxyONXWIu61ew2XUc2a5EwInW2zleQpuEzgn4XzYOXapI2fBrZaKiR6hCXdYLdDufiNqQLun8Lsjr7i7QXkUPA7ASrTVOLkgbUKTUzd1SlGZQzPY0vqM0A2cK2Eqn2Wq7trzXsEmtoX/qgdgGHWiF66tkMY+NNVkFiFZakA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwVu1Wh7pYdvfMR5lOj1KWGe1RpoiyE2cttUnHmWdtY=;
 b=cmzpG7L4U7plaSHPEd+uGJDVCCm7tj81tlM7ojraCCqNAyMqbb5GdxbNqlRyEsMZPyFXo97YbxHY6l6IrEV5nEXaGLuTz8G9XEWzoEUSYPBzXO2bZeaFH8V1+NBmDWnFVeGl9umliPQO6t6rJxD92FuPxvWSwcCljtWVngOLVBgb1+uiewCe+z7qltzttOZQ7bPzIFWbJcZlxRzr7wf+N0A5tibL6iZ73UwYqWd8lGuUM41x4Eq1aJdZuFvvCKEQ4wYyv3UNR0DtfwowUvUdtxpO8U2qW/uK6lnS1G0Qn32vLA1vTZ/Oj3zjjedb+0le5wGbUuYEd0Q2UUk3nc/YtQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wwVu1Wh7pYdvfMR5lOj1KWGe1RpoiyE2cttUnHmWdtY=;
 b=L56ZpJvVm26cuq/yqMtmFxS0M4RrsnnK1boKOWDtgaXBJm3uJM9XrRKs51ySrWllEAhwdcEwSkqoPbGl3wflQjaD9B9n3eE70idosNvI2qNvG1C0eLDoT3QAXQ+nU+BE+0pzqMZDcpmjjosVtEH+W9dEBEV0+/bLpLrV/565G8I=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from BN6PR11MB4052.namprd11.prod.outlook.com (2603:10b6:405:7a::37)
 by BN6PR11MB3860.namprd11.prod.outlook.com (2603:10b6:405:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Mon, 6 Apr
 2020 11:18:24 +0000
Received: from BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376]) by BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376%3]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 11:18:24 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 05/11] staging: wfx: remove useless defines
Date:   Mon,  6 Apr 2020 13:17:50 +0200
Message-Id: <20200406111756.154086-6-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
References: <20200406111756.154086-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: DM5PR05CA0010.namprd05.prod.outlook.com
 (2603:10b6:3:d4::20) To BN6PR11MB4052.namprd11.prod.outlook.com
 (2603:10b6:405:7a::37)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR05CA0010.namprd05.prod.outlook.com (2603:10b6:3:d4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.13 via Frontend Transport; Mon, 6 Apr 2020 11:18:22 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50b461f2-1ecd-44e1-7da1-08d7da1c38c6
X-MS-TrafficTypeDiagnostic: BN6PR11MB3860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR11MB38603330A3887EA4FA06A02A93C20@BN6PR11MB3860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1148;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(39850400004)(346002)(366004)(136003)(376002)(186003)(16526019)(7696005)(52116002)(36756003)(5660300002)(107886003)(316002)(54906003)(66946007)(66476007)(4326008)(2616005)(66556008)(1076003)(66574012)(81166006)(6666004)(6486002)(8936002)(2906002)(86362001)(81156014)(8676002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: mbk9XW+f2V13R2u0v3H3cM4SQ967I0NZc5BjgN29NflH9JO13GuXKt9WHhXf2Dxo43TwHfOJiPBb/yaNi5/XcvvBz8qCXqvq0ygzmeoChPh0P2RF0m68hnH2d6Ip1tAC1qRoIk+OJuG9pHBfNgAnhr8zFvrrgsR14Gw421oVUpVuCbCn3MC4TExAHFJb91ouZ1tI27CCyVRAKsxcGfoxsPt6oWtewLM0bdXh57PBrzfje1iS9T7YbBc9B1Kow0ZZ2YVtDiQte/DJoZPwyg9NYUDVOx07kz+JE4odJCVGxlXfS7SvEsT7tMg/tYxXp0faouoKIW/3ez+FUNiPmzOzFJGLYpIuVmBii2hbYGusCJsHJEhZIeg7uxSDkN12SGT2e8jHoQFyGcywGO6LbEekOioQXJFetKTUU26DjHwxGwjrW6az04AH9q9Wiy/wl6FC
X-MS-Exchange-AntiSpam-MessageData: 42SsPDAQ/tbL1OtX+Mny6CyIEbQx4N0DphVCzyJLyTD4TEzRpdpKLlx/55evjUCl90rP1Ocqju97d9M1z1bxNVyeJGud8+4sOWtDUcM4KJflDHyoAJUmITrdx2UWvKHiDRnanWjXx2+s7YDQ8NEiiIHyA6f1YywsVN7dBPLljucOLZ1UpeAK9qPDC27V+yEJdSXr6CKxLW7bj1P7tr40Dg==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50b461f2-1ecd-44e1-7da1-08d7da1c38c6
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 11:18:24.5714
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0ReLh77UxvnMvgZ+BA8OENdtllhKXdahaJBl2ylfIzTnlSn7nECBCvJ7x2qjrfEDwdRPjkTg4znx03gY6ofIBg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3860
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKU2V2
ZXJhbCB2YWx1ZXMgZGVmaW5lZCBpbiBoaWYgQVBJIGFyZSBvbmx5IGhlcmUgdG8gZGVmaW5lIGxl
bmd0aCBvZiBzb21lCmFycmF5cy4gSW4gbW9zdCBjYXNlcywgdGhleSBkbyBub3QgcHJvdmlkZSBh
bnkgZXh0cmEgaW5mb3JtYXRpb24gYWJvdXQKdGhlIHNpemUgb2YgdGhlIGFycmF5IChpZS4gIkFQ
SV9GSVJNV0FSRV9MQUJFTF9TSVpFIiBpcyBvbmx5IHVzZWQgdG8KZGVmaW5lIHRoZSBzaXplIG9m
IG1lbWJlciAiZmlybXdhcmVfbGFiZWwiKS4KClJlbW92ZSB0aGVzZSB1c2VsZXNzIGRlZmluaXRp
b25zLgoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBz
aWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2FwaV9nZW5lcmFsLmggfCAy
NyArKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvaGlmX2Fw
aV9taWIuaCAgICAgfCAxMSArKystLS0tLS0tLQogMiBmaWxlcyBjaGFuZ2VkLCAxMiBpbnNlcnRp
b25zKCspLCAyNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9kcml2ZXJzL3N0YWdpbmcvd2Z4
L2hpZl9hcGlfZ2VuZXJhbC5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwu
aAppbmRleCA3MzAxNjEzNWY1MzguLmM1OGI5YTFlZmYzZCAxMDA2NDQKLS0tIGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfYXBpX2dlbmVyYWwuaAorKysgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L2hp
Zl9hcGlfZ2VuZXJhbC5oCkBAIC0xMzUsMTYgKzEzNSwxMSBAQCBzdHJ1Y3QgaGlmX290cF9waHlf
aW5mbyB7CiAJdTggICAgb3RwX3BoeV92ZXI6MjsKIH0gX19wYWNrZWQ7CiAKLSNkZWZpbmUgQVBJ
X09QTl9TSVpFICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgMTQKLSNkZWZpbmUg
QVBJX1VJRF9TSVpFICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgOAotI2RlZmlu
ZSBBUElfRElTQUJMRURfQ0hBTk5FTF9MSVNUX1NJWkUgICAgICAgICAgICAgICAgICAyCi0jZGVm
aW5lIEFQSV9GSVJNV0FSRV9MQUJFTF9TSVpFICAgICAgICAgICAgICAgICAgICAgICAgIDEyOAot
CiBzdHJ1Y3QgaGlmX2luZF9zdGFydHVwIHsKIAl1MzIgICBzdGF0dXM7CiAJdTE2ICAgaGFyZHdh
cmVfaWQ7Ci0JdTggICAgb3BuW0FQSV9PUE5fU0laRV07Ci0JdTggICAgdWlkW0FQSV9VSURfU0la
RV07CisJdTggICAgb3BuWzE0XTsKKwl1OCAgICB1aWRbOF07CiAJdTE2ICAgbnVtX2lucF9jaF9i
dWZzOwogCXUxNiAgIHNpemVfaW5wX2NoX2J1ZjsKIAl1OCAgICBudW1fbGlua3NfYXA7CkBAIC0x
NTcsMTEgKzE1MiwxMSBAQCBzdHJ1Y3QgaGlmX2luZF9zdGFydHVwIHsKIAl1OCAgICBmaXJtd2Fy
ZV9taW5vcjsKIAl1OCAgICBmaXJtd2FyZV9tYWpvcjsKIAl1OCAgICBmaXJtd2FyZV90eXBlOwot
CXU4ICAgIGRpc2FibGVkX2NoYW5uZWxfbGlzdFtBUElfRElTQUJMRURfQ0hBTk5FTF9MSVNUX1NJ
WkVdOworCXU4ICAgIGRpc2FibGVkX2NoYW5uZWxfbGlzdFsyXTsKIAlzdHJ1Y3QgaGlmX290cF9y
ZWd1bF9zZWxfbW9kZV9pbmZvIHJlZ3VsX3NlbF9tb2RlX2luZm87CiAJc3RydWN0IGhpZl9vdHBf
cGh5X2luZm8gb3RwX3BoeV9pbmZvOwogCXUzMiAgIHN1cHBvcnRlZF9yYXRlX21hc2s7Ci0JdTgg
ICAgZmlybXdhcmVfbGFiZWxbQVBJX0ZJUk1XQVJFX0xBQkVMX1NJWkVdOworCXU4ICAgIGZpcm13
YXJlX2xhYmVsWzEyOF07CiB9IF9fcGFja2VkOwogCiBzdHJ1Y3QgaGlmX2luZF93YWtldXAgewpA
QCAtMjI5LDEwICsyMjQsOCBAQCBzdHJ1Y3QgaGlmX2luZF9nZW5lcmljIHsKIH0gX19wYWNrZWQ7
CiAKIAotI2RlZmluZSBISUZfRVhDRVBUSU9OX0RBVEFfU0laRSAgICAgICAgICAgIDEyNAotCiBz
dHJ1Y3QgaGlmX2luZF9leGNlcHRpb24gewotCXU4ICAgIGRhdGFbSElGX0VYQ0VQVElPTl9EQVRB
X1NJWkVdOworCXU4ICAgIGRhdGFbMTI0XTsKIH0gX19wYWNrZWQ7CiAKIApAQCAtMzAyLDE0ICsy
OTUsMTQgQEAgc3RydWN0IGhpZl9jbmZfc2V0X3NsX21hY19rZXkgewogCXUzMiAgIHN0YXR1czsK
IH0gX19wYWNrZWQ7CiAKLSNkZWZpbmUgQVBJX0hPU1RfUFVCX0tFWV9TSVpFICAgICAgICAgICAg
ICAgICAgICAgICAgICAgMzIKLSNkZWZpbmUgQVBJX0hPU1RfUFVCX0tFWV9NQUNfU0laRSAgICAg
ICAgICAgICAgICAgICAgICAgNjQKLQogZW51bSBoaWZfc2xfc2Vzc2lvbl9rZXlfYWxnIHsKIAlI
SUZfU0xfQ1VSVkUyNTUxOSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgPSAweDAxLAog
CUhJRl9TTF9LREYgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICA9IDB4MDIK
IH07CiAKKyNkZWZpbmUgQVBJX0hPU1RfUFVCX0tFWV9TSVpFICAgICAgICAgICAgICAgICAgICAg
ICAgICAgMzIKKyNkZWZpbmUgQVBJX0hPU1RfUFVCX0tFWV9NQUNfU0laRSAgICAgICAgICAgICAg
ICAgICAgICAgNjQKKwogc3RydWN0IGhpZl9yZXFfc2xfZXhjaGFuZ2VfcHViX2tleXMgewogCXU4
ICAgIGFsZ29yaXRobToyOwogCXU4ICAgIHJlc2VydmVkMTo2OwpAQCAtMzMxLDEwICszMjQsOCBA
QCBzdHJ1Y3QgaGlmX2luZF9zbF9leGNoYW5nZV9wdWJfa2V5cyB7CiAJdTggICAgbmNwX3B1Yl9r
ZXlfbWFjW0FQSV9OQ1BfUFVCX0tFWV9NQUNfU0laRV07CiB9IF9fcGFja2VkOwogCi0jZGVmaW5l
IEFQSV9FTkNSX0JNUF9TSVpFICAgICAgICAzMgotCiBzdHJ1Y3QgaGlmX3JlcV9zbF9jb25maWd1
cmUgewotCXU4ICAgIGVuY3JfYm1wW0FQSV9FTkNSX0JNUF9TSVpFXTsKKwl1OCAgICBlbmNyX2Jt
cFszMl07CiAJdTggICAgZGlzYWJsZV9zZXNzaW9uX2tleV9wcm90ZWN0aW9uOjE7CiAJdTggICAg
cmVzZXJ2ZWQxOjc7CiAJdTggICAgcmVzZXJ2ZWQyWzNdOwpkaWZmIC0tZ2l0IGEvZHJpdmVycy9z
dGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21p
Yi5oCmluZGV4IDczMmY4MmQxMGExOS4uZTZkMDU3ODk3MjBjIDEwMDY0NAotLS0gYS9kcml2ZXJz
L3N0YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZf
YXBpX21pYi5oCkBAIC0xNDksOSArMTQ5LDYgQEAgc3RydWN0IGhpZl9taWJfcnhfZmlsdGVyIHsK
IAl1OCAgICByZXNlcnZlZDRbM107CiB9IF9fcGFja2VkOwogCi0jZGVmaW5lIEhJRl9BUElfT1VJ
X1NJWkUgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDMKLSNkZWZpbmUgSElGX0FQSV9N
QVRDSF9EQVRBX1NJWkUgICAgICAgICAgICAgICAgICAgICAgICAgMwotCiBzdHJ1Y3QgaGlmX2ll
X3RhYmxlX2VudHJ5IHsKIAl1OCAgICBpZV9pZDsKIAl1OCAgICBoYXNfY2hhbmdlZDoxOwpAQCAt
MTU5LDggKzE1Niw4IEBAIHN0cnVjdCBoaWZfaWVfdGFibGVfZW50cnkgewogCXU4ICAgIGhhc19h
cHBlYXJlZDoxOwogCXU4ICAgIHJlc2VydmVkOjE7CiAJdTggICAgbnVtX21hdGNoX2RhdGE6NDsK
LQl1OCAgICBvdWlbSElGX0FQSV9PVUlfU0laRV07Ci0JdTggICAgbWF0Y2hfZGF0YVtISUZfQVBJ
X01BVENIX0RBVEFfU0laRV07CisJdTggICAgb3VpWzNdOworCXU4ICAgIG1hdGNoX2RhdGFbM107
CiB9IF9fcGFja2VkOwogCiBzdHJ1Y3QgaGlmX21pYl9iY25fZmlsdGVyX3RhYmxlIHsKQEAgLTI3
MywxNCArMjcwLDEyIEBAIGVudW0gaGlmX3RtcGx0IHsKIAlISUZfVE1QTFRfTkEgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgPSAweDcKIH07CiAKLSNkZWZpbmUgSElGX0FQSV9NQVhfVEVN
UExBVEVfRlJBTUVfU0laRSAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIDcwMAotCiBzdHJ1
Y3QgaGlmX21pYl90ZW1wbGF0ZV9mcmFtZSB7CiAJdTggICAgZnJhbWVfdHlwZTsKIAl1OCAgICBp
bml0X3JhdGU6NzsKIAl1OCAgICBtb2RlOjE7CiAJdTE2ICAgZnJhbWVfbGVuZ3RoOwotCXU4ICAg
IGZyYW1lW0hJRl9BUElfTUFYX1RFTVBMQVRFX0ZSQU1FX1NJWkVdOworCXU4ICAgIGZyYW1lWzcw
MF07CiB9IF9fcGFja2VkOwogCiBzdHJ1Y3QgaGlmX21pYl9iZWFjb25fd2FrZV91cF9wZXJpb2Qg
ewotLSAKMi4yNS4xCgo=
