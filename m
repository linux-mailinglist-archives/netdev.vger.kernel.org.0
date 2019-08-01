Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C9677E21C
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 20:23:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730747AbfHASXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 14:23:54 -0400
Received: from mail-eopbgr10046.outbound.protection.outlook.com ([40.107.1.46]:62850
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727498AbfHASXy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 14:23:54 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DwryJ7HFY5UKpejA3AhhTS9/eaLbEJ3UEjP/QZkfGc95aZopvwJAt55FMGNWoo5W0MWl/wOx59L3DXzoOiNvsQxDFZgXS+BgSd863gSqSj3a0Q6Nhs5Cl6aCaDlSMKpIE2dFDarDpO2qamUOu2UHe+PeLntq5ADQK0d3+APGRN6N7zM+fJEWa0/ja8mvj2ViQd82Zkg9JpPilf1EUhcInpOpnG/jk55aSDba5ufkcAFUeH0kXHZ4OsBg640H9r4PuLNFEXTOZdNyhHYZVa/cy/XPAZjGCIiKSsRO0KmjmHMjJNsespZ6xi1Gz8s3e+HuqwvyXj7k6G5HovSuGbzY/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lK4juYqz2IJwxYsuETKll2wnhzl14StKlPr6Rgd5Y+Q=;
 b=gtH3Ir7s9wSyxqGTd3IRiWaAg0TyzuDEP1I0Zv3IG6FeDrQqrgn0NykAIgHQoHqPPXJBm4r9/P8hoXs73xetj/FqZCGYv3AhD92Bvh9Z961NfW31Iki1emhWAngrqKDGwiBHUXwmiQ7vJNzWZrouXhNgHuEBWVTA3UEhtDLO+O69oRC+MjrblFO53S8oWAhjA2W7+fD4BF/2cagcXNl0Z2I106RM4Qr+Ln8O2fCFSMOK1ZqHf59uVkSn1YmwdIUnNnAlHOF85N4WSGF04qnRz1RhHKH/I9kggLxitWc+COJqmFOduL9T9oWRwZoQPhaILK/6geT4fbfmqO1qIZk+Cg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lK4juYqz2IJwxYsuETKll2wnhzl14StKlPr6Rgd5Y+Q=;
 b=PqLhwt+9pE6sIYTGBgllGi88Drgb3l8Zs2dRCI28fLMQtLnOGsB/3tNdWKi7knIDx2T63poAzVBnsrUb7KasyEafFFTfhpFxr1IFCUN7PH7aMEHJZPqOtwjQ1cRuzGP57ve8Zqgkb/7vta5XEWEX3+DzHVRyyBZQLL+zpdTQI2c=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2707.eurprd05.prod.outlook.com (10.172.216.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Thu, 1 Aug 2019 18:23:50 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2136.010; Thu, 1 Aug 2019
 18:23:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Leon Romanovsky <leonro@mellanox.com>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 00/11] Mellanox, mlx5-next updates 2019-07-29
Thread-Topic: [PATCH mlx5-next 00/11] Mellanox, mlx5-next updates 2019-07-29
Thread-Index: AQHVRlJgGi9Ja1YAgk2f66wYwhD1Eqbmn6GA
Date:   Thu, 1 Aug 2019 18:23:49 +0000
Message-ID: <27ff59a378e1cd8848ffcb494825302f230cbb8d.camel@mellanox.com>
References: <20190729211209.14772-1-saeedm@mellanox.com>
In-Reply-To: <20190729211209.14772-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6ac21e3a-4e0c-4e0b-5346-08d716ad667e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM4PR0501MB2707;
x-ms-traffictypediagnostic: AM4PR0501MB2707:
x-microsoft-antispam-prvs: <AM4PR0501MB270756764A64F81ACA28AAC8BEDE0@AM4PR0501MB2707.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 01165471DB
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(376002)(396003)(366004)(346002)(136003)(199004)(189003)(53754006)(6436002)(2616005)(118296001)(36756003)(476003)(305945005)(316002)(478600001)(486006)(26005)(450100002)(2501003)(186003)(446003)(66556008)(14454004)(66066001)(11346002)(6506007)(99286004)(6512007)(3846002)(6116002)(91956017)(76116006)(4744005)(110136005)(66476007)(6246003)(102836004)(58126008)(8936002)(81166006)(7736002)(66946007)(8676002)(71190400001)(76176011)(5660300002)(64756008)(6486002)(68736007)(229853002)(71200400001)(86362001)(2906002)(25786009)(66446008)(256004)(53936002)(81156014)(15650500001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2707;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: kxJlG5M37f1mq8CXdt0h3KWOkXZibEzmQUrP9H8w3QtrCJur7wzQjD3jzNnOA4eiVHHrFW0DVpPvb9wJ+Qd9cTPx74us4f4ADX4nfQ9KZ2JjteryxPLHiS7IYsHqLMOeFziaZiB7SFUhFQ2V9guk+J3BPqJUTrf2ol8PLbBWND+UyYNINsJMfzGVAANcOMfR5V5O+VL9Rn8tlKr8GeyOs82FwMH+rrxkgDsd1kpc1+ed8jIwGL2mE0sy6UKtW/CztTgkrzNcZx7D67jEp+nnGPWu1ju0C2Bo6Nw3L4Hch4CNGbav2R07zNkPUskdI1BseIeC2Wqxeh1e6+mxRUjhnezHkA4nxtKYezB+gd2UaVIbNUiYlSejs0kKjecyCfwkrLE1ZYp+gOGUGy7Qk9f1YB5gD24MpyuqsmMfuy/eZX4=
Content-Type: text/plain; charset="utf-8"
Content-ID: <7460EB523079B345B5183C1F2070C58F@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6ac21e3a-4e0c-4e0b-5346-08d716ad667e
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Aug 2019 18:23:49.9203
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2707
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTI5IGF0IDIxOjEyICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgQWxsLA0KPiANCj4gVGhpcyBzZXJpZXMgaW5jbHVkZSBtaXNjIHVwZGF0ZXMgZm9ybSBt
bHg1IGNvcmUgZHJpdmVyLg0KPiANCj4gMSkgRWxpIGltcHJvdmVzIHRoZSBoYW5kbGluZyBvZiB0
aGUgc3VwcG9ydCBmb3IgUW9TIGVsZW1lbnQgdHlwZQ0KPiAyKSBHYXZpIHJlZmFjdG9ycyBhbmQg
cHJlcGFyZXMgbWx4NSBmbG93IGNvdW50ZXJzIGZvciBibHVrIGFsbG9jYXRpb24NCj4gc3VwcG9y
dA0KPiAzKSBQYXJhdiwgcmVmYWN0b3JzIGFuZCBpbXByb3ZlcyBlc3dpdGNoIGxvYWQvdW5sb2Fk
IGZsb3dzDQo+IDQpIFNhZWVkLCB0d28gbWlzYyBjbGVhbnVwcw0KPiANCg0KQXBwbGllZCB0byBt
bHg1LW5leHQuDQoNClRoYW5rcywNClNhZWVkLg0KDQo=
