Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D96A1F1530
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 12:34:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729777AbfKFLeQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 06:34:16 -0500
Received: from mail-eopbgr800088.outbound.protection.outlook.com ([40.107.80.88]:26624
        "EHLO NAM03-DM3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725856AbfKFLeQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 06:34:16 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=e+UtrgHVRaI/AC5RKNo/mWgDPTygjgg0k7yd9IF50ELD/zzNDkZYfF+nLXumSGHGqK8rgkPDHNSCer8Y+Hme/L3m2A/MEqznjJpDtU568ledvqetDukMexxomB0ZVHFN8nYeXXuwEK/LoTWuTbuhfSAf4Fw5RzXX7LnyqnlK5kjOy423njvdm3C84Ni+drYs67ovhCeacwZcRP18nQNfSxN8JLzOuY6WGfb4qb5DBer/p7zlgY2/Q4U7RceL0TFxvyQBbbRP0HydYFHxzj2rRRH0vjpXnCj4Vf5ZSb+n60S3LCvC2+SualWDx8lF1dYtsU2FsQwxd9s53VepTuXEoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTm+QhdB+etugVN+zZJe1PcdXzqRX98SD6farB7u+Ao=;
 b=Wnr+/hBJyqxpxQwEMpE1iH5d7tiSlug9nmZiG38fWpx56zw4Btl2jVA2oJfr3YptU+gv8e8v4UQ2dPyFfUqgh5z98bTfXLtMHZZ4FnqUFVZI1ypoSQ4cy4j9Z1Zu7kNkcNIYSVY+uFXe+MKkNs1MaQBZyTavKgrqfU2rJVJi13Lu4lULEeLbtRSGA86XECfuRMaMntYzwTptcMsCYHqYihzrlRW0AemKk9Zg9NZN5eO4zuNV5/nmiKn2+bsRErsRzzSCoyt+QRVMtBfZ50aMsthlMZs5Mi0EtH4hEUO4h1f+wJCBa1t8R/XsIMzKerIMP8pb9TW7r+4u8Wh6HmaFdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=infinera.com; dmarc=pass action=none header.from=infinera.com;
 dkim=pass header.d=infinera.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=infinera.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xTm+QhdB+etugVN+zZJe1PcdXzqRX98SD6farB7u+Ao=;
 b=JHek57ghtROx468N5pEcfDXg9ehV9zcYwwSawVzSWMvGOB7m2C4fTJwX3fRCiyWMgSRbN8gmEXxjyUJVLxpbwNw8b4altlr3OdYq2nvWecEgtEYnI1dvplu50T/KoYJHwLq2HPm8r7MesieSVmoNYTxmIo3kiZG6nNPwbAnh/CA=
Received: from BN8PR10MB3540.namprd10.prod.outlook.com (20.179.77.152) by
 BN8PR10MB3218.namprd10.prod.outlook.com (20.179.136.84) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 11:34:13 +0000
Received: from BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::d0b1:a3a7:699a:2e2]) by BN8PR10MB3540.namprd10.prod.outlook.com
 ([fe80::d0b1:a3a7:699a:2e2%6]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 11:34:13 +0000
From:   Joakim Tjernlund <Joakim.Tjernlund@infinera.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: SIOCSIFDSTADDR for IPv6 removed ?
Thread-Topic: SIOCSIFDSTADDR for IPv6 removed ?
Thread-Index: AQHVlJYdvtZdppS9xU+N4EAZGCsgHw==
Date:   Wed, 6 Nov 2019 11:34:13 +0000
Message-ID: <63900c63bcb04f226fba538fd31c609c8ff6e776.camel@infinera.com>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Joakim.Tjernlund@infinera.com; 
x-originating-ip: [88.131.87.201]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: b9ac8954-e889-4b6a-f5da-08d762ad3fc7
x-ms-traffictypediagnostic: BN8PR10MB3218:
x-microsoft-antispam-prvs: <BN8PR10MB3218D130390E1B3F69B1BA3AF4790@BN8PR10MB3218.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(346002)(366004)(396003)(39860400002)(376002)(189003)(199004)(6116002)(71190400001)(71200400001)(66946007)(36756003)(6486002)(99286004)(256004)(76116006)(6916009)(66446008)(66556008)(305945005)(3846002)(25786009)(5640700003)(558084003)(6436002)(6512007)(86362001)(66066001)(26005)(102836004)(2501003)(7736002)(91956017)(64756008)(2616005)(316002)(5660300002)(66476007)(486006)(8936002)(14454004)(2351001)(476003)(118296001)(478600001)(81166006)(1730700003)(6506007)(81156014)(8676002)(186003)(2906002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR10MB3218;H:BN8PR10MB3540.namprd10.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: infinera.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rbp9Z5slzjFZGjhbpQNm77kXXcM2lA7Qh70+0SauX0Bq9sZtFWEKU9BKHWXZQedsvH8TPG0vTZ6id/3Fe5P2dNJBHM2qGzxKc17cXLE0sbUE0MAq72KqBga+LoU9aZIuCtHTZF6dqj5yvgbxqFWbgMWywnsDvrR5TUhkSi3zPeTFJNnO8kxPW0ZUmLrwizX/s0v6OgMGCxpAkcTUa1H5vvBp6g/LTafryFm1xm5kIYwH7fNWupB8lQG6Bn4taL25doDEbcsj1W3VLxXOk37Tc3pDf7994YB41XMDJOOR0LO5n+LF5lQNwG/AyBf4v07E4uIBbqgbO4YsbncBr0Jjemx8T9JFq4tgeyIfqbORtqB/0CW0hsQ6Ld1u37Enl3kNAdxid9lifsLOoN22F6VMU0hLRZyiTG3TaADsfXpAe8Nch55ddtmPdopCCemLeIUO
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <9F82D27C13C0604EB8F3D79440F67980@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: infinera.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9ac8954-e889-4b6a-f5da-08d762ad3fc7
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 11:34:13.4768
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 285643de-5f5b-4b03-a153-0ae2dc8aaf77
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iGacmIt/FFRaaQu5AM2tMfHvugKr8Xkzwshfgc9jWRFp1v/cEpQT9LUzb4MmrQCZTav57UTzUxFnQKTZScaWBw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3218
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbSB3aGF0IEkgY2FuIHRlbGwsIGl0IGlzIG5vdCBwb3NzaWJsZSB0byBzZXQgRFNUQUREUiBp
biBJUHY2IGFuZCBJIHdvbmRlciB3aHk/DQoNClRoZXJlIGlzIGFuIGV4cGVjdGF0aW9uIGZvciBJ
UFY2X1NJVCB3aGljaCBjYW4gYnV0IGFtIHVzaW5nIHBwcG9lIGFuZCB0aGVyZSBJIGNhbm5vdC4N
Cg0KIEpvY2tlDQo=
