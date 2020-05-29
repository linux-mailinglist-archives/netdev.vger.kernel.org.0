Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 95D0D1E883B
	for <lists+netdev@lfdr.de>; Fri, 29 May 2020 22:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727964AbgE2UAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 16:00:12 -0400
Received: from mail-eopbgr00079.outbound.protection.outlook.com ([40.107.0.79]:32133
        "EHLO EUR02-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726866AbgE2UAM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 May 2020 16:00:12 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RThezDIb7NwORKfeyihia7KMr4HsWaeNMs+e0P2GqO/iETGcBFMQ9jSwp1euBsS/AEm6Ak4EYHOPUmKx727G9Gp9CIt8lQbUa4JG0SjCkUKD6MT7Qny2N0rA1L/Lr/ujal/nTKRtJ6QNp5nfOuKmmSid0VYiHJHdsvKJ3WDRVy9NDjmV6YK7MdRsRMLijd8jCn5OZCCTkErpxYe70NPSCemdvdA+PaK9opHWJNvu/N+3sSeHuiM4+nRNe9wNBl0EngeGWKeTMcwUedOigpg/Fh+wB0g3akcHZHhGOKJ47FDPBrP268dIU/m/Sw8IIC1N0tGPMe2VChcq9oQ2t5dHFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aByGIY6rEUb6OTjD+gCwnfEd10sy7hEwV4HnU2BAjw=;
 b=PkyZngovCaClaRbGHho7aMhTk2K1zmTViiphQPyIhWpIXya3AbqYtWtsdL7oXVd2lNsPjoXMluuudX5a+7P9cCQBHsPbqxs8aiaBAvid1Ynfsf+9v+jo0LELQiCVhZ+QBzdOfC9pT5XPE62FYZlcnYOpTN+WkeGIOfNjCiDcQwnhSN1hCDjpUc930wXvzP00mpaevhrU5nzphLO9U9XZGQ+lTm31AZ33/QW4L+Tr3vkGOdtwxJtr57/Ax7cf+51jHklUYXUtcfm756gok/AcTdDZFP7HOCRj55RkhJ6ZpxT2tduYvJ5pConc+tkF46/hRKMrnihlF8EJkb/TeM1SEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4aByGIY6rEUb6OTjD+gCwnfEd10sy7hEwV4HnU2BAjw=;
 b=LfORHatO/2l7Suqa96xMDJ1e1no9mBgRl6HjIsSGHzXX59vwRyoHf74mqnJIoRSkCkB0r7JUyKsqLDXyXnoPWOAvdSgxGObuIHlt/RqS/NKde0lSKngPXBmEjDfz0/GBJ9Oz3KzexZUA1e6tOphGEj39RrS5/YtdMznS/E2lO34=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (2603:10a6:803:5e::23)
 by VI1PR05MB4368.eurprd05.prod.outlook.com (2603:10a6:803:44::26) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3045.17; Fri, 29 May
 2020 20:00:06 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::2405:4594:97a:13c%2]) with mapi id 15.20.3045.018; Fri, 29 May 2020
 20:00:06 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "kuba@kernel.org" <kuba@kernel.org>
CC:     Roi Dayan <roid@mellanox.com>, Maor Dickman <maord@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [net 3/6] net/mlx5e: Remove warning "devices are not on same
 switch HW"
Thread-Topic: [net 3/6] net/mlx5e: Remove warning "devices are not on same
 switch HW"
Thread-Index: AQHWNYZmyNXlRzF1g0WmtEOAS1l+E6i/b0IAgAANLQA=
Date:   Fri, 29 May 2020 20:00:06 +0000
Message-ID: <90153a2f53ffb09b31b069445d2bccf86d2b8ef7.camel@mellanox.com>
References: <20200529065645.118386-1-saeedm@mellanox.com>
         <20200529065645.118386-4-saeedm@mellanox.com>
         <20200529121222.4b68ce20@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200529121222.4b68ce20@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.36.2 (3.36.2-1.fc32) 
authentication-results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
x-originating-ip: [73.15.39.150]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 9abe78c1-ea3c-4461-5ef0-08d8040ae27d
x-ms-traffictypediagnostic: VI1PR05MB4368:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB43689E470E8CF44E0D728351BE8F0@VI1PR05MB4368.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 04180B6720
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: qq5ejHtgp4fhudl5xJYtPz744LZ1nZvMEeIfVLuLo8vJDYXnBP7reRXy4JzCu3icol/jF8yTKg2PtU6UsN0gc0XWcdBfhaJCHvF8KkuhREnWBuz+Hp2Ih0q/gLcYbKbdTxd1dwHZ0nZmhE55d12bydPjbbpwy1xsqraQgnaDceGMDUAmpVSq3yDPySbLcjJvVJgBTQMEfyolaVFVozzuYYUO79WOuDETQzRPqZBNqoUzA/rk5vGVlfExQPLNBOT39qWQi2Zo8ItGycAU+UxE5MN6kJIzRjmPK5AGyAoW9118coMwI5O0dA7jI7feDau1ZWRL+oj/JAprhjZsc9J0SQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR05MB5102.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(376002)(396003)(366004)(39860400002)(346002)(136003)(4326008)(26005)(8676002)(186003)(6506007)(6916009)(71200400001)(2616005)(316002)(2906002)(76116006)(66446008)(64756008)(66556008)(6486002)(83380400001)(66946007)(36756003)(478600001)(86362001)(54906003)(8936002)(66476007)(91956017)(4744005)(6512007)(5660300002);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: ssIOw4j86yt8DoO7gwKJnmvCFtqzz6FE7WBcT9BNv+aCjg41M0iS+QwbpdbOwh/eFNHdROVo018XV5QzNn6nN0CF0Nhp5IRPAcxABvXjMMPMw+Sv5+YNw93Lrf5zOfUOg+IL2sBMuX+zNv0uBghyMg9DNlSmYkgKPpGXBXqTDSvSkOUb/k3hgvZvoYpoJoQnzD/PJLzCNBy0DdUlxVR3bd7hYd2oBaRZIzxkoi/U8CcWiOH6PW0tl3LoW05PrDcymrRJgpH4Ca6xwMUascbxLqa20BjFOYxE1bXiO97vOj/73FL+3/dhPtPYY7xFUV2A4huRaPwWpWNBsnmx19ZAfsBeBgubLdRoM93+ZzG26mZ73t4S6Zx8RPRgwGC3QDvVMEd9FnmndNV9gn+t5FfLEM/nw9p95AWrNi+cVesdnpDtltIhlrTsws4V50lG7dLpoK3/EN+DNQwDHWxftIr8K2js3fLGhFmQ7TgI8b1zdWk=
Content-Type: text/plain; charset="utf-8"
Content-ID: <17F0D90AA4FD6049B984E8B46237B3D6@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9abe78c1-ea3c-4461-5ef0-08d8040ae27d
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 May 2020 20:00:06.7097
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: pYTbzswNNFhWJ3SXqqqR1euNA5od4SP3nCaKPBKUlrENB4n/cNkNVKZ6SDhKXDumLBKw+EfP6xEN0MH9wnrTuQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4368
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDIwLTA1LTI5IGF0IDEyOjEyIC0wNzAwLCBKYWt1YiBLaWNpbnNraSB3cm90ZToN
Cj4gT24gVGh1LCAyOCBNYXkgMjAyMCAyMzo1Njo0MiAtMDcwMCBTYWVlZCBNYWhhbWVlZCB3cm90
ZToNCj4gPiBGcm9tOiBNYW9yIERpY2ttYW4gPG1hb3JkQG1lbGxhbm94LmNvbT4NCj4gPiANCj4g
PiBPbiB0dW5uZWwgZGVjYXAgcnVsZSBpbnNlcnRpb24sIHRoZSBpbmRpcmVjdCBtZWNoYW5pc20g
d2lsbCBhdHRlbXB0DQo+ID4gdG8NCj4gPiBvZmZsb2FkIHRoZSBydWxlIG9uIGFsbCB1cGxpbmsg
cmVwcmVzZW50b3JzIHdoaWNoIHdpbGwgdHJpZ2dlciB0aGUNCj4gPiAiZGV2aWNlcyBhcmUgbm90
IG9uIHNhbWUgc3dpdGNoIEhXLCBjYW4ndCBvZmZsb2FkIGZvcndhcmRpbmciDQo+ID4gbWVzc2Fn
ZQ0KPiA+IGZvciB0aGUgdXBsaW5rIHdoaWNoIGlzbid0IG9uIHRoZSBzYW1lIHN3aXRjaCBIVyBh
cyB0aGUgVkYNCj4gPiByZXByZXNlbnRvci4NCj4gPiANCj4gPiBUaGUgYWJvdmUgZmxvdyBpcyB2
YWxpZCBhbmQgc2hvdWxkbid0IGNhdXNlIHdhcm5pbmcgbWVzc2FnZSwNCj4gPiBmaXggYnkgcmVt
b3ZpbmcgdGhlIHdhcm5pbmcgYW5kIG9ubHkgcmVwb3J0IHRoaXMgZmxvdyB1c2luZyBleHRhY2su
DQo+ID4gDQo+ID4gRml4ZXM6IGYzOTUzMDAzYTY2ZiAoIm5ldC9tbHg1ZTogRml4IGFsbG93ZWQg
dGMgcmVkaXJlY3QgbWVyZ2VkDQo+ID4gZXN3aXRjaCBvZmZsb2FkIGNhc2VzIikNCj4gPiBTaWdu
ZWQtb2ZmLWJ5OiBNYW9yIERpY2ttYW4gPG1hb3JkQG1lbGxhbm94LmNvbT4NCj4gPiBSZXZpZXdl
ZC1ieTogUm9pIERheWFuIDxyb2lkQG1lbGxhbm94LmNvbT4NCj4gPiBTaWduZWQtb2ZmLWJ5OiBT
YWVlZCBNYWhhbWVlZCA8c2FlZWRtQG1lbGxhbm94LmNvbT4NCj4gDQo+IEZpeGVzIHRhZzogRml4
ZXM6IGYzOTUzMDAzYTY2ZiAoIm5ldC9tbHg1ZTogRml4IGFsbG93ZWQgdGMgcmVkaXJlY3QNCj4g
bWVyZ2VkIGVzd2l0Y2ggb2ZmbG9hZCBjYXNlcyIpDQo+IEhhcyB0aGVzZSBwcm9ibGVtKHMpOg0K
PiAJLSBUYXJnZXQgU0hBMSBkb2VzIG5vdCBleGlzdA0KDQpGaXhpbmcsIHRoYW5rcyAhDQo=
