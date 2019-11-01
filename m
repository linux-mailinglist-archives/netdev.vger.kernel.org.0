Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59378ECA44
	for <lists+netdev@lfdr.de>; Fri,  1 Nov 2019 22:28:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726927AbfKAV21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Nov 2019 17:28:27 -0400
Received: from mail-eopbgr50087.outbound.protection.outlook.com ([40.107.5.87]:37101
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726023AbfKAV21 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 1 Nov 2019 17:28:27 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ldcnTZl9Atmyx2Z2nz1qxRFWVqijHMPqq4jYtHkiWit0M2J50PzvYAqhvYSOs6nzFxbwFI9hWHQ9XRi69aTZK+G3K8hnl5NxloP0zAP1ONfzY7InCTNYL9l3NViM2tftWyiyYVyHBy7re1me6wfOheNB53S3ppnMfTJYOtabJ7Ycbt7rftlJAfEeyPnkOCcjDNxuSWhl1fld8qEm5OIbx2vIcksRD/ay/m/OFu45QAHtHuRV/KkSUzWGzSPAGrxLTsNjPsoK1tcQkn9oDH92Pw0I518Lnv48B+gkm7FJPIz+fBHxcMODWN0G3TVIf/wTgIRfQ+Qb2fMmEXbnyJsg+A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9iBY+GpA4ZJ1EEfXkqDy21kO9TV/ldmHuo9oF7t6jc=;
 b=Qn3L+hLHKx5l+YxqggoMWbA4iNFBZyLuqrUP8BWMs1PsFcIz3MFWjhq0yyFbr96rflIyMJqK2p2k588b148GdHH5hs9P730MS1QV2LF/OUunmcqp1SgW5jODPtZWIo4aaKRLH6Z80JhrcKLHmIOUqYyht0UINOs/ER1JFOPkWAZNYtP8Qnxu6YULGe+5PVWu6pVoPBpJbLIMhU5NHdXdAJH3FiuMLSNWWkdwhTCwEBEV0ylQEnR9xWxD4eAF7+/tsY/Qe6ydnRktQAaTX7Zwj0qYVyRW8okL2KVeRfk/NomqrSP0/SKJaeK4SQErFS8IACSFSktDS76HLlD8Z2RsGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j9iBY+GpA4ZJ1EEfXkqDy21kO9TV/ldmHuo9oF7t6jc=;
 b=sLD74SW8cPQmX1tCZn4mZS6bAXe/k9qyWi8iYVuaK3p6B3H7F7qAged4G+EwiQAqqOmBuz4tmiZS4W2g6KccOSQPZvZpaV3TDS3xYGXAmqG44/8gCF9R+CQblAIAvnba9BdMd/uKP92D1yssdOkqWHgqvfvGk4OEv+qrGO07KiU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5712.eurprd05.prod.outlook.com (20.178.121.214) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Fri, 1 Nov 2019 21:28:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Fri, 1 Nov 2019
 21:28:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Ariel Levkovich <lariel@mellanox.com>,
        "jakub.kicinski@netronome.com" <jakub.kicinski@netronome.com>
CC:     "dsahern@gmail.com" <dsahern@gmail.com>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        "stephen@networkplumber.org" <stephen@networkplumber.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [PATCH net-next v2 0/3] VGT+ support
Thread-Topic: [PATCH net-next v2 0/3] VGT+ support
Thread-Index: AQHVkCQFGdJo5Spx4U2AGUa6mmGmtKd1dOQAgAFEboCAABz2AA==
Date:   Fri, 1 Nov 2019 21:28:22 +0000
Message-ID: <6e0a2b89b4ef56daca9a154fa8b042e7f06632a4.camel@mellanox.com>
References: <1572551213-9022-1-git-send-email-lariel@mellanox.com>
         <20191031172330.58c8631a@cakuba.netronome.com>
         <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
In-Reply-To: <8d7db56c-376a-d809-4a65-bfc2baf3254f@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bb348160-36de-40d6-f703-08d75f126c39
x-ms-traffictypediagnostic: VI1PR05MB5712:|VI1PR05MB5712:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB57120298AA730E43FD7F989BBE620@VI1PR05MB5712.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 020877E0CB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(376002)(366004)(396003)(39860400002)(346002)(189003)(199004)(76116006)(6306002)(66946007)(6246003)(107886003)(91956017)(966005)(64756008)(66446008)(66556008)(66476007)(446003)(11346002)(476003)(486006)(2616005)(4326008)(14454004)(6486002)(58126008)(110136005)(86362001)(186003)(316002)(229853002)(2501003)(53546011)(36756003)(6506007)(3846002)(102836004)(6116002)(26005)(54906003)(76176011)(5660300002)(256004)(66066001)(14444005)(25786009)(81156014)(71190400001)(71200400001)(99286004)(478600001)(118296001)(7736002)(305945005)(6436002)(6512007)(81166006)(2906002)(8936002)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5712;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IgkSQ8Aj8X24LRtAq+cJCS3/mTt4zZhG2uuLyocv5AIo7EXWus74W2Zggubm3RbJKRN/BUebQzF36m0+85CE9kRc5emBO/1vKUSOecHabSCFva83RBmrORpRl7uYGeehHkrCfv2dOcqRW/cKjsFMgJeB7E33gWk1T3ONftdy78BuvtlEQyEMQpp+YwD3HHmGk93qTKxpDNqu9DtRWwKRNeCwcgMzQA7I50t4+ib+QVhprHBwZ4c02KjvvaBYwg84YvI+mRGXCuNdXjTGRQmeXqFmTiYH70Vn3STMEb9uRDgSug8550flfetJpevhXr2Fb6cbIbAaYTZJNyFU1Vo2NyZb90I5IR3+PFllQn9zCX7mAU/F8JQtniPSvefwi6p5iAGuWmTWSsprYx+PGS2aUxo4OnssbgyeBzJp7zKxjz3pVpcCKJyAoXZNjIxPq7F63G9rPEggKd+iIC3u81G3zKL/2AknWfbePtn2KLtXY/k=
Content-Type: text/plain; charset="utf-8"
Content-ID: <C19D0014E1411F4DAF17AD60798E425B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bb348160-36de-40d6-f703-08d75f126c39
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Nov 2019 21:28:22.4403
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vaegdwG+Iqu6UUS0mhSZuDidSj3TwDR8d1LxdwQuDKtJDJI7vh0KgJMh7TjJ4x0WD1fXd8/+U1hyU0dNWUVKCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5712
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTExLTAxIGF0IDE5OjQ0ICswMDAwLCBBcmllbCBMZXZrb3ZpY2ggd3JvdGU6
DQo+IE9uIDEwLzMxLzE5IDg6MjMgUE0sIEpha3ViIEtpY2luc2tpIDxqYWt1Yi5raWNpbnNraUBu
ZXRyb25vbWUuY29tPg0KPiB3cm90ZToNCj4gPiBPbiBUaHUsIDMxIE9jdCAyMDE5IDE5OjQ3OjI1
ICswMDAwLCBBcmllbCBMZXZrb3ZpY2ggd3JvdGU6DQo+ID4gPiBUaGUgZm9sbG93aW5nIHNlcmll
cyBpbnRyb2R1Y2VzIFZHVCsgc3VwcG9ydCBmb3IgU1JJT1YgdmYNCj4gPiA+IGRldmljZXMuDQo+
ID4gPiANCj4gPiA+IFZHVCsgaXMgYW4gZXh0ZW50aW9uIG9mIHRoZSBWR1QgKFZpcnR1YWwgR3Vl
c3QgVGFnZ2luZykNCj4gPiA+IHdoZXJlIHRoZSBndWVzdCBpcyBpbiBjaGFyZ2Ugb2YgdmxhbiB0
YWdnaW5nIHRoZSBwYWNrZXRzDQo+ID4gPiBvbmx5IHdpdGggVkdUKyB0aGUgYWRtaW4gY2FuIGxp
bWl0IHRoZSBhbGxvd2VkIHZsYW4gaWRzDQo+ID4gPiB0aGUgZ3Vlc3QgY2FuIHVzZSB0byBhIHNw
ZWNpZmljIHZsYW4gdHJ1bmsgbGlzdC4NCj4gPiA+IA0KPiA+ID4gVGhlIHBhdGNoZXMgaW50cm9k
dWNlIHRoZSBBUEkgZm9yIGFkbWluIHVzZXJzIHRvIHNldCBhbmQNCj4gPiA+IHF1ZXJ5IHRoZXNl
IHZsYW4gdHJ1bmsgbGlzdHMgb24gdGhlIHZmcyB1c2luZyBuZXRsaW5rDQo+ID4gPiBjb21tYW5k
cy4NCj4gPiA+IA0KPiA+ID4gY2hhbmdlcyBmcm9tIHYxIHRvIHYyOg0KPiA+ID4gLSBGaXhlZCBp
bmRlbnRhdGlvbiBvZiBSVEVYVF9GSUxURVJfU0tJUF9TVEFUUy4NCj4gPiA+IC0gQ2hhbmdlZCB2
Zl9leHQgcGFyYW0gdG8gYm9vbC4NCj4gPiA+IC0gQ2hlY2sgaWYgVkYgbnVtIGV4Y2VlZHMgdGhl
IG9wZW5lZCBWRnMgcmFuZ2UgYW5kIHJldHVybiB3aXRob3V0DQo+ID4gPiBhZGRpbmcgdGhlIHZm
aW5mby4NCj4gPiANCj4gPiBJZiB5b3UgcmVwb3N0IHNvbWV0aGluZyB3aXRob3V0IGFkZHJlc3Np
bmcgZmVlZGJhY2sgeW91IHJlY2VpdmVkDQo+ID4geW91DQo+ID4gX2hhdmVfIF90b18gZGVzY3Jp
YmUgd2hhdCB0aGF0IGZlZWRiYWNrIHdhcyBhbmQgd2h5IGl0IHdhcyBpZ25vcmVkDQo+ID4gaW4g
DQo+ID4gdGhlIGNvdmVyIGxldHRlciBvZiB0aGUgbmV3IHBvc3RpbmcsIHBsZWFzZSBhbmQgdGhh
bmsgeW91Lg0KPiANCj4gUmlnaHQsIEkgbXVzdCd2ZSBtaXNzZWQgdGhhdC4NCj4gDQo+IEkgcmUg
cG9zdGVkIHRoZSBwYXRjaGVzIHRvIGFkZHJlc3MgdGhlIGNvZGUgcmVsYXRlZCBmZWVkYmFjayBm
cm9tDQo+IFN0ZXBoZW4gd2hpbGUNCj4gDQo+IHdlIGNvbnRpbnVlIHRoZSBkaXNjdXNzaW9uIG9u
IHRoZSBjb25jZXB0IG9mIGxlZ2FjeSBtb2RlIGZlYXR1cmVzLg0KPiANCj4gT24gMTAvMzAvMTkg
eW91IHdyb3RlOg0KPiANCj4gICAgICINCj4gDQo+ICAgICBUaGUgIndlIGRvbid0IHdhbnQgYW55
IG1vcmUgbGVnYWN5IFZGIG5kb3MiIHBvbGljeSB3aGljaCBJIHRoaW5rDQo+IHdlDQo+ICAgICB3
YW50ZWQgdG8gZm9sbG93IGlzIG11Y2ggZWFzaWVyIHRvIHN0aWNrIHRvIHRoYW4gIndlIGRvbid0
IHdhbnQNCj4gYW55DQo+ICAgICBtb3JlIGxlZ2FjeSBWRiBuZG9zLCB1bmxlc3MuLiIuDQo+ICAg
IA0KPiAgICAgVGhlcmUncyBub3RoaW5nIGhlcmUgdGhhdCBjYW4ndCBiZSBkb25lIGluIHN3aXRj
aGRldiBtb2RlDQo+IChwZXJoYXBzDQo+ICAgICBicmlkZ2Ugb2ZmbG9hZCB3b3VsZCBhY3R1YWxs
eSBiZSBtb3JlIHN1aXRhYmxlIHRoYW4ganVzdCBmbG93ZXIpLA0KPiAgICAgYW5kIHRoZSB1QVBJ
IGV4dGVuc2lvbiBpcyBub3QgYW4gaW5zaWduaWZpY2FudCBvbmUuDQo+ICAgIA0KPiAgICAgSSBk
b24ndCB0aGluayB3ZSBzaG91bGQgYmUgZ3Jvd2luZyBib3RoIGxlZ2FjeSBhbmQgc3dpdGNoZGV2
DQo+IEFQSXMsIGF0DQo+ICAgICBzb21lIHBvaW50IHdlIGdvdCB0byBwaWNrIG9uZS4gVGhlIHN3
aXRjaGRldiBleHRlbnNpb24gdG8gc2V0DQo+IGh3YWRkcg0KPiAgICAgZm9yIHdoaWNoIHBhdGNo
ZXMgd2VyZSBwb3N0ZWQgcmVjZW50bHkgaGFkIGJlZW4gaW1wbGVtZW50ZWQNCj4gdGhyb3VnaA0K
PiAgICAgbGVnYWN5IEFQSSBhIHdoaWxlIGFnbyAoYnkgQ2hlbHNpbyBJSVJDKSBzbyBpdCdzIG5v
dCB0aGF0IHdlJ3JlDQo+IGxvb2tpbmcNCj4gICAgIHRvd2FyZHMgc3dpdGNoZGV2IHdoZXJlIGxl
Z2FjeSBBUEkgaXMgaW1wb3NzaWJsZSB0byBleHRlbmQuIEl0J3MNCj4gcHVyZWx5DQo+ICAgICBh
IHBvbGljeSBkZWNpc2lvbiB0byBwaWNrIG9uZSBhbmQgZGVwcmVjYXRlIHRoZSBvdGhlci4NCj4g
ICAgDQo+ICAgICBPbmx5IGlmIHdlIGZyZWV6ZSB0aGUgbGVnYWN5IEFQSSBjb21wbGV0ZWx5IHdp
bGwgdGhlDQo+IG9yY2hlc3RyYXRpb24NCj4gICAgIGxheWVycyBoYXZlIGFuIGluY2VudGl2ZSB0
byBzdXBwb3J0IHN3aXRjaGRldi4gQW5kIHdlIGNhbiBzYXZlDQo+IHRoZSBmZXcNCj4gICAgIGh1
bmRyZWQgbGluZXMgb2YgY29kZSBwZXIgZmVhdHVyZSBpbiBldmVyeSBkcml2ZXIuLg0KPiAgICAg
Ig0KPiANCj4gDQo+IFVuZm9ydHVuYXRlbHksIGxpa2UgU2FlZWQgYW5kIHlvdXJzZWxmIG1lbnRp
b25lZCwgd2Ugc3RpbGwgZmFjZQ0KPiBjdXN0b21lcnMgdGhhdCBhcmUNCj4gDQo+IHJlZnVzaW5n
IHRvIG1vdmUgdG8gc3dpdGNoZGV2IHdoaWxlIHJlcXVpcmluZyBmZWF0dXJlIGFuZA0KPiBjYXBh
YmlsaXRpZXMNCj4gDQo+IGluIHZpcnR1YWwgZW52aXJvbm1lbnRzLg0KPiANCj4gDQo+IA0KPiBX
ZSBoYXZlIHNldmVyYWwgY29uZmlndXJhdGlvbnMgYXZhaWxhYmxlIHRvZGF5IGZvciBsZWdhY3kg
dGhhdA0KPiBpbmNsdWRlIHZsYW4gc2V0dGluZ3MNCj4gZm9yIHRoZSBWRi4NCj4gSSBrbm93IHRo
YXQgd2UgZGVjaWRlZCB0byByZWZyYWluIGZyb20gYWRkaW5nIG5ldyBsZWdhY3kgbmRvcyBidXQg
SQ0KPiBhbHNvIHRoaW5rIHdlDQo+IGxlZnQgYSBnYXAgaW4gdGhlIFZMQU4gY29udHJvbCBmb3Ig
bGVnYWN5IG1vZGUgd2hpbGUgdGhpcyBmZWF0dXJlDQo+IGZpbGxzIHRoYXQgZ2FwLg0KPiBUb2Rh
eSB1c2VyIGNhbiBlaXRoZXIgc2V0IGEgc2luZ2xlIFZMQU4gaWQgdG8gYSBWRiBvciBub25lIHRo
ZXJlJ3MNCj4gbm90aGluZyBpbiBiZXR3ZWVuLg0KPiBUaGlzIGZlYXR1cmUgY29tcGxlbWVudHMg
IHRoZSBtaXNzaW5nIHBhcnQgb2YgdGhlIHB1enpsZSBhbmQgd2UgZG9uJ3QNCj4gc2VlIGFueSBm
dXJ0aGVyDQo+IGZ1dHVyZSBkZXZlbG9wbWVudCBpbiB0aGlzIGFyZWEgYWZ0ZXIgdGhpcy4NCj4g
DQo+IFdlIGhhdmUgdHJpZWQgdG8gc3VibWl0IGFuZCBjbG9zZSB0aGlzIGdhcCBiZWZvcmUgKA0K
PiBodHRwczovL3BhdGNod29yay5vemxhYnMub3JnL3BhdGNoLzgwNjIxMykNCj4gYnV0IG1lc3Nl
ZCB1cCB0aGVyZSBhbmQgYXQgdGhlIHRpbWUgd2UgZGVjaWRlZCBub3QgdG8gcHJvY2VlZCB0aGUN
Cj4gZWZmb3J0DQo+IGR1ZSB0byBzZXZlcmFsIHJlYXNvbnMgc28gd2UgYXJlIHRyeWluZyB0byBj
bG9zZSB0aGlzIG5vdy4NCj4gDQo+IA0KPiANCg0KSmFrdWIsIHNpbmNlIEFyaWVsIGlzIHN0aWxs
IHdvcmtpbmcgb24gaGlzIHVwc3RyZWFtIG1haWxpbmcgbGlzdCBza2lsbHMNCjopLCBpIHdvdWxk
IGxpa2UgdG8gZW1waGFzaXMgYW5kIHN1bW1hcml6ZSBoaXMgcG9pbnQgaW4gdGV4dCBzdHlsZSA7
LSkNCnRoZSB3YXkgd2UgbGlrZSBpdC4NCg0KQm90dG9tIGxpbmUsIHdlIHRyaWVkIHRvIHB1c2gg
dGhpcyBmZWF0dXJlIGEgY291cGxlIG9mIHllYXJzIGFnbywgYW5kDQpkdWUgdG8gc29tZSBpbnRl
cm5hbCBpc3N1ZXMgdGhpcyBzdWJtaXNzaW9uIGlnbm9yZWQgZm9yIGEgd2hpbGUsIG5vdyBhcw0K
dGhlIGxlZ2FjeSBzcmlvdiBjdXN0b21lcnMgYXJlIG1vdmluZyB0b3dhcmRzIHVwc3RyZWFtLCB3
aGljaCBpcyBmb3IgbWUNCmEgZ3JlYXQgcHJvZ3Jlc3MgSSB0aGluayB0aGlzIGZlYXR1cmUgd29y
dGggdGhlIHNob3QsIGFsc28gYXMgQXJpZWwNCnBvaW50ZWQgb3V0LCBWRiB2bGFuIGZpbHRlciBp
cyByZWFsbHkgYSBnYXAgdGhhdCBzaG91bGQgYmUgY2xvc2VkLg0KDQpGb3IgYWxsIG90aGVyIGZl
YXR1cmVzIGl0IGlzIHRydWUgdGhhdCB0aGUgdXNlciBtdXN0IGNvbnNpZGVyIG1vdmluZyB0bw0K
d2l0Y2hkZXYgbW9kZSBvciBmaW5kIGEgYW5vdGhlciBjb21tdW5pdHkgZm9yIHN1cHBvcnQuDQoN
Ck91ciBwb2xpY3kgaXMgc3RpbGwgc3Ryb25nIHJlZ2FyZGluZyBvYnNvbGV0aW5nIGxlZ2FjeSBt
b2RlIGFuZCBwdXNoaW5nDQphbGwgbmV3IGZlYXR1cmUgdG8gc3dpdGNoZGV2IG1vZGUsIGJ1dCBs
b29raW5nIGF0IHRoZSBmYWN0cyBoZXJlICBJIGRvDQp0aGluayB0aGVyZSBpcyBhIHBvaW50IGhl
cmUgYW5kIFJPSSB0byBjbG9zZSB0aGlzIGdhcCBpbiBsZWdhY3kgbW9kZS4NCg0KSSBob3BlIHRo
aXMgYWxsIG1ha2Ugc2Vuc2UuIA0KDQpUaGFua3MsDQpTYWVlZC4NCg0K
