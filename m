Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA192A9729
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 01:31:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730533AbfIDXaw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 19:30:52 -0400
Received: from mail-eopbgr30049.outbound.protection.outlook.com ([40.107.3.49]:61765
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729963AbfIDXav (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 19:30:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ocXsRrGiBL4WFByAqTm4yd8AHRCZZUPJLX2lXe/CxtfNx0AostefLHp6KUWPtZqFz+GV5LciR/91J9wJUWzT8pAQI+D6xcsl5+enAfniJqJNl9vWGwuBhaL0E2mvHi2cNfhjk82luKwBteWfFtF5Lhv/5YwX/em/aFB+Mk1yj9EQ0Crmr+42RgGvj4HzG0H8Y+SCcX90XwkVRwZ50CKcOLtecTmlRZF4fGC72ZLxK1sTyCeMg6B5rvjse1Xd+qposdMqvCPghq6VEiOpP3PXcfladoWnLcm2G/d14iOZFraqNw/G5n00z8ShWmbodar8dAz5jzFLcFiwqiZMqQhN7A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgIw2fLMMMcjDxmGVr96dA5Wkk7DzsQAtnBnpcEFQcw=;
 b=ioY0P3bLZdGHwtLh0bcgA2eZFf5bBmaOln4OJg+o3Z4cgLRFOjDERTNlzHxFbuzCDteqo0f7Rv/6Fc3fazJs47oeTvY2bqQZzbfWud3IvMw+BMA7krYgplN68LZGJMeqVo69iVbeo9lTRDn/bKpoa9BRc4l+b6P3jVfqS1x9NKp6m7tncR7+krILCs8+Pu+WFt3/9LVvhkDET8eCc/aqiKTUE64GzWL+3iFqONJmC29nmmxxM7RI4RtPUNzYXl4n8M47tmUNPLHen3hmDCyQMQI79LVAWdzTKJvHjwGvNd7A6+5Xet79vQEhre6EsQCgHPkXlFEZu/UqyDhPMvA8Mw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rgIw2fLMMMcjDxmGVr96dA5Wkk7DzsQAtnBnpcEFQcw=;
 b=QtWjK3B/D7XeJF55hbJgNQ00c2WvI2DMiFUqNSsLRw23f+fGbYTaj0eDlIDD9t4NwbkC3hB3jbvVcOjqR9/Y6DzwWKNU3AWk07KAO1yaX/kRz23Uq3qPIxZ7HkkSfaoY25pQSDauGIoUhbX4wBUnDhDUBtHg6o8gNAHKbWbTlQY=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2174.eurprd05.prod.outlook.com (10.169.134.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Wed, 4 Sep 2019 23:30:48 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 23:30:48 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        Maor Gottlieb <maorg@mellanox.com>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] net/mlx5: fix missing assignment of variable err
Thread-Topic: [PATCH][next] net/mlx5: fix missing assignment of variable err
Thread-Index: AQHVY1cMQHDBtS2140Ov2q5+T37cXKccKt8A
Date:   Wed, 4 Sep 2019 23:30:48 +0000
Message-ID: <16073125f6bbc617a9ddc77441b9d3b840d50e28.camel@mellanox.com>
References: <20190904192914.19684-1-colin.king@canonical.com>
In-Reply-To: <20190904192914.19684-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec1cc122-e827-45d7-16b2-08d7318feabc
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2174;
x-ms-traffictypediagnostic: VI1PR0501MB2174:|VI1PR0501MB2174:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0501MB2174F96A14F6B4701C59B1E8BEB80@VI1PR0501MB2174.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7219;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(199004)(189003)(81156014)(8936002)(8676002)(54906003)(26005)(110136005)(66946007)(305945005)(66476007)(66556008)(66446008)(36756003)(91956017)(186003)(86362001)(4326008)(25786009)(316002)(6436002)(81166006)(6512007)(102836004)(6246003)(6506007)(64756008)(53936002)(476003)(11346002)(58126008)(446003)(2616005)(229853002)(14454004)(6486002)(76176011)(478600001)(486006)(2201001)(5660300002)(99286004)(71190400001)(6116002)(2501003)(66066001)(3846002)(71200400001)(2906002)(118296001)(256004)(76116006)(4744005)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2174;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OMVnnU2VNk01a/ttXBT057NCTE9xwEw5vt46xqJI2s0fPZ1OMa6UYH5vRq6vQjOh70jI2DSEBDQ420HIPdz7+QXZ7jaP4kjH09w3D4QYfR74STS1msnwRxJVXZWGzTFfs3QiEKPaFy8kmOjcs9ExX3DxITlLz6aytaf4WA4uHHzoInE1XvWL0tkzOvWsgfwV1UqI+87pkJk3/bLX8Axr4PpwPbXGEFt3F6vzFGBIvKkT0zldlq4dA5G2oOi6PqG2NNbTnwB5Gzy2znfM+SQUuqcYDKN7dWz9mmQm78KzePllniXTXaltakdGzSrJl1QxTcMGZxjtVdZ0AZw4StPcqhmOHnXoQqNPw4SeWTykLVEVp30jS4s+mudInOgMmwpa9K+u9JfyNQpVkE/TgoQmTBSUFPfXXmtzUmJHwYoNams=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6BD6F794F66F0D4DAFA95619B706143F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec1cc122-e827-45d7-16b2-08d7318feabc
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 23:30:48.3154
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Lv6P6ncs6K0Y6XGXR/7T3n7SX2pGBXkwX7EGDLWM6Gm4a6kk6XX+pEAEnMF1S3Yt0Qv8QDMblX858IG3ll/0Vw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2174
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA5LTA0IGF0IDIwOjI5ICswMTAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gVGhl
IGVycm9yIHJldHVybiBmcm9tIGEgY2FsbCB0byBtbHg1X2Zsb3dfbmFtZXNwYWNlX3NldF9wZWVy
IGlzIG5vdA0KPiBiZWluZyBhc3NpZ25lZCB0byB2YXJpYWJsZSBlcnIgYW5kIGhlbmNlIHRoZSBl
cnJvciBjaGVjayBmb2xsb3dpbmcNCj4gdGhlIGNhbGwgaXMgY3VycmVudGx5IG5vdCB3b3JraW5n
LiAgRml4IHRoaXMgYnkgYXNzaWduaW5nIHJldCBhcw0KPiBpbnRlbmRlZC4NCj4gDQo+IEFkZHJl
c3Nlcy1Db3Zlcml0eTogKCJMb2dpY2FsbHkgZGVhZCBjb2RlIikNCj4gRml4ZXM6IDg0NjNkYWYx
N2U4MCAoIm5ldC9tbHg1OiBBZGQgc3VwcG9ydCB0byB1c2UgU01GUyBpbiBzd2l0Y2hkZXYNCj4g
bW9kZSIpDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxjb2xpbi5raW5nQGNhbm9u
aWNhbC5jb20+DQo+IC0tLQ0KDQpBcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUuDQoNCkkgaGF2ZSBh
IGNsZWFudXAgc2VyaWVzIGNvbWluZyB1cCwgd2lsbCBzZW5kIGl0IGFsbCB0b2dldGhlciB0byAN
Cm5ldC1uZXh0IHNvb24uIA0KDQpUaGFua3MsDQpTYWVlZC4NCg==
