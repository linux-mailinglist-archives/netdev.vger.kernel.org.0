Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B697EA61FD
	for <lists+netdev@lfdr.de>; Tue,  3 Sep 2019 08:56:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727236AbfICG4h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Sep 2019 02:56:37 -0400
Received: from mail-eopbgr50041.outbound.protection.outlook.com ([40.107.5.41]:36355
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725919AbfICG4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Sep 2019 02:56:37 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BxK69q1iR5X+fpwYR7mdqcCiZqzGvssF4RjFWK6/t0fgnUymaI/YN8c57T1ryhH7GADhLkD3cp8Z0N8hYrmLPb88UIt5k1jiSdpqrUFFcbH6DzOasro1hinwWCeKmPzqTPl2rGtIkEheoI4NIWCuFNNPHIkmRG0WP6ls7uMAqql+fJDNSLZvmN2iO8P24u2tWOStcu/RBtlinUt85sRzxKwXWDjhXXbPW3uRDIZQc7PChpryTnJ01rDZWHuEJw4ggRocoChZRAord2BbUPzGvSHhqVhypZqSKzGFo4Xv19WxYVONYkRK9dQac3iiAnpYTuC6E/laReADYXUxIztAdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5T4G5kVlTIG8VY8/vR50LOXpTHYMWf/L83u2F4Ob7s=;
 b=P9Kc3pRbGK+R1NDUUX2FpqKyvsWf89KzsQEAHkSiIT6kFq5uTPH7co5W5lF0AOdJfyce+XfgzEjw7MLPk3l7DbigG52f1fCdiE3oPicUeROebUlo3YaG9CpbZrVroWtN0uzSy55lHW5PTXXUgOLGm3r1e1UC4+RID/be4am48fctUkO/PG9xR+NuW8Co2Z6bYCjQVlIRATVwQ/ezguReN/Wu11bZu8JTUAK1fj+4ZmeQR/JenGC1jRo+qeLjxoehfoXG8nUXn60dSgZ9fiR/k1vFndKBHIhbIdhCxeOYRiPeGaaZNhuckbR1zK5Eg+8ZIfMsuz/p+mZG26zccutDgw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=P5T4G5kVlTIG8VY8/vR50LOXpTHYMWf/L83u2F4Ob7s=;
 b=O7a9Qayk8G9r/m1QIhFSS2Bcmf7Z5dBcL7s1ms5+50Zbx0ahx6GU1x2NEfDlr3NTA3TUkz4KuiujQimGzk566zlpegducUpFuDVXgwgaAKqrtTCz8DPt2pFzcKMh5Jvq0hqGvRp4K2boRw5hQRSXLTog6uynm+GmXUKmc2/R/QE=
Received: from AM6PR05MB5460.eurprd05.prod.outlook.com (20.177.189.76) by
 AM6PR05MB6341.eurprd05.prod.outlook.com (20.179.7.207) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2199.20; Tue, 3 Sep 2019 06:56:33 +0000
Received: from AM6PR05MB5460.eurprd05.prod.outlook.com
 ([fe80::3d81:3325:7869:5e89]) by AM6PR05MB5460.eurprd05.prod.outlook.com
 ([fe80::3d81:3325:7869:5e89%3]) with mapi id 15.20.2220.022; Tue, 3 Sep 2019
 06:56:33 +0000
From:   Boris Pismenny <borisp@mellanox.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "oss-drivers@netronome.com" <oss-drivers@netronome.com>,
        "davejwatson@fb.com" <davejwatson@fb.com>,
        Aviad Yehezkel <aviadye@mellanox.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>
Subject: Re: [PATCH net-next 0/5] net/tls: minor cleanups
Thread-Topic: [PATCH net-next 0/5] net/tls: minor cleanups
Thread-Index: AQHVYhB39+k9MU4MDECg0cA4y0ovTqcZhUwA
Date:   Tue, 3 Sep 2019 06:56:33 +0000
Message-ID: <8579889b-7ad4-4d37-0141-db0b3d5d4b2a@mellanox.com>
References: <20190903043106.27570-1-jakub.kicinski@netronome.com>
In-Reply-To: <20190903043106.27570-1-jakub.kicinski@netronome.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: AM3PR04CA0127.eurprd04.prod.outlook.com (2603:10a6:207::11)
 To AM6PR05MB5460.eurprd05.prod.outlook.com (2603:10a6:20b:36::12)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=borisp@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [193.47.165.251]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 484b1306-74cc-460a-0278-08d7303bdae9
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:AM6PR05MB6341;
x-ms-traffictypediagnostic: AM6PR05MB6341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM6PR05MB6341F92AD0EDE75FDD88F614B0B90@AM6PR05MB6341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:663;
x-forefront-prvs: 01494FA7F7
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(346002)(39860400002)(136003)(376002)(366004)(199004)(189003)(14454004)(6246003)(25786009)(5660300002)(99286004)(81166006)(478600001)(4744005)(102836004)(26005)(6506007)(386003)(8936002)(53546011)(3846002)(6116002)(8676002)(256004)(14444005)(2501003)(54906003)(229853002)(110136005)(316002)(36756003)(76176011)(6512007)(4326008)(53936002)(11346002)(6486002)(446003)(71200400001)(186003)(66066001)(31696002)(7736002)(86362001)(31686004)(305945005)(2906002)(486006)(476003)(2616005)(6436002)(52116002)(81156014)(66446008)(64756008)(66946007)(66556008)(71190400001)(66476007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM6PR05MB6341;H:AM6PR05MB5460.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: lEwHYZ5lk4355SjrLFJ9wziDr6HjFLJnko+HCBNaNDzoJJy7FAQ1IajJIf4qldIdK50wN6zuhW/a8mxt5DKPwh3CobasJ36hq5+D8NwH24xQsJeP3oF1zlX/Dp7wnFKT/AzStNpx2wQPiG6TCLx7qj9OnuLnbsXeHD59pQ2u6GX4IJoftbEYilKxKrkcYcxgQF6xZn1+NoyEhwA6ggmNV0aGGVx2Mr+MSmTjSMiMeud6+s1RlAMVMZyrrsF8pWBp1AE0tugRME/EhHrNb3o8QwxmA2j9RmDAagPkCI9Chc4rLSRQ3wJ2sKkH9AkLB/21evttnrLgFY4LMhTbn8D50dniqTaFon31vJMcJywmZsQx3cFgriMbDLYJyJSOxZtgAb9eM9QbIFnFpi6nD2zL5cSyKGBZ1dezq4IFagxoT2U=
Content-Type: text/plain; charset="utf-8"
Content-ID: <CEC7A30B84A33A4492D2FF4B28D45F2C@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 484b1306-74cc-460a-0278-08d7303bdae9
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Sep 2019 06:56:33.4849
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 9NVWjzL5KAhfepn+kPZwMeMMhHXk56GeRXtahP68HK9GLfGWHkmf5bmHuz1BwPXoxgAFzELxyM2gjcqBa7bFEw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR05MB6341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gOS8zLzIwMTkgNzozMSBBTSwgSmFrdWIgS2ljaW5za2kgd3JvdGU6DQo+IEhpIQ0KPg0KPiBU
aGlzIHNldCBpcyBhIGdyYWIgYmFnIG9mIFRMUyBjbGVhbnVwcyBhY2N1bXVsYXRlZCBpbiBteSB0
cmVlDQo+IGluIGFuIGF0dGVtcHQgdG8gYXZvaWQgbWVyZ2UgcHJvYmxlbXMgd2l0aCBuZXQuIE5v
dGhpbmcgc3RhbmRzDQo+IG91dC4gRmlyc3QgcGF0Y2ggZGVkdXBzIGNvbnRleHQgaW5mb3JtYXRp
b24uIE5leHQgY29udHJvbCBwYXRoDQo+IGxvY2tpbmcgaXMgdmVyeSBzbGlnaHRseSBvcHRpbWl6
ZWQuIEZvdXJ0aCBwYXRjaCBjbGVhbnMgdXANCj4gdWdseSAjaWZkZWZzLg0KPg0KPiBKYWt1YiBL
aWNpbnNraSAoNSk6DQo+ICAgbmV0L3RsczogdXNlIHRoZSBmdWxsIHNrX3Byb3RvIHBvaW50ZXIN
Cj4gICBuZXQvdGxzOiBkb24ndCBqdW1wIHRvIHJldHVybg0KPiAgIG5ldC90bHM6IG5hcnJvdyBk
b3duIHRoZSBjcml0aWNhbCBhcmVhIG9mIGRldmljZV9vZmZsb2FkX2xvY2sNCj4gICBuZXQvdGxz
OiBjbGVhbiB1cCB0aGUgbnVtYmVyIG9mICNpZmRlZnMgZm9yIENPTkZJR19UTFNfREVWSUNFDQo+
ICAgbmV0L3RsczogZGVkdXAgdGhlIHJlY29yZCBjbGVhbnVwDQo+DQo+ICBkcml2ZXJzL2NyeXB0
by9jaGVsc2lvL2NodGxzL2NodGxzX21haW4uYyB8ICA2ICstDQo+ICBpbmNsdWRlL25ldC90bHMu
aCAgICAgICAgICAgICAgICAgICAgICAgICB8IDQ4ICsrKysrKysrKy0tLS0tDQo+ICBuZXQvdGxz
L3Rsc19kZXZpY2UuYyAgICAgICAgICAgICAgICAgICAgICB8IDc4ICsrKysrKysrKysrLS0tLS0t
LS0tLS0tDQo+ICBuZXQvdGxzL3Rsc19tYWluLmMgICAgICAgICAgICAgICAgICAgICAgICB8IDQ2
ICsrKystLS0tLS0tLS0NCj4gIG5ldC90bHMvdGxzX3N3LmMgICAgICAgICAgICAgICAgICAgICAg
ICAgIHwgIDYgKy0NCj4gIDUgZmlsZXMgY2hhbmdlZCwgODUgaW5zZXJ0aW9ucygrKSwgOTkgZGVs
ZXRpb25zKC0pDQoNCkxHVE0NCg0KUmV2aWV3ZWQtYnk6IEJvcmlzIFBpc21lbm55IDxib3Jpc3BA
bWVsbGFub3guY29tPg0KDQo=
