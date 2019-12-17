Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50B8E123179
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 17:15:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728927AbfLQQPl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 11:15:41 -0500
Received: from mail-bn8nam11on2073.outbound.protection.outlook.com ([40.107.236.73]:39265
        "EHLO NAM11-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728815AbfLQQPN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 11:15:13 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fN2N8guRCItW+EEg/Hkj/ukOSc+A5qgpMgCCbDuS1aKr60NR79F6wKAd+D0J7vZtW8rT2CknmAmW3ChADexCzNnfthOeb5UDDSbQIYxNd4iiisOt1dQXORvgp58bBi/To/qexgnmhxqkf2X5n9YpE8PHftV3c3ZswKBX7Yc2Af+RZQv/iaUFS1CqmfHPShl7wT5+pS4aP/43a4QJ1H6VOjTjVMXFC5/zkXJSRRnpAS5fyyDVlsMQQ7ZJXOOLNRubJW9z/H03uLETvnDXRBSnltTPoj03KioXDVWwzwx8Jo6evslazAAyuvSMRypYtlcQM7XSs90QsjI5dVdVoqu1Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzJ9Km3ztcZj3nWkxD6oAFc1JunTerw1K22+aUHSyQY=;
 b=Q8/+Q6MQrVYzLzCl95yiNzpKTskyfZ0zwQLtq+jUgezGbehSPq3aMakC6fc+ISNm3tNDD4oiciGd/yQ3matAg7czY92Dnx8Gq6ouGY/BNtVkhbinS+GaXOxv8yYzRsh2nOYqVJbqAAwBPSrQ8rckr7JM1xVp11mCniC6seXcfkOTwI0JYW9au3X93Na7+6VFQSbuY2mHZA/iFAg2rsx7fHuTyIFMFYk7VtH2Q8tvL3dd8tvErpxaOGRbN4mR2ogsloiybReWdcw2X5K4PwAv+6EZHRF8cJ4Pr6S4Ng2ZfoQV2wLEaOWNglj/Y1a8rhllqSpCWIpCoZWE4cpcL6/tVQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=silabs.com; dmarc=pass action=none header.from=silabs.com;
 dkim=pass header.d=silabs.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=silabs.onmicrosoft.com; s=selector2-silabs-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yzJ9Km3ztcZj3nWkxD6oAFc1JunTerw1K22+aUHSyQY=;
 b=hHUPn9FfBs9/BeHAbJ8Yt88Wvffcmd0gAAMHrChMAdFsTmxeJ1D0aDq144b/2s+HFjBMG+ga4FHumvBcHtATBE0qREI+lLAN9vOPZzEs+UKEXiIyHtaqZq/94rdRcAVpQECeRga500kGzbafbVm2qxxNmwSyVMiUV2M98nTznSI=
Received: from MN2PR11MB4063.namprd11.prod.outlook.com (10.255.180.22) by
 MN2PR11MB4208.namprd11.prod.outlook.com (52.135.36.80) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.20; Tue, 17 Dec 2019 16:15:07 +0000
Received: from MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf]) by MN2PR11MB4063.namprd11.prod.outlook.com
 ([fe80::f46c:e5b4:2a85:f0bf%4]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 16:15:07 +0000
From:   =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
To:     "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        =?utf-8?B?SsOpcsO0bWUgUG91aWxsZXI=?= <Jerome.Pouiller@silabs.com>
Subject: [PATCH v2 28/55] staging: wfx: better naming for
 hif_mib_set_association_mode->greenfield
Thread-Topic: [PATCH v2 28/55] staging: wfx: better naming for
 hif_mib_set_association_mode->greenfield
Thread-Index: AQHVtPUlFWQs71+YPUmVM/v2SaPjlg==
Date:   Tue, 17 Dec 2019 16:15:07 +0000
Message-ID: <20191217161318.31402-29-Jerome.Pouiller@silabs.com>
References: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
In-Reply-To: <20191217161318.31402-1-Jerome.Pouiller@silabs.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0174.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::18) To MN2PR11MB4063.namprd11.prod.outlook.com
 (2603:10b6:208:13f::22)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Jerome.Pouiller@silabs.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.24.0
x-originating-ip: [37.71.187.125]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3ca7774f-a86b-43ae-1c39-08d7830c483f
x-ms-traffictypediagnostic: MN2PR11MB4208:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MN2PR11MB42082C2759841F9A1F619C3493500@MN2PR11MB4208.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(396003)(366004)(136003)(376002)(346002)(199004)(189003)(5660300002)(316002)(6506007)(85182001)(478600001)(71200400001)(2906002)(36756003)(186003)(26005)(81166006)(54906003)(1076003)(110136005)(4326008)(8676002)(86362001)(6486002)(52116002)(6512007)(64756008)(85202003)(66946007)(66476007)(66446008)(66556008)(8936002)(107886003)(2616005)(81156014);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR11MB4208;H:MN2PR11MB4063.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: silabs.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1gIGDrfZ4OexfEo9vWRH4GF9pnaGjbr5wGKb0Qao3io5HEWqEGbBErMUUI3Nnx9lfHGP4C3FW7BnCHd8Gd2Cy0mos7GqwI7i5O16M9freK1SZwy6rA+KlK8hirNtk3PT33cqZbesWfH9IUSVaG1ii8eEGb38b2ec6kG/cD9yew4wG1QXuF6KMtit2pUa0n0Q2s2V2dPNsgYrkNvnrVfdkM2VTTtxM2+fDbYZYTWynRHHdminzlfxejKkX9Ep+TaLV09AcRS8nYL/+8kCdDH/SfIcgAm2DqQKCXFVun4cnAoQ4f1a0e7MivDUX7u6g3XqoH4J2alIjT3OSbKIOx4/mhqgBPDGH3n0NbHGWtv58c4QKuc8Iuy6WE+eq5HSWAi+LIjrS5g+m/nNr6nKuZZMjBR1JxUNdk/onVNsq+yzV9FZg8dxsy5EtGTakF8aPUmS
Content-Type: text/plain; charset="utf-8"
Content-ID: <EDE334FD3E22814F8DD42331491EA07F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: silabs.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ca7774f-a86b-43ae-1c39-08d7830c483f
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 16:15:07.2805
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 54dbd822-5231-4b20-944d-6f4abcd541fb
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JuEpEzuH//Z8RYJYo0CVidaLIGYoPqC8vTVbdq+yIDKVUzwq1GfFKY4+VcV/zESom9P16C8BFZGKYJzRDafj4w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR11MB4208
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogSsOpcsO0bWUgUG91aWxsZXIgPGplcm9tZS5wb3VpbGxlckBzaWxhYnMuY29tPgoKQ3Vy
cmVudCBuYW1lICJtaXhlZF9vcl9ncmVlbmZpZWxkX3R5cGUiIGRvZXMgbm90IGFsbG93IHRvIGtu
b3cgaWYKInRydWUiIG1lYW5zICJtaXhlZCIgb2YgImdyZWVuZmllbGQiLiBJdCBpcyBwb3NzaWJs
ZSB0byB1c2UgYSBiZXR0ZXIKbmFtZSBhbmQgZHJvcCAiZW51bSBoaWZfdHhfbW9kZSIuCgpTaWdu
ZWQtb2ZmLWJ5OiBKw6lyw7RtZSBQb3VpbGxlciA8amVyb21lLnBvdWlsbGVyQHNpbGFicy5jb20+
Ci0tLQogZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5oIHwgOCArKy0tLS0tLQogZHJp
dmVycy9zdGFnaW5nL3dmeC9zdGEuYyAgICAgICAgIHwgMiArLQogMiBmaWxlcyBjaGFuZ2VkLCAz
IGluc2VydGlvbnMoKyksIDcgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZHJpdmVycy9zdGFn
aW5nL3dmeC9oaWZfYXBpX21pYi5oIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBpX21pYi5o
CmluZGV4IDM0ZTQzMTBhZDcxZi4uMTYwM2IzMDc0YmY3IDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0
YWdpbmcvd2Z4L2hpZl9hcGlfbWliLmgKKysrIGIvZHJpdmVycy9zdGFnaW5nL3dmeC9oaWZfYXBp
X21pYi5oCkBAIC0zOTUsMTEgKzM5NSw2IEBAIHN0cnVjdCBoaWZfbWliX25vbl9lcnBfcHJvdGVj
dGlvbiB7CiAJdTggICByZXNlcnZlZDJbM107CiB9IF9fcGFja2VkOwogCi1lbnVtIGhpZl90eF9t
b2RlIHsKLQlISUZfVFhfTU9ERV9NSVhFRCAgICAgICAgICAgICAgICAgICAgICAgID0gMHgwLAot
CUhJRl9UWF9NT0RFX0dSRUVORklFTEQgICAgICAgICAgICAgICAgICAgPSAweDEKLX07Ci0KIGVu
dW0gaGlmX3RtcGx0IHsKIAlISUZfVE1QTFRfUFJCUkVRICAgICAgICAgICAgICAgICAgICAgICAg
ICAgPSAweDAsCiAJSElGX1RNUExUX0JDTiAgICAgICAgICAgICAgICAgICAgICAgICAgICAgID0g
MHgxLApAQCAtNDc0LDcgKzQ2OSw4IEBAIHN0cnVjdCBoaWZfbWliX3NldF9hc3NvY2lhdGlvbl9t
b2RlIHsKIAl1OCAgICByZXNlcnZlZDE6NDsKIAl1OCAgICBzaG9ydF9wcmVhbWJsZToxOwogCXU4
ICAgIHJlc2VydmVkMjo3OwotCXU4ICAgIG1peGVkX29yX2dyZWVuZmllbGRfdHlwZTsKKwl1OCAg
ICBncmVlbmZpZWxkOjE7CisJdTggICAgcmVzZXJ2ZWQzOjc7CiAJdTggICAgbXBkdV9zdGFydF9z
cGFjaW5nOwogCXUzMiAgIGJhc2ljX3JhdGVfc2V0OwogfSBfX3BhY2tlZDsKZGlmZiAtLWdpdCBh
L2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMgYi9kcml2ZXJzL3N0YWdpbmcvd2Z4L3N0YS5jCmlu
ZGV4IGU1YzkzMzY3OGM0Ny4uOTM5YzY0ZjEwOGVkIDEwMDY0NAotLS0gYS9kcml2ZXJzL3N0YWdp
bmcvd2Z4L3N0YS5jCisrKyBiL2RyaXZlcnMvc3RhZ2luZy93Zngvc3RhLmMKQEAgLTk5Niw3ICs5
OTYsNyBAQCBzdGF0aWMgdm9pZCB3Znhfam9pbl9maW5hbGl6ZShzdHJ1Y3Qgd2Z4X3ZpZiAqd3Zp
ZiwKIAlhc3NvY2lhdGlvbl9tb2RlLnNwYWNpbmcgPSAxOwogCWFzc29jaWF0aW9uX21vZGUuc2hv
cnRfcHJlYW1ibGUgPSBpbmZvLT51c2Vfc2hvcnRfcHJlYW1ibGU7CiAJYXNzb2NpYXRpb25fbW9k
ZS5iYXNpY19yYXRlX3NldCA9IGNwdV90b19sZTMyKHdmeF9yYXRlX21hc2tfdG9faHcod3ZpZi0+
d2RldiwgaW5mby0+YmFzaWNfcmF0ZXMpKTsKLQlhc3NvY2lhdGlvbl9tb2RlLm1peGVkX29yX2dy
ZWVuZmllbGRfdHlwZSA9IHdmeF9odF9ncmVlbmZpZWxkKCZ3dmlmLT5odF9pbmZvKTsKKwlhc3Nv
Y2lhdGlvbl9tb2RlLmdyZWVuZmllbGQgPSB3ZnhfaHRfZ3JlZW5maWVsZCgmd3ZpZi0+aHRfaW5m
byk7CiAJYXNzb2NpYXRpb25fbW9kZS5tcGR1X3N0YXJ0X3NwYWNpbmcgPSB3ZnhfaHRfYW1wZHVf
ZGVuc2l0eSgmd3ZpZi0+aHRfaW5mbyk7CiAKIAl3ZnhfY3FtX2Jzc2xvc3Nfc20od3ZpZiwgMCwg
MCwgMCk7Ci0tIAoyLjI0LjAKCg==
