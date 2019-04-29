Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B2D9ED6F
	for <lists+netdev@lfdr.de>; Tue, 30 Apr 2019 01:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729230AbfD2X4z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 19:56:55 -0400
Received: from mail-eopbgr80043.outbound.protection.outlook.com ([40.107.8.43]:25474
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728844AbfD2X4z (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Apr 2019 19:56:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s9enm65Fmx4q0RhjGfaYPXrZcMwyGpu0c49ZMXx/umQ=;
 b=mgNK1AeNh5qit58tGSVXyYJBsSKt1vAE25uaadXxF4G5wcL/XjlA/BvQs+OWNUwdgU2FHrSNFE1mZbik3FwZYCrpLnmHj+eRWgBBNh6+/xT2tzNAeL9SkxOcygOR21Cp0H9ivc7U7DtF7RxJWsmXtVwdtXEmp58F6t9/il3RJ0Y=
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com (20.179.9.32) by
 DB8PR05MB5948.eurprd05.prod.outlook.com (20.179.9.222) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1835.12; Mon, 29 Apr 2019 23:56:50 +0000
Received: from DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07]) by DB8PR05MB5898.eurprd05.prod.outlook.com
 ([fe80::ed24:8317:76e4:1a07%4]) with mapi id 15.20.1835.018; Mon, 29 Apr 2019
 23:56:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH V2 mlx5-next 00/11] Mellanox, mlx5-next updates 2019-04-25
Thread-Topic: [PATCH V2 mlx5-next 00/11] Mellanox, mlx5-next updates
 2019-04-25
Thread-Index: AQHU/rdQCT5HmbSN5kGRKvPoPpHHQqZT0O6A
Date:   Mon, 29 Apr 2019 23:56:50 +0000
Message-ID: <d9de66c0da44c294809b32a8420d2a16b02c327e.camel@mellanox.com>
References: <20190429181326.6262-1-saeedm@mellanox.com>
In-Reply-To: <20190429181326.6262-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.30.5 (3.30.5-1.fc29) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7acc2115-50b2-454c-47ac-08d6ccfe58df
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5948;
x-ms-traffictypediagnostic: DB8PR05MB5948:
x-microsoft-antispam-prvs: <DB8PR05MB59480851634002FCCB62D5E6BE390@DB8PR05MB5948.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0022134A87
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39860400002)(346002)(366004)(396003)(376002)(189003)(199004)(99286004)(14454004)(26005)(6486002)(3846002)(4326008)(6116002)(76176011)(6436002)(66066001)(478600001)(4744005)(186003)(450100002)(6636002)(71190400001)(71200400001)(229853002)(6512007)(8936002)(25786009)(53936002)(6246003)(91956017)(6862004)(66476007)(305945005)(66446008)(6506007)(64756008)(5660300002)(7736002)(76116006)(36756003)(66946007)(66556008)(68736007)(118296001)(73956011)(256004)(37006003)(54906003)(446003)(81156014)(11346002)(81166006)(15650500001)(316002)(58126008)(486006)(2906002)(102836004)(97736004)(86362001)(476003)(8676002)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5948;H:DB8PR05MB5898.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: f6h1LYTbqAnykZKTR5w+VzigedhCWb8mfLirfBW3GLjhGqSlUsPHblF7dFpmfYPfmAESgkQtE3K2jF2b9dUliJhEPiPzKQwjmBCfmnYWlOrwtjQCaEQbg4dBX2HGfA4jzjlJOhAHyxW/qK3qRhIc3iyrXgC8S344rjdOYTF6aF+M3iZ6ScPEZIJoDr8QAbPWHAanoOAaGpcQPKnEMOZv2jS8OMfL/HHygTqlD0/kDm1iipwc9y8CXF/aM1/CXaNX9cX2VhZLQB9sCi17jrrrq+gswXiuBQ/h1F+SposSabgSZVFPPpq8dQi1Fhm1zezNfQ7yTGCK5f0K1YRxcLk5MNS3NeQQkIv17OXM0tAluGOJi1DT/XSj9YkC4/KK4LF7XNvu/5quKsbhKm/Ahx2U6DOd7nl2IYeDz5Spbw+I9ks=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FDD646D0202A3B4FA142F3AAF12A4D6E@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7acc2115-50b2-454c-47ac-08d6ccfe58df
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Apr 2019 23:56:50.3460
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5948
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA0LTI5IGF0IDE4OjEzICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGksDQo+IA0KPiBUaGlzIHNlcmllcyBwcm92aWRlcyBtaXNjIGxvdyBsZXZlbCB1cGRhdGVz
IHRvIG1seDUgY29yZSBkcml2ZXIsIHRvDQo+IGJlDQo+IHNoYXJlZCBiZXR3ZWVuIHJkbWEgYW5k
IG5ldC1uZXh0IHRyZWVzLg0KPiANCj4gMSkgRnJvbSBBeWE6IEVuYWJsZSBnZW5lcmFsIGV2ZW50
cyBvbiBhbGwgcGh5c2ljYWwgbGluayB0eXBlcyBhbmQgDQo+IHJlc3RyaWN0IGdlbmVyYWwgZXZl
bnQgaGFuZGxpbmcgb2Ygc3VidHlwZSBERUxBWV9EUk9QX1RJTUVPVVQgaW4gbWx4NQ0KPiByZG1h
DQo+IGRyaXZlciB0byBldGhlcm5ldCBsaW5rcyBvbmx5IGFzIGl0IHdhcyBpbnRlbmRlZC4NCj4g
DQo+IDIpIEZyb20gRWxpOiBJbnRyb2R1Y2UgbG93IGxldmVsIGJpdHMgZm9yIHByaW8gdGFnIG1v
ZGUNCj4gDQo+IDMpIEZyb20gTWFvcjogTG93IGxldmVsIHN0ZWVyaW5nIHVwZGF0ZXMgdG8gc3Vw
cG9ydCBSRE1BIFJYIGZsb3cNCj4gc3RlZXJpbmcgYW5kIGVuYWJsZXMgUm9DRSBsb29wYmFjayB0
cmFmZmljIHdoZW4gc3dpdGNoZGV2IGlzIGVuYWJsZWQuDQo+IA0KPiA0KSBGcm9tIFZ1IGFuZCBQ
YXJhdjogVHdvIHNtYWxsIG1seDUgY29yZSBjbGVhbnVwcw0KPiANCj4gNSkgRnJvbSBZZXZnZW55
IGFkZCBIVyBkZWZpbml0aW9ucyBvZiBnZW5ldmUgb2ZmbG9hZHMNCj4gDQo+IEluIGNhc2Ugb2Yg
bm8gb2JqZWN0aW9ucyB0aGlzIHNlcmllcyB3aWxsIGJlIGFwcGxpZWQgdG8gbWx4NS1uZXh0DQo+
IGJyYW5jaC4NCj4gDQo+IHYyOg0KPiAtICBBZGRyZXNzIGNvbW1lbnRzIGZyb20gTGVvbi4NCj4g
LSAgU3RhdGljIGNoZWNrZXIgZml4ZXMuDQo+IA0KPiBUaGFua3MsDQo+IFNhZWVkLg0KPiANCj4g
DQoNCkFwcGxpZWQgdG8gbWx4NS1uZXh0LA0KDQpUaGFua3MgIQ0K
