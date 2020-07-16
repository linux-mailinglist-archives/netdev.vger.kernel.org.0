Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A25221C46
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 08:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726337AbgGPGBZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 02:01:25 -0400
Received: from mail-eopbgr80083.outbound.protection.outlook.com ([40.107.8.83]:26278
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725844AbgGPGBZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jul 2020 02:01:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XnvJk3ObGSJkaoJWoIXy9gAYYUsyEnbY33JqNSyzXWtBmMncWPcfWJWetLzB8DMxzWS43z2cX1fvrCj5IZIjpjnspGCsPwNRhfAcQPnOYi79tmbmrMDnJlIwz/7IuWp+vehMW/QXlPd/6r6TAArKxN7DuQ+eIb7Di+CsceL2FfHInQud789QT2SOat2Df7wQujwCwJ9JT1kEir/lLNk36Tt6JeskfK1cewLgVZieOGRsRkk4ySgWrOb6iNgWezHjXxIGP6+S1deRyJyex1hOU9Qf+92f+J1iTWSIMcDFV2DYlpBBGPwzNN7e9pmIHdnaurSE8tSDJoebbbLYeQrfbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lX2UurhWesNLGlg85VW0kMeRsJLvWuz5+aU1v/JBto=;
 b=HJYFxIYKbsGtB7UIe9+lcPASPlQSHuoKN3NZMTs55qK96ZGdasuBulDgsHFH1EzYLSvxT6refzN7peB3BUur8awQP+KX1eLBB0XQKOLjUfhMcEFcTEM+AFSNyOPGcvSbA11Tx6zYCDyac7euxmQQZ3O+v8zFcfhGPt9UZN8xEvh9NvfOfnP707/TnHPYpk6gW/fDvoaqc0NURiX3QF2+haeDfzpJfS9BsPAsWzNsF5QPRwH9uVmi8TKTPS2xJZ1Q1RDGM7Mqi4Mw0XamrGUXm1nY3amIeoGSjkiPl84KrU/q0+9fvxjceC0Jlq1WEjJmbkIboJEq53cD+Q7HVQcH0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/lX2UurhWesNLGlg85VW0kMeRsJLvWuz5+aU1v/JBto=;
 b=WIvfgjxe1XUqgoTmHEzO2n1ocVHeviEgAmZ3ypr0Px3NQ2JGwHNvnZuTRglU0TkIePQ1xwUCNNlTKBYbH+7LgjS5fQdfKkytKcqBh4CxGVAnlaKANYtGwP+OLEl8y0XxWF0p8eRzKquwXRTOscWMciXlmt8CM5xnjdcob5/WZwU=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR0502MB3712.eurprd05.prod.outlook.com (2603:10a6:803:2::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3174.22; Thu, 16 Jul
 2020 06:01:22 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3174.027; Thu, 16 Jul 2020
 06:01:22 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/4] mlx5 next updates 2020-07-14
Thread-Topic: [PATCH mlx5-next 0/4] mlx5 next updates 2020-07-14
Thread-Index: AQHWWmB048u9+Gh8gESepMJyS0cOA6kJuEuA
Date:   Thu, 16 Jul 2020 06:01:22 +0000
Message-ID: <4d50b2dffcf28c470410e4644b62ed6d666df85c.camel@mellanox.com>
References: <20200715042835.32851-1-saeedm@mellanox.com>
In-Reply-To: <20200715042835.32851-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.3 (3.36.3-1.fc32) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2e92adaa-4496-4565-4e19-08d8294daa8a
x-ms-traffictypediagnostic: VI1PR0502MB3712:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0502MB37120F19EE8BCC4EB1D901E5BE7F0@VI1PR0502MB3712.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: G1ifBMu2lM9y1m1cb0pPeNQjkZlh30/Z0rzPmV6h7IJ8DAxoTB/nYvlMt9TycuRnXR0wUA5Rdx/9USdIpLGexlzB1ZcitYsEr5i8gN7e7FyHjlf4+XyaSJkRF6hRZ2XooeheEqNe+XVhjcUKCLkZEPJMzgEz200BUrGd9um0cGKc56wFe92cxWReVhPYXlkpH53skuv5t/S/7cu3v9UUjwHlAL84IX6JGFWX308Sp/nvC9kSiMhX9yIigKUxeS8xUdiNCmMSl+cokPRt8D6EkwhkGUkKE1sAh3sXrcTM1jEZ1T6zRBhyflqbIUvVx3UwPOWiwr7FLa73B0I+aEHS0g==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(346002)(396003)(136003)(366004)(39860400002)(4326008)(450100002)(2616005)(15650500001)(8676002)(8936002)(6862004)(36756003)(6486002)(478600001)(83380400001)(186003)(26005)(71200400001)(5660300002)(4744005)(86362001)(6512007)(54906003)(66446008)(64756008)(2906002)(66556008)(76116006)(91956017)(37006003)(6636002)(66946007)(316002)(6506007)(66476007);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: +nwN/MBc6M2cdF4wz4jXT07aq/hM3dpmjEfARIusxKhb+LmADbpUwVsF2TnIpX1JH25BiN6GiT+YaqDZE4ZJXZ8SGNJvIr4AqiQALenOVfIXa3jAygAcSS4ZHCBjGaTLvoerFdtwH2dNa5AW8Ov3e9/amiR7KMerkpnUi1YrttySKyEF2uvX7Fhr3z2Wn4pTABZgr5OUdK7ikx+1mlpDckpiRsEUzvIHnQP9jEwcrokH4JLF2k4ZVjIfPRz9L6TLBy2S/Rc67gbze1GFVp/NCDTOEup5W2aSHfHfBLuIeRGHd+B7IDoevmYAykcuzb5k3xHEt6F4vNx45ClefDojZ7QE+VyeSb0imjclru1IHglHfdSrC6mL0+sjkYhbe3esssbuSi8kImi7BvuF59ohGdwrQuIgV0NoNuJ9QW1Sp3aB5lsRFwJP9trv1cUZ/CIaH3alfOQRQmvret+DHhKGbIEzlXV+3JdI+5iA5qqSa+U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <60B82108A225FE45901210003D841B3E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: VI1PR05MB5102.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2e92adaa-4496-4565-4e19-08d8294daa8a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Jul 2020 06:01:22.0877
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ulV79uwi+TPUP3cYreIxLmTiZ2bUSIp6Rd8sToUX4R+Uo+03Wm9llwaUemlIQZJQTYF5dOkX91JScc7mBsBCCQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0502MB3712
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDIwLTA3LTE0IGF0IDIxOjI4IC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGksDQo+IA0KPiBUaGlzIHBhdGNoc2V0IGludHJvZHVjZXMgc29tZSB1cGRhdGVzIHRvIG1s
eDUgbmV4dCBzaGFyZWQgYnJhbmNoLg0KPiANCj4gMSkgRWxpIENvaGVuLCBBZGRzIEhXIGFuZCBt
bHg1X2NvcmUgZHJpdmVyIGRlZmluaXRpb25zIGFuZCBiaXRzIGZvcg0KPiB1cGNvbWluZyBtbHg1
IFZEUEEgZHJpdmVyIHN1cHBvcnQuDQo+IDIpIE1pY2hhZWwgR3VyYWxuaWsgRW5hYmxlcyBjb3Vu
dCBhY3Rpb25zIGZvciBzaW1wbGUgYWxsb3cgc3RlZXJpbmcNCj4gcnVsZS4NCj4gDQo+IEluIGNh
c2Ugb2Ygbm8gb2JqZWN0aW9ucyB0aGlzIHBhdGNoc2V0IHdpbGwgYmUgYXBwbGllZCB0byBtbHg1
LW5leHQNCj4gYW5kDQo+IGxhdGVyIHNlbnQgdG8gcmRtYSBhbmQgbmV0LW5leHQgdHJlZXMuDQoN
ClBhdGNoZXMgYXBwbGllZCB0byBtbHg1LW5leHQuDQpUaGFua3MgIQ0KDQo=
