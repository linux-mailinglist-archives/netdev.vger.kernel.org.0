Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8762A510DE
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:42:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731270AbfFXPm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:42:28 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:10082 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730057AbfFXPm2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:42:28 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="38135313"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2019 08:42:24 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex01.mchp-main.com (10.10.87.71) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 08:42:23 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 08:41:25 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cy7clChqZqllOByJ8bTJpZf7py4lFWj3o7vA5bp45m0=;
 b=ZOnTmHaIOqqofjNUaPmVt5dJ364/SPxqz6n0Yq0O7H/mY/+AAYuojlv+K/a8zEMiK5w9JZBqOtgiiV8it9d5RGl5KOS0lTv80yW7Jrsq7n8EE+DO7AjqxiTEsbo1MBPBEydrlopGCElOMVnFzqaGf0hjczkooCTDem6VvvcbRI8=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHSPR00MB242.namprd11.prod.outlook.com (10.169.207.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 15:42:22 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 15:42:22 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <palmer@sifive.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] net: macb: Kconfig: Rename Atmel to Cadence
Thread-Topic: [PATCH 2/2] net: macb: Kconfig: Rename Atmel to Cadence
Thread-Index: AQHVKqNpwG0Ep9s7ZE+pDmRh0wbU7Q==
Date:   Mon, 24 Jun 2019 15:42:21 +0000
Message-ID: <a2065e81-432f-fc9b-df24-8abe655b45ef@microchip.com>
References: <mhng-87f5f418-acd4-4a29-b82e-6dc574a4828a@palmer-si-x1e>
In-Reply-To: <mhng-87f5f418-acd4-4a29-b82e-6dc574a4828a@palmer-si-x1e>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0337.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:d::13) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7724c8bc-dcf8-4ad3-d007-08d6f8ba8c00
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHSPR00MB242;
x-ms-traffictypediagnostic: MWHSPR00MB242:
x-microsoft-antispam-prvs: <MWHSPR00MB242DD455F205F5CCCC0B499E0E00@MWHSPR00MB242.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(376002)(346002)(39860400002)(396003)(189003)(199004)(486006)(316002)(54906003)(386003)(31696002)(66066001)(5660300002)(53546011)(6916009)(229853002)(102836004)(86362001)(186003)(6506007)(6246003)(8676002)(7736002)(256004)(14444005)(71200400001)(71190400001)(305945005)(81166006)(81156014)(8936002)(6116002)(6512007)(476003)(52116002)(6486002)(36756003)(6436002)(26005)(68736007)(478600001)(99286004)(4326008)(64756008)(11346002)(446003)(66446008)(2616005)(14454004)(25786009)(66946007)(76176011)(66476007)(66556008)(73956011)(2906002)(53936002)(3846002)(31686004)(72206003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHSPR00MB242;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: P12GUgHb9VNKL95ttoRJu3zv/xEewbrB7GgFWMw9JEQuYh8snaxxmsTacqKrDfNZ7G0y+ntANhoL5k+03w5qpIsClAsHsvYL2mUv9utMPTpbMLGcafd+DubllArb+2eGJ48KKRucczW2XY5CVfU8MtZr9NDZDUfw6vbGJLQH1u/Tb0bUAcxTExbV+VYmQcCFFZVoBYQ3ZRSftiSSZ+C6E+pcHMZ15bXVOrYpsWqfW2rPo8FnwqGNFxmuHMYlQ95AhQPJRFjTnVki5YxNch8OIj0Xrqu42VEyfLwEGZFbHhBAtxG51VxXrDY2xD/8QK/dyXc3ZpWJyJb5CpW2Q66FUiiFsZAoafGMoVv0HvUhAMFQSDjZl/6mOpBSwGGpNhoMzm4dINQFP2dLseVz4PJ7TE9bKlrsr1WWGNNQZshz5zM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACF124971A10B34C9267609799D85DE7@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 7724c8bc-dcf8-4ad3-d007-08d6f8ba8c00
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 15:42:21.9305
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nicolas.ferre@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHSPR00MB242
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQvMDYvMjAxOSBhdCAxMTo1NywgUGFsbWVyIERhYmJlbHQgd3JvdGU6DQo+IEV4dGVybmFs
IEUtTWFpbA0KPiANCj4gDQo+IE9uIE1vbiwgMjQgSnVuIDIwMTkgMDI6NDk6MTYgUERUICgtMDcw
MCksIE5pY29sYXMuRmVycmVAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4+IE9uIDI0LzA2LzIwMTkg
YXQgMDg6MTYsIFBhbG1lciBEYWJiZWx0IHdyb3RlOg0KPj4+IEV4dGVybmFsIEUtTWFpbA0KPj4+
DQo+Pj4NCj4+PiBXaGVuIHRvdWNoaW5nIHRoZSBLY29uZmlnIGZvciB0aGlzIGRyaXZlciBJIG5v
dGljZWQgdGhhdCBib3RoIHRoZQ0KPj4+IEtjb25maWcgaGVscCB0ZXh0IGFuZCBhIGNvbW1lbnQg
cmVmZXJyZWQgdG8gdGhpcyBiZWluZyBhbiBBdG1lbCBkcml2ZXIuDQo+Pj4gQXMgZmFyIGFzIEkg
a25vdywgdGhpcyBpcyBhIENhZGVuY2UgZHJpdmVyLiAgVGhlIGZpeCBpcyBqdXN0DQo+Pg0KPj4g
SW5kZWVkOiB3YXMgd3JpdHRlbiBhbmQgdGhlbiBtYWludGFpbmVkIGJ5IEF0bWVsIChub3cgTWlj
cm9jaGlwKSBmb3INCj4+IHllYXJzLi4uIFNvIEkgd291bGQgc2F5IHRoYXQgbW9yZSB0aGFuIGEg
IkNhZGVuY2UgZHJpdmVyIiBpdCdzIGEgZHJpdmVyDQo+PiB0aGF0IGFwcGxpZXMgdG8gYSBDYWRl
bmNlIHBlcmlwaGVyYWwuDQo+Pg0KPj4gSSB3b24ndCBob2xkIHRoZSBwYXRjaCBqdXN0IGZvciB0
aGlzIGFzIHRoZSBwYXRjaCBtYWtlcyBwZXJmZWN0IHNlbnNlLA0KPj4gYnV0IHdvdWxkIGxvdmUg
dGhhdCBpdCdzIGJlZW4gaGlnaGxpZ2h0ZWQuLi4NCj4gDQo+IE9LLCBJIGRvbid0IG1pbmQgY2hh
bmdpbmcgaXQuICBEb2VzIHRoaXMgbG9vayBPSz8gIEkgaGF2ZSB0byBzdWJtaXQgYSB2MiBhbnl3
YXkNCj4gZm9yIHRoZSBmaXJzdCBwYXRjaC4NCg0KWWVwLCBuaWNlIQ0KDQpUaGFua3MsDQogICBO
aWNvbGFzDQoNCj4gDQo+IEF1dGhvcjogUGFsbWVyIERhYmJlbHQgPHBhbG1lckBzaWZpdmUuY29t
Pg0KPiBEYXRlOiAgIFN1biBKdW4gMjMgMjM6MDQ6MTQgMjAxOSAtMDcwMA0KPiANCj4gICAgICBu
ZXQ6IG1hY2I6IEtjb25maWc6IFJlbmFtZSBBdG1lbCB0byBDYWRlbmNlDQo+IA0KPiAgICAgIFRo
ZSBoZWxwIHRleHQgbWFrZXMgaXQgbG9vayBsaWtlIE5FVF9WRU5ET1JfQ0FERU5DRSBlbmFibGVz
IHN1cHBvcnQgZm9yDQo+ICAgICAgQXRtZWwgZGV2aWNlcywgd2hlbiBpbiByZWFsaXR5IGl0J3Mg
YSBkcml2ZXIgd3JpdHRlbiBieSBBdG1lbCB0aGF0DQo+ICAgICAgc3VwcG9ydHMgQ2FkZW5jZSBk
ZXZpY2VzLiAgVGhpcyBtYXkgY29uZnVzZSB1c2VycyB0aGF0IGhhdmUgdGhpcyBkZXZpY2UNCj4g
ICAgICBvbiBhIG5vbi1BdG1lbCBTb0MuDQo+IA0KPiAgICAgIFRoZSBmaXggaXMganVzdCBzL0F0
bWVsL0NhZGVuY2UvLCBidXQgSSBkaWQgZ28gYW5kIHJlLXdyYXAgdGhlIEtjb25maWcNCj4gICAg
ICBoZWxwIHRleHQgYXMgdGhhdCBjaGFuZ2UgY2F1c2VkIGl0IHRvIGdvIG92ZXIgODAgY2hhcmFj
dGVycy4NCj4gDQo+ICAgICAgU2lnbmVkLW9mZi1ieTogUGFsbWVyIERhYmJlbHQgPHBhbG1lckBz
aWZpdmUuY29tPg0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVu
Y2UvS2NvbmZpZyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvS2NvbmZpZw0KPiBpbmRl
eCA3NGVlMmJmZDIzNjkuLjI5YjYxMzJiNDE4ZSAxMDA2NDQNCj4gLS0tIGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2FkZW5jZS9LY29uZmlnDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nh
ZGVuY2UvS2NvbmZpZw0KPiBAQCAtMSw2ICsxLDYgQEANCj4gICAjIFNQRFgtTGljZW5zZS1JZGVu
dGlmaWVyOiBHUEwtMi4wLW9ubHkNCj4gICAjDQo+IC0jIEF0bWVsIGRldmljZSBjb25maWd1cmF0
aW9uDQo+ICsjIENhZGVuY2UgZGV2aWNlIGNvbmZpZ3VyYXRpb24NCj4gICAjDQo+IA0KPiAgIGNv
bmZpZyBORVRfVkVORE9SX0NBREVOQ0UNCj4gQEAgLTEzLDggKzEzLDggQEAgY29uZmlnIE5FVF9W
RU5ET1JfQ0FERU5DRQ0KPiAgICAgICAgICAgIElmIHVuc3VyZSwgc2F5IFkuDQo+IA0KPiAgICAg
ICAgICAgIE5vdGUgdGhhdCB0aGUgYW5zd2VyIHRvIHRoaXMgcXVlc3Rpb24gZG9lc24ndCBkaXJl
Y3RseSBhZmZlY3QgdGhlDQo+IC0gICAgICAgICBrZXJuZWw6IHNheWluZyBOIHdpbGwganVzdCBj
YXVzZSB0aGUgY29uZmlndXJhdG9yIHRvIHNraXAgYWxsDQo+IC0gICAgICAgICB0aGUgcmVtYWlu
aW5nIEF0bWVsIG5ldHdvcmsgY2FyZCBxdWVzdGlvbnMuIElmIHlvdSBzYXkgWSwgeW91IHdpbGwg
YmUNCj4gKyAgICAgICAgIGtlcm5lbDogc2F5aW5nIE4gd2lsbCBqdXN0IGNhdXNlIHRoZSBjb25m
aWd1cmF0b3IgdG8gc2tpcCBhbGwgdGhlDQo+ICsgICAgICAgICByZW1haW5pbmcgQ2FkZW5jZSBu
ZXR3b3JrIGNhcmQgcXVlc3Rpb25zLiBJZiB5b3Ugc2F5IFksIHlvdSB3aWxsIGJlDQo+ICAgICAg
ICAgICAgYXNrZWQgZm9yIHlvdXIgc3BlY2lmaWMgY2FyZCBpbiB0aGUgZm9sbG93aW5nIHF1ZXN0
aW9ucy4NCj4gDQo+ICAgaWYgTkVUX1ZFTkRPUl9DQURFTkNFDQo+IA0KPj4NCj4+PiBzL0F0bWVs
L0NhZGVuY2UvLCBidXQgSSBkaWQgZ28gYW5kIHJlLXdyYXAgdGhlIEtjb25maWcgaGVscCB0ZXh0
IGFzIHRoYXQNCj4+PiBjaGFuZ2UgY2F1c2VkIGl0IHRvIGdvIG92ZXIgODAgY2hhcmFjdGVycy4N
Cj4+Pg0KPj4+IFNpZ25lZC1vZmYtYnk6IFBhbG1lciBEYWJiZWx0IDxwYWxtZXJAc2lmaXZlLmNv
bT4NCj4+PiAtLS0NCj4+PiAgICBkcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL0tjb25maWcg
fCA2ICsrKy0tLQ0KPj4+ICAgIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVs
ZXRpb25zKC0pDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2Fk
ZW5jZS9LY29uZmlnIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9LY29uZmlnDQo+Pj4g
aW5kZXggNzRlZTJiZmQyMzY5Li4yOWI2MTMyYjQxOGUgMTAwNjQ0DQo+Pj4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9LY29uZmlnDQo+Pj4gKysrIGIvZHJpdmVycy9uZXQvZXRo
ZXJuZXQvY2FkZW5jZS9LY29uZmlnDQo+Pj4gQEAgLTEsNiArMSw2IEBADQo+Pj4gICAgIyBTUERY
LUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5DQo+Pj4gICAgIw0KPj4+IC0jIEF0bWVs
IGRldmljZSBjb25maWd1cmF0aW9uDQo+Pj4gKyMgQ2FkZW5jZSBkZXZpY2UgY29uZmlndXJhdGlv
bg0KPj4+ICAgICMNCj4+PiAgICANCj4+PiAgICBjb25maWcgTkVUX1ZFTkRPUl9DQURFTkNFDQo+
Pj4gQEAgLTEzLDggKzEzLDggQEAgY29uZmlnIE5FVF9WRU5ET1JfQ0FERU5DRQ0KPj4+ICAgIAkg
IElmIHVuc3VyZSwgc2F5IFkuDQo+Pj4gICAgDQo+Pj4gICAgCSAgTm90ZSB0aGF0IHRoZSBhbnN3
ZXIgdG8gdGhpcyBxdWVzdGlvbiBkb2Vzbid0IGRpcmVjdGx5IGFmZmVjdCB0aGUNCj4+PiAtCSAg
a2VybmVsOiBzYXlpbmcgTiB3aWxsIGp1c3QgY2F1c2UgdGhlIGNvbmZpZ3VyYXRvciB0byBza2lw
IGFsbA0KPj4+IC0JICB0aGUgcmVtYWluaW5nIEF0bWVsIG5ldHdvcmsgY2FyZCBxdWVzdGlvbnMu
IElmIHlvdSBzYXkgWSwgeW91IHdpbGwgYmUNCj4+PiArCSAga2VybmVsOiBzYXlpbmcgTiB3aWxs
IGp1c3QgY2F1c2UgdGhlIGNvbmZpZ3VyYXRvciB0byBza2lwIGFsbCB0aGUNCj4+PiArCSAgcmVt
YWluaW5nIENhZGVuY2UgbmV0d29yayBjYXJkIHF1ZXN0aW9ucy4gSWYgeW91IHNheSBZLCB5b3Ug
d2lsbCBiZQ0KPj4+ICAgIAkgIGFza2VkIGZvciB5b3VyIHNwZWNpZmljIGNhcmQgaW4gdGhlIGZv
bGxvd2luZyBxdWVzdGlvbnMuDQo+Pj4gICAgDQo+Pj4gICAgaWYgTkVUX1ZFTkRPUl9DQURFTkNF
DQo+Pj4NCj4+DQo+Pg0KPj4gLS0gDQo+PiBOaWNvbGFzIEZlcnJlDQoNCg0KLS0gDQpOaWNvbGFz
IEZlcnJlDQo=
