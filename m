Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9EC2B2AD1
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 03:30:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726166AbgKNC3g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 21:29:36 -0500
Received: from szxga02-in.huawei.com ([45.249.212.188]:2433 "EHLO
        szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725981AbgKNC3g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 21:29:36 -0500
Received: from DGGEMM404-HUB.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4CXzmx61lYz54fM;
        Sat, 14 Nov 2020 10:29:21 +0800 (CST)
Received: from dggema706-chm.china.huawei.com (10.3.20.70) by
 DGGEMM404-HUB.china.huawei.com (10.3.20.212) with Microsoft SMTP Server (TLS)
 id 14.3.487.0; Sat, 14 Nov 2020 10:29:32 +0800
Received: from dggema755-chm.china.huawei.com (10.1.198.197) by
 dggema706-chm.china.huawei.com (10.3.20.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.1913.5; Sat, 14 Nov 2020 10:29:32 +0800
Received: from dggema755-chm.china.huawei.com ([10.1.198.197]) by
 dggema755-chm.china.huawei.com ([10.1.198.197]) with mapi id 15.01.1913.007;
 Sat, 14 Nov 2020 10:29:32 +0800
From:   zhangqilong <zhangqilong3@huawei.com>
To:     Jakub Kicinski <kuba@kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "kuznet@ms2.inr.ac.ru" <kuznet@ms2.inr.ac.ru>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: =?gb2312?B?tPC4tDogW1BBVENIXSBpcHY2OiBGaXggZXJyb3IgcGF0aCB0byBjYW5jZWwg?=
 =?gb2312?Q?the_meseage?=
Thread-Topic: [PATCH] ipv6: Fix error path to cancel the meseage
Thread-Index: AQHWui0Qi/9C6xxpiUm/NAMSwIdFSqnG510Q
Date:   Sat, 14 Nov 2020 02:29:32 +0000
Message-ID: <3bfc6c8e2885456cb527bf1b4d42e7fa@huawei.com>
References: <20201112080950.1476302-1-zhangqilong3@huawei.com>
 <20201113182257.4b6dabfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113182257.4b6dabfb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Accept-Language: zh-CN, en-US
Content-Language: zh-CN
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.174.179.28]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PiANCj4gT24gVGh1LCAxMiBOb3YgMjAyMCAxNjowOTo1MCArMDgwMCBaaGFuZyBRaWxvbmcgd3Jv
dGU6DQo+ID4gZ2VubG1zZ19jYW5jZWwoKSBuZWVkcyB0byBiZSBjYWxsZWQgaW4gdGhlIGVycm9y
IHBhdGggb2YNCj4gPiBpbmV0Nl9maWxsX2lmbWNhZGRyIGFuZCBpbmV0Nl9maWxsX2lmYWNhZGRy
IHRvIGNhbmNlbCB0aGUgbWVzc2FnZS4NCj4gPg0KPiA+IEZpeGVzOiAyMDM2NTFiNjY1ZjcyICgi
aXB2NjogYWRkIGluZXQ2X2ZpbGxfYXJncyIpDQo+ID4gUmVwb3J0ZWQtYnk6IEh1bGsgUm9ib3Qg
PGh1bGtjaUBodWF3ZWkuY29tPg0KPiA+IFNpZ25lZC1vZmYtYnk6IFpoYW5nIFFpbG9uZyA8emhh
bmdxaWxvbmczQGh1YXdlaS5jb20+DQo+IA0KPiBUaGlzIGlzIHRoZSBjb3JyZWN0IGZpeGVzIHRh
ZzoNCj4gDQo+IEZpeGVzOiA2ZWNmNGMzN2ViM2UgKCJpcHY2OiBlbmFibGUgSUZBX1RBUkdFVF9O
RVROU0lEIGZvciBSVE1fR0VUQUREUiIpDQo+IA0KPiBBcHBsaWVkLg0KDQpZZXMsIHlvdSBhcmUg
cmlnaHQuDQoNClRoYW5rcywNClpoYW5nDQo=
