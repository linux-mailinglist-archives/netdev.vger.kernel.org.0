Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 025854286FF
	for <lists+netdev@lfdr.de>; Mon, 11 Oct 2021 08:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234309AbhJKGs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Oct 2021 02:48:28 -0400
Received: from mx22.baidu.com ([220.181.50.185]:43174 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234336AbhJKGs1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Oct 2021 02:48:27 -0400
Received: from BC-Mail-Ex28.internal.baidu.com (unknown [172.31.51.22])
        by Forcepoint Email with ESMTPS id 67DD7AA44CF83002F3D8;
        Mon, 11 Oct 2021 14:46:24 +0800 (CST)
Received: from BJHW-MAIL-EX26.internal.baidu.com (10.127.64.41) by
 BC-Mail-Ex28.internal.baidu.com (172.31.51.22) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2176.2; Mon, 11 Oct 2021 14:46:24 +0800
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-MAIL-EX26.internal.baidu.com (10.127.64.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Mon, 11 Oct 2021 14:46:18 +0800
Received: from BJHW-MAIL-EX27.internal.baidu.com ([169.254.58.247]) by
 BJHW-MAIL-EX27.internal.baidu.com ([169.254.58.247]) with mapi id
 15.01.2308.014; Mon, 11 Oct 2021 14:46:18 +0800
From:   "Cai,Huoqing" <caihuoqing@baidu.com>
To:     "qiangqing.zhang@nxp.com" <qiangqing.zhang@nxp.com>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: RE: [PATCH] MAINTAINERS: Update the devicetree documentation path of
 imx fec driver
Thread-Topic: [PATCH] MAINTAINERS: Update the devicetree documentation path of
 imx fec driver
Thread-Index: AQHXvNa7SNJVZtpXyEaTQMgsu9LtGKvNXVvA
Date:   Mon, 11 Oct 2021 06:46:18 +0000
Message-ID: <57e0dba511144864b80359947e3e1f8f@baidu.com>
References: <20211009062729.778-1-caihuoqing@baidu.com>
In-Reply-To: <20211009062729.778-1-caihuoqing@baidu.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.12.190.132]
Content-Type: text/plain; charset="gb2312"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8sDQorQ2MgcWlhbmdxaW5nLnpoYW5nQG54cC5jb20sIG5ldGRldkB2Z2VyLmtlcm5lbC5v
cmcNCg0KPiAtLS0tLU9yaWdpbmFsIE1lc3NhZ2UtLS0tLQ0KPiBGcm9tOiBDYWksSHVvcWluZyA8
Y2FpaHVvcWluZ0BiYWlkdS5jb20+DQo+IFNlbnQ6IDIwMjHE6jEw1MI5yNUgMTQ6MjcNCj4gVG86
IENhaSxIdW9xaW5nDQo+IENjOiBsaW51eC1rZXJuZWxAdmdlci5rZXJuZWwub3JnDQo+IFN1Ympl
Y3Q6IFtQQVRDSF0gTUFJTlRBSU5FUlM6IFVwZGF0ZSB0aGUgZGV2aWNldHJlZSBkb2N1bWVudGF0
aW9uIHBhdGggb2YNCj4gaW14IGZlYyBkcml2ZXINCj4gDQo+IENoYW5nZSB0aGUgZGV2aWNldHJl
ZSBkb2N1bWVudGF0aW9uIHBhdGgNCj4gdG8gIkRvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5k
aW5ncy9uZXQvZnNsLGZlYy55YW1sIg0KPiBzaW5jZSAnZnNsLWZlYy50eHQnIGhhcyBiZWVuIGNv
bnZlcnRlZCB0byAnZnNsLGZlYy55YW1sJyBhbHJlYWR5Lg0KPiANCj4gU2lnbmVkLW9mZi1ieTog
Q2FpIEh1b3FpbmcgPGNhaWh1b3FpbmdAYmFpZHUuY29tPg0KPiAtLS0NCj4gIE1BSU5UQUlORVJT
IHwgMiArLQ0KPiAgMSBmaWxlIGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0p
DQo+IA0KPiBkaWZmIC0tZ2l0IGEvTUFJTlRBSU5FUlMgYi9NQUlOVEFJTkVSUw0KPiBpbmRleCA3
Y2ZkNjNjZTcxMjIuLjliMjU1Y2Y0ZmNhOCAxMDA2NDQNCj4gLS0tIGEvTUFJTlRBSU5FUlMNCj4g
KysrIGIvTUFJTlRBSU5FUlMNCj4gQEAgLTc1MDksNyArNzUwOSw3IEBAIEZSRUVTQ0FMRSBJTVgg
LyBNWEMgRkVDIERSSVZFUg0KPiAgTToJSm9ha2ltIFpoYW5nIDxxaWFuZ3FpbmcuemhhbmdAbnhw
LmNvbT4NCj4gIEw6CW5ldGRldkB2Z2VyLmtlcm5lbC5vcmcNCj4gIFM6CU1haW50YWluZWQNCj4g
LUY6CURvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNsLWZlYy50eHQNCj4g
K0Y6CURvY3VtZW50YXRpb24vZGV2aWNldHJlZS9iaW5kaW5ncy9uZXQvZnNsLGZlYy55YW1sDQo+
ICBGOglkcml2ZXJzL25ldC9ldGhlcm5ldC9mcmVlc2NhbGUvZmVjLmgNCj4gIEY6CWRyaXZlcnMv
bmV0L2V0aGVybmV0L2ZyZWVzY2FsZS9mZWNfbWFpbi5jDQo+ICBGOglkcml2ZXJzL25ldC9ldGhl
cm5ldC9mcmVlc2NhbGUvZmVjX3B0cC5jDQo+IC0tDQo+IDIuMjUuMQ0KDQo=
