Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 282267BE6D
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 12:30:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387739AbfGaKad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 06:30:33 -0400
Received: from mail-eopbgr20058.outbound.protection.outlook.com ([40.107.2.58]:48969
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387671AbfGaKaa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 06:30:30 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=iKZKhyGpatZAwEu/Ww3JNtPVx1P8+gSWkPzyIl0dvkMloO8qBq1IuhzaNwcVAmLs1jVmwLFAKFWnQdn9aYGCjVH653DFRT51bGfMjhEcxUnckHSxYgb7c/WWxVsYdY3jp/FFqpqW2xxDYK12wsri14V05kOC3PG33+K5BH5CCl7pnP1nfdbhE6mmVt7fQiJHCeJyyyy6YWG/wtx6hiKaX+rHMRELPcOk8VL+/YaXclB1dCoDIGExJS/lsQ0qZ2XOwZsm38qR4nuOf6I9PAJTerFtkbK7sRtCbhCZF+0u2tRwNczjBr1zRwBIkstksVmGkStPG2uheE4WI/sGaAoM9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62XP5NMfZ0BjhU2uOrVWbhII6sugH0ch98h5szWTJgA=;
 b=EaG0ZLTcC6BtgKeKovyCyvzloFlu8OWAyj5NsWCw0HdDAyVKmCZVJrwaD6C9655ldBNdfBVv/GnDIh1A36xhGUd74tlinFCGfyBS06vTgz07g4oxqLpNpjOwbNZg3Bd8mNY0upZ6dNnaEvJz7iLfMGhCuCbsDIGrcLGsSUbqdMZ9qlwslyjU4lcdTJapGH4hldb72pBsbtU0mbb9F9TpaDT1IF1sn6FopmFlQee6JYiGY8l+oxly1ywrFyVkHDoq2JF4+kq2IJMsIi/JKPeyIKzotVS/uEgRQa+2Gw1CLYjQfVkyrx2sKV29PEIaaeZviB+rPSGVgkKJWsKTv9TjtA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=62XP5NMfZ0BjhU2uOrVWbhII6sugH0ch98h5szWTJgA=;
 b=fklu8cQWhKfYuCO/qEnWtLuwiaVlBChOa+ZUt5fMjIOyCPS09E9gSOSs4zAHZJcdjFl3cXRI9GenLC0LW+d6jA+iLbo97US82ITuQBa5SjKpyt7YVTwOb7ejF36/ai8AvRxq7LGedmosu1fpoiDhPs7n5fhfRX0QAQS5XgyAQcc=
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com (20.179.10.157) by
 DB8PR05MB5980.eurprd05.prod.outlook.com (20.179.10.86) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 10:30:26 +0000
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e]) by DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e%3]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 10:30:26 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 1/2] selftests: mlxsw: Fix local variable
 declarations in DSCP tests
Thread-Topic: [PATCH net-next 1/2] selftests: mlxsw: Fix local variable
 declarations in DSCP tests
Thread-Index: AQHVR4r3g620+ns76k+2ZJEtTZ/o0Q==
Date:   Wed, 31 Jul 2019 10:30:26 +0000
Message-ID: <4ac605020da39a6a6fe4f6aff5a2ed323e0a1378.1564568595.git.petrm@mellanox.com>
References: <cover.1564568595.git.petrm@mellanox.com>
In-Reply-To: <cover.1564568595.git.petrm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.20.1
x-clientproxiedby: LO2P265CA0132.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9f::24) To DB8PR05MB6044.eurprd05.prod.outlook.com
 (2603:10a6:10:aa::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-originating-ip: [37.142.13.130]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d3a9043-ae81-4f84-bed7-08d715a21a00
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600148)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB8PR05MB5980;
x-ms-traffictypediagnostic: DB8PR05MB5980:
x-microsoft-antispam-prvs: <DB8PR05MB59807B2F28D79296E4DE2DB1DBDF0@DB8PR05MB5980.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:126;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(189003)(199004)(6486002)(8676002)(1730700003)(52116002)(8936002)(102836004)(5660300002)(81166006)(81156014)(76176011)(66946007)(50226002)(53936002)(386003)(66574012)(256004)(3846002)(66556008)(86362001)(64756008)(66446008)(71190400001)(71200400001)(6436002)(66476007)(2906002)(99286004)(6506007)(6116002)(25786009)(6512007)(54906003)(5640700003)(7736002)(14444005)(68736007)(305945005)(486006)(316002)(2351001)(476003)(4326008)(118296001)(36756003)(2616005)(11346002)(478600001)(186003)(446003)(6916009)(14454004)(26005)(107886003)(2501003)(66066001);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB5980;H:DB8PR05MB6044.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: /1yjLIIa/WLHSECXLGX48/qSdoHu7o2kgx9skeyey7AyHDCryTBZmGbkI1uJkdf6yfrg+i32KnKWiKTwuqcqHuaKD+eaPCRIRaq/UNRp8Rd2PQCYpC7H9Durc7LCU8ioeCIuJk1gjzgDtFzMLbvq/OPCaqQc4dMv8hyUnNEq2slviI5C8Kpupp0TdPjFUNqMzUuoaSJpF6fy1jb0bS5rGiEaQDUTrGN2r94yTouX3PcDR37ZVFCZQVSLZ4uxI+y/4n35KgLYToeyI5ae41VXEb4CocQAmdl+w7v7GfoudZrZcnArXHY4Hvf7Y8rrPYZnegOPNz12/fwlITG5uUNFPry0DAQ8CfDpIH8l4t/bO+GfQfw+hdWszGGBO64csGsKmFuQVEjwQ1wW8zU2xLuWJHRw76WCNI9kTu3PcGuclts=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d3a9043-ae81-4f84-bed7-08d715a21a00
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 10:30:26.3355
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB5980
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

These two tests have some problems in the global scope pollution and on
contrary, contain unnecessary local declarations. Fix them.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 .../testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh  | 6 ++++--
 .../testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh  | 5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh b=
/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
index 40f16f2a3afd..5cbff8038f84 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_bridge.sh
@@ -36,8 +36,6 @@ source $lib_dir/lib.sh
=20
 h1_create()
 {
-	local dscp;
-
 	simple_if_init $h1 192.0.2.1/28
 	tc qdisc add dev $h1 clsact
 	dscp_capture_install $h1 10
@@ -67,6 +65,7 @@ h2_destroy()
 dscp_map()
 {
 	local base=3D$1; shift
+	local prio
=20
 	for prio in {0..7}; do
 		echo app=3D$prio,5,$((base + prio))
@@ -138,6 +137,7 @@ dscp_ping_test()
 	local prio=3D$1; shift
 	local dev_10=3D$1; shift
 	local dev_20=3D$1; shift
+	local key
=20
 	local dscp_10=3D$(((prio + 10) << 2))
 	local dscp_20=3D$(((prio + 20) << 2))
@@ -175,6 +175,8 @@ dscp_ping_test()
=20
 test_dscp()
 {
+	local prio
+
 	for prio in {0..7}; do
 		dscp_ping_test v$h1 192.0.2.1 192.0.2.2 $prio $h1 $h2
 	done
diff --git a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh b=
/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
index 9faf02e32627..f25e3229e1cc 100755
--- a/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
+++ b/tools/testing/selftests/drivers/net/mlxsw/qos_dscp_router.sh
@@ -52,8 +52,6 @@ reprioritize()
=20
 h1_create()
 {
-	local dscp;
-
 	simple_if_init $h1 192.0.2.1/28
 	tc qdisc add dev $h1 clsact
 	dscp_capture_install $h1 0
@@ -87,6 +85,7 @@ h2_destroy()
 dscp_map()
 {
 	local base=3D$1; shift
+	local prio
=20
 	for prio in {0..7}; do
 		echo app=3D$prio,5,$((base + prio))
@@ -156,6 +155,7 @@ dscp_ping_test()
 	local reprio=3D$1; shift
 	local dev1=3D$1; shift
 	local dev2=3D$1; shift
+	local i
=20
 	local prio2=3D$($reprio $prio)   # ICMP Request egress prio
 	local prio3=3D$($reprio $prio2)  # ICMP Response egress prio
@@ -205,6 +205,7 @@ __test_update()
 {
 	local update=3D$1; shift
 	local reprio=3D$1; shift
+	local prio
=20
 	sysctl_restore net.ipv4.ip_forward_update_priority
 	sysctl_set net.ipv4.ip_forward_update_priority $update
--=20
2.20.1

