Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC79168735
	for <lists+netdev@lfdr.de>; Fri, 21 Feb 2020 20:06:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729699AbgBUTGM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Feb 2020 14:06:12 -0500
Received: from mail-eopbgr150047.outbound.protection.outlook.com ([40.107.15.47]:8003
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726423AbgBUTGL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Feb 2020 14:06:11 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jHotaWsqZkFBNoKH0xjg0Zm4vYNGyfsnouyVDFOuUidrUHk8yZZLwo0Ad04FJWEcZ3mgRJbtoAdGhbihlafHO20yg4QzyooizofR9c3sgq6j+5hEglrYCnn0NP2qrL+TJfrp9oIaqOt7l1OGyv+4Hru7mAqc7hm8FfE4APeLbbD7gnnSDmvC6uYiOuAoGOm/ZIl7IvVJ12JwOvQFXusw/cvHLdFMg1gySRIpNDsbw5fP/TbPH8iPFF/7GLQzGSFIunqvLPif9kqY21pKLeFofhlMut9wTwifcG8teTDGmtrQjlwLENA/tCBvQv1i3qwWIAcGCmNkyIjSu5J2rwUk3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9/CgzCVror0bmniqcOZIxPKvOjeUySAUfhGDCPgj8Y=;
 b=NXB1G+OJkJrnsPhRv7hEhpu5FKO7Gbxq6Ow6y4OXXjNnGRSIn92wtjTF94OesUL1WJueQsH7y0gdeCnettxjeQp59TmbYaDOkOIZ4/d73uUl2gLX3XQRTd6s71/JBWKjNNMWl7lgJmBeT2xe9eOgIBhK7NNeaBUWAyeX5DLhK7dW7what406RnbDv59nDtS+dSFcAH2jrGMY3zPjHMzTwcPjPxSZfCL5XJbbNuhXvhMbyonaLqz5kUVwKjVF2uJF3iU/GZnZzTLhIS/Rr0RwOO8w4NBJRqN97BgseCjzNK+7xPjNEq9RVeOxqZXOgx696pHTti9uOfWbIKpeATx3qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=z9/CgzCVror0bmniqcOZIxPKvOjeUySAUfhGDCPgj8Y=;
 b=J4eZ8duGZzHMNsU8sm9WgWPvoVa+PX1wRT48pv1nXCS0bLqpR6LfWba06e2fqPur/3Ov5rGaErXJT7wBm4yAJP2pZo9vSw4kwFQBNZgpmCC8uxxZGrNjo8rMMquLkGLT3PGfgBoiAYjeR2bwo1eEcAhKDtQHUHyR/LxJRQdES9E=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5117.eurprd05.prod.outlook.com (20.178.10.141) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2729.34; Fri, 21 Feb 2020 19:05:35 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2729.033; Fri, 21 Feb 2020
 19:05:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "ndev@hwipl.net" <ndev@hwipl.net>,
        "leon@kernel.org" <leon@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] Documentation: fix vxlan typo in mlx5.rst
Thread-Topic: [PATCH net-next] Documentation: fix vxlan typo in mlx5.rst
Thread-Index: AQHV5pUS4RGbCSDmXEOFojpeVvAiHKgmBpwA
Date:   Fri, 21 Feb 2020 19:05:34 +0000
Message-ID: <963d65106c6a5be9f43ce88abc9d8a08342cc7b4.camel@mellanox.com>
References: <20200218195259.203207-1-ndev@hwipl.net>
In-Reply-To: <20200218195259.203207-1-ndev@hwipl.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.3 (3.34.3-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 4e1e7277-1266-4aca-1bda-08d7b70107cc
x-ms-traffictypediagnostic: VI1PR05MB5117:
x-microsoft-antispam-prvs: <VI1PR05MB5117CB36E197FB18913351AABE120@VI1PR05MB5117.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0320B28BE1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39850400004)(136003)(366004)(396003)(376002)(346002)(199004)(189003)(66446008)(66946007)(66556008)(66476007)(36756003)(26005)(76116006)(5660300002)(6506007)(2616005)(91956017)(4326008)(2906002)(186003)(316002)(6486002)(71200400001)(64756008)(110136005)(8676002)(478600001)(6512007)(81156014)(81166006)(8936002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5117;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: di+/JMGiVLTPgtLP9kSXsa6miTVbhXt2riYFx9Fru/aTE16icUC6e3N+nPWbcDhuppMr96cXl44+/Htq1y0p+Ur776ZgYUGFcpaU82zOvVJzPRNvki1MlLhZtKoV4csKnd/J+c1HdFdDpy2GOZCEezMjTsgPaOC6CdhNGdNL5t6YlPUZqV1iOs1zZuBrmj8oFRi1YaUYKoWQV7JFZEtbQFiUJlCDBb2AdIhl4UP5E+FcfwScN6kkAnUvFBCyLNrt9QbyWiIIZBGVYE9WnkQ4U4tKFew8Wfmfy1DwXY3nCe8a4aoESBF4qup7HhvX7g8VYIWTbI1KZkkF3SF/Kil/h5IASHsi9nuoUv1xRijTpTrKD7q3BrzDcD4mtL7jOkyjaTN45Wg9dq1oHg2OCgaa0S0qnDziMWVquDLw6yURuq1dH+JEcdvj8AkfprxbhiDZ
x-ms-exchange-antispam-messagedata: TMilNa9AmHXBrsyy5qm1Oe/RdRzaMg2o2h+EjAQNTyFbuuyDBXvwWFH62z29waz7lQz06aUMqTzyHYNx2qnyX9Wwo43JXuL/MT7O7v080aCCnM7pYzLSFEsHITtkJjtsU9Xs6BjqZ+Sl00ZLyG9KfA==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <69907C9B7387EE41A2892E60E761B7FD@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e1e7277-1266-4aca-1bda-08d7b70107cc
X-MS-Exchange-CrossTenant-originalarrivaltime: 21 Feb 2020 19:05:34.7842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: dDqg1teSZTpRSpvW7/6QySAWyKwCyWyI8tmzBd/LwIs7r/RchVyd79PK96CCPeJtc8YDR+bcIn7vw1Mbpuf4vQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5117
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTAyLTE4IGF0IDIwOjUyICswMTAwLCBIYW5zIFdpcHBlbCB3cm90ZToNCj4g
Rml4IGEgdnhsYW4gdHlwbyBpbiB0aGUgbWx4NSBkcml2ZXIgZG9jdW1lbnRhdGlvbi4NCj4gDQo+
IFNpZ25lZC1vZmYtYnk6IEhhbnMgV2lwcGVsIDxuZGV2QGh3aXBsLm5ldD4NCj4gLS0tDQo+ICBE
b2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZGV2aWNlX2RyaXZlcnMvbWVsbGFub3gvbWx4NS5yc3Qg
fCAyICstDQo+ICAxIGZpbGUgY2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkN
Cj4gDQo+IGRpZmYgLS1naXQNCj4gYS9Eb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZGV2aWNlX2Ry
aXZlcnMvbWVsbGFub3gvbWx4NS5yc3QNCj4gYi9Eb2N1bWVudGF0aW9uL25ldHdvcmtpbmcvZGV2
aWNlX2RyaXZlcnMvbWVsbGFub3gvbWx4NS5yc3QNCj4gaW5kZXggZjU3NWE0OTc5MGU4Li5lOWI2
NTAzNWNkNDcgMTAwNjQ0DQo+IC0tLSBhL0RvY3VtZW50YXRpb24vbmV0d29ya2luZy9kZXZpY2Vf
ZHJpdmVycy9tZWxsYW5veC9tbHg1LnJzdA0KPiArKysgYi9Eb2N1bWVudGF0aW9uL25ldHdvcmtp
bmcvZGV2aWNlX2RyaXZlcnMvbWVsbGFub3gvbWx4NS5yc3QNCj4gQEAgLTEwMSw3ICsxMDEsNyBA
QCBFbmFibGluZyB0aGUgZHJpdmVyIGFuZCBrY29uZmlnIG9wdGlvbnMNCj4gICoqRXh0ZXJuYWwg
b3B0aW9ucyoqICggQ2hvb3NlIGlmIHRoZSBjb3JyZXNwb25kaW5nIG1seDUgZmVhdHVyZSBpcw0K
PiByZXF1aXJlZCApDQo+ICANCj4gIC0gQ09ORklHX1BUUF8xNTg4X0NMT0NLOiBXaGVuIGNob3Nl
biwgbWx4NSBwdHAgc3VwcG9ydCB3aWxsIGJlDQo+IGVuYWJsZWQNCj4gLS0gQ09ORklHX1ZYTEFO
OiBXaGVuIGNob3NlbiwgbWx4NSB2eGFsbiBzdXBwb3J0IHdpbGwgYmUgZW5hYmxlZC4NCj4gKy0g
Q09ORklHX1ZYTEFOOiBXaGVuIGNob3NlbiwgbWx4NSB2eGxhbiBzdXBwb3J0IHdpbGwgYmUgZW5h
YmxlZC4NCj4gIC0gQ09ORklHX01MWEZXOiBXaGVuIGNob3NlbiwgbWx4NSBmaXJtd2FyZSBmbGFz
aGluZyBzdXBwb3J0IHdpbGwgYmUNCj4gZW5hYmxlZCAodmlhIGRldmxpbmsgYW5kIGV0aHRvb2wp
Lg0KPiAgDQo+ICBEZXZsaW5rIGluZm8NCg0KQXBwbGllZCB0byBuZXQtbmV4dC1tbHg1DQoNClRo
YW5rcyAhDQo=
