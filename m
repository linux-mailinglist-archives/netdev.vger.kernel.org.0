Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CCE54E59DA
	for <lists+netdev@lfdr.de>; Sat, 26 Oct 2019 13:05:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726203AbfJZLFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Oct 2019 07:05:34 -0400
Received: from mail-eopbgr820078.outbound.protection.outlook.com ([40.107.82.78]:56384
        "EHLO NAM01-SN1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726124AbfJZLFd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 26 Oct 2019 07:05:33 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Pw3clFxNKMPBJbznAzntasJ2k7W+/ODLxGIztWvz0VX34LObITsERBuSDWNVrWabCsxJjNF+GCG0RnsgWU9mhSTUitj7lMALkUNQB5otC9mRdKqs61Y5hoqFUAwm1sZuFnx82dUSID1iE/8K+OkTZXWQT0Vcyv76pmA00CVpWXVFxYpdvVOKXWKvvQr4/Vy/71Hv991jVUUWql4Yhd1YG5ZQ3WRvdnIZ4PI374C5DPAo7n6Z3Au6J5DkgkufN0X13UkkYJhGWIMiZEvoiVJxpusONFyB+KUh06Tm8XDCQKaNCK16wAY+KRwY7O43DYYUqpu0G840jKzcSnBvz7yk9w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdQt3pgQXdRX6v7ZfuWAkwFeul39rmeyqLytZgqb+lk=;
 b=c3SG27bftMKN5iAO/H9o3UUPTn2driAB15R/aeiawJZLcIabby46+2LPzihwQoFkZtZ9OsO0IfLgPtUxLLGzF1AtNwUGuiZuxyZwlATRZRhCLhVnjKM9VeuworUDiBJfPrRX4z++xMPv2+4sNLrnzEehFVZ8Q9rVELj4JOnBrYqv+TN/XOTbmGPV3rG6W1MGVEVH61IYU7RnnQq82JxRGvN+DMfw1SHGWR2ieNahQcZYIoevYLmhlFBm83VJbjW/o+0qN6vDQvC1keJhFmKAjrw4WUOgdR8tdZx2a7eN1mtTLFleNbYWos9SxpOiW4CCj/iqXUCmfIfGhB9GfduNrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=UdQt3pgQXdRX6v7ZfuWAkwFeul39rmeyqLytZgqb+lk=;
 b=s8oimWSWbCOkdAjklHduxqB95UsDq1YOuPUOsvxdCttNr+gIWLWTbQ2eLgFOE5h8hIWwMd4finBDdvQhJJs5cmiGbqHiqaUqnYVxDagyxlygZ2VQATJtidEriNRt/tmY43q2w9tNtnKmd3zIROMN9QuHjDzQIj/jhasrlw59N5U=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3587.namprd11.prod.outlook.com (20.178.221.158) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Sat, 26 Oct 2019 11:05:30 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2387.023; Sat, 26 Oct 2019
 11:05:30 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH net-next 0/3] net: aquantia: ptp followup fixes
Thread-Topic: [PATCH net-next 0/3] net: aquantia: ptp followup fixes
Thread-Index: AQHVi+1HIHCWF7sVn0uBLBofmSyLig==
Date:   Sat, 26 Oct 2019 11:05:30 +0000
Message-ID: <cover.1572083797.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: GVAP278CA0015.CHEP278.PROD.OUTLOOK.COM
 (2603:10a6:710:20::25) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
x-mailer: git-send-email 2.17.1
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 161844d8-b401-4ed3-47b5-08d75a0469d3
x-ms-traffictypediagnostic: BN8PR11MB3587:
x-ms-exchange-purlcount: 1
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB3587C269D8A3E151FB5E8EDD98640@BN8PR11MB3587.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5516;
x-forefront-prvs: 0202D21D2F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39850400004)(346002)(396003)(376002)(366004)(199004)(189003)(386003)(6512007)(64756008)(66476007)(66946007)(508600001)(6306002)(66446008)(3846002)(6116002)(14444005)(36756003)(26005)(256004)(2351001)(71190400001)(2906002)(71200400001)(99286004)(2501003)(305945005)(66066001)(6436002)(5640700003)(102836004)(6486002)(52116002)(86362001)(50226002)(6506007)(6916009)(966005)(44832011)(316002)(4744005)(25786009)(8936002)(81156014)(1730700003)(8676002)(81166006)(5660300002)(476003)(2616005)(4326008)(54906003)(486006)(7736002)(186003)(14454004)(107886003)(66556008);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3587;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: a/YsH7wGLkYH2YHdONpNdlaWgvza9a5FSbGzs6lmh3T9sx+ZAk/SXryffN0YW2AoCM8CGRjMZyElUIJ2PWUZgwQxxoPLX3VtM5pmJOyOW9YrBKZJrG/OIZpMU4UPYnLJJpPSp/f/NdweG/B6DF7KdMRwrPNZZHHUb/V0kyWuEntwR8b2aowSnj55fb+D1F/wtKP6839nDFMpFMawgEFjOhG078QwCUpGXsdRC86k+5xLdM8NlpR1/WzNLL+4mbj/ClfSEPNyv/0CNceb0gnkYsO+n7pUnt3tDtA3Pof7kcggenU8k3+ID14wNzOmPZMIev01NDBdYF1fV3RcL6pBHHXVDNFsgmardQll+KQ1LSGCgI/wa39PFwSjgbvs4l6SioSLJEi8yxKZXu6S1jrU8wpzyx8zo0/BSuUMIcon2GC/KYga6r5dpqbi6aC68OJ7lQ91GIpRErhS+qyAO7CqpDWbQF3Pq+h46KiewluJbEA=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 161844d8-b401-4ed3-47b5-08d75a0469d3
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Oct 2019 11:05:30.2115
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: I3s5drO0iZQVWLdzvMNICh2lwkYH+iXifCapkjlrAdlRIJaU0gEbnYhg7VhGbloXH8cBnuEQrRNwUD6w03vy1A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3587
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

Here are two sparse warnings, third patch is a fix for
scaled_ppm_to_ppb missing. Eventually I reworked this
to exclude ptp module from build. Please consider it instead
of this patch: https://patchwork.ozlabs.org/patch/1184171/

Igor Russkikh (3):
  net: aquantia: fix var initialization warning
  net: aquantia: fix warnings on endianness
  net: aquantia: disable ptp object build if no config

 .../net/ethernet/aquantia/atlantic/Makefile   |  3 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.c   |  2 +-
 .../net/ethernet/aquantia/atlantic/aq_ptp.h   | 84 +++++++++++++++++++
 .../aquantia/atlantic/hw_atl/hw_atl_b0.c      |  9 +-
 .../aquantia/atlantic/hw_atl/hw_atl_utils.h   |  2 +-
 5 files changed, 92 insertions(+), 8 deletions(-)

--=20
2.17.1

