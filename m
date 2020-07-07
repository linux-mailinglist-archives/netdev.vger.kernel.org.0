Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEB3216495
	for <lists+netdev@lfdr.de>; Tue,  7 Jul 2020 05:32:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbgGGDcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 23:32:52 -0400
Received: from mail-vi1eur05on2084.outbound.protection.outlook.com ([40.107.21.84]:6025
        "EHLO EUR05-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727044AbgGGDcv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 6 Jul 2020 23:32:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GAWz0Z7rvm7zFPpIQ27D4OKHtVYpLh3bpQNRyAxT5XPxnEo22GT4m/6H+lFQ4LoOqzrj00HH++Ddnm4R5tefS1z+WuXpRJRnAxyfWbh2NELAMRkl2/dw8471R5WI3ak18a4FSVRhv2SC1RGPjNafcUJwUaeN9dQ9pQ93LHfYBLwLU8eeDF+YEp/B9np8wq1YWX035pmy3DmNi7oWQUOYv8djF4Sj3fglaDyP0IoN7B/LpRczh9IReT2z8tkv5AuRlUCoNsBQv9VgrWlCow4XamSFlmT7HgMysVXrgHUigNPHaBi4Qy4lLYGH+v21R3PMbN+K1VI0EsUPWp2wQ2lwgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=habpFCODOWgg5aW+ZWS2izBgnAMhATg2eUC61gGudrw=;
 b=MMRhlZYqK7EccKtYLjbzDXRg92v9lhmWBy14yH4+5OOe3VOLQDkOBOWi69ZHUyZqNVZNeH3Ft2ekaH8F+ahw43odXp2Di25fCpCXR2nPBkBvu6D/3mQeAQHgCLBZSKtikWoqSHtc8tgUC5UAVcvleXrqLZLHzX7X85j0PO5jLCZpnraQunYGsqWgzZp863o+JNaW8L3Wayyrb4UB4w2nLaznEQuOSp9qbXURA+fMmwnJ5TtYYnD6uBHCGqWesp4HLzK4ExIUekHKT5hROZpjN34yIpbiQSEmR71pVpGNPVM4y6h4MgwdtMd+8MtDE+iQqyflU36rDVw0yOlsCu6uzA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=habpFCODOWgg5aW+ZWS2izBgnAMhATg2eUC61gGudrw=;
 b=c2mdGqvqKwdVto64fFcvin8Pk91lMizUx9UNHeloTx3iHHSXLo3JEl51U8AvTseGBORvMoiXHP8iNyFnWzHs5Mb5LTcU9lSBb+zOnTHhl2DFCoAM0cnYbjCdkDZER192k5aDQtneVeSLu+iYB6PjELovcP89AqkK+BGuRrX7LKQ=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4512.eurprd05.prod.outlook.com (2603:10a6:803:44::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3153.28; Tue, 7 Jul
 2020 03:32:48 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3153.029; Tue, 7 Jul 2020
 03:32:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bigeasy@linutronix.de" <bigeasy@linutronix.de>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
CC:     "tglx@linutronix.de" <tglx@linutronix.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "leon@kernel.org" <leon@kernel.org>
Subject: Re: [PATCH net] net/mlx5e: Do not include rwlock.h directly
Thread-Topic: [PATCH net] net/mlx5e: Do not include rwlock.h directly
Thread-Index: AQHWUVk9W5JWRQW/Zk2VxUq1PuEY66j7e9uA
Date:   Tue, 7 Jul 2020 03:32:47 +0000
Message-ID: <8c4aaa265eda2af6fc574c7966b78c3a4fc574d9.camel@mellanox.com>
References: <20200703164432.qp6pkukrbua3yyhl@linutronix.de>
In-Reply-To: <20200703164432.qp6pkukrbua3yyhl@linutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 974b9776-ee56-45f8-5a76-08d822266b87
x-ms-traffictypediagnostic: VI1PR05MB4512:
x-microsoft-antispam-prvs: <VI1PR05MB4512CE3887D558657E068B46BE660@VI1PR05MB4512.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0457F11EAF
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: UP1qh/r9VApr4n/qJP8V7QzFuN0serwP6686cKJyC5YmIOPr6LotPEEncBuvnMZryWqnZrxIcDfhHDoXT8e3tBDH+UaoWBr7lEkpOOP+f6Si98TPi2nf1CpyE/pNAsOssy4shBKBvzOjPlXBxWju33F1Q2rC9jKYbqRuJCX19YTiKXE3lxGxHc/Pf4vr0J+TX13nW7UYrcOsQUdxZsTh0riU2xt7QNuBuww7RdAvRA1hxWNw3SBN7WAib4fsbUtSzqFkWyxk+y7tFnAI0aNQknnBQ44QFhIq1JICTSutQONZkgzxv+D/3opEazL49eU8GECJWr/qIh8/i22SGj1YJg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(376002)(136003)(346002)(396003)(39860400002)(26005)(6506007)(71200400001)(6512007)(36756003)(4326008)(2906002)(8676002)(86362001)(66446008)(64756008)(66556008)(66476007)(186003)(4744005)(8936002)(478600001)(316002)(83380400001)(2616005)(6486002)(76116006)(66946007)(110136005)(54906003)(5660300002)(91956017);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +NNRuBcX/WY32hJeyFh8xdbe/X+O7TVbQpDLAZzKXENStEaYuvzrI449/EDZT8awY7GBy4hQNWKUWYnFlu4Fh167vQrLMsEMxuFpVLV9yMoIniKhUn4/gciUEiPBwZOe3tHVsbDl9OIJXQIX+aJjsLuqI5hpd4yAECjIlHhY0w6pgKuVW/x5Y7OQT/8nEhFI3+aEOEULgrbvwG559TWU3BwxXC4Tr5KtD4kuxhZO4AfSe6C3Gul7ksw92o4Gknf6VnlWl9ACPorifOxJHKTcXJe5wLUQo7QKk570IJvYUSzmwDUS737bU+wp75trfEQ7RVVPwbmX9eibHBpIPwUzmYF4J1MwwhR2Mu0+tJfpTJWrW1AvPJn4S5GD2SZOHIm2zLeAvtkXlw6h7ySQarKEuNBYOMINeF8xKxHByO5hGHkkESoO+wEc9HcfXaAXAw1RVI5DzDE63pvjtcAv5KF+Wr0S+w4FrHigAbwXG66XuYk=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <85E5647C8B50CB48A4A91A232C2139FF@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 974b9776-ee56-45f8-5a76-08d822266b87
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Jul 2020 03:32:48.0099
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SQ7JKJs4r7hYuaKUvBoNUqz7SsI+CHcnMTBvlLMCrfhVBFO/3L94I5DnQAfUwffRZtD0VS/PpQv0CwthJsRUmw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4512
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA3LTAzIGF0IDE4OjQ0ICswMjAwLCBTZWJhc3RpYW4gQW5kcnplaiBTaWV3
aW9yIHdyb3RlOg0KPiByd2xvY2suaCBzaG91bGQgbm90IGJlIGluY2x1ZGVkIGRpcmVjdGx5LiBJ
bnN0ZWFkIGxpbnV4L3NwbGlubG9jay5oDQo+IHNob3VsZCBiZSBpbmNsdWRlZC4gSW5jbHVkaW5n
IGl0IGRpcmVjdGx5IHdpbGwgYnJlYWsgdGhlIFJUIGJ1aWxkLg0KPiANCj4gRml4ZXM6IDU0OWMy
NDNlNGUwMTAgKCJuZXQvbWx4NWU6IEV4dHJhY3QgbmVpZ2gtc3BlY2lmaWMgY29kZSBmcm9tDQo+
IGVuX3JlcC5jIHRvIHJlcC9uZWlnaC5jIikNCj4gU2lnbmVkLW9mZi1ieTogU2ViYXN0aWFuIEFu
ZHJ6ZWogU2lld2lvciA8YmlnZWFzeUBsaW51dHJvbml4LmRlPg0KPiAtLS0NCj4gSXQgd291bGQg
YmUgbmljZSBpZiB0aGlzIGNvdWxkIGdldCBpbnRvIHY1Ljggc2luY2UgdGhpcyBpbmNsdWRlIGhh
cw0KPiBiZWVuDQo+IGFkZGVkIGluIHY1LjgtcmMxLg0KPiANCg0KSSBkb24ndCBtaW5kIGFwcGx5
aW5nIHRoaXMgdG8gbmV0Lg0KDQpBY2tlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNhZWVkbUBtZWxs
YW5veC5jb20+DQoNCg0K
