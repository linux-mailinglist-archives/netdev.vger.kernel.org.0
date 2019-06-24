Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4F96551D7B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 23:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730013AbfFXV5M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 17:57:12 -0400
Received: from mail-eopbgr60055.outbound.protection.outlook.com ([40.107.6.55]:3918
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726372AbfFXV5J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 17:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mVWeJvChTqJLvA5vhobksnWOT81SDJLcmFb0mIKOQoA=;
 b=GF5AdSxJqNhuSlzcC5oiI5eI+nE3eWxm7Pli8sSzdKoi3FulSvGjwcmx0g5iM9ow8polgsNg/5eCwY+sLdcTVepJwYoeD/2GmhHJEBKRWlYcA1YfI7qGGtmsKu/KCCF0pqhJbgTpZJ0swp+FjbTmYrsUYrJGeGBK1j2XOuBekjo=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2392.eurprd05.prod.outlook.com (10.168.73.10) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2008.16; Mon, 24 Jun 2019 21:57:05 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::a901:6951:59de:3278%2]) with mapi id 15.20.2008.014; Mon, 24 Jun 2019
 21:57:05 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "leon@kernel.org" <leon@kernel.org>
CC:     Jason Gunthorpe <jgg@mellanox.com>,
        Yishai Hadas <yishaih@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>,
        "dledford@redhat.com" <dledford@redhat.com>
Subject: Re: [PATCH rdma-next v1 00/12] DEVX asynchronous events
Thread-Topic: [PATCH rdma-next v1 00/12] DEVX asynchronous events
Thread-Index: AQHVJfl5PSbKJXA400e2KA/0k+cTY6ahwcuAgACmBoCACPu5AA==
Date:   Mon, 24 Jun 2019 21:57:05 +0000
Message-ID: <a8de53f1acb069057dedc94fb8bd29ea3e658716.camel@mellanox.com>
References: <20190618171540.11729-1-leon@kernel.org>
         <19107c92279cf4ad4d870fa54514423c5e46b748.camel@mellanox.com>
         <20190619044557.GA11611@mtr-leonro.mtl.com>
In-Reply-To: <20190619044557.GA11611@mtr-leonro.mtl.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.3 (3.32.3-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 731e5227-23ef-4a14-0f3f-08d6f8eee59d
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2392;
x-ms-traffictypediagnostic: DB6PR0501MB2392:
x-ms-exchange-purlcount: 1
x-microsoft-antispam-prvs: <DB6PR0501MB239274F3D46912ECD0876CD0BEE00@DB6PR0501MB2392.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 007814487B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(346002)(39860400002)(396003)(366004)(136003)(54534003)(189003)(199004)(2616005)(486006)(86362001)(476003)(54906003)(256004)(8936002)(81156014)(81166006)(1730700003)(73956011)(26005)(3846002)(6116002)(6512007)(25786009)(66066001)(68736007)(966005)(91956017)(66446008)(76116006)(64756008)(66556008)(71190400001)(8676002)(4326008)(102836004)(6916009)(4744005)(6506007)(229853002)(5660300002)(186003)(71200400001)(66476007)(7736002)(66946007)(6486002)(305945005)(2501003)(76176011)(118296001)(58126008)(2906002)(2351001)(36756003)(316002)(6306002)(6436002)(5640700003)(6246003)(14454004)(99286004)(446003)(11346002)(53936002)(478600001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2392;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 254LJye8qPuerQ4ZWfhuhnSawcke/ErjtQpC1ivAXwrccWbKtw8mqeIJtPjonr2Mndxk4LRwQx8ECqs70xj+Oc14f2GsCaGWBX9AuBXOdUDLHP43Euc8VODsSOiTMNGfLB+p1j/EyCvXhMPJ0nkC3foK05KMKMiq1lWeU2fSrXNSAcB6/qoGNDaYPQnkvsAv/vWH2LxmBspx2/QZ64vo8HLLx2WYpxKwOjxtk611k+ISMVOxzWvSLE7Qipigz1yCCx3UW9aNj7g3+UpyoOjE2SAOX6ejvbMJyBB3DYCcTgXv//EXdQ5DD10hfVqYJG47XFT8JMw0rRFyMlaCqh4NHNr5vhepzCCPdjkuTrGPPvyqTa/oirw/eu9IukzOE6NvkunYehPlBhNUKEkMP2k+rh3s8nU7GFAkYQpRZBSSdm8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <D58CD9665377FF479CD3B806169914B6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 731e5227-23ef-4a14-0f3f-08d6f8eee59d
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2019 21:57:05.7033
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2392
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA2LTE5IGF0IDA3OjQ1ICswMzAwLCBMZW9uIFJvbWFub3Zza3kgd3JvdGU6
DQo+IE9uIFR1ZSwgSnVuIDE4LCAyMDE5IGF0IDA2OjUxOjQ1UE0gKzAwMDAsIFNhZWVkIE1haGFt
ZWVkIHdyb3RlOg0KPiA+IE9uIFR1ZSwgMjAxOS0wNi0xOCBhdCAyMDoxNSArMDMwMCwgTGVvbiBS
b21hbm92c2t5IHdyb3RlOg0KPiA+ID4gRnJvbTogTGVvbiBSb21hbm92c2t5IDxsZW9ucm9AbWVs
bGFub3guY29tPg0KPiA+ID4gDQo+ID4gPiBDaGFuZ2Vsb2c6DQo+ID4gPiAgdjAgLT4gdjE6DQo+
ID4gDQo+ID4gTm9ybWFsbHkgMXN0IHN1Ym1pc3Npb24gaXMgVjEgYW5kIDJuZCBpcyBWMi4NCj4g
PiBzbyB0aGlzIHNob3VsZCBoYXZlIGJlZW4gdjEtPnYyLg0KPiANCj4gIk5vcm1hbGx5IiBkZXBl
bmRzIG9uIHRoZSBsYW5ndWFnZSB5b3UgYXJlIHVzaW5nLiBJbiBDLCBldmVyeXRoaW5nDQo+IHN0
YXJ0cyBmcm9tIDAsIGluY2x1ZGluZyB2ZXJzaW9uIG9mIHBhdGNoZXMgOikuDQo+IA0KDQpZb3Ug
YXJlIHdyb25nOg0KcXVvdGluZzogaHR0cHM6Ly9rZXJuZWxuZXdiaWVzLm9yZy9QYXRjaFRpcHNB
bmRUcmlja3MNCg0KIkZvciBleGFtcGxlLCBpZiB5b3UncmUgc2VuZGluZyB0aGUgc2Vjb25kIHJl
dmlzaW9uIG9mIGEgcGF0Y2gsIHlvdQ0Kc2hvdWxkIHVzZSBbUEFUQ0ggdjJdLiINCg0Kbm93IGRv
bid0IHRlbGwgbWUgdGhhdCBzZWNvbmQgcmV2aXNpb24gaXMgYWN0dWFsbHkgM3JkIHJldmlzaW9u
IG9yIDFzdA0KaXMgMm5kIDopLi4gDQoNCj4gPiBGb3IgbWx4NS1uZXh0IHBhdGNoZXM6DQo+ID4g
DQo+ID4gQWNrZWQtYnk6IFNhZWVkIE1haGFtZWVkIDxzYWVlZG1AbWVsbGFub3guY29tPg0KPiAN
Cj4gVGhhbmtzDQo=
