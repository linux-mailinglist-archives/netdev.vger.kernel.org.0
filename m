Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 722545272B
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 10:54:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730987AbfFYIym (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jun 2019 04:54:42 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:56845 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727770AbfFYIym (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 04:54:42 -0400
Received-SPF: Pass (esa1.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa1.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa1.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa1.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.63,415,1557212400"; 
   d="scan'208";a="40305589"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 25 Jun 2019 01:54:40 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.87.152) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Tue, 25 Jun 2019 01:54:35 -0700
Received: from NAM03-BY2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Tue, 25 Jun 2019 01:54:54 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=a4Lr2HZyPwSxB12nJy/uMrnDlyw3HAJqepLTt+G42P8=;
 b=UEeXgW100aalofdBapyhGSXihJUGMBVRfwf+ZszIiLxMjIYvrr9orHGEUimI+VkDPvYLReuNfhMEvTYVS2uedF/H2rQD3p8Kzxp2/4M1iweSEZyJA8wX640MxAt2YkRS39dBvolIsAJ9LOvDq4YZqYcJqoFx0XoqErKb+HeOTEE=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHPR11MB1456.namprd11.prod.outlook.com (10.172.53.138) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Tue, 25 Jun 2019 08:54:35 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3%6]) with mapi id 15.20.2008.014; Tue, 25 Jun 2019
 08:54:35 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <palmer@sifive.com>, <harinik@xilinx.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] net: macb: Kconfig: Rename Atmel to Cadence
Thread-Topic: [PATCH v2 2/2] net: macb: Kconfig: Rename Atmel to Cadence
Thread-Index: AQHVKzLeb4DIwh6l502Q1PTnA+FjCaasEMWA
Date:   Tue, 25 Jun 2019 08:54:34 +0000
Message-ID: <2f89d5ec-9017-285d-cbac-2ef56baa77fd@microchip.com>
References: <20190625084828.540-1-palmer@sifive.com>
 <20190625084828.540-3-palmer@sifive.com>
In-Reply-To: <20190625084828.540-3-palmer@sifive.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0222.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:b::18) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e63cc516-84b4-4533-7060-08d6f94abf02
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1456;
x-ms-traffictypediagnostic: MWHPR11MB1456:
x-microsoft-antispam-prvs: <MWHPR11MB1456CC80FC521573F46908AEE0E30@MWHPR11MB1456.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 0079056367
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(39860400002)(136003)(396003)(346002)(376002)(189003)(199004)(3846002)(66446008)(66556008)(99286004)(386003)(76176011)(52116002)(53546011)(6506007)(73956011)(102836004)(66476007)(64756008)(66946007)(6116002)(31696002)(110136005)(54906003)(2501003)(316002)(486006)(11346002)(2616005)(476003)(26005)(5660300002)(31686004)(186003)(446003)(229853002)(72206003)(6486002)(6436002)(478600001)(2906002)(14454004)(66066001)(71200400001)(256004)(71190400001)(8676002)(7736002)(305945005)(86362001)(81166006)(68736007)(25786009)(6246003)(4326008)(8936002)(81156014)(6512007)(53936002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1456;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: LgYIL3dQO2MprpZjlVuh4TJcRZhFvbY9wLJkT1kq/wrtepIWv393006GwuiU4dnNlCpc1rtXlFIEsmXF78kwlY0GWZOTZI5AzinrwLf/O5kS9YCVaOHLtIPJwcqR3TKUyJhOPDHAT19EAr2BRNkwmQd/hUO5avrUkUTtTinWTICxNUN9DRicuoYZPIx8vxJZeuDbG3DybcTmpB2duryGlL7bmEHSISoK7pC4QJD3sjRB/qnCvjKhjWj8jre/gFjgdyn8fteN3f5saHot5czdTfE6kYTdXa1CY2fjUYORiwr4WsLxcJl6Pi+kzV/FHBkskwbLcqstyyFQZcPO89bTzz0qGpaJPlPhruU8PQmSdCGPpZSinIcKVA2s/TmbnfHvpvlsHGOBRT+6njmySclMAeoOGNsaxVYgOTKTBeoNR8M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <384AAF53D375A146B770C63979A4D0C8@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: e63cc516-84b4-4533-7060-08d6f94abf02
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Jun 2019 08:54:34.9189
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nicolas.ferre@microchip.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1456
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjUvMDYvMjAxOSBhdCAxMDo0OCwgUGFsbWVyIERhYmJlbHQgd3JvdGU6DQo+IFRoZSBoZWxw
IHRleHQgbWFrZXMgaXQgbG9vayBsaWtlIE5FVF9WRU5ET1JfQ0FERU5DRSBlbmFibGVzIHN1cHBv
cnQgZm9yDQo+IEF0bWVsIGRldmljZXMsIHdoZW4gaW4gcmVhbGl0eSBpdCdzIGEgZHJpdmVyIHdy
aXR0ZW4gYnkgQXRtZWwgdGhhdA0KPiBzdXBwb3J0cyBDYWRlbmNlIGRldmljZXMuICBUaGlzIG1h
eSBjb25mdXNlIHVzZXJzIHRoYXQgaGF2ZSB0aGlzIGRldmljZQ0KPiBvbiBhIG5vbi1BdG1lbCBT
b0MuDQo+IA0KPiBUaGUgZml4IGlzIGp1c3Qgcy9BdG1lbC9DYWRlbmNlLywgYnV0IEkgZGlkIGdv
IGFuZCByZS13cmFwIHRoZSBLY29uZmlnDQo+IGhlbHAgdGV4dCBhcyB0aGF0IGNoYW5nZSBjYXVz
ZWQgaXQgdG8gZ28gb3ZlciA4MCBjaGFyYWN0ZXJzLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogUGFs
bWVyIERhYmJlbHQgPHBhbG1lckBzaWZpdmUuY29tPg0KDQpBY2tlZC1ieTogTmljb2xhcyBGZXJy
ZSA8bmljb2xhcy5mZXJyZUBtaWNyb2NoaXAuY29tPg0KDQo+IC0tLQ0KPiAgIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2NhZGVuY2UvS2NvbmZpZyB8IDYgKysrLS0tDQo+ICAgMSBmaWxlIGNoYW5nZWQs
IDMgaW5zZXJ0aW9ucygrKSwgMyBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL0tjb25maWcgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9j
YWRlbmNlL0tjb25maWcNCj4gaW5kZXggNjRkOGQ2ZWU3NzM5Li5mNGIzYmQ4NWRmZTMgMTAwNjQ0
DQo+IC0tLSBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvS2NvbmZpZw0KPiArKysgYi9k
cml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL0tjb25maWcNCj4gQEAgLTEsNiArMSw2IEBADQo+
ICAgIyBTUERYLUxpY2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMC1vbmx5DQo+ICAgIw0KPiAtIyBB
dG1lbCBkZXZpY2UgY29uZmlndXJhdGlvbg0KPiArIyBDYWRlbmNlIGRldmljZSBjb25maWd1cmF0
aW9uDQo+ICAgIw0KPiAgIA0KPiAgIGNvbmZpZyBORVRfVkVORE9SX0NBREVOQ0UNCj4gQEAgLTEz
LDggKzEzLDggQEAgY29uZmlnIE5FVF9WRU5ET1JfQ0FERU5DRQ0KPiAgIAkgIElmIHVuc3VyZSwg
c2F5IFkuDQo+ICAgDQo+ICAgCSAgTm90ZSB0aGF0IHRoZSBhbnN3ZXIgdG8gdGhpcyBxdWVzdGlv
biBkb2Vzbid0IGRpcmVjdGx5IGFmZmVjdCB0aGUNCj4gLQkgIGtlcm5lbDogc2F5aW5nIE4gd2ls
bCBqdXN0IGNhdXNlIHRoZSBjb25maWd1cmF0b3IgdG8gc2tpcCBhbGwNCj4gLQkgIHRoZSByZW1h
aW5pbmcgQXRtZWwgbmV0d29yayBjYXJkIHF1ZXN0aW9ucy4gSWYgeW91IHNheSBZLCB5b3Ugd2ls
bCBiZQ0KPiArCSAga2VybmVsOiBzYXlpbmcgTiB3aWxsIGp1c3QgY2F1c2UgdGhlIGNvbmZpZ3Vy
YXRvciB0byBza2lwIGFsbCB0aGUNCj4gKwkgIHJlbWFpbmluZyBDYWRlbmNlIG5ldHdvcmsgY2Fy
ZCBxdWVzdGlvbnMuIElmIHlvdSBzYXkgWSwgeW91IHdpbGwgYmUNCj4gICAJICBhc2tlZCBmb3Ig
eW91ciBzcGVjaWZpYyBjYXJkIGluIHRoZSBmb2xsb3dpbmcgcXVlc3Rpb25zLg0KPiAgIA0KPiAg
IGlmIE5FVF9WRU5ET1JfQ0FERU5DRQ0KPiANCg0KDQotLSANCk5pY29sYXMgRmVycmUNCg==
