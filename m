Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1478D136C59
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 12:53:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727909AbgAJLxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 06:53:34 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:55515 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727717AbgAJLxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 06:53:33 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: tzrr7ZcayS3Gn5j1xBIHmVUFTGZDwfpvGP9JwCXe9Ps/Smvp3ZyzeUuCBclqU92n8KZc68adRV
 /bdtzKuRbKx69LpuFKFkSkPO+JzxNyafsUjQYTS+jIG7ZwHu+EGnEheTswQCHDEdTwqh5Sod64
 U+eimPelfl3TOwR2lE/pLFzMKNnaTsLoQD3v7mVEOoBZ1j69Htze5+sdZxp4WmNJ6ZIVCQYQtD
 lRWkYPIj1wgeY52WSD7odW3uN5WOx/F9W8AT0m5qg/1exoYVC3xZbDeFiTbcrxp7f53EJRmS6F
 +wI=
X-IronPort-AV: E=Sophos;i="5.69,416,1571727600"; 
   d="scan'208";a="61482871"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Jan 2020 04:53:28 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 10 Jan 2020 04:53:27 -0700
Received: from NAM10-DM6-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Fri, 10 Jan 2020 04:53:27 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Wj91K5Ch06FkKfDZ2fSF4lpIB2+CtzCBMeN4dvNMAvRhMRylnPNHsnkz3y8tNQo7+pIS6SlTYvzD1KJmCMbmGlnZ6+BwcSCplFaOoitToMblDHjMRUfLmhWJWUjuSGPConUPU6kyP0xXAQdEci6CShMn5iJJPDyIoK0TkVIszMvubeFc8wAh3s3PiSDdPO4/m9bjrVtjEa7LpTSIGS89ZI2jFqOvIHHhaCWEkpXtneiou58f15fU+0FjqEEm9/IGHGobj0UZV8XXDPlwrkl1bAvPI8bzXMPjp1zCA8MIINPC0GeAGQZRW2fRwuWlTMQOs+5fNZOWCkmc7a1Yy5b/TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1f0+YPt9B8JllmK2AlCr0uK4QGNADdVwFcwPUVoHjUA=;
 b=Hhy38wpSoIXFqWFHLrr3/qgc+8h51LmZM1eJf2IpSA7ERxyo8TcUgH/9Aw0LnRPJ/pu4YIEtT9N9GCanT0JaVRkvM3cLO/JrjbjF/2irOCGaQRmxLcVSqujij2LVWKqKxZbvWEZXCVFgD5wHgsXzva4HQxOTO9tNv1V+WEem4waCg0eOL7bATszDVb0NF/id1+2n4pHfoluG0K75xzmeDpy9xUIM6IJl6wQ99S52cMP6GliwlmpWKgPIBSMfe+RMp9N0DbRU9h6wZaOHBNHYrnZv7UInuDQM84lJshu9z1ptUHVryu90lhTlS2Du/dmtxdnfBF3ih+qElbXuQQdgVw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1f0+YPt9B8JllmK2AlCr0uK4QGNADdVwFcwPUVoHjUA=;
 b=mqOEWNOdX8cD1A8wjADUF7r94Y8kLI9bbcjthucERgYXpOw0g+X0ewkYlzudk+M9rz8JdUoIasQMdS4QvxeXf86HsXUc/8cgaQr1FwpGrvve6kgqpaBSsAyEMclDAik9lpl1o3GXpHtxAyR6whFyrZJiC9+eQxw7DF9Mpdct8Hw=
Received: from DM6PR11MB3225.namprd11.prod.outlook.com (20.176.120.224) by
 DM6PR11MB4427.namprd11.prod.outlook.com (52.132.249.148) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.8; Fri, 10 Jan 2020 11:53:24 +0000
Received: from DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::106f:424f:ac54:1dbb]) by DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::106f:424f:ac54:1dbb%7]) with mapi id 15.20.2623.008; Fri, 10 Jan 2020
 11:53:24 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <mparab@cadence.com>, <Nicolas.Ferre@microchip.com>,
        <jakub.kicinski@netronome.com>, <andrew@lunn.ch>,
        <antoine.tenart@bootlin.com>, <rmk+kernel@armlinux.org.uk>
CC:     <f.fainelli@gmail.com>, <davem@davemloft.net>,
        <netdev@vger.kernel.org>, <hkallweit1@gmail.com>,
        <linux-kernel@vger.kernel.org>, <dkangude@cadence.com>,
        <a.fatoum@pengutronix.de>, <brad.mouring@ni.com>,
        <pthombar@cadence.com>
Subject: Re: [PATCH net] net: macb: fix for fixed-link mode
Thread-Topic: [PATCH net] net: macb: fix for fixed-link mode
Thread-Index: AQHVx6yQuHKU8HZdIEGV/21BAySXqQ==
Date:   Fri, 10 Jan 2020 11:53:24 +0000
Message-ID: <91a5684d-9170-fdf6-3cd1-ae0636f3727b@microchip.com>
References: <1578635183-30482-1-git-send-email-mparab@cadence.com>
In-Reply-To: <1578635183-30482-1-git-send-email-mparab@cadence.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 25b71596-5048-458e-b903-08d795c3b2b0
x-ms-traffictypediagnostic: DM6PR11MB4427:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB44275100B6F1EAD0540EEB5087380@DM6PR11MB4427.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 02788FF38E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(376002)(366004)(396003)(346002)(136003)(199004)(189003)(66946007)(66556008)(7416002)(5660300002)(31696002)(36756003)(4326008)(6512007)(71200400001)(31686004)(81166006)(66476007)(81156014)(76116006)(6506007)(53546011)(2906002)(64756008)(8676002)(91956017)(86362001)(6486002)(478600001)(2616005)(110136005)(66446008)(54906003)(186003)(316002)(26005)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB4427;H:DM6PR11MB3225.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xvgIqA3S4CT/m7yfYFlhFtG4BbWn1EProIEWhT1kBekv7IgJ3Pas8Tu2gzvU00Rn+UTdnd6b8KoFseGQYVTZPmBSmS7HNxH6a8U17oCy6jFhytGwaDHSbNexcAfBt2bNGXPVBOoyalbIagrUt1KQ+RVIquH7tqdfkPpCx5ZAvwOXFKn3PLvHXSEKQPNxeiSfy1PeEvSk/yZmn7TrNBRmGbGrXCrXvNmd0pfo1eaurPDtnc3TTljn0ctx3uZg9oR0lQUwApCVydvu95HrbTGtYVPbOgyJlhE8kXN9Urv3bHWZzQS55+95OnRxu6tKvFs6GXIEJVPvPcDzuJiJ7AV1vmbYa9tRdfFfgJaQzp1sy6WS7QjaSH5vV7HFZRk1aNRkP3dGuPGgEAcvRQEEZItTGGPtFvtQAvEIIUH1C84V7KLqemlxPB9iMjAGPaKXf/wK
Content-Type: text/plain; charset="utf-8"
Content-ID: <34620BF7CDB77B488CD27212D16E8D37@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 25b71596-5048-458e-b903-08d795c3b2b0
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Jan 2020 11:53:24.4172
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Zp5z0qKWx46d3zle/Hiwp5LekH6ZHXAC5cnGXMJdZBMXl38RhbAIUXF30pqUvhiLumGcyLJijmOm+h7Deabx8l40BBaolYDZtQxPTD7PwZc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4427
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDEwLjAxLjIwMjAgMDc6NDYsIE1pbGluZCBQYXJhYiB3cm90ZToNCj4gVGhpcyBwYXRj
aCBmaXggdGhlIGlzc3VlIHdpdGggZml4ZWQgbGluay4gV2l0aCBmaXhlZC1saW5rDQo+IGRldmlj
ZSBvcGVuaW5nIGZhaWxzIGR1ZSB0byBtYWNiX3BoeWxpbmtfY29ubmVjdCBub3QNCj4gaGFuZGxp
bmcgZml4ZWQtbGluayBtb2RlLCBpbiB3aGljaCBjYXNlIG5vIE1BQy1QSFkgY29ubmVjdGlvbg0K
PiBpcyBuZWVkZWQgYW5kIHBoeWxpbmtfY29ubmVjdCByZXR1cm4gc3VjY2VzcyAoMCksIGhvd2V2
ZXINCj4gaW4gY3VycmVudCBkcml2ZXIgYXR0ZW1wdCBpcyBtYWRlIHRvIHNlYXJjaCBhbmQgY29u
bmVjdCB0bw0KPiBQSFkgZXZlbiBmb3IgZml4ZWQtbGluay4NCj4gDQo+IEZpeGVzOiA3ODk3YjA3
MWFjM2IgKCJuZXQ6IG1hY2I6IGNvbnZlcnQgdG8gcGh5bGluayIpDQo+IFNpZ25lZC1vZmYtYnk6
IE1pbGluZCBQYXJhYiA8bXBhcmFiQGNhZGVuY2UuY29tPg0KPiAtLS0NCj4gIGRyaXZlcnMvbmV0
L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWluLmMgfCAyNCArKysrKysrKysrKysrKystLS0tLS0t
LS0NCj4gIDEgZmlsZSBjaGFuZ2VkLCAxNSBpbnNlcnRpb25zKCspLCA5IGRlbGV0aW9ucygtKQ0K
PiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFjYl9tYWlu
LmMgYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IGluZGV4IGM1
ZWUzNjNjYTVkYy4uNDFjNDg1NDg1NjE5IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhl
cm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+ICsrKyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2Nh
ZGVuY2UvbWFjYl9tYWluLmMNCj4gQEAgLTYxMSwyMSArNjExLDI0IEBAIHN0YXRpYyBjb25zdCBz
dHJ1Y3QgcGh5bGlua19tYWNfb3BzIG1hY2JfcGh5bGlua19vcHMgPSB7DQo+ICAgICAgICAgLm1h
Y19saW5rX3VwID0gbWFjYl9tYWNfbGlua191cCwNCj4gIH07DQo+IA0KPiArc3RhdGljIGJvb2wg
bWFjYl9waHlfaGFuZGxlX2V4aXN0cyhzdHJ1Y3QgZGV2aWNlX25vZGUgKmRuKQ0KPiArew0KPiAr
ICAgICAgIGRuID0gb2ZfcGFyc2VfcGhhbmRsZShkbiwgInBoeS1oYW5kbGUiLCAwKTsNCj4gKyAg
ICAgICBvZl9ub2RlX3B1dChkbik7DQo+ICsgICAgICAgcmV0dXJuIGRuICE9IE5VTEw7DQo+ICt9
DQo+ICsNCj4gIHN0YXRpYyBpbnQgbWFjYl9waHlsaW5rX2Nvbm5lY3Qoc3RydWN0IG1hY2IgKmJw
KQ0KPiAgew0KPiAgICAgICAgIHN0cnVjdCBuZXRfZGV2aWNlICpkZXYgPSBicC0+ZGV2Ow0KPiAg
ICAgICAgIHN0cnVjdCBwaHlfZGV2aWNlICpwaHlkZXY7DQo+ICsgICAgICAgc3RydWN0IGRldmlj
ZV9ub2RlICpkbiA9IGJwLT5wZGV2LT5kZXYub2Zfbm9kZTsNCj4gICAgICAgICBpbnQgcmV0Ow0K
PiANCj4gLSAgICAgICBpZiAoYnAtPnBkZXYtPmRldi5vZl9ub2RlICYmDQo+IC0gICAgICAgICAg
IG9mX3BhcnNlX3BoYW5kbGUoYnAtPnBkZXYtPmRldi5vZl9ub2RlLCAicGh5LWhhbmRsZSIsIDAp
KSB7DQo+IC0gICAgICAgICAgICAgICByZXQgPSBwaHlsaW5rX29mX3BoeV9jb25uZWN0KGJwLT5w
aHlsaW5rLCBicC0+cGRldi0+ZGV2Lm9mX25vZGUsDQo+IC0gICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgIDApOw0KPiAtICAgICAgICAgICAgICAgaWYgKHJldCkgew0K
PiAtICAgICAgICAgICAgICAgICAgICAgICBuZXRkZXZfZXJyKGRldiwgIkNvdWxkIG5vdCBhdHRh
Y2ggUEhZICglZClcbiIsIHJldCk7DQo+IC0gICAgICAgICAgICAgICAgICAgICAgIHJldHVybiBy
ZXQ7DQo+IC0gICAgICAgICAgICAgICB9DQo+IC0gICAgICAgfSBlbHNlIHsNCj4gKyAgICAgICBp
ZiAoZG4pDQo+ICsgICAgICAgICAgICAgICByZXQgPSBwaHlsaW5rX29mX3BoeV9jb25uZWN0KGJw
LT5waHlsaW5rLCBkbiwgMCk7DQo+ICsNCj4gKyAgICAgICBpZiAoIWRuIHx8IChyZXQgJiYgIW1h
Y2JfcGh5X2hhbmRsZV9leGlzdHMoZG4pKSkgew0KPiAgICAgICAgICAgICAgICAgcGh5ZGV2ID0g
cGh5X2ZpbmRfZmlyc3QoYnAtPm1paV9idXMpOw0KPiAgICAgICAgICAgICAgICAgaWYgKCFwaHlk
ZXYpIHsNCj4gICAgICAgICAgICAgICAgICAgICAgICAgbmV0ZGV2X2VycihkZXYsICJubyBQSFkg
Zm91bmRcbiIpOw0KPiBAQCAtNjM4LDYgKzY0MSw5IEBAIHN0YXRpYyBpbnQgbWFjYl9waHlsaW5r
X2Nvbm5lY3Qoc3RydWN0IG1hY2IgKmJwKQ0KPiAgICAgICAgICAgICAgICAgICAgICAgICBuZXRk
ZXZfZXJyKGRldiwgIkNvdWxkIG5vdCBhdHRhY2ggdG8gUEhZICglZClcbiIsIHJldCk7DQo+ICAg
ICAgICAgICAgICAgICAgICAgICAgIHJldHVybiByZXQ7DQo+ICAgICAgICAgICAgICAgICB9DQo+
ICsgICAgICAgfSBlbHNlIGlmIChyZXQpIHsNCj4gKyAgICAgICAgICAgICAgIG5ldGRldl9lcnIo
ZGV2LCAiQ291bGQgbm90IGF0dGFjaCBQSFkgKCVkKVxuIiwgcmV0KTsNCj4gKyAgICAgICAgICAg
ICAgIHJldHVybiByZXQ7DQo+ICAgICAgICAgfQ0KDQpZb3UgY2FuIHJlbW92ZSB0aGlzICJlbHNl
IGlmIChyZXQpIiBicmFuY2ggYW5kIGFsc286DQoJaWYgKHJldCkgew0KICAgICAgICAgICAgICAg
bmV0ZGV2X2VycihkZXYsICJDb3VsZCBub3QgYXR0YWNoIFBIWSAoJWQpXG4iLCByZXQpOw0KICAg
ICAgICAgICAgICAgcmV0dXJuIHJldDsNCgl9DQoNCnVuZGVyICJpZiAoIWRuIHx8IChyZXQgJiYg
IW1hY2JfcGh5X2hhbmRsZV9leGlzdHMoZG4pKSkiIGFuZCBoYXZlIHNvbWV0aGluZw0KbGlrZToN
Cg0Kc3RhdGljIGludCBtYWNiX3BoeWxpbmtfY29ubmVjdChzdHJ1Y3QgbWFjYiAqYnApDQp7DQoJ
c3RydWN0IG5ldF9kZXZpY2UgKmRldiA9IGJwLT5kZXY7DQoJc3RydWN0IHBoeV9kZXZpY2UgKnBo
eWRldjsNCglzdHJ1Y3QgZGV2aWNlX25vZGUgKmRuID0gYnAtPnBkZXYtPmRldi5vZl9ub2RlOw0K
CWludCByZXQ7DQoNCglpZiAoZG4pDQoJCXJldCA9IHBoeWxpbmtfb2ZfcGh5X2Nvbm5lY3QoYnAt
PnBoeWxpbmssIGRuLCAwKTsNCg0KCWlmICghZG4gfHwgKHJldCAmJiAhbWFjYl9waHlfaGFuZGxl
X2V4aXN0cyhkbikpKSB7DQoJCXBoeWRldiA9IHBoeV9maW5kX2ZpcnN0KGJwLT5taWlfYnVzKTsN
CgkJaWYgKCFwaHlkZXYpIHsNCgkJCW5ldGRldl9lcnIoZGV2LCAibm8gUEhZIGZvdW5kXG4iKTsN
CgkJCXJldHVybiAtRU5YSU87DQoJCX0NCg0KCQkvKiBhdHRhY2ggdGhlIG1hYyB0byB0aGUgcGh5
ICovDQoJCXJldCA9IHBoeWxpbmtfY29ubmVjdF9waHkoYnAtPnBoeWxpbmssIHBoeWRldik7DQoJ
fQ0KDQoJaWYgKHJldCkgew0KCQluZXRkZXZfZXJyKGRldiwgIkNvdWxkIG5vdCBhdHRhY2ggUEhZ
ICglZClcbiIsIHJldCk7DQoJCXJldHVybiByZXQ7DQoJfQ0KDQoJcGh5bGlua19zdGFydChicC0+
cGh5bGluayk7DQoNCglyZXR1cm4gMDsNCn0NCg0KPiANCj4gICAgICAgICBwaHlsaW5rX3N0YXJ0
KGJwLT5waHlsaW5rKTsNCj4gLS0NCj4gMi4xNy4xDQo+IA0KPiA=
