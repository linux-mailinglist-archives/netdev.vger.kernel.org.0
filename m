Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590CE233F45
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 08:43:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731367AbgGaGnW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jul 2020 02:43:22 -0400
Received: from mail-eopbgr1400100.outbound.protection.outlook.com ([40.107.140.100]:46611
        "EHLO JPN01-TY1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731224AbgGaGnV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 Jul 2020 02:43:21 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Puptqhj8JF2YBxXEz2eyuZ4zNV89w0oHh+ysjQm7icS7o/wwUnDTxKkD1y2p1mAh/YEzz/pWBt3a7FpUCwZTqapfXfcRWpKpAN+rTkcHDeafnJvOfmM2DmEncm7tSVY1kEbu7iqbLcDrskLBQEwn94EZGCuVUEF3PuDhVre/cGyqe1GigMMmRRlIzXKC1Z/Rj6ukM/2A3txtZJ9YJ0NyXCCWlU2HBtAZjGcVuvyL+VosycFXeW235+vgKKnGI9Ht/6gDxIl93i0USwaYOFfCnw9k4Lo43b3+9KaexwYE6tlNr8moLlUCkx+YgI3+38ElVe+EbQtVP4C0DygUYMK5pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhgqHZbnWCWMwX2lmUV5RkomX6eCxPUQkCnl1BWvhXU=;
 b=WKsk6PjEE7P4aEnC0vHTWLuG/MehPovy+jn3r67wXtIO1wyX9HXD6fzIWYBG4xDIwQojWtMfv+70cen8dtC08EQY5uLPM8BKr46kQhASewDdBdquUIL7yhXqQSiv0UfddnlEcS6yIEqU20jLer0AWQ0qlryveYTqSuwB0ceAvqVH49+QX2qr9ZTkZYCOog0prJRM8zMpOdEd42yPh73Cy8B8HE7O0pBKf/2QZtOkzRHdGBEJP+6Rfifv73Ijf7NXdNpo8YD7Eg0bdpxXrk9ck+nhTjOoaiAKwZwbwkJB0SeAXWOYhQmT4uIQcN5n4Puo+Nn85Tb1hlfnLR3TDNemUA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IhgqHZbnWCWMwX2lmUV5RkomX6eCxPUQkCnl1BWvhXU=;
 b=iOUEWpA730f7K4eIk3jDx4EmEAydu2aR7pVkR9bOxJk6BfNDxr+pB82ybpQvCLov8xE5LoWQDH167Q3YnMCfo3NvhvQ8BLTEaKYYUd6UswTQUoye8ACmxUxcswtuv3cCoxubQzrN6KsMlb2sLiM6IGBuRytADCH7PXcvsb8NCrs=
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com (2603:1096:404:d5::22)
 by TYAPR01MB2222.jpnprd01.prod.outlook.com (2603:1096:404:2::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3239.18; Fri, 31 Jul
 2020 06:43:17 +0000
Received: from TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3]) by TY2PR01MB3692.jpnprd01.prod.outlook.com
 ([fe80::9083:6001:8090:9f3%6]) with mapi id 15.20.3239.017; Fri, 31 Jul 2020
 06:43:17 +0000
From:   Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
To:     Sergei Shtylyov <sergei.shtylyov@gmail.com>,
        Yuusuke Ashizuka <ashiduka@fujitsu.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-renesas-soc@vger.kernel.org" 
        <linux-renesas-soc@vger.kernel.org>
Subject: RE: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Thread-Topic: [PATCH v2] ravb: Fixed the problem that rmmod can not be done
Thread-Index: AQHWZlopa4nv6nqNlEaX6k+bLc2aS6kf9vzQgABYDYCAAJzv8A==
Date:   Fri, 31 Jul 2020 06:43:17 +0000
Message-ID: <TY2PR01MB3692A94CD6479F2976458B0FD84E0@TY2PR01MB3692.jpnprd01.prod.outlook.com>
References: <20200730035649.5940-1-ashiduka@fujitsu.com>
 <20200730100151.7490-1-ashiduka@fujitsu.com>
 <TY2PR01MB36928342A37492E8694A7625D8710@TY2PR01MB3692.jpnprd01.prod.outlook.com>
 <793b7100-9a3a-11fd-f0cd-bf225b958775@gmail.com>
In-Reply-To: <793b7100-9a3a-11fd-f0cd-bf225b958775@gmail.com>
Accept-Language: ja-JP, en-US
Content-Language: ja-JP
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=renesas.com;
x-originating-ip: [240f:60:5f3e:1:7d28:3e82:377f:8a0]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 40780d72-c382-4b33-62bd-08d8351d0218
x-ms-traffictypediagnostic: TYAPR01MB2222:
x-microsoft-antispam-prvs: <TYAPR01MB222223BEB19EA2F17268C31ED84E0@TYAPR01MB2222.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0ZKgSeLMWQfhc032O6bGGM5LZMikKDR+HySGuwV9VVYOECksOdTVD/DgDv95Kmu9FGvIiC8roRgfFB8tAUW2mAlXRdyKmMl40o2zTS7IzJAjM+1s2VxjlPELUMgatJEF36IRMWEOyEEEZCetkxWAkG9dN+uOWjReqj00KAlCp7EuhPttbOrJPyPTTsuZo4fZ7DtPG0wIFZdRCjG/P1h0IcKUOx6YLRZv6LAUYPM0HruOQ3bSijj6nCTBoahS4spt3DaA2SM80o7uNCXXq5sq2TzmnPsvl07n+ERVvtEXQlZTP7AOdh55OktyjFBp6RYi
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3692.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(39860400002)(136003)(366004)(346002)(53546011)(5660300002)(6506007)(52536014)(4326008)(86362001)(7696005)(83380400001)(33656002)(186003)(478600001)(54906003)(8676002)(66476007)(76116006)(66556008)(66446008)(66946007)(64756008)(2906002)(9686003)(71200400001)(316002)(55016002)(8936002)(110136005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: MyiSdUOufEWRW6yPa1+JwqGiR8IydNsIgSuG/qTsIPUhLud2eSTgAA3uQJOQetGZyK6kde76da8RysRhg9ZalxfXZ6ERcy/RoTW6clK5oYTymnTPKpcq663pvPI54JGYhfF0vYXrAIfaAorUnpsHs3Joj3OptFb/OQ90q6Vz7emVGjHwliu4ENj7Vr2AQ5aE4nJO/jm66trXNW0m8MhAw3eSePZlVNcNVjcrfizaB8bHfyPmbeevvJMdaGyruTyv9H212zkorJfgqGAGeQvhzp/HLx7lxui4LcuZfLoliKeT/EU+mCseHEh3nTePidN4gqwPmbCTPRwte+kmdaHAY7Kt/Nhep9wtac70XyWO0wmS46q5m5+V4oHiA/126uYek4qazrJMh4P6unq01X2UVwR7Ki5Cio5fJtVRWW6RoaQw9GS4DO/W/oDPd4x5CdtZPHLVYf+q3Pke2lET5yC16ZNpga3ArOVh55e4jy4lGdWiJk2X0XkC69o9u2o+mbSiomUY8bVuRsH7/FZOdcy07ChVWBmWcHdS5OOdatBMx0GrQRb1zIlJbpcI3U+VvT0yEbHekTo8laFBTNrm+ZGd1aDhOoFkoZSb3mt+sHilPuHa+85bNF1ixDlAkBgIRmp3ZgO4eABRad+qJweJkOhCro5IdefMAE575qEDxmdcARvpmUkH8l1B1JKjEjDCbmCfEtTM0etDVuM4nTZmWsCpVA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3692.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40780d72-c382-4b33-62bd-08d8351d0218
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2020 06:43:17.7322
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: IudmmvXbIPoKLi0sfcc7G2itH0o/SI7nJe5evOgGDFjBlNFpPLV84V/06e6IC8eeZ1roDzekCa5XQrneSfpk/2hUqLX0J2l2gcF3Xt+1K+cP3SruvKdOl4TPqmUh3AGJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TYAPR01MB2222
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8hDQoNCj4gRnJvbTogU2VyZ2VpIFNodHlseW92LCBTZW50OiBGcmlkYXksIEp1bHkgMzEs
IDIwMjAgMToyNCBBTQ0KPiANCj4gSGVsbG8hDQo+IA0KPiBPbiA3LzMwLzIwIDI6MzcgUE0sIFlv
c2hpaGlybyBTaGltb2RhIHdyb3RlOg0KPiANCj4gPj4gRnJvbTogWXV1c3VrZSBBc2hpenVrYSwg
U2VudDogVGh1cnNkYXksIEp1bHkgMzAsIDIwMjAgNzowMiBQTQ0KPiA+PiBTdWJqZWN0OiBbUEFU
Q0ggdjJdIHJhdmI6IEZpeGVkIHRoZSBwcm9ibGVtIHRoYXQgcm1tb2QgY2FuIG5vdCBiZSBkb25l
DQo+ID4NCj4gPiBUaGFuayB5b3UgZm9yIHRoZSBwYXRjaCEgSSBmb3VuZCBhIHNpbWlsYXIgcGF0
Y2ggZm9yIGFub3RoZXIgZHJpdmVyIFsxXS4NCj4gDQo+ICAgIEl0J3Mgbm90IHRoZSBzYW1lIGNh
c2UgLS0gdGhhdCBkcml2ZXIgaGFkbid0IGhhZCB0aGUgTURJTyByZWxlYXNlIGNvZGUgYXQgYWxs
DQo+IGJlZm9yZSB0aGF0IHBhdGNoLg0KDQpZb3UncmUgY29ycmVjdC4gSSBkaWRuJ3QgcmVhbGl6
ZWQgaXQuLi4NCg0KPiA+IFNvLCB3ZSBzaG91bGQgYXBwbHkgdGhpcyBwYXRjaCB0byB0aGUgcmF2
YiBkcml2ZXIuDQo+IA0KPiAgICBJIGJlbGlldmUgdGhlIGRyaXZlciBpcyBpbm5vY2VudC4gOi0p
DQoNCkkgaG9wZSBzbyA6KQ0KDQo8c25pcD4NCj4gPj4gJCBsc21vZA0KPiA+PiBNb2R1bGUgICAg
ICAgICAgICAgICAgICBTaXplICBVc2VkIGJ5DQo+ID4+IHJhdmIgICAgICAgICAgICAgICAgICAg
NDA5NjAgIDENCj4gPj4gJCBybW1vZCByYXZiDQo+ID4+IHJtbW9kOiBFUlJPUjogTW9kdWxlIHJh
dmIgaXMgaW4gdXNlDQo+IA0KPiAgICBTaG91bGRuJ3QgdGhlIGRyaXZlciBjb3JlIGNhbGwgdGhl
IHJlbW92ZSgpIG1ldGhvZCBmb3IgdGhlIGFmZmVjdGVkIGRldmljZXMNCj4gZmlyc3QsIGJlZm9y
ZSBjaGVja2luZyB0aGUgcmVmY291bnQ/DQoNCkluIHRoaXMgY2FzZSwgYW4gbWlpIGJ1cyBvZiAi
bWRpb2JiX29wcyBiYl9vcHMiIGlzIGFmZmVjdGVkICJkZXZpY2UiIGJ5IHRoZSByYXZiIGRyaXZl
ci4NCkFuZCB0aGUgcmF2YiBkcml2ZXIgc2V0cyB0aGUgb3duZXIgb2YgbWlpIGJ1cyBhcyBUSElT
X01PRFVMRSBsaWtlIGJlbG93Og0KDQpzdGF0aWMgc3RydWN0IG1kaW9iYl9vcHMgYmJfb3BzID0g
ew0KICAgICAgICAub3duZXIgPSBUSElTX01PRFVMRSwNCiAgICAgICAgLnNldF9tZGMgPSByYXZi
X3NldF9tZGMsDQogICAgICAgIC5zZXRfbWRpb19kaXIgPSByYXZiX3NldF9tZGlvX2RpciwNCiAg
ICAgICAgLnNldF9tZGlvX2RhdGEgPSByYXZiX3NldF9tZGlvX2RhdGEsDQogICAgICAgIC5nZXRf
bWRpb19kYXRhID0gcmF2Yl9nZXRfbWRpb19kYXRhLA0KfTsNCg0KU28sIEkgZG9uJ3QgdGhpbmsg
dGhlIGRyaXZlciBjb3JlIGNhbiBjYWxsIHRoZSByZW1vdmUoKSBtZXRob2QgZm9yIHRoZSBtaWkg
YnVzDQpiZWNhdXNlIGl0J3MgYSBwYXJ0IG9mIHRoZSByYXZiIGRyaXZlci4uLg0KDQpCeSB0aGUg
d2F5LCBhYm91dCB0aGUgbWRpby1ncGlvIGRyaXZlciwgSSdtIHdvbmRlcmluZyBpZiB0aGUgbWRp
by1ncGlvDQpkcml2ZXIgY2Fubm90IGJlIHJlbW92ZWQgYnkgcm1tb2QgdG9vLiAocGVyaGFwcywg
d2UgbmVlZCAicm1tb2QgLWYiIHRvIHJlbW92ZSBpdC4pDQoNCj4gPj4gRml4ZWQgdG8gZXhlY3V0
ZSBtZGlvX2luaXQoKSBhdCBvcGVuIGFuZCBmcmVlX21kaW8oKSBhdCBjbG9zZSwgdGhlcmVieSBy
bW1vZCBpcw0KPiA+DQo+ID4gSSB0aGluayAiRml4ZWQgdG8gY2FsbCByYXZiX21kaW9faW5pdCgp
IGF0IG9wZW4gYW5kIHJhdmJfbWRpb19yZWxlYXNlKCkgLi4uIiBpcyBiZXR0ZXIuDQo+ID4gSG93
ZXZlciwgSSdtIG5vdCBzdXJlIHdoZXRoZXIgdGhhdCBTZXJnZWkgd2hvIGlzIHRoZSByZXZpd2Vy
IG9mIHRoaXMgZHJpdmVyIGFjY2VwdHMNCj4gPiB0aGUgZGVzY3JpcHRpb25zIHdoaWNoIEkgc3Vn
Z2VzdGVkIHRob3VnaCA6KQ0KPiANCj4gICAgVGhlIGxhbmd1YWdlIGJhcnJpZXIgaXNuJ3QgdGhl
IG9ubHkgb2JzdGFjbGUuIDotKQ0KDQpJIGFncmVlIHdpdGggeW91IDopDQoNCj4gPiBCeSB0aGUg
d2F5LCBJIHRoaW5rIHlvdSBoYXZlIHRvIHNlbmQgdGhpcyBwYXRjaCB0byB0aGUgZm9sbG93aW5n
IG1haW50YWluZXJzIHRvbzoNCj4gPiAjIFdlIGNhbiBnZXQgaXQgYnkgdXNpbmcgc2NyaXB0cy9n
ZXRfbWFpbnRhaW5lcnMucGwuDQo+ID4gRGF2aWQgUy4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQu
bmV0PiAobWFpbnRhaW5lcjpORVRXT1JLSU5HIERSSVZFUlMsY29tbWl0X3NpZ25lcjo4Lzg9MTAw
JSkNCj4gPiBKYWt1YiBLaWNpbnNraSA8a3ViYUBrZXJuZWwub3JnPiAobWFpbnRhaW5lcjpORVRX
T1JLSU5HIERSSVZFUlMpDQo+ID4NCj4gPiBCZXN0IHJlZ2FyZHMsDQo+ID4gWW9zaGloaXJvIFNo
aW1vZGENCj4gDQo+ICAgIEZvciB0aGUgZnV0dXJlLCBwbGVhc2UgdHJpbSB5b3VyIHJlcGx5IGJl
Zm9yZSB0aGUgcGF0Y2ggc3RhcnRzIGFzIHlvdQ0KPiBkb24ndCBjb21tZW50IG9uIHRoZSBwYXRj
aCBpdHNlbGYgYW55d2F5Li4uDQoNCk9vcHMsIEknbSBzb3JyeS4gSSdsbCBkbyB0aGF0IGZvciB0
aGUgZnV0dXJlLg0KDQpCZXN0IHJlZ2FyZHMsDQpZb3NoaWhpcm8gU2hpbW9kYQ0KDQo=
