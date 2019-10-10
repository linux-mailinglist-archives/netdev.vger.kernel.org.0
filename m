Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9098AD2BF1
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 16:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726097AbfJJOBY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 10:01:24 -0400
Received: from mail-eopbgr780080.outbound.protection.outlook.com ([40.107.78.80]:63120
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726009AbfJJOBY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Oct 2019 10:01:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDEUSzpJCkVQcABk+PffVsKJ9ahE5TALyRgB1IxU7h8oj15147IFxR3RX4fyWyDfmoj0txic8jA27j/Q3wwYW/eipM7eOH4/bFccVciHZ9hoRZwYI+MtGd3R5vmbFgfeWgOxfx8683UVGhhs7LxAH3COeMQTv+OnysKjKHy7MzIEkIKOfg9y123oj4+8WWD5fyKgAR9uz1LJ1rPjYer3ZKiZhYrM1ETAU0dEjigihg83FpsXIKEHb/2xIwgNMmhtYWHROVcxh/ebZEEMB85m6AaAPetPhLXr3ynuGFCXjoHEhNMe7bGo32Xdw0SCNEQxQt0oUiFgii71CdqFly3Jow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40c9YVx+tMwYKtU5OBQfDvB1/arEnRgfGhZSEczKs5I=;
 b=JCjFciKkevD/YteUWcUKRDSfEjT15EH6ieJBYJWntWjVrUaCi1+2tctDB4LsmutcJ2ONWKcHc96SOHH2QsLAx8CHHc3UZep9MNH947/SnIgRRYCIg3rgwr/9kH22wMkQfMhAqliWwIasBT+oE+FlbttRJHvlP4BXnx6y//2RP/0ApLKdSHGjdT+T5sFE7nIyBd6dldFz0vNBPeuqwbp44Jgk0XZlEs/WCkHw6yfuW4uhkwYFiuCDPb1CBNBLC8LG53J9XqiM/lIrbeaT42Iv8eAHvkZkAyYNNEGNh4PHhwOLkeGOUBfesW3HjLji8fHhZIM93kRYtIIOvnzpuEv5rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=40c9YVx+tMwYKtU5OBQfDvB1/arEnRgfGhZSEczKs5I=;
 b=19CulW9IwglvKL+rCeUj0fohNZbOONWnMyJ1E3SfaFhpm14komYQQ8yZUNCnIkdKn2FYPjEsYSkqDZTEEx/xTUxaXwcxscEd+YSPca/TvTIJVjuIhSGl/T7d2wvt327rvCfs9w9CGqZ4m8LsTj23ajCUf1wbKqZ/2kGgXKF2hho=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3779.namprd11.prod.outlook.com (20.178.220.154) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2347.16; Thu, 10 Oct 2019 14:01:21 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Thu, 10 Oct 2019
 14:01:21 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net 0/4] Aquantia/Marvell AQtion atlantic driver fixes 10/2019
Thread-Topic: [PATCH net 0/4] Aquantia/Marvell AQtion atlantic driver fixes
 10/2019
Thread-Index: AQHVf3MxR0fVJrFXUUm6fKkqkeZP0A==
Date:   Thu, 10 Oct 2019 14:01:20 +0000
Message-ID: <cover.1570708006.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0003.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::15)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 67e36286-5eb0-429b-6288-08d74d8a5414
x-ms-traffictypediagnostic: BN8PR11MB3779:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3779FB01CB9F8A319A2FCC5298940@BN8PR11MB3779.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 018632C080
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(366004)(39850400004)(396003)(346002)(376002)(189003)(199004)(66556008)(26005)(64756008)(476003)(6916009)(8676002)(14454004)(81156014)(81166006)(1730700003)(4326008)(508600001)(36756003)(2906002)(66946007)(186003)(66446008)(3846002)(66476007)(256004)(107886003)(2616005)(5660300002)(486006)(6116002)(6486002)(25786009)(305945005)(7736002)(316002)(6436002)(66066001)(4744005)(52116002)(386003)(99286004)(54906003)(5640700003)(6512007)(44832011)(50226002)(102836004)(71200400001)(71190400001)(2351001)(6506007)(8936002)(2501003)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3779;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: INfGaUdA9ndCM7jIGYolU3So1TtPs8oQ5P9Vo7sZu7BzGQR8YtqrA0rC+prO9Ki2SNFefeg/tdT6qlRIZWaCE0DKAWfK+XsjvK+uF7QfBfn+cq4u2/47SCd3IeuF4rzpZTTALXQSak7DR3zhZ4BlPzN6yfdsgwMDeD6igZFnQ9Yc7KGEcWN+HIAqCpxIaqp66ZD6+N9YQiOkIeZlhXq5ImQYIm5Y6Q0+measzhcictJwmdP4vVi1FxBjlIpm7exIKmERQljWkHtIgs3fJJr/MgPCeeUW8i+6M7sl7UXJVVCpmsxClcmYGhxSlYibEvO8qJkS1MsvmorCEvQRdCy2w8H+Ih64hWc+L/T/1Uz7TBFwoi67ov4vXVGulEqP50gkmaWBtAtHfcwMd/brEKLuYuKBD/Q54jjgm511N1m8d4M=
Content-Type: text/plain; charset="utf-8"
Content-ID: <33EB40CA07851442AB0FDB23438268E2@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 67e36286-5eb0-429b-6288-08d74d8a5414
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Oct 2019 14:01:20.9950
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: SpkXdVc9d+Y7XiLO7cZr6gMMK86HSeFPnwshxXd6rJrMqSs6BSWJDp23NUyJx3OV0fmwiIJbqSfkHjiLnYsJqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3779
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gRGF2aWQhDQoNCkhlcmUgaXMgYSBzZXQgb2YgdmFyaW91cyBidWdmaXhlcywgdG8gYmUg
Y29uc2lkZXJlZCBmb3Igc3RhYmxlIGFzIHdlbGwuDQoNClRoYW5rcyENCg0KRG1pdHJ5IEJvZ2Rh
bm92ICgyKToNCiAgbmV0OiBhcXVhbnRpYTogZG8gbm90IHBhc3MgbHJvIHNlc3Npb24gd2l0aCBp
bnZhbGlkIHRjcCBjaGVja3N1bQ0KICBuZXQ6IGFxdWFudGlhOiBjb3JyZWN0bHkgaGFuZGxlIG1h
Y3ZsYW4gYW5kIG11bHRpY2FzdCBjb2V4aXN0ZW5jZQ0KDQpJZ29yIFJ1c3NraWtoICgyKToNCiAg
bmV0OiBhcXVhbnRpYTogdGVtcGVyYXR1cmUgcmV0cmlldmFsIGZpeA0KICBuZXQ6IGFxdWFudGlh
OiB3aGVuIGNsZWFuaW5nIGh3IGNhY2hlIGl0IHNob3VsZCBiZSB0b2dnbGVkDQoNCiAuLi4vbmV0
L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX21haW4uYyAgfCAgNCArLS0NCiAuLi4vbmV0
L2V0aGVybmV0L2FxdWFudGlhL2F0bGFudGljL2FxX25pYy5jICAgfCAzMiArKysrKysrKystLS0t
LS0tLS0tDQogLi4uL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9hcV9yaW5nLmMgIHwg
IDMgKy0NCiAuLi4vYXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9iMC5jICAgICAgfCAy
MyArKysrKysrKysrLS0tDQogLi4uL2FxdWFudGlhL2F0bGFudGljL2h3X2F0bC9od19hdGxfbGxo
LmMgICAgIHwgMTcgKysrKysrKystLQ0KIC4uLi9hcXVhbnRpYS9hdGxhbnRpYy9od19hdGwvaHdf
YXRsX2xsaC5oICAgICB8ICA3ICsrLS0NCiAuLi4vYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9sbGhf
aW50ZXJuYWwuaCAgICAgfCAxOSArKysrKysrKysrKw0KIC4uLi9hdGxhbnRpYy9od19hdGwvaHdf
YXRsX3V0aWxzX2Z3MnguYyAgICAgICB8ICAyICstDQogOCBmaWxlcyBjaGFuZ2VkLCA3NyBpbnNl
cnRpb25zKCspLCAzMCBkZWxldGlvbnMoLSkNCg0KLS0gDQoyLjE3LjENCg0K
