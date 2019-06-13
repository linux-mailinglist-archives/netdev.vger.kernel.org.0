Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30C0C44D9E
	for <lists+netdev@lfdr.de>; Thu, 13 Jun 2019 22:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729947AbfFMUjv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Jun 2019 16:39:51 -0400
Received: from mail-eopbgr30082.outbound.protection.outlook.com ([40.107.3.82]:64391
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729558AbfFMUjv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 Jun 2019 16:39:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ChaPQ54ies0ai4o1Nx+r2CYr1TSqBB126FD8wq+ahFU=;
 b=K0SqP8IM/Jyd0LDvUeGPeRiQeZadDColJb1eTn4hJRFsNeV5OafEDG0UGrTpVHQQ2rld0wdjgpbfX4vlJBobYw6gNqotTRU+M3IkZMfbpn2APCrqmnL9CUJ6u8feCSRpDjlaL9mw9gfUjg946f5uAjhvVb0R8ySPSCPY/RH32Bs=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2760.eurprd05.prod.outlook.com (10.172.226.150) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1987.12; Thu, 13 Jun 2019 20:39:44 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.1987.012; Thu, 13 Jun 2019
 20:39:44 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Jiri Pirko <jiri@mellanox.com>,
        Moshe Shemesh <moshe@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next v2 15/15] Documentation: net: mlx5: Devlink health
 documentation
Thread-Topic: [net-next v2 15/15] Documentation: net: mlx5: Devlink health
 documentation
Thread-Index: AQHVIigiRUV8K9SOZUiH0K/earEkDw==
Date:   Thu, 13 Jun 2019 20:39:44 +0000
Message-ID: <20190613203825.31049-16-saeedm@mellanox.com>
References: <20190613203825.31049-1-saeedm@mellanox.com>
In-Reply-To: <20190613203825.31049-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR02CA0020.namprd02.prod.outlook.com
 (2603:10b6:a02:ee::33) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ed30cdf4-d426-4a75-9f5e-08d6f03f445e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2760;
x-ms-traffictypediagnostic: DB6PR0501MB2760:
x-microsoft-antispam-prvs: <DB6PR0501MB276034BB2CACEC7072401F9BBEEF0@DB6PR0501MB2760.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0067A8BA2A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(39860400002)(376002)(136003)(346002)(199004)(189003)(478600001)(68736007)(6486002)(86362001)(476003)(2616005)(14454004)(64756008)(66556008)(446003)(66946007)(11346002)(71190400001)(71200400001)(66446008)(73956011)(6436002)(25786009)(6512007)(6916009)(486006)(99286004)(107886003)(36756003)(1076003)(186003)(8676002)(81166006)(53936002)(81156014)(7736002)(5660300002)(76176011)(54906003)(305945005)(386003)(316002)(8936002)(6506007)(50226002)(256004)(2906002)(3846002)(66476007)(66066001)(102836004)(26005)(4326008)(52116002)(6116002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2760;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: XmwCUj/w8G0CN113RFygm7Z4TRcJw1LCIba5yw7Z8BFjZI9R/+tbKSwyW/oQqBwkiEtwY81ryvgwSGfaC8V1t6qDny+oFiLHK9z5tIp53vvaGA+HCC2lYsmQxvEgp9dPSg6+wg8FGopJXUs0EgxWoM13tw+KEJIhqALk4BIvQU0jfHtoPMYGSn3d/vows2Nut1Q/Q+fSO5g34qRenKvS3v3Rz9eRNtbG7Klb5DW/rJReWeDUZnHihUneACIBDO2z6ErEr1hKjHT1YfaeVFbO6qcg9Pzjl111uD7hh4KlToL4jJZ4WdAjYnD6zTFTgp30KFdNhr/L/IWmFpOG+jIX6wGCFm+DsR4LkkkfPQdHa0LDU++LZ2hWhQiaPCaam0yoaTSoP4xfnxI35qN4nsHatho8McjZZcLLzk4mVLYvImQ=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ed30cdf4-d426-4a75-9f5e-08d6f03f445e
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 Jun 2019 20:39:44.7908
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2760
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogTW9zaGUgU2hlbWVzaCA8bW9zaGVAbWVsbGFub3guY29tPg0KDQpEb2N1bWVudGF0aW9u
IGZvciBkZXZsaW5rIGhlYWx0aCByZXBvcnRlcnMgc3VwcG9ydGVkIGJ5IG1seDUuDQoNClNpZ25l
ZC1vZmYtYnk6IE1vc2hlIFNoZW1lc2ggPG1vc2hlQG1lbGxhbm94LmNvbT4NClNpZ25lZC1vZmYt
Ynk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KLS0tDQogLi4uL2Rldmlj
ZV9kcml2ZXJzL21lbGxhbm94L21seDUucnN0ICAgICAgICAgIHwgNzIgKysrKysrKysrKysrKysr
KysrKw0KIDEgZmlsZSBjaGFuZ2VkLCA3MiBpbnNlcnRpb25zKCspDQoNCmRpZmYgLS1naXQgYS9E
b2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZGV2aWNlX2RyaXZlcnMvbWVsbGFub3gvbWx4NS5yc3Qg
Yi9Eb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZGV2aWNlX2RyaXZlcnMvbWVsbGFub3gvbWx4NS5y
c3QNCmluZGV4IDBiZTgwMjE4NmQxMi4uNGVlZWYyZGY5MTJmIDEwMDY0NA0KLS0tIGEvRG9jdW1l
bnRhdGlvbi9uZXR3b3JraW5nL2RldmljZV9kcml2ZXJzL21lbGxhbm94L21seDUucnN0DQorKysg
Yi9Eb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZGV2aWNlX2RyaXZlcnMvbWVsbGFub3gvbWx4NS5y
c3QNCkBAIC0xMCw2ICsxMCw3IEBAIENvbnRlbnRzDQogPT09PT09PT0NCiANCiAtIGBFbmFibGlu
ZyB0aGUgZHJpdmVyIGFuZCBrY29uZmlnIG9wdGlvbnNgXw0KKy0gYERldmxpbmsgaGVhbHRoIHJl
cG9ydGVyc2BfDQogDQogRW5hYmxpbmcgdGhlIGRyaXZlciBhbmQga2NvbmZpZyBvcHRpb25zDQog
PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09PT09DQpAQCAtOTks
MyArMTAwLDc0IEBAIEVuYWJsaW5nIHRoZSBkcml2ZXIgYW5kIGtjb25maWcgb3B0aW9ucw0KIC0g
Q09ORklHX1BUUF8xNTg4X0NMT0NLOiBXaGVuIGNob3NlbiwgbWx4NSBwdHAgc3VwcG9ydCB3aWxs
IGJlIGVuYWJsZWQNCiAtIENPTkZJR19WWExBTjogV2hlbiBjaG9zZW4sIG1seDUgdnhhbG4gc3Vw
cG9ydCB3aWxsIGJlIGVuYWJsZWQuDQogLSBDT05GSUdfTUxYRlc6IFdoZW4gY2hvc2VuLCBtbHg1
IGZpcm13YXJlIGZsYXNoaW5nIHN1cHBvcnQgd2lsbCBiZSBlbmFibGVkICh2aWEgZGV2bGluayBh
bmQgZXRodG9vbCkuDQorDQorDQorRGV2bGluayBoZWFsdGggcmVwb3J0ZXJzDQorPT09PT09PT09
PT09PT09PT09PT09PT09DQorDQordHggcmVwb3J0ZXINCistLS0tLS0tLS0tLQ0KK1RoZSB0eCBy
ZXBvcnRlciBpcyByZXNwb25zaWJsZSBvZiB0d28gZXJyb3Igc2NlbmFyaW9zOg0KKw0KKy0gVFgg
dGltZW91dA0KKyAgICBSZXBvcnQgb24ga2VybmVsIHR4IHRpbWVvdXQgZGV0ZWN0aW9uLg0KKyAg
ICBSZWNvdmVyIGJ5IHNlYXJjaGluZyBsb3N0IGludGVycnVwdHMuDQorLSBUWCBlcnJvciBjb21w
bGV0aW9uDQorICAgIFJlcG9ydCBvbiBlcnJvciB0eCBjb21wbGV0aW9uLg0KKyAgICBSZWNvdmVy
IGJ5IGZsdXNoaW5nIHRoZSBUWCBxdWV1ZSBhbmQgcmVzZXQgaXQuDQorDQorVFggcmVwb3J0ZXIg
YWxzbyBzdXBwb3J0IERpYWdub3NlIGNhbGxiYWNrLCBvbiB3aGljaCBpdCBwcm92aWRlcw0KK3Jl
YWwgdGltZSBpbmZvcm1hdGlvbiBvZiBpdHMgc2VuZCBxdWV1ZXMgc3RhdHVzLg0KKw0KK1VzZXIg
Y29tbWFuZHMgZXhhbXBsZXM6DQorDQorLSBEaWFnbm9zZSBzZW5kIHF1ZXVlcyBzdGF0dXM6Og0K
Kw0KKyAgICAkIGRldmxpbmsgaGVhbHRoIGRpYWdub3NlIHBjaS8wMDAwOjgyOjAwLjAgcmVwb3J0
ZXIgdHgNCisNCistIFNob3cgbnVtYmVyIG9mIHR4IGVycm9ycyBpbmRpY2F0ZWQsIG51bWJlciBv
ZiByZWNvdmVyIGZsb3dzIGVuZGVkIHN1Y2Nlc3NmdWxseSwNCisgIGlzIGF1dG9yZWNvdmVyIGVu
YWJsZWQgYW5kIGdyYWNlZnVsIHBlcmlvZCBmcm9tIGxhc3QgcmVjb3Zlcjo6DQorDQorICAgICQg
ZGV2bGluayBoZWFsdGggc2hvdyBwY2kvMDAwMDo4MjowMC4wIHJlcG9ydGVyIHR4DQorDQorZncg
cmVwb3J0ZXINCistLS0tLS0tLS0tLQ0KK1RoZSBmdyByZXBvcnRlciBpbXBsZW1lbnRzIGRpYWdu
b3NlIGFuZCBkdW1wIGNhbGxiYWNrcy4NCitJdCBmb2xsb3dzIHN5bXB0b21zIG9mIGZ3IGVycm9y
IHN1Y2ggYXMgZncgc3luZHJvbWUgYnkgdHJpZ2dlcmluZw0KK2Z3IGNvcmUgZHVtcCBhbmQgc3Rv
cmluZyBpdCBpbnRvIHRoZSBkdW1wIGJ1ZmZlci4NCitUaGUgZncgcmVwb3J0ZXIgZGlhZ25vc2Ug
Y29tbWFuZCBjYW4gYmUgdHJpZ2dlcmVkIGFueSB0aW1lIGJ5IHRoZSB1c2VyIHRvIGNoZWNrDQor
Y3VycmVudCBmdyBzdGF0dXMuDQorDQorVXNlciBjb21tYW5kcyBleGFtcGxlczoNCisNCistIENo
ZWNrIGZ3IGhlYXRoIHN0YXR1czo6DQorDQorICAgICQgZGV2bGluayBoZWFsdGggZGlhZ25vc2Ug
cGNpLzAwMDA6ODI6MDAuMCByZXBvcnRlciBmdw0KKw0KKy0gUmVhZCBGVyBjb3JlIGR1bXAgaWYg
YWxyZWFkeSBzdG9yZWQgb3IgdHJpZ2dlciBuZXcgb25lOjoNCisNCisgICAgJCBkZXZsaW5rIGhl
YWx0aCBkdW1wIHNob3cgcGNpLzAwMDA6ODI6MDAuMCByZXBvcnRlciBmdw0KKw0KK05PVEU6IFRo
aXMgY29tbWFuZCBjYW4gcnVuIG9ubHkgb24gdGhlIFBGIHdoaWNoIGhhcyBmdyB0cmFjZXIgb3du
ZXJzaGlwLA0KK3J1bm5pbmcgaXQgb24gb3RoZXIgUEYgb3IgYW55IFZGIHdpbGwgcmV0dXJuICJP
cGVyYXRpb24gbm90IHBlcm1pdHRlZCIuDQorDQorZncgZmF0YWwgcmVwb3J0ZXINCistLS0tLS0t
LS0tLS0tLS0tLQ0KK1RoZSBmdyBmYXRhbCByZXBvcnRlciBpbXBsZW1lbnRzIGR1bXAgYW5kIHJl
Y292ZXIgY2FsbGJhY2tzLg0KK0l0IGZvbGxvd3MgZmF0YWwgZXJyb3JzIGluZGljYXRpb25zIGJ5
IENSLXNwYWNlIGR1bXAgYW5kIHJlY292ZXIgZmxvdy4NCitUaGUgQ1Itc3BhY2UgZHVtcCB1c2Vz
IHZzYyBpbnRlcmZhY2Ugd2hpY2ggaXMgdmFsaWQgZXZlbiBpZiB0aGUgRlcgY29tbWFuZA0KK2lu
dGVyZmFjZSBpcyBub3QgZnVuY3Rpb25hbCwgd2hpY2ggaXMgdGhlIGNhc2UgaW4gbW9zdCBGVyBm
YXRhbCBlcnJvcnMuDQorVGhlIHJlY292ZXIgZnVuY3Rpb24gcnVucyByZWNvdmVyIGZsb3cgd2hp
Y2ggcmVsb2FkcyB0aGUgZHJpdmVyIGFuZCB0cmlnZ2VycyBmdw0KK3Jlc2V0IGlmIG5lZWRlZC4N
CisNCitVc2VyIGNvbW1hbmRzIGV4YW1wbGVzOg0KKw0KKy0gUnVuIGZ3IHJlY292ZXIgZmxvdyBt
YW51YWxseTo6DQorDQorICAgICQgZGV2bGluayBoZWFsdGggcmVjb3ZlciBwY2kvMDAwMDo4Mjow
MC4wIHJlcG9ydGVyIGZ3X2ZhdGFsDQorDQorLSBSZWFkIEZXIENSLXNwYWNlIGR1bXAgaWYgYWxy
ZWFkeSBzdHJvcmVkIG9yIHRyaWdnZXIgbmV3IG9uZTo6DQorDQorICAgICQgZGV2bGluayBoZWFs
dGggZHVtcCBzaG93IHBjaS8wMDAwOjgyOjAwLjEgcmVwb3J0ZXIgZndfZmF0YWwNCisNCitOT1RF
OiBUaGlzIGNvbW1hbmQgY2FuIHJ1biBvbmx5IG9uIFBGLg0KLS0gDQoyLjIxLjANCg0K
