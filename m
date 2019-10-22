Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F541E013A
	for <lists+netdev@lfdr.de>; Tue, 22 Oct 2019 11:54:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731656AbfJVJyL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Oct 2019 05:54:11 -0400
Received: from mail-eopbgr810057.outbound.protection.outlook.com ([40.107.81.57]:7515
        "EHLO NAM01-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731333AbfJVJyK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Oct 2019 05:54:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TFMzDzALa8X/z7BD+IMsZHPfYBidTsAqP0lmNEV23pdTV3BnRRuwB/5WV8wAlkm+NW96pDG9w+I43nE7yrtSi+9Gts0VqF01iXVON+lvxeUco8syaHH2tz3FV35ayIDcTBY0bjGuKb25FmCL8i3pP/+zC3Q18YR8OcJ/XQPnKf8ZQMZ8vnAz2WjHD3doRle2VeZ1DiZGrvU+8u1VTHTSq3/UK2tt6U1EcHPkyKVGfsAGbVqhNRo9sRX6D0vVszKpWk0plH5AIfMBIurelZk/D55E5A9UCOFl4zQbe03xM0TK2Wf1G1STb/c7lYIuB7We5ZyTXglJqG7x7WDxEZc7Qg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUkgGS2ppNJtJnDtM5D5tjgUDYXBJVXa4E4VV2/3r7c=;
 b=D9BbKnqNe+zmYS83rFaanGvQuKBuzWGRsNQHQ0N5XfsSipExIbKIxRyjlykPY5XeIN5RAI8dDUiHkb91S95DH4g6oOL44gONwldynkQVhaiFu1jJipyEVroZPoRD5VdIFjIa0qKWv6vtgudSmk9zGVWjTM+EK/pCkRPHQ4nPHntslAa12HRGz1C1MvJii0V25KWTXJw+0X5yFM3ZraMbAQJ5GSf/ANewiuQZHCMQl7muFsOaZoUOR52mRgFunYpPB3xiy4cg6VZcTMcLiNqh+s/RSj1vcGoacxow/9FLJVt4rv795xpniGxLQKHZg+EHNfcKrqHtRMOKunTl/A56fQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NUkgGS2ppNJtJnDtM5D5tjgUDYXBJVXa4E4VV2/3r7c=;
 b=cLS9JBWEf21Gv+pNDbirMDlC2kXH+zxP3Y4Y5EUyIE3ksNeJBST2i0B2FglvPbbfZtog076Hcey8qAAZ4RAtB5jOpV1GChE+vMvXtTodxdBppSnm1MXrzR9/Q6hKx4JtMP/49KhjnZ3yWnCvlxpzqqp1BL4tBm4xBG9ec+/x94c=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3650.namprd11.prod.outlook.com (20.178.221.216) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2367.21; Tue, 22 Oct 2019 09:53:49 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.028; Tue, 22 Oct 2019
 09:53:49 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        "epomozov@marvell.com" <epomozov@marvell.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v3 net-next 12/12] net: aquantia: adding atlantic ptp
 maintainer
Thread-Topic: [PATCH v3 net-next 12/12] net: aquantia: adding atlantic ptp
 maintainer
Thread-Index: AQHViL6a24ovb2OzcEys8fhIUimfrQ==
Date:   Tue, 22 Oct 2019 09:53:49 +0000
Message-ID: <0c02d1f5cdbf898d6a9ca235fc0df2e8ab425c7f.1571737612.git.igor.russkikh@aquantia.com>
References: <cover.1571737612.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1571737612.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: MR2P264CA0092.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:500:32::32) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6f670205-e924-4878-dd9a-08d756d5bcf7
x-ms-traffictypediagnostic: BN8PR11MB3650:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB36507F4B4D7B407BFE1F27FA98680@BN8PR11MB3650.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01986AE76B
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(39850400004)(366004)(376002)(346002)(136003)(396003)(199004)(189003)(6512007)(107886003)(4326008)(4744005)(6486002)(6436002)(5640700003)(6306002)(3846002)(6116002)(2351001)(7736002)(305945005)(25786009)(81166006)(81156014)(1730700003)(8676002)(14454004)(50226002)(8936002)(508600001)(66066001)(118296001)(66946007)(6916009)(66446008)(64756008)(66556008)(66476007)(316002)(54906003)(71200400001)(186003)(86362001)(2616005)(476003)(446003)(11346002)(102836004)(2501003)(26005)(76176011)(71190400001)(99286004)(256004)(52116002)(6506007)(386003)(44832011)(2906002)(36756003)(486006)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3650;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: M4tJgk0ozPkvVf+ISiODjag5skCXjWLhpCH59Bid/6t1UV6lJUHD9RhsiC9/l0AdxmtolbwLio4JTzeMqCJ/GG96/vniUGTFbyPKeLh2YjfdAGudns26vqya1ss6WL7Qx+hj1+SN9Ka53PSyk0zAsgg8VxOK77/KZRL8aFNpjghXNbrHnl1M2oMs98jBAhJpFDLvjiZ2zfnVtlvOj950O7uIhXhBGBbOxIlOCiroZ/Yl3DV9VLs5ko4bv3wkFhvAqPBd0xAfMC4mSVlCE3OqUFxQ/zRWCIxbFBQP21sqprA/qrZd1TLoghgnm4RRDrG52Z5dUI9m52/NJK9xemvETUZ+c5cnRSNFbKY6lfDmker/weoTdOQ8RmxTCciXhSPY7wgOf2yI1U+vlyak0Waytk7CALtZhzfPAG5UZcjdTKn4w2wZxtlXjo9jIV3MOnCG
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6f670205-e924-4878-dd9a-08d756d5bcf7
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Oct 2019 09:53:49.7306
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: GXtq6ZrhSylRGWfySoMh4aPwH2t8nfToGZSt5KChFHqG5+06pPpkyzSGATrxqcdrfdH7zkhWNImDob4oMC+R3A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3650
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP implementation is designed and maintained by Egor Pomozov, adding
him as this module maintainer. Egor is the author of the core
functionality and the architect, and is to be contacted for
all Aquantia PTP/AVB functionality.

Signed-off-by: Egor Pomozov <epomozov@marvell.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index aaa6ee71c000..7fc074632eac 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1190,6 +1190,13 @@ Q:	http://patchwork.ozlabs.org/project/netdev/list/
 F:	drivers/net/ethernet/aquantia/atlantic/
 F:	Documentation/networking/device_drivers/aquantia/atlantic.txt
=20
+AQUANTIA ETHERNET DRIVER PTP SUBSYSTEM
+M:	Egor Pomozov <epomozov@marvell.com>
+L:	netdev@vger.kernel.org
+S:	Supported
+W:	http://www.aquantia.com
+F:	drivers/net/ethernet/aquantia/atlantic/aq_ptp*
+
 ARC FRAMEBUFFER DRIVER
 M:	Jaya Kumar <jayalk@intworks.biz>
 S:	Maintained
--=20
2.17.1

