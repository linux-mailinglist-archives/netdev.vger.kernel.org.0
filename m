Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F3526E951E
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 03:55:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfJ3CzG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 22:55:06 -0400
Received: from mail-eopbgr1300092.outbound.protection.outlook.com ([40.107.130.92]:45600
        "EHLO APC01-HK2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726831AbfJ3CzG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 22:55:06 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=VrM32K1c7IupaBnamhw2KdWeGdWYk4dzxLI176ix0hDDWBA3X7ErgYi8CAvzjIn8hD6Rt6uJmBXhH7VsC3mRrWYP4wMwHJaLHh2gms6oG1SKOe4DLUIUeX9Rr7uHyc78HuZMvuyNFm+f0slxW6+xZN830l3+hHShOe17n2PvyQ+f4jQIjmeWPhthC0GtF/+Nfp3wLC3nwfCTmoENsAnp0jOeuWnzdxlnYF/CQS865CZCWDsGeHkgx8jhbyVyt7Jx5CAVwfLgMKcFmmVvpghO4mbe3bJp4KbQ5LHBMJPXCd7c38oNl1f8knx9J/EvVLFtbNY1WwNCzCh/9mC8Z6ys3g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxAei7q3lxZB5tOv5HgCrZZnY51nYQDWs+k711t3jJk=;
 b=j6TuwVUKG/wrdWb6p5SvqrwCuRJe+rek0wYMARpsxHImlc5JaxqIJiQycP2ZrndtFOQXXdYbuiiOJ6kLRcOkTMY2lrJBJEmpIJ8g6DxjT3bL2raFTYeKUhROs1xAtycm7HBJ9zFFj45/v1zOV43AgpudWK1nIEw5XFY0wllyUCimEJ9AoE4X10P2p+BfN/S/QFQKpPB8p7GdIUxnqY7JlaX4nl8+bwyuI2dR739viNT3jVKwt81zJJJ8U/HEN18/B+UQXBBpoNXfuXOPZgxsUQqBGD3TtgANsYhYX1y7oCY7dguNFeUEg5YWo9SCTY1O7Ug+tNAJ5+tefL4qjGnuuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=renesas.com; dmarc=pass action=none header.from=renesas.com;
 dkim=pass header.d=renesas.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=renesasgroup.onmicrosoft.com; s=selector2-renesasgroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=TxAei7q3lxZB5tOv5HgCrZZnY51nYQDWs+k711t3jJk=;
 b=sZCez8M/hpr8Ci3YqCwqXsbrDpeb5a4cAb/xU+Ta9W4QoJwhv+FpHhfkliUaptjLMrl5KWP/4PakeAfbWKQTG9sGohB3vOAyRDZjhBe27v9U1k68L8ydTRM9LW6jxl3S9YvxfFSHXuzkYGlLf+p5s5cTlmv/wULqfqQR5O4gC8s=
Received: from TY2PR01MB3034.jpnprd01.prod.outlook.com (20.177.100.140) by
 TY2PR01MB3241.jpnprd01.prod.outlook.com (20.177.100.149) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.25; Wed, 30 Oct 2019 02:54:59 +0000
Received: from TY2PR01MB3034.jpnprd01.prod.outlook.com
 ([fe80::3c2f:6301:8f68:4c37]) by TY2PR01MB3034.jpnprd01.prod.outlook.com
 ([fe80::3c2f:6301:8f68:4c37%6]) with mapi id 15.20.2387.025; Wed, 30 Oct 2019
 02:54:59 +0000
From:   Vincent Cheng <vincent.cheng.xh@renesas.com>
To:     Rob Herring <robh@kernel.org>
CC:     "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>
Subject: Re: [PATCH v3 1/2] dt-bindings: ptp: Add bindings doc for IDT
 ClockMatrix based PTP clock
Thread-Topic: [PATCH v3 1/2] dt-bindings: ptp: Add bindings doc for IDT
 ClockMatrix based PTP clock
Thread-Index: AQHViEnsnceJntXJaUCNpjtJej9X26drxUsAgAW6HgCAAK1EgIAAF+uAgABFnAA=
Date:   Wed, 30 Oct 2019 02:54:59 +0000
Message-ID: <20191030025447.GA17946@renesas.com>
References: <1571687868-22834-1-git-send-email-vincent.cheng.xh@renesas.com>
 <20191025193228.GA31398@bogus> <20191029145953.GA29825@renesas.com>
 <CAL_JsqLteAdjk+4KQ2hd5m16irT9_70EAxNWdTDLFHCZkex2Bg@mail.gmail.com>
 <20191030024539.GA13815@renesas.com>
In-Reply-To: <20191030024539.GA13815@renesas.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [173.195.53.163]
x-clientproxiedby: BY5PR17CA0005.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::18) To TY2PR01MB3034.jpnprd01.prod.outlook.com
 (2603:1096:404:7c::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=vincent.cheng.xh@renesas.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 6b75151d-207b-4fa1-f8fc-08d75ce48d9e
x-ms-traffictypediagnostic: TY2PR01MB3241:
x-microsoft-antispam-prvs: <TY2PR01MB3241B6D9B39CF00ACBB941EED2600@TY2PR01MB3241.jpnprd01.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1417;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(4636009)(376002)(39860400002)(396003)(366004)(346002)(136003)(199004)(189003)(51914003)(52116002)(229853002)(99286004)(76176011)(6486002)(186003)(6506007)(11346002)(26005)(66446008)(64756008)(66556008)(66476007)(66946007)(102836004)(86362001)(386003)(476003)(2616005)(486006)(478600001)(66066001)(4326008)(446003)(256004)(14444005)(81156014)(5660300002)(1076003)(81166006)(33656002)(8676002)(8936002)(305945005)(3846002)(6116002)(25786009)(36756003)(7736002)(2906002)(54906003)(316002)(6436002)(14454004)(6512007)(6246003)(71190400001)(6306002)(6916009)(71200400001);DIR:OUT;SFP:1102;SCL:1;SRVR:TY2PR01MB3241;H:TY2PR01MB3034.jpnprd01.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: renesas.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 54y6FpMKZk20BmRI8q69Of5JVqnJy0LSp+rEfLOwg5y8ebi9SSK3KlPE43oZdglJ3RtteJoRKghsZDfyCovotw2EaKyDk60JaNeNjtzhdYdAHqL6rOBAc+yKgSoEuthaoIFAnOz7yKTnyvSoOLUK+Ok50F8ZEyjLFplk0JIM7T5k/Nl9WjvWdsIzWSrivCTLEiLe/9xqY/d3iY7jz4swFib1YahA2OkoxWFTnOiM1vhXTuAjgh60GFOvMG9jGB+jcq+b5o+s57XMF+xEY8KKTPvgYXMIFP/y9dHd2FgZlkAP2hXIebjf0Wv/VCtuDQTpLLx4HnETRtiEERA52PTe7asRRdsTfw1OAd74PPOVs/4F3vCAe3ojZOEIJ6qpyWCa5mhJgVDvDdefD1YLb/qJ3WJpj9Z4ik13t1YcdKmXZpniNAW5jVP4PnN0geAWsBqA
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <369A3678C97CFF4DBF72B26E2267F83D@jpnprd01.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: renesas.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b75151d-207b-4fa1-f8fc-08d75ce48d9e
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 02:54:59.7307
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 53d82571-da19-47e4-9cb4-625a166a4a2a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0+fquMYXRfbGv7i9eeGI0GsyiqtubdqQ2drZi2R03lleVZdlR3x5aPrn0xeckzURoLnEHtki6Ui7V+GY0uY2S7TqrUewWBr3apTJYpUuYYA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: TY2PR01MB3241
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCBPY3QgMjksIDIwMTkgYXQgMTA6NDU6NTJQTSBFRFQsIFZpbmNlbnQgQ2hlbmcgd3Jv
dGU6DQo+T24gVHVlLCBPY3QgMjksIDIwMTkgYXQgMDU6MjA6MDNQTSBFRFQsIFJvYiBIZXJyaW5n
IHdyb3RlOg0KPj5PbiBUdWUsIE9jdCAyOSwgMjAxOSBhdCAxMDowMCBBTSBWaW5jZW50IENoZW5n
DQo+Pjx2aW5jZW50LmNoZW5nLnhoQHJlbmVzYXMuY29tPiB3cm90ZToNCj4+Pg0KPj4+IE9uIEZy
aSwgT2N0IDI1LCAyMDE5IGF0IDAzOjMyOjI4UE0gRURULCBSb2IgSGVycmluZyB3cm90ZToNCj4+
PiA+T24gTW9uLCBPY3QgMjEsIDIwMTkgYXQgMDM6NTc6NDdQTSAtMDQwMCwgdmluY2VudC5jaGVu
Zy54aEByZW5lc2FzLmNvbSB3cm90ZToNCj4+PiA+PiBGcm9tOiBWaW5jZW50IENoZW5nIDx2aW5j
ZW50LmNoZW5nLnhoQHJlbmVzYXMuY29tPg0KPj4+ID4+DQo+Pj4gPj4gQWRkIGRldmljZSB0cmVl
IGJpbmRpbmcgZG9jIGZvciB0aGUgSURUIENsb2NrTWF0cml4IFBUUCBjbG9jay4NCj4+PiA+Pg0K
Pj4+ID4+ICsNCj4+PiA+PiArZXhhbXBsZXM6DQo+Pj4gPj4gKyAgLSB8DQo+Pj4gPj4gKyAgICBw
aGNANWIgew0KPj4+ID4NCj4+PiA+cHRwQDViDQo+Pj4gPg0KPj4+ID5FeGFtcGxlcyBhcmUgYnVp
bHQgbm93IGFuZCB0aGlzIGZhaWxzOg0KPj4+ID4NCj4+PiA+RG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL3B0cC9wdHAtaWR0Y20uZXhhbXBsZS5kdHM6MTkuMTUtMjg6DQo+Pj4gPldh
cm5pbmcgKHJlZ19mb3JtYXQpOiAvZXhhbXBsZS0wL3BoY0A1YjpyZWc6IHByb3BlcnR5IGhhcyBp
bnZhbGlkIGxlbmd0aCAoNCBieXRlcykgKCNhZGRyZXNzLWNlbGxzID09IDEsICNzaXplLWNlbGxz
ID09IDEpDQo+Pj4gPg0KPj4+ID5UaGUgcHJvYmxlbSBpcyBpMmMgZGV2aWNlcyBuZWVkIHRvIGJl
IHNob3duIHVuZGVyIGFuIGkyYyBidXMgbm9kZS4NCj4+PiA+DQo+Pj4gPj4gKyAgICAgICAgICBj
b21wYXRpYmxlID0gImlkdCw4YTM0MDAwIjsNCj4+PiA+PiArICAgICAgICAgIHJlZyA9IDwweDVi
PjsNCj4+PiA+PiArICAgIH07DQo+Pj4NCj4+PiBJIGFtIHRyeWluZyB0byByZXBsaWNhdGUgdGhl
IHByb2JsZW0gbG9jYWxseSB0byBjb25maXJtIHRoZSBmaXggcHJpb3IgdG8gcmUtc3VibWlzc2lv
bi4NCj4+Pg0KPj4+IEkgaGF2ZSB0cmllZCB0aGUgZm9sbG93aW5nOg0KPj4+DQo+Pj4gLi90b29s
cy9kdC1kb2MtdmFsaWRhdGUgfi9wcm9qZWN0cy9saW51eC9Eb2N1bWVudGF0aW9uL2RldmljZXRy
ZWUvYmluZGluZ3MvcHRwL3B0cC1pZHRjbS55YW1sDQo+Pj4gLi90b29scy9kdC1leHRyYWN0LWV4
YW1wbGUgfi9wcm9qZWN0cy9saW51eC9Eb2N1bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3Mv
cHRwL3B0cC1pZHRjbS55YW1sID4gZXhhbXBsZS5kdHMNCj4+Pg0KPj4+IEhvdyB0byB2YWxpZGF0
ZSB0aGUgZXhhbXBsZS5kdHMgZmlsZSBhZ2FpbnN0IHRoZSBzY2hlbWEgaW4gcHRwLWlkdGNtLnlh
bWw/DQo+Pg0KPj4nbWFrZSAtayBkdF9iaW5kaW5nX2NoZWNrJyBpbiB0aGUga2VybmVsIHRyZWUu
DQo+DQo+VGhhbmtzIGZvciB0aGUgdGlwIC0gdGhhdCBsZWQgbWUgdG8gcmUtZGlzY292ZXIgd3Jp
dGUtc2NoZW1hLnJzdA0KPg0KPkRpZCB0aGUgZm9sbG93aW5nIHRvIGVuc3VyZSBkdC1zY2hlbWEg
YW5kIHlhbWwgaXMgaW5zdGFsbGVkOg0KPiQgcGlwMyBpbnN0YWxsIGdpdCtodHRwczovL2dpdGh1
Yi5jb20vZGV2aWNldHJlZS1vcmcvZHQtc2NoZW1hLmdpdEBtYXN0ZXINCj4NCj4kIHBrZy1jb25m
aWcgLS1leGlzdHMgeWFtbC0wLjEgJiYgZWNobyB5ZXMNCj55ZXMNCj4NCj4kIHBrZy1jb25maWcg
eWFtbC0wLjEgLS1saWJzDQo+LWx5YW1sDQo+DQo+DQo+SG93ZXZlciwgSSBnZXQgJ05vIHJ1bGUg
dG8gbWFrZSB0YXJnZXQiIGVycm9yIHdpdGggJ21ha2UgLWsgZHRfYmluZGluZ19jaGVjaycuDQo+
DQo+T24gbGludXg6IFR1ZSBPY3QgMjksIGNvbW1pdCAyM2ZkYjE5OGFlOA0KPg0KPiQgbWFrZSAt
ayBkdF9iaW5kaW5nX2NoZWNrIFwNCj4gICAgRFRfU0NIRU1BX0ZJTEVTPURvY3VtZW50YXRpb24v
ZGV2aWNldHJlZS9iaW5kaW5ncy90cml2aWFsLWRldmljZXMueWFtbA0KPiAgU0NIRU1BICBEb2N1
bWVudGF0aW9uL2RldmljZXRyZWUvYmluZGluZ3MvcHJvY2Vzc2VkLXNjaGVtYS55YW1sDQo+ICBD
SEtEVCAgIERvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy90cml2aWFsLWRldmljZXMu
eWFtbA0KPm1ha2VbMV06ICoqKiBObyBydWxlIHRvIG1ha2UgdGFyZ2V0DQo+CSdEb2N1bWVudGF0
aW9uL2RldmljZXRyZWUvYmluZGluZ3MvdHJpdmlhbC1kZXZpY2VzLmV4YW1wbGUuZHQueWFtbCcs
DQo+CSBuZWVkZWQgYnkgJ19fYnVpbGQnLg0KPgkJCQkJCQkJDQo+T24gbGludXgtbmV4dC1taXJy
b3I6IFR1ZSBPY3QgMjksIGNvbW1pdCBjNTdjZjM4MzNjNg0KPg0KPiQgbWFrZSAtayBkdF9iaW5k
aW5nX2NoZWNrIFwNCj4JRFRfU0NIRU1BX0ZJTEVTPURvY3VtZW50YXRpb24vZGV2aWNldHJlZS9i
aW5kaW5ncy90cml2aWFsLWRldmljZXMueWFtbA0KPiAgU0NIRU1BICBEb2N1bWVudGF0aW9uL2Rl
dmljZXRyZWUvYmluZGluZ3MvcHJvY2Vzc2VkLXNjaGVtYS55YW1sDQo+ICBDSEtEVCAgIERvY3Vt
ZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy90cml2aWFsLWRldmljZXMueWFtbA0KPm1ha2Vb
MV06ICoqKiBObyBydWxlIHRvIG1ha2UgdGFyZ2V0IA0KPgknRG9jdW1lbnRhdGlvbi9kZXZpY2V0
cmVlL2JpbmRpbmdzL3RyaXZpYWwtZGV2aWNlcy5leGFtcGxlLmR0LnlhbWwnLCANCj4JbmVlZGVk
IGJ5ICdfX2J1aWxkJy4NCj4NCj5JIHdpbGwga2VlcCBnb29nbGluZywgYnV0IGFueSB0aXBzIHdp
bGwgYmUgZ3JlYXRseSBhcHByZWNpYXRlZC4NCg0KUGxlYXNlIGlnbm9yZSwgSSBmaWd1cmVkIGl0
IG91dC4NCg0KJ21ha2UgLWsgZHRfYmluZGluZyBjaGVjayBBUkNIPWFybScgd29ya3Mgd2l0aG91
dCBtYWtlIGVycm9ycy4NCg0KUmVnYXJkcywNClZpbmNlbnQNCg==
