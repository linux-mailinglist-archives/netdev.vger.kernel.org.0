Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 491C5384A8
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 08:58:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727524AbfFGG6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 02:58:24 -0400
Received: from mail-eopbgr740081.outbound.protection.outlook.com ([40.107.74.81]:15280
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726891AbfFGG6X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 7 Jun 2019 02:58:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=xilinx.onmicrosoft.com; s=selector1-xilinx-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pKjBHGhH/wJcjTXje/fojuz6JzyLJn0zVl1WKgrfH28=;
 b=wHjUglFNVpFmsKJWNPNifaA5vP6o1Zen/jseIuZ7XctbkvLlgz89/0A70KW5d3E/8lqUe44PTc77Qa9rLuVD7gix2qZOKjNvE9bag2IahPe7CoeNvKct/RP7JU0ySzhQu0WigxA1NZ6Vs3cSQXkHh5etLPCLKjtLxIGHPdhSGI4=
Received: from MN2PR02MB6400.namprd02.prod.outlook.com (52.132.175.209) by
 MN2PR02MB6333.namprd02.prod.outlook.com (52.132.175.90) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1943.22; Fri, 7 Jun 2019 06:58:15 +0000
Received: from MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::6001:ad1f:d548:2b71]) by MN2PR02MB6400.namprd02.prod.outlook.com
 ([fe80::6001:ad1f:d548:2b71%6]) with mapi id 15.20.1965.011; Fri, 7 Jun 2019
 06:58:14 +0000
From:   Appana Durga Kedareswara Rao <appanad@xilinx.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "wg@grandegger.com" <wg@grandegger.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Michal Simek <michals@xilinx.com>
CC:     "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Srinivas Neeli <sneeli@xilinx.com>
Subject: RE: [PATCH 0/6] net: can: xilinx_can: Bug fixes and Enhancements
Thread-Topic: [PATCH 0/6] net: can: xilinx_can: Bug fixes and Enhancements
Thread-Index: AQHU3X5pxtrhGyT8f0y/0R8BjEz816YUgSyAgAEkNOCAM9QFwIBGxw/Q
Date:   Fri, 7 Jun 2019 06:58:14 +0000
Message-ID: <MN2PR02MB64007451AEE68134E7B304A1DC100@MN2PR02MB6400.namprd02.prod.outlook.com>
References: <1552908766-26753-1-git-send-email-appana.durga.rao@xilinx.com>
 <d1cd73cc-e200-7c06-dd6e-3c5e2e35709c@pengutronix.de>
 <DM5PR02MB21875918C65EF8757E34C574DC420@DM5PR02MB2187.namprd02.prod.outlook.com>
 <DM5PR02MB2187137A63481B2BB2E12920DC230@DM5PR02MB2187.namprd02.prod.outlook.com>
In-Reply-To: <DM5PR02MB2187137A63481B2BB2E12920DC230@DM5PR02MB2187.namprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-Auto-Response-Suppress: DR, RN, NRN, OOF, AutoReply
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=appanad@xilinx.com; 
x-originating-ip: [149.199.50.133]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba809c67-1da0-45b5-4162-08d6eb158354
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:MN2PR02MB6333;
x-ms-traffictypediagnostic: MN2PR02MB6333:
x-ms-exchange-purlcount: 2
x-ld-processed: 657af505-d5df-48d0-8300-c31994686c5c,ExtAddr
x-microsoft-antispam-prvs: <MN2PR02MB6333F21B56A7142C46C027E2DC100@MN2PR02MB6333.namprd02.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0061C35778
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(366004)(376002)(136003)(346002)(39860400002)(199004)(189003)(13464003)(256004)(66066001)(2906002)(71200400001)(53936002)(107886003)(4326008)(53386004)(74316002)(6116002)(3846002)(76116006)(2501003)(73956011)(71190400001)(66446008)(66946007)(5660300002)(64756008)(76176011)(102836004)(52536014)(8936002)(8676002)(81156014)(81166006)(99286004)(7696005)(66476007)(53546011)(6506007)(6436002)(55016002)(186003)(446003)(229853002)(7736002)(6306002)(305945005)(9686003)(476003)(66556008)(478600001)(26005)(14444005)(316002)(86362001)(14454004)(966005)(68736007)(6246003)(11346002)(6636002)(110136005)(2201001)(25786009)(486006)(54906003)(33656002);DIR:OUT;SFP:1101;SCL:1;SRVR:MN2PR02MB6333;H:MN2PR02MB6400.namprd02.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: xilinx.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: KjCwsLk52Xuuxjt/qA+rHs7hF4ZGFQCRk/jDgGmV9XDYG/d0HyrtdYPaKOcHwsYsgJqIXkAarERGhbFNNuIliSQeJwTGOkoO4zWjF8D1CoPL/OWZPSOG+Atxv6eXUYA+EFW6ZuK75rP1XMl+VmYl+UxNeZMmm+ugS9LcArYtHesQxDnIurdPBWCodCvyeie4QHPkGmDTEQWL84I8vS+JIvoFKO/iBvQDNVMoeyrwvjkxtf/H605dm8A/8WbtjOUZo7OssNfAMui60UTbu2BBGw06SoYAoefTDLcvsXyxw1gXoWXHAEJ03xZZV4RCb939Yq46vBa6hrXlqSNqmFWORDZ4X7JRklc8xuMbdeNPrFVDyIDGYlXx+4MXPfzlFr7lsfFGGC7BTxWd+t4aeYuLfl09sb3OlGwnFcYi0+4cGZs=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: xilinx.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba809c67-1da0-45b5-4162-08d6eb158354
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jun 2019 06:58:14.7872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 657af505-d5df-48d0-8300-c31994686c5c
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: appanad@xilinx.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR02MB6333
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTWFyYywNCg0KRnJpZW5kbHkgcGluZyAhIQ0KDQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0t
LS0tDQo+IEZyb206IEFwcGFuYSBEdXJnYSBLZWRhcmVzd2FyYSBSYW8NCj4gU2VudDogVHVlc2Rh
eSwgQXByaWwgMjMsIDIwMTkgMTI6MDggUE0NCj4gVG86ICdNYXJjIEtsZWluZS1CdWRkZScgPG1r
bEBwZW5ndXRyb25peC5kZT47ICd3Z0BncmFuZGVnZ2VyLmNvbScNCj4gPHdnQGdyYW5kZWdnZXIu
Y29tPjsgJ2RhdmVtQGRhdmVtbG9mdC5uZXQnIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsNCj4gTWlj
aGFsIFNpbWVrIDxtaWNoYWxzQHhpbGlueC5jb20+DQo+IENjOiAnbGludXgtY2FuQHZnZXIua2Vy
bmVsLm9yZycgPGxpbnV4LWNhbkB2Z2VyLmtlcm5lbC5vcmc+Ow0KPiAnbmV0ZGV2QHZnZXIua2Vy
bmVsLm9yZycgPG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc+OyAnbGludXgtYXJtLQ0KPiBrZXJuZWxA
bGlzdHMuaW5mcmFkZWFkLm9yZycgPGxpbnV4LWFybS1rZXJuZWxAbGlzdHMuaW5mcmFkZWFkLm9y
Zz47ICdsaW51eC0NCj4ga2VybmVsQHZnZXIua2VybmVsLm9yZycgPGxpbnV4LWtlcm5lbEB2Z2Vy
Lmtlcm5lbC5vcmc+DQo+IFN1YmplY3Q6IFJFOiBbUEFUQ0ggMC82XSBuZXQ6IGNhbjogeGlsaW54
X2NhbjogQnVnIGZpeGVzIGFuZCBFbmhhbmNlbWVudHMNCj4gDQo+IEhpIE1hcmMsDQo+IA0KPiA+
IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+ID4gRnJvbTogQXBwYW5hIER1cmdhIEtlZGFy
ZXN3YXJhIFJhbw0KPiA+IFNlbnQ6IFRodXJzZGF5LCBNYXJjaCAyMSwgMjAxOSAxMjowNiBQTQ0K
PiA+IFRvOiAnTWFyYyBLbGVpbmUtQnVkZGUnIDxta2xAcGVuZ3V0cm9uaXguZGU+OyB3Z0BncmFu
ZGVnZ2VyLmNvbTsNCj4gPiBkYXZlbUBkYXZlbWxvZnQubmV0OyBNaWNoYWwgU2ltZWsgPG1pY2hh
bHNAeGlsaW54LmNvbT4NCj4gPiBDYzogbGludXgtY2FuQHZnZXIua2VybmVsLm9yZzsgbmV0ZGV2
QHZnZXIua2VybmVsLm9yZzsgbGludXgtYXJtLQ0KPiA+IGtlcm5lbEBsaXN0cy5pbmZyYWRlYWQu
b3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gU3ViamVjdDogUkU6IFtQQVRD
SCAwLzZdIG5ldDogY2FuOiB4aWxpbnhfY2FuOiBCdWcgZml4ZXMgYW5kDQo+ID4gRW5oYW5jZW1l
bnRzDQo+ID4NCj4gPiBIaSBNYXJjLA0KPiA+DQo+ID4gPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2Ut
LS0tLQ0KPiA+ID4gRnJvbTogTWFyYyBLbGVpbmUtQnVkZGUgPG1rbEBwZW5ndXRyb25peC5kZT4N
Cj4gPiA+IFNlbnQ6IFdlZG5lc2RheSwgTWFyY2ggMjAsIDIwMTkgNjozOSBQTQ0KPiA+ID4gVG86
IEFwcGFuYSBEdXJnYSBLZWRhcmVzd2FyYSBSYW8gPGFwcGFuYWRAeGlsaW54LmNvbT47DQo+ID4g
PiB3Z0BncmFuZGVnZ2VyLmNvbTsgZGF2ZW1AZGF2ZW1sb2Z0Lm5ldDsgTWljaGFsIFNpbWVrDQo+
ID4gPiA8bWljaGFsc0B4aWxpbnguY29tPg0KPiA+ID4gQ2M6IGxpbnV4LWNhbkB2Z2VyLmtlcm5l
bC5vcmc7IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IGxpbnV4LWFybS0NCj4gPiA+IGtlcm5lbEBs
aXN0cy5pbmZyYWRlYWQub3JnOyBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+ID4gPiBT
dWJqZWN0OiBSZTogW1BBVENIIDAvNl0gbmV0OiBjYW46IHhpbGlueF9jYW46IEJ1ZyBmaXhlcyBh
bmQNCj4gPiA+IEVuaGFuY2VtZW50cw0KPiA+ID4NCj4gPiA+IE9uIDMvMTgvMTkgMTI6MzIgUE0s
IEFwcGFuYSBEdXJnYSBLZWRhcmVzd2FyYSByYW8gd3JvdGU6DQo+ID4gPiA+IFRoaXMgcGF0Y2gg
c2VyaWVzIGRvZXMgdGhlIGJlbG93DQo+ID4gPiA+IC0tPiBBZGRlZCBzdXBwb3J0IGZvciBDQU5G
RCBGRCBmcmFtZXMgRml4IENoZWNrcGF0Y2ggcmVwb3J0ZWQNCj4gPiA+ID4gLS0+IHdhcm5pbmdz
IGFuZCBjaGVja3MNCj4gPiA+ID4NCj4gPiA+ID4gQXBwYW5hIER1cmdhIEtlZGFyZXN3YXJhIHJh
byAoNik6DQo+ID4gPiA+ICAgbmV0OiBjYW46IHhpbGlueF9jYW46IEZpeCBzdHlsZSBpc3N1ZXMN
Cj4gPiA+ID4gICBuZXQ6IGNhbjogeGlsaW54X2NhbjogRml4IGZsYWdzIGZpZWxkIGluaXRpYWxp
emF0aW9uIGZvciBheGkgY2FuIGFuZA0KPiA+ID4gPiAgICAgY2FucHMNCj4gPiA+ID4gICBuZXQ6
IGNhbjogeGlsaW54X2NhbjogQWRkIGNhbnR5cGUgcGFyYW1ldGVyIGluIHhjYW5fZGV2dHlwZV9k
YXRhDQo+ID4gPiA+ICAgICBzdHJ1Y3QNCj4gPiA+ID4gICBuZXQ6IGNhbjogeGlsaW54X2Nhbjog
QWRkIHN1cHBvcnQgZm9yIENBTkZEIEZEIGZyYW1lcw0KPiA+ID4gPiAgIG5ldDogY2FuOiB4aWxp
bnhfY2FuOiBBZGQgU1BEWCBsaWNlbnNlDQo+ID4gPiA+ICAgbmV0OiBjYW46IHhpbGlueF9jYW46
IEZpeCBrZXJuZWwgZG9jIHdhcm5pbmdzDQo+ID4gPiA+DQo+ID4gPiA+ICBkcml2ZXJzL25ldC9j
YW4veGlsaW54X2Nhbi5jIHwgMzAzDQo+ID4gPiA+ICsrKysrKysrKysrKysrKysrKysrKysrKysr
KysrKysrKysrKy0tLS0tLS0NCj4gPiA+ID4gIDEgZmlsZSBjaGFuZ2VkLCAyNTcgaW5zZXJ0aW9u
cygrKSwgNDYgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiA+ID4gQXBwbGllZCB0byBsaW51eC1jYW4t
bmV4dC90ZXN0aW5nLCBidXQgaW4gb3JkZXIuIEZpcnN0IGZpeGVzIHRoYW4NCj4gPiA+IGVuaGFu
Y2VtZW50czoNCj4gPg0KPiA+IFRoYW5rcy4uLg0KPiA+IEkgY291bGRuJ3QgZmluZCB0aGUgcGF0
Y2hlcyBoZXJlDQo+ID4gaHR0cHM6Ly9naXQua2VybmVsLm9yZy9wdWIvc2NtL2xpbnV4L2tlcm5l
bC9naXQvbWtsL2xpbnV4LWNhbi0NCj4gPiBuZXh0LmdpdC9sb2cvZHJpdmVycy9uZXQvY2FuL3hp
bGlueF9jYW4uYz9oPXRlc3RpbmcNCj4gPiBBbSBJIHJlZmVycmluZyB3cm9uZyByZXBvL2JyYW5j
aD8/DQo+IA0KPiBUaGVyZSBhcmUgYSBjb3VwbGUgb2YgYnVnIGZpeGVzIGF2YWlsYWJsZSBmb3Ig
dGhpcyBkcml2ZXIgb24gdG9wIG9mIHRoaXMgcGF0Y2gNCj4gc2VyaWVzLg0KPiBQbGVhc2UgbGV0
IG1lIGtub3cgdGhlIGJyYW5jaCB3aGVyZSB0aGlzIHBhdGNoIHNlcmllcyBnb3QgYXBwbGllZCwg
d2lsbCBzZW5kDQo+IHRoZSBidWcgZml4ZXMgb24gdG9wIG9mIHRoYXQgYnJhbmNoLg0KPiANCg0K
UmVnYXJkcywNCktlZGFyLg0KDQo+IFJlZ2FyZHMsDQo+IEtlZGFyLg0KPiA+DQo+ID4gUmVnYXJk
cywNCj4gPiBLZWRhci4NCj4gPiA+DQo+ID4gPiA+IDI0MTgyNjMwMjg1NCBuZXQ6IGNhbjogeGls
aW54X2NhbjogRml4IHN0eWxlIGlzc3Vlcw0KPiA+ID4gPiA3MGZiMjZmYWRjMjcgbmV0OiBjYW46
IHhpbGlueF9jYW46IEZpeCBrZXJuZWwgZG9jIHdhcm5pbmdzDQo+ID4gPiA+IDdiZWI2NDM1MWZm
MSBuZXQ6IGNhbjogeGlsaW54X2NhbjogQWRkIFNQRFggbGljZW5zZSBkZDk0OTEwYmNlYWUgbmV0
Og0KPiA+ID4gPiBjYW46IHhpbGlueF9jYW46IEZpeCBmbGFncyBmaWVsZCBpbml0aWFsaXphdGlv
biBmb3IgYXhpIGNhbiBhbmQNCj4gPiA+ID4gY2FucHMNCj4gPiA+ID4gNmJkMDVjZWNlNTY3IG5l
dDogY2FuOiB4aWxpbnhfY2FuOiBBZGQgY2FudHlwZSBwYXJhbWV0ZXIgaW4NCj4gPiA+ID4geGNh
bl9kZXZ0eXBlX2RhdGEgc3RydWN0DQo+ID4gPiA+IDM0ZTI4MDE3MDczNiBuZXQ6IGNhbjogeGls
aW54X2NhbjogQWRkIHN1cHBvcnQgZm9yIENBTkZEIEZEIGZyYW1lcw0KPiA+ID4NCj4gPiA+IE1h
cmMNCj4gPiA+DQo+ID4gPiAtLQ0KPiA+ID4gUGVuZ3V0cm9uaXggZS5LLiAgICAgICAgICAgICAg
ICAgIHwgTWFyYyBLbGVpbmUtQnVkZGUgICAgICAgICAgIHwNCj4gPiA+IEluZHVzdHJpYWwgTGlu
dXggU29sdXRpb25zICAgICAgICB8IFBob25lOiArNDktMjMxLTI4MjYtOTI0ICAgICB8DQo+ID4g
PiBWZXJ0cmV0dW5nIFdlc3QvRG9ydG11bmQgICAgICAgICAgfCBGYXg6ICAgKzQ5LTUxMjEtMjA2
OTE3LTU1NTUgfA0KPiA+ID4gQW10c2dlcmljaHQgSGlsZGVzaGVpbSwgSFJBIDI2ODYgIHwgaHR0
cDovL3d3dy5wZW5ndXRyb25peC5kZSAgIHwNCg0K
