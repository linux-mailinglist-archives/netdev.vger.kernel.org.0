Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A40C8103AA5
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728709AbfKTNFT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:19 -0500
Received: from mail-eopbgr60049.outbound.protection.outlook.com ([40.107.6.49]:50305
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728584AbfKTNFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vo99ETAv8zTH9Iv1/3ICGpO/KKh3tfGfOPPzeR+wqjVfJIQlvw7C2xh3031lr2F7Fi+T/lifCeafhqWzDB3ie2lHX/1vD5fQaMS3NCAXSvwIv4vi9Mh7x/ofELd6KHV7Q3j3zJ/ATEbdionxqxs3wuV0mSiiXF2HZ/OMLyoZojlmQZCbHqkbKjoRBCZI+svfdToD7qCQ5oMAr7KQ2eC/2ufzTSmpoOU2U2/F1rqMFhKb2o7/ayA1WXaaqVm9VfvZckQ/ijUp3ERXsEeK4gN1MlZjglXCeK0vXk6dTtzutJGyDjYbbNCU4Cy/IFz78rFiP7sAvVfRRxk/cr/umLdoBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7D4jTzmIOvFf5kJfLmCvW4vjVW2ca3oH8BMM80jwzY=;
 b=dlhrjKQoaDeyQcbf0BSalGiLJYkAXEVD3h4UrMEVTaahzNis11l828OM2CCNKOnKJjt3cRIqkEvqjSOQqMrCAx0v87LiSagdopN2n1Cq1OpjBbP6oJs9f1YAh8GkH3SV62kSqB2R2bc/4ZSoy7HI1FrcCt7RZNm+AFzupNsaN5VlP4Es73vpKhQDEsRxCP9GgqJsd4ZZAOfzP/ZHla7zh/L6iVP00LtW6kJZY9ogy4e8j8wNf7kkgNSYbRWOhxKd/xTy2GYaB9higCFI1QjcjLOpOHW2YN5K5VV+I26UZWFmVBwFJ+qGwCLvuHCDa5mIiAIAPtQEaVW1GqQTXCDXYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K7D4jTzmIOvFf5kJfLmCvW4vjVW2ca3oH8BMM80jwzY=;
 b=XBg70DEDeHplW4OiqTvfwU0d+PqlA7ml2YLUNDhfE0+9JRSNJQ3AGa008m4WDIwbWphfS8d406hOpZD37W9V/YRR7jmpNijuhWr9INX9sXaDIILDI3Czna1z77n1HcKyeBLJehNYp23a1XrNHtWcFT8T4lYzCI4WNPDJyaYhOec=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:11 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:11 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 02/10] mlxsw: spectrum_qdisc: Clarify a comment
Thread-Topic: [RFC PATCH 02/10] mlxsw: spectrum_qdisc: Clarify a comment
Thread-Index: AQHVn6Mj7DFuj6ouwUGs9F1BKHZ71w==
Date:   Wed, 20 Nov 2019 13:05:10 +0000
Message-ID: <a6acd26a03ed1b3ef7295ccea6fc1e592d990d8c.1574253236.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 6b52aa3d-278a-4980-01bf-08d76dba463c
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB2982E4DA1D6847B5630E903FDB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(446003)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(76176011)(71190400001)(71200400001)(2351001)(256004)(64756008)(2501003)(52116002)(86362001)(14444005)(486006)(6116002)(11346002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4326008)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: IxS5Ki5xuiXNSx+bRb8FKWu1aUMtz3tjyTCoHMAll86balI+Y34oUS6p3lH1JI31AHo1HJbXSHyHhUKsqJFWpkqD+bJiRKRP8E769TDcXaIfcwdMWq0B5ovZw231+ytP9RBhD7L8HglBGTjeMTBaGaGGK4trNsVTVfjWWEFvxioCdJ21wyQ44KHr9lqUozxFRT8ZWdubxT1cg1RtvIV+X36VfRy3frcnhTWmGeXuemFbBo17/o9wanD9Mu3XFbyyvrb86Uwr/fFGgQKTjJaaaOKuDJLHvJh1BFnW1QVA2X8ILDJU1BsGiFRuto1x4dH2Rk9vZ/9FNiqW016W96gV9zp5w3cuje7VXFv8Iv96H9sAHG0Exu9pOPuZG5la7WMBIFvtpXQkWpmBjjpiNZSGhwq/NWgEK7g7auNDBdGQJjmg1hR0G+oXWV76CnaPTIp7
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b52aa3d-278a-4980-01bf-08d76dba463c
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:10.8715
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0xqlZ+KCFgk0yO9/yed3Ni20cRpqIZTzXZbYGuuPb2esncXvDN1ef+MyTljBt00JWAXjxSLXhhRMmmZ1WnPu7g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expand the coment at mlxsw_sp_qdisc_prio_graft() to make the problem that
this function is trying to handle clearer.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers=
/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 68cc6737d45c..0457ff5f6942 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -631,10 +631,18 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_p=
rio =3D {
 	.clean_stats =3D mlxsw_sp_setup_tc_qdisc_prio_clean_stats,
 };
=20
-/* Grafting is not supported in mlxsw. It will result in un-offloading of =
the
- * grafted qdisc as well as the qdisc in the qdisc new location.
- * (However, if the graft is to the location where the qdisc is already at=
, it
- * will be ignored completely and won't cause un-offloading).
+/* Linux allows linking of Qdiscs to arbitrary classes (so long as the res=
ulting
+ * graph is free of cycles). These operations do not change the parent han=
dle
+ * though, which means it can be incomplete (if there is more than one cla=
ss
+ * where the Qdisc in question is grafted) or outright wrong (if the Qdisc=
 was
+ * linked to a different class and then removed from the original class).
+ *
+ * The notification for child Qdisc replace (e.g. TC_RED_REPLACE) comes be=
fore
+ * the notification for parent graft (e.g. TC_PRIO_GRAFT). We take the rep=
lace
+ * notification to offload the child Qdisc, based on its parent handle, an=
d use
+ * the graft operation to validate that the class where the child is actua=
lly
+ * grafted corresponds to the parent handle. If the two don't match, we
+ * unoffload the child.
  */
 static int
 mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_sp_port,
@@ -644,9 +652,6 @@ mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_s=
p_port,
 	int tclass_num =3D MLXSW_SP_PRIO_BAND_TO_TCLASS(p->band);
 	struct mlxsw_sp_qdisc *old_qdisc;
=20
-	/* Check if the grafted qdisc is already in its "new" location. If so -
-	 * nothing needs to be done.
-	 */
 	if (p->band < IEEE_8021QAZ_MAX_TCS &&
 	    mlxsw_sp_port->tclass_qdiscs[tclass_num].handle =3D=3D p->child_handl=
e)
 		return 0;
--=20
2.20.1

