Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 855377BE6B
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 12:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387700AbfGaKa3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 06:30:29 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:50805
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S2387399AbfGaKa3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Jul 2019 06:30:29 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=j6uEhqDQGSDspq6A+eI9LazuKx9RqurY3uTh/weMWK8Jdux+pkPIXT9J0caDbEMGa1ez2pF0148A5Iu5IazmN8WIuYiPRsFi3QB5NTLrit7amDQWt3nqh2hSApq4rClHI5eP1f3cQYeKZTtI6/64AqaUSz/Rgt9JmxLxCQUXHJYdMsj46e2lAtZiElMku2GzW0YFANMLsPZrJ0PBhXPFAHzWBEq2+zw3q/4qAadl2yb0wxvDMKoRbRXb93+O3vFjQUOePEOO2zoe+4SbksZ1KzIDLd3mmgNVsA3kStd6tCljaCgkW3ZlTJ1R6S9StuniiD2u6DVG6qXqsvUSccK7rw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+Sqw/p543kcLVKVtk+8SWlds/k0YBQSy8z3xYhfx1A=;
 b=K6IQgqk7xXuFmSpzM+92rCHtA5nDxxQNExiNWa07Jpa4mW25N+jB7jHItgmhsPm2MpJ+AZJgxnp7lkHWf+B/FX/vBHw4jgY5B3L5jV8YLRdWutWnEbDw5CWFmdjyLdS2vY0Nd8sPGtc6/h4aWAAUMtYkOAmccjL7dzfOT9TfSklLbXxShfzcX0O2mBHVK7jOSDs91JdV8IxP/qHt2aFZeeapEQT9QSExw1pA7Foep8QqsOiIMti99jw7G8tYcuqrPaemnw0O5QKmyxKxUdFVGeyf1Rw9cih8ExzEknIZu5ASO3ZKIaoFBBU9YZy4HHaF1kcpZOskejRfcr4qheyXVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1;spf=pass
 smtp.mailfrom=mellanox.com;dmarc=pass action=none
 header.from=mellanox.com;dkim=pass header.d=mellanox.com;arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=O+Sqw/p543kcLVKVtk+8SWlds/k0YBQSy8z3xYhfx1A=;
 b=dKejrS7/wPFRFf26SXRA1UE4erYFQXGqX6oEAIZudhUG6ci0TDsa8gz3fjncwjX8LS0g1sHDOPG6lFEtseDGB7mm8AVzuWO9XHNf81JPhTQ6dUU/p1L1FqP6iR4C3/msjb/zy6ONOWIVgCIPVd/6rAvNnClKADLuwbhUy6BXQn4=
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com (20.179.10.157) by
 DB8PR05MB6603.eurprd05.prod.outlook.com (20.179.11.33) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2115.15; Wed, 31 Jul 2019 10:30:25 +0000
Received: from DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e]) by DB8PR05MB6044.eurprd05.prod.outlook.com
 ([fe80::1587:f8a7:2e31:c75e%3]) with mapi id 15.20.2115.005; Wed, 31 Jul 2019
 10:30:25 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Petr Machata <petrm@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH net-next 0/2] mlxsw: Test coverage for DSCP leftover fix
Thread-Topic: [PATCH net-next 0/2] mlxsw: Test coverage for DSCP leftover fix
Thread-Index: AQHVR4r3erUbPodIQk+/h6yonZWzIQ==
Date:   Wed, 31 Jul 2019 10:30:25 +0000
Message-ID: <cover.1564568595.git.petrm@mellanox.com>
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
x-ms-office365-filtering-correlation-id: f08121c0-021a-4b1e-8a5f-08d715a21983
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600148)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:DB8PR05MB6603;
x-ms-traffictypediagnostic: DB8PR05MB6603:
x-microsoft-antispam-prvs: <DB8PR05MB6603658CB05552C8681B331FDBDF0@DB8PR05MB6603.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6790;
x-forefront-prvs: 011579F31F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(199004)(189003)(6436002)(6486002)(86362001)(3846002)(8936002)(71190400001)(5660300002)(8676002)(107886003)(71200400001)(66066001)(2906002)(305945005)(54906003)(66574012)(14454004)(81156014)(81166006)(1730700003)(316002)(7736002)(6916009)(6116002)(36756003)(50226002)(99286004)(186003)(476003)(6512007)(6506007)(5640700003)(68736007)(486006)(2616005)(66556008)(478600001)(256004)(102836004)(52116002)(386003)(2501003)(53936002)(64756008)(66446008)(66476007)(66946007)(2351001)(4744005)(26005)(4326008)(25786009);DIR:OUT;SFP:1101;SCL:1;SRVR:DB8PR05MB6603;H:DB8PR05MB6044.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: m7MPlEI3AyGubCcxj1xnuuawY35WDpAH5mo1fxKLRVW5hZVj14HZCX+eyE7eFm6qEdIMF6MEJoSRStfW0VAuzsm+ghDZeAVkZ8/xogt6DeAQKI8npi2Pg/iw1tZ5hGhHLkAyV8DSl6oO6Ozhgq2Q/CbgVJ0ZbjvkuXJqYWoTxzJEGsaUcdA17Sr0aHgQig3anUmKBxm4yKSd1sW/czPWGFGvwKRJiSwtDjsw3rKQuIDEnLVeaFtbc1vdTZvAQmFPDRfeZF4JwcIoNShL0Xh2MN54DNBtx6fHTup8CI3xzJV0H74cHhRSvvICP9tDX5TFMI4w4JmRCRQrAsZUQfxF2XxD/QoENN9AyJzmFwRAIayBNCfvXgEp0+lBcM3uJLonPfakJtteuo6h5d3mW1pzI7EJ2MdtKCW5G3E9Y3f308Q=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f08121c0-021a-4b1e-8a5f-08d715a21983
X-MS-Exchange-CrossTenant-originalarrivaltime: 31 Jul 2019 10:30:25.5449
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: petrm@mellanox.com
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8PR05MB6603
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch set fixes some global scope pollution issues in the DSCP tests
(in patch #1), and then proceeds (in patch #2) to add a new test for
checking whether, after DSCP prioritization rules are removed from a port,
DSCP rewrites consistently to zero, instead of the last removed rule still
staying in effect.

Petr Machata (2):
  selftests: mlxsw: Fix local variable declarations in DSCP tests
  selftests: mlxsw: Add a test for leftover DSCP rule

 .../drivers/net/mlxsw/qos_dscp_bridge.sh      |  6 +++--
 .../drivers/net/mlxsw/qos_dscp_router.sh      | 24 +++++++++++++++++--
 2 files changed, 26 insertions(+), 4 deletions(-)

--=20
2.20.1

