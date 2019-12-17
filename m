Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id ABB421238D1
	for <lists+netdev@lfdr.de>; Tue, 17 Dec 2019 22:47:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726920AbfLQVrG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 16:47:06 -0500
Received: from mail-eopbgr30057.outbound.protection.outlook.com ([40.107.3.57]:52469
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726874AbfLQVrG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Dec 2019 16:47:06 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=npg/06OkW9mu77qxHcYZqX6CyOjoTul1I01OPCI6WeEVfLk476+qgN44eveXdG8PzXwDIygdLuuBRttDPaB1o2SlQjZvBD4TlNBU5IfozPmJIvaRpHzwHldxHLbXFcmZJhu9Up8tK1SAv5cu0quuGjBLD2+mO6/amRuHYsGRlaKPqdW3mhGlZewvMNAGTftfr4IWfQWghijco7qnxsDQ5ZHhh8WaeVvQ/poHdT/ajHCt6KMm6FcqiIBMnocv7ohhfM7fhAc4ZcE6OTfmzmsnf1pi9Z+ZAZ9Y6z7MBn9TWsvHhTJuk+0sBtuFmBdmDnzRxg2miLOrf6DLKq41t+mTcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCV1Cfgi+ZdNBex6OwsxjDEJJXoLWKn2yePNb8YKjV8=;
 b=G54WZwfSaeo9ZW3aE7NwB/RwX43y0F6LlHSgisDIMokw+8Qga++AUXGHLimjObXQhLPIqy58hu5eBqrPdAgbRxrJghOR2aSFpiWXcjOwlXJYjRSyX5RjjVL9mPxoZ8iRWr1lEHC4WvpfKTY4kCd8GPSy6nbkK2uzYoKKGsFwsFc67UiN7Z1V385altHYZPDWEHJcPZMJtRzkz4l60KC3ng8w+k6sQg5nt8I6dJTS8+6kIo/xBQPDOTuLk5fGDoKg9+rNsOBqPeggDZzlRODmQP6yjvNUIxQb5ghHUutafx+LirHDwLU4r+iwGAFEWUwNN8Mm7IUOWYU/Y0s4ihpPJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=darbyshire-bryant.me.uk; dmarc=pass action=none
 header.from=darbyshire-bryant.me.uk; dkim=pass
 header.d=darbyshire-bryant.me.uk; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=darbyshire-bryant.me.uk; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=gCV1Cfgi+ZdNBex6OwsxjDEJJXoLWKn2yePNb8YKjV8=;
 b=I6kHwa8wpJAq0n1fScLrvRz1nYgaPhKjc7c8f63MMaGgs0xM0df4+M0h8IuBSOgLBetMldUDxUQs5govgPza2IG4x6q3aGhKQ2+ScjeMISL/QZiRhV+8zMoJnbjaGPKSFH5DkRl4q+jmJ4GwZsjKOayhl0uEqJQgQz3eJDqdjN4=
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com (10.171.106.21) by
 VI1PR0302MB2605.eurprd03.prod.outlook.com (10.171.105.15) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.14; Tue, 17 Dec 2019 21:46:22 +0000
Received: from VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46]) by VI1PR0302MB2750.eurprd03.prod.outlook.com
 ([fe80::7585:5ab6:a348:de46%7]) with mapi id 15.20.2538.019; Tue, 17 Dec 2019
 21:46:22 +0000
From:   Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Kevin 'ldir' Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
Subject: [PATCH net-next v1] sch_cake: drop unused variable tin_quantum_prio
Thread-Topic: [PATCH net-next v1] sch_cake: drop unused variable
 tin_quantum_prio
Thread-Index: AQHVtSNsBibxs87QfEiHtLubJ3YVBg==
Date:   Tue, 17 Dec 2019 21:46:21 +0000
Message-ID: <20191217214554.27435-1-ldir@darbyshire-bryant.me.uk>
Accept-Language: en-GB, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-clientproxiedby: LO2P123CA0058.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1::22) To VI1PR0302MB2750.eurprd03.prod.outlook.com
 (2603:10a6:800:e3::21)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ldir@darbyshire-bryant.me.uk; 
x-ms-exchange-messagesentrepresentingtype: 1
x-mailer: git-send-email 2.21.0 (Apple Git-122.2)
x-originating-ip: [2a02:c7f:1243:8e00::dc83]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: aa18b974-9b53-436e-9157-08d7833a8e78
x-ms-traffictypediagnostic: VI1PR0302MB2605:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR0302MB2605C4FD06C23A1735B98001C9500@VI1PR0302MB2605.eurprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:5236;
x-forefront-prvs: 02543CD7CD
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(136003)(39830400003)(346002)(396003)(366004)(376002)(189003)(199004)(2616005)(66946007)(66476007)(66556008)(2906002)(186003)(66446008)(64756008)(6486002)(107886003)(4326008)(71200400001)(6512007)(8936002)(52116002)(6506007)(1076003)(5660300002)(6916009)(86362001)(81156014)(81166006)(508600001)(8676002)(316002)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0302MB2605;H:VI1PR0302MB2750.eurprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: darbyshire-bryant.me.uk does not
 designate permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: OriAy52UREnM8ZIz44X5mpa0VyfSm6GKGaqgdtCm/dUkzJE+84hxa2OAik/eDDjoFxJcPiELCBQm59EnIXqIZv2QNyMxKE5O0n58VjuKE0OeUuYhBHWEIAiGO8cm7g5Y7GZA+CixOECBk1y73Bn4CywqWge4glajW6pgv+YDOOes2fA3IsPKiwE5hv7LOHvRyBtAqkg4UGs6Dw/1JX9sCMXCQVEltEuuKdNyfCtHsVwfuOsql5QLV7TBe4aVt5e7QAmJtirKdU/dti89CEECATqxdOSG8aE1f5IqX0QNeAp1eP0enje8kf6ROwGMqnnH7IwAY3A4y4oqaprEsHz4xbE/10/ff6TObZafgUrv/S01noZI2PY9KtDhpchOlCSaMdEGInY1ci6evKpm0pp6TH26Siso/kNI55wGXi7pw3SGl5aJVFM8qMGD5fRmMHTB
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: darbyshire-bryant.me.uk
X-MS-Exchange-CrossTenant-Network-Message-Id: aa18b974-9b53-436e-9157-08d7833a8e78
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Dec 2019 21:46:22.0101
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9151708b-c553-406f-8e56-694f435154a4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: Uxpp3+ydoa1gPb2mAbuY68HVgsIq/3hdTJ9QMhtvXGk60eewcMinLDIpc84J6irKa3Gla85107onUDGyxXrhq78i0OsR7lWlj4zCVMu39kc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0302MB2605
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Turns out tin_quantum_prio isn't used anymore and is a leftover from a
previous implementation of diffserv tins.  Since the variable isn't used
in any calculations it can be eliminated.

Drop variable and places where it was set.

Signed-off-by: Kevin Darbyshire-Bryant <ldir@darbyshire-bryant.me.uk>
---
 net/sched/sch_cake.c | 35 ++++++-----------------------------
 1 file changed, 6 insertions(+), 29 deletions(-)

diff --git a/net/sched/sch_cake.c b/net/sched/sch_cake.c
index 53a80bc6b13a..170320932d10 100644
--- a/net/sched/sch_cake.c
+++ b/net/sched/sch_cake.c
@@ -173,7 +173,6 @@ struct cake_tin_data {
 	u64	tin_rate_bps;
 	u16	tin_rate_shft;
=20
-	u16	tin_quantum_prio;
 	u16	tin_quantum_band;
 	s32	tin_deficit;
 	u32	tin_backlog;
@@ -2241,7 +2240,6 @@ static int cake_config_besteffort(struct Qdisc *sch)
 	cake_set_rate(b, rate, mtu,
 		      us_to_ns(q->target), us_to_ns(q->interval));
 	b->tin_quantum_band =3D 65535;
-	b->tin_quantum_prio =3D 65535;
=20
 	return 0;
 }
@@ -2253,7 +2251,6 @@ static int cake_config_precedence(struct Qdisc *sch)
 	u32 mtu =3D psched_mtu(qdisc_dev(sch));
 	u64 rate =3D q->rate_bps;
 	u32 quantum1 =3D 256;
-	u32 quantum2 =3D 256;
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
+		b->tin_quantum_band =3D max_t(u16, 1U, quantum1);
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
+		quantum1  *=3D 7;
+		quantum1 >>=3D 3;
 	}
=20
 	return 0;
@@ -2347,7 +2340,6 @@ static int cake_config_diffserv8(struct Qdisc *sch)
 	u32 mtu =3D psched_mtu(qdisc_dev(sch));
 	u64 rate =3D q->rate_bps;
 	u32 quantum1 =3D 256;
-	u32 quantum2 =3D 256;
 	u32 i;
=20
 	q->tin_cnt =3D 8;
@@ -2363,18 +2355,14 @@ static int cake_config_diffserv8(struct Qdisc *sch)
 		cake_set_rate(b, rate, mtu, us_to_ns(q->target),
 			      us_to_ns(q->interval));
=20
-		b->tin_quantum_prio =3D max_t(u16, 1U, quantum1);
-		b->tin_quantum_band =3D max_t(u16, 1U, quantum2);
+		b->tin_quantum_band =3D max_t(u16, 1U, quantum1);
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
+		quantum1  *=3D 7;
+		quantum1 >>=3D 3;
 	}
=20
 	return 0;
@@ -2413,12 +2401,6 @@ static int cake_config_diffserv4(struct Qdisc *sch)
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
 	q->tins[0].tin_quantum_band =3D quantum;
 	q->tins[1].tin_quantum_band =3D quantum >> 4;
@@ -2454,11 +2436,6 @@ static int cake_config_diffserv3(struct Qdisc *sch)
 	cake_set_rate(&q->tins[2], rate >> 2, mtu,
 		      us_to_ns(q->target), us_to_ns(q->interval));
=20
-	/* priority weights */
-	q->tins[0].tin_quantum_prio =3D quantum;
-	q->tins[1].tin_quantum_prio =3D quantum >> 4;
-	q->tins[2].tin_quantum_prio =3D quantum << 4;
-
 	/* bandwidth-sharing weights */
 	q->tins[0].tin_quantum_band =3D quantum;
 	q->tins[1].tin_quantum_band =3D quantum >> 4;
--=20
2.21.0 (Apple Git-122.2)

