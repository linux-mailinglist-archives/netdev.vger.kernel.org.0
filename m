Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86D67286185
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 16:49:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728694AbgJGOtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 10:49:20 -0400
Received: from hqnvemgate26.nvidia.com ([216.228.121.65]:15477 "EHLO
        hqnvemgate26.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728571AbgJGOtT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 10:49:19 -0400
Received: from hqmail.nvidia.com (Not Verified[216.228.121.13]) by hqnvemgate26.nvidia.com (using TLS: TLSv1.2, AES256-SHA)
        id <B5f7dd5630000>; Wed, 07 Oct 2020 07:49:07 -0700
Received: from HQMAIL111.nvidia.com (172.20.187.18) by HQMAIL111.nvidia.com
 (172.20.187.18) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Wed, 7 Oct
 2020 14:49:19 +0000
Received: from NAM12-BN8-obe.outbound.protection.outlook.com (104.47.55.177)
 by HQMAIL111.nvidia.com (172.20.187.18) with Microsoft SMTP Server (TLS) id
 15.0.1473.3 via Frontend Transport; Wed, 7 Oct 2020 14:49:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=E1MbZzSfZ3i3+LbVq7y14otxUC5Lb137/Ti2YOYHuy0gU+yJl0i6oWOkYCLGRt+cKVZm6Uov5/9iARmW228vX3J/+vtuvwsVdL0vRpHfiTpHsUiyUlfFl2h4gc69oO5VLOYE3M8JF+zSkv+uQiSfcea/i0ek/k2EVafgiszM4wvlO8VdGUTFLNZDSLRRVKsIsBHmR05tNFm3V75gbli6oaZcEwRQ1MY/CT+7jRJozgYQ/ynv5Y9yoXRWb+lhHgjf29nAEOwBnsdQ9SaPDY4dovcY9mQQx6thju9uWnCBfcGoBaeGBkbHZAbnfi1z25tUZp1M/bhVQlqjH8pEcbIaNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3Jc9d6oKhSlWFgXQPSyR4MIJKx1eafTynQ0vc7DYmec=;
 b=TNb545avd8zZRVDp3Y2FjXAyq1pJqbJcxmAjC2vOV1JzNxP+WZbZ2FNq3t9+0DGu6RUGiiwb7hrmPieeygaKymje05gwy9OsLEtCacJGLZ9QJrhhfmeG/ExYvEAjWi1C8rK2F+EcOY0v1+E2S/IvbwqsJEaZU6zw8NMoRFmu/InLL18y8opZ+qj/Q360PI4WQOUUIz/QxOWY5OJBcb9Q+vQF0DmCmTumj2VQ5Nuu3QYwyOUMhh10N99elknz8Y4WLVfCKa+HfhAnVir6Zl5wX7cCcpWxl1lPe1vONvjjJ3K5NNHJgHXahblt+2DvPDbqkrW2WAo9e2m6tkjs70hmxQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nvidia.com; dmarc=pass action=none header.from=nvidia.com;
 dkim=pass header.d=nvidia.com; arc=none
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com (2603:10b6:3:e3::23)
 by DM5PR1201MB2522.namprd12.prod.outlook.com (2603:10b6:3:ec::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3455.21; Wed, 7 Oct
 2020 14:49:17 +0000
Received: from DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62]) by DM5PR1201MB0010.namprd12.prod.outlook.com
 ([fe80::4517:3a8d:9dff:3b62%9]) with mapi id 15.20.3455.023; Wed, 7 Oct 2020
 14:49:17 +0000
From:   Nikolay Aleksandrov <nikolay@nvidia.com>
To:     "bridge@lists.linux-foundation.org" 
        <bridge@lists.linux-foundation.org>,
        "henrik.bjoernlund@microchip.com" <henrik.bjoernlund@microchip.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "Roopa Prabhu" <roopa@nvidia.com>,
        "UNGLinuxDriver@microchip.com" <UNGLinuxDriver@microchip.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "horatiu.vultur@microchip.com" <horatiu.vultur@microchip.com>
Subject: Re: [PATCH net] bridge: Netlink interface fix.
Thread-Topic: [PATCH net] bridge: Netlink interface fix.
Thread-Index: AQHWnKKpyTxrd+oPIUur9lgPN8/sf6mMOMkA
Date:   Wed, 7 Oct 2020 14:49:17 +0000
Message-ID: <32183f25a3d7ee8c148db42fbed9dd2a6e0a1f92.camel@nvidia.com>
References: <20201007120700.2152699-1-henrik.bjoernlund@microchip.com>
In-Reply-To: <20201007120700.2152699-1-henrik.bjoernlund@microchip.com>
Reply-To: Nikolay Aleksandrov <nikolay@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=nvidia.com;
x-originating-ip: [84.238.136.197]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 31a10b83-4b43-4a6b-5e0e-08d86ad02a9d
x-ms-traffictypediagnostic: DM5PR1201MB2522:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DM5PR1201MB2522F15AA272EB1849D791B1DF0A0@DM5PR1201MB2522.namprd12.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: raYIsBUYU8p7iPO02pTxX0DDZCe3nRqJe4fBc46nFFjKRJ6CPhnSnOAJLRXO930pcvRaMHjgCS4a64KFeyWSD3c+VllkJgZlYONJjXX3JPltbYz7bjF410Ooh6kdhbR5fsgNgKdC49lK1wA6rOPfxdy/Mpfzb7GVc+5c+izc6thhNSqrRBE6UpiIHlkVBzKENm5/dGEDu82Ja9t7jZbdMyxa6oCnYdUfwrGychtXTjC5cdVnBSr+gzYzzpkPQ/lX751XDXTF7Mg0A0T+tL2Bqne8fjxFAZi64xOpDgf9md2QHlM9jQ3rcwDZ+m+1erQE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR1201MB0010.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(136003)(39850400004)(366004)(376002)(346002)(396003)(110136005)(6512007)(3450700001)(316002)(2616005)(26005)(186003)(86362001)(6506007)(36756003)(66446008)(91956017)(5660300002)(66476007)(66946007)(66556008)(4326008)(6486002)(64756008)(8936002)(8676002)(478600001)(83380400001)(2906002)(4744005)(71200400001)(76116006);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: LwFttifwlcMlRJ9crNgJj8DTRM2RaikD1NswHR3nfrVmCCxJIVhxuzOJMJtTGSwBALgGwG5XtEV3DhDqveBwOlupY0jnSwJ/YjnKkacXRwcy0KuHB7C3nvTqBflI8KgdyxgOsp2M8OPNLFHRG9zIuHgEZRa+HDgMVrg1/mhBmFvEyrn1u7phIF1I2JpJvvtg/+u0a3eF4wCUd2KskCektOtR0BegZvjhej1NuEsFR7Y3XbiRAp+hLe9Ww+oWGaW0XJScpQ4m5MklvENamSZ59pcPf48Gyc0YDsZWImdsYT0zwVPVNML2TIe4MzSQtJMxesIXNzi41ArmjhbwjVqlQxJoFuT9inxqsCBe0loDvvrg73+fyCeyRM3dYqikar4FAqdSdnF/rjv+IY8q4M+te5saWiOJthBCGFjzVlK9P50IwwIlWzeCuTh/sLWawiwFTgHtX8XqRCNYIJTPMvqPLh/DNK1CoBm1OsGDM4ZOmSy6hYhZ4urQmZ4OakiHSl/1ReYsF4b5LAujslyZ1wixMgFEN9e2r1FxByV+Nlv1GIB6QgF0ECaeEDEKg6NhZ267RaeeEK7DKoaN0LOfgnoxZ787OIrULWbx9M3pRp/LJw3+zkH4+BUg6eUVqzBF/EObs6Any0Wrr7zo6no7v9VxFw==
Content-Type: text/plain; charset="utf-8"
Content-ID: <54A55BAAEF11184F834429296B94FC63@namprd12.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR1201MB0010.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 31a10b83-4b43-4a6b-5e0e-08d86ad02a9d
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Oct 2020 14:49:17.2613
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 43083d15-7273-40c1-b7db-39efd9ccc17a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hzOh27YNxOn3flD0ElR/TP3l0X2DcLjaMAenivavVkjkb4o7wBlycNM/HbvNFQR2guJSHgokJ8ABj+vxk4eOcQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR1201MB2522
X-OriginatorOrg: Nvidia.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nvidia.com; s=n1;
        t=1602082147; bh=3Jc9d6oKhSlWFgXQPSyR4MIJKx1eafTynQ0vc7DYmec=;
        h=ARC-Seal:ARC-Message-Signature:ARC-Authentication-Results:From:To:
         CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:References:
         In-Reply-To:Reply-To:Accept-Language:Content-Language:
         X-MS-Has-Attach:X-MS-TNEF-Correlator:user-agent:
         authentication-results:x-originating-ip:x-ms-publictraffictype:
         x-ms-office365-filtering-correlation-id:x-ms-traffictypediagnostic:
         x-ms-exchange-transport-forked:x-microsoft-antispam-prvs:
         x-ms-oob-tlc-oobclassifiers:x-ms-exchange-senderadcheck:
         x-microsoft-antispam:x-microsoft-antispam-message-info:
         x-forefront-antispam-report:x-ms-exchange-antispam-messagedata:
         Content-Type:Content-ID:Content-Transfer-Encoding:MIME-Version:
         X-MS-Exchange-CrossTenant-AuthAs:
         X-MS-Exchange-CrossTenant-AuthSource:
         X-MS-Exchange-CrossTenant-Network-Message-Id:
         X-MS-Exchange-CrossTenant-originalarrivaltime:
         X-MS-Exchange-CrossTenant-fromentityheader:
         X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
         X-MS-Exchange-CrossTenant-userprincipalname:
         X-MS-Exchange-Transport-CrossTenantHeadersStamped:X-OriginatorOrg;
        b=LKdt3A/8P3dWCjD7skfoQ+HQ+cODP6DrpLiu+7pAg2yTupN/8DcmJHGuQzgoHyWZB
         wpwjDqKc+vASc802588Zo8s1FC08K4+ytCpAQXeuA/J3L5xzWenzKgbAU/DVXl9PUA
         Kgt2B05cCVKFI5WtHRcgeVFTEuhFYCNIlsBJtB+4wANrUPC3Tp69om5+mIhZ1muU9Y
         iyEFUE8wgn8vG1unamhmr+u5f+NkkBMfOuNy0gcVNZN8htBAgbelivavRHXTKiQfMQ
         m/DqBk85Axm/vu/Rtg28JRNVphtSB2RM+Bi3y8uqXl+LI6hZxDPxydscGEjtdRhsA4
         dxSDYwLCpCcTg==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDIwLTEwLTA3IGF0IDEyOjA3ICswMDAwLCBIZW5yaWsgQmpvZXJubHVuZCB3cm90
ZToNCj4gVGhpcyBjb21taXQgaXMgY29ycmVjdGluZyBORVRMSU5LIGJyX2ZpbGxfaWZpbmZvKCkg
dG8gYmUgYWJsZSB0bw0KPiBoYW5kbGUgJ2ZpbHRlcl9tYXNrJyB3aXRoIG11bHRpcGxlIGZsYWdz
IGFzc2VydGVkLg0KPiANCj4gRml4ZXM6IDM2YThlOGUyNjU0MjAgKCJicmlkZ2U6IEV4dGVuZCBi
cl9maWxsX2lmaW5mbyB0byByZXR1cm4gTVBSIHN0YXR1cyIpDQo+IA0KPiBTaWduZWQtb2ZmLWJ5
OiBIZW5yaWsgQmpvZXJubHVuZCA8aGVucmlrLmJqb2Vybmx1bmRAbWljcm9jaGlwLmNvbT4NCj4g
UmV2aWV3ZWQtYnk6IEhvcmF0aXUgVnVsdHVyIDxob3JhdGl1LnZ1bHR1ckBtaWNyb2NoaXAuY29t
Pg0KPiBTdWdnZXN0ZWQtYnk6IE5pa29sYXkgQWxla3NhbmRyb3YgPG5pa29sYXlAbnZpZGlhLmNv
bT4NCj4gVGVzdGVkLWJ5OiBIb3JhdGl1IFZ1bHR1ciA8aG9yYXRpdS52dWx0dXJAbWljcm9jaGlw
LmNvbT4NCj4gLS0tDQo+ICBuZXQvYnJpZGdlL2JyX25ldGxpbmsuYyB8IDI2ICsrKysrKysrKysr
LS0tLS0tLS0tLS0tLS0tDQo+ICAxIGZpbGUgY2hhbmdlZCwgMTEgaW5zZXJ0aW9ucygrKSwgMTUg
ZGVsZXRpb25zKC0pDQo+IA0KDQpUaGUgcGF0Y2ggbG9va3MgZ29vZCwgcGxlYXNlIGRvbid0IHNl
cGFyYXRlIHRoZSBGaXhlcyB0YWcgZnJvbSB0aGUgb3RoZXJzLg0KQWNrZWQtYnk6IE5pa29sYXkg
QWxla3NhbmRyb3YgPG5pa29sYXlAbnZpZGlhLmNvbT4NCg0K
