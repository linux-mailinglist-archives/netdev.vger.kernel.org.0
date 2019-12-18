Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 045BC124902
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbfLROFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:05:21 -0500
Received: from mail-eopbgr140057.outbound.protection.outlook.com ([40.107.14.57]:64466
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726856AbfLROFU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:05:20 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=R3H6ZLUFp0o/kCv/SHpdPqWq6H0dgPlxNO3f2sz+UcAye8hoaxgMF5qxGMq11Jl+Fqm+wKmlOwWp7RLbJWG6OoywofLhZUEPrp4OxIAYmTEIOz1Kyu0rZZjaBrVdkFCix2zWqMRoTIZnj6UUKXlZl1aqYPtsb1ixe4fJO0gt06vjyC3rid6ZOjR5eJt8LVVQd4aqzP3Xgbiw69bLFD8weJWtRXoAk4dwnaS7FZ2UAroEkzrrCjLq2ybumQ1swGDZxZyG501d/NFUN64OFGxmQzVT4cXHIkhnOQgaNS+6yv3HI6sCQcsFHtc3e8//dUBv38ZRhCZ+qc7hGSjSnEE2zg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5R1rxzzYiSbRNI8mY55S0xSHIAupGCauvCAChUqVs0=;
 b=FP3aDmkMtuhvPqYarYshTpnu9WIuf0Vs+lxSB3tpqH0kkbJk0k+czg6wqtyniD6REa0uEuwepYNM7I9WcwpvCRbWy+jtVsoFinf0eWke4WgYYbQhQC7NWB2H659slUok2B5b1CUmORApSrlJNOJvng59mSGoU2O7FpcBASGPTsVx5YX607EcqrSY5HP3ghBP9h+rcqt8OmDUCIdeeY7qrJ08ry5VQqqW6CBSDCDXz2glNfQi2kC0BH738Yl1L7wybOBJHCGLNFc4v9kVNEiU0y7IC+f961PIP435bX6TLdpgeivf+2c/yMc6fPznSgLWPK4jwdyK12ohhHVCx/vVUQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=darbyshire-bryant.me.uk; dmarc=pass action=none
 header.from=darbyshire-bryant.me.uk; dkim=pass
 header.d=darbyshire-bryant.me.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y5R1rxzzYiSbRNI8mY55S0xSHIAupGCauvCAChUqVs0=;
 b=F2jn97azVggV7PmuqiRTu7lVtZyGjiRaJt4e6flCLslCH7ZQ2ezx69hWnV1fz2Nu7Q2hmCCYwDsLNNmaUFUp0X2Mw0jX9OP+cKt5RmdlffnV0Ht9ukpgRYyxqh8eFBoqY0bRVZ0XiMKFO7086VZsp9BHi52Mhtm1UCKXkY2zdOQ=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB3358.eurprd03.prod.outlook.com (52.134.13.25) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Wed, 18 Dec 2019 14:05:13 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:05:13 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH net-next v2] sch_cake: drop unused variable tin_quantum_prio
Thread-Topic: [PATCH net-next v2] sch_cake: drop unused variable
 tin_quantum_prio
Thread-Index: AQHVtawqU01I35ZFf0y7jA/tdJ+eDA==
Date:   Wed, 18 Dec 2019 14:05:13 +0000
Message-ID: <20191218140459.24992-1-ldir@darbyshire-bryant.me.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0061.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::25) To VI1PR0302MB2750.eurprd03.prod.outlook.com
 (2603:10a6:800:e3::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0 (Apple Git-122.2)
x-originating-ip: [2a02:c7f:1243:8e00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: da47056b-1d82-43e8-7d14-08d783c34d20
x-ms-traffictypediagnostic: VI1PR0302MB3358:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0302MB33580477E3A75F47D4B05902C9530@VI1PR0302MB3358.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(376002)(366004)(396003)(346002)(39830400003)(136003)(199004)(189003)(36756003)(8676002)(81166006)(86362001)(81156014)(6916009)(508600001)(316002)(52116002)(6486002)(107886003)(66446008)(64756008)(66946007)(66556008)(2906002)(66476007)(186003)(6512007)(71200400001)(8936002)(6506007)(5660300002)(1076003)(4326008)(2616005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB3358;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: n+4Dr6HKPFKkcvv1SJrRCCPzscdlvAo/KObjCots+rkRLHCT/TMvm2dH4kVtW00ho2oI86a2kzxJ2RBciAjmioQYOhpqpmZhfQbeqvpqcjz8mBp3TzMuVOn3p48uDSOpgl+DoTndq6v7hSO9nbS4W3Y4+w5v1/z2sCW0JuvrfsKZWhMmVPaKm94kakcNT10Cx+wzGxaM4PAil9XU/Bbkeq9PBOwqM3z48nBzskXaX7ELNew5QVbHZXND5sOP4ADayqpJ3T1UiaWUjw0Xli73ZFSQKVX9V5t0TRBcEaDJRBAOVlHmObTvx+pgelx6qAJlrSFt+75RPOKUH/pBrJFkHyJAB52PUMFAhUnDsUvejIl1F/9KCxsbT4o/g+rE53Gl3+aapfKulZFEpuw/2trn/69W6MCgze//9WoM2xjq9Puvq5oUh2kwMa2n4tg/8hSr
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: da47056b-1d82-43e8-7d14-08d783c34d20
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:05:13.5409
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: hG6ZHJcaHpm5oNMwewNlm9T4SXO2RXr+k+9AYRzsgktCbxoJidsuDK8VrAdLxhwFhu0C4csnXoXzKVxjXT4y8jbERKs3yWl+bthAoNZEb8Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB3358
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turns out tin_quantum_prio isn't used anymore and is a leftover from a
previous implementation of diffserv tins.  Since the variable isn't used
in any calculations it can be eliminated.

Drop variable and places where it was set.  Rename remaining variable
and consolidate naming of intermediate variables that set it.

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
---
v2 - rename intermediate 'quantum1' variables to just 'quantum' since
there's only one of them left now.  Also rename remaining
tin_quantum_band to tin_quantum since there's now only 1 type of
quantum.

Please drop the v1 patch

 net/sched/sch_cake.c | 59 ++++++++++++++------------------------------
 1 file changed, 18 insertions(+), 41 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 53a80bc6b13a..9ce85b97169c 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -173,8 +173,7 @@ struct cake_tin_data {
 	u64	tin_rate_bps;
 	u16	tin_rate_shft;
=20
-	u16	tin_quantum_prio;
-	u16	tin_quantum_band;
+	u16	tin_quantum;
 	s32	tin_deficit;
 	u32	tin_backlog;
 	u32	tin_dropped;
@@ -1919,7 +1918,7 @@ static struct sk_buff *cake_dequeue(struct Qdisc *sch=
)
 		while (b->tin_deficit < 0 ||
 		       !(b->sparse_flow_count + b->bulk_flow_count)) {
 			if (b->tin_deficit <=3D 0)
-				b->tin_deficit +=3D b->tin_quantum_band;
+				b->tin_deficit +=3D b->tin_quantum;
 			if (b->sparse_flow_count + b->bulk_flow_count)
 				empty =3D false;
=20
@@ -2240,8 +2239,7 @@ static int cake_config_besteffort(struct Qdisc *sch)
=20
 	cake_set_rate(b, rate, mtu,
 		      us_to_ns(q->target), us_to_ns(q->interval));
-	b->tin_quantum_band =3D 65535;
-	b->tin_quantum_prio =3D 65535;
+	b->tin_quantum =3D 65535;
=20
 	return 0;
 }
@@ -2252,8 +2250,7 @@ static int cake_config_precedence(struct Qdisc *sch)
 	struct cake_sched_data *q =3D qdisc_priv(sch);
 	u32 mtu =3D psched_mtu(qdisc_dev(sch));
 	u64 rate =3D q->rate_bps;
-	u32 quantum1 =3D 256;
-	u32 quantum2 =3D 256;
+	u32 quantum =3D 256;
 	u32 i;
=20
 	q->tin_cnt =3D 8;
@@ -2266,18 +2263,14 @@ static int cake_config_precedence(struct Qdisc *sch=
)
 		cake_set_rate(b, rate, mtu, us_to_ns(q->target),
 			      us_to_ns(q->interval));
=20
-		b->tin_quantum_prio =3D max_t(u16, 1U, quantum1);
-		b->tin_quantum_band =3D max_t(u16, 1U, quantum2);
+		b->tin_quantum =3D max_t(u16, 1U, quantum);
=20
 		/* calculate next class's parameters */
 		rate  *=3D 7;
 		rate >>=3D 3;
=20
-		quantum1  *=3D 3;
-		quantum1 >>=3D 1;
-
-		quantum2  *=3D 7;
-		quantum2 >>=3D 3;
+		quantum  *=3D 7;
+		quantum >>=3D 3;
 	}
=20
 	return 0;
@@ -2346,8 +2339,7 @@ static int cake_config_diffserv8(struct Qdisc *sch)
 	struct cake_sched_data *q =3D qdisc_priv(sch);
 	u32 mtu =3D psched_mtu(qdisc_dev(sch));
 	u64 rate =3D q->rate_bps;
-	u32 quantum1 =3D 256;
-	u32 quantum2 =3D 256;
+	u32 quantum =3D 256;
 	u32 i;
=20
 	q->tin_cnt =3D 8;
@@ -2363,18 +2355,14 @@ static int cake_config_diffserv8(struct Qdisc *sch)
 		cake_set_rate(b, rate, mtu, us_to_ns(q->target),
 			      us_to_ns(q->interval));
=20
-		b->tin_quantum_prio =3D max_t(u16, 1U, quantum1);
-		b->tin_quantum_band =3D max_t(u16, 1U, quantum2);
+		b->tin_quantum =3D max_t(u16, 1U, quantum);
=20
 		/* calculate next class's parameters */
 		rate  *=3D 7;
 		rate >>=3D 3;
=20
-		quantum1  *=3D 3;
-		quantum1 >>=3D 1;
-
-		quantum2  *=3D 7;
-		quantum2 >>=3D 3;
+		quantum  *=3D 7;
+		quantum >>=3D 3;
 	}
=20
 	return 0;
@@ -2413,17 +2401,11 @@ static int cake_config_diffserv4(struct Qdisc *sch)
 	cake_set_rate(&q->tins[3], rate >> 2, mtu,
 		      us_to_ns(q->target), us_to_ns(q->interval));
=20
-	/* priority weights */
-	q->tins[0].tin_quantum_prio =3D quantum;
-	q->tins[1].tin_quantum_prio =3D quantum >> 4;
-	q->tins[2].tin_quantum_prio =3D quantum << 2;
-	q->tins[3].tin_quantum_prio =3D quantum << 4;
-
 	/* bandwidth-sharing weights */
-	q->tins[0].tin_quantum_band =3D quantum;
-	q->tins[1].tin_quantum_band =3D quantum >> 4;
-	q->tins[2].tin_quantum_band =3D quantum >> 1;
-	q->tins[3].tin_quantum_band =3D quantum >> 2;
+	q->tins[0].tin_quantum =3D quantum;
+	q->tins[1].tin_quantum =3D quantum >> 4;
+	q->tins[2].tin_quantum =3D quantum >> 1;
+	q->tins[3].tin_quantum =3D quantum >> 2;
=20
 	return 0;
 }
@@ -2454,15 +2436,10 @@ static int cake_config_diffserv3(struct Qdisc *sch)
 	cake_set_rate(&q->tins[2], rate >> 2, mtu,
 		      us_to_ns(q->target), us_to_ns(q->interval));
=20
-	/* priority weights */
-	q->tins[0].tin_quantum_prio =3D quantum;
-	q->tins[1].tin_quantum_prio =3D quantum >> 4;
-	q->tins[2].tin_quantum_prio =3D quantum << 4;
-
 	/* bandwidth-sharing weights */
-	q->tins[0].tin_quantum_band =3D quantum;
-	q->tins[1].tin_quantum_band =3D quantum >> 4;
-	q->tins[2].tin_quantum_band =3D quantum >> 2;
+	q->tins[0].tin_quantum =3D quantum;
+	q->tins[1].tin_quantum =3D quantum >> 4;
+	q->tins[2].tin_quantum =3D quantum >> 2;
=20
 	return 0;
 }
--=20
2.21.0 (Apple Git-122.2)

