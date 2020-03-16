Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2A2471874A2
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 22:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732656AbgCPVTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 17:19:09 -0400
Received: from mail-eopbgr70051.outbound.protection.outlook.com ([40.107.7.51]:21138
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1732567AbgCPVTJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Mar 2020 17:19:09 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DC++W2T3HnG2jOAGEf8aYzuSjtE6ruz0KoJhw/GK7zVCCB++onwSYH2DXjfnHqfK314W24GxNVWFE3Mx/hW2zTs3XGRISdP8W0T2sfaf8UmnoVYDiA9uVOP1B7QoR2lmef8ziRDieAEMum4Hog0l7N9r8c8omNtljankGfPSB9GI45F/muTzkJwgIQugzCLINaETLqpgutNMsGtmqOYA4jY7XApBWJZddJD6j4DipiI1AtEbOSDTfbjbtC/K8IPnepT4lJT3shSGVpCm1cC2cvciFxy997Q2mtYVZcDEOfiZGSdcAxtB57boi8txsKZqisCInFJ1UCNaf2OMG8ykOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mHpFbhKjLPCe2gTl73mXkphR6XLMS7I7gQxSFBVRRg=;
 b=VqoqmCA4bnYtnrbCpoyuN3+r7xDbjNHciSC7t9AY1T6TsYU8bBDixxzprQK/PVS0n03JcGjWpajRgWjPW+9Bu/S+PMmClFT57peqkjQyhkyUkb4jAzrPRRG9LDngVgKBCrov2h0v5j0y33nU/CwkqVQPZcwKC1RVkNV7YQP0XqLr5KHiL7iVrEbR3QK4yjnaIAdFL06SIqRF6h+m87hSY/7kRHwqLUknHNi+KDUVhp/xWgSUEGSgdYFGZnyUcRViXhXR0kawFqXcg9J0zdlclEjahAgA19OMJv6CuHjHumCnpu+B/VXSwrp0hBS9sz9s24qFVISgLofH51sOoq85qA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=1mHpFbhKjLPCe2gTl73mXkphR6XLMS7I7gQxSFBVRRg=;
 b=W3QBmfns9h/NDx/pJrNS4JPqEya1+iuAg/557sD+ll8LVv5dUtsgOy/74Gg733uO0CdYu4Q8fOQMFyXzh2w8kQE0WZRAfuOLd6P6Bp2VHyHgLs/SphHTKZO8A2J1JM+efcS7iWaa63kk5ZhmEKSjvvQrPhuMfJymF0hQdpPz+7w=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4926.eurprd05.prod.outlook.com (20.177.52.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2814.22; Mon, 16 Mar 2020 21:19:05 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2793.023; Mon, 16 Mar 2020
 21:19:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "yuehaibing@huawei.com" <yuehaibing@huawei.com>,
        Jiri Pirko <jiri@mellanox.com>, Roi Dayan <roid@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Oz Shlomo <ozsh@mellanox.com>,
        "leon@kernel.org" <leon@kernel.org>,
        Paul Blakey <paulb@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net/mlx5e: CT: remove set but not used variable
 'unnew'
Thread-Topic: [PATCH net-next] net/mlx5e: CT: remove set but not used variable
 'unnew'
Thread-Index: AQHV+e4JaUSaLigfdEmB/1IwmiaykKhLvRgA
Date:   Mon, 16 Mar 2020 21:19:05 +0000
Message-ID: <d5acf4f27a5438d40ba5f53ec9cb498742202576.camel@mellanox.com>
References: <20200314104446.54364-1-yuehaibing@huawei.com>
In-Reply-To: <20200314104446.54364-1-yuehaibing@huawei.com>
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
x-ms-office365-filtering-correlation-id: 0ab72745-7533-417e-16a6-08d7c9efa88a
x-ms-traffictypediagnostic: VI1PR05MB4926:|VI1PR05MB4926:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB49264AA2279B5DD71D3E5FA6BEF90@VI1PR05MB4926.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1148;
x-forefront-prvs: 03449D5DD1
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(346002)(376002)(136003)(366004)(199004)(76116006)(110136005)(6486002)(2906002)(4744005)(5660300002)(54906003)(8676002)(81156014)(81166006)(6636002)(478600001)(8936002)(91956017)(316002)(36756003)(66946007)(186003)(66476007)(86362001)(26005)(71200400001)(6506007)(66446008)(4326008)(64756008)(66556008)(6512007)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4926;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: +OjH6zUnz4hmohebetZWjAGrr5snuq2HExLnfh4ttFdIUiOhlv/G6WWdoRjzxnmKNmXGBQiD591twyEmoyibpKBNy6qMJOHQ6sE6PnnGtahxd0asrvj8GOe8JW7CiADGAYWJGszvqmEqeGwJZiZ5De1zcP5npKzJrcaNRz54as2EAvPtr6RP0c8nFH53urFX9PYL6dg1lvyNXgx+eB2mMCdyigSIWyk+NVI+1zVzdfchvRaSmq3r9EggmQPQ05WRKolIWWfnNqFt9b/SN6Vs66JMLNKHjffYCrybauGOB5DrXpv+TsQ8leiGngPYmHuUuqmclcfOk/8oevyu3XjX0MYnnrbf2Iy+LK4MhmVl7WYCLWMMrTHNf+P0XNIJ1xWnaNiy7j59SdiY8iS9W8gRgs8mvSBJrqtHkjEEdPa4ewoH38c2k78hEYySqknjhvsX
x-ms-exchange-antispam-messagedata: MHfDNXeXdb51WkXBYHUIPwxqvzMwNAwIVctr0npTM0FFdGx9xNjwLCB2A9kPbujJGaIxaewABe958asXctH0G0clbBrS8vdqhw18K1gLfF4UKd+scj81KInyQiL7/IpvShEv1w0l1EI0Jn6m8SSWPQ==
Content-Type: text/plain; charset="utf-8"
Content-ID: <512337F70B95A048AD76561F50EDE3B7@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0ab72745-7533-417e-16a6-08d7c9efa88a
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Mar 2020 21:19:05.6894
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M9T4tHtCuvy8PeWURs2eWFlhfZZ7GGo613t43Wu7Iw23gwU1/j1PXKWY96q5pQxVU2tkjRr7kEbZZbxNf6vSFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4926
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gU2F0LCAyMDIwLTAzLTE0IGF0IDE4OjQ0ICswODAwLCBZdWVIYWliaW5nIHdyb3RlOg0KPiBk
cml2ZXJzL25ldC9ldGhlcm5ldC9tZWxsYW5veC9tbHg1L2NvcmUvZW4vdGNfY3QuYzoNCj4gIElu
IGZ1bmN0aW9uIG1seDVfdGNfY3RfcGFyc2VfbWF0Y2g6DQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0
L21lbGxhbm94L21seDUvY29yZS9lbi90Y19jdC5jOjY5OTozNjogd2FybmluZzoNCj4gIHZhcmlh
YmxlIHVubmV3IHNldCBidXQgbm90IHVzZWQgWy1XdW51c2VkLWJ1dC1zZXQtdmFyaWFibGVdDQo+
IA0KPiBjb21taXQgNGMzODQ0ZDllOTdlICgibmV0L21seDVlOiBDVDogSW50cm9kdWNlIGNvbm5l
Y3Rpb24gdHJhY2tpbmciKQ0KPiBpbnZvbGVkIHRoaXMgdW51c2VkIHZhcmlhYmxlLCByZW1vdmUg
aXQuDQo+IA0KDQpJIHRvb2sgdGhlIGxpYmVydHkgdG8gZml4IHRoaXMgdG8gYSBwcm9wZXIgIkZp
eGVzOiIgdGFnLg0KDQpBcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUNCg0KVGhhbmtzLA0KU2FlZWQu
DQoNCg==
