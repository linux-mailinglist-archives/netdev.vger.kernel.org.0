Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB554510C5
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 17:38:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731195AbfFXPia (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 11:38:30 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:13600 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726880AbfFXPi2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 11:38:28 -0400
Received-SPF: Pass (esa6.microchip.iphmx.com: domain of
  Nicolas.Ferre@microchip.com designates 198.175.253.82 as
  permitted sender) identity=mailfrom;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="Nicolas.Ferre@microchip.com";
  x-conformance=spf_only; x-record-type="v=spf1";
  x-record-text="v=spf1 mx a:ushub1.microchip.com
  a:smtpout.microchip.com a:mx1.microchip.iphmx.com
  a:mx2.microchip.iphmx.com include:servers.mcsv.net
  include:mktomail.com include:spf.protection.outlook.com ~all"
Received-SPF: None (esa6.microchip.iphmx.com: no sender
  authenticity information available from domain of
  postmaster@email.microchip.com) identity=helo;
  client-ip=198.175.253.82; receiver=esa6.microchip.iphmx.com;
  envelope-from="Nicolas.Ferre@microchip.com";
  x-sender="postmaster@email.microchip.com";
  x-conformance=spf_only
Authentication-Results: esa6.microchip.iphmx.com; spf=Pass smtp.mailfrom=Nicolas.Ferre@microchip.com; spf=None smtp.helo=postmaster@email.microchip.com; dkim=pass (signature verified) header.i=@microchiptechnology.onmicrosoft.com; dmarc=pass (p=none dis=none) d=microchip.com
X-IronPort-AV: E=Sophos;i="5.63,412,1557212400"; 
   d="scan'208";a="35625180"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2019 08:38:27 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.87.151) by
 chn-vm-ex03.mchp-main.com (10.10.87.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 24 Jun 2019 08:37:28 -0700
Received: from NAM04-BN3-obe.outbound.protection.outlook.com (10.10.215.89) by
 email.microchip.com (10.10.87.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 24 Jun 2019 08:37:27 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microchiptechnology.onmicrosoft.com;
 s=selector1-microchiptechnology-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Z8Vw1y174E7oyZoYvXlSn3C/Ka4yfqqxb9UEYX1Ezk=;
 b=sn2HlGn3AFoGH99UgovOLUjWVdiafpuwFnURmVO2yqFzlVQNk5KTcbT49oLfMGuoOENrHN7FN3jeJUrCLS0r7SayaPkqQibl9CLfJb8+AyKitxdkDhE/XPw/NLDAiOaFIxmCFxE68cEvUlVJgjxKyTA40b5SLUj8Rh5XGWFYmng=
Received: from MWHPR11MB1662.namprd11.prod.outlook.com (10.172.55.15) by
 MWHSPR00MB242.namprd11.prod.outlook.com (10.169.207.151) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.13; Mon, 24 Jun 2019 15:38:23 +0000
Received: from MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3]) by MWHPR11MB1662.namprd11.prod.outlook.com
 ([fe80::7534:63dc:8504:c2b3%6]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 15:38:23 +0000
From:   <Nicolas.Ferre@microchip.com>
To:     <robh+dt@kernel.org>, <yash.shah@sifive.com>
CC:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-riscv@lists.infradead.org>,
        <devicetree@vger.kernel.org>, <mark.rutland@arm.com>,
        <palmer@sifive.com>, <aou@eecs.berkeley.edu>, <ynezz@true.cz>,
        <paul.walmsley@sifive.com>, <sachin.ghadi@sifive.com>
Subject: Re: [PATCH 1/2] net/macb: bindings doc: add sifive fu540-c000 binding
Thread-Topic: [PATCH 1/2] net/macb: bindings doc: add sifive fu540-c000
 binding
Thread-Index: AQHVKqLbM22kFcE4xk2eilNUVLOx5w==
Date:   Mon, 24 Jun 2019 15:38:23 +0000
Message-ID: <b0c60ec9-2f57-c3f5-c3b4-ee83a5ec4c45@microchip.com>
References: <1558611952-13295-1-git-send-email-yash.shah@sifive.com>
 <1558611952-13295-2-git-send-email-yash.shah@sifive.com>
 <CAL_Jsq+p5PnTDgxuh9_Aw1RvTk4aTYjKxyMq7DPczLzQVv8_ew@mail.gmail.com>
In-Reply-To: <CAL_Jsq+p5PnTDgxuh9_Aw1RvTk4aTYjKxyMq7DPczLzQVv8_ew@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P265CA0406.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:f::34) To MWHPR11MB1662.namprd11.prod.outlook.com
 (2603:10b6:301:e::15)
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [213.41.198.74]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 290f0a53-2d13-42a3-dab0-08d6f8b9fde6
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(2017052603328)(7193020);SRVR:MWHSPR00MB242;
x-ms-traffictypediagnostic: MWHSPR00MB242:
x-microsoft-antispam-prvs: <MWHSPR00MB2422390040E3DA84F4ECFD6E0E00@MWHSPR00MB242.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(39860400002)(346002)(376002)(366004)(136003)(189003)(199004)(6436002)(26005)(68736007)(6116002)(476003)(6512007)(110136005)(36756003)(6486002)(52116002)(73956011)(76176011)(66556008)(2906002)(3846002)(53936002)(72206003)(31686004)(66476007)(66946007)(11346002)(64756008)(478600001)(4326008)(99286004)(14454004)(25786009)(446003)(2616005)(66446008)(86362001)(102836004)(229853002)(53546011)(186003)(6506007)(6246003)(54906003)(316002)(486006)(5660300002)(66066001)(31696002)(386003)(71200400001)(7416002)(305945005)(71190400001)(8936002)(81156014)(81166006)(8676002)(7736002)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:MWHSPR00MB242;H:MWHPR11MB1662.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: microchip.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: QNtqDVoxysryNHIC74fIbsrkiCeObMpZohIvR4w1aKNnVNyCM/BiSdfNTl7hSloeV5r4YJcunx9VV3i+DKARv4WG04vLbqzj+dMxJGB4gmllN67LpWwVfqM4otEbxZ3iPy7+6Tb+IwKhb6ecARkisf2NorWGmdyIT5ycYjzo+2up4QEwKnU7TnyeXZErOyOKKy4tSjTzgcR53nQPksGgPcqz19DVmObu4wo9JyzXDoZMV6glvm2NDoFONiIp4WnE0eLNXnXvan9FqqWke4Et8B3LVGrcVaAr6QVQ35zIqEYCZT6wrygcDQrHd2eCwzebYpyqzzShfFtxeQOgJGptT/uF5A0bVLALfijovmrEyRXcsCE1nZ8ngKPHaHxlmw6GKjsma3rTZHK8xpzevKa8r+3xGjVeF0aP/Hh75q2W8tU=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BF668DD5250ADD4CA5B56765716862D1@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-Network-Message-Id: 290f0a53-2d13-42a3-dab0-08d6f8b9fde6
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 15:38:23.4499
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

T24gMjMvMDUvMjAxOSBhdCAyMjo1MCwgUm9iIEhlcnJpbmcgd3JvdGU6DQo+IE9uIFRodSwgTWF5
IDIzLCAyMDE5IGF0IDY6NDYgQU0gWWFzaCBTaGFoIDx5YXNoLnNoYWhAc2lmaXZlLmNvbT4gd3Jv
dGU6DQo+Pg0KPj4gQWRkIHRoZSBjb21wYXRpYmlsaXR5IHN0cmluZyBkb2N1bWVudGF0aW9uIGZv
ciBTaUZpdmUgRlU1NDAtQzAwMDANCj4+IGludGVyZmFjZS4NCj4+IE9uIHRoZSBGVTU0MCwgdGhp
cyBkcml2ZXIgYWxzbyBuZWVkcyB0byByZWFkIGFuZCB3cml0ZSByZWdpc3RlcnMgaW4gYQ0KPj4g
bWFuYWdlbWVudCBJUCBibG9jayB0aGF0IG1vbml0b3JzIG9yIGRyaXZlcyBib3VuZGFyeSBzaWdu
YWxzIGZvciB0aGUNCj4+IEdFTUdYTCBJUCBibG9jayB0aGF0IGFyZSBub3QgZGlyZWN0bHkgbWFw
cGVkIHRvIEdFTUdYTCByZWdpc3RlcnMuDQo+PiBUaGVyZWZvcmUsIGFkZCBhZGRpdGlvbmFsIHJh
bmdlIHRvICJyZWciIHByb3BlcnR5IGZvciBTaUZpdmUgR0VNR1hMDQo+PiBtYW5hZ2VtZW50IElQ
IHJlZ2lzdGVycy4NCj4+DQo+PiBTaWduZWQtb2ZmLWJ5OiBZYXNoIFNoYWggPHlhc2guc2hhaEBz
aWZpdmUuY29tPg0KPj4gLS0tDQo+PiAgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvbWFjYi50eHQgfCAzICsrKw0KPj4gICAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL0RvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5n
cy9uZXQvbWFjYi50eHQgYi9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvbmV0L21h
Y2IudHh0DQo+PiBpbmRleCA5YzVlOTQ0Li45MWEyYTY2IDEwMDY0NA0KPj4gLS0tIGEvRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tYWNiLnR4dA0KPj4gKysrIGIvRG9jdW1l
bnRhdGlvbi9kZXZpY2V0cmVlL2JpbmRpbmdzL25ldC9tYWNiLnR4dA0KPj4gQEAgLTQsNiArNCw3
IEBAIFJlcXVpcmVkIHByb3BlcnRpZXM6DQo+PiAgIC0gY29tcGF0aWJsZTogU2hvdWxkIGJlICJj
ZG5zLFs8Y2hpcD4tXXttYWNifGdlbX0iDQo+PiAgICAgVXNlICJjZG5zLGF0OTFybTkyMDAtZW1h
YyIgQXRtZWwgYXQ5MXJtOTIwMCBTb0MuDQo+PiAgICAgVXNlICJjZG5zLGF0OTFzYW05MjYwLW1h
Y2IiIGZvciBBdG1lbCBhdDkxc2FtOSBTb0NzLg0KPj4gKyAgVXNlICJjZG5zLGZ1NTQwLW1hY2Ii
IGZvciBTaUZpdmUgRlU1NDAtQzAwMCBTb0MuDQo+IA0KPiBUaGlzIHBhdHRlcm4gdGhhdCBBdG1l
bCBzdGFydGVkIGlzbid0IHJlYWxseSBjb3JyZWN0LiBUaGUgdmVuZG9yDQo+IHByZWZpeCBoZXJl
IHNob3VsZCBiZSBzaWZpdmUuICdjZG5zJyB3b3VsZCBiZSBhcHByb3ByaWF0ZSBmb3IgYQ0KPiBm
YWxsYmFjay4NCg0KT2ssIHdlIG1pc3NlZCB0aGlzIGZvciB0aGUgc2FtOXg2MCBTb0MgdGhhdCB3
ZSBhZGRlZCByZWNlbnRseSB0aGVuLg0KDQpBbnl3YXkgYSBsaXR0bGUgdG9vIGxhdGUsIGNvbWlu
ZyBiYWNrIHRvIHRoaXMgbWFjaGluZSwgYW5kIHRhbGtpbmcgdG8gDQpZYXNoLCBpc24ndCAic2lm
aXZlLGZ1NTQwLWMwMDAtbWFjYiIgbW9yZSBzcGVjaWZpYyBhbmQgYSBiZXR0ZXIgbWF0Y2ggDQpm
b3IgYmVpbmcgZnV0dXJlIHByb29mPyBJIHdvdWxkIGFkdmljZSBmb3IgdGhlIG1vc3Qgc3BlY2lm
aWMgcG9zc2libGUgDQp3aXRoIG90aGVyIGNvbXBhdGlibGUgc3RyaW5ncyBvbiB0aGUgc2FtZSBs
aW5lIGluIHRoZSBEVCwgbGlrZToNCg0KInNpZml2ZSxmdTU0MC1jMDAwLW1hY2IiLCAic2lmaXZl
LGZ1NTQwLW1hY2IiDQoNCk1vcmVvdmVyLCBpcyBpdCByZWFsbHkgYSAibWFjYiIgb3IgYSAiZ2Vt
IiB0eXBlIG9mIGludGVyZmFjZSBmcm9tIA0KQ2FkZW5jZT8gTm90IGEgYmlnIGRlYWwsIGJ1dCBq
dXN0IHRvIGRpc2N1c3MgdGhlIHRvcGljIHRvIHRoZSBib25lLi4uDQoNCk5vdGUgdGhhdCBJJ20g
ZmluZSBpZiB5b3UgY29uc2lkZXIgdGhhdCB3aGF0IHlvdSBoYXZlIGluIG5ldC1uZXh0IG5ldyBp
cyANCmNvcnJlY3QuDQoNClJlZ2FyZHMsDQogICBOaWNvbGFzDQoNCj4+ICAgICBVc2UgImNkbnMs
c2FtOXg2MC1tYWNiIiBmb3IgTWljcm9jaGlwIHNhbTl4NjAgU29DLg0KPj4gICAgIFVzZSAiY2Ru
cyxucDQtbWFjYiIgZm9yIE5QNCBTb0MgZGV2aWNlcy4NCj4+ICAgICBVc2UgImNkbnMsYXQzMmFw
NzAwMC1tYWNiIiBmb3Igb3RoZXIgMTAvMTAwIHVzYWdlIG9yIHVzZSB0aGUgZ2VuZXJpYyBmb3Jt
OiAiY2RucyxtYWNiIi4NCj4+IEBAIC0xNyw2ICsxOCw4IEBAIFJlcXVpcmVkIHByb3BlcnRpZXM6
DQo+PiAgICAgVXNlICJjZG5zLHp5bnFtcC1nZW0iIGZvciBaeW5xIFVsdHJhc2NhbGUrIE1QU29D
Lg0KPj4gICAgIE9yIHRoZSBnZW5lcmljIGZvcm06ICJjZG5zLGVtYWMiLg0KPj4gICAtIHJlZzog
QWRkcmVzcyBhbmQgbGVuZ3RoIG9mIHRoZSByZWdpc3RlciBzZXQgZm9yIHRoZSBkZXZpY2UNCj4+
ICsgICAgICAgRm9yICJjZG5zLGZ1NTQwLW1hY2IiLCBzZWNvbmQgcmFuZ2UgaXMgcmVxdWlyZWQg
dG8gc3BlY2lmeSB0aGUNCj4+ICsgICAgICAgYWRkcmVzcyBhbmQgbGVuZ3RoIG9mIHRoZSByZWdp
c3RlcnMgZm9yIEdFTUdYTCBNYW5hZ2VtZW50IGJsb2NrLg0KPj4gICAtIGludGVycnVwdHM6IFNo
b3VsZCBjb250YWluIG1hY2IgaW50ZXJydXB0DQo+PiAgIC0gcGh5LW1vZGU6IFNlZSBldGhlcm5l
dC50eHQgZmlsZSBpbiB0aGUgc2FtZSBkaXJlY3RvcnkuDQo+PiAgIC0gY2xvY2stbmFtZXM6IFR1
cGxlIGxpc3RpbmcgaW5wdXQgY2xvY2sgbmFtZXMuDQo+PiAtLQ0KPj4gMS45LjENCj4+DQo+IA0K
DQoNCi0tIA0KTmljb2xhcyBGZXJyZQ0K
