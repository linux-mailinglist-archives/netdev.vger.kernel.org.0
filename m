Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61F9D3715F
	for <lists+netdev@lfdr.de>; Thu,  6 Jun 2019 12:13:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728088AbfFFKM7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 06:12:59 -0400
Received: from mail-eopbgr40047.outbound.protection.outlook.com ([40.107.4.47]:49987
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726972AbfFFKM7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 Jun 2019 06:12:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wV+yehDfRcc4JlvjLAqFar7m0+JZ88G4CYY4s2jh60c=;
 b=IPUTM9HKLg+bNg2roqHWupOKPaEWlc7Kjys5mSgrwG+8j3G+qHTRlSThOCkXydcRWAQ03eoJ2M4ccpLgbtgK7rIn5L6B0SCWBRWSMnmAp8Jcmm6I2vOYzlv1qHdG2vaRbXgIPTsIfxRN1VyTlop1O8xAsH8GaZQccsc3oMwFOb0=
Received: from AM6PR05MB6133.eurprd05.prod.outlook.com (20.179.3.144) by
 AM6PR05MB4246.eurprd05.prod.outlook.com (52.135.161.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1965.14; Thu, 6 Jun 2019 10:12:55 +0000
Received: from AM6PR05MB6133.eurprd05.prod.outlook.com
 ([fe80::1cec:5ce0:adab:7a12]) by AM6PR05MB6133.eurprd05.prod.outlook.com
 ([fe80::1cec:5ce0:adab:7a12%7]) with mapi id 15.20.1965.011; Thu, 6 Jun 2019
 10:12:54 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     Shalom Toledo <shalomt@mellanox.com>
CC:     Richard Cochran <richardcochran@gmail.com>,
        Ido Schimmel <idosch@idosch.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, mlxsw <mlxsw@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Thread-Topic: [PATCH net-next 4/9] mlxsw: reg: Add Management UTC Register
Thread-Index: AQHVGgXQP1IklGUwcU+S0muNLhm5KKaLjGoAgAFjlgCAAGLaAIAAGYkAgACBM4CAAG4EgIAAESiA
Date:   Thu, 6 Jun 2019 10:12:54 +0000
Message-ID: <87k1dzxbru.fsf@mellanox.com>
References: <20190603121244.3398-1-idosch@idosch.org>
 <20190603121244.3398-5-idosch@idosch.org>
 <20190604141724.rwzthxdrcnvjboen@localhost>
 <05498adb-364e-18c9-f1d1-bb32462e4036@mellanox.com>
 <20190605172354.gixuid7t72yoxjks@localhost>
 <78632a57-3dc7-f290-329b-b0ead767c750@mellanox.com>
 <20190606023743.s7im2d3zwgyd7xbp@localhost>
 <98e33c30-2f9c-277a-6a6a-6d9668a6c8ba@mellanox.com>
In-Reply-To: <98e33c30-2f9c-277a-6a6a-6d9668a6c8ba@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM5P194CA0008.EURP194.PROD.OUTLOOK.COM
 (2603:10a6:203:8f::18) To AM6PR05MB6133.eurprd05.prod.outlook.com
 (2603:10a6:20b:af::16)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [78.45.160.211]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 550a04ba-ad87-4499-3a55-08d6ea678a80
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB4246;
x-ms-traffictypediagnostic: AM6PR05MB4246:
x-microsoft-antispam-prvs: <AM6PR05MB42462DCD0899688C3F0B1455DB170@AM6PR05MB4246.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00603B7EEF
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(346002)(39860400002)(366004)(136003)(396003)(376002)(189003)(199004)(6116002)(3846002)(6246003)(256004)(7736002)(11346002)(476003)(6862004)(446003)(4326008)(86362001)(2616005)(26005)(71190400001)(102836004)(25786009)(71200400001)(53936002)(486006)(305945005)(6636002)(2906002)(66066001)(478600001)(186003)(4744005)(107886003)(5660300002)(64756008)(66556008)(66476007)(66946007)(73956011)(66446008)(229853002)(316002)(99286004)(52116002)(53546011)(6506007)(386003)(6512007)(54906003)(68736007)(76176011)(37006003)(81156014)(81166006)(6486002)(8676002)(6436002)(8936002)(14454004)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB4246;H:AM6PR05MB6133.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kaRKcKegH8tEV7Jag9xsKKsw6KLZH/uvYBxV0/i4uUenprdz4p+Ei4J9RQRPSv4tY3qjmWBhL9TcMWQ7yuswsbr8tLyw7TpnXgYCKb4pFpsOfJjisK+Fygy+/jOknru0eyuqJL1gFUcek5se8YwjZyqR9TVNe4YMPAXORN85a/OcSCCv4ybyqrLd+tZYnCrtaCITOw7zNvthj43YqDT3o0RqEXA346Oe4U+7z78mSkl/wLkOVYO89JwhhKoitEAx4Iys1ZaLMrwY/gj9RTWZ1knDMtjlx8sc1CQMffqaPJSIthKaKGhmzPG7Qwyz+rcT7fw3/A98BuIDeB5FN7pTT8eTr44Nv05mgomOnwS3sOa3pI+bAefR0kVwWQnRrZsmyi1w+efPUSAGJk3fdxhPGCMILDR+xfdZS6+EpyN4Aik=
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 550a04ba-ad87-4499-3a55-08d6ea678a80
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Jun 2019 10:12:54.9072
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB4246
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQpTaGFsb20gVG9sZWRvIDxzaGFsb210QG1lbGxhbm94LmNvbT4gd3JpdGVzOg0KDQo+IE9uIDA2
LzA2LzIwMTkgNTozNywgUmljaGFyZCBDb2NocmFuIHdyb3RlOg0KPj4gT2theSwgc28gdGhlbiB5
b3Ugd2FudCB0byBjb252ZXJ0IGl0IGludG8gVEFJIChmb3IgUFRQKSByYXRoZXIgdGhhbiBVVEMu
DQo+DQo+IE5vLCB0aGUgSFcgaW50ZXJmYWNlIGlzIGluIFVUQyBmb3JtYXQuIFRoaXMgaXMgcGFy
dCBvZiB0aGUgSFcgbWFjaGluZSB0aGF0DQo+IHJlc3BvbnNpYmxlIGZvciBhZGRpbmcgdGhlIFVU
QyB0aW1lIHN0YW1waW5nIG9uIFItU1BBTiBtaXJyb3IgcGFja2V0cy4NCg0KVGhlIHdheSBJIHVu
ZGVyc3RhbmQgaXQgaXMgdGhhdCBVVEMgaXMgYSBtaXNub21lci4gV2UgYXJlIGNlcnRhaW5seSBu
b3QNCnVwZGF0aW5nIHRoZSBsaXN0IG9mIGxlYXAgc2Vjb25kcyBpbiB0aGUgQVNJQyBzbyB0aGF0
IGl0IGtub3dzIGhvdyB0bw0KZ2V0IHRvIFVUQy4gKFRvIGJlIGNsZWFyLCBubyBzdWNoIGludGVy
ZmFjZSBldmVuIGV4aXN0cy4pIEJ1dCBpdCdzDQpjYWxsZWQgVVRDIGluIHRoZSBkb2N1bWVudGF0
aW9uLCBzbyB3ZSB3YW50IHRvIGtlZXAgdGhlIG5hbWUgZm9yIHRoYXQNCnJlYXNvbi4NCg==
