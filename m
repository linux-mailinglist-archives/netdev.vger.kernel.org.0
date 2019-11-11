Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E4FAF8104
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 21:19:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727533AbfKKUTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 15:19:06 -0500
Received: from mail-eopbgr40044.outbound.protection.outlook.com ([40.107.4.44]:33745
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727059AbfKKUTG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Nov 2019 15:19:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fLj/141oUqfzlF+ypFJx03j7geRbn2v9Om/gMs6kNIDf1HH3GGneLYegEXa3FuREugaOivOoFcpLfRB/KpC8+6eE76AHDI5zJ4OGC/TtQ9Kke/OKRzQTp8ICBpwn6SimnvH+CourwwjlKr2lXAAAKkEOtswKnyqfeiHKAgcxMkYTRzTRRQ+QeV557X6ZNR0vFlItwbcJvcycOy+f3bSJ5QT8r0qVOEKAcRow1cjb08BugghanzsL3bQ+XGFhTUlnPWzENhdI60uJc2+4caFeKwTmy9aL0vD+tMYEV3yl96gPXu1WXW59gpykNxe8xkj41dUNsVPfFiV3c05KBDv6IA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeWoeZ/0T+H84XNeFvjJ8kCDwAsRObaxRalBej4DkAs=;
 b=ZerxxbrSwzQeEysadu7iyBbaZdFb67mpdMDEd5xpa63v1jn4Ilz8AHilQSBvUKZQ1RajgITBNEJu2GznIgSsudK0PJdfXlePrl7QfhzKQqyxWlyfXttYMLrJ9Yzlsc+oepontNn+8qngKSbMYYaRK4zdcGKGE45w7vYHXJLIzTM6wAn0+lmllMs7A2m+/D1yqp6gcBckPKGtPhTjDQq4sJWNFjCrv9yUCitjb4O/MV9WLU0Khbfbp8YMnn1Zr8WR+B4xT7rOtjrpGOK2oxuaA1XpSUuLCdYMmFUdWFVnKTDadGpWeprqTvqkWM5kykue9ZQ+YC8uBg8Msw4+U6Khyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NeWoeZ/0T+H84XNeFvjJ8kCDwAsRObaxRalBej4DkAs=;
 b=PDQ408Iwdue2kSmkFgmvNgU+m+04nwpDIyGlQAxEiezatT/St906RCWIyHj+V801kbSK48aWolCGJ5re7I1h7unoKJ4bjZuwBqJHqnDNoUAzT0DkdFn7tsWSam0OKSr0YBwPnALtjJ/HWAEK+bvcMnuU10uK4Li9V53U/Imo+g4=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4541.eurprd05.prod.outlook.com (20.176.2.140) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Mon, 11 Nov 2019 20:19:00 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.027; Mon, 11 Nov 2019
 20:19:00 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/5] Mellanox, mlx5 roce enable devlink
 parameter
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, mlx5 roce enable devlink
 parameter
Thread-Index: AQHVlo6Tcf69cInxPkuJQUqWBpS4R6eGbWIA
Date:   Mon, 11 Nov 2019 20:18:59 +0000
Message-ID: <515df88e0347754a994c73487b4afbc46b2d75c1.camel@mellanox.com>
References: <20191108234451.31660-1-saeedm@mellanox.com>
In-Reply-To: <20191108234451.31660-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Evolution 3.32.4 (3.32.4-1.fc30) 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-originating-ip: [209.116.155.178]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: bebfc5d9-227f-4940-a9e8-08d766e46344
x-ms-traffictypediagnostic: VI1PR05MB4541:|VI1PR05MB4541:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4541DBEC9CAACE87BB2E5C16BE740@VI1PR05MB4541.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0218A015FA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(189003)(199004)(53754006)(476003)(229853002)(8676002)(5660300002)(8936002)(11346002)(2616005)(99286004)(186003)(81156014)(81166006)(102836004)(7736002)(2906002)(6506007)(66066001)(4744005)(76176011)(26005)(71190400001)(71200400001)(450100002)(305945005)(446003)(25786009)(36756003)(256004)(3846002)(4326008)(118296001)(6246003)(6512007)(6636002)(66476007)(486006)(478600001)(6486002)(54906003)(6862004)(66946007)(91956017)(14444005)(76116006)(66446008)(64756008)(6116002)(6436002)(14454004)(86362001)(66556008)(316002)(37006003)(58126008);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4541;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: PC8ZBGHw0OAhyLOGW05u5YR+vy/S/XM794WCS2lDrdYnqk1CXVnu8wgBgbF7007Ikbse7iwbLx4Ds3D+uAMlziFGfVHaRP2AOZz43NUk3zJtDyypIiyREhazM19qI2hFEQxLeNrKCn+toEUg96WVdghc8O3aWOcGijlb0VeDBIfB/ph11aT9yVi3kaGpDWf0eQtUnRFSMDj5frpIT5b/HgGabBLUU62jJxo35mpA+xLT58b2rWb/Ku4/U0xKoywzIWvFhXCMYyWsNv204rkZ0YFKcHHpnqDUXQ3Y1+Xh2x/I/p1/tpXVOZQWOZpam1CGf4JXOz9khoWBrtdpBbkTQc9QSjiABzXygGjYKtdT8ghLM/poW29jhLHR4R5MAya8qHFS50kV+VbN8FWN/kMPdAViHOe8RE0x2CIGiyMCkrc5NjifRqfkzjJCXSvs9z8D
Content-Type: text/plain; charset="utf-8"
Content-ID: <B1F1252925F96A47BDBCED6EBE0E0E01@eurprd05.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bebfc5d9-227f-4940-a9e8-08d766e46344
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Nov 2019 20:18:59.8516
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: aNxLS/h38jLz3U5i5se3j3d997rSz0sCP5dF9xgh14vW76EfrMJybiH75hKz4izwuyP1sJmWEiemfRvGM4lBrg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4541
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gRnJpLCAyMDE5LTExLTA4IGF0IDIzOjQ1ICswMDAwLCBTYWVlZCBNYWhhbWVlZCB3cm90ZToN
Cj4gSGkgQWxsLA0KPiANCj4gQ3VycmVudGx5IFJvQ0UgaXMgYWx3YXlzIGVuYWJsZWQgYnkgZGVm
YXVsdCBpbiBtbHg1IGFuZCB0aGVyZSBpcyBubw0KPiBvcHRpb24NCj4gZm9yIHRoZSB1c2VyIHRv
IGRpc2FibGUgaXQuDQo+IA0KPiBUaGlzIGNoYW5nZSBpbnRyb2R1Y2VzIG5ldyBnZW5lcmljIGRl
dmxpbmsgcGFyYW0gImVuYWJsZV9yb2NlIi4gDQo+IFVzZXIgc2hvdWxkIHNldCBkZXNpcmVkIHBh
cmFtIHZhbHVlIGFuZCByZWxvYWQgdGhlIGRyaXZlciB0byBnZXQNCj4gZGVzaXJlZCBjb25maWd1
cmF0aW9uLg0KPiANCj4gVHdvIG9wdGlvbnMgZm9yIHJlbG9hZDoNCj4gMSkgcmVsb2FkIG1seDVf
aWIgZHJpdmVyLg0KPiAyKSByZWxvYWQgdmlhIGRldmxpbmssIG9uY2UgdGhlIGRldmxpbmsgbWx4
NSByZWxvYWQgc3VwcG9ydCBbMV0NCj4gbGFuZHMgaW4gbmV0LW5leHQgYnJhbmNoLCBhZnRlciB0
aGlzIHNlcmllcyBpcyBhcHBsaWVkLg0KPiANCj4gbWx4NSBkZXZsaW5rIHJlbG9hZCBpcyBub3Qg
cGFydCBvZiB0aGlzIHBhdGNoc2V0IHNpbmNlIGl0IGRlcGVuZHMgb24NCj4gY2hhbmdlcyBmcm9t
IG5ldC1uZXh0IHRyZWUuDQo+IA0KPiBSb0NFIHdpbGwgc3RpbGwgYmUgZW5hYmxlZCBieSBkZWZh
dWx0IGFmdGVyIHRoaXMgY2hhbmdlLg0KPiANCj4gSW4gY2FzZSBvZiBubyBvYmplY3Rpb24gdGhp
cyBzZXJpZXMgd2lsbCBiZSBhcHBsaWVkIHRvIG1seDUtbmV4dA0KPiBicmFuY2gNCj4gYW5kIHNl
bnQgbGF0ZXIgYXMgcHVsbCByZXF1ZXN0IHRvIGJvdGggcmRtYS1uZXh0IGFuZCBuZXQtbmV4dA0K
PiBicmFuY2hlcy4NCj4gDQoNClNlcmllcyBhcHBsaWVkIHRvIG1seDUtbmV4dC4NCg0KVGhhbmtz
Lg0KDQo=
