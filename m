Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70FB7CF7A7
	for <lists+netdev@lfdr.de>; Tue,  8 Oct 2019 12:57:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730662AbfJHK5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 06:57:13 -0400
Received: from mail-eopbgr750051.outbound.protection.outlook.com ([40.107.75.51]:48528
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730278AbfJHK5K (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Oct 2019 06:57:10 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NYIYjq0/SsVdRzAuD9qcR0KaMZ1CqP1BZ/fo80ewo0sovxWocW5nleY/VOGeJeOXC+34e38hVRD2t7GnsA7tPZpsas/XiNYGsXJmVCDYpVVjiEWFp7Pao/+Xpi6GYgqj5LziyQtdAkOoS2lr59fQ/rl4GxrADkt/EhLVJXMkgR9h2YRZfK/5dLpVyfC1WalFKmQ/MHBaC9oITG0ezU1SSdz+7UvwGPp3usl6rON2bWfiATTsdUtOFSTbY/toBjzNCnXZIroArDd8ZOdxwAGm8C8lHnJgR9s3Lumq+JxUKYFk384dMBEZx7Qrg98PdxypPTOKPEWMRUUIh1b1FI+neg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bdM9WdcMV/fcWLs7Oz1+ANuYSif6tmWHvKqTKF+S+A=;
 b=O2p9bMa48JMSfqYWb3WDIIdwWkMiR75l3nIipaPrwACTzfBiaQ7XNqJewkN1BjiQYbb11jRraOGg78BHvpUxn37UVBXegZBviRD6OxF2U7CQ4OAWIESTLCQEq91jOHmbq2vqz4j757GoeI50vdnFVoPAuacsRwqzj3sMVh49RT+ECHD/FDzqdCMyAwBN3EY9Oztsv4gVsS/CNQE+FyR+Rc6uYVOKURZycoweMbk2zuPIeMNQ2hczAn2vbkkcAZFghiybWwUWhNKCQDhbCC/j9Vp4HeQPYculh/lGV4E6B7IDWU1t0yJofvzJ6EAlq7QjvRgIc24w8v4uV1TiQcEHhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=aquantia.com; dmarc=pass action=none header.from=aquantia.com;
 dkim=pass header.d=aquantia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=AQUANTIA1COM.onmicrosoft.com; s=selector2-AQUANTIA1COM-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4bdM9WdcMV/fcWLs7Oz1+ANuYSif6tmWHvKqTKF+S+A=;
 b=8BlVzWbUha06wglyUSAg5GF73nxrbnlK0seDVelEKlgW/nMJPgocB5KwHNbN9OC6IKo3fs+NWstIupR/rM8eHwxsyP8evyUUwbAw6cEa6KtbdXOllaZZWvf1cINwjIO2Ng902yD4DrlHfbOGkhC895VE1hGYQX8/18Rmt7W0d0M=
Received: from BN8PR11MB3762.namprd11.prod.outlook.com (20.178.221.83) by
 BN8PR11MB3666.namprd11.prod.outlook.com (20.178.221.19) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2327.24; Tue, 8 Oct 2019 10:57:01 +0000
Received: from BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f]) by BN8PR11MB3762.namprd11.prod.outlook.com
 ([fe80::accc:44e2:f64d:f2f%3]) with mapi id 15.20.2347.016; Tue, 8 Oct 2019
 10:57:01 +0000
From:   Igor Russkikh <Igor.Russkikh@aquantia.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "richardcochran@gmail.com" <richardcochran@gmail.com>,
        Egor Pomozov <Egor.Pomozov@aquantia.com>,
        Dmitry Bezrukov <Dmitry.Bezrukov@aquantia.com>,
        "andrew@lunn.ch" <andrew@lunn.ch>,
        Simon Edelhaus <sedelhaus@marvell.com>,
        Igor Russkikh <Igor.Russkikh@aquantia.com>
Subject: [PATCH v2 net-next 12/12] net: aquantia: adding atlantic ptp
 maintainer
Thread-Topic: [PATCH v2 net-next 12/12] net: aquantia: adding atlantic ptp
 maintainer
Thread-Index: AQHVfccc9VyxUKgxOEKYM3nfa2Dk5g==
Date:   Tue, 8 Oct 2019 10:57:01 +0000
Message-ID: <8a7db3f57de8806a70faab18ab63e461159d58ae.1570531332.git.igor.russkikh@aquantia.com>
References: <cover.1570531332.git.igor.russkikh@aquantia.com>
In-Reply-To: <cover.1570531332.git.igor.russkikh@aquantia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: PR0P264CA0215.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1f::35) To BN8PR11MB3762.namprd11.prod.outlook.com
 (2603:10b6:408:8d::19)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=Igor.Russkikh@aquantia.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.17.1
x-originating-ip: [95.79.108.179]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: afb04121-368b-4dfa-36ce-08d74bde3f2e
x-ms-traffictypediagnostic: BN8PR11MB3666:
x-ld-processed: 83e2e134-991c-4ede-8ced-34d47e38e6b1,ExtFwd
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <BN8PR11MB366670396AD6CCEBDE19BC37989A0@BN8PR11MB3666.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5797;
x-forefront-prvs: 01842C458A
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(979002)(1496009)(366004)(346002)(376002)(396003)(39850400004)(136003)(189003)(199004)(118296001)(71190400001)(71200400001)(2501003)(256004)(6916009)(305945005)(316002)(107886003)(2351001)(4326008)(2906002)(44832011)(6116002)(7736002)(3846002)(54906003)(6486002)(6436002)(11346002)(5640700003)(6512007)(99286004)(6306002)(25786009)(66556008)(50226002)(76176011)(52116002)(5660300002)(8936002)(2616005)(81156014)(66446008)(102836004)(81166006)(8676002)(386003)(6506007)(508600001)(4744005)(14454004)(26005)(36756003)(86362001)(446003)(64756008)(476003)(486006)(66946007)(186003)(66476007)(66066001)(1730700003)(969003)(989001)(999001)(1009001)(1019001);DIR:OUT;SFP:1101;SCL:1;SRVR:BN8PR11MB3666;H:BN8PR11MB3762.namprd11.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: aquantia.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 6TMNKqpjtYZbDKSA38UNi03hjnlysxxsCF+zIgpHXoXsb4PGwECD/TmBerlGrMQVhHaiVnTH5QkX42dQKB/g8cP2eEWbKKAtG3dTXAwltu2YRJUsg3R/8DVMKyrr/TMZanFuuH6bqm7U/RYcHJkIcVm8Ln6frxCbHr1Ur5dGVOH1sa43wh21PUugvlrPwr8KlqfrKbY0ESg8zYwk2GBiAlm+8ZH6yNjnYJgzj7HNje3ozo2wTHAn+xMOaV+BWW2tRc82zk1OThDun7IhbJuJ7EYMntV6EO80jxEnp7yoVvafADRRX7TqEUXQvUDC2d13AWdJMvzhg3uK/KMB6kS1v6FgbJsEXchgLU53pZ3zTKoaxP/3o/DP6CEpbmTM5Zsc76DYOmpiXLyiBnGo8lz2O/k30t+s3+kLtJZIPvkb/eU=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: aquantia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: afb04121-368b-4dfa-36ce-08d74bde3f2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Oct 2019 10:57:01.4818
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2e134-991c-4ede-8ced-34d47e38e6b1
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vY91p4AtQSoM91trayvIZRoONMhgk6G/pws3C4ZNBur6ifVOBk+toURj+91pGazfQ/pdr6CojQM8BeizsR8aZA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR11MB3666
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PTP implementation is designed and maintained by Egor Pomozov, adding
him as this module maintainer. Egor is the author of the core
functionality and the architect, and is to be contacted for
all Aquantia PTP/AVB functionality.

Signed-off-by: Egor Pomozov <egor.pomozov@aquantia.com>
Signed-off-by: Igor Russkikh <igor.russkikh@aquantia.com>
---
 MAINTAINERS | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 496e8f156925..c757749040f9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1190,6 +1190,13 @@ Q:	http://patchwork.ozlabs.org/project/netdev/list/
 F:	drivers/net/ethernet/aquantia/atlantic/
 F:	Documentation/networking/device_drivers/aquantia/atlantic.txt
=20
+AQUANTIA ETHERNET DRIVER PTP SUBSYSTEM
+M:	Egor Pomozov <egor.pomozov@aquantia.com>
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

