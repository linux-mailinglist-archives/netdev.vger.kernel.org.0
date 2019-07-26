Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 108F4773CD
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 00:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbfGZWAv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jul 2019 18:00:51 -0400
Received: from mail-eopbgr50079.outbound.protection.outlook.com ([40.107.5.79]:24318
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726262AbfGZWAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jul 2019 18:00:51 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CErweVQqdXGJi0C58avcjelZoLNbJMSZXgvCY4FRopR2bNPlVH2vPx0VGQNoO74aztdOzmafIBQC0joekJx22U14XwT01v9woCUlk1UUPabktRMd78AiyREPBN5Ns+WbZZSwjoFrAtfjoypEHT3UhN3BFN2yxrGvN/SmwwwUnr1l+DAE3fvsmAqYozIe+rpc/OnhSfzQKvSnAJ+qK+QEz8q/yOMfcOXjktbCUmuP5G+i/Eci7CEfNhCL5eHbSSYDx7QELIRz/b7Rkrd8k1ghCuyPadtt3qyCUi4/KW8rqc2MBITjgjYtlAqRJPHSnl8udjnnia2M0cBs138TrfUc4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny8VjXX+nDY9ffYy9pJpso+5Wke6w0BJpFyI0BRgsss=;
 b=aa0ZMnIvGESk/c5W0RDqJ2ebzMWRZTAQI+rrsQA90DdcR5Wsz3OD7mlcLAGufKYPAwh1pQYrN8pTdKsuHZ+qLgCcEIVsX5OT6B+8LkBR9PrsoD5hiIVGDhz1vXer1IOX4dhLO3CJ+IqqefnJPBWdyv1fgMRhlrGYmqLaspa6q04y1gHAlk8OqUL9Ptdz/XldYUDqwX0Ma2tCQxKih2EKK9tj8f3VzNTHGiOumEprmYLeCExbEVdhqAvDUoHWRV2LVbI0rzXW9JmA3Y4kivX31Bfy8C/vyS58gM2sEyqvwpufrOliXkPWLLPf0MV3P2aEU3h3U0Y//WxoF5Yc1wkftg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ny8VjXX+nDY9ffYy9pJpso+5Wke6w0BJpFyI0BRgsss=;
 b=VqzPrm8odShjajnPPR6+go8mYAau2Nciie+JwIR/yRU6FFqBKtVB8ukD37muhHYrSX+wZWLxR51zMVJe4GDHmNOnBFVLE/dKl3R8NQQqJ7II3dCvFZn9cQeGV3AS9JNwBYXOIiv8xNbN8G7aSyl5DxTYHgPoh7H1BQdKlJkfqaU=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2727.eurprd05.prod.outlook.com (10.172.225.21) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2094.16; Fri, 26 Jul 2019 22:00:46 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::7148:ecd4:3a7f:f3f%11]) with mapi id 15.20.2094.017; Fri, 26 Jul 2019
 22:00:46 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "lipeng321@huawei.com" <lipeng321@huawei.com>,
        "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "liuyonglong@huawei.com" <liuyonglong@huawei.com>
Subject: Re: [PATCH V2 net-next 07/11] net: hns3: adds debug messages to
 identify eth down cause
Thread-Topic: [PATCH V2 net-next 07/11] net: hns3: adds debug messages to
 identify eth down cause
Thread-Index: AQHVQ2IPaN8qwQ7wx0eGapj0CGanI6bddGAA
Date:   Fri, 26 Jul 2019 22:00:46 +0000
Message-ID: <a32ca755bfd69046cf89aeacbf67fd16313de768.camel@mellanox.com>
References: <1564111502-15504-1-git-send-email-tanhuazhong@huawei.com>
         <1564111502-15504-8-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1564111502-15504-8-git-send-email-tanhuazhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 663de3a4-5810-4f49-0442-08d71214b662
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2727;
x-ms-traffictypediagnostic: DB6PR0501MB2727:
x-microsoft-antispam-prvs: <DB6PR0501MB2727531250CF6396C275CCBFBEC00@DB6PR0501MB2727.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:9508;
x-forefront-prvs: 01106E96F6
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(136003)(396003)(366004)(376002)(39860400002)(199004)(189003)(6486002)(305945005)(54906003)(6512007)(256004)(66946007)(110136005)(14454004)(53936002)(3846002)(86362001)(36756003)(4326008)(5660300002)(316002)(8676002)(66446008)(15650500001)(58126008)(68736007)(64756008)(25786009)(76116006)(7736002)(6116002)(66476007)(99286004)(2616005)(81156014)(81166006)(6506007)(11346002)(91956017)(2501003)(486006)(8936002)(476003)(76176011)(2906002)(66066001)(118296001)(478600001)(26005)(186003)(71200400001)(229853002)(71190400001)(6246003)(102836004)(66556008)(446003)(6436002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2727;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: W8gKGsH6Ma6kh9s2uH5Un/4KMCnaETD1OK0STr2dUqMu9/lD+UbQ/wyrFZHpLYLJTzsYgUafI6o0pPNMBL8fvotY5uKn5U5seTMmz50q/nF5rDLeASc6OWjXzmOQZ7Hd0uDw8t+8bYtbWQHtC0Ws7MyumvLjaZEFAM5aRaj2YEM1BdwzpGCIgQg29YSWMLw9ybJQ7njk2c2hjHdv5TUOi3ty5m5pOfBuiY4jxvkYtX1FJCsCXVS8RYCdeowcoJ/w+LQwCadJ5ZrjM+CEaMHxR6MGGjCb85tBuvB+I75BthyPId9bAAElgaTREAhKvqIWz6fmj2K453I1u7YTn0RcuBUFGGWRFY2z2O4Lf5Lg5+vpoRM9k4JFko4PIRoEJOLUg0oL49+gpXtKCIM2LZsGUlc0MypVcPEk+zy3sNwUvc8=
Content-Type: text/plain; charset="utf-8"
Content-ID: <755F9874F7BDE14F96BB43787EE839B1@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 663de3a4-5810-4f49-0442-08d71214b662
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jul 2019 22:00:46.3158
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2727
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTA3LTI2IGF0IDExOjI0ICswODAwLCBIdWF6aG9uZyBUYW4gd3JvdGU6DQo+
IEZyb206IFlvbmdsb25nIExpdSA8bGl1eW9uZ2xvbmdAaHVhd2VpLmNvbT4NCj4gDQo+IFNvbWUg
dGltZXMganVzdCBzZWUgdGhlIGV0aCBpbnRlcmZhY2UgaGF2ZSBiZWVuIGRvd24vdXAgdmlhDQo+
IGRtZXNnLCBidXQgY2FuIG5vdCBrbm93IHdoeSB0aGUgZXRoIGRvd24uIFNvIGFkZHMgc29tZSBk
ZWJ1Zw0KPiBtZXNzYWdlcyB0byBpZGVudGlmeSB0aGUgY2F1c2UgZm9yIHRoaXMuDQo+IA0KPiBT
aWduZWQtb2ZmLWJ5OiBZb25nbG9uZyBMaXUgPGxpdXlvbmdsb25nQGh1YXdlaS5jb20+DQo+IFNp
Z25lZC1vZmYtYnk6IFBlbmcgTGkgPGxpcGVuZzMyMUBodWF3ZWkuY29tPg0KPiBTaWduZWQtb2Zm
LWJ5OiBIdWF6aG9uZyBUYW4gPHRhbmh1YXpob25nQGh1YXdlaS5jb20+DQo+IC0tLQ0KPiAgZHJp
dmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5zM19lbmV0LmMgICAgfCAyNA0KPiAr
KysrKysrKysrKysrKysrKysrKw0KPiAgZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2hu
czMvaG5zM19ldGh0b29sLmMgfCAyNg0KPiArKysrKysrKysrKysrKysrKysrKysrDQo+ICAuLi4v
bmV0L2V0aGVybmV0L2hpc2lsaWNvbi9obnMzL2huczNwZi9oY2xnZV9kY2IuYyB8IDE0ICsrKysr
KysrKysrKw0KPiAgMyBmaWxlcyBjaGFuZ2VkLCA2NCBpbnNlcnRpb25zKCspDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9uZXQvZXRoZXJuZXQvaGlzaWxpY29uL2huczMvaG5zM19lbmV0LmMN
Cj4gYi9kcml2ZXJzL25ldC9ldGhlcm5ldC9oaXNpbGljb24vaG5zMy9obnMzX2VuZXQuYw0KPiBp
bmRleCA0ZDU4YzUzLi4yZTMwY2ZhIDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL25ldC9ldGhlcm5l
dC9oaXNpbGljb24vaG5zMy9obnMzX2VuZXQuYw0KPiArKysgYi9kcml2ZXJzL25ldC9ldGhlcm5l
dC9oaXNpbGljb24vaG5zMy9obnMzX2VuZXQuYw0KPiBAQCAtNDU5LDYgKzQ1OSwxMCBAQCBzdGF0
aWMgaW50IGhuczNfbmljX25ldF9vcGVuKHN0cnVjdCBuZXRfZGV2aWNlDQo+ICpuZXRkZXYpDQo+
ICAJCWgtPmFlX2FsZ28tPm9wcy0+c2V0X3RpbWVyX3Rhc2socHJpdi0+YWVfaGFuZGxlLCB0cnVl
KTsNCj4gIA0KPiAgCWhuczNfY29uZmlnX3hwcyhwcml2KTsNCj4gKw0KPiArCWlmIChuZXRpZl9t
c2dfZHJ2KGgpKQ0KPiArCQluZXRkZXZfaW5mbyhuZXRkZXYsICJuZXQgb3BlblxuIik7DQo+ICsN
Cg0KdG8gbWFrZSBzdXJlIHRoaXMgaXMgb25seSBpbnRlbmRlZCBmb3IgZGVidWcsIGFuZCB0byBh
dm9pZCByZXBldGl0aW9uLg0KI2RlZmluZSBobnMzX2RiZyhfX2RldiwgZm9ybWF0LCBhcmdzLi4u
KQkJCVwNCih7CQkJCQkJCQlcDQoJaWYgKG5ldGlmX21zZ19kcnYoaCkpCQkJCQlcDQoJCW5ldGRl
dl9pbmZvKGgtPm5ldGRldiwgZm9ybWF0LCAjI2FyZ3MpOyAgICAgICAgIFwNCn0pDQojZW5kaWYN
Cg0K
