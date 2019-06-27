Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF3ED57B6D
	for <lists+netdev@lfdr.de>; Thu, 27 Jun 2019 07:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726422AbfF0F3i (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jun 2019 01:29:38 -0400
Received: from mail-eopbgr30086.outbound.protection.outlook.com ([40.107.3.86]:5893
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725385AbfF0F3i (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 27 Jun 2019 01:29:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=I+4WzajZb2NolRYdTtemqYgBTB4DS0H+K2EV+WZ6lRg=;
 b=rdpUwYVk8vABPb+9vTA0k6+ijz3eYzGEZqQbw3dD436BnTjNHfJEH+1SILj52lM1ZbBrE7KY7mgLNPQMxP7rDkGw88JfepxsSG0xVuVWv3Px9c2L7FzpVmmn+ETLJCrxBGzILO2V5APGbXn06SgTOPsgxwd/7a2ZL0M93KQdAbU=
Received: from AM4PR0501MB2257.eurprd05.prod.outlook.com (10.165.45.27) by
 AM4PR0501MB2642.eurprd05.prod.outlook.com (10.172.215.148) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2032.17; Thu, 27 Jun 2019 05:29:35 +0000
Received: from AM4PR0501MB2257.eurprd05.prod.outlook.com
 ([fe80::4d19:2bbc:edde:4baf]) by AM4PR0501MB2257.eurprd05.prod.outlook.com
 ([fe80::4d19:2bbc:edde:4baf%7]) with mapi id 15.20.2008.014; Thu, 27 Jun 2019
 05:29:35 +0000
From:   Yamin Friedman <yaminf@mellanox.com>
To:     Sagi Grimberg <sagi@grimberg.me>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        Tal Gilboa <talgi@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [for-next V2 09/10] RDMA/nldev: Added configuration of RDMA
 dynamic interrupt moderation to netlink
Thread-Topic: [for-next V2 09/10] RDMA/nldev: Added configuration of RDMA
 dynamic interrupt moderation to netlink
Thread-Index: AQHVK5in78ka7kEMeUiDy0OdQxEiQ6as3xQAgAIcUwA=
Date:   Thu, 27 Jun 2019 05:29:35 +0000
Message-ID: <1c110b74-1731-936e-f4f2-2c880c453eb1@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-10-saeedm@mellanox.com>
 <f621af3b-37a3-eb97-368a-3201fa49f338@grimberg.me>
In-Reply-To: <f621af3b-37a3-eb97-368a-3201fa49f338@grimberg.me>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0021.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::33)
 To AM4PR0501MB2257.eurprd05.prod.outlook.com (2603:10a6:200:50::27)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=yaminf@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: e3612d6c-de51-4ca7-22ae-08d6fac070c0
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2642;
x-ms-traffictypediagnostic: AM4PR0501MB2642:
x-microsoft-antispam-prvs: <AM4PR0501MB26420341F81A14EA7B371491B1FD0@AM4PR0501MB2642.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4941;
x-forefront-prvs: 008184426E
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(396003)(376002)(39860400002)(346002)(366004)(199004)(189003)(31686004)(186003)(14454004)(4326008)(110136005)(478600001)(25786009)(7736002)(26005)(11346002)(54906003)(66556008)(446003)(229853002)(6116002)(2616005)(53936002)(3846002)(66946007)(68736007)(64756008)(66476007)(66446008)(316002)(73956011)(256004)(8676002)(71190400001)(71200400001)(52116002)(81156014)(81166006)(31696002)(86362001)(2906002)(99286004)(305945005)(386003)(53546011)(66066001)(6506007)(6512007)(36756003)(486006)(102836004)(6486002)(476003)(6636002)(6246003)(5660300002)(76176011)(8936002)(4744005)(14444005)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2642;H:AM4PR0501MB2257.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: n4xX/eubHkGRLLYvNmbu8tktboM+ZRVkWNI9YIH/O7IDCx0pZOVgn13qkfU6afAD5WD2nB1hx/Ra4oADrkfULUY0lVsbSiRp20io1ndkA5LrWYDsACTsO5Df6paC2YQd8Cm5I+oMHrEWkFWMM9dXOavyVul8qE4HzzTGAzDWPRzzAW7JOV+y/o580eDXuWIjfL5uOc2yBp92P8IiZ6aisbvu88YjgXVv9YYNSt1MJoBPzeyqG/MrBojWFgGk1BrpbbxHXbxKwTqnTgb0OFLGNnV6cQycMX5MvvvBhnLOhwYPkM3R7NTf0jMn4YD+m3syYPuBAsGqSLtIAu8OjTunKXB8G2C2W78/pd9B/KeWBxWO7QS8qPYpp0CUbFKWAgCdCa3pdRHhcAU0jTYXqXiUjMitOHF2mIZzdJbS8p0cY/o=
Content-Type: text/plain; charset="utf-8"
Content-ID: <898047FE2FDA7E4995C79E55B19E088E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3612d6c-de51-4ca7-22ae-08d6fac070c0
X-MS-Exchange-CrossTenant-originalarrivaltime: 27 Jun 2019 05:29:35.4861
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: yaminf@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2642
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpPbiA2LzI2LzIwMTkgMTI6MTUgQU0sIFNhZ2kgR3JpbWJlcmcgd3JvdGU6DQo+DQo+DQo+IE9u
IDYvMjUvMTkgMTo1NyBQTSwgU2FlZWQgTWFoYW1lZWQgd3JvdGU6DQo+PiBGcm9tOiBZYW1pbiBG
cmllZG1hbiA8eWFtaW5mQG1lbGxhbm94LmNvbT4NCj4+DQo+PiBBZGRlZCBwYXJhbWV0ZXIgaW4g
aWJfZGV2aWNlIGZvciBlbmFibGluZyBkeW5hbWljIGludGVycnVwdCANCj4+IG1vZGVyYXRpb24g
c28NCj4+IHRoYXQgaXQgY2FuIGJlIGNvbmZpZ3VyZWQgaW4gdXNlcnNwYWNlIHVzaW5nIHJkbWEg
dG9vbC4NCj4+DQo+PiBJbiBvcmRlciB0byBzZXQgZGltIGZvciBhbiBpYiBkZXZpY2UgdGhlIGNv
bW1hbmQgaXM6DQo+PiByZG1hIGRldiBzZXQgW0RFVl0gZGltIFtvbnxvZmZdDQo+PiBQbGVhc2Ug
c2V0IG9uL29mZi4NCj4NCj4gSXMgImRpbSIgd2hhdCB5b3Ugd2FudCB0byBleHBvc2UgdG8gdGhl
IHVzZXI/IG1heWJlDQo+ICJhZGFwdGl2ZS1tb2RlcmF0aW9uIiBpcyBtb3JlIGZyaWVuZGx5Pw0K
VGhhdCBtYWtlcyBzZW5zZSwgSSB3aWxsIGNoYW5nZSBpdC4NCg==
