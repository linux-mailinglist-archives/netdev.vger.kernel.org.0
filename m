Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AAED41A1
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 15:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbfJKNpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Oct 2019 09:45:23 -0400
Received: from mail-eopbgr740048.outbound.protection.outlook.com ([40.107.74.48]:39328
        "EHLO NAM01-BN3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728123AbfJKNpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 11 Oct 2019 09:45:23 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBxCA3yT7XbQS3g/b+2IOv4DnJo7nQ44WLY1rliQyrkEKTTEFMT0UyvrGPvLPpbzBSnU2Hl9MaLGPxPNHrjQCAtXB34AZtf1xJtGqqn4ColAfELTFfETTBzLsZTVQzTelPHSmEAeiiYIal+fdO+l7Oe+cd49XTOXfrcbJO8bxBuO7pugKfgy+wutuYoBMNrqOypLJeJKQ9seThydeLg7Zs4p3GSSovsv3HGWyl11OTAAxQz94UIvHZc1FUmP3qT+fWnXBKA9I7mL9xoQ240i8+XXnhpsTVnUCTo95PfFLyAJ6KjvjsbcXlb58AadzCCWarozPAm630puhb0girO6Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+71ROZcbTfZ+ihiFUjxsr86VPRrjzTSLxeDJsSKx4Mc=;
 b=MPK9OqNI9UoL1KLQiCg+PrhQz6FkyLRfEe+YEy5yHN0pgJix9H/yLRo2zl3cXPr2hT4uNsgjWFFmPMGOplnA8e3H4pJDxHwNN2XnB27M54zXQanA8yx/2/n395raYqpmI9Oaiz6Md+/wTR3RlTyCbdELPYFLdHT4OHq37NhJt7Q1qHSd358YSVLems7WznemwB1nF1qTMG4h9aQIsI/olcLM1TbJ2+U7v9x++kiUPnNSA8Nq9K+Aa4Vy2KQn0emoTMrjDw/JuXxXL/lAua4cAecd1Nj8vo2TAdl9L7FLEYe1H6PcTmFNGtpulHxsrNgt76tHwHheTf9Hr0g46yrS0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+71ROZcbTfZ+ihiFUjxsr86VPRrjzTSLxeDJsSKx4Mc=;
 b=W+XiyJ/DUHnlfpZRTHMypdMHiCFZbIOrXRr6i4s2BP/lC32SwPeoclr+NbgBPdGDeXtpOcBjzvJ6H4gnIvph6W23YkUuRiPXd3H1cEB43HoNpTPxz5li/VnwdxqOq3zaHcEATq/RYXhbY4ZSy4FnUFScPoYgaHoQ1p1orazqWkw=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3587.namprd11.prod.outlook.com (20.178.221.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Fri, 11 Oct 2019 13:45:18 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.021; Fri, 11 Oct 2019
 13:45:18 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v2 net 0/4] Aquantia/Marvell AQtion atlantic driver fixes
 10/2019
Thread-Topic: [PATCH v2 net 0/4] Aquantia/Marvell AQtion atlantic driver fixes
 10/2019
Thread-Index: AQHVgDoe1VFNtqKPdU+Efm73c5uEeA==
Date:   Fri, 11 Oct 2019 13:45:18 +0000
Message-ID: <cover.1570787323.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR2P264CA0005.FRAP264.PROD.OUTLOOK.COM (2603:10a6:101::17)
 To BN8PR11MB3762.namprd11.prod.outlook.com (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 295cb0c7-10a3-4595-0861-08d74e514088
x-ms-traffictypediagnostic: BN8PR11MB3587:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB35871A894916B8B6446BA4EC98970@BN8PR11MB3587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0187F3EA14
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(39850400004)(136003)(346002)(396003)(189003)(199004)(6916009)(66446008)(14454004)(36756003)(64756008)(99286004)(66476007)(4744005)(486006)(2351001)(52116002)(476003)(66946007)(66556008)(2501003)(305945005)(6506007)(44832011)(7736002)(386003)(5660300002)(86362001)(2616005)(66066001)(102836004)(26005)(508600001)(8676002)(81156014)(107886003)(316002)(71190400001)(81166006)(54906003)(1730700003)(4326008)(3846002)(6116002)(71200400001)(2906002)(256004)(6486002)(5640700003)(50226002)(25786009)(6436002)(6512007)(186003)(8936002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3587;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tdnTfpVXVEmkyjB3OpeotmjC4dVuOoudAhrLBYYIyy03bvak/U9HW7w569zPjU4bA4C/alPwqColCKi/j431elV4VfEsvMkJaKbEMk1QgmfsG+3uWFJhsfRAlZL5hZoCxNnCujsT3wyII/h5Dut+ArgVRdKr/50IHSl9aUK2goX3Rv9/rHnCRvHDk9ua49DoljXSE+defVNyr2ljQyjyP/0XVP2F0WVfiufsiKo3DkzSWqVrQdgjQWzSw8F3NAobmedYQYlGHcVi226xmLQ3d5vEWcdZj36SF93+4rwDipFmnbhjbYuE7XW/qmEagOellq5mwTCNM83/ys1Wi+FavBSCrXN29tyMKej5JtSD5c8jFjKav8YXlgr8vKPmTtW8OowSa3Pvns55pSDYlkBsTol+vwKFW6kAqHi6JzC3MNM=
Content-Type: text/plain; charset="utf-8"
Content-ID: <3D319AF36E532D4D8F2160BA32AAF91F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 295cb0c7-10a3-4595-0861-08d74e514088
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 Oct 2019 13:45:18.1816
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hWvoEZAtIR2vjBVVUviyBYLAaD0EPevOzlBfzop9kj4OcK6c73IWG6aPJ4hdUxvqDdqblWk2Pz0R8Y8/kvUeFA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3587
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

SGVsbG8gRGF2aWQhDQoNCkhlcmUgaXMgYSBzZXQgb2YgdmFyaW91cyBidWdmaXhlcywgdG8gYmUg
Y29uc2lkZXJlZCBmb3Igc3RhYmxlIGFzIHdlbGwuDQoNClRoYW5rcyENCg0KVjI6IGRvdWJsZSBz
cGFjZSByZW1vdmVkDQoNCkRtaXRyeSBCb2dkYW5vdiAoMik6DQogIG5ldDogYXF1YW50aWE6IGRv
IG5vdCBwYXNzIGxybyBzZXNzaW9uIHdpdGggaW52YWxpZCB0Y3AgY2hlY2tzdW0NCiAgbmV0OiBh
cXVhbnRpYTogY29ycmVjdGx5IGhhbmRsZSBtYWN2bGFuIGFuZCBtdWx0aWNhc3QgY29leGlzdGVu
Y2UNCg0KSWdvciBSdXNza2lraCAoMik6DQogIG5ldDogYXF1YW50aWE6IHRlbXBlcmF0dXJlIHJl
dHJpZXZhbCBmaXgNCiAgbmV0OiBhcXVhbnRpYTogd2hlbiBjbGVhbmluZyBodyBjYWNoZSBpdCBz
aG91bGQgYmUgdG9nZ2xlZA0KDQogLi4uL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9h
cV9tYWluLmMgIHwgIDQgKy0tDQogLi4uL25ldC9ldGhlcm5ldC9hcXVhbnRpYS9hdGxhbnRpYy9h
cV9uaWMuYyAgIHwgMzIgKysrKysrKysrLS0tLS0tLS0tLQ0KIC4uLi9uZXQvZXRoZXJuZXQvYXF1
YW50aWEvYXRsYW50aWMvYXFfcmluZy5jICB8ICAzICstDQogLi4uL2FxdWFudGlhL2F0bGFudGlj
L2h3X2F0bC9od19hdGxfYjAuYyAgICAgIHwgMjMgKysrKysrKysrKy0tLQ0KIC4uLi9hcXVhbnRp
YS9hdGxhbnRpYy9od19hdGwvaHdfYXRsX2xsaC5jICAgICB8IDE3ICsrKysrKysrLS0NCiAuLi4v
YXF1YW50aWEvYXRsYW50aWMvaHdfYXRsL2h3X2F0bF9sbGguaCAgICAgfCAgNyArKy0tDQogLi4u
L2F0bGFudGljL2h3X2F0bC9od19hdGxfbGxoX2ludGVybmFsLmggICAgIHwgMTkgKysrKysrKysr
KysNCiAuLi4vYXRsYW50aWMvaHdfYXRsL2h3X2F0bF91dGlsc19mdzJ4LmMgICAgICAgfCAgMiAr
LQ0KIDggZmlsZXMgY2hhbmdlZCwgNzcgaW5zZXJ0aW9ucygrKSwgMzAgZGVsZXRpb25zKC0pDQoN
Ci0tIA0KMi4xNy4xDQoNCg==
