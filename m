Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012EA22B92E
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 00:09:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgGWWI5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 18:08:57 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:62594 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726173AbgGWWI4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 18:08:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595542137; x=1627078137;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=yXHnu6gTvmNIXIQWtB7t+9sAxDzQ1uzE9BKVE+FJ4oA=;
  b=TtJSkL5YkqxFjh10IsUI+mTGWfZarDIi4GYwhnXgiztT0qYLo7Sn/sPn
   akgKCYfNKyBjG9E4+so+VktX5UM8NupOHh1EeLAhEB8HYlQJexk4rPdSJ
   TppI5rNoLRZEczizraKjR9g5h5UPzZtvgkGh4re/azEG/d4umihAA+cNh
   qGVOmHAARu7+k6pM0LlRBBEx3qyhHG2QRz9Ig/DJGwkp92sdWLLakmA+c
   /GND4X554kzNxi8HuJologhhfcOgJIcNky9d8W7yjqHftQ+Eav7TDUUv1
   pQAanCM0539pTJnU/Hbm2fsr+WoA6jhVYF/+4U3r5jAmCuYMbqIDrMcnL
   Q==;
IronPort-SDR: TOEGqNsJG8QJfzDzTQ0eMEkmcSZV6paiP8HFO2rS80Q2dfbF/IxxAQ0BtvPUtTCqdEIiMepI1U
 +MoBF46e/evXsKEDnKd8Erw6/roZexfCG8GWaGDikpeei05v7j18epT917vzeErFG30RpkSEaQ
 fSLWfH94Fj7VUV7Va7gS59PlKweIcZqfEgUNLppHbgCWCoRuTP920hgJzVv/mpXg1XCkItynwh
 89RbJcbrEZXENQ31Zuf0BUsHqohL3kKk6FPfcz1rbJde4w0GD2JhsNFLQcdnW/+jzJXWSmOdUl
 7kQ=
X-IronPort-AV: E=Sophos;i="5.75,388,1589266800"; 
   d="scan'208";a="84409853"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Jul 2020 15:08:56 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 23 Jul 2020 15:08:15 -0700
Received: from NAM11-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3 via Frontend
 Transport; Thu, 23 Jul 2020 15:08:15 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iA2Fn7GVQO6JWns+uerQl28AH8mElhGh9VMGqslS/eZ0SzK+zABVppZNc7xbt+3AsoQVoyaGpoyaaz81tpO0DzO4jTdB5uaOHnDWL7pOWIPOR9pE1uS2aabGwC86cX9+v0ujbnT/pRTzqhZ/z7RnDCQtNSHpKqEYybuOlAmExaz+JNy2Z7Aq2nEoLp/23P+ogBRwqe+WCKH8dDEKDHiOrAGsbWWpO9t2NvHqRrTgDXnaHfcR/7A/20MuyHQ7ugN6QdB1aRUVBCJ1WtH4zoVIg/LrlnvIxghCuVMkZZ2YTc+JOLakLBX3TL+88GbRDoKWRsGJ+HlI3ar2Y+uCUaWIPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXHnu6gTvmNIXIQWtB7t+9sAxDzQ1uzE9BKVE+FJ4oA=;
 b=VH4R08WQcGpawzZ9bcff8wlQVKTpBK48UK9kY9l6I9yXU5Jwwz6fw0Sqct044TjnJijnCgfmLP9gUJk34cnsOWuYOmK6StDOtXGn9m5wbbt+96mrsNDp0XWUl69x+Aamd3DkJ1gxpj8Rc/bmNQt6QzPHBXxn69SiVgvqiDV14qexy95GZlTcfIKzM1EzGmj28LepAtHY2WwShiEXerurQBzzXPWckiHB1VnbpuwPbGqa4pROYmaa5hSkB9uI+VQtjyBxdMSNmZpQ5xmnkaP7YN9GM7VRMDQDoRtW/HxycXouP4wQYco0E3Ytc6by//im4z/LYdyNDVP/GTzPWUN9yw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yXHnu6gTvmNIXIQWtB7t+9sAxDzQ1uzE9BKVE+FJ4oA=;
 b=Bj8cadf6yLB5WJwMzgkY7ttgucgslx4Tj7rey7Zxqfue5m23f/tDDXLzJK1SYXIZ68REHtUbBlM3OgJKGjJ7QLe+IzTkwPKOW0AE9mou9ZS7aQX0SirQRjh0wOM5mO7xycYIDKxJLgsPqoxzhUKebiHVrCEFsaNnAMN7w28py9A=
Received: from SN6PR11MB3504.namprd11.prod.outlook.com (2603:10b6:805:d0::17)
 by SA0PR11MB4672.namprd11.prod.outlook.com (2603:10b6:806:96::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3216.24; Thu, 23 Jul
 2020 22:08:51 +0000
Received: from SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0]) by SN6PR11MB3504.namprd11.prod.outlook.com
 ([fe80::851c:67fc:a034:9ea0%4]) with mapi id 15.20.3216.022; Thu, 23 Jul 2020
 22:08:51 +0000
From:   <Codrin.Ciubotariu@microchip.com>
To:     <f.fainelli@gmail.com>, <netdev@vger.kernel.org>,
        <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
CC:     <Nicolas.Ferre@microchip.com>, <Claudiu.Beznea@microchip.com>,
        <davem@davemloft.net>, <kuba@kernel.org>, <andrew@lunn.ch>,
        <robh+dt@kernel.org>, <alexandre.belloni@bootlin.com>,
        <Ludovic.Desroches@microchip.com>
Subject: Re: [PATCH net-next v2 3/7] net: macb: parse PHY nodes found under an
 MDIO node
Thread-Topic: [PATCH net-next v2 3/7] net: macb: parse PHY nodes found under
 an MDIO node
Thread-Index: AQHWX4MOpDLDucI5kUq6RMoIO+hGv6kVh78AgAA06wA=
Date:   Thu, 23 Jul 2020 22:08:51 +0000
Message-ID: <1ba55a2a-487a-dbd5-29e6-5d4231e80167@microchip.com>
References: <20200721171316.1427582-1-codrin.ciubotariu@microchip.com>
 <20200721171316.1427582-4-codrin.ciubotariu@microchip.com>
 <460e5f3d-f3a0-154e-d617-d1536c96e390@gmail.com>
In-Reply-To: <460e5f3d-f3a0-154e-d617-d1536c96e390@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
authentication-results: gmail.com; dkim=none (message not signed)
 header.d=none;gmail.com; dmarc=none action=none header.from=microchip.com;
x-originating-ip: [84.232.220.208]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 383a2c63-637f-49a9-6ec3-08d82f54fba0
x-ms-traffictypediagnostic: SA0PR11MB4672:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA0PR11MB4672E8A39E817C8715CAF6ACE7760@SA0PR11MB4672.namprd11.prod.outlook.com>
x-bypassexternaltag: True
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: nKQC3NAyH55CYFgmmplwcJLJGlhXtfybd/7+iCoA2imcxoJnWZcRlF2XM+cegwbV486lIGdaGkxer8QQ3+3gevAlZnxRxNZmuKgojHafSQE0UhZRAOW9Fzs22oqT/w0q9ROOlpa5Bofu6T4v9B766J3yngrIqVSwdPBTBr7/36iq0SB07YQ6YbopazmLUPV3iTEnm7y9Evi+DxfdWF2AVkY+Jyp8dEmeDDC9evu9V0dJ+TyEgdix7REdtiIzrUNLSjLeBlKPfNKP8BZ41RG3W/BHJvH64JfitF7G4w3nXZS3yKiCYJmFdbzO8FsWwoekMMRdHhn//uBB+i6d03SP9nyAJ+xPF+JNDzvjrEeYmzDV1/yIYs33c9wo20xEt55E
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR11MB3504.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(39860400002)(136003)(376002)(346002)(396003)(366004)(6486002)(186003)(107886003)(26005)(8676002)(8936002)(86362001)(36756003)(64756008)(7416002)(2906002)(66446008)(316002)(478600001)(66476007)(66556008)(110136005)(66946007)(31696002)(6512007)(76116006)(91956017)(31686004)(6506007)(53546011)(2616005)(54906003)(5660300002)(4326008)(71200400001)(43740500002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 3IL7XJ4XujXgIVk7J7hYIR9uJNb9tn/eQnaJ9uMVb8Q2tD41vuTpL41QllSlHVmQhZwzN6Fy+afmnAQuVAh4xZjVzwRGb4L0LNSIoi5JnU4w9JUswAGYS1DqkReWsccfJ9JjOospwDwzNcFRJbt3S6vYJQgKHW2rdmgPQu3eqj4ixfEiFs7gbmfSQ89V1s4/5RnGmnPuuJYVcIsEn2C1TJDlEb74Sh1TucbmQf115OmuEscr9Gk0G3MqJeIam1bRETBAH50limoRCXzNcn8h8cL7f1Gu9zHP77j8jpj38eHCqNvxXarzd6CtPiEj0DDL7L7yaY4ZATROGKi+Q7k6uRvlw5Ih1DVSbuKSGBP1MyDDwqYTqPXaIaMD94rTrEKC9C224aTB4trC22SFNa9RJiOdxwSLN8H+ZmMWVcxUeHvA8+Glcs9osfYwlWgb1KSl4Clgojt92G8+t9SyotVMU6IlpIeC3yeQArHk6W84V7fBLmXTg6UlD3GAC5ugoyDa
Content-Type: text/plain; charset="utf-8"
Content-ID: <11926891E0FCFA4D80A77C57D1AFF233@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR11MB3504.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 383a2c63-637f-49a9-6ec3-08d82f54fba0
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Jul 2020 22:08:51.7239
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: MA6d7Wg9R2Rh73oNuoGrSdPd5VVr9PHVCcD968hjk4Z8vlB3dyh3fxgo0VcKvNXNo+mZbWZX3ilzGiFbIb85/PY3yimibkYyGrSCdvSqakQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA0PR11MB4672
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjMuMDcuMjAyMCAyMTo1OSwgRmxvcmlhbiBGYWluZWxsaSB3cm90ZToNCj4gRVhURVJOQUwg
RU1BSUw6IERvIG5vdCBjbGljayBsaW5rcyBvciBvcGVuIGF0dGFjaG1lbnRzIHVubGVzcyB5b3Ug
a25vdyB0aGUgY29udGVudCBpcyBzYWZlDQo+IA0KPiBPbiA3LzIxLzIwIDEwOjEzIEFNLCBDb2Ry
aW4gQ2l1Ym90YXJpdSB3cm90ZToNCj4+IFRoZSBNQUNCIGVtYmVkcyBhbiBNRElPIGJ1cyBjb250
cm9sbGVyLiBGb3IgdGhpcyByZWFzb24sIHRoZSBQSFkgbm9kZXMNCj4+IHdlcmUgcmVwcmVzZW50
ZWQgYXMgc3ViLW5vZGVzIGluIHRoZSBNQUNCIG5vZGUuIEdlbmVyYWxseSwgdGhlDQo+PiBFdGhl
cm5ldCBjb250cm9sbGVyIGlzIGRpZmZlcmVudCB0aGFuIHRoZSBNRElPIGNvbnRyb2xsZXIsIHNv
IHRoZSBQSFlzDQo+PiBhcmUgcHJvYmVkIGJ5IGEgc2VwYXJhdGUgTURJTyBkcml2ZXIuIFNpbmNl
IGFkZGluZyB0aGUgUEhZIG5vZGVzIGRpcmVjdGx5DQo+PiB1bmRlciB0aGUgRVRIIG5vZGUgYmVj
YW1lIGRlcHJlY2F0ZWQsIHdlIGFkanVzdCB0aGUgTUFDQiBkcml2ZXIgdG8gbG9vaw0KPj4gZm9y
IGFuIE1ESU8gbm9kZSBhbmQgcmVnaXN0ZXIgdGhlIHN1Ym5vZGUgTURJTyBkZXZpY2VzLg0KPj4N
Cj4+IFNpZ25lZC1vZmYtYnk6IENvZHJpbiBDaXVib3Rhcml1IDxjb2RyaW4uY2l1Ym90YXJpdUBt
aWNyb2NoaXAuY29tPg0KPj4gLS0tDQo+Pg0KPj4gQ2hhbmdlcyBpbiB2MjoNCj4+ICAgLSByZWFk
ZGVkIG5ld2xpbmUgcmVtb3ZlZCBieSBtaXN0YWtlOw0KPj4NCj4+ICAgZHJpdmVycy9uZXQvZXRo
ZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyB8IDEwICsrKysrKysrKysNCj4+ICAgMSBmaWxlIGNo
YW5nZWQsIDEwIGluc2VydGlvbnMoKykNCj4+DQo+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQv
ZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVu
Y2UvbWFjYl9tYWluLmMNCj4+IGluZGV4IDg5ZmU3YWY1ZTQwOC4uYjI1YzY0YjQ1MTQ4IDEwMDY0
NA0KPj4gLS0tIGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPj4g
KysrIGIvZHJpdmVycy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPj4gQEAgLTc0
MCwxMCArNzQwLDIwIEBAIHN0YXRpYyBpbnQgbWFjYl9taWlfcHJvYmUoc3RydWN0IG5ldF9kZXZp
Y2UgKmRldikNCj4+ICAgc3RhdGljIGludCBtYWNiX21kaW9idXNfcmVnaXN0ZXIoc3RydWN0IG1h
Y2IgKmJwKQ0KPj4gICB7DQo+PiAgICAgICAgc3RydWN0IGRldmljZV9ub2RlICpjaGlsZCwgKm5w
ID0gYnAtPnBkZXYtPmRldi5vZl9ub2RlOw0KPj4gKyAgICAgc3RydWN0IGRldmljZV9ub2RlICpt
ZGlvX25vZGU7DQo+PiArICAgICBpbnQgcmV0Ow0KPj4NCj4+ICAgICAgICBpZiAob2ZfcGh5X2lz
X2ZpeGVkX2xpbmsobnApKQ0KPj4gICAgICAgICAgICAgICAgcmV0dXJuIG1kaW9idXNfcmVnaXN0
ZXIoYnAtPm1paV9idXMpOw0KPiANCj4gRG9lcyBub3QgdGhpcyBuZWVkIGNoYW5naW5nIGFzIHdl
bGw/IENvbnNpZGVyIHRoZSB1c2UgY2FzZSBvZiBoYXZpbmcNCj4geW91ciBNQUNCIEV0aGVybmV0
IG5vZGUgaGF2ZSBhIGZpeGVkLWxpbmsgcHJvcGVydHkgdG8gZGVzY3JpYmUgaG93IGl0DQo+IGNv
bm5lY3RzIHRvIGEgc3dpdGNoLCBhbmQgeW91ciBNQUNCIE1ESU8gY29udHJvbGxlciwgZXhwcmVz
c2VkIGFzIGENCj4gc3ViLW5vZGUsIGRlc2NyaWJpbmcgdGhlIE1ESU8gYXR0YWNoZWQgc3dpdGNo
IGl0IGNvbm5lY3RzIHRvLg0KDQpSaWdodCwgdGhpcyBpcyB3aGF0IEkgd2FzIGRpc2N1c3Npbmcg
d2l0aCBDbGF1ZGl1IG9uIHRoZSBvdGhlciB0aHJlYWQuIEkgDQphbSB0aGlua2luZyB0byBqdXN0
IG1vdmUgdGhlIGxvb2sgZm9yIG1kaW8gYmVmb3JlIGNoZWNraW5nIGZvciANCmZpeGVkLWxpbmsu
IFRoaXMgd2lsbCBwcm9iZSB0aGUgTURJTyBkZXZpY2VzIGFuZCBzaW1wbGUgbWRpb2J1c19yZWdp
c3RlciANCndpbGwgYmUgY2FsbGVkIG9ubHkgaWYgdGhlIG1kaW8gbm9kZSBpcyBtaXNzaW5nLg0K
DQpUaGFuayB5b3UgZm9yIHlvdXIgcmV2aWV3KHMpIQ0KDQpCZXN0IHJlZ2FyZHMsDQpDb2RyaW4N
Cg0KPiANCj4+DQo+PiArICAgICAvKiBpZiBhbiBNRElPIG5vZGUgaXMgcHJlc2VudCwgaXQgc2hv
dWxkIGNvbnRhaW4gdGhlIFBIWSBub2RlcyAqLw0KPj4gKyAgICAgbWRpb19ub2RlID0gb2ZfZ2V0
X2NoaWxkX2J5X25hbWUobnAsICJtZGlvIik7DQo+PiArICAgICBpZiAobWRpb19ub2RlKSB7DQo+
PiArICAgICAgICAgICAgIHJldCA9IG9mX21kaW9idXNfcmVnaXN0ZXIoYnAtPm1paV9idXMsIG1k
aW9fbm9kZSk7DQo+PiArICAgICAgICAgICAgIG9mX25vZGVfcHV0KG1kaW9fbm9kZSk7DQo+PiAr
ICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+PiArICAgICB9DQo+PiArDQo+PiAgICAgICAgLyog
T25seSBjcmVhdGUgdGhlIFBIWSBmcm9tIHRoZSBkZXZpY2UgdHJlZSBpZiBhdCBsZWFzdCBvbmUg
UEhZIGlzDQo+PiAgICAgICAgICogZGVzY3JpYmVkLiBPdGhlcndpc2Ugc2NhbiB0aGUgZW50aXJl
IE1ESU8gYnVzLiBXZSBkbyB0aGlzIHRvIHN1cHBvcnQNCj4+ICAgICAgICAgKiBvbGQgZGV2aWNl
IHRyZWUgdGhhdCBkaWQgbm90IGZvbGxvdyB0aGUgYmVzdCBwcmFjdGljZXMgYW5kIGRpZCBub3QN
Cj4+DQo+IA0KPiANCj4gLS0NCj4gRmxvcmlhbg0KPiANCg0K
