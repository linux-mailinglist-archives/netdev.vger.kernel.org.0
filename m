Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8380C75971
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 23:22:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfGYVWl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jul 2019 17:22:41 -0400
Received: from mail-eopbgr20065.outbound.protection.outlook.com ([40.107.2.65]:19843
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726585AbfGYVWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jul 2019 17:22:41 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YGp+2p8Q9Hhq/fubcIA6f6lqJEUpSSuOeIM7T7YiIHOjdi0uIHn0PzXpKYgmn8dIg2CY2Mzutw8jcyWJCilmeocrxy7IeUBIfOQFrvdZybe5RVF+Vagr4UATMt6N16tpazPXhP+3iKhaxpaBu5Ai9IUTj4kQUy9pQm7SOW5KmTIvom9lifqXiY51AX0Fa6PaN0YCYqc8UvmzQGi5ScxptbuMRjPGYn/JQ0eEOG0i2gTDRvFFLiG1AHUenpenx3DnKnobGCcuDW7Ka8UnJ1hRUM0G1fXRTk8Np1HP1n7dh1/xgNWJ10L4kkhEl4U80XoLQRDjZCXqE4leUVVErnql2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkOvDFEO+SPkk4/mPfZEnHQdIZWhTByhveR/x7mds4g=;
 b=lhSewKH8oG+XsZP0ExPnPceQ0aZcXq+AlFaxSYK/ieWNxiyGqdb6zc0eZR3MrealK1FGSPsyJZQWQy3CPYGOuN+1xd/fMoBrJEzDC8MkGTTwVFAJjBo9KoZL0IRwkV66/Q314zOvD+BWRwp8y/iofWsz9PBuN+pr95XxNy6vWjqBcargCdHtzoh0CzFKiZYiKAk0O/DJJpSwmBzBuPWPRhWwy44UbOwAuFbgJwgABtn7/lY1+3z4tOmnrIv5Ntrozt2/WMmkHwkzL+LVOo9rgknIPXxXv4s3b2x2YmGEf8JuV2SzVXhtfx9pYPAWqNQIu0mZKf1yQ52ZiCqjCMkrMA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zkOvDFEO+SPkk4/mPfZEnHQdIZWhTByhveR/x7mds4g=;
 b=lA5rX56Go13sBEt/25ZvzYuvnMP22H/pRwtRqXECsZXr0NjdZb4kQlUcoFvFTSwj4m7ndbrvXTJAQtxgPC0djH0vGo8wgbNvbypUJfTO1twIfibv9EqK/W1LmHiWUvthXFtJO+TeZtXoYldUL5sRbibMyjlZeU7D+xUJLkW8hY8=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2280.eurprd05.prod.outlook.com (10.168.55.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Thu, 25 Jul 2019 21:22:37 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Thu, 25 Jul 2019
 21:22:37 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "wenxu@ucloud.cn" <wenxu@ucloud.cn>, Roi Dayan <roid@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Mark Bloch <markb@mellanox.com>,
        Paul Blakey <paulb@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH] net/mlx5e: Fix zero table prio set by user.
Thread-Topic: [PATCH] net/mlx5e: Fix zero table prio set by user.
Thread-Index: AQHVQtt/x6xrhluvM0OJIHhyhV29vabb2G8A
Date:   Thu, 25 Jul 2019 21:22:36 +0000
Message-ID: <7b03d1fdda172ce99c3693d8403cbdaf5a31bb6c.camel@mellanox.com>
References: <1564053847-28756-1-git-send-email-wenxu@ucloud.cn>
In-Reply-To: <1564053847-28756-1-git-send-email-wenxu@ucloud.cn>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 971c84a3-7390-4dd6-1535-08d711463761
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2280;
x-ms-traffictypediagnostic: DB6PR0501MB2280:
x-microsoft-antispam-prvs: <DB6PR0501MB2280C108CFCC0FEC1BD4A451BEC10@DB6PR0501MB2280.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0109D382B0
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(366004)(376002)(396003)(346002)(199004)(189003)(11346002)(486006)(6116002)(76176011)(2906002)(8936002)(476003)(2616005)(81166006)(64756008)(2501003)(6636002)(102836004)(99286004)(81156014)(446003)(66476007)(14454004)(36756003)(71190400001)(26005)(71200400001)(186003)(229853002)(118296001)(6486002)(66066001)(53936002)(5660300002)(4326008)(6246003)(8676002)(6512007)(3846002)(91956017)(110136005)(316002)(86362001)(14444005)(7736002)(25786009)(58126008)(305945005)(478600001)(256004)(68736007)(66446008)(76116006)(66946007)(66556008)(6506007)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2280;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OAQ5Mgrzm7OasDhkFapS0uw5V2BjRMUozLbtYypP8UHITUxrmoGYOgS8OsVtwM9zbFTcKMEPUdwnFt0jtX+9LwSd1gQvrcKR1PYAHizihb3K6ZLtHAj8kG0pb9mfVUWQHTlEByFpKKPTJzLRmzvAkknEkyZqVqPSXMX3/jtQlZ5JRwJB0f/8l2/DZfsv5ZyyKTFZYZHjQwoSTRvCjiL3HpP3Jlh4cTFaltR9xAFdys1gFiGX/xS3zjJmnwAqJsDvPSvzrv+gnnVJ7cli93nQWiw7mHvouUq3dFi6e+JxNZoPOGaoXsL3sUaMt7OjBkeb+Xrg5qQtV/Wu6/SiuEO8UYXWHdwjO6DZlTmWy2AWNyGRN41fmtExZJ+fkQYR5JpIfmZVUtMGji8I751WOcPj2YWbmDe1Pv9dB0CM6vC9vhY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <A9FA3D19FDDC1F4C9AE99361EFD9903D@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 971c84a3-7390-4dd6-1535-08d711463761
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jul 2019 21:22:36.8767
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2280
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA3LTI1IGF0IDE5OjI0ICswODAwLCB3ZW54dUB1Y2xvdWQuY24gd3JvdGU6
DQo+IEZyb206IHdlbnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IA0KPiBUaGUgZmxvd19jbHNfY29t
bW9uX29mZmxvYWQgcHJpbyBpcyB6ZXJvDQo+IA0KPiBJdCBsZWFkcyB0aGUgaW52YWxpZCB0YWJs
ZSBwcmlvIGluIGh3Lg0KPiANCj4gRXJyb3I6IENvdWxkIG5vdCBwcm9jZXNzIHJ1bGU6IEludmFs
aWQgYXJndW1lbnQNCj4gDQo+IGtlcm5lbCBsb2c6DQo+IG1seDVfY29yZSAwMDAwOjgxOjAwLjA6
IEUtU3dpdGNoOiBGYWlsZWQgdG8gY3JlYXRlIEZEQiBUYWJsZSBlcnIgLTIyDQo+ICh0YWJsZSBw
cmlvOiA2NTUzNSwgbGV2ZWw6IDAsIHNpemU6IDQxOTQzMDQpDQo+IA0KPiB0YWJsZV9wcmlvID0g
KGNoYWluICogRkRCX01BWF9QUklPKSArIHByaW8gLSAxOw0KPiBzaG91bGQgY2hlY2sgKGNoYWlu
ICogRkRCX01BWF9QUklPKSArIHByaW8gaXMgbm90IDANCj4gDQo+IFNpZ25lZC1vZmYtYnk6IHdl
bnh1IDx3ZW54dUB1Y2xvdWQuY24+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVs
bGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hfb2ZmbG9hZHMuYyB8IDQgKysrLQ0KPiAgMSBmaWxlIGNo
YW5nZWQsIDMgaW5zZXJ0aW9ucygrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdA0K
PiBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxv
YWRzLmMNCj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZXN3aXRj
aF9vZmZsb2Fkcy5jDQo+IGluZGV4IDA4OWFlNGQuLjY0Y2E5MGYgMTAwNjQ0DQo+IC0tLSBhL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lc3dpdGNoX29mZmxvYWRzLmMN
Cj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2Vzd2l0Y2hf
b2ZmbG9hZHMuYw0KPiBAQCAtOTcwLDcgKzk3MCw5IEBAIHN0YXRpYyBpbnQgZXN3X2FkZF9mZGJf
bWlzc19ydWxlKHN0cnVjdCANCg0KdGhpcyBwaWVjZSBvZiBjb2RlIGlzbid0IGluIHRoaXMgZnVu
Y3Rpb24sIHdlaXJkIGhvdyBpdCBnb3QgdG8gdGhlDQpkaWZmLCBwYXRjaCBhcHBsaWVzIGNvcnJl
Y3RseSB0aG91Z2ggIQ0KDQo+IG1seDVfZXN3aXRjaCAqZXN3KQ0KPiAgCQlmbGFncyB8PSAoTUxY
NV9GTE9XX1RBQkxFX1RVTk5FTF9FTl9SRUZPUk1BVCB8DQo+ICAJCQkgIE1MWDVfRkxPV19UQUJM
RV9UVU5ORUxfRU5fREVDQVApOw0KPiAgDQo+IC0JdGFibGVfcHJpbyA9IChjaGFpbiAqIEZEQl9N
QVhfUFJJTykgKyBwcmlvIC0gMTsNCj4gKwl0YWJsZV9wcmlvID0gKGNoYWluICogRkRCX01BWF9Q
UklPKSArIHByaW87DQo+ICsJaWYgKHRhYmxlX3ByaW8pDQo+ICsJCXRhYmxlX3ByaW8gPSB0YWJs
ZV9wcmlvIC0gMTsNCj4gIA0KDQpUaGlzIGlzIGJsYWNrIG1hZ2ljLCBldmVuIGJlZm9yZSB0aGlz
IGZpeC4NCnRoaXMgLTEgc2VlbXMgdG8gYmUgbmVlZGVkIGluIG9yZGVyIHRvIGNhbGwNCmNyZWF0
ZV9uZXh0X3NpemVfdGFibGUodGFibGVfcHJpbykgd2l0aCB0aGUgcHJldmlvdXMgInRhYmxlIHBy
aW8iID8NCih0YWJsZV9wcmlvIC0gMSkgID8NCg0KVGhlIHdob2xlIHRoaW5nIGxvb2tzIHdyb25n
IHRvIG1lIHNpbmNlIHdoZW4gcHJpbyBpcyAwIGFuZCBjaGFpbiBpcyAwLA0KdGhlcmUgaXMgbm90
IHN1Y2ggdGhpbmcgdGFibGVfcHJpbyAtIDEuDQoNCm1sbnggZXN3aXRjaCBndXlzIGluIHRoZSBj
YywgcGxlYXNlIGFkdmlzZS4NCg0KVGhhbmtzLA0KU2FlZWQuDQoNCj4gIAkvKiBjcmVhdGUgZWFy
bGllciBsZXZlbHMgZm9yIGNvcnJlY3QgZnNfY29yZSBsb29rdXAgd2hlbg0KPiAgCSAqIGNvbm5l
Y3RpbmcgdGFibGVzDQo=
