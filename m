Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2937DF1C4
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 10:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbfD3IFj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Apr 2019 04:05:39 -0400
Received: from mail-eopbgr740042.outbound.protection.outlook.com ([40.107.74.42]:54432
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725790AbfD3IFj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Apr 2019 04:05:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector1-aquantia-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hQ4f0HtgBOoAwxSuqRqzavM/htAlkGAloRbLUWNLEwM=;
 b=XhcEVhW7dY1/JRfkgM7lYcW6AVZwdGBo2TaxVFBpzPkPDgtGbwNc+zEX/N50L2c286oL/LzQFHt4nt9QCHI33TDFq28RYG7CcrMeipdsr2biLcsaWue9KFNL5lEQELkcKcXncOJE8+WkW8oe064o8kztVrLcrMaVMtsYhxjMYcI=
Received: from DM6PR11MB3625.namprd11.prod.outlook.com (20.178.230.149) by
 DM6PR11MB3386.namprd11.prod.outlook.com (20.176.123.13) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1856.10; Tue, 30 Apr 2019 08:05:33 +0000
Received: from DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653]) by DM6PR11MB3625.namprd11.prod.outlook.com
 ([fe80::f035:2c20:5a61:7653%3]) with mapi id 15.20.1835.018; Tue, 30 Apr 2019
 08:05:33 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "David S . Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Nikita Danilov <Nikita.Danilov@aquantia.com>,
        Dmitry Bogdanov <Dmitry.Bogdanov@aquantia.com>
Subject: Re: [PATCH v4 net-next 08/15] net: aquantia: use macros for better
 visibility
Thread-Topic: [PATCH v4 net-next 08/15] net: aquantia: use macros for better
 visibility
Thread-Index: AQHU/nL9LHyAAmhhAkGb+LUo1/O1mA==
Date:   Tue, 30 Apr 2019 08:05:33 +0000
Message-ID: <c9b48982-ecf0-b50f-234a-cde9679425f3@aquantia.com>
References: <cover.1556531633.git.igor.russkikh@aquantia.com>
 <6ee59f31c13b6cdc9b1a3b8fc1b258ad3b8e7848.1556531633.git.igor.russkikh@aquantia.com>
 <20190429221600.GQ12333@lunn.ch>
In-Reply-To: <20190429221600.GQ12333@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: BYAPR02CA0072.namprd02.prod.outlook.com
 (2603:10b6:a03:54::49) To DM6PR11MB3625.namprd11.prod.outlook.com
 (2603:10b6:5:13a::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 78dcfb8f-b4e1-4788-d75c-08d6cd429ebd
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:DM6PR11MB3386;
x-ms-traffictypediagnostic: DM6PR11MB3386:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DM6PR11MB3386AA768CDA6E103DEE4646983A0@DM6PR11MB3386.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 00235A1EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39850400004)(376002)(346002)(396003)(199004)(189003)(446003)(2616005)(11346002)(476003)(102836004)(73956011)(66446008)(486006)(386003)(66556008)(64756008)(66476007)(66946007)(66066001)(97736004)(68736007)(14454004)(186003)(8676002)(86362001)(558084003)(478600001)(8936002)(26005)(6506007)(81156014)(305945005)(7736002)(31696002)(72206003)(6916009)(966005)(2906002)(81166006)(4326008)(256004)(6512007)(6306002)(6246003)(52116002)(107886003)(76176011)(25786009)(31686004)(5660300002)(229853002)(316002)(6436002)(99286004)(44832011)(36756003)(3846002)(53936002)(6116002)(6486002)(54906003)(71200400001)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DM6PR11MB3386;H:DM6PR11MB3625.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: x97/3AOAdImpDim+htP51V1UUfEcgTx5Tua/GrfSXRerdhHJlOOILwhMPWGUSkYPHtn4PMPYAw+bUvgwTBpqppgEvGHhmzOKyckgZltp4D+7pRoMPqDR1enATmHZVX7SGNuzEXu+2O8ctYcAkWPvtZXgoMeIoZDkoiho5Yc9ookf5l5JGyayA7R6NknB3nC5X57qnFKVL2jnA7xoYHOLq6x+8aLIEozNS2UF11joGxnOdW05p/k5Jz5T7R4qqvtITkkOGDVOvmIeWrjfOdtbN7t2Hmh6LIeKSsM9Eayf10Ps9n+tuoFyavtWoLOQjOU2fG3ooi+31e4WA4kN+84iDVx6ErzH9gz/wzrK9gyezvfQrv2nfuUSNf6qe8KWGiKJgiPWGpRrWb8/JDINpXB0oxbpYTzv6xCmRA9fjeXLhaY=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2D53A84AE077A04BB78586B7904E15DC@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 78dcfb8f-b4e1-4788-d75c-08d6cd429ebd
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Apr 2019 08:05:33.7663
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR11MB3386
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4+IFNpZ25lZC1vZmYtYnk6IE5pa2l0YSBEYW5pbG92IDxuZGFuaWxvdkBhcXVhbnRpYS5j
b20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBJZ29yIFJ1c3NraWtoIDxpZ29yLnJ1c3NraWtoQGFxdWFu
dGlhLmNvbT4NCj4gDQo+IEhpIElnb3INCj4gDQo+IGh0dHBzOi8vd3d3LnNwaW5pY3MubmV0L2xp
c3RzL25ldGRldi9tc2c1NjcyMzguaHRtbA0KPiANCj4gUGxlYXNlIHJlbWVtYmVyIHRvIGFkZCBh
bnkgcmV2aWV3ZWQtYnkgeW91IGdldC4NCj4gDQo+ICAgICAgICBBbmRyZXcNCg0KSGkgQW5kcmV3
LA0KDQpXaWxsIGRvIGZvciBzdXJlIG5leHQgdGltZSEgVGhhbmtzIGZvciB5b3VyIGRldGFpbGVk
IHJldmlldyENCg0KICBJZ29yDQo=
