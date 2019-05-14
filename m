Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 485791C3CA
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 09:24:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726338AbfENHYQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 03:24:16 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:64662 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfENHYQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 May 2019 03:24:16 -0400
Received-SPF: Pass (esa2.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa2.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa2.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa2.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.60,467,1549954800"; 
   d="scan'208";a="33027039"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/DHE-RSA-AES256-SHA; 14 May 2019 00:24:15 -0700
Received: from NAM05-DM3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.76.49) with Microsoft SMTP Server (TLS) id
 14.3.352.0; Tue, 14 May 2019 00:24:04 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Mj/17vUNWUDyqVec96UZVHVD14D6vp/DKaBx2tvwpVM=;
 b=W2TgjKjtivYyRkbDbdc5at+VhmQPq2KJfhPJTorus3J6TB1FX8NMzPb+B/jLg/CU+lnqjW0r8nZoRZF76/oHYuW+ATRiuys/J5yDqxPAMF5J7WFgSB0TNlvVhq9+SPwu18/f402MRPEdzLM9mINmrpPKGgltLeoo4O4utTInrJg=
Received: from DM5PR11MB1658.namprd11.prod.outlook.com (10.172.36.9) by
 DM5PR11MB1849.namprd11.prod.outlook.com (10.175.90.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.24; Tue, 14 May 2019 07:24:02 +0000
Received: from DM5PR11MB1658.namprd11.prod.outlook.com
 ([fe80::11ae:9a85:a3d:f722]) by DM5PR11MB1658.namprd11.prod.outlook.com
 ([fe80::11ae:9a85:a3d:f722%8]) with mapi id 15.20.1878.024; Tue, 14 May 2019
 07:24:02 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <luca@lucaceresoli.net>, <netdev@vger.kernel.org>
CC:     <davem@davemloft.net>, <linux-kernel@vger.kernel.org>,
        <Claudiu.Beznea@microchip.com>
Subject: Re: [PATCH] net: macb: fix error format in dev_err()
Thread-Topic: [PATCH] net: macb: fix error format in dev_err()
Thread-Index: AQHVCiU4ThIIVTJw1Ey4CFSnWt1LDaZqN7AA
Date:   Tue, 14 May 2019 07:24:02 +0000
Message-ID: <775ea7ee-f879-149a-8a60-97635a2cd218@microchip.com>
References: <20190514071450.27760-1-luca@lucaceresoli.net>
In-Reply-To: <20190514071450.27760-1-luca@lucaceresoli.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR04CA0034.namprd04.prod.outlook.com
 (2603:10b6:a03:40::47) To DM5PR11MB1658.namprd11.prod.outlook.com
 (2603:10b6:4:8::9)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [94.177.32.154]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: abdf06a0-cd3b-4820-c008-08d6d83d23b2
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM5PR11MB1849;
x-ms-traffictypediagnostic: DM5PR11MB1849:
x-microsoft-antispam-prvs: <DM5PR11MB1849E28B382124E03FDD74D2E0080@DM5PR11MB1849.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:765;
x-forefront-prvs: 0037FD6480
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(376002)(366004)(39860400002)(346002)(136003)(199004)(189003)(229853002)(6506007)(386003)(476003)(6436002)(6512007)(31686004)(2616005)(102836004)(446003)(31696002)(53546011)(66066001)(86362001)(11346002)(71190400001)(256004)(71200400001)(26005)(486006)(4326008)(6246003)(2501003)(68736007)(6486002)(53936002)(186003)(8936002)(107886003)(36756003)(76176011)(2906002)(99286004)(5660300002)(54906003)(110136005)(81156014)(25786009)(73956011)(66946007)(52116002)(66556008)(66476007)(66446008)(64756008)(478600001)(14454004)(6116002)(81166006)(14444005)(316002)(305945005)(3846002)(72206003)(8676002)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM5PR11MB1849;H:DM5PR11MB1658.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: UKbCpzJZIEZvmXhy8nWxxlaupGkhj3Vi3POTej6fGSMz5iAxTrC4muznmFGm6fU6BEtRSNWkphSsmqgkGhFj7JK38sopQfEHIbz3RSYrMuRv0j41rD06NE2+SctA+4fJaaEri1bVkztyjEAOwxrdWApGT85/O2umUh4ZTkcBgrK2PLPI/LHufAHVoy2huKY/ii+Id1COcTxwlOIpL9Qzfhm1ZRXeQCeQAuHLpvdsc9wUUbu+C4NWNTTD1/046QGryp3f0a/XVccR/+w7lVs1cazJJ0kw6c1RpGjXBnYxIdzVknagKvipmNLOAi/VqPLeqsCr/U+rymZi13rCQJfoQ6HsjlQZNF0chH1MaiwL+79XktrLG52ZeDzNFghtCpU6YbKaeglDlQ+EH4oV/Lw80hUq/CBt7oUlELMB4Q7XexM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <398B1A0F0F35F64687BFA9C51DFFDEF4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: abdf06a0-cd3b-4820-c008-08d6d83d23b2
X-MS-Exchange-CrossTenant-originalarrivaltime: 14 May 2019 07:24:02.5307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR11MB1849
X-OriginatorOrg: microchip.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMTQvMDUvMjAxOSBhdCAwOToxNCwgTHVjYSBDZXJlc29saSB3cm90ZToNCj4gRXh0ZXJuYWwg
RS1NYWlsDQo+IA0KPiANCj4gRXJyb3JzIGFyZSBuZWdhdGl2ZSBudW1iZXJzLiBVc2luZyAldSBz
aG93cyB0aGVtIGFzIHZlcnkgbGFyZ2UgcG9zaXRpdmUNCj4gbnVtYmVycyBzdWNoIGFzIDQyOTQ5
NjcyNzcgdGhhdCBkb24ndCBtYWtlIHNlbnNlLiBVc2UgdGhlICVkIGZvcm1hdA0KPiBpbnN0ZWFk
LCBhbmQgZ2V0IGEgbXVjaCBuaWNlciAtMTkuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBMdWNhIENl
cmVzb2xpIDxsdWNhQGx1Y2FjZXJlc29saS5uZXQ+DQoNCkluZGVlZCENCkFja2VkLWJ5OiBOaWNv
bGFzIEZlcnJlIDxuaWNvbGFzLmZlcnJlQG1pY3JvY2hpcC5jb20+DQoNCj4gLS0tDQo+ICAgZHJp
dmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDE2ICsrKysrKysrLS0tLS0t
LS0NCj4gICAxIGZpbGUgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWlu
LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IGMw
NDk0MTBiYzg4OC4uYmViZDliMWFlYjY0IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nh
ZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTMzNDMsNyArMzM0Myw3IEBAIHN0YXRpYyBpbnQgbWFj
Yl9jbGtfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2LCBzdHJ1Y3QgY2xrICoqcGNs
aywNCj4gICAJCWlmICghZXJyKQ0KPiAgIAkJCWVyciA9IC1FTk9ERVY7DQo+ICAgDQo+IC0JCWRl
dl9lcnIoJnBkZXYtPmRldiwgImZhaWxlZCB0byBnZXQgbWFjYl9jbGsgKCV1KVxuIiwgZXJyKTsN
Cj4gKwkJZGV2X2VycigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIGdldCBtYWNiX2NsayAoJWQpXG4i
LCBlcnIpOw0KPiAgIAkJcmV0dXJuIGVycjsNCj4gICAJfQ0KPiAgIA0KPiBAQCAtMzM1Miw3ICsz
MzUyLDcgQEAgc3RhdGljIGludCBtYWNiX2Nsa19pbml0KHN0cnVjdCBwbGF0Zm9ybV9kZXZpY2Ug
KnBkZXYsIHN0cnVjdCBjbGsgKipwY2xrLA0KPiAgIAkJaWYgKCFlcnIpDQo+ICAgCQkJZXJyID0g
LUVOT0RFVjsNCj4gICANCj4gLQkJZGV2X2VycigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIGdldCBo
Y2xrICgldSlcbiIsIGVycik7DQo+ICsJCWRldl9lcnIoJnBkZXYtPmRldiwgImZhaWxlZCB0byBn
ZXQgaGNsayAoJWQpXG4iLCBlcnIpOw0KPiAgIAkJcmV0dXJuIGVycjsNCj4gICAJfQ0KPiAgIA0K
PiBAQCAtMzM3MCwzMSArMzM3MCwzMSBAQCBzdGF0aWMgaW50IG1hY2JfY2xrX2luaXQoc3RydWN0
IHBsYXRmb3JtX2RldmljZSAqcGRldiwgc3RydWN0IGNsayAqKnBjbGssDQo+ICAgDQo+ICAgCWVy
ciA9IGNsa19wcmVwYXJlX2VuYWJsZSgqcGNsayk7DQo+ICAgCWlmIChlcnIpIHsNCj4gLQkJZGV2
X2VycigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIGVuYWJsZSBwY2xrICgldSlcbiIsIGVycik7DQo+
ICsJCWRldl9lcnIoJnBkZXYtPmRldiwgImZhaWxlZCB0byBlbmFibGUgcGNsayAoJWQpXG4iLCBl
cnIpOw0KPiAgIAkJcmV0dXJuIGVycjsNCj4gICAJfQ0KPiAgIA0KPiAgIAllcnIgPSBjbGtfcHJl
cGFyZV9lbmFibGUoKmhjbGspOw0KPiAgIAlpZiAoZXJyKSB7DQo+IC0JCWRldl9lcnIoJnBkZXYt
PmRldiwgImZhaWxlZCB0byBlbmFibGUgaGNsayAoJXUpXG4iLCBlcnIpOw0KPiArCQlkZXZfZXJy
KCZwZGV2LT5kZXYsICJmYWlsZWQgdG8gZW5hYmxlIGhjbGsgKCVkKVxuIiwgZXJyKTsNCj4gICAJ
CWdvdG8gZXJyX2Rpc2FibGVfcGNsazsNCj4gICAJfQ0KPiAgIA0KPiAgIAllcnIgPSBjbGtfcHJl
cGFyZV9lbmFibGUoKnR4X2Nsayk7DQo+ICAgCWlmIChlcnIpIHsNCj4gLQkJZGV2X2VycigmcGRl
di0+ZGV2LCAiZmFpbGVkIHRvIGVuYWJsZSB0eF9jbGsgKCV1KVxuIiwgZXJyKTsNCj4gKwkJZGV2
X2VycigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIGVuYWJsZSB0eF9jbGsgKCVkKVxuIiwgZXJyKTsN
Cj4gICAJCWdvdG8gZXJyX2Rpc2FibGVfaGNsazsNCj4gICAJfQ0KPiAgIA0KPiAgIAllcnIgPSBj
bGtfcHJlcGFyZV9lbmFibGUoKnJ4X2Nsayk7DQo+ICAgCWlmIChlcnIpIHsNCj4gLQkJZGV2X2Vy
cigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIGVuYWJsZSByeF9jbGsgKCV1KVxuIiwgZXJyKTsNCj4g
KwkJZGV2X2VycigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIGVuYWJsZSByeF9jbGsgKCVkKVxuIiwg
ZXJyKTsNCj4gICAJCWdvdG8gZXJyX2Rpc2FibGVfdHhjbGs7DQo+ICAgCX0NCj4gICANCj4gICAJ
ZXJyID0gY2xrX3ByZXBhcmVfZW5hYmxlKCp0c3VfY2xrKTsNCj4gICAJaWYgKGVycikgew0KPiAt
CQlkZXZfZXJyKCZwZGV2LT5kZXYsICJmYWlsZWQgdG8gZW5hYmxlIHRzdV9jbGsgKCV1KVxuIiwg
ZXJyKTsNCj4gKwkJZGV2X2VycigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIGVuYWJsZSB0c3VfY2xr
ICglZClcbiIsIGVycik7DQo+ICAgCQlnb3RvIGVycl9kaXNhYmxlX3J4Y2xrOw0KPiAgIAl9DQo+
ICAgDQo+IEBAIC0zODY4LDcgKzM4NjgsNyBAQCBzdGF0aWMgaW50IGF0OTFldGhlcl9jbGtfaW5p
dChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2LCBzdHJ1Y3QgY2xrICoqcGNsaywNCj4gICAN
Cj4gICAJZXJyID0gY2xrX3ByZXBhcmVfZW5hYmxlKCpwY2xrKTsNCj4gICAJaWYgKGVycikgew0K
PiAtCQlkZXZfZXJyKCZwZGV2LT5kZXYsICJmYWlsZWQgdG8gZW5hYmxlIHBjbGsgKCV1KVxuIiwg
ZXJyKTsNCj4gKwkJZGV2X2VycigmcGRldi0+ZGV2LCAiZmFpbGVkIHRvIGVuYWJsZSBwY2xrICgl
ZClcbiIsIGVycik7DQo+ICAgCQlyZXR1cm4gZXJyOw0KPiAgIAl9DQo+ICAgDQo+IA0KDQoNCi0t
IA0KTmljb2xhcyBGZXJyZQ0K
