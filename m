Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A088E103AA7
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 14:05:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728786AbfKTNFV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 08:05:21 -0500
Received: from mail-eopbgr130051.outbound.protection.outlook.com ([40.107.13.51]:19220
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728683AbfKTNFT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 08:05:19 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XkPCGazcGlwB+FuuJlOwv0rPhLlRT7X4Ffvi99fPSq+I9DSW0xD+qFYLrd7G9CIiHzT7oQB6DcHhUJ+LPdJSqPdfme/q5y6J4GvelZtHzQUe+0E+w2aeHNZZeO7pYomEcgloLM7hLYv/sInU8AOXb17092lo5KuagzGdfZgQcJBx4ejeZyjGSnKUGlCm32fzOVw+F6V3XcoeS/I8O8wez7trWCG29DHWp+viamEBXZ5Ya90glg2J7iTvA2/l5BtiyK8PiXY9dw9TJsCpVlcLzATSTQwihFEEJoBVtTEllQtrc5LWPjRs0Rnz4LIpfxSZmgH77jUBC9NBmn83EOeWaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JOKRb3yr5ujAQFjNbh5plIrbSokZZhJSWy+3YXVU6w=;
 b=adAf8FsdoRc8ye217SW0/474nBAMXCOf8gTaY8O0k7tNlsLF/QWGYlTOlqtvoFWkpXFI5FhoFn+gnsaU/ime6CCZPH+jgu9nprAj/yZVoas5x/jVJYuRpsb4OFUpcv5UovkI1cro/wUxfzDJgphpV05V7mHzF1LOq0tI169qJN9GDUVDQdV6+MUujuw0yN+q/QYhdYL3TcUh40Wcm5mCJ5tEjwURY+cM7bbT8Y6I63Qre8TzBu4MNPsJRBPVw7WoU2dyLlmHtr/kLef5A14dJ+a1XQkiwMqKczLhreuuqDsn0dGmJeqDZ4SnbJfrUrAnNY7+DRqVvwsB7qlrjeH1zg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5JOKRb3yr5ujAQFjNbh5plIrbSokZZhJSWy+3YXVU6w=;
 b=mGNKFLucacQ1FSdz8drdtywg6mJd+ZJtOHfvvaEM21H4Z7lg09+Pg14BEIkc4ha/OyJRo3KyGla3rUeJI4eOYacK5VRpJiOhY/7nbKpRcRe8hPRM5LNw6FmUZWOkdJNx4K5TQZBD8sZycoUzThA5I9yMscwTx49liRnPfYR77vw=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB2982.eurprd05.prod.outlook.com (10.172.246.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2451.29; Wed, 20 Nov 2019 13:05:10 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::24d5:3eb9:d96b:c521%7]) with mapi id 15.20.2451.029; Wed, 20 Nov 2019
 13:05:10 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Subject: [RFC PATCH 01/10] net: pkt_cls: Clarify a comment
Thread-Topic: [RFC PATCH 01/10] net: pkt_cls: Clarify a comment
Thread-Index: AQHVn6Mj+SJi3CoK+Em/2KIDs+LAbA==
Date:   Wed, 20 Nov 2019 13:05:09 +0000
Message-ID: <6292bbe365be8a914b25f4559be5c8e5fa72a2a2.1574253236.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: 2d8e97ac-ae82-403f-e470-08d76dba458e
x-ms-traffictypediagnostic: DB6PR0502MB2982:|DB6PR0502MB2982:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB298296B44E91C37DDD8521B0DB4F0@DB6PR0502MB2982.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(396003)(366004)(376002)(39860400002)(346002)(189003)(199004)(102836004)(1730700003)(6436002)(2616005)(446003)(50226002)(81156014)(81166006)(478600001)(66556008)(8936002)(66476007)(66946007)(14454004)(5640700003)(6506007)(2906002)(386003)(36756003)(66446008)(66066001)(8676002)(6486002)(26005)(186003)(54906003)(7736002)(316002)(6512007)(305945005)(76176011)(71190400001)(71200400001)(2351001)(256004)(64756008)(2501003)(52116002)(86362001)(14444005)(486006)(6116002)(11346002)(3846002)(5660300002)(25786009)(99286004)(476003)(6916009)(4744005)(4326008)(118296001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB2982;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: F4dOK9RAF9gvMwNLhnzWHanZWFur1rw4w7w5K70wzsHfuoLWolGAlOiCKGJXVETpuP+ZjrpGlJK039rH+/0Bks3uS64bku7nVRoXZEYJUJSA4byiFQjuJErFjswgIQOLWwTpPLRH+ELpipFssAMLROVB3MXJC3MaGgk3BshoMaVF2y1jn1WD22wcnmV7ccanQraLLC9F2gBmQPiSaLTwvqZIh09zkA54gehDjVHz6RZp61hLosauQR1wk7pSDcQhi+09c27n/1RdvZaW4iAioPeKF+BfazsDfkv2Y0Oz9wSPlRZ734+yjMKPnDRRK3mn0zfMvENYsK2E0pFSecxif3b2GgpGQFgIB0xGESIt+E9y71gJUR7Fdsj3hsqK3RAoZQxySx3uu+RKhahyiqpZ415LI4aeHYRLQmuNKb24vaLGHL2oihBuKOjtzSjrAsMd
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2d8e97ac-ae82-403f-e470-08d76dba458e
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 13:05:09.9139
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: macgoKOYm1WSfAThMqCU90SL8TtVX58zc0tSmw8g6tW/nMxmvlajaWgTU6P9xHtLzjLB/ZRklsDh9BWmWubudg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB2982
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bit about negating HW backlog left me scratching my head. Clarify the
comment.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 include/net/pkt_cls.h | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/include/net/pkt_cls.h b/include/net/pkt_cls.h
index e553fc80eb23..a7c5d492bc04 100644
--- a/include/net/pkt_cls.h
+++ b/include/net/pkt_cls.h
@@ -791,9 +791,8 @@ enum tc_prio_command {
 struct tc_prio_qopt_offload_params {
 	int bands;
 	u8 priomap[TC_PRIO_MAX + 1];
-	/* In case that a prio qdisc is offloaded and now is changed to a
-	 * non-offloadedable config, it needs to update the backlog & qlen
-	 * values to negate the HW backlog & qlen values (and only them).
+	/* At the point of un-offloading the Qdisc, the reported backlog and
+	 * qlen need to be reduced by the portion that is in HW.
 	 */
 	struct gnet_stats_queue *qstats;
 };
--=20
2.20.1

