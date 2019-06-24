Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F2865061D
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 11:49:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728575AbfFXJtV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 05:49:21 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:40080 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbfFXJtV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 05:49:21 -0400
Received-SPF: Pass (esa3.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa3.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa3.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa3.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.63,411,1557212400"; 
   d="scan'208";a="38732937"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2019 02:49:19 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex04.mchp-main.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 02:48:20 -0700
Received: from NAM02-CY1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Mon, 24 Jun 2019 02:49:17 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=C8HHa/2TRhb8sNnLAXClmCsglpdLm2WMqRTras05AIM=;
 b=Sx1zahOiEa0mZZTkbCgOZxsq8WkISVhET0R4crIqA65eW+nYPBHYfQoSUr/oqsXvvae7PfnDvESvlSm5+8U+qkiv/JdMkG6ZR1bGr7RnTKxBhRN8pY8X9Oqi7nVCXphd3v5sCGNlo7fZGZZm411+uZ5kEfk3F1ShPTGh2C519v4=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB0030.namprd11.prod.outlook.com (10.164.204.26) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 09:49:17 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 09:49:17 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <palmer@sifive.com>, <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: macb: Kconfig: Rename Atmel to Cadence
Thread-Topic: [PATCH 2/2] net: macb: Kconfig: Rename Atmel to Cadence
Thread-Index: AQHVKnIWNTWzxb1PyUmXl3jea+egkA==
Date:   Mon, 24 Jun 2019 09:49:16 +0000
Message-ID: <0c714db9-a3c1-e89b-8889-e9cdb2ac6c52@microchip.com>
References: <20190624061603.1704-1-palmer@sifive.com>
 <20190624061603.1704-3-palmer@sifive.com>
In-Reply-To: <20190624061603.1704-3-palmer@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0149.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1b::17) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: bfb11cb9-dbaf-48f6-f4f5-08d6f88938af
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB0030;
x-ms-traffictypediagnostic: MWHPR11MB0030:
x-microsoft-antispam-prvs: <MWHPR11MB0030AFCFBC17EE00BE070234E0E00@MWHPR11MB0030.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(396003)(136003)(39860400002)(376002)(366004)(189003)(199004)(31696002)(6246003)(31686004)(71200400001)(71190400001)(386003)(53546011)(229853002)(6436002)(6486002)(6512007)(8936002)(2501003)(52116002)(66066001)(5660300002)(4326008)(99286004)(86362001)(76176011)(68736007)(25786009)(316002)(186003)(7736002)(476003)(26005)(6506007)(102836004)(110136005)(36756003)(2906002)(14454004)(8676002)(54906003)(305945005)(256004)(81166006)(66946007)(6116002)(14444005)(446003)(66446008)(64756008)(66556008)(81156014)(72206003)(66476007)(3846002)(73956011)(53936002)(11346002)(2616005)(478600001)(486006);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB0030;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sGge7R8gxYf452FtFmh4YZnOTz17xr0p0m1c1AcV4AKlUOlZfjm5GuATAEsvFvbQW9BmzQc3Yc9MwEp/kwQDgq/MlVrfvcpBY0WYNNaJkFXr+/wre3cpJacJ+0LcO/ogfR2iNiBQp/BbOga8BF3flnyTZwJX//BHkq5J+OsWDuVRbLXXEh4GQlJ3tPAY87XPA/DPhg+mJhf3B8NC0Kxw+dDR/2flslu+9AybdEPKJsyBY/urShPmdIdbCCe+Yjgf/Qx9VVCfEoSMu2HQbb50I8z+k4bC0/vGlAs8O86M0T2vSHQKZbm+PkEi5DkhNxp/2TcM2dLXp+QVpirOhJu4uMrgeBHzgbgFwJpFw/tj1KzsOhb2P3g0wZQJukP9fvUjyIl5d9u4eOqoY/Ss2smYM+hpiiqJENhYVohcFemFv3g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <4D8181CA2F84B6408EDD924C3BA214C4@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: bfb11cb9-dbaf-48f6-f4f5-08d6f88938af
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 09:49:16.8610
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nicolas.ferre@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB0030
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQvMDYvMjAxOSBhdCAwODoxNiwgUGFsbWVyIERhYmJlbHQgd3JvdGU6DQo+IEV4dGVybmFs
IEUtTWFpbA0KPiANCj4gDQo+IFdoZW4gdG91Y2hpbmcgdGhlIEtjb25maWcgZm9yIHRoaXMgZHJp
dmVyIEkgbm90aWNlZCB0aGF0IGJvdGggdGhlDQo+IEtjb25maWcgaGVscCB0ZXh0IGFuZCBhIGNv
bW1lbnQgcmVmZXJyZWQgdG8gdGhpcyBiZWluZyBhbiBBdG1lbCBkcml2ZXIuDQo+IEFzIGZhciBh
cyBJIGtub3csIHRoaXMgaXMgYSBDYWRlbmNlIGRyaXZlci4gIFRoZSBmaXggaXMganVzdA0KDQpJ
bmRlZWQ6IHdhcyB3cml0dGVuIGFuZCB0aGVuIG1haW50YWluZWQgYnkgQXRtZWwgKG5vdyBNaWNy
b2NoaXApIGZvciANCnllYXJzLi4uIFNvIEkgd291bGQgc2F5IHRoYXQgbW9yZSB0aGFuIGEgIkNh
ZGVuY2UgZHJpdmVyIiBpdCdzIGEgZHJpdmVyIA0KdGhhdCBhcHBsaWVzIHRvIGEgQ2FkZW5jZSBw
ZXJpcGhlcmFsLg0KDQpJIHdvbid0IGhvbGQgdGhlIHBhdGNoIGp1c3QgZm9yIHRoaXMgYXMgdGhl
IHBhdGNoIG1ha2VzIHBlcmZlY3Qgc2Vuc2UsIA0KYnV0IHdvdWxkIGxvdmUgdGhhdCBpdCdzIGJl
ZW4gaGlnaGxpZ2h0ZWQuLi4NCg0KPiBzL0F0bWVsL0NhZGVuY2UvLCBidXQgSSBkaWQgZ28gYW5k
IHJlLXdyYXAgdGhlIEtjb25maWcgaGVscCB0ZXh0IGFzIHRoYXQNCj4gY2hhbmdlIGNhdXNlZCBp
dCB0byBnbyBvdmVyIDgwIGNoYXJhY3RlcnMuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBQYWxtZXIg
RGFiYmVsdCA8cGFsbWVyQHNpZml2ZS5jb20+DQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0L2V0aGVy
bmV0L2NhZGVuY2UvS2NvbmZpZyB8IDYgKysrLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQsIDMgaW5z
ZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25l
dC9ldGhlcm5ldC9jYWRlbmNlL0tjb25maWcgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNl
L0tjb25maWcNCj4gaW5kZXggNzRlZTJiZmQyMzY5Li4yOWI2MTMyYjQxOGUgMTAwNjQ0DQo+IC0t
LSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvS2NvbmZpZw0KPiArKysgYi9kcml2ZXJz
L25ldC9ldGhlcm5ldC9jYWRlbmNlL0tjb25maWcNCj4gQEAgLTEsNiArMSw2IEBADQo+ICAgIyBT
UERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5DQo+ICAgIw0KPiAtIyBBdG1lbCBk
ZXZpY2UgY29uZmlndXJhdGlvbg0KPiArIyBDYWRlbmNlIGRldmljZSBjb25maWd1cmF0aW9uDQo+
ICAgIw0KPiAgIA0KPiAgIGNvbmZpZyBORVRfVkVORE9SX0NBREVOQ0UNCj4gQEAgLTEzLDggKzEz
LDggQEAgY29uZmlnIE5FVF9WRU5ET1JfQ0FERU5DRQ0KPiAgIAkgIElmIHVuc3VyZSwgc2F5IFku
DQo+ICAgDQo+ICAgCSAgTm90ZSB0aGF0IHRoZSBhbnN3ZXIgdG8gdGhpcyBxdWVzdGlvbiBkb2Vz
bid0IGRpcmVjdGx5IGFmZmVjdCB0aGUNCj4gLQkgIGtlcm5lbDogc2F5aW5nIE4gd2lsbCBqdXN0
IGNhdXNlIHRoZSBjb25maWd1cmF0b3IgdG8gc2tpcCBhbGwNCj4gLQkgIHRoZSByZW1haW5pbmcg
QXRtZWwgbmV0d29yayBjYXJkIHF1ZXN0aW9ucy4gSWYgeW91IHNheSBZLCB5b3Ugd2lsbCBiZQ0K
PiArCSAga2VybmVsOiBzYXlpbmcgTiB3aWxsIGp1c3QgY2F1c2UgdGhlIGNvbmZpZ3VyYXRvciB0
byBza2lwIGFsbCB0aGUNCj4gKwkgIHJlbWFpbmluZyBDYWRlbmNlIG5ldHdvcmsgY2FyZCBxdWVz
dGlvbnMuIElmIHlvdSBzYXkgWSwgeW91IHdpbGwgYmUNCj4gICAJICBhc2tlZCBmb3IgeW91ciBz
cGVjaWZpYyBjYXJkIGluIHRoZSBmb2xsb3dpbmcgcXVlc3Rpb25zLg0KPiAgIA0KPiAgIGlmIE5F
VF9WRU5ET1JfQ0FERU5DRQ0KPiANCg0KDQotLSANCk5pY29sYXMgRmVycmUNCg==
