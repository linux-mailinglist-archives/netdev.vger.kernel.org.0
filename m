Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E346133F51
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 11:32:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727781AbgAHKcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 05:32:07 -0500
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:24539 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726751AbgAHKcH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 05:32:07 -0500
Received-SPF: Pass (esa5.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa5.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa5.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa5.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: 1sQMxfbxTI3rpvhkWFlXyq6q3aeFPTRGTmeYBudpcCcG7DhCDCV+3Rwevjj8CPgQtQRrkXIxQ4
 jUGKbqEqDEZagXGEdXdCw6GiMi3GK76Xk3kKE8g1+fU4gho74ABPzPJT8kZJS17DjpoJkI3BJu
 VpuS5Q9DO4c7YZZvWRc3KGimHWSILUoXZ6VIjze9wAxhAf3KZpbQ8bv/UsjDdI3ZW42pZku0/q
 nlE9jkTE4IhbDUUFAJCUf2749ulUuQB2SvS1gpcO9XG9kAyYEav0uTIBspu9LbyqIcmP64sSbG
 Z4o=
X-IronPort-AV: E=Sophos;i="5.69,409,1571727600"; 
   d="scan'208";a="61216849"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jan 2020 03:32:06 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 8 Jan 2020 03:32:04 -0700
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Wed, 8 Jan 2020 03:32:04 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=juQ+pxH0KhPAm2LBIUhuF/ReEkFPVMSDIJ9xlc/q7DGAZX5IXabzbsHiA/x0jSDxPWLnWdAxrd+mrLA+8/lXvmHC7SCiBXbREprlnVQJWxySLJyChy54a9DeI7nKkr2bZhYA780r245P1J/Fe7GcZWf6fsxfPNBaUoZ8yd6QaZ38s/c9DpdFCRrednfKHaDrdnwsPpRfK0GHPAVL1ptp7gS28GDM25Up7tTJqH0W/KdzfHsQvbiNvcA9E+ccfuR+zZ8vWyQtcgoMW9Qi8WuHuQYJduUrrE/x2XQdLoErzXBRQeXf8O/iJIsciIcl9edVSbUZxFR+c+MLze3WpqOhKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1HSrwjwBJLKF498NA0eoBK97xsuu1s0IdW/AL1BVl8=;
 b=OqFyIZVOha3he+tfkO2PrYoXWrpM9dYxmQtDnR3TraYamp5xPKpR3CjqoQeZT0uEJ+kFc+4PzatCFYg/JBpOA80NVCU26c4X2tC3OcVblk8nSz+ni4BBYcGZIHBWfvaQkoszoI7XMfIynIs3ZiXa02chiwE8k2lY9NCgcgPk5qX/6bM62C57jsWPhAgzghxgwSVEoD3YTO3MV2rOhCh7G18WCodmwYosgqn9LpRTZFjknXN5OmGvjuAfYoMJs+xFtUQQQPSjIZSlyaiqdMfDQ5smcWmZ9yNLctFpmNBo2foCoPp+acX7lT/sHnz8udC8qgDiGTijPhu1QItaCvAheQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t1HSrwjwBJLKF498NA0eoBK97xsuu1s0IdW/AL1BVl8=;
 b=GmeGN9flgY+hrCQljfqdGL3pBt2EkuLa71+3Ix6LbA41KYKcEPUnVByqJihNSXfh39xeWYOkb7+hrpDMTkvDvCBnGt2V3UgSFJDWUMpRnEUrtm4G0pJ0CDKMbc/n8Htw7P7kA/vIEuVAcaOJse4SgkafMGbmKh9JQnXCIq8sSyE=
Received: from SN6PR11MB2830.namprd11.prod.outlook.com (52.135.91.21) by
 SN6PR11MB3101.namprd11.prod.outlook.com (52.135.127.23) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2602.12; Wed, 8 Jan 2020 10:32:03 +0000
Received: from SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::9439:53a6:d896:d176]) by SN6PR11MB2830.namprd11.prod.outlook.com
 ([fe80::9439:53a6:d896:d176%7]) with mapi id 15.20.2623.008; Wed, 8 Jan 2020
 10:32:03 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <linux@armlinux.org.uk>, <mparab@cadence.com>
CC:     <antoine.tenart@bootlin.com>, <dkangude@cadence.com>,
        <hkallweit1@gmail.com>, <andrew@lunn.ch>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <Claudiu.Beznea@microchip.com>,
        <netdev@vger.kernel.org>, <f.fainelli@gmail.com>,
        <a.fatoum@pengutronix.de>, <brad.mouring@ni.com>,
        <pthombar@cadence.com>
Subject: Re: [PATCH v2 3/3] net: macb: add support for high speed interface
Thread-Topic: [PATCH v2 3/3] net: macb: add support for high speed interface
Thread-Index: AQHVsZm5l82MVXLf60OyobQPmImAGae7UQaAgAACAgCAAWMWwIAACq4AgAe4FfCAHEGlAA==
Date:   Wed, 8 Jan 2020 10:32:03 +0000
Message-ID: <7aa36539595f52cbe5b5b084e1add6359149724e.camel@microchip.com>
References: <1576230007-11181-1-git-send-email-mparab@cadence.com>
         <1576230177-11404-1-git-send-email-mparab@cadence.com>
         <20191215151249.GA25745@shell.armlinux.org.uk>
         <20191215152000.GW1344@shell.armlinux.org.uk>
         <BY5PR07MB65143D385836FF49966F5F6AD3510@BY5PR07MB6514.namprd07.prod.outlook.com>
         <20191216130908.GI25745@shell.armlinux.org.uk>
         <BY5PR07MB6514F3B5E2A1B910218F7EFBD32C0@BY5PR07MB6514.namprd07.prod.outlook.com>
In-Reply-To: <BY5PR07MB6514F3B5E2A1B910218F7EFBD32C0@BY5PR07MB6514.namprd07.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [2a01:cb1c:a97:7600:749e:ccc3:b323:7b02]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3037f0b0-e0e2-42aa-365f-08d7942600cf
x-ms-traffictypediagnostic: SN6PR11MB3101:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR11MB3101713B9C384F2CDCAF547EE03E0@SN6PR11MB3101.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 02760F0D1C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(396003)(376002)(136003)(39860400002)(346002)(199004)(189003)(6506007)(2616005)(2906002)(7416002)(66446008)(6486002)(186003)(66556008)(66946007)(76116006)(64756008)(66476007)(6512007)(81156014)(5660300002)(91956017)(4326008)(54906003)(478600001)(110136005)(66574012)(316002)(86362001)(81166006)(71200400001)(36756003)(8936002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:SN6PR11MB3101;H:SN6PR11MB2830.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: vtZ/VKPHDShqG2JWyLkfyZqZtQsik+qKVazUY+AhxkbrWpfFxo+8FKnfcocEhCEP8EdKlmA/7madcwl0lWIzED4c8aT6quiHsEQQx84yV9evkYW0KHF1xKrXaDpfcLDLvC9G3FPBptWe63pO0C9c7gGT0AnPM9I056kgjrucKwXiMcTI1cFrmqI2PbhKLk75yWbltNzHwGlbuOEqDsWObVTw18QSCoTn9p/V6kBshTNy9BPfCHqRV0BbcOroZxvuGBtNGdcmJsMkI1Kt9yPJ+n6rcOnJ3aGBlsScD7qbZ6FPgcO+9GgR75JHA/A80B5P03dsuvKIxSzrW1096DViOQooaQi4ZUvsgj7ZN4HFknxZPEh7D08QkZj16HkDBLKtmPEVBhKfOo9jRTyFmel7hCJtRbnWD0i9T1TVk7SfsteMhWov0FHZQpk1tZ9e9hTM
Content-Type: text/plain; charset="utf-8"
Content-ID: <083662BC94BD55418D71E2D987A2DD0D@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 3037f0b0-e0e2-42aa-365f-08d7942600cf
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jan 2020 10:32:03.7763
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: S87Xe+gAQNUIemwPUgcNagw6BhfbY53rY7crFHVFkKvl65VnrMKwK+VlKRY/Nj4FKlasJUpiojethwzfw62vvUWXrA2ihWG8W4M3pYRIMgg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR11MB3101
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

TGUgc2FtZWRpIDIxIGTDqWNlbWJyZSAyMDE5IMOgIDExOjA4ICswMDAwLCBNaWxpbmQgUGFyYWIg
YSDDqWNyaXQgOg0KPiA+ID4gQWRkaXRpb25hbCAzcmQgcGFydHkgSTJDIElQIHJlcXVpcmVkIChu
b3QgcGFydCBvZiBHRU0pIGZvciBtb2R1bGUNCj4gPiA+IGludGVycm9nYXRpb24gKE1ESU8gdG8g
STJDIGhhbmRsZWQgYnkgU1cNCj4gPiA+ICArLS0tLS0tLS0tLS0tLS0rICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICstLS0tLS0tLS0tLSsNCj4gPiA+ICB8ICAgICAgICAgICAgICB8
ICAgICAgIHwgICAgICAgIHwgICAgICAgICAgICAgICAgIHwgIFNGUCsgICAgIHwNCj4gPiA+ICB8
IEdFTSBNQUMvRE1BICB8IDwtLS0+IHwgU2VyRGVzIHwgPC0tLS0gU0ZJLS0tLS0+IHwgT3B0aWNh
bCAgIHwNCj4gPiA+ICB8ICAgVVNYIFBDU3wgICB8ICAgICAgIHwgKFBNQSkgIHwgICAgICAgICAg
ICAgICAgIHwgTW9kdWxlICAgIHwNCj4gPiA+ICArLS0tLS0tLS0tLS0tLS0rICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICstLS0tLS0tLS0tLSsNCj4gPiA+ICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIF4NCj4gPiA+ICAgICAg
ICAgKy0tLS0tLS0tKyAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwNCj4g
PiA+ICAgICAgICAgfCBJMkMgICAgfCAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwNCj4gPiA+ICAgICAgICAgfCBNYXN0ZXIgfCA8LS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0t
LS0tLS0tLS0tLS0tLXwNCj4gPiA+ICAgICAgICAgKy0tLS0tLS0tKw0KPiA+IFRoZSBrZXJuZWwg
c3VwcG9ydHMgdGhpcyB0aHJvdWdoIHRoZSBzZnAgYW5kIHBoeWxpbmsgc3VwcG9ydC4gU0ZJIGlz
DQo+ID4gbW9yZSBjb21tb25seSBrbm93biBhcyAxMEdCQVNFLVIuIE5vdGUgdGhhdCB0aGlzIGlz
ICpub3QqIFVTWEdNSUkuDQo+ID4gTGluayBzdGF0dXMgbmVlZHMgdG8gY29tZSBmcm9tIHRoZSBN
QUMgc2lkZSwgc28gbWFjYl9tYWNfcGNzX2dldF9zdGF0ZSgpDQo+ID4gaXMgcmVxdWlyZWQuDQo+
ID4gDQo+ID4gPiBSYXRlIGRldGVybWluZWQgYnkgMTBHQkFTRS1UIFBIWSBjYXBhYmlsaXR5IHRo
cm91Z2ggYXV0by1uZWdvdGlhdGlvbi4NCj4gPiA+IEkyQyBJUCByZXF1aXJlZA0KPiA+ID4gICst
LS0tLS0tLS0tLS0tLSsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKy0tLS0tLS0t
LS0tKw0KPiA+ID4gIHwgICAgICAgICAgICAgIHwgICAgICAgfCAgICAgICAgfCAgICAgICAgICAg
ICAgICAgfCAgU0ZQKyB0byAgfA0KPiA+ID4gIHwgR0VNIE1BQy9ETUEgIHwgPC0tLT4gfCBTZXJE
ZXMgfCA8LS0tLSBTRkktLS0tLT4gfCAxMEdCQVNFLVQgfA0KPiA+ID4gIHwgICBVU1ggUENTfCAg
IHwgICAgICAgfCAoUE1BKSAgfCAgICAgICAgICAgICAgICAgfCAgICAgICAgICAgfA0KPiA+ID4g
ICstLS0tLS0tLS0tLS0tLSsgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgKy0tLS0t
LS0tLS0tKw0KPiA+ID4gICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgXg0KPiA+ID4gICAgICAgICArLS0tLS0tLS0rICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+ID4gICAgICAgICB8IEkyQyAgICB8ICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgfA0KPiA+ID4gICAgICAgICB8IE1hc3Rl
ciB8IDwtLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tfA0KPiA+ID4gICAgICAg
ICArLS0tLS0tLS0rDQo+ID4gDQo+ID4gVGhlIDEwRyBjb3BwZXIgbW9kdWxlIEkgaGF2ZSB1c2Vz
IDEwR0JBU0UtUiwgNTAwMEJBU0UtWCwgMjUwMEJBU0UtWCwNCj4gPiBhbmQgU0dNSUkgKHdpdGhv
dXQgaW4tYmFuZCBzdGF0dXMpLCBkeW5hbWljYWxseSBzd2l0Y2hpbmcgYmV0d2Vlbg0KPiA+IHRo
ZXNlIGRlcGVuZGluZyBvbiB0aGUgcmVzdWx0cyBvZiB0aGUgY29wcGVyIHNpZGUgbmVnb3RpYXRp
b24uDQo+ID4gDQo+ID4gPiBVU1hHTUlJIFBIWS4gVXNlcyBNRElPIG9yIGVxdWl2YWxlbnQgZm9y
IHN0YXR1cyB4ZmVyDQo+ID4gPiAgKy0tLS0tLS0tLS0tLS0rICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgKy0tLS0tLS0tKw0KPiA+ID4gIHwgICAgICAgICAgICAgfCAgICAgICB8
ICAgICAgICB8ICAgICAgICAgICAgICAgICAgIHwgICAgICAgIHwNCj4gPiA+ICB8IEdFTSBNQUMv
RE1BIHwgPC0tLT4gfCBTZXJEZXMgfCA8LS0tIFVTWEdNSUkgLS0tPiB8ICBQSFkgICB8DQo+ID4g
PiAgfCAgVVNYIFBDUyAgICB8ICAgICAgIHwgKFBNQSkgIHwgICAgICAgICAgICAgICAgICAgfCAg
ICAgICAgfA0KPiA+ID4gICstLS0tLS0tLS0tLS0tKyAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICstLS0tLS0tLSsNCj4gPiA+ICAgICAgICBeICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAgICAgIF4NCj4gPiA+ICAgICAgICB8X19fX19fX19fX19f
X19fX19fX19fIE1ESU8gX19fX19fX19fX19fX19fX19fX19fX3wNCj4gPiANCj4gPiBPdmVyYWxs
LCBwbGVhc2UgaW1wbGVtZW50IHBoeWxpbmsgcHJvcGVybHkgZm9yIHlvdXIgTUFDLCByYXRoZXIg
dGhhbg0KPiA+IHRoZSBjdXJyZW50IGhhbGYtaGVhcnRlZCBhcHByb2FjaCB0aGF0ICp3aWxsKiBi
cmVhayBpbiB2YXJpb3VzDQo+ID4gY2lyY3Vtc3RhbmNlcy4NCj4gPiANCj4gDQo+IFdlIHdvdWxk
IG5lZWQgbW9yZSB0aW1lIHRvIGdldCBiYWNrIG9uIHRoZSByZXN0cnVjdHVyZWQgaW1wbGVtZW50
YXRpb24uDQo+IFdoaWxlIHdlIHdvcmsgb24gdGhhdCwgaXMgaXQgb2theSB0byBhY2NlcHQgcGF0
Y2ggMS8zIGFuZCBwYXRjaCAyLzM/DQoNCk1pbGluZCwNCg0KSSdtIG5vdCBhZ2FpbnN0IHF1ZXVp
bmcgcGF0Y2hlcyAxICYgMiBvZiB0aGlzIHNlcmllcyB3aGlsZSB0aGUgM3JkIG9uZSBpcw0Kc3Rp
bGwgaW4gcmV2aWV3Lg0KDQpIb3dldmVyLCBJIHdvdWxkIHByZWZlciB0aGF0IHlvdSBmb2xsb3ct
dXAgSmFrdWIgS2ljaW5za2kncyBhZHZpY2Ugd2hlbiBoZQ0KYW5zd2VyZWQgdG8geW91ciB2MiBz
ZXJyaWVzLg0KDQpTbyBwbGVhc2UsIHJlLXNlbmQgdGhlIHBhdGNoZXMgMSBhcyBhICJmaXgiIHR5
cGUgb2YgcGF0Y2gsIG1ha2luZyBzdXJlIHRoYXQgaXQNCnN0aWxsIGFwcGxpZXMgYWZ0ZXIgbGF0
ZXN0IEFudG9pbmUncyBjaGFuZ2VzLiBUaGVuLCByZS1zZW5kIHRoZSAyLzMgcGF0Y2ggb2YNCnRo
ZSBzZXJpZXMgYXMgYSB2MyBjb2xsZWN0aW5nIHJldmlld3MgKGFzIEkgZGlkbid0IHJlY2VpdmVk
IHYyKS4NCg0KV2hlbiB0aGUgZmlyc3QgMiBhcmUgcXVldWVkIGJ5IERhdmlkLCB3ZSBjYW4gcmVz
dW1lIHRoZSBkaXNjdXNzaW9uIGFib3V0IHlvdXINCjNyZCBwYXRjaCBhbmQgd2hhdCBJIGNhbiB0
ZWxsIHlvdSBhYm91dCB0aGlzIHRvcGljIGlzIHRoYXQgaXQncyByZWFsbHkgYnkNCmZvbGxvd2lu
ZyBSdXNzZWxsIGNvbW1lbnRzIGFuZCBhZHZpY2UgdGhhdCB3ZSB3aWxsIG1ha2UgcHJvZ3Jlc3M6
IEkgd29uJ3QNCmFjY2VwdCBhbnl0aGluZyB3aXRob3V0IGhpcyBhY2tub3dsZWRnbWVudCwgb2Yg
Y291cnNlLg0KDQpCZXN0IHJlZ2FyZHMsDQogIE5pY29sYXMNCg0K
