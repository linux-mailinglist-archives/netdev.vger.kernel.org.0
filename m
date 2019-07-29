Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B0477848D
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 07:48:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726680AbfG2Fse (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 01:48:34 -0400
Received: from mail-eopbgr20078.outbound.protection.outlook.com ([40.107.2.78]:35976
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725988AbfG2Fse (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 01:48:34 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CmSqAKG//rp7D9bzwfzxCdPy19blIloaxLHOOOB5B1FpF7GSD9rqKxJB5GPiGPJOuSPKE8T3gkEivmtPZR0ux9A43KTQzEf+GH6++gmOikXRoYquhE3C63oplFeb2BOZezDvZ7M1D3n+6DCNXeDoHBiU9ienya9KRCWHjkAAMIvKyGnkgpW6GhuTJWzBbC29/KTd2DuItrNBKAZX9hb+yv4zWM3HeGwYOsUL2ruNhagVbIyh3p0f23Lg5tH8T/SoN4oZDyN2PQ0oR4ZvqfBgXwRfPwprslC96vIOjVEQEk1D/ky7hXD+nLkIiyEXbwUVm/djKAnlHnJlMIUR7dl6Rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9IYg2LtqT4orkyXY5cPb0ZNG/qBkCzLoW0mMATQ/04=;
 b=iKAfH7BHR9bNdWvgF/TeeJNY8GgTAtUK/SMYMR4uWGD1/mkVEhYV4ubPAaterZ0LHOnjp312Y3NRG4hAp6sAFautclSsUyl5/iGhHsgVf8uqhNAQmQIQVlvZdOrBAwRoTEGIuJwNmsPeY/46Jnx9aZTheI4AvNcoyYITw5f5BJPwG/olMkgnCvczKrwiLt27ZHB7aJDgseHyCFJY0/0wjN9pQsNPMJQPd5nnYlGar1L5cLxZAvtjkBN79X9EbpZZsSakRjg6WZ0/8kFDBKUn94gXFO7dsGtYUZUBbuKCUS3fiJylvLpnWitY+BT/+18KiRWS2/0fHD8X8MqQjkM9eg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=N9IYg2LtqT4orkyXY5cPb0ZNG/qBkCzLoW0mMATQ/04=;
 b=ZjBKex1YX7DyP3uPOo68jzpMg0NQiuBLqCVXwCyQtn9YMswVhXnFP3s0Dq9fDn1H6PrXaYiY+7WHrC1jdjVdhhy22JnNWLSR55EQ2Xie9lp71wy7mYPf3e5CG3WCCbzNNfLoGzirfUiAv3cyJF3FfMbjBVgDWu1+bWLXPS6XXV0=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2376.eurprd05.prod.outlook.com (10.168.75.143) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.14; Mon, 29 Jul 2019 05:48:29 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::3c28:c77d:55b0:15b2%5]) with mapi id 15.20.2115.005; Mon, 29 Jul 2019
 05:48:29 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "tanhuazhong@huawei.com" <tanhuazhong@huawei.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "yisen.zhuang@huawei.com" <yisen.zhuang@huawei.com>,
        "salil.mehta@huawei.com" <salil.mehta@huawei.com>,
        "linuxarm@huawei.com" <linuxarm@huawei.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V4 net-next 00/10] net: hns3: some code optimizations &
 bugfixes & features
Thread-Topic: [PATCH V4 net-next 00/10] net: hns3: some code optimizations &
 bugfixes & features
Thread-Index: AQHVRbkez66y46wiD02cT7vkv/dyNabhFwqA
Date:   Mon, 29 Jul 2019 05:48:28 +0000
Message-ID: <1aa604e4afe85fa9cfd2e47fbb5386c2c1041310.camel@mellanox.com>
References: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1564368811-65492-1-git-send-email-tanhuazhong@huawei.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 65bd0094-fb7c-44e5-756a-08d713e861ca
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2376;
x-ms-traffictypediagnostic: DB6PR0501MB2376:
x-microsoft-antispam-prvs: <DB6PR0501MB2376DD4383F3FCB020E5838FBEDD0@DB6PR0501MB2376.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4502;
x-forefront-prvs: 01136D2D90
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(136003)(346002)(366004)(39860400002)(199004)(189003)(54534003)(26005)(316002)(186003)(3846002)(25786009)(6116002)(11346002)(68736007)(71190400001)(71200400001)(6486002)(229853002)(54906003)(110136005)(486006)(256004)(36756003)(2906002)(6436002)(2616005)(476003)(446003)(14444005)(66446008)(66946007)(478600001)(8936002)(99286004)(7736002)(5660300002)(6246003)(6506007)(66556008)(102836004)(64756008)(66476007)(305945005)(76116006)(91956017)(86362001)(76176011)(14454004)(8676002)(53936002)(58126008)(2501003)(66066001)(81166006)(81156014)(4326008)(6512007)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2376;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: S7D6+PZedXk1PNIByIDrfyCU7TB5eHu2+3tPf4PHYsPGdhrncjgrluAsbVH2ey+8IqSBJgR2W4UB8WpaTsIClBnsrE3cNB0cCcqOr40Tl0trIw/IfJ3PGwBhb7dGcOKLRDdFzahnqYCgVQN1+z8gzP0PMoYjFesB9zuKNwHNevl+L9MFwD2mFiQpGVR7a8ioH/gE7ZuEJNnbSypNnroro0cL3R0/6MGE7I+JIBB2ZPoie8uFx9FRdlLpIp72EMkEcwg2ji2e0afViHuQS38JU9OSREldgnRdmqEv8boAr1BdgjOotDYHqTABRWK0w2Y5j+cxhmxaXrzCpshBhJI1gSUVzgfdW5UC8g8Yt//mPppbEAXKUtADW+ueJbDpoyHiiehzRe7hVL4ZozapjqYHYtbSoB7CLxmD1FteMGZfRhs=
Content-Type: text/plain; charset="utf-8"
Content-ID: <F3B16A678070FF4993F05AAF527C9563@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 65bd0094-fb7c-44e5-756a-08d713e861ca
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jul 2019 05:48:28.8414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: saeedm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2376
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gTW9uLCAyMDE5LTA3LTI5IGF0IDEwOjUzICswODAwLCBIdWF6aG9uZyBUYW4gd3JvdGU6DQo+
IFRoaXMgcGF0Y2gtc2V0IGluY2x1ZGVzIGNvZGUgb3B0aW1pemF0aW9ucywgYnVnZml4ZXMgYW5k
IGZlYXR1cmVzIGZvcg0KPiB0aGUgSE5TMyBldGhlcm5ldCBjb250cm9sbGVyIGRyaXZlci4NCj4g
DQo+IFtwYXRjaCAxLzEwXSBjaGVja3MgcmVzZXQgc3RhdHVzIGJlZm9yZSBzZXR0aW5nIGNoYW5u
ZWwuDQo+IA0KPiBbcGF0Y2ggMi8xMF0gYWRkcyBhIE5VTEwgcG9pbnRlciBjaGVja2luZy4NCj4g
DQo+IFtwYXRjaCAzLzEwXSByZW1vdmVzIHJlc2V0IGxldmVsIHVwZ3JhZGluZyB3aGVuIGN1cnJl
bnQgcmVzZXQgZmFpbHMuDQo+IA0KPiBbcGF0Y2ggNC8xMF0gZml4ZXMgYSBHRlAgZmxhZ3MgZXJy
b3JzIHdoZW4gaG9sZGluZyBzcGluX2xvY2suDQo+IA0KPiBbcGF0Y2ggNS8xMF0gbW9kaWZpZXMg
ZmlybXdhcmUgdmVyc2lvbiBmb3JtYXQuDQo+IA0KPiBbcGF0Y2ggNi8xMF0gYWRkcyBzb21lIHBy
aW50IGluZm9ybWF0aW9uIHdoaWNoIGlzIG9mZiBieSBkZWZhdWx0Lg0KPiANCj4gW3BhdGNoIDcv
MTAgLSA4LzEwXSBhZGRzIHR3byBjb2RlIG9wdGltaXphdGlvbnMgYWJvdXQgaW50ZXJydXB0DQo+
IGhhbmRsZXINCj4gYW5kIHdvcmsgdGFzay4NCj4gDQo+IFtwYXRjaCA5LzEwXSBhZGRzIHN1cHBv
cnQgZm9yIHVzaW5nIG9yZGVyIDEgcGFnZXMgd2l0aCBhIDRLIGJ1ZmZlci4NCj4gDQo+IFtwYXRj
aCAxMC8xMF0gbW9kaWZpZXMgbWVzc2FnZXMgcHJpbnRzIHdpdGggZGV2X2luZm8oKSBpbnN0ZWFk
IG9mDQo+IHByX2luZm8oKS4NCj4gDQo+IENoYW5nZSBsb2c6DQo+IFYzLT5WNDogcmVwbGFjZSBu
ZXRpZl9pbmZvIHdpdGggbmV0aWZfZGJnIGluIFtwYXRjaCA2LzEwXQ0KPiBWMi0+VjM6IGZpeGVz
IGNvbW1lbnRzIGZyb20gU2FlZWQgTWFoYW1lZWQgYW5kIEpvZSBQZXJjaGVzLg0KPiBWMS0+VjI6
IGZpeGVzIGNvbW1lbnRzIGZyb20gU2FlZWQgTWFoYW1lZWQgYW5kDQo+IAlyZW1vdmVzIHByZXZp
b3VzIFtwYXRjaCA0LzExXSBhbmQgW3BhdGNoIDExLzExXQ0KPiAJd2hpY2ggbmVlZHMgZnVydGhl
ciBkaXNjdXNzaW9uLCBhbmQgYWRkcyBhIG5ldw0KPiAJcGF0Y2ggWzEwLzEwXSBzdWdnZXN0ZWQg
YnkgU2FlZWQgTWFoYW1lZWQuDQo+IA0KDQpSZXZpZXdlZC1ieTogU2FlZWQgTWFoYW1lZWQgPHNh
ZWVkbUBtZWxsYW5veC5jb20+DQo=
