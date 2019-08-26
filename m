Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4889E9CD4C
	for <lists+netdev@lfdr.de>; Mon, 26 Aug 2019 12:32:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729524AbfHZKb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Aug 2019 06:31:56 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:54904 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfHZKbz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Aug 2019 06:31:55 -0400
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: S//NYx8mCZy0j9NXOEiIiMHSjWL+e+6cAtdAabtN3wnEtlJpsBSOm+1mAymJ6/dhZNatpdwDat
 3KDl1wL9Rd3DijsdTJbC4lSFxrqMx0QqmynmfDDCdukkG/yKurJbqNa9gHM+4zc8QGsMbwI1jB
 8xm8Nq10qXsJ62zleZRyfLZ3BmG7G5hDIqJFu73v2+JUDos/8ogUJ6CRAc2ck2mpfOwEX43C0o
 VK52ZLRu95ioANBXTuwW8MALblqodhAQl08mkpHQALqIYlfQd7ZPROzy3aWTth7coZmxRkEnvR
 Ckg=
X-IronPort-AV: E=Sophos;i="5.64,431,1559545200"; 
   d="scan'208";a="45594507"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 26 Aug 2019 03:31:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 26 Aug 2019 03:31:52 -0700
Received: from NAM02-SN1-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 26 Aug 2019 03:31:52 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fX4WtjxPszSD8Rhg/qCh0UyOIsNJLm4fZpA90uV0jiqP7Hzjzyf44lNFfvkasSykHusaPM75zctygZqcSL4SUO+WOkFCK429YwYTjkFFYaxjx4XpCs5SjbT8DlTKJVXmKFjYs1ZNzAaEfb4n0TjMXZlg3GJuhdEyZ5gJhnQk8DcSMi4BsvRCNDMGLoLO8UEYtWvUA3+7EqlsHluy+ZA5aXef30QVU4FeRpTFo1umhE6Uez9B8arou5YANh4mRI0GrkhZTnMggKtiYAcIoYqXiPq7j7nf6plkpLH70ObMFhckpThN/OgEa3OFt+inVZCbbt9sDwnfW193+3EuGozsDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5e8yxaXgIBFnKIV6Imzd1SEradXS9tuXdb8LEjnKb0=;
 b=NkcMljFh9LnZEI9luf6O/+qlljPmy3lnl7sAYNdwWs5LtAHM1i+XAiAjXGx4elfnsvDmNda0HLu21NtiYPov7fhXb7olOh52q013kPDqg4AUbEOScbqbxd/YIs98e68a3ReJTJ17UhMbdxNbr5SD2Dim5tq58GZG3t6ZX1jHiBihpkgXjVUE8Hi2Yrqb4n6UFXfPkOmamQhF/2hcKaidvjknOvabfxKf2Xahy+DzFEUz2vqfdaAYqMEWEX48Dh925VS78B0n8Dg8NzYDJBr1pdj7kdS1cWBdSTeWAlVya/stUDmNASFxpn4sYjNPWhX6XcBZ8/zYSWWrse8+D7i/gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5e8yxaXgIBFnKIV6Imzd1SEradXS9tuXdb8LEjnKb0=;
 b=ZxUIEk99gKsNxxNonH2xe9a+YUL2B3BQyLcdlQ17pFZw77GgqzjJHoMBhJpv0RFriyUWrCNHUK1WqPf2XvbZshbxrcJUoYdPNdpABYF71a0U+U7b0pOwwCS7+Rj5UNTUKqpXjMzgwgKNLwb8nv7MdeqG1cQdqurLmDa4Asivo2Q=
Received: from MWHPR11MB1549.namprd11.prod.outlook.com (10.172.54.17) by
 MWHPR11MB1341.namprd11.prod.outlook.com (10.169.237.144) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.21; Mon, 26 Aug 2019 10:31:50 +0000
Received: from MWHPR11MB1549.namprd11.prod.outlook.com
 ([fe80::9596:8d2b:63e5:9a36]) by MWHPR11MB1549.namprd11.prod.outlook.com
 ([fe80::9596:8d2b:63e5:9a36%3]) with mapi id 15.20.2199.021; Mon, 26 Aug 2019
 10:31:50 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <poeschel@lemonage.de>
CC:     <gregkh@linuxfoundation.org>, <tglx@linutronix.de>,
        <swinslow@gmail.com>, <allison@lohutok.net>,
        <opensource@jilayne.com>, <kstewart@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <johan@kernel.org>
Subject: Re: [PATCH v6 5/7] nfc: pn533: add UART phy driver
Thread-Topic: [PATCH v6 5/7] nfc: pn533: add UART phy driver
Thread-Index: AQHVWNGdL4y2YDqy/kWuOclZouuScg==
Date:   Mon, 26 Aug 2019 10:31:50 +0000
Message-ID: <c83c2748-604d-94b7-7bb0-04b61feff9e7@microchip.com>
References: <20190820120345.22593-1-poeschel@lemonage.de>
 <20190820120345.22593-5-poeschel@lemonage.de>
 <909777a0-a70e-2174-4455-4afa0591a462@microchip.com>
 <20190823100611.GB14401@lem-wkst-02.lemonage>
In-Reply-To: <20190823100611.GB14401@lem-wkst-02.lemonage>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0010.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:a6::22) To MWHPR11MB1549.namprd11.prod.outlook.com
 (2603:10b6:301:c::17)
x-ms-exchange-messagesentrepresentingtype: 1
x-tagtoolbar-keys: D20190826133142470
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 455024d4-967d-4245-9b8a-08d72a109ace
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHPR11MB1341;
x-ms-traffictypediagnostic: MWHPR11MB1341:
x-microsoft-antispam-prvs: <MWHPR11MB1341A07E8913E74811E2C1C687A10@MWHPR11MB1341.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01415BB535
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(136003)(366004)(346002)(376002)(396003)(199004)(189003)(476003)(99286004)(486006)(2616005)(11346002)(446003)(6916009)(8936002)(14454004)(7416002)(2906002)(3846002)(6116002)(6486002)(102836004)(31686004)(6436002)(81166006)(81156014)(26005)(76176011)(52116002)(8676002)(305945005)(6506007)(53546011)(7736002)(386003)(186003)(31696002)(66446008)(86362001)(229853002)(64756008)(66946007)(66556008)(66476007)(25786009)(5660300002)(4326008)(36756003)(6512007)(256004)(316002)(54906003)(6246003)(66066001)(53936002)(71200400001)(71190400001)(478600001)(66574012)(14444005)(21314003);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHPR11MB1341;H:MWHPR11MB1549.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: Wb6p5W7wst8wl7IzTcIajyExthyT8tGxciyMIxM8MF54ifVVSFFMOlWBBsp+h8JmH/ytIsBzcZ6opdDl29Pfs6cM1P+ErA0EUv3TFX2VerxVwJnRsFDWeROJLymccpORsfLr3MYdbILr/NPbt+3FwNxLI46KJW6Ok2L4D2tIBkB9p1Ht7n59VqoH6uea96jVxOwJicbuFPyDJpd1beH2zhbPj4fik5cdLvVVclcvEOSJof3z05dzOKoz+pDWZpVcyGwjNseBOQxJNqjsmBYkPFHFc8oq2Ff6YanRssokXRS1ft1rpImUMLmOJyjcYGlmeMsdbBH2dqM/OotrqOaGw/sAfT6fLF2JpVcsThAMYGnGCA06yfb26JO62TMZoiLEDeTzJUkjOn2U4ZOGNc1uTDxmun/WcNSbOJ2ZB803MNE=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF9D9E7593FA154DB0031E341F6EBA32@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 455024d4-967d-4245-9b8a-08d72a109ace
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Aug 2019 10:31:50.6686
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: E8LvkVbKOJ9b7v3gfDUXBOlNhw1WeWe6wcD/ST0ZQdEWo4w01VD517lxMil2WFCC9ZAV5B0uAGxQ0/ziTG+TT1EU/tGAfYjDSPpxbOTsYxc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGkgTGFycywNCg0KT24gMjMuMDguMjAxOSAxMzowNiwgTGFycyBQb2VzY2hlbCB3cm90ZToNCj4g
RXh0ZXJuYWwgRS1NYWlsDQo+IA0KPiANCj4gT24gVGh1LCBBdWcgMjIsIDIwMTkgYXQgMTA6MDk6
MDlBTSArMDAwMCwgQ2xhdWRpdS5CZXpuZWFAbWljcm9jaGlwLmNvbSB3cm90ZToNCj4+IEhpIExh
cnMsDQo+Pg0KPj4gT24gMjAuMDguMjAxOSAxNTowMywgTGFycyBQb2VzY2hlbCB3cm90ZToNCj4+
PiBUaGlzIGFkZHMgdGhlIFVBUlQgcGh5IGludGVyZmFjZSBmb3IgdGhlIHBuNTMzIGRyaXZlci4N
Cj4+PiBUaGUgcG41MzMgZHJpdmVyIGNhbiBiZSB1c2VkIHRocm91Z2ggVUFSVCBpbnRlcmZhY2Ug
dGhpcyB3YXkuDQo+Pj4gSXQgaXMgaW1wbGVtZW50ZWQgYXMgYSBzZXJkZXYgZGV2aWNlLg0KPj4+
DQo+Pj4gQ2M6IEpvaGFuIEhvdm9sZCA8am9oYW5Aa2VybmVsLm9yZz4NCj4+PiBTaWduZWQtb2Zm
LWJ5OiBMYXJzIFBvZXNjaGVsIDxwb2VzY2hlbEBsZW1vbmFnZS5kZT4NCj4+PiAtLS0NCj4+PiBD
aGFuZ2VzIGluIHY2Og0KPj4+IC0gUmViYXNlZCB0aGUgcGF0Y2ggc2VyaWVzIG9uIHY1LjMtcmM1
DQo+Pj4NCj4+PiBDaGFuZ2VzIGluIHY1Og0KPj4+IC0gVXNlIHRoZSBzcGxpdHRlZCBwbjUzeF9j
b21tb25faW5pdCBhbmQgcG41M3hfcmVnaXN0ZXJfbmZjDQo+Pj4gICBhbmQgcG41M3hfY29tbW9u
X2NsZWFuIGFuZCBwbjUzeF91bnJlZ2lzdGVyX25mYyBhbGlrZQ0KPj4+DQo+Pj4gQ2hhbmdlcyBp
biB2NDoNCj4+PiAtIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wKw0KPj4+IC0gU291
cmNlIGNvZGUgY29tbWVudHMgYWJvdmUgcmVmZXJpbmcgaXRlbXMNCj4+PiAtIEVycm9yIGNoZWNr
IGZvciBzZXJkZXZfZGV2aWNlX3dyaXRlJ3MNCj4+PiAtIENoYW5nZSBpZiAoeHh4ID09IE5VTEwp
IHRvIGlmICgheHh4KQ0KPj4+IC0gUmVtb3ZlIGRldmljZSBuYW1lIGZyb20gYSBkZXZfZXJyDQo+
Pj4gLSBtb3ZlIHBuNTMzX3JlZ2lzdGVyIGluIF9wcm9iZSBhIGJpdCB0b3dhcmRzIHRoZSBlbmQg
b2YgX3Byb2JlDQo+Pj4gLSBtYWtlIHVzZSBvZiBuZXdseSBhZGRlZCBkZXZfdXAgLyBkZXZfZG93
biBwaHlfb3BzDQo+Pj4gLSBjb250cm9sIHNlbmRfd2FrZXVwIHZhcmlhYmxlIGZyb20gZGV2X3Vw
IC8gZGV2X2Rvd24NCj4+Pg0KPj4+IENoYW5nZXMgaW4gdjM6DQo+Pj4gLSBkZXBlbmQgb24gU0VS
SUFMX0RFVl9CVVMgaW4gS2NvbmZpZw0KPj4+DQo+Pj4gQ2hhbmdlcyBpbiB2MjoNCj4+PiAtIHN3
aXRjaGVkIGZyb20gdHR5IGxpbmUgZGlzY2lwbGluZSB0byBzZXJkZXYsIHJlc3VsdGluZyBpbiBt
YW55DQo+Pj4gICBzaW1wbGlmaWNhdGlvbnMNCj4+PiAtIFNQRFggTGljZW5zZSBJZGVudGlmaWVy
DQo+Pj4NCj4+PiAgZHJpdmVycy9uZmMvcG41MzMvS2NvbmZpZyAgfCAgMTEgKysNCj4+PiAgZHJp
dmVycy9uZmMvcG41MzMvTWFrZWZpbGUgfCAgIDIgKw0KPj4+ICBkcml2ZXJzL25mYy9wbjUzMy9w
bjUzMy5oICB8ICAgOCArDQo+Pj4gIGRyaXZlcnMvbmZjL3BuNTMzL3VhcnQuYyAgIHwgMzE2ICsr
KysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysNCj4+PiAgNCBmaWxlcyBjaGFuZ2Vk
LCAzMzcgaW5zZXJ0aW9ucygrKQ0KPj4+ICBjcmVhdGUgbW9kZSAxMDA2NDQgZHJpdmVycy9uZmMv
cG41MzMvdWFydC5jDQo+Pj4NCj4+PiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZmMvcG41MzMvS2Nv
bmZpZyBiL2RyaXZlcnMvbmZjL3BuNTMzL0tjb25maWcNCj4+PiBpbmRleCBmNmQ2YjM0NWJhMGQu
LjdmZTFiYmUyNjU2OCAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL25mYy9wbjUzMy9LY29uZmln
DQo+Pj4gKysrIGIvZHJpdmVycy9uZmMvcG41MzMvS2NvbmZpZw0KPj4+IEBAIC0yNiwzICsyNiwx
NCBAQCBjb25maWcgTkZDX1BONTMzX0kyQw0KPj4+ICANCj4+PiAgCSAgSWYgeW91IGNob29zZSB0
byBidWlsZCBhIG1vZHVsZSwgaXQnbGwgYmUgY2FsbGVkIHBuNTMzX2kyYy4NCj4+PiAgCSAgU2F5
IE4gaWYgdW5zdXJlLg0KPj4+ICsNCj4+PiArY29uZmlnIE5GQ19QTjUzMl9VQVJUDQo+Pj4gKwl0
cmlzdGF0ZSAiTkZDIFBONTMyIGRldmljZSBzdXBwb3J0IChVQVJUKSINCj4+PiArCWRlcGVuZHMg
b24gU0VSSUFMX0RFVl9CVVMNCj4+PiArCXNlbGVjdCBORkNfUE41MzMNCj4+PiArCS0tLWhlbHAt
LS0NCj4+PiArCSAgVGhpcyBtb2R1bGUgYWRkcyBzdXBwb3J0IGZvciB0aGUgTlhQIHBuNTMyIFVB
UlQgaW50ZXJmYWNlLg0KPj4+ICsJICBTZWxlY3QgdGhpcyBpZiB5b3VyIHBsYXRmb3JtIGlzIHVz
aW5nIHRoZSBVQVJUIGJ1cy4NCj4+PiArDQo+Pj4gKwkgIElmIHlvdSBjaG9vc2UgdG8gYnVpbGQg
YSBtb2R1bGUsIGl0J2xsIGJlIGNhbGxlZCBwbjUzMl91YXJ0Lg0KPj4+ICsJICBTYXkgTiBpZiB1
bnN1cmUuDQo+Pj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmZjL3BuNTMzL01ha2VmaWxlIGIvZHJp
dmVycy9uZmMvcG41MzMvTWFrZWZpbGUNCj4+PiBpbmRleCA0M2MyNWI0Zjk0NjYuLmI5NjQ4MzM3
NTc2ZiAxMDA2NDQNCj4+PiAtLS0gYS9kcml2ZXJzL25mYy9wbjUzMy9NYWtlZmlsZQ0KPj4+ICsr
KyBiL2RyaXZlcnMvbmZjL3BuNTMzL01ha2VmaWxlDQo+Pj4gQEAgLTQsNyArNCw5IEBADQo+Pj4g
ICMNCj4+PiAgcG41MzNfdXNiLW9ianMgID0gdXNiLm8NCj4+PiAgcG41MzNfaTJjLW9ianMgID0g
aTJjLm8NCj4+PiArcG41MzJfdWFydC1vYmpzICA9IHVhcnQubw0KPj4+ICANCj4+PiAgb2JqLSQo
Q09ORklHX05GQ19QTjUzMykgICAgICs9IHBuNTMzLm8NCj4+PiAgb2JqLSQoQ09ORklHX05GQ19Q
TjUzM19VU0IpICs9IHBuNTMzX3VzYi5vDQo+Pj4gIG9iai0kKENPTkZJR19ORkNfUE41MzNfSTJD
KSArPSBwbjUzM19pMmMubw0KPj4+ICtvYmotJChDT05GSUdfTkZDX1BONTMyX1VBUlQpICs9IHBu
NTMyX3VhcnQubw0KPj4+IGRpZmYgLS1naXQgYS9kcml2ZXJzL25mYy9wbjUzMy9wbjUzMy5oIGIv
ZHJpdmVycy9uZmMvcG41MzMvcG41MzMuaA0KPj4+IGluZGV4IDUxMGRkZWJiZDg5Ni4uNjU0MTA4
OGZhZDczIDEwMDY0NA0KPj4+IC0tLSBhL2RyaXZlcnMvbmZjL3BuNTMzL3BuNTMzLmgNCj4+PiAr
KysgYi9kcml2ZXJzL25mYy9wbjUzMy9wbjUzMy5oDQo+Pj4gQEAgLTQzLDYgKzQzLDExIEBADQo+
Pj4gIA0KPj4+ICAvKiBQcmVhbWJsZSAoMSksIFNvUEMgKDIpLCBBQ0sgQ29kZSAoMiksIFBvc3Rh
bWJsZSAoMSkgKi8NCj4+PiAgI2RlZmluZSBQTjUzM19TVERfRlJBTUVfQUNLX1NJWkUgNg0KPj4+
ICsvKg0KPj4+ICsgKiBQcmVhbWJsZSAoMSksIFNvUEMgKDIpLCBQYWNrZXQgTGVuZ3RoICgxKSwg
UGFja2V0IExlbmd0aCBDaGVja3N1bSAoMSksDQo+Pj4gKyAqIFNwZWNpZmljIEFwcGxpY2F0aW9u
IExldmVsIEVycm9yIENvZGUgKDEpICwgUG9zdGFtYmxlICgxKQ0KPj4+ICsgKi8NCj4+PiArI2Rl
ZmluZSBQTjUzM19TVERfRVJST1JfRlJBTUVfU0laRSA4DQo+Pj4gICNkZWZpbmUgUE41MzNfU1RE
X0ZSQU1FX0NIRUNLU1VNKGYpIChmLT5kYXRhW2YtPmRhdGFsZW5dKQ0KPj4+ICAjZGVmaW5lIFBO
NTMzX1NURF9GUkFNRV9QT1NUQU1CTEUoZikgKGYtPmRhdGFbZi0+ZGF0YWxlbiArIDFdKQ0KPj4+
ICAvKiBIYWxmIHN0YXJ0IGNvZGUgKDMpLCBMRU4gKDQpIHNob3VsZCBiZSAweGZmZmYgZm9yIGV4
dGVuZGVkIGZyYW1lICovDQo+Pj4gQEAgLTg0LDYgKzg5LDkgQEANCj4+PiAgI2RlZmluZSBQTjUz
M19DTURfTUlfTUFTSyAweDQwDQo+Pj4gICNkZWZpbmUgUE41MzNfQ01EX1JFVF9TVUNDRVNTIDB4
MDANCj4+PiAgDQo+Pj4gKyNkZWZpbmUgUE41MzNfRlJBTUVfREFUQUxFTl9BQ0sgMHgwMA0KPj4+
ICsjZGVmaW5lIFBONTMzX0ZSQU1FX0RBVEFMRU5fRVJST1IgMHgwMQ0KPj4+ICsjZGVmaW5lIFBO
NTMzX0ZSQU1FX0RBVEFMRU5fRVhURU5ERUQgMHhGRg0KPj4+ICANCj4+PiAgZW51bSAgcG41MzNf
cHJvdG9jb2xfdHlwZSB7DQo+Pj4gIAlQTjUzM19QUk9UT19SRVFfQUNLX1JFU1AgPSAwLA0KPj4+
IGRpZmYgLS1naXQgYS9kcml2ZXJzL25mYy9wbjUzMy91YXJ0LmMgYi9kcml2ZXJzL25mYy9wbjUz
My91YXJ0LmMNCj4+PiBuZXcgZmlsZSBtb2RlIDEwMDY0NA0KPj4+IGluZGV4IDAwMDAwMDAwMDAw
MC4uZjFjYzIzNTRhNGZkDQo+Pj4gLS0tIC9kZXYvbnVsbA0KPj4+ICsrKyBiL2RyaXZlcnMvbmZj
L3BuNTMzL3VhcnQuYw0KPj4+IEBAIC0wLDAgKzEsMzE2IEBADQo+Pj4gKy8vIFNQRFgtTGljZW5z
ZS1JZGVudGlmaWVyOiBHUEwtMi4wKw0KPj4+ICsvKg0KPj4+ICsgKiBEcml2ZXIgZm9yIE5YUCBQ
TjUzMiBORkMgQ2hpcCAtIFVBUlQgdHJhbnNwb3J0IGxheWVyDQo+Pj4gKyAqDQo+Pj4gKyAqIENv
cHlyaWdodCAoQykgMjAxOCBMZW1vbmFnZSBTb2Z0d2FyZSBHbWJIDQo+Pj4gKyAqIEF1dGhvcjog
TGFycyBQw7ZzY2hlbCA8cG9lc2NoZWxAbGVtb25hZ2UuZGU+DQo+Pj4gKyAqIEFsbCByaWdodHMg
cmVzZXJ2ZWQuDQo+Pj4gKyAqLw0KPj4+ICsNCj4+PiArI2luY2x1ZGUgPGxpbnV4L2RldmljZS5o
Pg0KPj4+ICsjaW5jbHVkZSA8bGludXgva2VybmVsLmg+DQo+Pj4gKyNpbmNsdWRlIDxsaW51eC9t
b2R1bGUuaD4NCj4+PiArI2luY2x1ZGUgPGxpbnV4L25mYy5oPg0KPj4+ICsjaW5jbHVkZSA8bGlu
dXgvbmV0ZGV2aWNlLmg+DQo+Pj4gKyNpbmNsdWRlIDxsaW51eC9vZi5oPg0KPj4+ICsjaW5jbHVk
ZSA8bGludXgvc2VyZGV2Lmg+DQo+Pj4gKyNpbmNsdWRlICJwbjUzMy5oIg0KPj4+ICsNCj4+PiAr
I2RlZmluZSBQTjUzMl9VQVJUX1NLQl9CVUZGX0xFTgkoUE41MzNfQ01EX0RBVEFFWENIX0RBVEFf
TUFYTEVOICogMikNCj4+PiArDQo+Pj4gK2VudW0gc2VuZF93YWtldXAgew0KPj4+ICsJUE41MzJf
U0VORF9OT19XQUtFVVAgPSAwLA0KPj4+ICsJUE41MzJfU0VORF9XQUtFVVAsDQo+Pj4gKwlQTjUz
Ml9TRU5EX0xBU1RfV0FLRVVQLA0KPj4+ICt9Ow0KPj4+ICsNCj4+PiArDQo+Pj4gK3N0cnVjdCBw
bjUzMl91YXJ0X3BoeSB7DQo+Pj4gKwlzdHJ1Y3Qgc2VyZGV2X2RldmljZSAqc2VyZGV2Ow0KPj4+
ICsJc3RydWN0IHNrX2J1ZmYgKnJlY3Zfc2tiOw0KPj4+ICsJc3RydWN0IHBuNTMzICpwcml2Ow0K
Pj4+ICsJZW51bSBzZW5kX3dha2V1cCBzZW5kX3dha2V1cDsNCj4+DQo+PiBDb3VsZCB0aGVyZSBi
ZSBhbnkgY29uY3VycmVuY3kgaXNzdWVzIHcvIHJlZ2FyZHMgdG8gYWNjZXNzaW5nIHRoaXMNCj4+
IHZhcmlhYmxlPyBJIHNlZSBpdCBpcyBhY2Nlc3NlZCBpbiBwbjUzMl91YXJ0X3NlbmRfZnJhbWUo
KSwgcG41MzJfZGV2X3VwKCksDQo+PiBwbjUzMl9kZXZfZG93bigpIHdoaWNoIG1heSBiZSBjYWxs
ZWQgZnJvbSB0aGUgZm9sbG93aW5nIHdxOg0KPj4NCj4+ICAgICAgICAgSU5JVF9XT1JLKCZwcml2
LT5taV90bV9yeF93b3JrLCBwbjUzM193cV90bV9taV9yZWN2KTsNCj4+DQo+PiAgICAgICAgIElO
SVRfV09SSygmcHJpdi0+bWlfdG1fdHhfd29yaywgcG41MzNfd3FfdG1fbWlfc2VuZCk7DQo+Pg0K
Pj4gICAgICAgICBJTklUX0RFTEFZRURfV09SSygmcHJpdi0+cG9sbF93b3JrLCBwbjUzM193cV9w
b2xsKTsNCj4+DQo+Pg0KPj4gYW5kIGZyb20gbmV0L25mYy9jb3JlLmMgdmlhIGRldl91cCgpL2Rl
dl9kb3duKCkuDQo+IA0KPiBXZWxsLCBJIHNwZW5kIHNvbWUgbWludXRlcyB0aGlua2luZyBhYm91
dCB0aGlzLiBUaGVyZSBzaG91bGQgYmUgbm8gcmVhbA0KPiBwcm9ibGVtLiBUaGUgY29kZSBpbiBw
bjUzMy5jIGVuc3VyZXMsIHRoYXQgY29tbWFuZHMgYXJlIHRyYW5zbWl0dGVkDQo+IHNlcXVlbmNp
YWxseS4gQW5kIGl0IGFsd2F5cyBpcyBjb21tYW5kIC0gcmVzcG9uc2UuIFNvIGlmIGEgY29tbWFu
ZCBpcw0KPiBzZW5kLCB0aGUgZHJpdmVyIHdhaXRzIGZvciBhIHJlc3BvbnNlIGZyb20gdGhlIGNo
aXAuDQo+IFNvIHBuNTMyX3VhcnRfc2VuZF9mcmFtZSBzaG91bGQgbm90IGJlIGNhbGxlZCBtdWx0
aXBsZSB0aW1lcyB3aXRob3V0DQo+IHJlYWNoaW5nIGF0IGxlYXN0IHNlcmRldl9kZXZpY2Vfd3Jp
dGUsIGJ1dCBhdCB0aGlzIHBvaW50IHRoZSByYWNlIGlzDQo+IGFscmVhZHkgb3Zlci4NCj4gVGhl
cmUgaXMgb25lIGV4Y2VwdGlvbiwgdGhpcyBpcyB0aGUgYWJvcnQgY29tbWFuZC4gVGhpcyBjb21t
YW5kIGNhbiBiZQ0KPiBzZW50IHdpdGhvdXQgcmVjZWl2aW5nIGEgcHJldmlvdXMgcmVzcG9uc2Uu
IFNvIHRoZXJlIGlzIHRoZSBwb3NzaWJpbGl0eQ0KPiBvZiBhIHN1Y2Nlc3NmdWwgcmFjZS4NCj4g
VGhlIHNlbmRfd2FrZXVwIHZhcmlhYmxlIGlzIHVzZWQgdG8gY29udHJvbCBpZiB3ZSBuZWVkIHRv
IHNlbmQgYQ0KPiB3YWtldXAgcmVxdWVzdCB0byB0aGUgcG41MzIgY2hpcCBwcmlvciB0byB0aGUg
YWN0dWFsIGNvbW1hbmQgd2Ugd291bGQNCj4gbGlrZSB0byBzZW5kLg0KPiBXb3JzdCB0aGluZyB0
aGF0IEkgc2VlIGNvdWxkIGhhcHBlbiAtIGlmIHRoZSByYWNlIHN1Y2NlZWRzIC0gaXMgdGhhdCB3
ZQ0KPiBzZW5kIGEgd2FrZXVwIHRvIHRoZSBjaGlwIHRoYXQgaXMgcHJvcGFibHkgbm90IG5lZWRl
ZCBhcyBpdCBpcyBhbHJlYWR5DQo+IGF3YWtlLiBCdXQgdGhpcyBkb2VzIG5vdCBodXJ0IGFzIGEg
d2FrZXVwIHNlbmQgdG8gdGhlIHBuNTMyIGlzDQo+IGVzc2VudGlhbGx5IGEgbm8tb3AgaWYgdGhl
IGNoaXAgaXMgYXdha2UgYWxyZWFkeS4gSSBjb3VsZCBoYXZlDQo+IGltcGxlbWVudGVkIGl0IHNv
LCB0aGF0IGEgd2FrZXVwIGlzIHNlbnQgaW4gZnJvbnQgb2YgZXZlcnkgY29tbWFuZA0KPiB3aXRo
b3V0IHRoaW5raW5nIGFuZCB0aGUgZHJpdmVyIHdvdWxkIHdvcmsuDQo+IFRoZSBzYW1lIGlzIHdp
dGggcG41MzJfZGV2X3VwLiBJdCBjb3VsZCBiZSB0aGF0IHRoZXJlIGlzIG9uZSB3YWtldXAgc2Vu
dA0KPiB0byBtdWNoLCBidXQgaXQgZG9lcyBub3QgaHVydC4NCj4gcG41MzJfZGV2X2Rvd24gaXMg
bm90IHByb2JsZW1hdGljIEkgdGhpbmsuDQo+IA0KPiBUbyBzdW0gaXQgdXA6IFRoZXJlIGlzIG1h
eWJlIGEgdmVyeSBsaXR0bGUgcHJvYmFiaWxpdHksIGJ1dCBpdCBkb2VzDQo+IG5vdGhpbmcgYmFk
LiBRdWVzdGlvbiBpcyBub3c6IElzIGl0IHdvcnRoIG11dGV4J2luZyB0aGUgc2VuZF93YWtldXAN
Cj4gdmFyaWFibGUgb3IgY2FuIHdlIGxlYXZlIGl0IGFzLWlzID8NCg0KQmVpbmcgc28gYXMgeW91
IGRlc2NyaWJlZCBhYm92ZSwgSSBhbSBmb3IgbGVhdmluZyBpdCBhcyBpcy4gTWF5YmUsIGFzIHlv
dQ0Kd2lzaCwgZG9jdW1lbnQgdGhpcyBzb21ld2hlcmUgKGUuZy4gYSBjb21tZW50IGluIHRoZSBj
b2RlKSwgc28gdGhhdCBvdGhlcnMNCnRvIGJlIGF3YXJlIG9mIHRoaXMuDQoNClRoYW5rIHlvdSwN
CkNsYXVkaXUgQmV6bmVhDQoNCj4gDQo+IFRoYW5rIHlvdSBmb3IgeW91ciByZXZpZXcsIENsYXVk
aXUuDQo+IFJlZ2FyZHMsDQo+IExhcnMNCj4gDQo+IA0K
