Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DED55626E
	for <lists+netdev@lfdr.de>; Wed, 26 Jun 2019 08:38:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfFZGiF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Jun 2019 02:38:05 -0400
Received: from mail-eopbgr80048.outbound.protection.outlook.com ([40.107.8.48]:46238
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725876AbfFZGiF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 26 Jun 2019 02:38:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OzKx06qsLU7TtJWUXLnSYZQdwf2X5N/5mN2lcQO7GEQ=;
 b=R/8SloPnyU8HM4eqfttlmqo7P02KGZrY8jFn8vjaZiuP41/Kh7m6PpBOAERw+h0g61oE6vu6bxTbxhRV2rxWmAL3jutsCaOwH2WY0MituauwIJhpCjAouoQzHBSEMQmqB26lbV1fqY2O2ckE1zm5MlaDKvSCkxmIUX8X2fztJp8=
Received: from AM6PR05MB5288.eurprd05.prod.outlook.com (20.177.196.225) by
 AM6PR05MB5222.eurprd05.prod.outlook.com (20.177.191.88) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Wed, 26 Jun 2019 06:38:01 +0000
Received: from AM6PR05MB5288.eurprd05.prod.outlook.com
 ([fe80::18ed:d109:3c41:e2d8]) by AM6PR05MB5288.eurprd05.prod.outlook.com
 ([fe80::18ed:d109:3c41:e2d8%7]) with mapi id 15.20.2008.007; Wed, 26 Jun 2019
 06:38:01 +0000
From:   Tal Gilboa <talgi@mellanox.com>
To:     Sagi Grimberg <sagi@grimberg.me>,
        Saeed Mahameed <saeedm@mellanox.com>,
        "David S. Miller" <davem@davemloft.net>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@mellanox.com>
CC:     Leon Romanovsky <leonro@mellanox.com>,
        Or Gerlitz <ogerlitz@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [for-next V2 05/10] linux/dim: Rename externally used net_dim
 members
Thread-Topic: [for-next V2 05/10] linux/dim: Rename externally used net_dim
 members
Thread-Index: AQHVK5iht7Ts0vV/G0qmbH4NbsQw6qas6qcAgACRhIA=
Date:   Wed, 26 Jun 2019 06:38:00 +0000
Message-ID: <cb51f169-9861-9478-4a22-f6f2d8930b70@mellanox.com>
References: <20190625205701.17849-1-saeedm@mellanox.com>
 <20190625205701.17849-6-saeedm@mellanox.com>
 <c97bbab4-13a9-b9e1-69f2-d4aba43e1c06@grimberg.me>
In-Reply-To: <c97bbab4-13a9-b9e1-69f2-d4aba43e1c06@grimberg.me>
Accept-Language: he-IL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [193.47.165.251]
x-clientproxiedby: PR0P264CA0180.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1c::24) To AM6PR05MB5288.eurprd05.prod.outlook.com
 (2603:10a6:20b:64::33)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=talgi@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: d17f6993-b8ad-4df6-ab17-08d6fa00d53f
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB5222;
x-ms-traffictypediagnostic: AM6PR05MB5222:
x-microsoft-antispam-prvs: <AM6PR05MB52220235E21A5F6931628E82D2E20@AM6PR05MB5222.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2512;
x-forefront-prvs: 00808B16F3
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(396003)(136003)(39860400002)(366004)(346002)(376002)(189003)(199004)(54906003)(86362001)(81156014)(99286004)(31696002)(7736002)(8936002)(14454004)(6512007)(6436002)(229853002)(305945005)(6486002)(26005)(316002)(3846002)(31686004)(6116002)(110136005)(52116002)(53936002)(558084003)(6246003)(68736007)(6636002)(71190400001)(36756003)(4326008)(8676002)(66476007)(25786009)(81166006)(66946007)(73956011)(66556008)(71200400001)(476003)(53546011)(6506007)(2616005)(64756008)(486006)(66446008)(66066001)(5660300002)(186003)(76176011)(446003)(102836004)(2906002)(256004)(386003)(11346002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB5222;H:AM6PR05MB5288.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: sz7k/zhuHeSdJ0mMwgfiQW36kYc232BhYtrJBYtOl6QcolrTxsNMTzfNdJzPOz4+qrZ1rOVTV/EbGcfINqxkbO3N40/j47CkFTPuaCCQ52MgzNmUoQNnRrURSiYImH4yKpYFf7BpVDb+MCl3JOPdtGWOhDoCnRJNx/i9oxRCsP3a+sFGfoGTV0J8Y9qWC5Lcf9wR01E8ODG3iXzZ5SW5TshV1Z1MvwmhyuV0WKFhf6fT/tld8EUMEZPtRllEG1jicOKIc8E6rkbyTHef4+M7EO/CEn3mFJAoRzxb33DLrggH0n5ayd9z08ectAQbm+1bwd9VplQkrPuabDfHMidbsFs6YGYp07EHBfFr9vJqzCjyGhWnaQZR43wH04olXjI+dHHibnl/4JCQol+/k05DhHs0CujGCA2DEN5+Wq/nM+s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <698BA68745DA5346A1A3835B2C252C3A@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d17f6993-b8ad-4df6-ab17-08d6fa00d53f
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2019 06:38:00.9954
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: talgi@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB5222
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gNi8yNi8yMDE5IDEyOjU3IEFNLCBTYWdpIEdyaW1iZXJnIHdyb3RlOg0KPiBRdWVzdGlvbiwg
ZG8gYW55IG90aGVyIG5pY3MgdXNlIG9yIHBsYW4gdG8gdXNlIHRoaXM/DQpZZXMsIHNlZSB0aGUg
Y2hhbmdlZCBmaWxlcyBsaXN0IHVuZGVyIGRyaXZlcnMvbmV0IGZvciBleGlzdGluZyB1c2FnZS4N
Cg0KPiANCj4gUmV2aWV3ZWQtYnk6IFNhZ2kgR3JpbWJlcmcgPHNhZ2lAZ3JpbWJlcmcubWU+DQo=
