Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A3AA1E571B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 07:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727114AbgE1F4y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 01:56:54 -0400
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:23726
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727092AbgE1F4x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 May 2020 01:56:53 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LIj1Tb8q22tCC10GHhLHVsBdtXf8rVlUpJOOya8nhncol/FvVnrYEb4HY79VXhgAon5o4ZfENQ93zlPhaWKxoJvNKakhmkGKzSRC8XsqB8dBi1aM2VpBuFdQYp9qOyzJNSqPpaTWbH/mnyT9AYIjx9zcWonLCkpr15/gR59/NHM8uUtz084BAa9nJhPRZ8TW4l2cILOVsjCPP8igr+yPdEW9vHu5XUwoxNa8HIW/PxRY23Ffh+fEIV9uzIESHiOayuOu+rj6kUzpAzuHSjWXA5sm4M1xYERru/wsIPHS7DU/UfHNPiGS3Ve6aP0uyZYK+JyUIlNA3XnGGYWxiQokqw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GSCSgtjBOFA0XYB6otUzvsWSLjpWEtA5QgnsOZkW6/0=;
 b=LSQVcJKf2RaKD/InCcXidXoXhLAsKv9vimUSWc3JfqIXuDmjFV0B5BLPfuisGxwu2NcnFAf66Kh53A6rp9k8uHpgkRAh/624DLIFod8XHGdEH3Eim4wuoko03TUDUj/JP/2G2UiQoM6aZIWxK++q3ZKMQurgnSKQQk9Gm5m8DEeS79cu5hU4/cIvTkRbUmU5sKeOcsvaNiEwW1cVss0/8An/LEAZHXSnmYrepnetHq7oaUsEkO224tK0aZfcTgEpnDUXVzycrh2QbznMPXqJ46vMowUZs3bYWZ0Zyu0KoBXwLvycoSgf2ZNsV5ahY3cQ+5MquerJydLs9JZNr37g8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GSCSgtjBOFA0XYB6otUzvsWSLjpWEtA5QgnsOZkW6/0=;
 b=lkLzBr+4r2BQOtqvh3Fc169SsRCvN69NBdyZEvtlfVI2uG6glLPJMrR5PTo44EPQC0SacDad+mNEdmjZD64oYv7pZkIye9AlxlvN5i4FAbJ+JhSoY3/F1wNFhRbXF2UmxC/43T3VCfFGowgBRPNfmCRrzsFoSxeL2miANu5bo+M=
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 (2603:10a6:208:1b::25) by AM0PR0502MB3666.eurprd05.prod.outlook.com
 (2603:10a6:208:17::25) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3021.27; Thu, 28 May
 2020 05:56:48 +0000
Received: from AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b]) by AM0PR0502MB3826.eurprd05.prod.outlook.com
 ([fe80::2dae:c2a2:c26a:f5b%7]) with mapi id 15.20.3021.029; Thu, 28 May 2020
 05:56:47 +0000
From:   Amit Cohen <amitc@mellanox.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     mlxsw <mlxsw@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "o.rempel@pengutronix.de" <o.rempel@pengutronix.de>
Subject: RE: Link down reasons
Thread-Topic: Link down reasons
Thread-Index: AdY0MRsCf+pEVriLQBWXdVHGjFy9PgAPhZ2AABC/emA=
Date:   Thu, 28 May 2020 05:56:47 +0000
Message-ID: <AM0PR0502MB38267B345D7829A00790285DD78E0@AM0PR0502MB3826.eurprd05.prod.outlook.com>
References: <AM0PR0502MB38261D4F4F7A3BB5E0FDCD10D7B10@AM0PR0502MB3826.eurprd05.prod.outlook.com>
 <20200527213843.GC818296@lunn.ch>
In-Reply-To: <20200527213843.GC818296@lunn.ch>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: lunn.ch; dkim=none (message not signed)
 header.d=none;lunn.ch; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [87.68.150.248]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: edf3c620-6905-4e2d-2c0f-08d802cbe8c3
x-ms-traffictypediagnostic: AM0PR0502MB3666:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM0PR0502MB3666FCA8B4D5978D1FB1EBF1D78E0@AM0PR0502MB3666.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0417A3FFD2
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: jSGID7YLy2eioxKBrMmMLtHozyuU+WJxdby2fxtVzdtfPqOI8I8miJJbZHbdHlXl52eFJvAoS+iGAKZ+SlieAtFZ/qN0sjZhyPgpcoGAnOgRhN4rA355Adpp8+OuqliQMWtGyjPiP8bOidJ3UXRcm92En7vdg1vyN3HbynfZLy6jD7n9jsV0GJXDTO6CPHgH3GjdNCBuLBL2yOt66chaHhsRbfc4LF6OJs0kkfosInvOlaK++NSZX7v69v9CGD5DZKYwhnJKwt+Z6InSN8VyeI103jzAwmpd0LFgTx7qY46PDu/kdzGRak9AzGhfkJVlIUY1HtNyKlb5bRze1LzVdQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR0502MB3826.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(376002)(396003)(136003)(346002)(71200400001)(76116006)(64756008)(66946007)(66476007)(6506007)(66556008)(26005)(186003)(5660300002)(7696005)(83380400001)(66446008)(8676002)(8936002)(3480700007)(7116003)(52536014)(478600001)(4326008)(6916009)(55016002)(33656002)(9686003)(86362001)(54906003)(2906002)(316002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +JpmmbvAJ6S6U8G/penK9I1f3yk5FjvfmjDmZrgKrX00dI8X5V4JHYyJbw9uBqrFo1uZL970t+MkB00MSewb2zk5z6384jEDVwAkHFyvQxLqogtWyQgBeCbGg4e3icVmnxAHdiMP32eEyHDhenjKICYLpk0xSMthcDTrms/7uGgJidCpMGdBthnbUWcn4Lxj0JZ7bxMf7oMJTFlcKrFYANIyLpgAEPXFHBKn/AISxGpNCQz79GrQdp7q6NhbWQTRHoPPLoJlSBRUqhdcRn+/CEoiX2c5S2jdn+LfKlESBrXbVH6EvZVMt5GTH7xN+mdfdDy0L3ndr1EC9dI2m25KaGdRjs8MprAsqfoIpKW5EgSfsLXc4REOeYrj4cn1ZAHP21y2owr0EwMIrf08S3/TmlYcMODFM3cjPJ35sypfJzTnfECdgzd0KaIDW0kDtDiCwoeQKSc9kfOu5d9CNWjOrfqCCRgTPaJMtTkrHuUog7M=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf3c620-6905-4e2d-2c0f-08d802cbe8c3
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 May 2020 05:56:47.8997
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ep6KY/Kq4UoQaiqHIuIZOC1XIdiF204iz4pBdXdG4kYoSAKI5okcuC1hTipSJkHPBczGNOJNdAYctYKTZZ5wLw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

QW5kcmV3IEx1bm4gPGFuZHJld0BsdW5uLmNoPiB3cml0ZXM6DQoNCj5PbiBXZWQsIE1heSAyNywg
MjAyMCBhdCAwMzo0MToyMlBNICswMDAwLCBBbWl0IENvaGVuIHdyb3RlOg0KPj4gSGkgQW5kcmV3
LA0KPj4gDQo+PiBXZSBhcmUgcGxhbm5pbmcgdG8gc2VuZCBhIHNldCB0aGF0IGV4cG9zZXMgbGlu
ay1kb3duIHJlYXNvbiBpbiBldGh0b29sLg0KPj4gDQo+PiBJdCBzZWVtcyB0aGF0IHRoZSBhYmls
aXR5IG9mIHlvdXIgc2V0IOKAnEV0aGVybmV0IGNhYmxlIHRlc3Qgc3VwcG9ydOKAnSANCj4+IGNh
biBiZSBpbnRlZ3JhdGVkIHdpdGggbGluay1kb3duIHJlYXNvbi4NCj4+IA0KPj4gIA0KPj4gDQo+
PiBUaGUgaWRlYSBpcyB0byBleHBvc2UgcmVhc29uIGFuZCBzdWJyZWFzb24gKGlmIHRoZXJlIGlz
KToNCj4+IA0KPj4gJCBldGh0b29sIGV0aFgNCj4+IA0KPj4g4oCmDQo+PiANCj4+IExpbmsgZGV0
ZWN0ZWQ6IG5vIChObyBjYWJsZSkgLy8gTm8gc3ViIHJlYXNvbg0KPj4gDQo+PiAgDQo+PiANCj4+
ICQgZXRodG9vbCBldGhZDQo+PiANCj4+IExpbmsgZGV0ZWN0ZWQ6IG5vIChBdXRvbmVnIGZhaWx1
cmUsIE5vIHBhcnRuZXIgZGV0ZWN0ZWQpDQo+PiANCj4+ICANCj4+IA0KPj4gQ3VycmVudGx5IHdl
IGhhdmUgcmVhc29uIOKAnGNhYmxlIGlzc3Vl4oCdIGFuZCBzdWJyZWFzb25zIOKAnHVuc3VwcG9y
dGVkIA0KPj4gY2FibGXigJ0gYW5kIOKAnHNob3J0ZWQgY2FibGXigJ0uDQo+PiANCj4+IFRoZSBt
ZWNoYW5pc20gb2YgY2FibGUgdGVzdCBjYW4gYmUgaW50ZWdyYXRlZCBhbmQgYWxsb3cgdXMgcmVw
b3J0IOKAnGNhYmxlIGlzc3Vl4oCdDQo+PiByZWFzb24gYW5kIOKAnHNob3J0ZWQgY2FibGXigJ0g
c3VicmVhc29uLg0KPg0KPkhpIEFtaXQNCj4NCj5JIGRvbid0IHJlYWxseSBzZWUgdGhlbSBiZWlu
ZyBjb21iaW5hYmxlLiBGaXJzdCBvZmYsIHlvdXIgQVBJIHNlZW1zIHRvbyBsaW1pdGluZy4gSG93
IGRvIHlvdSBzYXkgd2hpY2ggcGFpciBpcyBicm9rZW4sIG9yIGF0IHdoYXQgZGlzdGFuY2U/IFdo
YXQgYWJvdXQgb3BlbiBjYWJsZSwgYXMgb3Bwb3NlZCB0byBzaG9ydGVkIGNhYmxlPw0KPg0KPlNv
IGkgd291bGQgc3VnZ2VzdDoNCj4NCj5MaW5rIGRldGVjdGVkOiBubyAoY2FibGUgaXNzdWUpDQo+
DQo+QW5kIHRoZW4gcmVjb21tZW5kIHRoZSB1c2VyIHVzZXMgZXRodG9vbCAtLWNhYmxlLXRlc3Qg
dG8gZ2V0IGFsbCB0aGUgZGV0YWlscywgYW5kIHlvdSBoYXZlIGEgbXVjaCBtb3JlIGZsZXhpYmxl
IEFQSSB0byBwcm92aWRlIGFzIG11Y2ggb3IgYXMgbGl0dGxlIGluZm9ybWF0aW9uIGFzIHlvdSBo
YXZlLg0KPg0KPiAgIEFuZHJldw0KDQpUaGFua3MhDQpMaW5rLWRvd24gcmVhc29uIGhhcyB0byBj
b25zaWRlciBjYWJsZS10ZXN0IG9yIG5vdD8gSW4gb3JkZXIgdG8gcmVwb3J0ICJjYWJsZSBpc3N1
ZSIsIHdlIGFzc3VtZSB0aGF0IHRoZSBkcml2ZXIgaW1wbGVtZW50ZWQgbGluay1kb3duIHJlYXNv
biBpbiBhZGRpdGlvbiB0byBjYWJsZS10ZXN0Pw0KSSdtIGFza2luZyBhYm91dCBQSFkgZHJpdmVy
IGZvciBleGFtcGxlIHRoYXQgaW1wbGVtZW50ZWQgY2FibGUtdGVzdCBhbmQgbm90IGxpbmstZG93
biByZWFzb24sIHNvIGFjY29yZGluZyB0byBjYWJsZS10ZXN0IHdlIHNob3VsZCByZXBvcnQgImNh
YmxlIGlzc3VlIiBhcyBhIGxpbmstZG93biByZWFzb24gb3IgZG8gbm90IGV4cG9zZSByZWFzb24g
aGVyZT8NCg0K
