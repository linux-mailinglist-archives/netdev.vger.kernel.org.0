Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A05C1BCCAE
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 21:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728950AbgD1TrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Apr 2020 15:47:08 -0400
Received: from mail-db8eur05on2046.outbound.protection.outlook.com ([40.107.20.46]:6083
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728620AbgD1TrI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Apr 2020 15:47:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Rp+b8Scdkpgry7v3VLMTRPWrEZnb6ZcYkW2gEcRj+CWnRkSOkwv4fPDxtvPf/YhZ/TtejJhNiZNfsQDGZVXkoPaqd3AnT4iYBDe6TD0gugiPC2vxZigmcSchkyKFRGZcWWDpun4ZuhMuwYxeFQp2d3GORsLjarZS5t4djzfl4oyXlUhmJdefaBi4dMqiLVOUu9vRfYnObFjuiUfYhGQkSGDVT6TtHVV5jEzxlRcG+Sojjj/n+JIYfvR5mMlej2oK/h1jcphhtVVTQcDnduSx8AGAF0H8EgA1lbLseqwzPRTXzJwGpuaPWA/IudUJGUUlDkXbK+XXF90/PeYr0NnWsw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEHKWHxglI7JF2FookFPkAXTXTNkRh6nttdg8vPnGiw=;
 b=Mv9voATpjAmOMdHgYToq+2jqSGpWLVFWyKC/kYkrY3RM7Jqsr7TeUXNND2tzQ2FN4W5Ae8EyxB7RAyPUuIkij/B3q1W+19nI/83oVtuORr4DBKiCsIVT6HatupbKTPfqaGKUA5eQ0dmsfi7viKPIiD0JUI24Lks7b8pxAUkEsv+ptAFQgFZnp+D6IVVb3S8R2ZJBGicWtAH9O95Pmbr60qT4b/EXJ23+Dm7AmzGnXriaqm7rXKJ+O8fMQ7REqbUXtQbBCleWv8KreXr11Q4NanwpOxg4Ng1I1Ytf5u4zLb4Hc51MFIZSURy5RZm1QOD2Q10b8lhi+ac28LtCgbTyUg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=pEHKWHxglI7JF2FookFPkAXTXTNkRh6nttdg8vPnGiw=;
 b=l/3U9T/1WJc0TETHbssxuidlhOdE/f2hJjBGTG4Ha7fUxUY0Gb1Cf5xgn4U6PAbZdfAJWmfCnZoiqyz73is6i5s2p9YX5QktsBtF3zSajLr7t9WKqUPCux4sa0Y4Gq9zDOtKQ6tQC0f3vphTF4VgnXjwi6zzDybihfVUDlClV+E=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB6861.eurprd05.prod.outlook.com (2603:10a6:800:180::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2937.22; Tue, 28 Apr
 2020 19:47:04 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::9d19:a564:b84e:7c19%7]) with mapi id 15.20.2937.023; Tue, 28 Apr 2020
 19:47:04 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/9] Mellanox, mlx5-next updates 2020-04-24
Thread-Topic: [PATCH mlx5-next 0/9] Mellanox, mlx5-next updates 2020-04-24
Thread-Index: AQHWGnDqJYCj0TEvRUShTVEoyDwW36iO9rAA
Date:   Tue, 28 Apr 2020 19:47:04 +0000
Message-ID: <1ff8dcc7de4e8bc6f16010878db57b77d89ca3ca.camel@mellanox.com>
References: <20200424194510.11221-1-saeedm@mellanox.com>
In-Reply-To: <20200424194510.11221-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.34.4 (3.34.4-1.fc31) 
authentication-results: mellanox.com; dkim=none (message not signed)
 header.d=none;mellanox.com; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: b692b4aa-543c-44ac-37d1-08d7ebaced5c
x-ms-traffictypediagnostic: VI1PR05MB6861:|VI1PR05MB6861:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6861EC318D099F57B93A73F7BEAC0@VI1PR05MB6861.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0387D64A71
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(86362001)(66946007)(76116006)(64756008)(91956017)(66476007)(6506007)(66446008)(8936002)(37006003)(66556008)(2616005)(54906003)(26005)(36756003)(8676002)(6512007)(6862004)(6486002)(71200400001)(4744005)(5660300002)(498600001)(186003)(450100002)(15650500001)(6636002)(4326008)(2906002);DIR:OUT;SFP:1101;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: L+57qULG7XEIy/3+YXLr5gwN9c9vcIwhUkiO36ZRhl2sb2sUuKficup34n4dwvs5S+YiG2hrcHreHLxff5KqFe0gY2ssZHVQ5xv4nocrBAvSbWOFkwTrLf2H/iSriscSafydmVpH4+HOFYuNgRe53E5/3ZhDzUSjMdG6h0d5kedzpdMLp/f3puSooCUOnRpgxLYuO9SqiJd5sL1Og/kb0+0cABJiRyJPSx5XoPLGaoUbZMRtAoi+UnHvjnIBKO7cvxzQuef0/vRBHXhWkOe4OHRRrHS9j03NMOhYRp8dOKbFY2axa7jumW60jzTK0Qtx6Fozcknh1iLyuS9pWjqiMaue9Vd/F6yd4L+P+N/NY7GjDwxawBwm4Ab176pTEa0g2Slhqyda8zSJjscZDTTR8ndGUR/Kd5EihQ5/e28fz7lk7H53Ofyv1B9qTpuddG4B
x-ms-exchange-antispam-messagedata: lkaa3X0DmEeeg1KuQiGNM9rGeDdChzAbsYJdmJdaHAfoZL7OwrsmcsntUDVriMOHtoAb29QS6QKhyWun7v0QroI4D+XVx36R+New/CIqQWdadHyyIIa4ckcfUqSM5KiBOa1JpfzPIfglj3iKbpb2tZN7eDX5qFiBRpfhsDRdA2LrEs+wkiTS8giNL3oBG6Ddu6uI8BcTYj3x0kVy9K4BoKnthMC0ovXPUihd97lcrTCdu3aGJH7pMxFZ7GlkcXtL1S5YEqU5nJfrr2EXpgYhEo6dtdO1vliNiaV28dlEeu067rFsOXSk8cvL4TRUbQ6xB8YThUJVppasgMRTFivx22w3gPetgte6N1gozVNB0CX+pJS+8VA/W1YDdWdbaud6k/cOL1B7pzVYWQC/8i7432shp+sSJjMbmos5mZwc+mYBPgn+T+mUbzyqWfg3gxqkLoCSOWwzuKYLWU2UL4R0LLDiaL3weuFQ6SJXom2mXdIRYflh0GK3MA2+qSMfBcEx09TSURYT+1D8uMxVCEAwAhCYMTbqPfgGJyKf0SoMWMtaOpV3iVhgYfnioX/VNCP+e5mVj68VWpcysddq9wyx0vkUZ2N2zU/tFjweKmFrdVSFLsFHO/Q5tN3vn4u8Jtycestk7vEptAF3S36wd38ezTpz+FAWUjpZISwRVtJEpABrNyM5WvJdW29n0OH2Hf1XL8OicShQVMk4CjxU3H4VD+XmtRJdxYoxDPTTLbTxXbkgoNnGAa9rdbgxssnwo0JTq4/1+qp7JvMVhHFRSf/BLUSgggwYBMjefDF/OI7/xfg=
Content-Type: text/plain; charset="utf-8"
Content-ID: <AF404394BF85F34D9EDB1F06C9FFFB7B@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b692b4aa-543c-44ac-37d1-08d7ebaced5c
X-MS-Exchange-CrossTenant-originalarrivaltime: 28 Apr 2020 19:47:04.3601
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: o0jYyGwQuT31TTZwpBrlp6t3LUH0SKtPND0aXmWpS6IAqhEtV/BDAEpHpdY3RlbeQcIT9MOpqPnQtVeTI6llWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6861
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA0LTI0IGF0IDEyOjQ1IC0wNzAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGksIA0KPiANCj4gVGhpcyBzZXJpZXMgcHJvdmlkZXMgbWlzYyBtbHg1IHVwZGF0ZXMsIG1v
c3RseSBIVyBiaXRzIGFuZA0KPiBkZWZpbml0aW9uczoNCj4gDQo+IDEpIHJlbGVhc2UgYWxsIHBh
Z2VzIEZXIGNhcGFiaWxpdHkgYnV0DQo+IDIpIEFsaWduZWQgSUNNIG1lbW9yeSBhbGxvY2F0aW9u
DQo+IDMpIENPUFkgc3RlZXJpbmcgYWN0aW9uDQo+IDQpIGJpdHMgYW5kIGRlZmluaXRpb25zIGZv
ciBGVyB1cGRhdGUgZmVhdHVyZQ0KPiA1KSBJUFNlYyBhbmQgVExTIHJlbGF0ZWQgSFcgYml0cw0K
PiANCj4gSW4gY2FzZSBvZiBubyBvYmplY3Rpb24gdGhpcyBzZXJpZXMgd2lsbCBiZSBhcHBsaWVk
IHRvIG1seDUtbmV4dA0KPiBicmFuY2gNCj4gYW5kIHNlbnQgbGF0ZXIgYXMgcHVsbCByZXF1ZXN0
IHRvIGJvdGggcmRtYS1uZXh0IGFuZCBuZXQtbmV4dA0KPiBicmFuY2hlcy4NCj4gDQoNCmFwcGxp
ZWQgdG8gbWx4NS1uZXh0Lg0KDQpUaGFua3MgDQo=
