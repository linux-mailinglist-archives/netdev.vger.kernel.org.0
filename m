Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C66C19F470
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 13:19:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727447AbgDFLS2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 07:18:28 -0400
Received: from mail-dm6nam11on2071.outbound.protection.outlook.com ([40.107.223.71]:6126
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727125AbgDFLS2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Apr 2020 07:18:28 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S1SvjGEVgGJeT/Xi5oCYPkBnJLHcjRn9dcaA5qYhu8pxKh2F5+ZeKYtlQVcxtBUm9hxzWi3UbKU8zXC/qQXL4bOICafJsiVs0Db25IXEDVgkPs/T5H0o46Qa/BcoR662dPo6c3GLzipxh8z493xUntGa5ZToG7rsfoQqqk4ejJ+n26ZAs95HjGT92DBFrw0Bx7UtyB/mIS2K+2LT8d50iD51cgEG4iaTwMu3z5617LQMwbCRdAtJOkt2LDafS1TGLoh1vVMF1rd8i48PMsVYiRyHLtlSuUp1g0iZP4rluBv1RWzKec2GEHxilm0ab1YvaEGEgPhcoIB36I4tVZsXdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDUdKC5MG45uXW86FF3QFFtB2tT6J3KT7RhKATBOomQ=;
 b=go5d+PbFFjE+14mzoSDvyO6CfswhuBPG6uUbBUuW/zN5uojQcRanunyZoP58r+DWQ7MJDVX1kDsIaEnukmHjF0h5qWZ0+WGPZBEknh04kXSYQOW7RCTKeCG311sPX2xUvI4LGtHrOodvdAeIRZ6+jL7WwjjVFBgvZxe15ohsFJ7gc8Qr/yr6xDCd5KaeIfNMBK+LvfY21TzN3xD1+NaYchJSbPb+4ZHXH1A7BiMeSyp84RKuYtw+pjPGYVhkK863lL6QDl8LSoHMz0wRpYt3+LwhqUPnNZnWw9iO7iy9bOAEdDVfap9qZf4lZKi0dnXEliDuFFmBGliSyLNcs2pXzQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=JDUdKC5MG45uXW86FF3QFFtB2tT6J3KT7RhKATBOomQ=;
 b=cvHQdv9SI/y0twln6A/gb2A64EaIkyeSJtjGbpwl0QdkjGoJJd87nsCK3R3N//JgknrIfE7sU26X0jcq4mokafN/bqizT1m08ve6yRtGXVOwV8/+S31Kzig617Mq7mGoJJH3jq5Tk9C4FW0rppbCgnO7GcNLENFEWaGJC2Zp7DM=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from BN6PR11MB4052.namprd11.prod.outlook.com (2603:10b6:405:7a::37)
 by BN6PR11MB3860.namprd11.prod.outlook.com (2603:10b6:405:77::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.15; Mon, 6 Apr
 2020 11:18:15 +0000
Received: from BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376]) by BN6PR11MB4052.namprd11.prod.outlook.com
 ([fe80::e0af:e9de:ffce:7376%3]) with mapi id 15.20.2878.018; Mon, 6 Apr 2020
 11:18:15 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 01/11] staging: wfx: drop unused WFX_LINK_ID_GC_TIMEOUT
Date:   Mon,  6 Apr 2020 13:17:46 +0200
Message-Id: <20200406111756.154086-2-Jerome.Pouiller@silabs.com>
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
Received: from pc-42.silabs.com (2a01:e35:2435:66a0:544b:f17b:7ae8:fb7) by DM5PR05CA0010.namprd05.prod.outlook.com (2603:10b6:3:d4::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2900.13 via Frontend Transport; Mon, 6 Apr 2020 11:18:13 +0000
X-Mailer: git-send-email 2.25.1
X-Originating-IP: [2a01:e35:2435:66a0:544b:f17b:7ae8:fb7]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7b7daadd-0ca9-42a9-9c13-08d7da1c337f
X-MS-TrafficTypeDiagnostic: BN6PR11MB3860:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR11MB3860BB51D77C207A3BBE723C93C20@BN6PR11MB3860.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:136;
X-Forefront-PRVS: 0365C0E14B
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR11MB4052.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(396003)(39850400004)(346002)(366004)(136003)(376002)(186003)(16526019)(7696005)(52116002)(36756003)(5660300002)(107886003)(316002)(54906003)(66946007)(66476007)(4326008)(2616005)(66556008)(1076003)(66574012)(81166006)(6666004)(6486002)(8936002)(2906002)(86362001)(81156014)(4744005)(8676002)(478600001);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: aHXD46as/q4E8cewX6P0gFH2a2vyC38CO6BSpziPxZpVVjHjBk0Y6kk3dpKumWMR/3X6i3a8o8S+8uM79YntUvjCpIaV1MKIBQGwa8sqWHvzn1MmzvvITDTGTGGuYnPPmsh3buApd6FK7vjyXJpHvbloziDjyKb6I8W+UULBnyEevs54E3mpyX8pKJ82WEEOIkmy+/HkKQ+N7akj94l+11Ag39/vor+NcoK1UoZBPyC3SEYWMZg0Hz1jukYpya/vLOdu9xAiDHEOHjE7zwx/RMjlZAlg68QAQR0o3aok9ikuTlcP504iaCmXaFZKcck8W3i3+rDNwwAoU5tuF1pK4hXtcjj2atXxjk20GxFaI/xjSEx/RvVP3l5dVizdmELU3fomwKMWVgw8b7JlEWHTdRkPRuzt0NbGnkErZ6LLjKfJjHJx+1cmk9SZoUVkT/8J
X-MS-Exchange-AntiSpam-MessageData: LV0iFZwUFuRmZhC/6PW+xAUN88Ge0ZzMIzh5CeVBH/0feHnB+O5IVnTDlFIvljoXup5SblBzQ60W3ma9Y5zUUq3N3wCeAmUVlfIXfqUakRjoGgWvw+16uBKMYv8AF/cCvE6h3oVe42n2+kFGtC3M+fv5q0Qb7FkhrhaxZaiN4u2UEfj+GuYowxhsM/xsrfEWiddXHZfYm0AlieJCghkmVA==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7b7daadd-0ca9-42a9-9c13-08d7da1c337f
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2020 11:18:15.7972
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8cnMrzriV2vbn0000dbiCRM/9LaIMsz5pu4ZMygJeF2EaWLUZtjYkMPktfXWJ/Mow9mtNWfEFZUryENeOl0ywQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR11MB3860
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKVGhl
IGRlZmluaXRpb24gV0ZYX0xJTktfSURfR0NfVElNRU9VVCBpcyBub3QgdXNlZCBhbnltb3JlIHNp
bmNlCmNvbW1pdCBkNmFlYmE1NzVmMjcgKCJzdGFnaW5nOiB3Zng6IHNpbXBsaWZ5IHRoZSBsaW5r
LWlkIGFsbG9jYXRpb24iKQoKU2lnbmVkLW9mZi1ieTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9t
ZS5wb3VpbGxlckBzaWxhYnMuY29tPgotLS0KIGRyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5j
IHwgMSAtCiAxIGZpbGUgY2hhbmdlZCwgMSBkZWxldGlvbigtKQoKZGlmZiAtLWdpdCBhL2RyaXZl
cnMvc3RhZ2luZy93ZngvZGF0YV90eC5jIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9kYXRhX3R4LmMK
aW5kZXggOTNlZDBlZDYzYmIyLi5jODhkMTRmZTYxNGIgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvc3Rh
Z2luZy93ZngvZGF0YV90eC5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93ZngvZGF0YV90eC5jCkBA
IC0xNyw3ICsxNyw2IEBACiAjaW5jbHVkZSAiaGlmX3R4X21pYi5oIgogCiAjZGVmaW5lIFdGWF9J
TlZBTElEX1JBVEVfSUQgICAgMTUKLSNkZWZpbmUgV0ZYX0xJTktfSURfR0NfVElNRU9VVCAoKHVu
c2lnbmVkIGxvbmcpKDEwICogSFopKQogCiBzdGF0aWMgaW50IHdmeF9nZXRfaHdfcmF0ZShzdHJ1
Y3Qgd2Z4X2RldiAqd2RldiwKIAkJCSAgIGNvbnN0IHN0cnVjdCBpZWVlODAyMTFfdHhfcmF0ZSAq
cmF0ZSkKLS0gCjIuMjUuMQoK
