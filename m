Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0A1D41235E3
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 20:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbfLQToO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 14:44:14 -0500
Received: from mail-eopbgr60066.outbound.protection.outlook.com ([40.107.6.66]:45253
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727529AbfLQToO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 14:44:14 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NcR0xntdaJaCEi0SFLZ5vsPNqZjyMmX3kv/FRFskyIjVG0Kz6ooje9bajZNhmtxarUS5YRw8xL4Y3i1s4ll4oBK2bdaAZL0Z3PcuqEE7yVU48Em1n/YtMjnl6k2HR6UMY3Je5kGijA4yL/gJ1+TX+Q76L1hkEMZuoUm5DDo2Go66XrSKa9WeoFf2GgYaI+S331z4ppHQN7esRA46mWcIqcsgOczzvc6rIw0XaBgnJ+92/NIjT/ROIzA9hdGj6aTqFhuq+UwXymYUA/6oqHJz3bML8/QOZAu/mZ2P0YEVfhoNvpY8MUgScoDupdbtTFk9OtbnIyxrhll74tep4I0u1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdFVR07OXu8CFRt8vZrcUv2ZPzji8ARqN/wV6jgySn4=;
 b=P2RlplGcoKDfOeGDHzig96Y4d46YWo2PrsRzO7sqa9LUKP051T94XNjS9N4ob2al/ZRhmmjWV4P7XkDPTO+ONyZSrRtaD1nYV2YTuvfrlShz4VZYAPD/dAafgPep1KRMSWUvGYVfE4jA5plaHiwgi0ziZrT6VWQJpm59v9e8AQew/6Sj34ITqLhW9+T7fFbJLtdu98WLh+DxIWteGQ5hWphwJRU92wXifadxuo4EmpqEBaZPJ4eQndvUqcDgqjms6+T26tdRp7PBAMePhrWz7xl/jJLkeoQ4Ddi5C3hPf7yZKbzQZ+zWo6L7EBA3hx/EqNOKjTxPPJ76NKkjAqY9mg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vdFVR07OXu8CFRt8vZrcUv2ZPzji8ARqN/wV6jgySn4=;
 b=XJ0Y4p9N5NY/uSp10r12gnigzHJ22sWhhShoskNs+eQY+J8ENU0NDwyUOMU5+tMPlEliIS2Ekd175qWBZR3B5s6u25JKMSD6sILZ/6umGIdaJyObWxqCKvG1BTALNqFflgdKKbKsSonwIbiYERLjixjlIJCsXqKTn0aR6i6m0yk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6016.eurprd05.prod.outlook.com (20.178.204.217) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Tue, 17 Dec 2019 19:44:10 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::c872:cf66:4a5c:c881%5]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 19:44:09 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Yanjun Zhu <yanjunz@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "zyjzyj2000@gmail.com" <zyjzyj2000@gmail.com>
Subject: Re: [PATCH 1/1] net/mlx5: limit the function in local scope
Thread-Topic: [PATCH 1/1] net/mlx5: limit the function in local scope
Thread-Index: AQHVsluu9QD/TOG5nUKb7aELbFVCFKe+v/iA
Date:   Tue, 17 Dec 2019 19:44:09 +0000
Message-ID: <f87b61499831bdc4100f7959d3a95c58c488df1d.camel@mellanox.com>
References: <1576313477-20401-1-git-send-email-yanjunz@mellanox.com>
In-Reply-To: <1576313477-20401-1-git-send-email-yanjunz@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.5 (3.32.5-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 521d609f-165f-4a79-851b-08d783297c59
x-ms-traffictypediagnostic: VI1PR05MB6016:|VI1PR05MB6016:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB60167F6404309534858194C1BE500@VI1PR05MB6016.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(39860400002)(346002)(376002)(189003)(199004)(76116006)(64756008)(6506007)(2616005)(5660300002)(2906002)(86362001)(478600001)(8676002)(71200400001)(6512007)(26005)(4001150100001)(8936002)(81166006)(4326008)(186003)(6486002)(110136005)(66946007)(66446008)(66556008)(66476007)(36756003)(81156014)(91956017)(316002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6016;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PrjwjWXQj9hMkQKoQiUNHUjsE5/kA4lL/hY2MvChpPdEuMDWQplht70iGMuDAtfNkEN+o42DI5uFXHjmVb6Ai7aG2TXBsfoiVQlbcwoGHorga2J9d+HYtZAm6lENAolMVK71MpxJyCNuLXtSaX3deUBXehkBJa5nRKPfWevAswnsdXsDpTZW2YFMbtiNDcKXFnuS7S12rO9ycUnNaOZ0OaU/VgIjlSbnLpyFpKvnrCbhMwnWz7EcVj+X9v87oXMiPqAVso4VwT7R8wpIoADq6CdvR6CMhiM2xLQoZ/jqYxbtRKFUlq3uxlI6Vl1L6869TCR1TaMYm2Eb7oh38gKJ68GTNzes8x/V08vIEWaf/1mfdBniaWAFQh276by1WHq85SsDR5eQ7qayrOxio1sTU7P9/jNfxBTLMxC/6eQtTB0c/Cqftk9qAlovSBbe0gSl
Content-Type: text/plain; charset="utf-8"
Content-ID: <4C03FD73680652478E9DF8601DCA9C92@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 521d609f-165f-4a79-851b-08d783297c59
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 19:44:09.6845
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9viho9SOl8ZmcVevScP9PcPnJymULjkwa1u6OrvDe+K2uyGINhtKi8twFgtHKK1lDSFUQR5Tc8rVzei8C2K4+Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6016
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDE5LTEyLTE0IGF0IDEwOjUxICswMjAwLCBaaHUgWWFuanVuIHdyb3RlOg0KPiBG
cm9tOiBaaHUgWWFuanVuIDx6eWp6eWoyMDAwQGdtYWlsLmNvbT4NCj4gDQo+IFRoZSBmdW5jdGlv
biBtbHg1X2J1Zl9hbGxvY19ub2RlIGlzIG9ubHkgdXNlZCBieSB0aGUgZnVuY3Rpb24gaW4gdGhl
DQo+IGxvY2FsIHNjb3BlLiBTbyBpdCBpcyBhcHByb3ByaWF0ZSB0byBsaW1pdCB0aGlzIGZ1bmN0
aW9uIGluIHRoZSBsb2NhbA0KPiBzY29wZS4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IFpodSBZYW5q
dW4gPHp5anp5ajIwMDBAZ21haWwuY29tPg0KDQpMR1RNLCB3aWxsIGFwcGx5IHRvIG1seDUtbmV4
dCBzb29uLg0KDQpUaGFua3MsDQpTYWVlZC4NCg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L21lbGxhbm94L21seDUvY29yZS9hbGxvYy5jIHwgNCArKy0tDQo+ICBpbmNsdWRlL2xpbnV4
L21seDUvZHJpdmVyLmggICAgICAgICAgICAgICAgICAgICB8IDIgLS0NCj4gIDIgZmlsZXMgY2hh
bmdlZCwgMiBpbnNlcnRpb25zKCspLCA0IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdpdCBh
L2RyaXZlcnMvbmV0L2V0aGVybmV0L21lbGxhbm94L21seDUvY29yZS9hbGxvYy5jDQo+IGIvZHJp
dmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2FsbG9jLmMNCj4gaW5kZXggNTQ5
Zjk2Mi4uNDIxOThlNiAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2FsbG9jLmMNCj4gKysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFu
b3gvbWx4NS9jb3JlL2FsbG9jLmMNCj4gQEAgLTcxLDggKzcxLDggQEAgc3RhdGljIHZvaWQgKm1s
eDVfZG1hX3phbGxvY19jb2hlcmVudF9ub2RlKHN0cnVjdA0KPiBtbHg1X2NvcmVfZGV2ICpkZXYs
DQo+ICAJcmV0dXJuIGNwdV9oYW5kbGU7DQo+ICB9DQo+ICANCj4gLWludCBtbHg1X2J1Zl9hbGxv
Y19ub2RlKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYsIGludCBzaXplLA0KPiAtCQkJc3RydWN0
IG1seDVfZnJhZ19idWYgKmJ1ZiwgaW50IG5vZGUpDQo+ICtzdGF0aWMgaW50IG1seDVfYnVmX2Fs
bG9jX25vZGUoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldiwgaW50IHNpemUsDQo+ICsJCQkgICAg
ICAgc3RydWN0IG1seDVfZnJhZ19idWYgKmJ1ZiwgaW50IG5vZGUpDQo+ICB7DQo+ICAJZG1hX2Fk
ZHJfdCB0Ow0KPiAgDQo+IGRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgN
Cj4gYi9pbmNsdWRlL2xpbnV4L21seDUvZHJpdmVyLmgNCj4gaW5kZXggMjcyMDBkZS4uNTljZmYz
OCAxMDA2NDQNCj4gLS0tIGEvaW5jbHVkZS9saW51eC9tbHg1L2RyaXZlci5oDQo+ICsrKyBiL2lu
Y2x1ZGUvbGludXgvbWx4NS9kcml2ZXIuaA0KPiBAQCAtOTI4LDggKzkyOCw2IEBAIGludCBtbHg1
X2NtZF9leGVjX3BvbGxpbmcoc3RydWN0IG1seDVfY29yZV9kZXYNCj4gKmRldiwgdm9pZCAqaW4s
IGludCBpbl9zaXplLA0KPiAgdm9pZCBtbHg1X3N0b3BfaGVhbHRoX3BvbGwoc3RydWN0IG1seDVf
Y29yZV9kZXYgKmRldiwgYm9vbA0KPiBkaXNhYmxlX2hlYWx0aCk7DQo+ICB2b2lkIG1seDVfZHJh
aW5faGVhbHRoX3dxKHN0cnVjdCBtbHg1X2NvcmVfZGV2ICpkZXYpOw0KPiAgdm9pZCBtbHg1X3Ry
aWdnZXJfaGVhbHRoX3dvcmsoc3RydWN0IG1seDVfY29yZV9kZXYgKmRldik7DQo+IC1pbnQgbWx4
NV9idWZfYWxsb2Nfbm9kZShzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LCBpbnQgc2l6ZSwNCj4g
LQkJCXN0cnVjdCBtbHg1X2ZyYWdfYnVmICpidWYsIGludCBub2RlKTsNCj4gIGludCBtbHg1X2J1
Zl9hbGxvYyhzdHJ1Y3QgbWx4NV9jb3JlX2RldiAqZGV2LA0KPiAgCQkgICBpbnQgc2l6ZSwgc3Ry
dWN0IG1seDVfZnJhZ19idWYgKmJ1Zik7DQo+ICB2b2lkIG1seDVfYnVmX2ZyZWUoc3RydWN0IG1s
eDVfY29yZV9kZXYgKmRldiwgc3RydWN0IG1seDVfZnJhZ19idWYNCj4gKmJ1Zik7DQo=
