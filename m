Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB2620A28
	for <lists+netdev@lfdr.de>; Thu, 16 May 2019 16:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727339AbfEPOwY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 May 2019 10:52:24 -0400
Received: from mail-eopbgr690053.outbound.protection.outlook.com ([40.107.69.53]:19693
        "EHLO NAM04-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726736AbfEPOwX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 May 2019 10:52:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TppCjx/zgI5exUWP22rpAabHkY6qrlsVIoXzt3NkfFA=;
 b=tqRANOmAp+8PWcQUWI9dL0ivkkT9+FstOnocS/qAymTdPyijaPIWRUx2vGS9EmMnKxzDNN9YdT8BNRNX81Dl+Pfi4wyeuaW4mtQ90WvlyuxxNkvvcFehJkZWg1rBH3NbB2rXRJKSc+gyKzCgr1FT2C/9ufcvPEUsRum6wncgGrM=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3659.namprd11.prod.outlook.com (20.178.231.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.16; Thu, 16 May 2019 14:52:20 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::512d:4596:4513:424a%5]) with mapi id 15.20.1900.010; Thu, 16 May 2019
 14:52:20 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "David S . Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Oliver Neukum <oneukum@suse.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net 1/3] Revert "aqc111: fix double endianness swap on BE"
Thread-Topic: [PATCH net 1/3] Revert "aqc111: fix double endianness swap on
 BE"
Thread-Index: AQHVC/b2hw7QUOpyhEaktibpGYD1dg==
Date:   Thu, 16 May 2019 14:52:20 +0000
Message-ID: <259b21722e914287c0f15ca0ebfd1225aff7ba3a.1558017386.git.igor.russkikh@aquantia.com>
References: <cover.1558017386.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1558017386.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: HE1P195CA0010.EURP195.PROD.OUTLOOK.COM (2603:10a6:3:fd::20)
 To DM6PR11MB3625.namprd11.prod.outlook.com (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: af5fefb8-c2df-4ab4-3cae-08d6da0e18f7
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3659;
x-ms-traffictypediagnostic: DM6PR11MB3659:
x-microsoft-antispam-prvs: <DM6PR11MB3659A1EEEF92B9CB62EFA7C2980A0@DM6PR11MB3659.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:211;
x-forefront-prvs: 0039C6E5C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39850400004)(136003)(346002)(396003)(376002)(189003)(199004)(53936002)(6436002)(99286004)(54906003)(316002)(118296001)(14454004)(2906002)(50226002)(6512007)(6486002)(73956011)(478600001)(86362001)(5660300002)(8936002)(305945005)(66066001)(102836004)(72206003)(476003)(81166006)(2616005)(11346002)(36756003)(66446008)(64756008)(66556008)(7736002)(68736007)(446003)(81156014)(66476007)(8676002)(3846002)(76176011)(26005)(6916009)(44832011)(52116002)(71190400001)(71200400001)(107886003)(66946007)(6116002)(486006)(256004)(186003)(4326008)(14444005)(386003)(6506007)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3659;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LpD+VbHQld2z2xUme/uyxk/8MU6N+NHUFCsEruwhMj7JJZpRx6ksmyO+QMrvo/ggkAFPYl+p6CJMg4prkVpLXTEM/w7f1eVc/M7fCdRfzzQ7mlh0NZyIetANynMR5LR0qKG6X1GY4mvmA37Xxupoh0gDlgHXdFCe8QCFjhsvMgpZF5cxGwEMPqOryBs7RJpy2Tcrg47sWMdaQ/hJov4Rw9CmnZarKrO2283dL/srwRJp1fMQ1MDr0KvqUBheO6eKTfXALgFeb6y86b3z7JC++/fxeCLrFOwub1HDO0NnnvYVRE3xpYhAvkCvhHxOuZDXO1zUXSjDzNT+l/vZu29Wo6JTQINdZ17zI3gh+nKdnIviqqV3REMPfZgn+nzUcFju1w3Q0v1CQYf6iBpcK/AEOWBgqVOxH3S9KDylO+4qRX4=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: af5fefb8-c2df-4ab4-3cae-08d6da0e18f7
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 May 2019 14:52:20.5775
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3659
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

VGhpcyByZXZlcnRzIGNvbW1pdCAyY2Y2NzI3MDliZWIwMDVmNmU5MGNiNGVkYmVkNmYyMjE4YmE5
NTNlLg0KDQpUaGUgcmVxdWlyZWQgdGVtcG9yYXJ5IHN0b3JhZ2UgaXMgYWxyZWFkeSBkb25lIGlu
c2lkZSBvZiB3cml0ZTMyLzE2DQpoZWxwZXJzLg0KDQpTaWduZWQtb2ZmLWJ5OiBJZ29yIFJ1c3Nr
aWtoIDxpZ29yLnJ1c3NraWtoQGFxdWFudGlhLmNvbT4NCi0tLQ0KIGRyaXZlcnMvbmV0L3VzYi9h
cWMxMTEuYyB8IDYgKystLS0tDQogMSBmaWxlIGNoYW5nZWQsIDIgaW5zZXJ0aW9ucygrKSwgNCBk
ZWxldGlvbnMoLSkNCg0KZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3VzYi9hcWMxMTEuYyBiL2Ry
aXZlcnMvbmV0L3VzYi9hcWMxMTEuYw0KaW5kZXggYjg2YzVjZTlhOTJhLi41OTlkNTYwYTg0NTAg
MTAwNjQ0DQotLS0gYS9kcml2ZXJzL25ldC91c2IvYXFjMTExLmMNCisrKyBiL2RyaXZlcnMvbmV0
L3VzYi9hcWMxMTEuYw0KQEAgLTE0MjgsNyArMTQyOCw3IEBAIHN0YXRpYyBpbnQgYXFjMTExX3Jl
c3VtZShzdHJ1Y3QgdXNiX2ludGVyZmFjZSAqaW50ZikNCiB7DQogCXN0cnVjdCB1c2JuZXQgKmRl
diA9IHVzYl9nZXRfaW50ZmRhdGEoaW50Zik7DQogCXN0cnVjdCBhcWMxMTFfZGF0YSAqYXFjMTEx
X2RhdGEgPSBkZXYtPmRyaXZlcl9wcml2Ow0KLQl1MTYgcmVnMTYsIG9sZHJlZzE2Ow0KKwl1MTYg
cmVnMTY7DQogCXU4IHJlZzg7DQogDQogCW5ldGlmX2NhcnJpZXJfb2ZmKGRldi0+bmV0KTsNCkBA
IC0xNDQ0LDExICsxNDQ0LDkgQEAgc3RhdGljIGludCBhcWMxMTFfcmVzdW1lKHN0cnVjdCB1c2Jf
aW50ZXJmYWNlICppbnRmKQ0KIAkvKiBDb25maWd1cmUgUlggY29udHJvbCByZWdpc3RlciA9PiBz
dGFydCBvcGVyYXRpb24gKi8NCiAJcmVnMTYgPSBhcWMxMTFfZGF0YS0+cnhjdGw7DQogCXJlZzE2
ICY9IH5TRlJfUlhfQ1RMX1NUQVJUOw0KLQkvKiBuZWVkcyB0byBiZSBzYXZlZCBpbiBjYXNlIGVu
ZGlhbm5lc3MgaXMgc3dhcHBlZCAqLw0KLQlvbGRyZWcxNiA9IHJlZzE2Ow0KIAlhcWMxMTFfd3Jp
dGUxNl9jbWRfbm9wbShkZXYsIEFRX0FDQ0VTU19NQUMsIFNGUl9SWF9DVEwsIDIsICZyZWcxNik7
DQogDQotCXJlZzE2ID0gb2xkcmVnMTYgfCBTRlJfUlhfQ1RMX1NUQVJUOw0KKwlyZWcxNiB8PSBT
RlJfUlhfQ1RMX1NUQVJUOw0KIAlhcWMxMTFfd3JpdGUxNl9jbWRfbm9wbShkZXYsIEFRX0FDQ0VT
U19NQUMsIFNGUl9SWF9DVEwsIDIsICZyZWcxNik7DQogDQogCWFxYzExMV9zZXRfcGh5X3NwZWVk
KGRldiwgYXFjMTExX2RhdGEtPmF1dG9uZWcsDQotLSANCjIuMTcuMQ0KDQo=
