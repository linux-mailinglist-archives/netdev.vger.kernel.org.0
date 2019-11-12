Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE28F96AC
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 18:09:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727498AbfKLRJX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 12:09:23 -0500
Received: from mail-eopbgr40058.outbound.protection.outlook.com ([40.107.4.58]:50830
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726896AbfKLRJW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 12:09:22 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Th9SyUkgehnzOjRqmcX7RYo0UhWsXaWX7YjSuYu++SOmZ7nGIUO3dwTzm5+5nFTg6VbdUJI61Cvl7JvCeus3IioiDru+HwvptSW2qYH0KEXd/dpn2zQnAJQydL9vtO5PTBXY5JkbmPxWcYUAgPOLaBnbs/urBBFRqUKa7ErBE88I2NYSgY7oKYTcxbdgPreZ4f/CAK2LO2oUSx05oO6xnO2CRWBzlbThdxV/uFntMN/QYE8zpqxrmqMdMKeMWRCsCoLq1/rZEgHIUoSeVEm7OG1PH2YcvidxsPgAZl+hGsia9fTf6H9i/YfsvoP46Y1CbllSJUYAb7MIxNE0TUFI1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzM1TJCTk7jEnlOjhMr68Z7qtyq4I/rLyRZRwyy8JjU=;
 b=ZMVzTTl/dmq1QhuV/BYyVH+R00+xNLXVXZEXyF3scJPQBYU2glXamfuJZXcS3ON9HT9RnDPGmsRgDMdvzRrtQFi7/8oyaTJ2HBnhs5692WeZ0tDhWQCkxKupsE1cPorYSKpq61W+B22NEptcWPlvK16qQ20H0SJhUvJQ8r1LMzDVB7erNpXsPXUwuM8iol4XftQ63M5V5qo8idyyE6Hn/zrQMlKRXnOSb5dLxP9laoaUyEjrHTzCzw73lHrTtZT6Wn03uPj1OPDWCtnfP/StW8FuvzqxvnfKxdAo43zsIAPfp+pq7AFLIf6H6BxL2+KUbQGKqBi54QzA2+6oQTx8VA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lzM1TJCTk7jEnlOjhMr68Z7qtyq4I/rLyRZRwyy8JjU=;
 b=ZDdv1OtPB0KyerxsWjYYnrQvPof59gCMGdAZmWpGz5hsLlOmAogdKhYlOKz9FgqMfyQcB67+0zbjT2oo6Sm7KERmLWuts+ePcK7PLre0z/bVq/HuxBALMWVanWRfNHP9+sSNa7XsW2PGUpTJ3zhFHaMwBt/GZQfj68+wA3KFIsg=
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com (20.177.49.153) by
 VI1PR04MB5213.eurprd04.prod.outlook.com (20.177.49.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.25; Tue, 12 Nov 2019 17:09:18 +0000
Received: from VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::9470:d3aa:b0e0:9a9b]) by VI1PR04MB4880.eurprd04.prod.outlook.com
 ([fe80::9470:d3aa:b0e0:9a9b%6]) with mapi id 15.20.2430.027; Tue, 12 Nov 2019
 17:09:18 +0000
From:   Claudiu Manoil <claudiu.manoil@nxp.com>
To:     "HEMANT RAMDASI (hramdasi)" <hramdasi@cisco.com>,
        "Daniel Walker (danielwa)" <danielwa@cisco.com>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Sathish Jarugumalli -X (sjarugum - ARICENT TECHNOLOGIES HOLDINGS
        LIMITED at Cisco)" <sjarugum@cisco.com>
Subject: RE: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Topic: [PATCH net] gianfar: Don't force RGMII mode after reset, use
 defaults
Thread-Index: AQHVmWkzb/KVHeRA/ECvEdv93vqv/qeHvtCAgAACaQCAAAFWgA==
Date:   Tue, 12 Nov 2019 17:09:18 +0000
Message-ID: <VI1PR04MB4880787A714A9E49A436AD2496770@VI1PR04MB4880.eurprd04.prod.outlook.com>
References: <1573570511-32651-1-git-send-email-claudiu.manoil@nxp.com>
 <20191112164707.GQ18744@zorba>
 <E84DB6A8-AB7F-428C-8A90-46A7A982D4BF@cisco.com>
In-Reply-To: <E84DB6A8-AB7F-428C-8A90-46A7A982D4BF@cisco.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=claudiu.manoil@nxp.com; 
x-originating-ip: [212.146.100.6]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: fc683d03-297e-4edb-1334-08d767930df2
x-ms-traffictypediagnostic: VI1PR04MB5213:
x-microsoft-antispam-prvs: <VI1PR04MB5213C8C6923B013476B60D2996770@VI1PR04MB5213.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3383;
x-forefront-prvs: 021975AE46
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(346002)(376002)(136003)(366004)(13464003)(199004)(189003)(76116006)(186003)(66476007)(66946007)(26005)(64756008)(86362001)(7696005)(446003)(66556008)(102836004)(76176011)(33656002)(99286004)(6506007)(6436002)(305945005)(6246003)(4326008)(55016002)(7736002)(9686003)(14454004)(478600001)(74316002)(6116002)(3846002)(229853002)(486006)(71200400001)(8936002)(66446008)(256004)(11346002)(25786009)(52536014)(476003)(71190400001)(54906003)(316002)(110136005)(5660300002)(66066001)(44832011)(8676002)(81156014)(81166006)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR04MB5213;H:VI1PR04MB4880.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: EhikuplPhk/iIKkCTPxkMFQHgsVJcbYRtX0RDvl9x9TgsVgpbfur4aSbBD9hFAAvytx/zE20ZoF8xcEv+uCRD/1XPu+gHeDV8XmBlBuySg+KYZvUkypASo3C074StAtfsIc5r5KX4wLySGU+OYGDACS03uOdHqM7zOWKWisoMyyq2W7O2zaW2CMaf/HvdYgiZq8ItOzjBb49GV+hXhkEyYfguCX27LL1m4vbO0TZzYbzbt0HDBN2ZSgXmQoyTglwkDeeCeJ5qPpXJa00bas3n1btxF+n5Amkus1ft+sXvvNAkxVKd8jsQFptcjnN4Ouw9+SyV0MFzybvYUJueqgJSew8SqtRmsKSr/OuPSd1mRtGno3ttt3a1JMEEvCldOPJoxAIrVgptYlOnaSjPwp+Gsub4DPEGCk0X0Qn1g9yvhyVUFHN+oHUHZpKR1X8a1Md
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fc683d03-297e-4edb-1334-08d767930df2
X-MS-Exchange-CrossTenant-originalarrivaltime: 12 Nov 2019 17:09:18.7446
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: FB70DW61MVK8arXgnQhpLcOSe1Bsud2mruapio5XVtYgjlTE9HEwnlIRq3B6/YKHIzOIyVNG/SPB4HDNXdb/vg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB5213
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pi0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+RnJvbTogSEVNQU5UIFJBTURBU0kgKGhyYW1k
YXNpKSA8aHJhbWRhc2lAY2lzY28uY29tPg0KPlNlbnQ6IFR1ZXNkYXksIE5vdmVtYmVyIDEyLCAy
MDE5IDY6NTYgUE0NCj5UbzogRGFuaWVsIFdhbGtlciAoZGFuaWVsd2EpIDxkYW5pZWx3YUBjaXNj
by5jb20+OyBDbGF1ZGl1IE1hbm9pbA0KPjxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPg0KPkNjOiBE
YXZpZCBTIC4gTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0PjsgbmV0ZGV2QHZnZXIua2VybmVs
Lm9yZzsNCj5TYXRoaXNoIEphcnVndW1hbGxpIC1YIChzamFydWd1bSAtIEFSSUNFTlQgVEVDSE5P
TE9HSUVTIEhPTERJTkdTDQo+TElNSVRFRCBhdCBDaXNjbykgPHNqYXJ1Z3VtQGNpc2NvLmNvbT4N
Cj5TdWJqZWN0OiBSZTogW1BBVENIIG5ldF0gZ2lhbmZhcjogRG9uJ3QgZm9yY2UgUkdNSUkgbW9k
ZSBhZnRlciByZXNldCwgdXNlDQo+ZGVmYXVsdHMNCj4NCj4gICAgPiBSZXBvcnRlZC1ieTogRGFu
aWVsIFdhbGtlciA8ZGFuaWVsd2FAY2lzY28uY29tPg0KPiAgICA+IFNpZ25lZC1vZmYtYnk6IENs
YXVkaXUgTWFub2lsIDxjbGF1ZGl1Lm1hbm9pbEBueHAuY29tPg0KPiAgICA+IC0tLQ0KPiAgICA+
ICBkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZ2lhbmZhci5jIHwgMyArKy0NCj4gICAg
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuaCB8IDIgKy0NCj4gICAg
PiAgMiBmaWxlcyBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDIgZGVsZXRpb25zKC0pDQo+ICAg
ID4NCj4gICAgPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dp
YW5mYXIuYw0KPmIvZHJpdmVycy9uZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuYw0KPiAg
ICA+IGluZGV4IDUxYWQ4NjQuLjBmNGQxM2QgMTAwNjQ0DQo+ICAgID4gLS0tIGEvZHJpdmVycy9u
ZXQvZXRoZXJuZXQvZnJlZXNjYWxlL2dpYW5mYXIuYw0KPiAgICA+ICsrKyBiL2RyaXZlcnMvbmV0
L2V0aGVybmV0L2ZyZWVzY2FsZS9naWFuZmFyLmMNCj4gICAgPiBAQCAtMzE3Myw3ICszMTczLDgg
QEAgdm9pZCBnZmFyX21hY19yZXNldChzdHJ1Y3QgZ2Zhcl9wcml2YXRlICpwcml2KQ0KPiAgICA+
ICAJZ2Zhcl93cml0ZSgmcmVncy0+bWluZmxyLCBNSU5GTFJfSU5JVF9TRVRUSU5HUyk7DQo+ICAg
ID4NCj4gICAgPiAgCS8qIEluaXRpYWxpemUgTUFDQ0ZHMi4gKi8NCj4gICAgPiAtCXRlbXB2YWwg
PSBNQUNDRkcyX0lOSVRfU0VUVElOR1M7DQo+ICAgID4gKwl0ZW1wdmFsID0gZ2Zhcl9yZWFkKCZy
ZWdzLT5tYWNjZmcyKTsNCj4gICAgPiArCXRlbXB2YWwgfD0gTUFDQ0ZHMl9QQURfQ1JDOw0KPg0K
PlRoaXMgaXMgbm90IGluIHN5bmMgd2l0aCBQQUQvQ1JDIGRlZmluaXRpb24gb2YgbWFjY2ZnMiBt
ZW50aW9uZWQgaW4gcDIwMiBybS4NCj4NCg0KSSBkb24ga25vdyB3aGF0IHlvdSBtZWFuLiAgVGhl
IGRlZmluaXRpb24gb2YgdGhpcyBiaXQgaXM6DQoiIFBhZCBhbmQgYXBwZW5kIENSQyAuIFRoaXMg
Yml0IGlzIGNsZWFyZWQgYnkgZGVmYXVsdC4NClRoaXMgYml0IG11c3QgYmUgc2V0IHdoZW4gaW4g
aGFsZi1kdXBsZXggbW9kZSAoTUFDQ0ZHMltGdWxsX0R1cGxleF0gaXMgY2xlYXJlZCkuDQowIEZy
YW1lcyBwcmVzZW50ZWQgdG8gdGhlIE1BQyBoYXZlIGEgdmFsaWQgbGVuZ3RoIGFuZCBjb250YWlu
IGEgQ1JDLg0KMSBUaGUgTUFDIHBhZHMgYWxsIHRyYW5zbWl0dGVkIHNob3J0IGZyYW1lcyBhbmQg
YXBwZW5kcyBhIENSQyB0byBldmVyeSBmcmFtZSByZWdhcmRsZXNzIG9mIHBhZGRpbmcNCnJlcXVp
cmVtZW50LiINCg0KU28gdGhlIGRyaXZlciBzZXRzIHRoaXMgYml0IHRvIGhhdmUgc21hbGwgZnJh
bWVzIHBhZGRlZC4gSXQgYWx3YXlzIHdvcmtlZCB0aGlzIHdheSwNCmFuZCBJIHJldGVzdGVkIG9u
IFAyMDIwUkRCIGFuZCBMUzEwMjFSREIgYW5kIHdvcmtzLg0KQXJlIHlvdSBzYXlpbmcgdGhhdCBw
YWRkaW5nIGRvZXMgbm90IHdvcmsgb24geW91ciBib2FyZCB3aXRoIHRoZSBjdXJyZW50IHVwc3Ry
ZWFtIGNvZGU/DQoNCi1DbGF1ZGl1DQoNCg==
