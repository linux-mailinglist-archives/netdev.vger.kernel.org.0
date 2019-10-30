Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0E218EA3E1
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:14:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfJ3TOu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:14:50 -0400
Received: from mail-eopbgr20060.outbound.protection.outlook.com ([40.107.2.60]:50339
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726259AbfJ3TOu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 15:14:50 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hQusqYOLW/atG6MRzx43KtjW+ksESpTuoHTjmYZ2Hxli8xVqWlLlOCMZ+A6JFWQZkM4U6bSyYycOADhDgIDdBy6HBuhDSBJIFzDvUdEFF4K9VSrcjlYbj9ZZtDCyNPZoY4RLd+PbfKag5GSY3XWdyG84qACDOtP6Gk2rgv6/a6JulpD1W3kWIpYfElHGpUmcnVYh8qQ6PpcluLjDwafGzRRsy4CSVfXD5rexWfuyGnocw6sGkHu5XmPExfPxO4US0Qj57dVLjRODHldNaC0wGOIIq9cD5COKLtmz92RdV6lp7lCRwMR5rmGr0x5TRFEbDH8L5nsjFpVoDTJmRXFxig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WumTBpjOu5Gr9XJn6eLmdM60poEhWajZkuaVoKJP50Q=;
 b=nusNPrhyOk5K5R5aKPBl67yNPatfxWpo0kChhLdok4xWfx7NHkOOvFS/UoFZxTSJqJKe5AuVrfGpwX6RbenPtsyMpM2eKsJikqx0R1IiSGpqagB2AOz4y665q+DsDTdQ2IMwdw5+jyKNY3+sXcSWXAXRxY8sIIm4qBYFee50MkptJlji8whHw5xELFv2OWmsaXgPY3ZpxUexntrPulwEpzqVrA8z3LKxxB+0kV87VLyOhGzwUWCLBtIfWIWO0GDfktFo9cTqU/3AJTkTBD1wOnlZyjr85fBCAcVE/v1VO9uNXy4PkqFm+XFdwM+N1/pLMR9yNvrMo1LxPq66kw/c/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WumTBpjOu5Gr9XJn6eLmdM60poEhWajZkuaVoKJP50Q=;
 b=TKllLJhFUQXzKM1RLffw40OIMDdqxVNfhmiV0U8ekVyRay4i8FydBaDoo7LhWr82CzyxlxQ/M7VoYfj/Vscr/3fF5MG3pjB57pjTtJTAJd45Ebq3voV2kl3cXSGo2ir72Kfv8/PI+O+Ku4zONaicpLy1Q+Mxd7+ve6UfufJt+iY=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3412.eurprd05.prod.outlook.com (10.171.188.145) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.17; Wed, 30 Oct 2019 19:14:46 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 19:14:46 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH 0/3] VGT+ support
Thread-Topic: [PATCH 0/3] VGT+ support
Thread-Index: AQHVj1ZLMHESO93MNkaxx/XwsaIHeg==
Date:   Wed, 30 Oct 2019 19:14:46 +0000
Message-ID: <1572462854-26188-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM0PR04CA0016.eurprd04.prod.outlook.com
 (2603:10a6:208:122::29) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 56b7224c-9596-495d-6dae-08d75d6d6d6c
x-ms-traffictypediagnostic: AM4PR05MB3412:|AM4PR05MB3412:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB341268E0EC46E4545C250678BA600@AM4PR05MB3412.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(346002)(136003)(396003)(376002)(39860400002)(189003)(199004)(476003)(486006)(66946007)(66446008)(14444005)(66476007)(2616005)(6116002)(3846002)(2906002)(71190400001)(66556008)(71200400001)(5660300002)(4720700003)(64756008)(256004)(8676002)(66066001)(86362001)(2501003)(81156014)(8936002)(478600001)(102836004)(6486002)(26005)(50226002)(6506007)(386003)(6436002)(52116002)(7736002)(5640700003)(186003)(1730700003)(81166006)(305945005)(25786009)(54906003)(6916009)(316002)(14454004)(4326008)(107886003)(99286004)(2351001)(6512007)(36756003);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3412;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: fDwd/9cOnGdX13OUaon291vO0d1KB1aMBZZbw9Rg5k2mi5soeHNoG9QvKaUwKn04c0gtI/OVgpedcbRY2ZU7BHWuaL/9czVBkMz8ggeUpN/w19qhmukHYqK0MhdFYNuGFgXiRPqj/CKSnNv+9dDtulreap+XpAe78ASwniCjyeloxuXFOcdlLlA/prXWfhIS0fznVrUGUkrZtXdu0ri8zGT6HPZ+bYFusRc+kARSnO/dKAY1YJK7evyroZyBvaJfwDisJC4UCc05FJrH9m/OyZm127Bp8AJdZok0I+0qMF8H+u6hcPHsAoDmjmbgdyrXKC/DW289/2eDmitUcJSfyKg3AdLw9XhuglTmhjrE/9BB8hmB0Z0j8f6YKHQ/izcM9Iv9Yf3BkbmCD1YhE++MkM40SHSR/fEgqD10ERfTn7Opgt0VGt5srlQsNKkRJ0ek
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56b7224c-9596-495d-6dae-08d75d6d6d6c
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 19:14:46.7483
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: eTRFIfEmzVAY3fm2YkFtMWrHCbCmjww43p4vFPQPHETQN2Gy8NGva9xaxx/5EJacyPqJzASviVLZNZhwwMjweA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3412
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following series introduces VGT+ support for SRIOV vf
devices.

VGT+ is an extention of the VGT (Virtual Guest Tagging)
where the guest is in charge of vlan tagging the packets
only with VGT+ the admin can limit the allowed vlan ids
the guest can use to a specific vlan trunk list.

The patches introduce the API for admin users to set and
query these vlan trunk lists on the vfs using netlink
commands.

Ariel Levkovich (3):
  net: Support querying specific VF properties
  net: Add SRIOV VGT+ support
  net/mlx5: Add SRIOV VGT+ support

 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  30 ++
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  | 600 ++++++++++++++++-=
----
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h  |  27 +-
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |   8 +-
 include/linux/if_link.h                            |   3 +
 include/linux/netdevice.h                          |  12 +
 include/uapi/linux/if_link.h                       |  35 ++
 include/uapi/linux/rtnetlink.h                     |   1 +
 net/core/rtnetlink.c                               | 169 ++++--
 9 files changed, 712 insertions(+), 173 deletions(-)

--=20
1.8.3.1

