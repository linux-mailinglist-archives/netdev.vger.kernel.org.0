Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0FE78CA6F
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 06:35:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726947AbfHNEf3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 00:35:29 -0400
Received: from mail-eopbgr50071.outbound.protection.outlook.com ([40.107.5.71]:6894
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726631AbfHNEf3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Aug 2019 00:35:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Md5fD17WhuhWsIzmv7Ys0L4ft9J78zwHNoLccyj6eWTMHWY5DPcn9hFVOsQS/PtbeufjN3+O/lorIGaUGb+CsZQUW+hfgwW/NQs+85f9O4lrzNvcKOz2uehbujc5Unj5sNUQV4k8gQbSMT+LDOpuMDE4m8X27JpkH75DFQkVvwOqOhW4bcACjPdxBR7OfHsOaiLScwWlWpqS5b1RSLI0DZKy1MMTmfbo1X9RGavP2fRkWl1nmS671c2LCbM3K6LtnWqyLKQVHygE+VDyRQL67bk88Rl89UYLSVKxdJLW0DxZvpTWsdDcItmwzOwZlkMj+ZeCwVH3LKWAZ5kw/xLy4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHRP0/FxhsqhZgXtx0AECvh0mjkTzOEIcSns5pKJyHc=;
 b=G/X1UwZ4s1atEojuEg+C5HNMdKP57sXj7xcWtErtq9DDyM91w1lbHPFbZ1fg0Xt1wei9ZCtsttx+k/8/eHtTV6qluw32/jvJHTienfP1ueJrQDMxaSs3tchjWDDYEOeHgGAMoSfeFbMrj/W+6Tj5M6uvNioKhSh5Cs+YG9+R9zAYIinpApZUNcFypoGXLgIJgeO5Dq1UOyFevStSzDfhGXJhXlraz1S7W52YT0SnIkY16yyas+n+S8FW+T8sFe3rd02RgV0bHoqr0q29PMEtRf0i10l3VpHCxY5AmHit6xqP+Xh8kAsvje0/kJHFAzwB8rArqgqrYh+Un8NZKT2VDg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BHRP0/FxhsqhZgXtx0AECvh0mjkTzOEIcSns5pKJyHc=;
 b=dKlEC3tgmMIq/Dmj+I4mcwxi3eN1z6w8Dd6eIAwEXSKmlrm8En4CQ/Z40ZYD7jjIrybsiH1ye/iNQcstMtuou4KhrEkZWvuSvAjcyaZ19lGBoGzXZtH9614FXyPy3vCtQo2ub5TCWslBP+XK136ATL4uECy1Vz3yo3mD6n8cneA=
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com (10.169.132.138) by
 VI1PR0401MB2576.eurprd04.prod.outlook.com (10.168.65.8) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2157.14; Wed, 14 Aug 2019 04:35:25 +0000
Received: from VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37]) by VI1PR0401MB2237.eurprd04.prod.outlook.com
 ([fe80::2072:e49f:a84a:8f37%11]) with mapi id 15.20.2157.022; Wed, 14 Aug
 2019 04:35:25 +0000
From:   "Y.b. Lu" <yangbo.lu@nxp.com>
To:     "Allan W . Nielsen" <allan.nielsen@microchip.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>
Subject: RE: [v2, 3/4] ocelot_ace: fix action of trap
Thread-Topic: [v2, 3/4] ocelot_ace: fix action of trap
Thread-Index: AQHVUYHAMgIQ7j68xkmdFszj+Iric6b4mmEAgAADugCAAXIisA==
Date:   Wed, 14 Aug 2019 04:35:25 +0000
Message-ID: <VI1PR0401MB2237F2B0D3907E2AAD82E666F8AD0@VI1PR0401MB2237.eurprd04.prod.outlook.com>
References: <20190813025214.18601-1-yangbo.lu@nxp.com>
 <20190813025214.18601-4-yangbo.lu@nxp.com>
 <20190813061651.7gtbum4wsaw5dahg@lx-anielsen.microsemi.net>
 <20190813063011.7pwlzm7mtzlqwwkx@lx-anielsen.microsemi.net>
In-Reply-To: <20190813063011.7pwlzm7mtzlqwwkx@lx-anielsen.microsemi.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yangbo.lu@nxp.com; 
x-originating-ip: [92.121.36.198]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d4928740-f46c-440e-6ee6-08d72070d39f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR0401MB2576;
x-ms-traffictypediagnostic: VI1PR0401MB2576:
x-microsoft-antispam-prvs: <VI1PR0401MB2576684B287F878752175F7EF8AD0@VI1PR0401MB2576.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01294F875B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(376002)(136003)(39860400002)(396003)(366004)(199004)(53754006)(13464003)(189003)(71190400001)(229853002)(66556008)(71200400001)(478600001)(53936002)(81166006)(316002)(81156014)(5660300002)(6916009)(76116006)(54906003)(66446008)(9686003)(66476007)(66946007)(64756008)(99286004)(55016002)(8936002)(6436002)(2906002)(6246003)(52536014)(86362001)(33656002)(4326008)(102836004)(256004)(14454004)(305945005)(26005)(7736002)(186003)(74316002)(11346002)(6506007)(25786009)(7696005)(3846002)(76176011)(8676002)(66066001)(6116002)(476003)(446003)(486006)(53546011);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0401MB2576;H:VI1PR0401MB2237.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: oCvDtktG4J27r6PJFvn7UFQnul4izDKqmnE80qzOloPNWiGnUr3Df04y4UWjO4ok41hH+W3kfL6wBm6yaokPHugRMpMUfzQadFTupBpBniEJVLZH074etyov03oLhfGdi8fqYa4ovdhZAFMO0xlMMpCf3tuVFGR+remdvPmqhSIRekL6hqzu1BEH95s2rs9Ic/1E6LlaOH5GL8ISX9eEify5IS/fF4n6q+/6CBekRbag11uqPsmBa+5PwXwiPxT+KERDkmkkZbJRE1JchGZdhMP4kVHEJxs/EjOa9K08efFeIJ9QnLSyM/IoLzLZAadCoqfXB61cnf3UvlMfZUatJVFsypeNPsjmAYwt68xBkE5Bo160/JcLwLgZYFjAoSB7V+D5GOHJWJSIEmjtW655qyVJCL2marWmQhIzW391Kns=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d4928740-f46c-440e-6ee6-08d72070d39f
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 Aug 2019 04:35:25.4292
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: uyDMgvs17A9utnQSSEknhMlPGLwk/cFddACrLNZm1kSHg7tnGgof2Hr/Epwj4V/Q85RhN45tQ3vSCAB9XLWyiw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0401MB2576
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgQWxsYW4sDQoNCj4gLS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCj4gRnJvbTogbmV0ZGV2
LW93bmVyQHZnZXIua2VybmVsLm9yZyA8bmV0ZGV2LW93bmVyQHZnZXIua2VybmVsLm9yZz4gT24N
Cj4gQmVoYWxmIE9mIEFsbGFuIFcgLiBOaWVsc2VuDQo+IFNlbnQ6IFR1ZXNkYXksIEF1Z3VzdCAx
MywgMjAxOSAyOjMwIFBNDQo+IFRvOiBZLmIuIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gQ2M6
IG5ldGRldkB2Z2VyLmtlcm5lbC5vcmc7IERhdmlkIFMgLiBNaWxsZXIgPGRhdmVtQGRhdmVtbG9m
dC5uZXQ+Ow0KPiBBbGV4YW5kcmUgQmVsbG9uaSA8YWxleGFuZHJlLmJlbGxvbmlAYm9vdGxpbi5j
b20+OyBNaWNyb2NoaXAgTGludXggRHJpdmVyDQo+IFN1cHBvcnQgPFVOR0xpbnV4RHJpdmVyQG1p
Y3JvY2hpcC5jb20+DQo+IFN1YmplY3Q6IFJlOiBbdjIsIDMvNF0gb2NlbG90X2FjZTogZml4IGFj
dGlvbiBvZiB0cmFwDQo+IA0KPiBUaGUgMDgvMTMvMjAxOSAwODoxNiwgQWxsYW4gVyAuIE5pZWxz
ZW4gd3JvdGU6DQo+ID4gVGhlIDA4LzEzLzIwMTkgMTA6NTIsIFlhbmdibyBMdSB3cm90ZToNCj4g
PiA+IFRoZSB0cmFwIGFjdGlvbiBzaG91bGQgYmUgY29weWluZyB0aGUgZnJhbWUgdG8gQ1BVIGFu
ZCBkcm9wcGluZyBpdA0KPiA+ID4gZm9yIGZvcndhcmRpbmcsIGJ1dCBjdXJyZW50IHNldHRpbmcg
d2FzIGp1c3QgY29weWluZyBmcmFtZSB0byBDUFUuDQo+ID4gPg0KPiA+ID4gU2lnbmVkLW9mZi1i
eTogWWFuZ2JvIEx1IDx5YW5nYm8ubHVAbnhwLmNvbT4NCj4gPiA+IC0tLQ0KPiA+ID4gQ2hhbmdl
cyBmb3IgdjI6DQo+ID4gPiAJLSBOb25lLg0KPiA+ID4gLS0tDQo+ID4gPiAgZHJpdmVycy9uZXQv
ZXRoZXJuZXQvbXNjYy9vY2Vsb3RfYWNlLmMgfCA2ICsrKy0tLQ0KPiA+ID4gIDEgZmlsZSBjaGFu
Z2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+ID4gPg0KPiA+ID4gZGlmZiAt
LWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2FjZS5jDQo+ID4gPiBiL2Ry
aXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90X2FjZS5jDQo+ID4gPiBpbmRleCA5MTI1MGYz
Li41OWFkNTkwIDEwMDY0NA0KPiA+ID4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvbXNjYy9v
Y2Vsb3RfYWNlLmMNCj4gPiA+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L21zY2Mvb2NlbG90
X2FjZS5jDQo+ID4gPiBAQCAtMzE3LDkgKzMxNyw5IEBAIHN0YXRpYyB2b2lkIGlzMl9hY3Rpb25f
c2V0KHN0cnVjdCB2Y2FwX2RhdGEgKmRhdGEsDQo+ID4gPiAgCQlicmVhazsNCj4gPiA+ICAJY2Fz
ZSBPQ0VMT1RfQUNMX0FDVElPTl9UUkFQOg0KPiA+ID4gIAkJVkNBUF9BQ1RfU0VUKFBPUlRfTUFT
SywgMHgwKTsNCj4gPiA+IC0JCVZDQVBfQUNUX1NFVChNQVNLX01PREUsIDB4MCk7DQo+ID4gPiAt
CQlWQ0FQX0FDVF9TRVQoUE9MSUNFX0VOQSwgMHgwKTsNCj4gPiA+IC0JCVZDQVBfQUNUX1NFVChQ
T0xJQ0VfSURYLCAweDApOw0KPiA+ID4gKwkJVkNBUF9BQ1RfU0VUKE1BU0tfTU9ERSwgMHgxKTsN
Cj4gPiA+ICsJCVZDQVBfQUNUX1NFVChQT0xJQ0VfRU5BLCAweDEpOw0KPiA+ID4gKwkJVkNBUF9B
Q1RfU0VUKFBPTElDRV9JRFgsIE9DRUxPVF9QT0xJQ0VSX0RJU0NBUkQpOw0KPiA+ID4gIAkJVkNB
UF9BQ1RfU0VUKENQVV9RVV9OVU0sIDB4MCk7DQo+ID4gPiAgCQlWQ0FQX0FDVF9TRVQoQ1BVX0NP
UFlfRU5BLCAweDEpOw0KPiA+ID4gIAkJYnJlYWs7DQo+ID4NCj4gPiBUaGlzIGlzIHN0aWxsIHdy
b25nLCBwbGVhc2Ugc2VlIHRoZSBjb21tZW50cyBwcm92aWRlZCB0aGUgZmlyc3QgdGltZQ0KPiA+
IHlvdSBzdWJtaXR0ZWQgdGhpcy4NCj4gPg0KPiA+IC9BbGxhbg0KPiANCj4gSSBiZWxpZXZlIHRo
aXMgd2lsbCBtYWtlIGl0IHdvcmsgLSBidXQgSSBoYXZlIG5vdCB0ZXN0ZWQgaXQ6DQo+IA0KPiAg
CWNhc2UgT0NFTE9UX0FDTF9BQ1RJT05fVFJBUDoNCj4gIAkJVkNBUF9BQ1RfU0VUKFBPUlRfTUFT
SywgMHgwKTsNCj4gLQkJVkNBUF9BQ1RfU0VUKE1BU0tfTU9ERSwgMHgwKTsNCj4gKwkJVkNBUF9B
Q1RfU0VUKE1BU0tfTU9ERSwgMHgxKTsNCj4gIAkJVkNBUF9BQ1RfU0VUKENQVV9RVV9OVU0sIDB4
MCk7DQo+ICAJCVZDQVBfQUNUX1NFVChDUFVfQ09QWV9FTkEsIDB4MSk7DQo+ICAJCWJyZWFrOw0K
PiANCg0KW1kuYi4gTHVdIEkgd2lsbCBoYXZlIGEgdHJ5LiBJdCBzZWVtcyBtb3JlIHByb3Blci4N
ClRoYW5rcy4NCg0KPiAtLQ0KPiAvQWxsYW4NCg==
