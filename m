Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B614279CDF
	for <lists+netdev@lfdr.de>; Sun, 27 Sep 2020 01:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgIZX1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Sep 2020 19:27:10 -0400
Received: from mail-bn8nam12on2043.outbound.protection.outlook.com ([40.107.237.43]:27689
        "EHLO NAM12-BN8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726382AbgIZX1K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Sep 2020 19:27:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ap/fLSQ0OYJ9iEmBKdXHulgXF5Tnl3TZfsl+XXnlJWecEMXFWE9an062bwdCgSQ4rc+CnZwsm2Vm5iHNSKVsXCrNivOTKPBodl5heO4NaUQXMn9bcaBOFOY+K5KqRNCGWHSjAyE+80IGOa7J3Z//G8uVncNMrW1sZ/b2BYxRySvqvNFbwTCnBuFC1gPD4Ciaowxz1a7ndsqsz4L3WvcS6Kb5G4qSV9Yk1ZE7vQwiRKEzP9YUAP8/Ztejdqw1vOo4f4mCwjtVUncSuB1gumgMRKiB4PTG3CPxO8tmv9Xv9qbwt0cTqQVtWODu8OcDibnMVdTYfmaVh18/yabeyEO1HQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1wg905FX2wwuW274cCjpr1qiDhwr6CaFI4/XAGc9yo=;
 b=h87Q/di4TPZ3b7p3osnUHdsQQJo8WxgOWb45pg2NYOcL65gMskR9jprf69h619BzUJE7GKI7+5HlLxW0GsYg5vMddIvJfw8W3VewTcjuBVQWIzdZlISqNOLw50mMSE+omHdVR1M9X/UnKb2BYWYVxsG8VHe8tsnjEY79OBqHKPZnF2iAAyvmCau+6UDVx3igO0hJjFwbpruQPT+5x/hzSuBCzVpDvJDMC75FH9GKoNZgttpkSYAChPKoDVesgfa8JSZ7JzpgBNjBgyjFrTCoBvQJTXu4+Ni4i7OEe+NFaofUtv/PSNExyefkGYiSFRUjT7wvyJZJydNoPn9agNJQ9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=windriver.com; dmarc=pass action=none
 header.from=windriver.com; dkim=pass header.d=windriver.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=windriversystems.onmicrosoft.com;
 s=selector2-windriversystems-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/1wg905FX2wwuW274cCjpr1qiDhwr6CaFI4/XAGc9yo=;
 b=HIm+o8Zuho1Sgs28l6vKbA9sZsxEz4LqIcz1eaH3XtcFNvXKxNkPkoYsIkp+0tU82aQDVPQ6GnKe1VAtN3y1XTZbA5VYHtVXqp33aDgfDAJ0C/TVUIRqFiBxaOyUR7uulw9dsIzVV5sUxpZ0jaEfAHJd5Y+aOvUuZUlYMxv1r4c=
Received: from BYAPR11MB2600.namprd11.prod.outlook.com (2603:10b6:a02:c8::15)
 by BYAPR11MB3719.namprd11.prod.outlook.com (2603:10b6:a03:fa::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3412.22; Sat, 26 Sep
 2020 23:27:06 +0000
Received: from BYAPR11MB2600.namprd11.prod.outlook.com
 ([fe80::103:e863:8475:4349]) by BYAPR11MB2600.namprd11.prod.outlook.com
 ([fe80::103:e863:8475:4349%5]) with mapi id 15.20.3391.026; Sat, 26 Sep 2020
 23:27:06 +0000
From:   "Liu, Yongxin" <Yongxin.Liu@windriver.com>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] Revert "net: ethernet: ixgbe: check the return value of
 ixgbe_mii_bus_init()"
Thread-Topic: [PATCH] Revert "net: ethernet: ixgbe: check the return value of
 ixgbe_mii_bus_init()"
Thread-Index: AQHWkugQQBwN14Xhs0uzcqOVgStpZql5AhuAgAAH39CAABD6gIACeCyw
Date:   Sat, 26 Sep 2020 23:27:05 +0000
Message-ID: <BYAPR11MB2600978E50C821FBC4DC66DAE5370@BYAPR11MB2600.namprd11.prod.outlook.com>
References: <20200925024247.993-1-yongxin.liu@windriver.com>
 <CAMpxmJWjczUhKH2K25E4Ezs9DEFQMxHMhD8qzhurSeEyE=wmXg@mail.gmail.com>
 <BYAPR11MB2600094C066D51C15B81EA70E5360@BYAPR11MB2600.namprd11.prod.outlook.com>
 <CAMpxmJXbwrE-X7zsnNy0DzmhWADR0GRXZy_RFK4RuOnCv=p7OA@mail.gmail.com>
In-Reply-To: <CAMpxmJXbwrE-X7zsnNy0DzmhWADR0GRXZy_RFK4RuOnCv=p7OA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: baylibre.com; dkim=none (message not signed)
 header.d=none;baylibre.com; dmarc=none action=none header.from=windriver.com;
x-originating-ip: [60.247.85.82]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 004110a0-ca8c-42a0-f059-08d86273ae8f
x-ms-traffictypediagnostic: BYAPR11MB3719:
x-microsoft-antispam-prvs: <BYAPR11MB3719DE73B75937654D049A07E5370@BYAPR11MB3719.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: cWd8S7USO81pfc+3tcA7kcNAUdEFr+RHhX+lbX1Kcv8Tz97XaoyuhtID2r32D9ZOz1r6Di4dLLF/hRA6czYqcUJlWbU6a15iphnBOlRijKN2KEZtVnybysFAtRWSmkwLIqxYW3XguqJWssrnr4UguCghXnRjYzvCAQk5iI2zwk6nzZ3A1xbfhcpmGW7yGZP6PA8zjvU9cJE6G/hfhzR115GY6vkfjTZ2PxtzLZCZZFCKWZJAetiMSIiuNb16B/cZRO4zZwMT3r/oSl5ePAdgwMGyU28yzI6T6D/h7lIPccgPpHCtqKuwb8sKJb8egPm6okaLkt2kYr2q/6bxRXMVaEzFYu+6a7CNvzC4ePLJlja8HZ1uuEVTzo7Yjx0MOfl25BcL+zSWrq+K3qNBT68m/9+ZG/ZbwoLyXm4NYbRFZ0S59PNgZHHMD40qqRnSWGMbq+29cGz2eNUTVlH+P5lg9Q==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR11MB2600.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(346002)(39830400003)(136003)(366004)(316002)(478600001)(6506007)(186003)(33656002)(6916009)(53546011)(86362001)(2906002)(26005)(54906003)(71200400001)(83380400001)(8676002)(64756008)(55016002)(4326008)(76116006)(5660300002)(66476007)(7696005)(66556008)(52536014)(9686003)(66446008)(8936002)(66946007)(966005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: x1IFkM87Y/OV0f6usjuextjQnDpd2xE7W+GgURp/S5uUiyvh3Fc3kHHVUXVBvZUWwuuln64CTeQZMGoSQKQEdFS3ecXLoSfiC11h82wk2El9j2No4lMOyR5+xTzxYIrsOml2co4iHT/0LFacNZkDU1oef0qv6vrB8IIUIVBpAglZVYzUtJ1ap9YATT0tipNFrSEQlzhv/DmMTEZk3NDP6SUizTMAPYBTzpbvuf+Nc5I9KVCEQAjOdictjNLa7TZh4zTPYX7SAqsR6XUPvwe8jNKDT4XstAMu4bu5/0GgL7cbBp0x8Qeb+7L1XALi5gAie0jJAuI7NAAKcY4K5NYFMZ97LJM9YZwY8Tj3VKPvnNpq02LZlNjU2lD4IzBO8Wk8mLQU7SE8Jh8BClSISlvCx5pcoLJ3B8NDp76lGVuTgwFO/hgtifSuAP8IjjmZ0lVkMuElCJi8/SLwnFfk5YXXu/PBotDOnahQOkeQCY0lPyNNadbinP5gy/PnOHDynTpPkdBFNSa5eci7y0/JhnA9GhOCvgrobyrUpre88EXnzGKRMdM5oXV1bLfXagH89NKzrx5XMdDEooM4CKMfXO4pgHNy2Mci7DKOlX4tF9JqMzw9gn9DNlZzl9g+7PHsdQioRp0BOBcZcKAD4+nW1FO6YQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: windriver.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BYAPR11MB2600.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 004110a0-ca8c-42a0-f059-08d86273ae8f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2020 23:27:05.9246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 8ddb2873-a1ad-4a18-ae4e-4644631433be
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jv5J4di6iZl+TnpgCk2RphXxaNM4nm1A++3QxpLqq3EAN1NmakOUDL474XgDDjNvhzWXCiTVXOQUQDereLz1vSBui4n1JeJgNnesz2P1Fl4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR11MB3719
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBCYXJ0b3N6IEdvbGFzemV3c2tp
IDxiZ29sYXN6ZXdza2lAYmF5bGlicmUuY29tPg0KPiBTZW50OiBGcmlkYXksIFNlcHRlbWJlciAy
NSwgMjAyMCAxNzo0NA0KPiBUbzogTGl1LCBZb25neGluIDxZb25neGluLkxpdUB3aW5kcml2ZXIu
Y29tPg0KPiBDYzogRGF2aWQgUyAuIE1pbGxlciA8ZGF2ZW1AZGF2ZW1sb2Z0Lm5ldD47IG5ldGRl
dg0KPiA8bmV0ZGV2QHZnZXIua2VybmVsLm9yZz47IExLTUwgPGxpbnV4LWtlcm5lbEB2Z2VyLmtl
cm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJlOiBbUEFUQ0hdIFJldmVydCAibmV0OiBldGhlcm5ldDog
aXhnYmU6IGNoZWNrIHRoZSByZXR1cm4gdmFsdWUNCj4gb2YgaXhnYmVfbWlpX2J1c19pbml0KCki
DQo+IA0KPiBPbiBGcmksIFNlcCAyNSwgMjAyMCBhdCAxMDo1MSBBTSBMaXUsIFlvbmd4aW4gPFlv
bmd4aW4uTGl1QHdpbmRyaXZlci5jb20+DQo+IHdyb3RlOg0KPiA+DQo+IA0KPiBbc25pcF0NCj4g
DQo+ID4gPiA+ICAgICAgICAgICAgICAgICAgICAgICAgIHRydWUpOw0KPiA+ID4gPg0KPiA+ID4g
PiAtICAgICAgIGVyciA9IGl4Z2JlX21paV9idXNfaW5pdChodyk7DQo+ID4gPiA+IC0gICAgICAg
aWYgKGVycikNCj4gPiA+ID4gLSAgICAgICAgICAgICAgIGdvdG8gZXJyX25ldGRldjsNCj4gPiA+
ID4gKyAgICAgICBpeGdiZV9taWlfYnVzX2luaXQoaHcpOw0KPiA+ID4gPg0KPiA+ID4gPiAgICAg
ICAgIHJldHVybiAwOw0KPiA+ID4gPg0KPiA+ID4gPiAtZXJyX25ldGRldjoNCj4gPiA+ID4gLSAg
ICAgICB1bnJlZ2lzdGVyX25ldGRldihuZXRkZXYpOw0KPiA+ID4gPiAgZXJyX3JlZ2lzdGVyOg0K
PiA+ID4gPiAgICAgICAgIGl4Z2JlX3JlbGVhc2VfaHdfY29udHJvbChhZGFwdGVyKTsNCj4gPiA+
ID4gICAgICAgICBpeGdiZV9jbGVhcl9pbnRlcnJ1cHRfc2NoZW1lKGFkYXB0ZXIpOw0KPiA+ID4g
PiAtLQ0KPiA+ID4gPiAyLjE0LjQNCj4gPiA+ID4NCj4gPiA+DQo+ID4gPiBUaGVuIHdlIHNob3Vs
ZCBjaGVjayBpZiBlcnIgPT0gLUVOT0RFViwgbm90IG91dHJpZ2h0IGlnbm9yZSBhbGwNCj4gPiA+
IHBvdGVudGlhbCBlcnJvcnMsIHJpZ2h0Pw0KPiA+ID4NCj4gPg0KPiA+IEhtLCBpdCBpcyB3ZWly
ZCB0byB0YWtlIC1FTk9ERVYgYXMgYSBubyBlcnJvci4NCj4gPiBIb3cgYWJvdXQganVzdCByZXR1
cm4gMCBpbnN0ZWFkIG9mIC1FTk9ERVYgaW4gdGhlIGZvbGxvd2luZyBmdW5jdGlvbj8NCj4gPg0K
PiANCj4gTm8sIGl0J3MgcGVyZmVjdGx5IGZpbmUuIC1FTk9ERVYgbWVhbnMgdGhlcmUncyBubyBk
ZXZpY2UgYW5kIHRoaXMgY2FuDQo+IGhhcHBlbi4gVGhlIGNhbGxlciBjYW4gdGhlbiBhY3QgYWNj
b3JkaW5nbHkgLSBmb3IgZXhhbXBsZTogaWdub3JlIHRoYXQNCj4gZmFjdC4gV2UgZG8gaXQgaW4g
c2V2ZXJhbCBwbGFjZXNbMV0uDQo+IA0KPiBCYXJ0b3N6DQo+IA0KPiBbc25pcF0NCj4gDQo+IFsx
XQ0KPiBodHRwczovL2VsaXhpci5ib290bGluLmNvbS9saW51eC9sYXRlc3Qvc291cmNlL2RyaXZl
cnMvbWlzYy9lZXByb20vYXQyNC5jIw0KPiBMNzE0DQoNCg0KT2theSwgcGxlYXNlIGdvIGFoZWFk
IGFuZCBmaXggdGhpcyBpc3N1ZS4NCg0KDQpUaGFua3MsDQpZb25neGluDQo=
