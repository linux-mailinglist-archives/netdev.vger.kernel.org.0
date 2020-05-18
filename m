Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2DFF1D7E4F
	for <lists+netdev@lfdr.de>; Mon, 18 May 2020 18:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgERQXN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 May 2020 12:23:13 -0400
Received: from mail-eopbgr70074.outbound.protection.outlook.com ([40.107.7.74]:24642
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727938AbgERQXL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 18 May 2020 12:23:11 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i4QS7/niT+dagDJ6brzSBZf2iGiLzEuRwnUOEL3G19/gl1E9Sf0iqEw4p/ivCoaSkxPVhxk9L1wD623s/pynJpp6gHNIPclKuENZBdmzsyzAXmVamse2oOdJuYaANIkI3QwMe+8lRIoRCdYDVeCPfu0B+ek34b4CXabVc6RfquwY4aHE3j7jaYR8o3wwVgktzeqakR+DfURRfhefKKQMoLtELRTmLkjrNDi2TnKtHhFFYXH4JUbH0cwyISISJ/rmxqt7old7KsVD7TDx4ynIYj21HGO5xJOZCsCzjiA141ILRdTlevrMzwttdEtvRJSTYQhLiqi0Bw3V1ABl/QUTGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bboQc+b4ozVr88L58p/RO1XRgrhwMrt0CX1UIpLFUYI=;
 b=fhqgbYmMSdTda0VnqBj4v1a0bp76swS17MjcUf/fbu+/PuV5nRYupW3FpwYLaneSSHsipTXbamXmkYi0Ba1o5a0b/Sd5ljWjFByIOpsm/2VfhNElKoFIq9+vOUC9gPhJv1XDDmbRSTJNf4O4IKjyjr3x72IW81NeXo3U4KFpEzBF6rSE7EN9xRX4Wx9QcTof0RVFE2xQf7tq0y7GdLcVV6+950kJPwDOcBzRwdyLiGJ1kSbGvHugN1nUg55cBQZsp3rDeFgRYfjQMCilGRSgcceTi5SmYjaKgX7q6uIrwLvvFYqMEYAV0g2dKQUF5ZU0++rRsnLb2wIWdd4L7l2v5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bboQc+b4ozVr88L58p/RO1XRgrhwMrt0CX1UIpLFUYI=;
 b=aKPsGHxBrGUGntMVUsQZgHR8JJXzqbDR7OWzOF7L9/C/6R1sF9uCvZ/7UojaJhxdHD83kjHUjqkxKgxcxoIUjDMkpBa91KFKHnaJW/+GgJ6rkJMbobYo/v1BGNMZqHy+6aaQwHG9pK2wisEcrnkvxDFGEXv32aPUonyPTMnX/v0=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4608.eurprd05.prod.outlook.com (2603:10a6:802:5f::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3000.31; Mon, 18 May
 2020 16:23:08 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3000.034; Mon, 18 May 2020
 16:23:08 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/3] Mellanox, updates for mlx5 next 15-05-2020
Thread-Topic: [PATCH mlx5-next 0/3] Mellanox, updates for mlx5 next 15-05-2020
Thread-Index: AQHWKwabjmjn1oQghU+1AJZxouFxuqiuCyqA
Date:   Mon, 18 May 2020 16:23:08 +0000
Message-ID: <51dde35a068bb9a16fc08f96b8ba84265b0472d2.camel@mellanox.com>
References: <20200515221654.14224-1-saeedm@mellanox.com>
In-Reply-To: <20200515221654.14224-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 74ab01e8-64c9-49fd-6ad0-08d7fb47c05b
x-ms-traffictypediagnostic: VI1PR05MB4608:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB46080926A520335A831E60E3BEB80@VI1PR05MB4608.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 04073E895A
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: BM+qE22kfKtbu218VUEQq6YX6CUy/84KuLqIRI3mb1n/MT3kOUYvtK81zNNnQIEpYRXLvWncTH+45DmO8MQYE39cRfW4RspdTrTpLHOLDjPbaZMEF2mew2tUsbqO0HF1nrLkzhh813zab0dczRP3layqV1r0iUeXZK4WljCMI0At9/oeCMa5K9ACDL4j8hSbcu+kfHvR5vjcfHa9+kXNct1eXWhS5Ya/OGWfBO2rW30ZRhhwBu9v6Pzimds86LUD1diQkcWA1r5bZeG/aCf44FrXVRla3bM0b7adlXA/AXWCsvKuxJd/e5aDLNXI448/+rtUFapeKZ5vOrXUKbOo26XoDJiVEUO4/rO8PoD2pvngkqliNbUoHlPgETw+n+K1gm8KAc4o3WiePbEOZFhfwMyeXFFXn2BWBuxqiDXkn4gtYiyQu/e6WQ6gbEDpHz0F
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(346002)(376002)(39860400002)(366004)(136003)(396003)(450100002)(8936002)(2906002)(6862004)(6636002)(8676002)(36756003)(4326008)(76116006)(6512007)(91956017)(66946007)(66446008)(66556008)(66476007)(64756008)(478600001)(71200400001)(6486002)(2616005)(5660300002)(6506007)(26005)(15650500001)(86362001)(186003)(316002)(54906003)(37006003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: 833oy56aswEYOfWz1XSIy7cTFSBPQAtjQ4dXKDZmq+m0XpV2BK4+vimUxBYca6t5LdgRTHJFYVjk/n0IM/o3ZSd8tY46ZSD2znhivlLkQToxkPiZKmTQC2byxdxedD3gU9tEZMNN1LRm9HE2f/eYMqHEkPLpc4TLDGn2/loCLnAQRQiDhJWYW1SpjpmPBcKgd9+kaXO0stIcTtYPPz6fUvwoMyJcQCYug2wWCrU00MzyWE5+6FdV4uz2I5+2am8wa72sZ55C26ajwSU5IAVfsg78Gx8Nki8qcDhmMiiYtSfVRJDfksn1DjZ3ti1T5cAqktEWcF5HzBmU97Z3e7JWtxV0H4k9IlnRyxDOhwqmEKgrplbfldfiVToP5MOp81hs4HfQzxXP1qAwXhrjgLw25DQT1fK4XOW4P+hLFARmoRrTOCpXL/LZGiiAJxF8NYt26sA1OE99SHdkCPZR1d2JvESwe1QTpaH520H1qPqEy+g=
Content-Type: text/plain; charset="utf-8"
Content-ID: <ACA8BCCC09629145815A4C0585108A40@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 74ab01e8-64c9-49fd-6ad0-08d7fb47c05b
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2020 16:23:08.3351
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xWJ7iNMaNzi6MBYRTh06AQ9ePmYS2vUkTbVMc1q7r1Zj2ta+Eq5ViyZLicIYcc8a9VBkfpi2WVGhfL5MgAqFjA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4608
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTE1IGF0IDE1OjE2IC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGksDQo+IA0KPiBUaGlzIHBhdGNoc2V0IGlzIGZvciBtbHg1LW5leHQgYnJhbmNoIHdpdGgg
bWlzYyB1cGRhdGVzIHRvDQo+IG1seDUgY29yZSBkcml2ZXIuDQo+IA0KPiAxKSBIZWFkZXIgbW9k
aWZ5IHN1cHBvcnQgZm9yIFJETUEgVFggRmxvdyB0YWJsZQ0KPiAyKSBUd28gc21hbGwgY2xlYW51
cHMuDQo+IA0KPiBUaGFua3MsDQo+IFNhZWVkLg0KPiANCj4gLS0tDQo+IA0KPiBNaWNoYWVsIEd1
cmFsbmlrICgxKToNCj4gICBuZXQvbWx4NTogQWRkIHN1cHBvcnQgZm9yIFJETUEgVFggRlQgaGVh
ZGVycyBtb2RpZnlpbmcNCj4gDQo+IFBhcmF2IFBhbmRpdCAoMSk6DQo+ICAgbmV0L21seDU6IE1v
dmUgaXNlZyBhY2Nlc3MgaGVscGVyIHJvdXRpbmVzIGNsb3NlIHRvIG1seDVfY29yZQ0KPiBkcml2
ZXINCj4gDQo+IFJhZWQgU2FsZW0gKDEpOg0KPiAgIG5ldC9tbHg1OiBDbGVhbnVwIG1seDVfaWZj
X2Z0ZV9tYXRjaF9zZXRfbWlzYzJfYml0cw0KPiANCj4gIGRyaXZlcnMvaW5maW5pYmFuZC9ody9t
bHg1L2Zsb3cuYyAgICAgICAgICAgICAgICAgICAgICB8ICA1ICsrKystDQo+ICBkcml2ZXJzL25l
dC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvY21kLmMgICAgICAgICAgfCAgNSArKysrKw0K
PiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL2ZzX2NtZC5jICAgICAg
IHwgIDQgKysrKw0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4NS9jb3JlL21h
aW4uYyAgICAgICAgIHwgIDUgKysrKysNCj4gIC4uLi9uZXQvZXRoZXJuZXQvbWVsbGFub3gvbWx4
NS9jb3JlL3N0ZWVyaW5nL2RyX3N0ZS5jICB8ICAxIC0NCj4gIC4uLi9ldGhlcm5ldC9tZWxsYW5v
eC9tbHg1L2NvcmUvc3RlZXJpbmcvZHJfdHlwZXMuaCAgICB8ICAzICstLQ0KPiAgaW5jbHVkZS9s
aW51eC9tbHg1L2RyaXZlci5oICAgICAgICAgICAgICAgICAgICAgICAgICAgIHwgMTAgLS0tLS0t
LS0NCj4gLS0NCj4gIGluY2x1ZGUvbGludXgvbWx4NS9tbHg1X2lmYy5oICAgICAgICAgICAgICAg
ICAgICAgICAgICB8ICA0ICstLS0NCj4gIDggZmlsZXMgY2hhbmdlZCwgMjAgaW5zZXJ0aW9ucygr
KSwgMTcgZGVsZXRpb25zKC0pDQo+IA0KDQoNCmFwcGxpZWQgdG8gbWx4NS1uZXh0Lg0K
