Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 155823155A
	for <lists+netdev@lfdr.de>; Fri, 31 May 2019 21:29:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727203AbfEaT3Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 May 2019 15:29:24 -0400
Received: from mail-eopbgr30049.outbound.protection.outlook.com ([40.107.3.49]:34272
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727085AbfEaT3Y (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 31 May 2019 15:29:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yuVPeiCO6kp8UIv6B5LlYPXTR07UsMNKfHxHLFk3x00=;
 b=RuMyvaL/JJqNY1aDVI93fdEOB6CRXvk7+g0rETxX7//Wivok1WOTE7BrtBo/wGjpCq3e4K8VVNPIdQZ6Gg72fwEWWcUCJ19sHIhI8LZc40VK33n/90HQV8HqJDcGnWFJWuf4GEAh7kw7G680tI6HmPbxyr3YInS8Qkiexpd3ToQ=
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com (20.178.125.223) by
 VI1PR05MB5213.eurprd05.prod.outlook.com (20.178.12.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1878.25; Fri, 31 May 2019 19:29:20 +0000
Received: from VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38]) by VI1PR05MB5902.eurprd05.prod.outlook.com
 ([fe80::dd31:2532:9adf:9b38%6]) with mapi id 15.20.1922.021; Fri, 31 May 2019
 19:29:20 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/6] Mellanox, mlx5-next minor updates
 2019-05-29
Thread-Topic: [PATCH mlx5-next 0/6] Mellanox, mlx5-next minor updates
 2019-05-29
Thread-Index: AQHVFnDkskX4c0eOQUCYixTy9S10v6aFoWSA
Date:   Fri, 31 May 2019 19:29:20 +0000
Message-ID: <5b63c973d9f1066fa7f68177d8ddb00f51ebe307.camel@mellanox.com>
References: <20190529224949.18194-1-saeedm@mellanox.com>
In-Reply-To: <20190529224949.18194-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.2 (3.32.2-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ba0d502f-a013-4a3a-1515-08d6e5fe479c
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:VI1PR05MB5213;
x-ms-traffictypediagnostic: VI1PR05MB5213:
x-microsoft-antispam-prvs: <VI1PR05MB5213F26E8BA8D55F336E7A85BE190@VI1PR05MB5213.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8273;
x-forefront-prvs: 00540983E2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(366004)(136003)(346002)(376002)(396003)(39860400002)(53754006)(189003)(199004)(81166006)(58126008)(36756003)(102836004)(76176011)(86362001)(2906002)(6116002)(37006003)(5660300002)(8676002)(4744005)(305945005)(486006)(64756008)(25786009)(316002)(15650500001)(6862004)(26005)(14454004)(54906003)(256004)(6506007)(81156014)(99286004)(4326008)(3846002)(508600001)(450100002)(2616005)(476003)(446003)(6436002)(66476007)(11346002)(91956017)(229853002)(66556008)(6512007)(7736002)(8936002)(73956011)(68736007)(71190400001)(186003)(71200400001)(53936002)(66066001)(6486002)(66446008)(118296001)(14444005)(6636002)(6246003)(76116006)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5213;H:VI1PR05MB5902.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: udEgwSX+WD90FvkCU6QcIfRNsnCg8DJiu4EebcaYiobZtqGJiiyYidgNDuoS2Z+KZi4g+RxDcL+6zRjDHJ01agq7wHQAmTMIaFkDW4qENM4pykS1fvFaI/nSA7lRIEqHFJmbueftwM90kGeEtqDyLc14oeqm/jHMKjqpL/6FHwzHSDKPmAVUIZUDtvlRIa18fAbWvWzDWHGxtp2lzPIRRvE1AEV+TpWr8uYMWO6E4us34qK+O04XpltgEyo93ygaCvMWG5EqvvfSuE2SXyRKnb6dgRu5WXV2/M3IrihxPDDepXJHsikNjdwjp3aQxYR/GB7aWFH/h51d5EN8lcwckUsxBd1qVdkCYSB7tEnDYeorOBWhZa4EM5v6KzAlGovl0pMAn89qMN/cr2X0+R2EbSWXhoqLaVILZy5Phu499so=
Content-Type: text/plain; charset="utf-8"
Content-ID: <6AAB369BB02AFA46BD279A6ACD925FD2@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ba0d502f-a013-4a3a-1515-08d6e5fe479c
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 May 2019 19:29:20.4019
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5213
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gV2VkLCAyMDE5LTA1LTI5IGF0IDIyOjUwICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgQWxsLA0KPiANCj4gVGhpcyBzZXJpZXMgcHJvdmlkZXMgc29tZSBsb3cgbGV2ZWwgdXBk
YXRlcyBmb3IgbWx4NSBkcml2ZXIgbmVlZGVkDQo+IGZvcg0KPiBib3RoIHJkbWEgYW5kIG5ldGRl
diB0cmVlcy4NCj4gDQo+IEVsaSBhZGRzIHRlcm1pbmF0aW9uIGZsb3cgc3RlZXJpbmcgdGFibGUg
Yml0cyBhbmQgaGFyZHdhcmUNCj4gZGVmaW5pdGlvbnMuDQo+IA0KPiBNb3NoZSBpbnRyb2R1Y2Vz
IHRoZSBjb3JlIGR1bXAgSFcgYWNjZXNzIHJlZ2lzdGVycyBkZWZpbml0aW9ucy4NCj4gDQo+IFBh
cmF2IHJlZmFjdG9ycyBhbmQgY2xlYW5zLXVwIFZGIHJlcHJlc2VudG9ycyBmdW5jdGlvbnMgaGFu
ZGxlcnMuDQo+IA0KPiBWdSByZW5hbWVzIGhvc3RfcGFyYW1zIGJpdHMgdG8gZnVuY3Rpb25fY2hh
bmdlZCBiaXRzIGFuZCBhZGQgdGhlDQo+IHN1cHBvcnQgZm9yIGVzd2l0Y2ggZnVuY3Rpb25zIGNo
YW5nZSBldmVudCBpbiB0aGUgZXN3aXRjaCBnZW5lcmFsDQo+IGNhc2UuDQo+IChmb3IgYm90aCBs
ZWdhY3kgYW5kIHN3aXRjaGRldiBtb2RlcykuDQo+IA0KPiBJbiBjYXNlIG9mIG5vIG9iamVjdGlv
biB0aGlzIHNlcmllcyB3aWxsIGJlIGFwcGxpZWQgdG8gbWx4NS1uZXh0DQo+IGJyYW5jaC4NCj4g
DQoNClNlcmllcyBhcHBsaWVkIHRvIG1seDUtbmV4dCBicmFuY2guDQo=
