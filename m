Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A8CA972D
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 01:31:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730579AbfIDXbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 19:31:09 -0400
Received: from mail-eopbgr30064.outbound.protection.outlook.com ([40.107.3.64]:64737
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727125AbfIDXbI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Sep 2019 19:31:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=doeWmOg9pt0QdrtjfA7SppHTVgRR4yNLQs4YuXiUYLUzKsyx19Km3tT5Bo6gzamaakHVxkg0b4y3unwBdHXHsJOHHwD9xa5Pao8I05F85p6xRVrHzHxh1a39ty5NFXcQ0fxVcds4LUcAQa+Lc1MDvbBWM8Iq5FGAw3HGoTu2geeGB25nSYdjXUcHHkh9Ss/jol12W+0bpkdUTMTV/hEVoQhW3h4cm9X/QEYSW160h4Gpw95F9aODysSVbVW2iRzOuXV7WM5VXpgfsXKNN4W+p7n610gYet67lRTLe5twxvDTHfqZXWWCvDVF3IWYiaT1ko1VKT7ChgYkweoOrjWoZQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fwalek2FWq0Df7jpMWOQaJWbpV9k0J2PJBz2ED0BDM=;
 b=FC1f+hWkOlPVAnj+vdhZANw4tzDMiUt0QNzk+Ww/eJ7wjiqnJePtwDCZvl8tOQGuZB3KsPABMD9V3O2AH51ZTy73Kyqv8T0S2o8sOgQWxEIKaiEcz5d8vvps9i4OvAsgBWhSPxMXPKulUgs2ttyBB462+BBjUNyidDlehdeb05PF7byPOETmdjK55vHX7LQ4tsMyXY7zcbgpSQhOqYSUesiRLk3NQ1VK8BpfzuHDe+Md6tId9Ld0JJIBG5GzdZ0HpoVQv2c5KXm6g++2ouVncKd6F6Tj6BuczW0SSfcJgZGZiNtkUQfbrllY8j1fiJ1ACg6mofFt4GlwbJXkQ2GMLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7fwalek2FWq0Df7jpMWOQaJWbpV9k0J2PJBz2ED0BDM=;
 b=s8Sww/4DL4gRu0iBHHnW4gALy5GscsmTSxPJqGH9c4ym5Y5PpO5vLY0xgY+vIU9DbhzQMGr6g2WbvrvJAvBEU8pkJ/82m2EuQZTnqQbhvR3gNxxNphcVNQ/StOe7eM/S5KpeKnWzIghm06nGU7luT3MFv2g5+0cOBVUs6oDumxI=
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com (10.172.11.140) by
 VI1PR0501MB2174.eurprd05.prod.outlook.com (10.169.134.27) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2220.20; Wed, 4 Sep 2019 23:31:05 +0000
Received: from VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9]) by VI1PR0501MB2765.eurprd05.prod.outlook.com
 ([fe80::c4f0:4270:5311:f4b9%5]) with mapi id 15.20.2220.022; Wed, 4 Sep 2019
 23:31:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "colin.king@canonical.com" <colin.king@canonical.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "leon@kernel.org" <leon@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH][next] net/mlx5: fix spelling mistake "offlaods" ->
 "offloads"
Thread-Topic: [PATCH][next] net/mlx5: fix spelling mistake "offlaods" ->
 "offloads"
Thread-Index: AQHVY1hdH4X6Sw0SoUK7WFDT3woPXqccKvGA
Date:   Wed, 4 Sep 2019 23:31:05 +0000
Message-ID: <cff2a86e5ad9ead6a5d3595686bc50f5ba53cc25.camel@mellanox.com>
References: <20190904193841.20138-1-colin.king@canonical.com>
In-Reply-To: <20190904193841.20138-1-colin.king@canonical.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ca251d21-971c-460f-cdaa-08d7318ff4e6
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:VI1PR0501MB2174;
x-ms-traffictypediagnostic: VI1PR0501MB2174:
x-microsoft-antispam-prvs: <VI1PR0501MB21743AC6A1E8EDD72A289DCCBEB80@VI1PR0501MB2174.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0150F3F97D
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(396003)(136003)(346002)(376002)(366004)(199004)(189003)(81156014)(8936002)(8676002)(54906003)(26005)(110136005)(66946007)(305945005)(66476007)(66556008)(66446008)(36756003)(91956017)(186003)(86362001)(4326008)(25786009)(316002)(6436002)(81166006)(6512007)(102836004)(558084003)(6246003)(6506007)(64756008)(53936002)(476003)(11346002)(58126008)(446003)(2616005)(229853002)(14454004)(6486002)(76176011)(478600001)(486006)(2201001)(5660300002)(99286004)(71190400001)(6116002)(2501003)(66066001)(3846002)(71200400001)(2906002)(118296001)(256004)(76116006)(7736002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0501MB2174;H:VI1PR0501MB2765.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: HQo38FbrnSWGBSvPALp/JEz3SVK+chNqqMhSqoBPUy3iK5jH8rY/gjgOVTgS9xNJx8MDhm0Tb526W46cYRdjcPUkPJc5zFwVifk4RfW7h86jkWwdZ4UQd90DxG1iXXNxH5gPahYnmICMGqbO0CCBN3orlwRD7+qf3vbmCUGcV/DB0NB6BlBwqM2COBkpw/siL4HAgTAA+S59WLSCkR2w0q4W6TmwSoAt9xaTX0eT+Nrj6GQ/AAHB+J0SXmB9xeFRas16MRyZcHs7TV8q6UJoVzwnvELmEytVp77WR3HLYId7kQ7qg5jhX/es14vAsNqg+03QdmiFy3aaZSLKrRWrwKBDThShK0WqbbtU8S0c8TqBbdQoJWrfWZKuLZi+P35Lp7QxlNi33oQg2gQu8gPtNz5pzAwBnq0qIFbiFRpU+n4=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <BB12FC76D5D01345BEE725D1ACCA68F8@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ca251d21-971c-460f-cdaa-08d7318ff4e6
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Sep 2019 23:31:05.4260
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: VlTE9cEzuTNLPVqQ4JL/zXkublPX03MMlVmc4MEtUkIx04AA/arfx2JKldPKOrd0lPFZrgC2tWCsiZBmLdeyMg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0501MB2174
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA5LTA0IGF0IDIwOjM4ICswMTAwLCBDb2xpbiBLaW5nIHdyb3RlOg0KPiBG
cm9tOiBDb2xpbiBJYW4gS2luZyA8Y29saW4ua2luZ0BjYW5vbmljYWwuY29tPg0KPiANCj4gVGhl
cmUgaXMgYSBzcGVsbGluZyBtaXN0YWtlIGluIGEgTkxfU0VUX0VSUl9NU0dfTU9EIGVycm9yIG1l
c3NhZ2UuDQo+IEZpeCBpdC4NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IENvbGluIElhbiBLaW5nIDxj
b2xpbi5raW5nQGNhbm9uaWNhbC5jb20+DQo+IA0KDQpBcHBsaWVkIHRvIG5ldC1uZXh0LW1seDUu
DQoNClRoYW5rcywNClNhZWVkLg0K
