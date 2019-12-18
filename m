Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 922A5124A78
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:56:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727441AbfLROz5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:55:57 -0500
Received: from mail-eopbgr40087.outbound.protection.outlook.com ([40.107.4.87]:28566
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727296AbfLROz4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:55:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FxXKOFuhq7pZQsokIYm0hm1xdlSeSkgalqV+dGNRxgQY5HkmdNEbaCLizL7ne4p5DcruTxbvVAoYgiizIE0PMHZ8RiMS0JeCFsR1D2CBN0AvQOJiMBI5iPVp28OMYA40dIyKQTehkfZOxqGgNt+1C/LWz6EVgQTMVeFR/M2dR0AMhowTf1RVDCbWSOEPkdc0Aec4x8ZLjBZ3VNgLQSlKu/eU/txN4JbMxx2UIIeokvEoQA7rnGTlMvcJZSHOImd1+MtuZ4Ogo9IYeLIdX/g9TJbv8o6Xf8pVqhj3gTkbwI5p5iLqp5eamOCnrcjrKvu6JoKQ06gqzkfYIcWwORk4TA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJezdWqp9nLNdOekwIN185NuqXoZlPqEi/LmdjBYlDA=;
 b=Hh/WL/H8OVznrEdksESoFNOKUSpxEvFfYa5ZBVnpe4kWyXBf0ocjvX2y7lDiA6GRlU36uWODVIm3FZk+H9mBIuFUEaeYbn3HzNoeYO/fm1XG3GZOP11nfa3mgZv6/fvDeFx1tx2v5ilxNwRqf81U+pt7oY5ykl1OEhMfJ0O8nh/mlK1bj5rvhsf0uNcsuykRZQWLNzqD/WU2eXeezcKniJXsf+2BE5jW8nyCPC9R9zt++jMyw3GY8zdUKXhy+vZzxsPl7agGVsHDkMb5n8myiSHFjYVps5TU5gbotbXlnplTiwokq8Fu76ItfSiMTPEorxDCjjm7dlwra8lKbK51rA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJezdWqp9nLNdOekwIN185NuqXoZlPqEi/LmdjBYlDA=;
 b=KEei0rClWRL+4yhgr4QorgGtllzKzfyFUcbVXtJXSX9iO5w1R+TIE+0XjOp2ltgtaD+/AB6/befWgPd5ZTSyv/336DMXSa8rCUNgrlNs/qulWujMUVlmBcOZuKT3bl6ByLoBH3M+82yVmjfxzRN+2RS34lrYXa5lvpFzHOeIDx8=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3048.eurprd05.prod.outlook.com (10.172.250.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 14:55:10 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:55:10 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v2 02/10] mlxsw: spectrum_qdisc: Clarify a
 comment
Thread-Topic: [PATCH net-next mlxsw v2 02/10] mlxsw: spectrum_qdisc: Clarify a
 comment
Thread-Index: AQHVtbMk6XjN7z1ArUiE+NyMw4xP9w==
Date:   Wed, 18 Dec 2019 14:55:10 +0000
Message-ID: <f203d4481f4634a4c763b17955e9488c90e9f35a.1576679651.git.petrm@mellanox.com>
References: <cover.1576679650.git.petrm@mellanox.com>
In-Reply-To: <cover.1576679650.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR2P264CA0031.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:101:1::19) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 708944e6-25e4-4955-3c16-08d783ca4739
x-ms-traffictypediagnostic: DB6PR0502MB3048:|DB6PR0502MB3048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3048D5038B65204EE72A0DB0DB530@DB6PR0502MB3048.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(2906002)(478600001)(6512007)(8936002)(81166006)(4326008)(316002)(107886003)(8676002)(71200400001)(26005)(186003)(81156014)(86362001)(2616005)(6916009)(66946007)(66446008)(64756008)(66556008)(66476007)(36756003)(6486002)(5660300002)(54906003)(52116002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3048;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: oOaNIMnB7J0Fn70mDBrIiMIvGpZ0oSSGwU14Ryh8IqeJy8OyuIHMlLypGyjDniaU7K7E+Hp2xCPIkt98NCGiTqI/kDmkXdb/n0rc7zoieFHyQ2muX2fEl7Q+K3+UNTZcmllTjBFh33GeJTf0TxRxKc8gAvotXqjb+VqgUOQ+92znMrsxqQMqGvtVej0OLQxv5S3mtw3SBn5XfHe6oJokNpqcgCd4eK/8yfIP12qlD6cApGKTqBl6Wk2miSuMgNHcJlgsjegsIq1GLPbAHtwNlIdar6ghpiHcBLJsg7sdVX/qyLchs42c8IO4BCP55zZ8BgaGOqPyxfNkxTmTdxPOcrrTKXBNSe7/5Qf7IiwWeWG0dFkQpLqeLyGWDorTE1nbRkIvM6A4FzGM2yTNGe1HX1I7FcTQ4mDLB4sdcI+z3YblQnF7t9ahz/+IiQ+fBPl4
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 708944e6-25e4-4955-3c16-08d783ca4739
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:55:10.0828
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 7N4U0w7Rw3NBnFt9BBWy+cNoIizRiHyjNOoQbpPStA/HREtAfpvtzdUvAugihB8MpzRupCuo3zeheaL0Sp9LRQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3048
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Expand the comment at mlxsw_sp_qdisc_prio_graft() to make the problem that
this function is trying to handle clearer.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
---

Notes:
    v2 (internal):
    - s/coment/comment in the commit message.
   =20
    v1 (internal):
    - Expand the explanation with an explicit example.

 .../ethernet/mellanox/mlxsw/spectrum_qdisc.c  | 31 ++++++++++++++-----
 1 file changed, 24 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c b/drivers=
/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
index 68cc6737d45c..135fef6c54b1 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_qdisc.c
@@ -631,10 +631,30 @@ static struct mlxsw_sp_qdisc_ops mlxsw_sp_qdisc_ops_p=
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
+ * E.g. consider this sequence of operations:
+ *
+ *  # tc qdisc add dev swp1 root handle 1: prio
+ *  # tc qdisc add dev swp1 parent 1:3 handle 13: red limit 1000000 avpkt =
10000
+ *  RED: set bandwidth to 10Mbit
+ *  # tc qdisc link dev swp1 handle 13: parent 1:2
+ *
+ * At this point, both 1:2 and 1:3 have the same RED Qdisc instance as the=
ir
+ * child. But RED will still only claim that 1:3 is its parent. If it's re=
moved
+ * from that band, its only parent will be 1:2, but it will continue to cl=
aim
+ * that it is in fact 1:3.
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
@@ -644,9 +664,6 @@ mlxsw_sp_qdisc_prio_graft(struct mlxsw_sp_port *mlxsw_s=
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

