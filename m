Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6856C27845C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 11:49:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727856AbgIYJtn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 05:49:43 -0400
Received: from mail-db8eur05on2075.outbound.protection.outlook.com ([40.107.20.75]:50145
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727495AbgIYJtn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Sep 2020 05:49:43 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hKuyi3egmi1KPiWp0JStOQHA35l6DpSlgRivF/jnc/Zv8Ohq0VwBEowbCBrh77uQlbwUPh7xKK7XmrPgk2RZjqQCFqQqCOHC/7LKfQnbwaiQge1H8tTlInCITIeFRdd/1nxzxu+SK3go8trsDlTP3wDlYKCxKCdAtHLSlAxSNofIbXiMJTP5//5PUDVuNFPl0LqBRpUl0IuijDp8803cUYoIPtaxI6v9xVUiAFMHgZRxJ3Qrlawshw4MGz79B+60LcXY9Fp4CjRMZi89YnaDL28xJo+AYgu65QajFgIuGfHadmfG2Zg+ezvpPPQQcMfxBwAD0cqxiRBzzOCIyNFw3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cj/N5nD20AKpoVWtCq33EzcGCJm6L8mJX0gBWsaL61g=;
 b=fgr7wdHziyN8QMnI75dZN8arQk9FrUOnKO0QxRFrQwn6WYPa4NoVblFV9t1OPzwM9Al8g6orYDKZwd1K2h8j1//8xWuVX/bSE7AGdvLOcu8GAbMn0NHAc7KWIPM/07JecUe7qjsGsIJHjQtLvGdQn5KP5fgw5U+ndNVjQn1N/NgUYur31fOsecPH7L1fGAMtyHvFOVJuoiPWyAtgD6SQJdCs63lMvZl3f4cUQiDTsWiPaOIqa6tlF3bwbawHgdxLSKYPm2CZ1D8//A6VW1UmQLVb+2U6fPGsZ/2KEFKrQ4JO/n6hdnQC7QRFjT7OFcUTmX+8H3yNsOAkKTHYJ5TFLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Cj/N5nD20AKpoVWtCq33EzcGCJm6L8mJX0gBWsaL61g=;
 b=G1yBb/adp9S7bSJRd/pOcmM2OHHjJeb1aXS/qJBpB8ty2NZdZZxQpWc9dvHYD5pOcR9x1SN9nDsXyWRB6qXFcnafJeLTt5Z66kOdzw4qg6bj2gImhxF2VvKn0YLwLx0omfKVJ3BOcXiVcZ0osIDcMAVLaHNSPHdRkpJ5HK1oSKE=
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com (2603:10a6:10:fa::15)
 by DB3PR0402MB3706.eurprd04.prod.outlook.com (2603:10a6:8:5::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3391.14; Fri, 25 Sep
 2020 09:49:33 +0000
Received: from DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68]) by DB8PR04MB6795.eurprd04.prod.outlook.com
 ([fe80::d12e:689a:169:fd68%8]) with mapi id 15.20.3412.022; Fri, 25 Sep 2020
 09:49:33 +0000
From:   Joakim Zhang <qiangqing.zhang@nxp.com>
To:     Marc Kleine-Budde <mkl@pengutronix.de>,
        "linux-can@vger.kernel.org" <linux-can@vger.kernel.org>
CC:     dl-linux-imx <linux-imx@nxp.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH linux-can-next/flexcan 3/4] can: flexcan: add CAN wakeup
 function for i.MX8
Thread-Topic: [PATCH linux-can-next/flexcan 3/4] can: flexcan: add CAN wakeup
 function for i.MX8
Thread-Index: AQHWkwrz8c+wtXLO9E26PNKKsphgzKl5GteAgAABB9A=
Date:   Fri, 25 Sep 2020 09:49:33 +0000
Message-ID: <DB8PR04MB6795E28AB76F9575519AD5ECE6360@DB8PR04MB6795.eurprd04.prod.outlook.com>
References: <20200925151028.11004-1-qiangqing.zhang@nxp.com>
 <20200925151028.11004-4-qiangqing.zhang@nxp.com>
 <f26c1dc3-f5f7-9a5a-ae2f-07cc2da6803e@pengutronix.de>
In-Reply-To: <f26c1dc3-f5f7-9a5a-ae2f-07cc2da6803e@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: pengutronix.de; dkim=none (message not signed)
 header.d=none;pengutronix.de; dmarc=none action=none header.from=nxp.com;
x-originating-ip: [119.31.174.71]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 7748ff03-1eb4-456d-3c90-08d861384eab
x-ms-traffictypediagnostic: DB3PR0402MB3706:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB3PR0402MB3706A345619087C28052E66FE6360@DB3PR0402MB3706.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G820tnRshS9sDRInd/mSp+5Fnfdc2Ueg2Mg+iz2+qKLoRwPj5KaVzkDPxDZKG0EJPm8A11RiW2aIdQ4ZryMM0AwuKb0JcXz5Cvv031SeZap89uuJ+K05ixKWjDNyAsRAqzSSjhbGnIllQg5q8q0j+8JPXVkFnJKFUZN7bv+nsoIYHa/Tvk9ol2Vb3nTDXgNclO/fHKHA6P0K18I432LgCNpwh45URM1fw9T8ZZDinB8SEhn56zcABFVuqzwT82IMARWj0oUWuelpCoTwYY2sYwlN6lLUALbUlet2S4Icg0aKmc9t1iwCigOuCwoxRu+XU9qLa8U+tk0IzhGOVx8oRxxocohpY1wDkhEYtg2zs0nvBPbLr7n5k3qd59G+u3ao3uVh5PgDMDpl0Qu5KdIvsA==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB8PR04MB6795.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(346002)(396003)(136003)(39860400002)(366004)(26005)(8676002)(110136005)(966005)(55016002)(76116006)(7696005)(83080400001)(9686003)(8936002)(83380400001)(316002)(71200400001)(64756008)(53546011)(66556008)(478600001)(66476007)(86362001)(66446008)(186003)(52536014)(4326008)(5660300002)(2906002)(33656002)(6506007)(66946007)(54906003);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: SslR1wIOdQNtTcYKHd/Tu74VH7aPuk47VwB8yVJVZ4Lp+TsPIVqGNOV6t84uflPE6eNFSsh0m8cN+DHw3zJlMSplpdF4K8fT+Jqr4reFItUAQJnzEykQbC8tJ8t5i01bdeYtNLRViTGESDBlU13Oa0aO7W46HOrM2AIuiDDHYN3aCL6vnL2Cr9faJqMB/YgkiIJI0zm69hceqUNcE4ds7Utkoz+Y1aqIPQpbO7Op3sOEP02upx265drtz/2uO3YgTbCG34ER6OKlbcdUZGSh5eyetLhw43G70fCsRJgIRAILf0VhmJ3Dx2kuoeuoCMb4m7F/CLupte/wZEkGqioO+eal9Z8DmRjY1Stm067I1HGikBo6M0shPaBC/ru80ArU96iEsSqglgJowxEy9LV4bIV2ghVYxTIbCC+fPBI3YzbsALf3paJQUNMvRzqnpjwpE9V2MMopJ/0wnGmk3DpfDRag3iZgnbuh+JB7H+zY/e2oxYHLgt4hbHX03Sd1Hg19G0WpwGKMAFOJfM5FEiul87XGLmO19nXO4Lh11RNLzLGzpDnWNwdWsqHyFWsH229qfSUzYfBUwGg0ja0vZ2K1M6gVTd/6T4+gR0ZMLbM5uDI8elpzcxh0fQaYYFIiycwaJ93964IrvbhhxldCY44n9A==
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DB8PR04MB6795.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7748ff03-1eb4-456d-3c90-08d861384eab
X-MS-Exchange-CrossTenant-originalarrivaltime: 25 Sep 2020 09:49:33.8504
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 69nrI7el8PKlZfPZWA8cPko4Ryn40FlkZ3+1tOfILJ2U1+doreoCQGXzNxoifLBQu4Dnma8iBBEE7ocnj3g7xQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB3PR0402MB3706
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQo+IC0tLS0tT3JpZ2luYWwgTWVzc2FnZS0tLS0tDQo+IEZyb206IE1hcmMgS2xlaW5lLUJ1ZGRl
IDxta2xAcGVuZ3V0cm9uaXguZGU+DQo+IFNlbnQ6IDIwMjDlubQ55pyIMjXml6UgMTc6NDQNCj4g
VG86IEpvYWtpbSBaaGFuZyA8cWlhbmdxaW5nLnpoYW5nQG54cC5jb20+OyBsaW51eC1jYW5Admdl
ci5rZXJuZWwub3JnDQo+IENjOiBkbC1saW51eC1pbXggPGxpbnV4LWlteEBueHAuY29tPjsgbmV0
ZGV2QHZnZXIua2VybmVsLm9yZw0KPiBTdWJqZWN0OiBSZTogW1BBVENIIGxpbnV4LWNhbi1uZXh0
L2ZsZXhjYW4gMy80XSBjYW46IGZsZXhjYW46IGFkZCBDQU4gd2FrZXVwDQo+IGZ1bmN0aW9uIGZv
ciBpLk1YOA0KPiANCj4gT24gOS8yNS8yMCA1OjEwIFBNLCBKb2FraW0gWmhhbmcgd3JvdGU6DQo+
ID4gVGhlIFN5c3RlbSBDb250cm9sbGVyIEZpcm13YXJlIChTQ0ZXKSBpcyBhIGxvdy1sZXZlbCBz
eXN0ZW0gZnVuY3Rpb24NCj4gPiB3aGljaCBydW5zIG9uIGEgZGVkaWNhdGVkIENvcnRleC1NIGNv
cmUgdG8gcHJvdmlkZSBwb3dlciwgY2xvY2ssIGFuZA0KPiA+IHJlc291cmNlIG1hbmFnZW1lbnQu
IEl0IGV4aXN0cyBvbiBzb21lIGkuTVg4IHByb2Nlc3NvcnMuIGUuZy4gaS5NWDhRTQ0KPiA+IChR
TSwgUVApLCBhbmQgaS5NWDhRWCAoUVhQLCBEWCkuDQo+ID4NCj4gPiBTQ1UgZHJpdmVyIG1hbmFn
ZXMgdGhlIElQQyBpbnRlcmZhY2UgYmV0d2VlbiBob3N0IENQVSBhbmQgdGhlIFNDVQ0KPiA+IGZp
cm13YXJlIHJ1bm5pbmcgb24gTTQuDQo+ID4NCj4gPiBGb3IgaS5NWDgsIHN0b3AgbW9kZSByZXF1
ZXN0IGlzIGNvbnRyb2xsZWQgYnkgU3lzdGVtIENvbnRyb2xsZXINCj4gPiBVbml0KFNDVSkgZmly
bXdhcmUuDQo+ID4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBKb2FraW0gWmhhbmcgPHFpYW5ncWluZy56
aGFuZ0BueHAuY29tPg0KPiA+IC0tLQ0KPiANCj4gSnVzdCBmb3IgcmVmZXJlbmNlLCB0aGlzIGZh
aWxzIHRvIGJ1aWxkIHdpdGg6DQo+IA0KPiBFUlJPUjogbW9kcG9zdDogImlteF9zY3VfZ2V0X2hh
bmRsZSIgW2RyaXZlcnMvbmV0L2Nhbi9mbGV4Y2FuLmtvXQ0KPiB1bmRlZmluZWQhDQo+IEVSUk9S
OiBtb2Rwb3N0OiAiaW14X3NjX21pc2Nfc2V0X2NvbnRyb2wiIFtkcml2ZXJzL25ldC9jYW4vZmxl
eGNhbi5rb10NCj4gdW5kZWZpbmVkIQ0KDQpZZXMsIEkgYnVpbGQgYXQgbXkgc2lkZSwgZHVlIHRv
IHNjdSBzeW1ib2xzIGhhdmUgbm90IGV4cG9ydCBvbiBub24tc2N1IHN5c3RlbXMuDQoNCkJlc3Qg
UmVnYXJkcywNCkpvYWtpbSBaaGFuZw0KPiBNYXJjDQo+IA0KPiAtLQ0KPiBQZW5ndXRyb25peCBl
LksuICAgICAgICAgICAgICAgICB8IE1hcmMgS2xlaW5lLUJ1ZGRlICAgICAgICAgICB8DQo+IEVt
YmVkZGVkIExpbnV4ICAgICAgICAgICAgICAgICAgIHwgaHR0cHM6Ly93d3cucGVuZ3V0cm9uaXgu
ZGUgIHwNCj4gVmVydHJldHVuZyBXZXN0L0RvcnRtdW5kICAgICAgICAgfCBQaG9uZTogKzQ5LTIz
MS0yODI2LTkyNCAgICAgfA0KPiBBbXRzZ2VyaWNodCBIaWxkZXNoZWltLCBIUkEgMjY4NiB8IEZh
eDogICArNDktNTEyMS0yMDY5MTctNTU1NSB8DQoNCg==
