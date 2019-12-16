Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C7CD121070
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 18:05:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726694AbfLPRBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 12:01:47 -0500
Received: from mail-eopbgr10084.outbound.protection.outlook.com ([40.107.1.84]:35200
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725805AbfLPRBq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Dec 2019 12:01:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Cnj75Z7FwLcVvUcC85vYUzY1rjBgI560oO5HognOBvOgFvrusP3GksTp0YNzdIN30lDxcyafhZ1Ip25RDYHXYPW93h/vZRFcelZ/sgTnLCNKgVv/3EYnK5WjObtTMWPD0pnTYYhUlszQ/Ew8rr4fyFqMdTtT7spdbP/yTfv9RqXhrchxEzwtbbKEswxpgkyjgC4UjOEzUHTF3gf57tulqBq6gwJ82gBfYcFGakXTWLi0UFVuT5Jx3rKtlZbX95GFvp7sEzTtFSyoJLO6lHzm4cKU5frirGBzveEp/UR8BQDN4GWbVAqbs2XElBjwlJki2DC/tzI74SQbHP6rZyrHrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJezdWqp9nLNdOekwIN185NuqXoZlPqEi/LmdjBYlDA=;
 b=kpDTh3NlHXRkccjf+OfrCBqvcrg9cxkPBmn4SU3yIvGxB/rYOX61uxd/Xw6XJis9MSk/oujOmbIHh4DrHyQnP+fHS5JCw4JeWR+fWgAEszsAd0nLo0s6iDdiEhxKfpjpcS84ThWEF06lRtbqmH6iwrqlzL3Gjrinh7UUwPdph5XUYLa7vHMYnZMmcHSqHikoIXGi+qZMKZLqEJqw1YLtuDJyWSFz/qW/H/wrBoo08IC17/3r7zq5pJJ9NHx5RQfK9YfdDanJPMAxfu8BC97CysBKYi4YGtf8SLb90uIJGCpe4YFhnvrdfGx53XfYmp2brq1gJDNtRWTnGhRpJQjtKg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mJezdWqp9nLNdOekwIN185NuqXoZlPqEi/LmdjBYlDA=;
 b=BCDvY2ZIXQ8mXJs338ZtLnVsvGsGL7sTQZUNxYfXOaAMGDynPcCGG0hJbLXrR9ByTau166M3posMyxI1Zg9pQJGKMSROzlhUrFTe3GJaRpLcl+85e2QeWCE/yLTz/OF9wQqZU3Wmtty1htdWdEs0fmZpwtgNYd/Vefi2cPpuiOk=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3014.eurprd05.prod.outlook.com (10.172.248.136) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.16; Mon, 16 Dec 2019 17:01:42 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Mon, 16 Dec 2019
 17:01:42 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v1 02/10] mlxsw: spectrum_qdisc: Clarify a
 comment
Thread-Topic: [PATCH net-next mlxsw v1 02/10] mlxsw: spectrum_qdisc: Clarify a
 comment
Thread-Index: AQHVtDJ9d6Ln6WqlH0K7rL4Im38j2w==
Date:   Mon, 16 Dec 2019 17:01:42 +0000
Message-ID: <f7c7f5c56140583b7a772d029cdb80326f3b38ca.1576515562.git.petrm@mellanox.com>
References: <cover.1576515562.git.petrm@mellanox.com>
In-Reply-To: <cover.1576515562.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: PR0P264CA0027.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:100:1::15) To DB6PR0502MB3047.eurprd05.prod.outlook.com
 (2603:10a6:4:9f::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: a8d91c86-1230-4570-c323-08d782499f8c
x-ms-traffictypediagnostic: DB6PR0502MB3014:|DB6PR0502MB3014:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB3014CFEE4C0DDB98681FCD58DB510@DB6PR0502MB3014.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02530BD3AA
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(39860400002)(346002)(376002)(189003)(199004)(186003)(6512007)(26005)(316002)(107886003)(71200400001)(6486002)(81166006)(6506007)(81156014)(8676002)(8936002)(66556008)(66476007)(66446008)(64756008)(66946007)(2906002)(478600001)(54906003)(6916009)(2616005)(86362001)(36756003)(52116002)(4326008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3014;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: joi4NjC9hxMfoSKMDD8FfA5ZO/Hdfwt66Qo8ry8tVXZjacBxt1kNphPaZjl1sMMPotVrOvM5lSnUTqU4zA+JQig67NEvsSFIBJZIK38XXaz9m8nmXKQ4ZUa5NY6pfISiet08+bjawqcRAysqKqCAz1DoYlcuoxS2OJHHF1BzIgUQrVwB2o9gQIPLtYupJouuCgDiYz/g7MkWhQDBgltb3hDFGntXnVZeKwqP7z4sZZRmary8xqeQ19KTzJ0hWoetZq4UsDL3wjjXbN5+68umcGHsy0TbX7RJFisrAVa72FT7T56yc6jjThN7wx/yMYiANO0La4kZTsTHFhlrSNuq0lZt19delOaN87to1nRM2uuBk5KEeWNdmJuH3R/gDqBMSqO4HsFD/GwlelnO9yNv9UVTyJ4eKeiXmOAAuxmihv5niZ7RRz5kZixUP3sd1mTi
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a8d91c86-1230-4570-c323-08d782499f8c
X-MS-Exchange-CrossTenant-originalarrivaltime: 16 Dec 2019 17:01:42.0568
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: w/E0osuKxyCHxwxkzjmlA1QYClpoxEIOuQenaOMpTWh1llmiBlgWmQL2qYTRvtJI/PWkldwb6lHSlKQDw2KQ1g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3014
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

