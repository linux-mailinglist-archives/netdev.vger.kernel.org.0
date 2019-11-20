Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81A3D103AAB
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730050AbfKTNFa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:30 -0500
Received: from mail-eopbgr50050.outbound.protection.outlook.com ([40.107.5.50]:61262
        "EHLO EUR03-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728836AbfKTNFZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=dyIorwlRpXrsLo/pBhaLTRmLSDh4oM0usKBDUcyvRAW990UwibDPYMvhbYsJ/XPXDA/u+h9Yn9aKNW4vnEADZw5CFVjqeumvO06rbar/Aa+/JahRtydKccilD7KaBNo4YVwNk37a5FlG94iCbNhj3kIHAcQj++JI7FGpo7Fn07tW7/1sA4fkJg6he4otfeWEH2aLcEav0bEocK/XOkY5zPtjYQdBCrs5OexpsOaHYi1PtpTtONEELBzpwd8GVifT7ZoSzEyq0SEj7jsXuOMS1FvgnTBPUgW7Ag/PfzA6SrOdprKdd+4AY3IABEjZYLBHTRPP96JCvFfj6IOFIcdDLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOmiVNML2TIQCsuXsTXXRIajpW4KYMHkOYP4QUlaNVE=;
 b=YSJzyCPUrj0q1es06NEBumHE4hQCpmdhsjcQThW7MdW0sjBS4VbKEuTeeVF77QJXFRYHpy7qtq9nnHYciAAO7FJccGeWZ6WqLmV/GagdjdbMM+cwmZpVyRUZI1TlFMv0Y5eulfMzFx2QdR/twPCtbY0RZ+40ZHUei/ZHkrkA4eWIMrMKuLaGboJAtb4PEpih+D5nEAPNU7O89XZlv0TM1g+nOtzh1mFAQDHCQ81VogGLnarX0HJCF04z+JA27hkODuVZ5BlxmP6fQoBlDoqnsF/duhcYrC/FD/mxmAljqhoSkx2rNQeTV77gHn7Jn+uZuMjj5ShSSWVVItvDGpWqPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gOmiVNML2TIQCsuXsTXXRIajpW4KYMHkOYP4QUlaNVE=;
 b=ef4u2W65bQaYqGjCkvjkJHmD5CPHtOU4BmW2JFlqGlzW6sU4veVN2keya/boi4nlYs/IYGHS9h4cKJH70YICZ+nYZNP4g3YgDDVLeuN8QWwT/6rbALR5/2bGL7wBU2Vr+ZzlqOu3Z2mdHWOJqfqpBVHUi7bYDWQN/Z3SI6j176o=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2950.eurprd05.prod.outlook.com (10.172.246.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.28; Wed, 20 Nov 2019 13:05:21 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:21 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 2/3] uapi: Update for the ETS Qdisc
Thread-Topic: [RFC PATCH 2/3] uapi: Update for the ETS Qdisc
Thread-Index: AQHVn6MpUHJqRdmsNkmwxlM10NbrJQ==
Date:   Wed, 20 Nov 2019 13:05:21 +0000
Message-ID: <20191120130519.17702-2-petrm@mellanox.com>
References: <cover.1574253236.git.petrm@mellanox.com>
In-Reply-To: <cover.1574253236.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: e521eba2-802e-4935-f35b-08d76dba4c5b
x-ms-traffictypediagnostic: DB6PR0502MB2950:|DB6PR0502MB2950:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2950045B911740A0BEDF238ADB4F0@DB6PR0502MB2950.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3044;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(39860400002)(136003)(396003)(346002)(366004)(189003)(199004)(52116002)(486006)(8936002)(2616005)(66066001)(256004)(14444005)(476003)(25786009)(6486002)(102836004)(6506007)(386003)(76176011)(81156014)(3846002)(316002)(6116002)(54906003)(2501003)(6436002)(26005)(66946007)(66476007)(66556008)(66446008)(64756008)(86362001)(5640700003)(5660300002)(6916009)(2906002)(11346002)(8676002)(71190400001)(1730700003)(2351001)(81166006)(446003)(1076003)(99286004)(478600001)(15650500001)(7736002)(6512007)(50226002)(36756003)(305945005)(4326008)(14454004)(186003)(71200400001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2950;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zvJqH1AbtROXcZb/VoeJVWYi10aPxFIX0D9e6wPs1NL5RQAwZtH7KBA+wLZb5LAgn7NopktzQsVIrDCmtTMB+yXpuCOllNrv9jVPeVjkDDiw4FKA1GxDBIqNlmVd+TOIUcBSysGvBOurkxXitBEXWE6FeX2M5c6r5TmqmRHGOyekLVyZ75RgEfEUUPgn1TT501IiP0i2thCyA45oVHCkV1Rtp7wX04QsgY65LD8ZUANL+Myojly6Iv7JaV4mZ2ZmpMPIg1FQUnLmYbB/SjsaM/soz7Ph8SFdgMWxIxtGYEefFsECRgZKFLZ31NP+OhlvQtIrefUl9brR5ouw2qNPlbTTmnOfD9+AgMmLH68Ym98k2/sGuO1LFOnIJsh3r5wrQ46N/JQlJ+lF7LhCOVe1xnWi+TrCIZacjRdI4X9itSDjzMLypxbU9fBxtIrqMqIM
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e521eba2-802e-4935-f35b-08d76dba4c5b
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:21.0872
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bXl/7W8or3V4OxKKmJg8teqawkUECR1R79YnvyNeQADzL8E77pMUemR/nUC5hnvdQ7JwZvQ0WdSXlTuTmLAGhQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2950
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update uAPI headers with the defines for the new ETS Qdisc.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/uapi/linux/pkt_sched.h | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/include/uapi/linux/pkt_sched.h b/include/uapi/linux/pkt_sched.=
h
index 5011259b..c570dfe8 100644
--- a/include/uapi/linux/pkt_sched.h
+++ b/include/uapi/linux/pkt_sched.h
@@ -1181,4 +1181,33 @@ enum {
=20
 #define TCA_TAPRIO_ATTR_MAX (__TCA_TAPRIO_ATTR_MAX - 1)
=20
+/* ETS */
+
+#define ETS_MAX_BANDS 16
+
+enum {
+	TCA_ETS_UNSPEC,
+	TCA_ETS_BANDS,	/* u8 */
+	TCA_ETS_STRICT,	/* u8 */
+	TCA_ETS_QUANTA,	/* nested TCA_ETS_BAND_QUANTUM */
+	TCA_ETS_PRIOMAP,	/* nested TCA_ETS_PMAP_BAND */
+	__TCA_ETS_MAX,
+};
+
+#define TCA_ETS_MAX (__TCA_ETS_MAX - 1)
+
+enum {
+	TCA_ETS_BAND_UNSPEC,
+	TCA_ETS_BAND_QUANTUM,	/* u32 */
+	__TCA_ETS_BAND_MAX,
+};
+#define TCA_ETS_BAND_MAX (__TCA_ETS_BAND_MAX - 1)
+
+enum {
+	TCA_ETS_PMAP_UNSPEC,
+	TCA_ETS_PMAP_BAND,	/* u8 */
+	__TCA_ETS_PMAP_MAX,
+};
+#define TCA_ETS_PMAP_MAX (__TCA_ETS_PMAP_MAX - 1)
+
 #endif
--=20
2.20.1

