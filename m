Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BB92190170
	for <lists+netdev@lfdr.de>; Mon, 23 Mar 2020 23:57:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726956AbgCWW5g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Mar 2020 18:57:36 -0400
Received: from mail-eopbgr80085.outbound.protection.outlook.com ([40.107.8.85]:46146
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725990AbgCWW5g (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 23 Mar 2020 18:57:36 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ArsFZnZ8jmSZIN9B0QNkc7WR5z2cFFhgMLaNwzDJFapE5mNchjyAGO38KmDUmbTRygDYL5755ddOqNRbbdB99+FFrF4gOPEoM2mbn/CI7A5jTdwjjetsZZeGzyu6OpUtTJ4+kvi+zqtaTNfquvDtHdma58e4vMaqvm4DUv0QkJwCIHJGsbUJJIZyA/Y7D33hdjN0U2kL929vPrfLwaxu/lc0NVrDRmSQbFqquJ7VMkroZBvMAu6FsH5Hbctwj8VL8vHNQWw/EaFiACmo4QWyUO2gs8kHAHTxDFykRfkY053Dz1mPrX8hWbV7I1eT76CEUi0cRhp6C4jbzNrm6ain2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKF5Pg27piNl+Ctry7cOloxQA5yC/MMWjWuOTmsJhcc=;
 b=BxSgcm2Xtb9JQZPgF3ewTnsenYDTaEEl2cQJFXohsjzqyUYJDmxhlWlTqr5KsMOIEA+WH+zZw1fpcSvXj9JmL2WVtjpAcjyfpS0Nm8pCqjQ3TLQF8nQOAE9f7MV6iHx0Kgn+FG0nnpszAUPEavFaa8NTUVfs1leJqNRUZAwB4cKRUQDkt3IVJ9ZqkMv0a6Qk2HmxE9lxlM+t3kaAh7iIitn0ZTLi8clUAPNNr/5D7Zjc+s9toLs//yz7Z4wm2YWIzip1DArb7sR/tf+Unn9leV08MGxvur90h0gzkAGUiMY5Dfttx2+wglFCh+d7xSdetTJwt3Ig97OJjaWEAbXlLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zKF5Pg27piNl+Ctry7cOloxQA5yC/MMWjWuOTmsJhcc=;
 b=p6Kk49G890IDKiIAbE4GW+QZaZJaAckDrNIwZh0XUMYKJz96VrPkqwXB5068uq5ZMAgWZdT/YawUIHDVdhFg8Nk1YwGD8yDxNVwtvdkhBUMad6W7ciZ+m2XZXe9CqJ/0f1HKWSTi4QvmMEBnwFBciwZQ/M95iq8QPrJPa3ndvYk=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5648.eurprd05.prod.outlook.com (20.178.121.206) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2835.18; Mon, 23 Mar 2020 22:57:32 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2835.021; Mon, 23 Mar 2020
 22:57:32 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-03-05
Thread-Topic: [pull request][net 0/5] Mellanox, mlx5 fixes 2020-03-05
Thread-Index: AQHV80RNKBZ+Y24z/0CDhMjONfpfj6g8sOiAgBo1aQA=
Date:   Mon, 23 Mar 2020 22:57:32 +0000
Message-ID: <2495edeb580e5a4b072bda6e72e4808c281b0f2e.camel@mellanox.com>
References: <20200305231739.227618-1-saeedm@mellanox.com>
         <20200306.224333.609016114112242678.davem@davemloft.net>
In-Reply-To: <20200306.224333.609016114112242678.davem@davemloft.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c383da0b-be05-4ff7-43ba-08d7cf7d923d
x-ms-traffictypediagnostic: VI1PR05MB5648:
x-microsoft-antispam-prvs: <VI1PR05MB5648F4B3C4E9BBD2C5C535CEBEF00@VI1PR05MB5648.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-forefront-prvs: 0351D213B3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(39860400002)(346002)(136003)(376002)(396003)(4326008)(26005)(186003)(71200400001)(2616005)(81166006)(86362001)(8676002)(4744005)(6512007)(81156014)(8936002)(6916009)(316002)(5660300002)(6506007)(91956017)(66476007)(76116006)(66946007)(64756008)(66446008)(6486002)(36756003)(2906002)(478600001)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5648;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /OQVJGI6kR3B1EQvZA2QNh4CfCPM+8kmQg8WdWq3hBBfKWp0PNAWX27r0bdTFS1cbkS0WO3BKskYHnl5kc2h1Qme8CUJtbCOlnBWXnmQa2XZ8bISu890z3M90uWmnv1abTF9vTcU3MgebXkwadLSUvWQkEpldgPOvL1c2vcWlf0kdF9Ow/0VwrB9TwF+lrrZTzzC+r7kPPxLAvrp3iA0vEU2fNIVxixWayafnwNCHxLBpADZekHgwzmkkLoBpGqpL+RwL5v8Otpq5SxSE+IyLIQggq6+f+/qaw0iPPxalN6reNeKgs/Daq0MjuABW5MzC8It9SWkdQ9TRSQhwvoicEgbd1UHmH4d/BJPCXQd4u6ehXO15NCJhqboPkGYTYlZaJhxHFJNWf/x2SsA8fuRyuJ516I8t9jHKgV7JDaaIRnJV8+KgO4cEHFI3aMTWNYC
x-ms-exchange-antispam-messagedata: YfF42rzp+Ik6XvlrGULlKnSQNesMqZNM0aEYNpx98E1FVmHmK+ee7mzyy6IO4skLEdy6Gde6l4LTIFiE6JIZ23GSpJi8pqGTgK0DWFz1z3LmVDsikCML2NeZxaV+u7qWWT8makrfySSDD4kI4lmIDQ==
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <D203D1C078E1164FB4FF0C15103A6FFB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c383da0b-be05-4ff7-43ba-08d7cf7d923d
X-MS-Exchange-CrossTenant-originalarrivaltime: 23 Mar 2020 22:57:32.6545
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: nudbh08sll3y0nkrCbwsT8pwsV1LzOR1+bBn60d3QXIWHOkuQIhsrWusJAIwVsu35bnqcL3CK/dPWwPjQnAnXg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5648
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTAzLTA2IGF0IDIyOjQzIC0wODAwLCBEYXZpZCBNaWxsZXIgd3JvdGU6DQo+
IEZyb206IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiBEYXRlOiBUaHUs
ICA1IE1hciAyMDIwIDE1OjE3OjM0IC0wODAwDQo+IA0KPiA+IFRoaXMgc2VyaWVzIGludHJvZHVj
ZXMgc29tZSBmaXhlcyB0byBtbHg1IGRyaXZlci4NCj4gPiANCj4gPiBQbGVhc2UgcHVsbCBhbmQg
bGV0IG1lIGtub3cgaWYgdGhlcmUgaXMgYW55IHByb2JsZW0uDQo+IA0KPiBQdWxsZWQuDQo+IA0K
DQpIaSBEYXZlLCANCg0KaSBkb24ndCBzZWUgdGhpcyBwdWxsIHJlcXVlc3QgbWVyZ2VkIGludG8g
eW91ciBuZXQgdHJlZSwgDQp3aGF0IGFtIGkgbWlzc2luZyA/IA0KDQpJIGFtIHByZXBhcmluZyBh
IG5ldyBmaXhlcyBwdWxsIHJlcXVlc3QsIHNob3VsZCBpIHJlLWluY2x1ZGUgdGhlc2UNCnBhdGNo
ZXMgYW5kIHN0YXJ0IG92ZXIgPyBJIGRvbid0IG1pbmQgLi4gDQoNCj4gPiBGb3IgLXN0YWJsZSB2
NS40DQo+ID4gICgnbmV0L21seDU6IERSLCBGaXggcG9zdHNlbmQgYWN0aW9ucyB3cml0ZSBsZW5n
dGgnKQ0KPiA+IA0KPiA+IEZvciAtc3RhYmxlIHY1LjUNCj4gPiAgKCduZXQvbWx4NWU6IGtUTFMs
IEZpeCBUQ1Agc2VxIG9mZi1ieS0xIGlzc3VlIGluIFRYIHJlc3luYyBmbG93JykNCj4gPiAgKCdu
ZXQvbWx4NWU6IEZpeCBlbmRpYW5uZXNzIGhhbmRsaW5nIGluIHBlZGl0IG1hc2snKQ0KPiANCj4g
UXVldWVkIHVwLCB0aGFua3MuDQo=
