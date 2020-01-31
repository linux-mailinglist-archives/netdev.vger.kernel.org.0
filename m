Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E6B914EEDF
	for <lists+netdev@lfdr.de>; Fri, 31 Jan 2020 15:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729132AbgAaO5s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Jan 2020 09:57:48 -0500
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:8001 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728825AbgAaO5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Jan 2020 09:57:48 -0500
Received-SPF: Pass (esa4.microchip.iphmx.com: domain of
  Claudiu.Beznea@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="Claudiu.Beznea@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com -exists:%{i}.spf.microchip.iphmx.com
  include:servers.mcsv.net include:mktomail.com
  include:spf.protection.outlook.com ~all"
Received-SPF: None (esa4.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa4.microchip.iphmx.com;
  envelope-from="Claudiu.Beznea@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa4.microchip.iphmx.com; spf=Pass smtp.mailfrom=Claudiu.Beznea@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
IronPort-SDR: Xpl2MSD9QH5o9sWt6hVoH6knzsCIJUUPHIhvSyPqJ0vuOd4tEEKnQyMkO805Kl4qA5K77Mm3Su
 3T0p9YxjcRm+y8VlqNYruwj5H11rLJqvlNQY2dWlC2ZwEA4jRw51WUBp5LxjHxQCHboVl/IjwG
 LyGoVS7gTx8Rf8PW8XSy8mMqssbluSD9zx1HnSfzfAnfT5KC/9W+DFrZDzDU+vD1c/3LAsgHuj
 PjihAOd1tM1eNO/S6V5AZI32q3C8525NwrT1LnoKFf+eJtwdJJ2BDKcWF7pkNLTvqW59WfHJDI
 wic=
X-IronPort-AV: E=Sophos;i="5.70,386,1574146800"; 
   d="scan'208";a="62784928"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 31 Jan 2020 07:57:46 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.87.72) by
 chn-vm-ex02.mchp-main.com (10.10.87.72) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Fri, 31 Jan 2020 07:57:45 -0700
Received: from NAM11-BN8-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.72) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5 via Frontend
 Transport; Fri, 31 Jan 2020 07:57:45 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GDWVJb85Zq9btI6TqK8AHifyJcEJpzYf2S2R5ER5GPzZDZBpeEijllr2CCLAINN++d+OgBRX3baXApULHVOjdQpEoruKqWWseQhY8lKFjOIR2WWY9wFw4y+9wulwmakLk0HBhBTEMXeNqkaQKFJjyumc+2lOJY5822kjtG6yRTGPeGz2LothdsQdCbIPCTWljb4ShwrxX7Xw5+aoW67u79OZkCgo2ULWbtEhSiZYVmrxFtjlsCrVq7veKtUewSnR+4q9G0LsNhqBRk2hzMilZmcB5uQVzwonTEthoEJjSntIZ1Q6x3mAgorhnYQzWCBk/fSMTi+HrbpXyVh1RGulLw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bySpHrufQ3JG1CbEj3vRKLtxSJGlvMAmH1Uki1FoZc=;
 b=RlSq6ivJnpw6ZW3C9WEpqQH4Tnpk+bGwPlJjjHYRCpKIxz9cGnYc9/TN/eh/gZE2p09z2XXVgcOQx3zObahdziaNpVfiJjDQmWrUOkW78Kw8gfib8HdFlcFDjpht0rgKVF6XzDkiKqC9Azx7rc74BhyakHQZopDxK3lKmRULeOxr0IJLDr2FC9SOO2qYH0n2QaS4/GGtBDE5xmD7NzzQ4fIfjUlZeKhE/wwPLVy4rJw7WX3vrzLZOcTSlNuHBAy0tEjUOHPcNigrOlsI7lOXKjyiGn4LTvMV+0CR99PbXht1nU32wNGomgs8A0JPDWICwcfE8j25JZPrOT2qGz81xw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microchip.com; dmarc=pass action=none
 header.from=microchip.com; dkim=pass header.d=microchip.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector2-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7bySpHrufQ3JG1CbEj3vRKLtxSJGlvMAmH1Uki1FoZc=;
 b=BMKkkMJ2lp4afsNfyVVpT6cluSj1p8VmRTcnlr7KsupJdSKrPvH00V/xS1Vnbdtt7LSyMGCCp/0VP0u4aEkieVZZA/RppIulmkVdhd/sXDhPTENbl6+JHNBraxmit2occChI8AqoWoL5wZQxV6aB7W4CtwO3ssPBm1JzkXqs/ss=
Received: from DM6PR11MB3225.namprd11.prod.outlook.com (20.176.120.224) by
 DM6PR11MB4348.namprd11.prod.outlook.com (52.132.249.146) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2665.23; Fri, 31 Jan 2020 14:57:44 +0000
Received: from DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::dc6b:1191:3a76:8b6a]) by DM6PR11MB3225.namprd11.prod.outlook.com
 ([fe80::dc6b:1191:3a76:8b6a%7]) with mapi id 15.20.2686.028; Fri, 31 Jan 2020
 14:57:44 +0000
From:   <Claudiu.Beznea@microchip.com>
To:     <harini.katakam@xilinx.com>, <Nicolas.Ferre@microchip.com>,
        <davem@davemloft.net>
CC:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <michal.simek@xilinx.com>, <harinikatakamlinux@gmail.com>
Subject: Re: [PATCH 2/2] net: macb: Limit maximum GEM TX length in TSO
Thread-Topic: [PATCH 2/2] net: macb: Limit maximum GEM TX length in TSO
Thread-Index: AQHV2EbLgASEFAVb4k6q8m7g4OpRNQ==
Date:   Fri, 31 Jan 2020 14:57:44 +0000
Message-ID: <29c67f4f-9dd9-3786-689f-c0b6eeb40f49@microchip.com>
References: <1580466455-27288-1-git-send-email-harini.katakam@xilinx.com>
 <1580466455-27288-3-git-send-email-harini.katakam@xilinx.com>
In-Reply-To: <1580466455-27288-3-git-send-email-harini.katakam@xilinx.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.177.32.156]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 28bd5c78-cdc3-4e3d-4e12-08d7a65dedb5
x-ms-traffictypediagnostic: DM6PR11MB4348:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM6PR11MB43481CDE6B9F753AC135621387070@DM6PR11MB4348.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 029976C540
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39860400002)(396003)(376002)(366004)(136003)(346002)(189003)(199004)(86362001)(478600001)(64756008)(53546011)(6506007)(31696002)(66446008)(66476007)(6486002)(66556008)(4326008)(81156014)(2906002)(2616005)(316002)(8676002)(31686004)(81166006)(6512007)(66946007)(36756003)(54906003)(26005)(8936002)(186003)(5660300002)(71200400001)(110136005)(76116006)(91956017);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB4348;H:DM6PR11MB3225.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: VlwhHcdqh5ngkQokAgRSgSpfIS4I0Z1lqreXNRWsuzpxP+jGrzmx5C2TKbT8STTnAwjQ0SCRA3YuszfM0xqbp/1kxe40M/cqBKKQQt105SOkNktFzI7QbukZ1sFRt0SkJH96gQaPyYO7u8Pl541wi0U05UmxO1Q8xTpUK+TPSYQm6ApRZfIk6bKrh2bKZcPLXfUXQBa47XI7ym4GIhttePutiR2pLFGDHblfIFFF8YgFB8J9lAVoBtF9bOom/Z6ovRLCeVwhavOYdYnTZXgYzP/cC2YumULvuEYJJNKSiffWIiTqDs6pmcsB7brluOkvTMVFfJRDYeHPUfluslAYIwLb13XXwE4hXDwOOWWG9k5uXesIFtwnJyVgiW3E9kFCr9BD61pAlqWFHHm7jffV7ng41XfTigTyMRUJ9W3wmXVavvHqomnWgkXUtdajcKHL
x-ms-exchange-antispam-messagedata: IbYaR7SNV6FoxxvUGWLEGG/0p9nEenovjKbOE9mg4cJuEVHGL96bHZw6rqcSmskFHTccbzSTONe6vcZ26l3MBUP9Ys3FpbLVNglxirR7GfyGC73i9P0OUuQqpcW46kqaWoVH3++39ArrDNCuTUA6Gw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <C7D2FA09BCEF5B4ABE64E99F9830A283@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 28bd5c78-cdc3-4e3d-4e12-08d7a65dedb5
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jan 2020 14:57:44.4237
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 3f4057f3-b418-4d4e-ba84-d55b4e897d88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +zMHqtd7c/5heFN/Ous0LZFfNzjtbX6Rk8GlQXnZlfBDl4+4LIT+77olvMPsVQUhQDJV96h591YtQKxXyqdm6runsYYMVBwxQpN2QLviVWE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB4348
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCk9uIDMxLjAxLjIwMjAgMTI6MjcsIEhhcmluaSBLYXRha2FtIHdyb3RlOg0KPiBFWFRFUk5B
TCBFTUFJTDogRG8gbm90IGNsaWNrIGxpbmtzIG9yIG9wZW4gYXR0YWNobWVudHMgdW5sZXNzIHlv
dSBrbm93IHRoZSBjb250ZW50IGlzIHNhZmUNCj4gDQo+IEdFTV9NQVhfVFhfTEVOIGN1cnJlbnRs
eSByZXNvbHZlcyB0byAweDNGRjggZm9yIGFueSBJUCB2ZXJzaW9uIHN1cHBvcnRpbmcNCj4gVFNP
IHdpdGggZnVsbCAxNGJpdHMgb2YgbGVuZ3RoIGZpZWxkIGluIHBheWxvYWQgZGVzY3JpcHRvci4g
QnV0IGFuIElQDQo+IGVycmF0YSBjYXVzZXMgZmFsc2UgYW1iYV9lcnJvciAoYml0IDYgb2YgSVNS
KSB3aGVuIGxlbmd0aCBpbiBwYXlsb2FkDQo+IGRlc2NyaXB0b3JzIGlzIHNwZWNpZmllZCBhYm92
ZSAxNjM4Ny4gVGhlIGVycm9yIG9jY3VycyBiZWNhdXNlIHRoZSBETUENCj4gZmFsc2VseSBjb25j
bHVkZXMgdGhhdCB0aGVyZSBpcyBub3QgZW5vdWdoIHNwYWNlIGluIFNSQU0gZm9yIGluY29taW5n
DQo+IHBheWxvYWQuIFRoZXNlIGVycm9ycyB3ZXJlIG9ic2VydmVkIGNvbnRpbnVvdXNseSB1bmRl
ciBzdHJlc3Mgb2YgbGFyZ2UNCj4gcGFja2V0cyB1c2luZyBpcGVyZiBvbiBhIHZlcnNpb24gd2hl
cmUgU1JBTSB3YXMgMTZLIGZvciBlYWNoIHF1ZXVlLiBUaGlzDQo+IGVycmF0YSB3aWxsIGJlIGRv
Y3VtZW50ZWQgc2hvcnRseSBhbmQgYWZmZWN0cyBhbGwgdmVyc2lvbnMgc2luY2UgVFNPDQo+IGZ1
bmN0aW9uYWxpdHkgd2FzIGFkZGVkLiBIZW5jZSBsaW1pdCB0aGUgbWF4IGxlbmd0aCB0byAweDNG
QzAgKHJvdW5kZWQpLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogSGFyaW5pIEthdGFrYW0gPGhhcmlu
aS5rYXRha2FtQHhpbGlueC5jb20+DQo+IC0tLQ0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvY2Fk
ZW5jZS9tYWNiX21haW4uYyB8IDMgKystDQo+ICAxIGZpbGUgY2hhbmdlZCwgMiBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJu
ZXQvY2FkZW5jZS9tYWNiX21haW4uYyBiL2RyaXZlcnMvbmV0L2V0aGVybmV0L2NhZGVuY2UvbWFj
Yl9tYWluLmMNCj4gaW5kZXggMmU0MThiOC4uOTk0ZmU2NyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy9uZXQvZXRoZXJuZXQvY2FkZW5jZS9tYWNiX21haW4uYw0KPiArKysgYi9kcml2ZXJzL25ldC9l
dGhlcm5ldC9jYWRlbmNlL21hY2JfbWFpbi5jDQo+IEBAIC03NCw2ICs3NCw3IEBAIHN0cnVjdCBz
aWZpdmVfZnU1NDBfbWFjYl9tZ210IHsNCj4gICNkZWZpbmUgTUFDQl9UWF9MRU5fQUxJR04gICAg
ICA4DQo+ICAjZGVmaW5lIE1BQ0JfTUFYX1RYX0xFTiAgICAgICAgICAgICAgICAoKHVuc2lnbmVk
IGludCkoKDEgPDwgTUFDQl9UWF9GUk1MRU5fU0laRSkgLSAxKSAmIH4oKHVuc2lnbmVkIGludCko
TUFDQl9UWF9MRU5fQUxJR04gLSAxKSkpDQo+ICAjZGVmaW5lIEdFTV9NQVhfVFhfTEVOICAgICAg
ICAgKCh1bnNpZ25lZCBpbnQpKCgxIDw8IEdFTV9UWF9GUk1MRU5fU0laRSkgLSAxKSAmIH4oKHVu
c2lnbmVkIGludCkoTUFDQl9UWF9MRU5fQUxJR04gLSAxKSkpDQo+ICsjZGVmaW5lIEdFTV9NQVhf
VFhfTEVOX0VSUkFUQSAgKHVuc2lnbmVkIGludCkoMHgzRkMwKQ0KPiANCj4gICNkZWZpbmUgR0VN
X01UVV9NSU5fU0laRSAgICAgICBFVEhfTUlOX01UVQ0KPiAgI2RlZmluZSBNQUNCX05FVElGX0xT
TyAgICAgICAgIE5FVElGX0ZfVFNPDQo+IEBAIC0zNjQwLDcgKzM2NDEsNyBAQCBzdGF0aWMgaW50
IG1hY2JfaW5pdChzdHJ1Y3QgcGxhdGZvcm1fZGV2aWNlICpwZGV2KQ0KPiANCj4gICAgICAgICAv
KiBzZXR1cCBhcHByb3ByaWF0ZWQgcm91dGluZXMgYWNjb3JkaW5nIHRvIGFkYXB0ZXIgdHlwZSAq
Lw0KPiAgICAgICAgIGlmIChtYWNiX2lzX2dlbShicCkpIHsNCj4gLSAgICAgICAgICAgICAgIGJw
LT5tYXhfdHhfbGVuZ3RoID0gR0VNX01BWF9UWF9MRU47DQo+ICsgICAgICAgICAgICAgICBicC0+
bWF4X3R4X2xlbmd0aCA9IG1pbihHRU1fTUFYX1RYX0xFTiwgR0VNX01BWF9UWF9MRU5fRVJSQVRB
KTsNCg0KSXNuJ3QgdGhpcyBhbHdheXMgcmVzb2x2ZWQgdG8gR0VNX01BWF9UWF9MRU5fRVJSQVRB
Pw0KDQo+ICAgICAgICAgICAgICAgICBicC0+bWFjYmdlbV9vcHMubW9nX2FsbG9jX3J4X2J1ZmZl
cnMgPSBnZW1fYWxsb2NfcnhfYnVmZmVyczsNCj4gICAgICAgICAgICAgICAgIGJwLT5tYWNiZ2Vt
X29wcy5tb2dfZnJlZV9yeF9idWZmZXJzID0gZ2VtX2ZyZWVfcnhfYnVmZmVyczsNCj4gICAgICAg
ICAgICAgICAgIGJwLT5tYWNiZ2VtX29wcy5tb2dfaW5pdF9yaW5ncyA9IGdlbV9pbml0X3Jpbmdz
Ow0KPiAtLQ0KPiAyLjcuNA0KPiANCj4g
