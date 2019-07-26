Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 94B1F7738B
	for <lists+netdev@lfdr.de>; Fri, 26 Jul 2019 23:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbfGZVjN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 17:39:13 -0400
Received: from mail-eopbgr50047.outbound.protection.outlook.com ([40.107.5.47]:8797
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728454AbfGZVjN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 17:39:13 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YhoPigJ1PN6DbrGDd9SXtpadMYKKwJGf1wA+YLX6xM9LEZPGMgIHduxaYipT07ANP061D1+4HxZW7gvF6qntnbLQGG13mZOgJVcjCDboC+vhAUhplhzJnGR6pj32oPq5ekCLphP8EdgPvKcRENsg+GUirISu/rDUousyuqry/iNoSP2ocNsQraZ71emdH2xt1qQWubrRmYCZLLqEKVhROyq7XyFcf9Fr/OYbyy3jaaf4E7tdoZsjol3Po72i5S9z4viRat/GPnDtm30xRipCWuFWlTItxXJsyBiwx/xd1k0PxEcpPPoMduV6p+3Sd0h14fBR8RSlL8fiseTrHHGL1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+AAKO3EKuUWR1Yv7OXoFqrzxIT/LPoI0qXF0vzc90E=;
 b=bZ8JLdg7LUEQp4E6Fo7AP8MrMukOHotppWMJnnPyQ74520mu1e/AF3/23dppSQpSf6hxeu4hgG8/svK39BTEvcyAB8GAfxuiuY2Gqcn5ycjofqPwyGjM/mOffznMDcGWZvhg5n2Sm7u4XWRoZNkDHDDfT/hWGFtxkz21XiHoqHUrIo2GUwYd794+5CUEJ+o54K2bTzLBmPRo+qj+CKpYl0VZzRW8g3qP1RSpLBGANbPWv2xG02BG+UM1hpoanusk6//+PsN5W8UJuH5sxsM/B/bz0P6SBrIzAWYoYX9e08YrLI1ydvXECOPuPzfQs+S+fVhxZejS+JZCc5Or5E735Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o+AAKO3EKuUWR1Yv7OXoFqrzxIT/LPoI0qXF0vzc90E=;
 b=HRtXx/PATVkKYox5j5q1hvKU3cPka9LpEdy+Va2FFiwBdLPjdpUPd3EPqUAsBxg7HPF/puoYvufVI7ospCLBIa5Vfo7PYGfA8FqtWwMZGxtuFLXsOXxYLHvrTe7rJm9FwN3gsXrd8EAqltK6J94W5nSikqtxCxZxSZNTQxjpKUA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2613.eurprd05.prod.outlook.com (10.172.225.141) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Fri, 26 Jul 2019 21:39:04 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 21:39:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "venza@brownhat.org" <venza@brownhat.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sergej.benilov@googlemail.com" <sergej.benilov@googlemail.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>
Subject: Re: [PATCH] sis900: add support for ethtool's EEPROM dump
Thread-Topic: [PATCH] sis900: add support for ethtool's EEPROM dump
Thread-Index: AQHVQyHuQtQD+LjK5kq+a7MFFILbd6bdbtAA
Date:   Fri, 26 Jul 2019 21:39:04 +0000
Message-ID: <c26f0ca5ae49c46f67dad51d013c51fffe2ac7d1.camel@mellanox.com>
References: <20190725194806.17964-1-sergej.benilov@googlemail.com>
In-Reply-To: <20190725194806.17964-1-sergej.benilov@googlemail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 14c62aaa-ef6f-4c4e-13cf-08d71211aea2
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2613;
x-ms-traffictypediagnostic: DB6PR0501MB2613:
x-microsoft-antispam-prvs: <DB6PR0501MB261357B6C4005EF3F9D84BE7BEC00@DB6PR0501MB2613.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4125;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(136003)(396003)(366004)(346002)(376002)(199004)(189003)(66476007)(64756008)(76116006)(476003)(25786009)(71200400001)(186003)(71190400001)(91956017)(66946007)(446003)(229853002)(66556008)(6506007)(2201001)(6486002)(6436002)(14444005)(256004)(66066001)(110136005)(478600001)(7736002)(316002)(102836004)(486006)(2501003)(26005)(99286004)(118296001)(2616005)(68736007)(36756003)(81166006)(2906002)(81156014)(14454004)(5660300002)(305945005)(8936002)(6116002)(76176011)(53936002)(86362001)(11346002)(3846002)(58126008)(6246003)(6512007)(66446008)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2613;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HiZFisY0uUFUA2h23BmzwObIhztD4GrwUwUXrh/E6PvhqPXSAkIq6F7uCHowfRetIcf+u/AzMz6ANbFC0lq4J84KiZX1x3iI9CRAV96sNH9Dsfgma03vNdoe4zIKYd9awP/qKnVSG1OsxJCeSl/svFp5FAVuacZ9tlEBa/H52s2pGSSWlETUmydDIJ8N3f51O8Xa4B40xdH20UOJNxB/jeyk3JYo5pq2ChJTE8GyZgGJCJIfc3F91f3AHg7L3QcI+QhKPjA4Md6gH3cb3sO/9Z1fzEgFygxwHMIZFo/bppDQFih4jR50ajCoTcaGfXDL7y1ikpLp/VeE9aKfxuehffvM6uUOBw5DzyN9PnL8mJSnzb6f+NbgAht/+MNMj9XGiouznjElM9u+pMIRl+kMy/UALZxSGj6Vs7VvvmF8hoY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3E270BCA125B4C499781421C62ADF92B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 14c62aaa-ef6f-4c4e-13cf-08d71211aea2
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 21:39:04.7067
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2613
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVGh1LCAyMDE5LTA3LTI1IGF0IDIxOjQ4ICswMjAwLCBTZXJnZWogQmVuaWxvdiB3cm90ZToN
Cj4gSW1wbGVtZW50IGV0aHRvb2wncyBFRVBST00gZHVtcCBjb21tYW5kIChldGh0b29sIC1lfC0t
ZWVwcm9tLWR1bXApLg0KPiANCj4gVGh4IHRvIEFuZHJldyBMdW5uIGZvciBjb21tZW50cy4NCj4g
DQo+IFNpZ25lZC1vZmYtYnk6IFNlcmdlaiBCZW5pbG92IDxzZXJnZWouYmVuaWxvdkBnb29nbGVt
YWlsLmNvbT4NCj4gLS0tDQo+ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9zaXMvc2lzOTAwLmMgfCA2
OA0KPiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrDQo+ICAxIGZpbGUgY2hhbmdlZCwg
NjggaW5zZXJ0aW9ucygrKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0
L3Npcy9zaXM5MDAuYw0KPiBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Npcy9zaXM5MDAuYw0KPiBp
bmRleCA2ZTA3ZjVlYmFjZmMuLjg1ZWFjY2JiYmFjMSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvc2lzL3NpczkwMC5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L3Np
cy9zaXM5MDAuYw0KPiBAQCAtMTkxLDYgKzE5MSw4IEBAIHN0cnVjdCBzaXM5MDBfcHJpdmF0ZSB7
DQo+ICAJdW5zaWduZWQgaW50IHR4X2Z1bGw7IC8qIFRoZSBUeCBxdWV1ZSBpcyBmdWxsLiAqLw0K
PiAgCXU4IGhvc3RfYnJpZGdlX3JldjsNCj4gIAl1OCBjaGlwc2V0X3JldjsNCj4gKwkvKiBFRVBS
T00gZGF0YSAqLw0KPiArCWludCBlZXByb21fc2l6ZTsNCj4gIH07DQo+ICANCj4gIE1PRFVMRV9B
VVRIT1IoIkppbSBIdWFuZyA8Y21odWFuZ0BzaXMuY29tLnR3PiwgT2xsaWUgTGhvIDwNCj4gb2xs
aWVAc2lzLmNvbS50dz4iKTsNCj4gQEAgLTQ3NSw2ICs0NzcsOCBAQCBzdGF0aWMgaW50IHNpczkw
MF9wcm9iZShzdHJ1Y3QgcGNpX2RldiAqcGNpX2RldiwNCj4gIAlzaXNfcHJpdi0+cGNpX2RldiA9
IHBjaV9kZXY7DQo+ICAJc3Bpbl9sb2NrX2luaXQoJnNpc19wcml2LT5sb2NrKTsNCj4gIA0KPiAr
CXNpc19wcml2LT5lZXByb21fc2l6ZSA9IDI0Ow0KPiArIA0KDQp0aGlzIHZhbHVlIGlzbid0IGNo
YW5naW5nIGFjcm9zcyB0aGlzIHBhdGNoLCANCndoeSBkbyB5b3UgbmVlZCB0byBzdG9yZSBhIGNv
bnN0YW50IHZhbHVlIGluIHByaXZhdGUgZGF0YSA/DQoNCkp1c3QgbWFrZSBhICNkZWZpbmUgLi4g
DQoNCj4gIAlwY2lfc2V0X2RydmRhdGEocGNpX2RldiwgbmV0X2Rldik7DQo+ICANCj4gIAlyaW5n
X3NwYWNlID0gcGNpX2FsbG9jX2NvbnNpc3RlbnQocGNpX2RldiwgVFhfVE9UQUxfU0laRSwNCj4g
JnJpbmdfZG1hKTsNCj4gQEAgLTIxMjIsNiArMjEyNiw2OCBAQCBzdGF0aWMgdm9pZCBzaXM5MDBf
Z2V0X3dvbChzdHJ1Y3QgbmV0X2RldmljZQ0KPiAqbmV0X2Rldiwgc3RydWN0IGV0aHRvb2xfd29s
aW5mbyAqdw0KPiAgCXdvbC0+c3VwcG9ydGVkID0gKFdBS0VfUEhZIHwgV0FLRV9NQUdJQyk7DQo+
ICB9DQo+ICANCj4gK3N0YXRpYyBpbnQgc2lzOTAwX2dldF9lZXByb21fbGVuKHN0cnVjdCBuZXRf
ZGV2aWNlICpkZXYpDQo+ICt7DQo+ICsJc3RydWN0IHNpczkwMF9wcml2YXRlICpzaXNfcHJpdiA9
IG5ldGRldl9wcml2KGRldik7DQo+ICsNCj4gKwlyZXR1cm4gc2lzX3ByaXYtPmVlcHJvbV9zaXpl
Ow0KPiArfQ0KPiArDQo+ICtzdGF0aWMgaW50IHNpczkwMF9yZWFkX2VlcHJvbShzdHJ1Y3QgbmV0
X2RldmljZSAqbmV0X2RldiwgdTggKmJ1ZikNCj4gK3sNCj4gKwlzdHJ1Y3Qgc2lzOTAwX3ByaXZh
dGUgKnNpc19wcml2ID0gbmV0ZGV2X3ByaXYobmV0X2Rldik7DQo+ICsJdm9pZCBfX2lvbWVtICpp
b2FkZHIgPSBzaXNfcHJpdi0+aW9hZGRyOw0KPiArCWludCB3YWl0LCByZXQgPSAtRUFHQUlOOw0K
PiArCXUxNiBzaWduYXR1cmU7DQo+ICsJdTE2ICplYnVmID0gKHUxNiAqKWJ1ZjsNCg0KcmV2ZXJz
ZSB4bWFzIHRyZWUuDQoNCj4gKwlpbnQgaTsNCj4gKw0KPiArCWlmIChzaXNfcHJpdi0+Y2hpcHNl
dF9yZXYgPT0gU0lTOTZ4XzkwMF9SRVYpIHsNCj4gKwkJc3czMihtZWFyLCBFRVJFUSk7DQo+ICsJ
CWZvciAod2FpdCA9IDA7IHdhaXQgPCAyMDAwOyB3YWl0KyspIHsNCj4gKwkJCWlmIChzcjMyKG1l
YXIpICYgRUVHTlQpIHsNCj4gKwkJCQkvKiByZWFkIDE2IGJpdHMsIGFuZCBpbmRleCBieSAxNiBi
aXRzDQo+ICovDQo+ICsJCQkJZm9yIChpID0gMDsgaSA8IHNpc19wcml2LT5lZXByb21fc2l6ZSAv
DQo+IDI7IGkrKykNCj4gKwkJCQkJZWJ1ZltpXSA9DQo+ICh1MTYpcmVhZF9lZXByb20oaW9hZGRy
LCBpKTsNCj4gKwkJCQlyZXQgPSAwOw0KPiArCQkJCWJyZWFrOw0KPiArCQkJfQ0KPiArCQkJdWRl
bGF5KDEpOw0KPiArCQl9DQoNCmNvc21ldGljIGNvbW1lbnQsIHRvbyBtdWNoIGluZGVudGF0aW9u
cyB0byBteSB0YXN0ZSwNCnR3byB3YXlzIHRvIGF2b2lkIHRoaXMsDQoxKSBpZiAhU0lTOTZ4Xzkw
MF9SRVYgZXhlY3V0ZSB0aGUgZWxzZSBzdGF0ZW1lbnQgYW5kIGVhcmx5IHJldHVybiANCjIpICJk
byB3aGlsZSIgdG8gd2FpdCBmb3IgKHNyMzIobWVhcikgJiBFRUdOVCkgYW5kIHRoZW4gZXhlY3V0
ZSB0aGUgZm9yDQpsb29wIHdoaWNoIHJlYWRzIHRoZSBlZXByb20gb3V0cyBzaWRlIHRoZSB3YWl0
IGxvb3AuDQoNCj4gKwkJc3czMihtZWFyLCBFRURPTkUpOw0KPiArCX0gZWxzZSB7DQo+ICsJCXNp
Z25hdHVyZSA9ICh1MTYpcmVhZF9lZXByb20oaW9hZGRyLCBFRVBST01TaWduYXR1cmUpOw0KPiAr
CQlpZiAoc2lnbmF0dXJlICE9IDB4ZmZmZiAmJiBzaWduYXR1cmUgIT0gMHgwMDAwKSB7DQo+ICsJ
CQkvKiByZWFkIDE2IGJpdHMsIGFuZCBpbmRleCBieSAxNiBiaXRzICovDQo+ICsJCQlmb3IgKGkg
PSAwOyBpIDwgc2lzX3ByaXYtPmVlcHJvbV9zaXplIC8gMjsgaSsrKQ0KPiArCQkJCWVidWZbaV0g
PSAodTE2KXJlYWRfZWVwcm9tKGlvYWRkciwgaSk7DQo+ICsJCQlyZXQgPSAwOw0KPiArCQl9DQo+
ICsJfQ0KPiArCXJldHVybiByZXQ7DQo+ICt9DQo+ICsNCj4gKyNkZWZpbmUgU0lTOTAwX0VFUFJP
TV9NQUdJQwkweEJBQkUNCj4gK3N0YXRpYyBpbnQgc2lzOTAwX2dldF9lZXByb20oc3RydWN0IG5l
dF9kZXZpY2UgKmRldiwgc3RydWN0DQo+IGV0aHRvb2xfZWVwcm9tICplZXByb20sIHU4ICpkYXRh
KQ0KPiArew0KPiArCXN0cnVjdCBzaXM5MDBfcHJpdmF0ZSAqc2lzX3ByaXYgPSBuZXRkZXZfcHJp
dihkZXYpOw0KPiArCXU4ICplZWJ1ZjsNCj4gKwlpbnQgcmVzOw0KPiArDQo+ICsJZWVidWYgPSBr
bWFsbG9jKHNpc19wcml2LT5lZXByb21fc2l6ZSwgR0ZQX0tFUk5FTCk7DQo+ICsJaWYgKCFlZWJ1
ZikNCj4gKwkJcmV0dXJuIC1FTk9NRU07DQo+ICsNCj4gKwllZXByb20tPm1hZ2ljID0gU0lTOTAw
X0VFUFJPTV9NQUdJQzsNCj4gKwlzcGluX2xvY2tfaXJxKCZzaXNfcHJpdi0+bG9jayk7DQo+ICsJ
cmVzID0gc2lzOTAwX3JlYWRfZWVwcm9tKGRldiwgZWVidWYpOw0KPiArCXNwaW5fdW5sb2NrX2ly
cSgmc2lzX3ByaXYtPmxvY2spOw0KPiArCWlmICghcmVzKQ0KPiArCQltZW1jcHkoZGF0YSwgZWVi
dWYgKyBlZXByb20tPm9mZnNldCwgZWVwcm9tLT5sZW4pOw0KPiArCWtmcmVlKGVlYnVmKTsNCj4g
KwlyZXR1cm4gcmVzOw0KPiArfQ0KPiArDQo+ICBzdGF0aWMgY29uc3Qgc3RydWN0IGV0aHRvb2xf
b3BzIHNpczkwMF9ldGh0b29sX29wcyA9IHsNCj4gIAkuZ2V0X2RydmluZm8gCT0gc2lzOTAwX2dl
dF9kcnZpbmZvLA0KPiAgCS5nZXRfbXNnbGV2ZWwJPSBzaXM5MDBfZ2V0X21zZ2xldmVsLA0KPiBA
QCAtMjEzMiw2ICsyMTk4LDggQEAgc3RhdGljIGNvbnN0IHN0cnVjdCBldGh0b29sX29wcw0KPiBz
aXM5MDBfZXRodG9vbF9vcHMgPSB7DQo+ICAJLnNldF93b2wJPSBzaXM5MDBfc2V0X3dvbCwNCj4g
IAkuZ2V0X2xpbmtfa3NldHRpbmdzID0gc2lzOTAwX2dldF9saW5rX2tzZXR0aW5ncywNCj4gIAku
c2V0X2xpbmtfa3NldHRpbmdzID0gc2lzOTAwX3NldF9saW5rX2tzZXR0aW5ncywNCj4gKwkuZ2V0
X2VlcHJvbV9sZW4gPSBzaXM5MDBfZ2V0X2VlcHJvbV9sZW4sDQo+ICsJLmdldF9lZXByb20gPSBz
aXM5MDBfZ2V0X2VlcHJvbSwNCj4gIH07DQo+ICANCj4gIC8qKg0K
