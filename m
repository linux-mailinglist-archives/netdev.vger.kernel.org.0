Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53558124A6C
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 15:55:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727345AbfLROzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 09:55:15 -0500
Received: from mail-eopbgr40087.outbound.protection.outlook.com ([40.107.4.87]:28566
        "EHLO EUR03-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727120AbfLROzP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Dec 2019 09:55:15 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Izwbydp9wVXewuRIXz3VYq/0H9KFbxMra8UEJizVNAjimuvyzNKQfmU6nao70EH9u9kVK9fBBJ298Wa/q021Q4KdffGe3IpPrF6LiCsM8vvHUlDWWL713bYZ2UrfVc4aia2szh/dh/osCLXz8MHgF7LAbUC194+5MkR8tsJZ2NGy+hHyvFn+ELbkq1o6u3ZDLX/4R6bUiMxGOWLKrmINpEWwowsBNvukeJF9v0wVStNnwuD7W1whqI3vAT9dV0yGIGhng1f8pCGRF6N+oHnADoKIZ9z84jMl70ZuzdTmLt+bk56Kvf5cC8dXDSxcm25duiE/rEtoPeVtPGqO/dbu2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4r2Mho3Uq+QGj4+RoYiEhK5R1K/lk9BTT3G5nljch4c=;
 b=P+8bBQx8J/OT66mgA8pEIPMyXr1dpZn2y9Bk873p90M9jnIJxYHw1uC14Gd7/wQJ6bqXC35y1ykeF9LerGkhtg8c+rVptX1PPjPKo7370lMtE7HgTXkOwaiKe0ASQ1Zm52UUGCu4T+UPB+YUQ5QlLZstulLIlZjGfdQ3icOe1lq0qYWQCpzdlm7SaX5hfIssnzx02WctwOLV+OXhx2EYnzl8Q3FZDXdrlhSs+KOUuH0MbdmV40/Zvtgh3Imyk8YnV2SauAb74sZjbZkRXsmDjwzHXCkiy/qk5eUnPo6qeDGylZfdJw8ol8JNDgKklJMLoccOMZP9lIIeQrSeigAKuQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4r2Mho3Uq+QGj4+RoYiEhK5R1K/lk9BTT3G5nljch4c=;
 b=U1wIuP7ldz8rXoCRBtAWEKPbCrCtZ87YAVjMMS11yXBel8M12XiB+nAy6WRbzeRLGju/+es55Lcz6B+mzN/L46LRH79laaUz5ec2I/lnnrdSB0M3ZF32cMwYPC0bSOt3V05q+3a+3QgvPFc8AsD0/iKWm4bfsTwv3plhN59ws8U=
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com (10.172.250.135) by
 DB6PR0502MB3048.eurprd05.prod.outlook.com (10.172.250.7) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2538.18; Wed, 18 Dec 2019 14:55:08 +0000
Received: from DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1]) by DB6PR0502MB3047.eurprd05.prod.outlook.com
 ([fe80::a153:bb4e:c909:d3a1%7]) with mapi id 15.20.2538.019; Wed, 18 Dec 2019
 14:55:08 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Roman Mashak <mrv@mojatatu.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Jiri Pirko <jiri@resnulli.us>, Jiri Pirko <jiri@mellanox.com>
Subject: [PATCH net-next mlxsw v2 01/10] net: pkt_cls: Clarify a comment
Thread-Topic: [PATCH net-next mlxsw v2 01/10] net: pkt_cls: Clarify a comment
Thread-Index: AQHVtbMjnmQea5EhZ0W3wj+y0sKwDw==
Date:   Wed, 18 Dec 2019 14:55:08 +0000
Message-ID: <794a9c5627deba48cf9135fc0f24df66c1b90f73.1576679651.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: a810e0c9-12c3-496e-3cf3-08d783ca4626
x-ms-traffictypediagnostic: DB6PR0502MB3048:|DB6PR0502MB3048:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0502MB30487946D403C71868D43C48DB530@DB6PR0502MB3048.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2803;
x-forefront-prvs: 0255DF69B9
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(376002)(396003)(39860400002)(136003)(189003)(199004)(2906002)(478600001)(6512007)(8936002)(81166006)(4326008)(316002)(107886003)(8676002)(71200400001)(26005)(186003)(81156014)(86362001)(2616005)(6916009)(66946007)(66446008)(64756008)(66556008)(66476007)(36756003)(6486002)(5660300002)(4744005)(54906003)(52116002)(6506007);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0502MB3048;H:DB6PR0502MB3047.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 1XFc53S4KnVqJPG09YeahIVaZ9rp2CaHTPqb0hAEc92UJfveHpMPyFtJW7lACcozcwTYt1shzuTAKNLJhtltnBjMByLTOjtrN7VDpr5AmY4+zgBaVpdnjoxbF/SinwDeys1PPA0pj/N3/37tQUFvBVGo2IT4pETGtUyXxoPidxHDIp7Wo+kAAxFHvrN0NQWnNKP9n6MC88TzPA7CaFPhij8Ga4kPr9lcOsIQz80zcND+AZizaWVokgo1d+HKk5j9CnRL68oNvpmcYMgTrCGm0GZ3bzLH3A27sPrUXQgkmoL1UjEFkp8TafGHkjP+12mULQGoNjoniNI2K54LLtP0TOQxRZeCtQtyMetPKtQcwmNGtPu/4IQnj07o7aF186VgGl8Bpc7fFcNr+a8iySuNerKL2ZZSuojjH5k0ibn0rxdMU5eqCSVbgGyHzpVtuypE
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a810e0c9-12c3-496e-3cf3-08d783ca4626
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Dec 2019 14:55:08.3246
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: LnZNny3I3ULAz0dfqnUppPGirj+nLMUlLcX7KuC2riYqbgWP0ChYVRXsmYxHLDD7CwABEsow+36zyMR0KQ1jqQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0502MB3048
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The bit about negating HW backlog left me scratching my head. Clarify the
comment.

Signed-off-by: Petr Machata <petrm@mellanox.com>
Reviewed-by: Ido Schimmel <idosch@mellanox.com>
Acked-by: Jiri Pirko <jiri@mellanox.com>
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

