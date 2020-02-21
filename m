Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83627167CE7
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 12:56:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728473AbgBUL4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 06:56:41 -0500
Received: from mail-eopbgr760043.outbound.protection.outlook.com ([40.107.76.43]:28579
        "EHLO NAM02-CY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728438AbgBUL4j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 06:56:39 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VJ+Ebhl3VHpyuTw1VaKCwkW6QDnIOdGDINKbORr35VuM7HJM4ZtLV2uO2zV1S77lMg0HhJGFfwf5V2pi11Z6YF4UQkMRj9PTFRmZaU4sE8ONG4QdffpeJfmmVSSuvslhzPyaDTLvyOwNIDt34Lon+TC2Eyuq6Swgq3hE/un8k3Nu8hW+nZwSUqr4MITIoqCCzeVq7i5QrZqH0NoE+EZLITzJnCRaPUMUEg/EhXeuHpq16kzIUbvajTSBaFT1VmRh181QumEaJF6xhDRMXu1HX8n9M59cs79DNgAL5FaMLDjsojXkDKAyjcWcDTGg1NFCyBPIXupG0RIBHjwPYKQCgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ac+i03LHC8k17GXI94714Z3Fgf4z908GQ4+BVj42lCA=;
 b=ChULLgUApfJjDV5jjE+jNuEinqEfMeDYJJCQ+ZIsWZVSq42QbwMd8mpwfnbj3BD0ijIXKoJteOrNDU/mIcyZqdQOyy8RJW+UWRyZl8YOmJVl/T63bEnyYCQESTfPNU+WG9RojIc5hvEh7gSE62zZwGm+spYGF4wwaSCjQNgcGb1pLh6WaBf8KegvLTA5ybAxg2jmHIan7DAQ36ZicHQD6weIURZaXQya5V6LuZI2rkQrx3S1flzcORFTRJWMOhR2ujBEWKUXcZQzi7va/TB6jRA17Wk3SMTuWucin+8jfQKO37ybyQW1kqxoTN8DKW8EuGCeUFzDLAjfxdq4NKq02g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ac+i03LHC8k17GXI94714Z3Fgf4z908GQ4+BVj42lCA=;
 b=dvYREGJ7G+BwpcL1DbYsxairOBcZaTte4xCQGieiJUmK3w9+o58Tjbh7yyfEt/Bhv9GkXr1NakXnMljG1TcWpplu/GWcu0zuoTKvtUJuukJiabcRGtl+pycKXXrTusx/tB9N+5XZqRdkqlXDATAWoP1k0pYcs7fubRSF6ZpGhvA=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (2603:10b6:208:13f::22)
 by MN2PR11MB4662.namprd11.prod.outlook.com (2603:10b6:208:263::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.17; Fri, 21 Feb
 2020 11:56:29 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::ade4:5702:1c8b:a2b3%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 11:56:29 +0000
From:   Jerome Pouiller <Jerome.Pouiller@silabs.com>
To:     linux-wireless@vger.kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S . Miller" <davem@davemloft.net>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Pouiller?= 
        <jerome.pouiller@silabs.com>
Subject: [PATCH 09/10] cfg80211: align documentation style of ieee80211_iface_combination
Date:   Fri, 21 Feb 2020 12:56:03 +0100
Message-Id: <20200221115604.594035-9-Jerome.Pouiller@silabs.com>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
References: <20200221115604.594035-1-Jerome.Pouiller@silabs.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: base64
X-ClientProxiedBy: PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1a::29) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
MIME-Version: 1.0
Received: from pc-42.silabs.com (37.71.187.125) by PR0P264CA0137.FRAP264.PROD.OUTLOOK.COM (2603:10a6:100:1a::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2750.18 via Frontend Transport; Fri, 21 Feb 2020 11:56:28 +0000
X-Mailer: git-send-email 2.25.0
X-Originating-IP: [37.71.187.125]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50865d48-13c5-48a5-7743-08d7b6c51633
X-MS-TrafficTypeDiagnostic: MN2PR11MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MN2PR11MB46628855A3E88E99AB1A417993120@MN2PR11MB4662.namprd11.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-Forefront-PRVS: 0320B28BE1
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(396003)(346002)(39860400002)(366004)(136003)(376002)(199004)(189003)(36756003)(86362001)(8676002)(81156014)(478600001)(8936002)(81166006)(7696005)(52116002)(66946007)(2906002)(66574012)(4326008)(107886003)(6916009)(1076003)(66556008)(6486002)(66476007)(6666004)(5660300002)(956004)(54906003)(316002)(2616005)(186003)(16526019)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4662;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dZCZ8aCRVhwV/OVXx3mf8+EpyksTVQ/+v+lTBxMjsOCIl4gJlhJHTaf6n18zFNzIclZRlLBp/Bey3/Q2FFjON8L6lmYKK69Nx929ffdeoONcTx+/TCR5r4LGHvvjGlrBkPnpQzJ/hAtgBSZstzYkAqSWLgGDSWR7m4dtcr6A6TBvKp31dUm/bOiiBTi0taiHL0+ea+h+Tl2jjKH8Ju2jsobhuKhPWz23AvkxeZoyYT3TJ26t3CiDsWNZBNiqggcztQxdgEE0gmFCVHcKjVs4mAjdFUCWoko8L1EU91C/VyD3G5ZToGuuAnL0DiNIgLxr+RicirZxQ8vuPkSZdCo6+MupwUbSPBfgCE/Shpb3CPESHj0M6lDTx/hSkQoELXkLeziImS2k6cTZaER+KFn0gSXQT03/LT79Qh8Qtmb9cEf1IsWd0LNpsWi0/dlXpjBC
X-MS-Exchange-AntiSpam-MessageData: N6LPHfK0ozhQ/H4hTiDuuC/6wBhsLmEkc07CXHpUu57RJi4msR4mwtO2nwNGqEoQQ/h1dGm+lKUI8m3hcFM6OHhQwpSOvyfyCb5zdsIpZDVDrkOezZG3HTQ1uVPbB6n88PRJPyoFYsvAqmVnOBwKPw==
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50865d48-13c5-48a5-7743-08d7b6c51633
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Feb 2020 11:56:29.5277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: yhOXiJQYHBYgGRXp7fGBcagkOwqti3t8Y4LFTuoqxxFNjB5qMhg4knY7c8i9pf4EdckorlwjX8Cu2eoAYpyIrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4662
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKSW4g
Y2ZnODAyMTEuaCwgYWxsIHRoZSBzdHJ1Y3RzIGJ1dCBpZWVlODAyMTFfaWZhY2VfY29tYmluYXRp
b24gYXJlCmRvY3VtZW50ZWQgYWJvdmUgdGhlaXIgZGVmaW5pdGlvbi4KClNpZ25lZC1vZmYtYnk6
IErDqXLDtG1lIFBvdWlsbGVyIDxqZXJvbWUucG91aWxsZXJAc2lsYWJzLmNvbT4KLS0tCiBpbmNs
dWRlL25ldC9jZmc4MDIxMS5oIHwgNjMgKysrKysrKysrKystLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgMTYgaW5zZXJ0aW9ucygrKSwgNDcgZGVsZXRpb25z
KC0pCgpkaWZmIC0tZ2l0IGEvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaCBiL2luY2x1ZGUvbmV0L2Nm
ZzgwMjExLmgKaW5kZXggMWNjMzQ0MmI1NDBmLi4yZjhjNDE5OTNlZDIgMTAwNjQ0Ci0tLSBhL2lu
Y2x1ZGUvbmV0L2NmZzgwMjExLmgKKysrIGIvaW5jbHVkZS9uZXQvY2ZnODAyMTEuaApAQCAtNDEw
Myw2MiArNDEwMywzMSBAQCBzdHJ1Y3QgaWVlZTgwMjExX2lmYWNlX2xpbWl0IHsKICAqCQkubnVt
X2RpZmZlcmVudF9jaGFubmVscyA9IDIsCiAgKgl9OwogICoKKyAqIEBsaW1pdHM6IGxpbWl0cyBm
b3IgdGhlIGdpdmVuIGludGVyZmFjZSB0eXBlcworICogQG51bV9kaWZmZXJlbnRfY2hhbm5lbHM6
IGNhbiB1c2UgdXAgdG8gdGhpcyBtYW55IGRpZmZlcmVudCBjaGFubmVscworICogQG1heF9pbnRl
cmZhY2VzOiAgbWF4aW11bSBudW1iZXIgb2YgaW50ZXJmYWNlcyBpbiB0b3RhbCBhbGxvd2VkIGlu
IHRoaXMgZ3JvdXAKKyAqIEBuX2xpbWl0czogbnVtYmVyIG9mIGxpbWl0YXRpb25zCisgKiBAYmVh
Y29uX2ludF9pbmZyYV9tYXRjaDogSW4gdGhpcyBjb21iaW5hdGlvbiwgdGhlIGJlYWNvbiBpbnRl
cnZhbHMgYmV0d2VlbgorICoJaW5mcmFzdHJ1Y3R1cmUgYW5kIEFQIHR5cGVzIG11c3QgbWF0Y2gu
IFRoaXMgaXMgcmVxdWlyZWQgb25seSBpbiBzcGVjaWFsCisgKgljYXNlcy4KKyAqIEByYWRhcl9k
ZXRlY3Rfd2lkdGhzOiBiaXRtYXAgb2YgY2hhbm5lbCB3aWR0aHMgc3VwcG9ydGVkIGZvciByYWRh
ciBkZXRlY3Rpb24KKyAqIEByYWRhcl9kZXRlY3RfcmVnaW9uczogYml0bWFwIG9mIHJlZ2lvbnMg
c3VwcG9ydGVkIGZvciByYWRhciBkZXRlY3Rpb24KKyAqIEBiZWFjb25faW50X21pbl9nY2Q6IFRo
aXMgaW50ZXJmYWNlIGNvbWJpbmF0aW9uIHN1cHBvcnRzIGRpZmZlcmVudCBiZWFjb24KKyAqCWlu
dGVydmFsczoKKyAqCSAgICAqID0gMDogYWxsIGJlYWNvbiBpbnRlcnZhbHMgZm9yIGRpZmZlcmVu
dCBpbnRlcmZhY2UgbXVzdCBiZSBzYW1lLgorICoJICAgICogPiAwOiBhbnkgYmVhY29uIGludGVy
dmFsIGZvciB0aGUgaW50ZXJmYWNlIHBhcnQgb2YgdGhpcworICoJICAgICAgY29tYmluYXRpb24g
QU5EIEdDRCBvZiBhbGwgYmVhY29uIGludGVydmFscyBmcm9tIGJlYWNvbmluZworICoJICAgICAg
aW50ZXJmYWNlcyBvZiB0aGlzIGNvbWJpbmF0aW9uIG11c3QgYmUgZ3JlYXRlciBvciBlcXVhbCB0
byB0aGlzCisgKgkgICAgICB2YWx1ZS4KICAqLwogc3RydWN0IGllZWU4MDIxMV9pZmFjZV9jb21i
aW5hdGlvbiB7Ci0JLyoqCi0JICogQGxpbWl0czoKLQkgKiBsaW1pdHMgZm9yIHRoZSBnaXZlbiBp
bnRlcmZhY2UgdHlwZXMKLQkgKi8KIAljb25zdCBzdHJ1Y3QgaWVlZTgwMjExX2lmYWNlX2xpbWl0
ICpsaW1pdHM7Ci0KLQkvKioKLQkgKiBAbnVtX2RpZmZlcmVudF9jaGFubmVsczoKLQkgKiBjYW4g
dXNlIHVwIHRvIHRoaXMgbWFueSBkaWZmZXJlbnQgY2hhbm5lbHMKLQkgKi8KIAl1MzIgbnVtX2Rp
ZmZlcmVudF9jaGFubmVsczsKLQotCS8qKgotCSAqIEBtYXhfaW50ZXJmYWNlczoKLQkgKiBtYXhp
bXVtIG51bWJlciBvZiBpbnRlcmZhY2VzIGluIHRvdGFsIGFsbG93ZWQgaW4gdGhpcyBncm91cAot
CSAqLwogCXUxNiBtYXhfaW50ZXJmYWNlczsKLQotCS8qKgotCSAqIEBuX2xpbWl0czoKLQkgKiBu
dW1iZXIgb2YgbGltaXRhdGlvbnMKLQkgKi8KIAl1OCBuX2xpbWl0czsKLQotCS8qKgotCSAqIEBi
ZWFjb25faW50X2luZnJhX21hdGNoOgotCSAqIEluIHRoaXMgY29tYmluYXRpb24sIHRoZSBiZWFj
b24gaW50ZXJ2YWxzIGJldHdlZW4gaW5mcmFzdHJ1Y3R1cmUKLQkgKiBhbmQgQVAgdHlwZXMgbXVz
dCBtYXRjaC4gVGhpcyBpcyByZXF1aXJlZCBvbmx5IGluIHNwZWNpYWwgY2FzZXMuCi0JICovCiAJ
Ym9vbCBiZWFjb25faW50X2luZnJhX21hdGNoOwotCi0JLyoqCi0JICogQHJhZGFyX2RldGVjdF93
aWR0aHM6Ci0JICogYml0bWFwIG9mIGNoYW5uZWwgd2lkdGhzIHN1cHBvcnRlZCBmb3IgcmFkYXIg
ZGV0ZWN0aW9uCi0JICovCiAJdTggcmFkYXJfZGV0ZWN0X3dpZHRoczsKLQotCS8qKgotCSAqIEBy
YWRhcl9kZXRlY3RfcmVnaW9uczoKLQkgKiBiaXRtYXAgb2YgcmVnaW9ucyBzdXBwb3J0ZWQgZm9y
IHJhZGFyIGRldGVjdGlvbgotCSAqLwogCXU4IHJhZGFyX2RldGVjdF9yZWdpb25zOwotCi0JLyoq
Ci0JICogQGJlYWNvbl9pbnRfbWluX2djZDoKLQkgKiBUaGlzIGludGVyZmFjZSBjb21iaW5hdGlv
biBzdXBwb3J0cyBkaWZmZXJlbnQgYmVhY29uIGludGVydmFscy4KLQkgKgotCSAqID0gMAotCSAq
ICAgYWxsIGJlYWNvbiBpbnRlcnZhbHMgZm9yIGRpZmZlcmVudCBpbnRlcmZhY2UgbXVzdCBiZSBz
YW1lLgotCSAqID4gMAotCSAqICAgYW55IGJlYWNvbiBpbnRlcnZhbCBmb3IgdGhlIGludGVyZmFj
ZSBwYXJ0IG9mIHRoaXMgY29tYmluYXRpb24gQU5ECi0JICogICBHQ0Qgb2YgYWxsIGJlYWNvbiBp
bnRlcnZhbHMgZnJvbSBiZWFjb25pbmcgaW50ZXJmYWNlcyBvZiB0aGlzCi0JICogICBjb21iaW5h
dGlvbiBtdXN0IGJlIGdyZWF0ZXIgb3IgZXF1YWwgdG8gdGhpcyB2YWx1ZS4KLQkgKi8KIAl1MzIg
YmVhY29uX2ludF9taW5fZ2NkOwogfTsKIAotLSAKMi4yNS4wCgo=
