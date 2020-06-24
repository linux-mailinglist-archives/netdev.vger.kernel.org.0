Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBD12206CC4
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 08:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389266AbgFXGnU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 02:43:20 -0400
Received: from mail-vi1eur05on2072.outbound.protection.outlook.com ([40.107.21.72]:21089
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2388428AbgFXGnT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jun 2020 02:43:19 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JaXk4ef6O4Nii9KJUuymowHkyq8mw7fmcc/Yme+4bC6TIYAZfLFekXw+dZ6OgZjQVuQfCqh7dhk9sKMUFrFYqjoI9MUaIGHpaJxTAYCHcjE7Zn95aBBnJxTwwKqrUVAzzdz61sryMZCSDI1nGkgqa4WUTX5hgoCcAGUhR/9AZU8jvKQN0HOt6JH0Qvzub5PPhDyjSMe4anR89AffOqmmZ+JelkrYl4gD+WKSdYrY8NKLNlF2c7MHSuYKafujwZhEyMCgYOLfDtrSVr+1i16MlMPhP7UFRyxOSO3+puP4/giMaVcjXLrkjKk/VxrEeHsKXpT0MLhT7YyFIcrOVY/fvA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOul3kgwRLnwHHLTCBHTOIDgfGndH5PxxR+vYHypmBw=;
 b=JeXDwmIHgIl65MbOIWdJe8rWfyQgDMCvACmDm8fAq/jEdv0AWKRFgz6W9+yyU/YW4j1xLMHlvFUbTSCrcke9BNtQKjicLpCVY0EdhxQlmn5ZSb/FUF/Uhp/2HrmqkeaQpw0TFbG41k2/wF/lOFYbyJYWHVe6qHF6bzI/0h8bdyezfzgwlSfYmJS+XlwaEp9ll8WbFAVTLNV4QwiOyLLjnnzR4UJm44Nf+HeXGSRk/M/xAEtGH7QAwz+VErIpUtxOdjnV/nC/Kg1W2lwJl26oR2G9sLsyvAGiIVjjw+74L+P22+dw3jHhAyBwukSGarJYd3KYgW4nJdO21/J4tsfFQA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LOul3kgwRLnwHHLTCBHTOIDgfGndH5PxxR+vYHypmBw=;
 b=p2qgH0Xlm19qzmKNZRT1ALR3IN3sGtuyP/5s06FGA91X/k3AVV4chafsGaVFzJothv9CK29FJh6cpn+Ai8WUIPAbwYD62TmsGg7XbVVrP1c4ktAWStCp2BeLS+eAa8eMv8n+oPpuh9rNnbOiAzVF7fO0SM1Gkq4I0+FEZFUWb7g=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6317.eurprd05.prod.outlook.com (2603:10a6:803:102::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.20; Wed, 24 Jun
 2020 06:43:16 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3131.020; Wed, 24 Jun 2020
 06:43:16 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [pull request][net-next V3 0/9] mlx5 updates 2020-06-23
Thread-Topic: [pull request][net-next V3 0/9] mlx5 updates 2020-06-23
Thread-Index: AQHWSeKIMlZSQxUp9kWuIDvnAEOPYajnUbGA
Date:   Wed, 24 Jun 2020 06:43:16 +0000
Message-ID: <5ceffacf527ff45b244d3db069bb50abe7339b33.camel@mellanox.com>
References: <20200624044615.64553-1-saeedm@mellanox.com>
In-Reply-To: <20200624044615.64553-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [216.228.112.22]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: d8a02c32-ea8c-4a05-4375-08d81809e006
x-ms-traffictypediagnostic: VI1PR05MB6317:
x-microsoft-antispam-prvs: <VI1PR05MB63171F2DF3E40A0BBF8BEC9BBE950@VI1PR05MB6317.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 0444EB1997
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: insbwrwYwc+RgUWQ/0Pnk+Z0cUx2oGXWXR8CO1SFBZ3Cydhn1d0eSlxcJQzPQ8oOah7HJW7s5F/VVpbusD+wsbfi66wWZyEDEnwEtXkfeIiDZw0SQtd8bBbgo41wr5lA+dUyZe4eEsSenJZ59v99VNiJKOZl7CG3cceittyhI+gNt6f7LaWb1MXxKKquhj/cI2iVgzEvoyprtN3KTV1Z5loddMK5vCM6ulQF3lGBtyBhZWR11OPcvyrSi5gEJfLZTVvPDiOA12IrWC2qlXqlibgXWEzdgH/EPr0V5rLXzw0axOqhR04wmbBczV/YPn+Ti2aahSAPpBpBl1Xb7L4mQg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(136003)(396003)(39850400004)(346002)(366004)(376002)(26005)(5660300002)(4744005)(6486002)(8936002)(110136005)(36756003)(66946007)(66476007)(66556008)(64756008)(66446008)(15650500001)(83380400001)(71200400001)(186003)(86362001)(4326008)(91956017)(76116006)(6506007)(316002)(6512007)(478600001)(2906002)(8676002)(2616005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: bpOEev9GON+hArmffX1mEbcFGqNIRs+W1fc1zk7slMueuIk3ApPNqcmmhtqWr81ePGRg9RTtirKi1UKmlNWbvVG5eO/+tImKZiUmPs5nUb0xybCLKOYi75bEqUIsKdYIcwHlGB47dNpRWyG3tTzXnIIg2Mlx7Q86jgzKYd2vN2zELgly/VtXv1xY6YZqmrtOxZJpHTpwqfswn9EK9LcuYENxpRcjwYufnQzvI9kwgMZsTh9CQ383oOxtbONa9cFIUp2NS+XQ+ZuAJvg3hY+/4Dtf30pqzzsRqL+18rPzsU5s6QOOZgHghgm62Iu4YNhzRf72I3g4E9waiUxl68DU5UpG/MNnP5Z+BKI1RT2bkxjInn+jD9Nr3CggBY3M97ACdNCJaL976MLOL/PysvnYzofvWlPF43PsN2Hw6dkf9sgEpwCAbaM2NkoNgplzJZLU/qb+Gmf/MjCRjx09qp4lMsfvRkiDR47UPty2Q3/dH6DzG2/FiKv9H+oQ78gIVDS8
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <E355E636B0D8E04D84CBBC4A23E731FB@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d8a02c32-ea8c-4a05-4375-08d81809e006
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2020 06:43:16.3315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4/XSOqY8/voGMt3u5byhQjNptBzvuyHTGjl56QPMgktoZRTHK/0ThZjjBsdLA85NH4zFewrF79byJ7gHoMRjcA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6317
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA2LTIzIGF0IDIxOjQ2IC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgRGF2ZSwgSmFrdWINCj4gDQo+IFRoaXMgc2VyaWVzIGFkZHMgbWlzYyB1cGRhdGVzIGFu
ZCBvbmUgc21hbGwgZmVhdHVyZSwgUmVsYXhlZA0KPiBvcmRlcmluZywgDQo+IHRvIG1seDUgZHJp
dmVyLg0KPiANCj4gdjEtPnYyOg0KPiAgLSBSZW1vdmVkIHVubmVjZXNzYXJ5IEZpeGVzIFRhZ3Mg
DQo+IA0KPiB2Mi0+djM6DQo+ICAtIERyb3AgIm1hY3JvIHVuZGVmaW5lIiBwYXRjaCwgaXQgaGFz
IG5vIHZhbHVlDQo+IA0KPiBGb3IgbW9yZSBpbmZvcm1hdGlvbiBwbGVhc2Ugc2VlIHRhZyBsb2cg
YmVsb3cuDQo+IA0KPiBQbGVhc2UgcHVsbCBhbmQgbGV0IG1lIGtub3cgaWYgdGhlcmUgaXMgYW55
IHByb2JsZW0uDQo+IA0KDQpIaSBEYXZlLCBJIGRvbid0IGtub3cgd2hhdCBpcyBnb2luZyBvbiB3
aXRoIG1lIHRvZGF5LCBwbGVhc2UgZG9uJ3QgcHVsbA0KdGhpcyBqdXN0IHlldCwgSSBzZWUgYSBj
b21tZW50IGZyb20gSmFrdWIgb24gVjEgdGhhdCBJIG1pc3NlZC4NCg0Kd2Ugd2lsbCBkaXNjdXNz
IGFuZCB3aWxsIGxldCB5b3Uga25vdyAuLiANCg0K
