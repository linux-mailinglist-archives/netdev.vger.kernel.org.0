Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 337F27362F
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfGXR7A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:59:00 -0400
Received: from mail-eopbgr80042.outbound.protection.outlook.com ([40.107.8.42]:33763
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725851AbfGXR7A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 13:59:00 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=glWs94uGclyJYnnEfoDNKV3Su2BErVbFwlcxQAUf6lZgc4r8ZoNt1LpuRSNmYUuvx3/ePKUnTHmt5K07ir2flk60fWWYzuIBBCAzWhvgPIh7S0Ghr+EIt2fxB6wwuvar71Ow/1PKWPOfKVOd7ZvUCziUR3R1Xp3LK69EUufNgjc2BD4/iS9kF+jxIw9SX/CXE98uxArP0K507JVppAHYJ4g0bsrvWUi7pVwKOs0/SwFRnfXa+O1Q1b4lVYm6DcbIGJthqRBqMJsUlHPvnOjNMCIwCiKv4zuYSV6LbANSjkM262A/X6B8Z5dsJHgRRBQbkd6uvZTuFuXerefYzrypVQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4r5jlW+fg5rU2e6wHY1ko6/a8XR7w6Nw8JXv5lWkoK8=;
 b=QYwWIfxeamnNs2KapllrNSzTf4ktO+iYBa/xzRrBEtlzXwuu3CE9stgRavWDM3Cv05PRwZL0ozQGNYzzq6sCvfcAFBTeazLDFadosFEERzMF8fzondvTaUYm5tCv8clJOKsa/6AZ1IapiWGJuCTOXVsCAq1O4YqhTJoNTpNSqp9gHiSP7oj1eNrNr3AQOcTyoi+LQjTGE9lj/mD6OkhNWEJA8hpGOk6T0b0K7PDe2D9fp1ZZiWqCyjN39WXotlbsg3wSo6qpkcx98reeNVO7AeFqAERhh+/X+hIDqoveipP9wUJb+tmzkc4zjPR4era0dmhK9agftdF1HOpGVOKb5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4r5jlW+fg5rU2e6wHY1ko6/a8XR7w6Nw8JXv5lWkoK8=;
 b=Sr6fN1AptBHMP8GERcaXW3h/qYGMZ5gtGB+3k5xMjI3IUqBpxUSQSt2AWzmUIeB6SNQsPHmh0cUxxzD1fDhDcpgychE8l/j8duqHACO1XdsBNe8SS8LtZfNptz6gqFo7Ye9VnZcOEboswsSfDQXOVVBixvJKXKXCsZDOE+SZxZ4=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2695.eurprd05.prod.outlook.com (10.172.225.140) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.17; Wed, 24 Jul 2019 17:58:55 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.011; Wed, 24 Jul 2019
 17:58:55 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "willy@infradead.org" <willy@infradead.org>
CC:     "hch@lst.de" <hch@lst.de>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
Thread-Topic: [PATCH v3 6/7] net: Rename skb_frag_t size to bv_len
Thread-Index: AQHVOLgCN3n4tiD8MUS+X3bLyy1Lk6bY2/6AgAAxcYCAARQJgA==
Date:   Wed, 24 Jul 2019 17:58:55 +0000
Message-ID: <60387845de777559c0067fcf892966f7ec68010b.camel@mellanox.com>
References: <20190712134345.19767-1-willy@infradead.org>
         <20190712134345.19767-7-willy@infradead.org>
         <267e43638c85447a5251ce9ca33356da4a8aa3f3.camel@mellanox.com>
         <20190724013055.GR363@bombadil.infradead.org>
In-Reply-To: <20190724013055.GR363@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: fd07d46a-7913-4388-be52-08d710609873
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2695;
x-ms-traffictypediagnostic: DB6PR0501MB2695:
x-microsoft-antispam-prvs: <DB6PR0501MB26957A9521A5214968F5E9D2BEC60@DB6PR0501MB2695.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-forefront-prvs: 0108A997B2
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(376002)(136003)(366004)(396003)(199004)(189003)(446003)(102836004)(8936002)(2616005)(256004)(11346002)(5660300002)(2351001)(476003)(86362001)(118296001)(186003)(66556008)(26005)(66446008)(66946007)(76116006)(66476007)(6506007)(2906002)(36756003)(66066001)(71200400001)(71190400001)(64756008)(229853002)(2501003)(68736007)(486006)(76176011)(4326008)(6436002)(6512007)(5640700003)(25786009)(3846002)(6246003)(6116002)(81166006)(6486002)(53936002)(81156014)(1730700003)(316002)(91956017)(6916009)(54906003)(14454004)(305945005)(99286004)(7736002)(478600001)(58126008)(4744005)(8676002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2695;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: OBEaij/FbJGPGJfq1Ccmw5sadSoseLRrRW8RJ2pKiEgqPQGA4JpiFCmH6cklyE2CewxfQXn05y9whHKGE4AICMu+1XHfPlO7k4dio/wsGH5d4g0nubUQjeyWOOFCBGtOLTDEDW4CxLQsOi6wQ3s3MxIGAErwdWkw7CiBjT0w1waTpy9vSdFHMXiGwsKKomSLYb85c/pse2aze8MSve/fc+ijYwrAStz/1/KyP34AQSn6oGlnK2vKZSxOeKOtwmWgO16gP+uS/0GCE9HM2/JedHRdOe4+OHNdaJX8ZjkCHbGm/VLEyoqHCnR0+/TfhQDEyc5gN08tqxGk0QjAewlYva4gAt1Z8NTQSkLoiMRNhobMLGAIZP6JrOyUQtflwhY0DElafi36X14JREWPxs8kEod71t0VS1maHOkoTmvuX/s=
Content-Type: text/plain; charset="utf-8"
Content-ID: <2041DF64C79BA8458503096BE275FB52@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fd07d46a-7913-4388-be52-08d710609873
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jul 2019 17:58:55.4842
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2695
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gVHVlLCAyMDE5LTA3LTIzIGF0IDE4OjMwIC0wNzAwLCBNYXR0aGV3IFdpbGNveCB3cm90ZToN
Cj4gT24gVHVlLCBKdWwgMjMsIDIwMTkgYXQgMTA6MzM6NTlQTSArMDAwMCwgU2FlZWQgTWFoYW1l
ZWQgd3JvdGU6DQo+ID4gPiAgc3RydWN0IHNrYl9mcmFnX3N0cnVjdCB7DQo+ID4gPiAgCXN0cnVj
dCBwYWdlICpidl9wYWdlOw0KPiA+ID4gLQlfX3UzMiBzaXplOw0KPiA+ID4gKwl1bnNpZ25lZCBp
bnQgYnZfbGVuOw0KPiA+ID4gIAlfX3UzMiBwYWdlX29mZnNldDsNCj4gPiANCj4gPiBXaHkgZG8g
eW91IGtlZXAgcGFnZV9vZmZzZXQgbmFtZSBhbmQgdHlwZSBhcyBpcyA/IGl0IHdpbGwgbWFrZSB0
aGUNCj4gPiBsYXN0DQo+ID4gcGF0Y2ggbXVjaCBjbGVhbmVyIGlmIHlvdSBjaGFuZ2UgaXQgdG8g
InVuc2lnbmVkIGludCBidl9vZmZzZXQiLg0KPiANCj4gV2UgZG9uJ3QgaGF2ZSBhbiBhY2Nlc3Nv
ciBmb3IgcGFnZV9vZmZzZXQsIHNvIHRoZXJlIGFyZSBhYm91dCAyODANCj4gb2NjdXJyZW5jZXMg
b2YgJz5wYWdlX29mZnNldCcgaW4gZHJpdmVycy9uZXQvDQo+IA0KDQpJIHVuZGVyc3RhbmQgYnV0
IHdoeSBub3QgY2hhaW5pbmcgdGhlIHR5cGUgdG8gInVuc2lnbmVkIGludCIgYXQgbGVhc3QNCnRv
IGF2b2lkIGNvbmZ1c2lvbiA/IA0KDQo+IEZlZWwgZnJlZSB0byBiZSB0aGUgaGVybyB3aG8gZG9l
cyB0aGF0IGNsZWFudXAuDQoNCg0K
