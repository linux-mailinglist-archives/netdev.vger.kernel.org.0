Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD2228394A
	for <lists+netdev@lfdr.de>; Tue,  6 Aug 2019 21:04:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfHFTEJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Aug 2019 15:04:09 -0400
Received: from mail-eopbgr130048.outbound.protection.outlook.com ([40.107.13.48]:16907
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725881AbfHFTEJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Aug 2019 15:04:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xj6YbZhP97rhrhlMTBbP7gOi+HwaH+6okc/nmnugDVNYrPilsTsWaC2DbKIK3EMYma2IEa5rujehhfDiqoLSc4efb+85Y+G/1KKdrjvUcao/hIPHn6R9bcYB50Wr4Ioh4fUkvfSEDYrB3OH/lqDtfceUOW+If3UYilSt2juasiovwwb1JrmEanc0NTGOSck8TthuJ30lsLxWKQ1OP6L/DJFMbcLgYerlhDQy+uIJYhLLfBuIdoD1LxAcl0hkNmeL/RnTdmlXkJKuQjrnCCayS+OjZ/zC8hdXcer89fxH+ieGIeuOXZT7vlZ8lKJONKGF/NuymciIP6KFMZWPpUIeSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cdzhe7hzEwLP7IHMdHM295JWd51b6be5k0vyGWxSOuY=;
 b=Bgj65dDMVZhcnPogXWyE+Exbj5X4G2EiqejA2em+LNSDtlSMgiKKQmmkzlVlsCg8Vwl4SofwIBUkb37c6u5d+jYIjgyzNXcoBMzGrFG63MOlLiBYjEibl0AO4tS3l1smpdUt/3oRReFky0SKGAsW8OJF2hJxvhV/NaWwNILByd5rLPWJrxic3lyL1Dh+4gLOhoaE2ZYNzQKueDyXQsccrMgS0hK0rdqD/D7vu432AE3XK3aYtCQx/nXhiyLaUUe7AREEBZ6H3UheS0pscqlB/Tplralvtcs6AX483bEymjn7bzO9iU3vyJDz2F/erAhi6V0uQ0yqpdliuRrRXcm3fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cdzhe7hzEwLP7IHMdHM295JWd51b6be5k0vyGWxSOuY=;
 b=kGO/agjQACbt0K2OBk8vAopdyFDDpcFV+yVagHjd8PlXJA6ofqs3+qD4AD8K2BIzdzbp2RdpbK9MwxyFLDNxlP2CJ5bT8Of+3FU9i5IaE9p0Rfmd1p34JIcQr9zmOvVubZejTkv9CjQEaYIMhraGhZO8ovsn9UC662Dwp72f5EQ=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2677.eurprd05.prod.outlook.com (10.172.225.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Tue, 6 Aug 2019 19:03:57 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2136.018; Tue, 6 Aug 2019
 19:03:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "jonathan.lemon@gmail.com" <jonathan.lemon@gmail.com>
CC:     "kernel-team@fb.com" <kernel-team@fb.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] mlx5: use correct counter
Thread-Topic: [PATCH net-next] mlx5: use correct counter
Thread-Index: AQHVTIS9qOlk2/ASyUOYGqasJ8da1abuelgA
Date:   Tue, 6 Aug 2019 19:03:57 +0000
Message-ID: <128f1f62141faee7620fbe56202f35ec8f6b42b6.camel@mellanox.com>
References: <20190806182819.788750-1-jonathan.lemon@gmail.com>
In-Reply-To: <20190806182819.788750-1-jonathan.lemon@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3dbf3275-5200-4409-eb9c-08d71aa0d56e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2677;
x-ms-traffictypediagnostic: DB6PR0501MB2677:
x-microsoft-antispam-prvs: <DB6PR0501MB2677B13A85931DDF5619E799BED50@DB6PR0501MB2677.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0121F24F22
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(376002)(136003)(396003)(346002)(199004)(189003)(66476007)(66946007)(476003)(256004)(54906003)(36756003)(66446008)(58126008)(64756008)(14444005)(66556008)(305945005)(76116006)(2616005)(7736002)(91956017)(486006)(118296001)(8676002)(3846002)(6116002)(68736007)(2501003)(186003)(316002)(81166006)(6486002)(81156014)(6246003)(71200400001)(71190400001)(478600001)(53936002)(446003)(25786009)(6512007)(6506007)(14454004)(5660300002)(11346002)(86362001)(1361003)(6436002)(66066001)(2351001)(6916009)(2906002)(26005)(4326008)(76176011)(229853002)(8936002)(5640700003)(99286004)(102836004);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2677;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: +vcL61z+bmNTMgWSd2tuwvqGU0XD8u2S5lDkHqbN7sn+hlXwWpVS7GEXfuUIu/Xu1Ahz8m0w1Jon7vZ1grJwXAKNiNb2KlYGrOksTISmztgJNn4/TYBdqtItMK6yRRopBGjDYo5pJdSl+fbJWFE+NE3/3w9X8VkPB0nNtMGcjFWCIuNw+XSgBXK0OfQm9shZmgclTTB0iiWW1a+kyLiypnrElLCyTOM1P52S8QXuh3W1X35LP6BbhYC9s2QMLm1k3aaVN3VJhPWUeENenet6A7v/sjtDscmvf/a41VBieILVUAHgYuA5N12Imu2KPy+QgvVG4m84yeWkMewmXZPlL/+yQv0KIJjODboGf29bFwM+PGRnmQHMIOrm88wsu5PTc0B/Jsnve+1/0iW7dIhHvT9C+SyKOjVCS/HcMjHDC1I=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <27D5798C24E30A449DF21C42340DB4F7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3dbf3275-5200-4409-eb9c-08d71aa0d56e
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Aug 2019 19:03:57.2900
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2677
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA4LTA2IGF0IDExOjI4IC0wNzAwLCBKb25hdGhhbiBMZW1vbiB3cm90ZToN
Cj4gbWx4NWVfZ3JwX3FfdXBkYXRlX3N0YXRzIHNlZW1zIHRvIGJlIHVzaW5nIHRoZSB3cm9uZyBj
b3VudGVyDQo+IGZvciBpZl9kb3duX3BhY2tldHMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBKb25h
dGhhbiBMZW1vbiA8am9uYXRoYW4ubGVtb25AZ21haWwuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMv
bmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9lbl9zdGF0cy5jIHwgMiArLQ0KPiAgMSBm
aWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3N0YXRzLmMN
Cj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW5fc3RhdHMuYw0K
PiBpbmRleCA2ZWVlM2M3ZDRiMDYuLjFkMTZlMDNhOTg3ZCAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3N0YXRzLmMNCj4gKysrIGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2VuX3N0YXRzLmMNCj4gQEAgLTM2
Myw3ICszNjMsNyBAQCBzdGF0aWMgdm9pZCBtbHg1ZV9ncnBfcV91cGRhdGVfc3RhdHMoc3RydWN0
DQo+IG1seDVlX3ByaXYgKnByaXYpDQo+ICAJICAgICFtbHg1X2NvcmVfcXVlcnlfcV9jb3VudGVy
KHByaXYtPm1kZXYsIHByaXYtDQo+ID5kcm9wX3JxX3FfY291bnRlciwgMCwNCj4gIAkJCQkgICAg
ICAgb3V0LCBzaXplb2Yob3V0KSkpDQo+ICAJCXFjbnQtPnJ4X2lmX2Rvd25fcGFja2V0cyA9DQo+
IE1MWDVfR0VUKHF1ZXJ5X3FfY291bnRlcl9vdXQsIG91dCwNCj4gLQkJCQkJCSAgICBvdXRfb2Zf
YnVmZmVyKTsNCj4gKwkJCQkJCSAgICByeF9pZl9kb3duX3BhY2tldHMpDQo+IDsNCg0KSGkgSm9u
YXRoYW4sIA0KDQpUaGlzIHBhdGNoIGluIG5vdCBhcHBsaWNhYmxlICh3b24ndCBjb21waWxlIGFu
ZCB0aGVyZSBpcyBubyBpc3N1ZSB3aXRoDQpjdXJyZW50IGNvZGUpLg0KDQpBbHRob3VnaCBpdCBp
cyBjb25mdXNpbmcgYnV0IHRoZSBjb2RlIGlzIGNvcnJlY3QgYXMgaXMuDQoNCjEpIHlvdXIgcGF0
Y2ggd29uJ3QgY29tcGlsZSBzaW5jZSB0aGVyZSBpcyBubyByeF9pZl9kb3duX3BhY2tldHMgZmll
bGQNCmluIHF1ZXJ5X3FfY291bnRlcl9vdXQgaHcgZGVmaW5pdGlvbiBzdHJ1Y3Q6IHBsZWFzZSBj
aGVjaw0KaW5jbHVkZS9saW51eC9tbHg1L21seDVfaWZjLmgNCm1seDVfaWZjX3F1ZXJ5X3FfY291
bnRlcl9vdXRfYml0cw0KMikgdGhlIGNvZGUgd29ya3MgYXMgaXMgc2luY2Ugd2hlbiBpbnRlcmZh
Y2UgaXMgZG93biBhbmQgcG9ydCBpcyB1cCwNCnRlY2huaWNhbGx5IGZyb20gaHcgcGVyc3BlY3Rp
dmUgdGhlcmUgaXMgIm5vIGJ1ZmZlciBhdmFpbGFibGUiIHNvIHRoZQ0Kb3V0X29mX2J1ZmZlciBj
b3VudGVyIG9mIHRoZSBkcm9wX3JxX3FfY291bnRlciB3aWxsIGNvdW50IHBhY2tldHMNCmRyb3Bw
ZWQgZHVlIHRvIGludGVyZmFjZSBkb3duLi4NCg0KVGhhbmtzLA0KU2FlZWQuDQoNCg==
