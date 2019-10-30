Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C542EA42C
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 20:25:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726651AbfJ3TZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 15:25:25 -0400
Received: from mail-eopbgr140050.outbound.protection.outlook.com ([40.107.14.50]:40260
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbfJ3TZY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 15:25:24 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IOR4ja0xOACWJxrKDu+KUOVaL7yYV5/AsDqc2cDpiQL8cMk89Gn+HcBbUwavhK4wsFKu+Pz8e5jEhITYPPRZx9a1IKv2KRUO1dAY9OY/XiCLIMbWQfZdrcSFvdlsT7iW0btpDH+rPLx8HPsaUS2VINvUGAnkGAqhhe6I9NRhJ58tnzCqAZDygEsssQ2UwKXHVFpKB/0C58r4fFlVHhesITZ1awABI0cV0e8KufVzNnzfkf1158kFY92n2+dev6BPiyKJY2GOWQZoVrx+RXGjFNNJg0+a+yg6k/ardVhz7kUH2J7xS169B+e8YSEr8mA3U/TAZxpCrHEO+fRh94zRXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rQYqWChUgyRG2H+V9V8dRj8EcCLqWBsZSpVEr3WVg4=;
 b=CkymsBBDwixtWOgrGG9/50jhIq86GaSOF4PEOR+cGV9B9FPBNIWV6xXt8bi1C4eXZpgzWpGpxFPQzW3cJJX5xRWb3T6R0mlH8QpUndJuTWTqcub6702ZTFJAmmkzqCLDga8S+m3CLquxtnpxWQSL88jZFAFEj/Gn3pjGCOC1YEr/YrU3XznqKDXjcRUBWjTlgDC4VpUA2V3HgkbqoFzdkKG/vif0OinM5siZJ020RLCAqvvSMDF9WF9PSGpnT4ySwTVL3F1K519DYbO65i6LQaD1WBaguN28Qn31huWJtmKHMKsycw04Ss0BxQCRsU8wAJfpb/Vco5gpaaOg0x0kTA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8rQYqWChUgyRG2H+V9V8dRj8EcCLqWBsZSpVEr3WVg4=;
 b=UyaYgaUDYK2/I0+WMt+eRQeWtBemDQwR4uwXqZgkpxJmqLnG2E7cqxk0ZdOIdIkowHehPDgSDQOrJD72rquJN3vTj6nkmpzrP61JfWPGZTmbVJGQO+8Kjf8LUhUc1PBSqyMwc17by/ep3FZOvwGcG41xbl80q8gAcK0VXXyx424=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3186.eurprd05.prod.outlook.com (10.171.191.32) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.24; Wed, 30 Oct 2019 19:25:21 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 19:25:21 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH v2 0/3] VGT+ support
Thread-Topic: [PATCH v2 0/3] VGT+ support
Thread-Index: AQHVj1fFL7ad5fJNrEqUrkP2PE+7hw==
Date:   Wed, 30 Oct 2019 19:25:21 +0000
Message-ID: <1572463515-26961-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM0PR05CA0093.eurprd05.prod.outlook.com
 (2603:10a6:208:136::33) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 2308c848-6f40-4af1-3e5e-08d75d6ee7a1
x-ms-traffictypediagnostic: AM4PR05MB3186:|AM4PR05MB3186:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB3186A5B3B86691EFC4A6E814BA600@AM4PR05MB3186.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:1468;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(396003)(346002)(376002)(39860400002)(189003)(199004)(305945005)(7736002)(64756008)(66446008)(14444005)(25786009)(316002)(66556008)(256004)(6506007)(386003)(54906003)(71200400001)(4326008)(71190400001)(486006)(2351001)(2906002)(6486002)(6512007)(2616005)(6436002)(86362001)(6916009)(5640700003)(107886003)(52116002)(476003)(50226002)(14454004)(8936002)(8676002)(1730700003)(81156014)(81166006)(99286004)(186003)(66476007)(5660300002)(66946007)(2501003)(3846002)(478600001)(102836004)(4720700003)(66066001)(36756003)(6116002)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3186;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: /FlreUO4OGRuC4bGZ9DiNkUYmI+yNkzo3u3X3T5ZxAPgdAo8sIL64BfhtphqcHZ4gMxGNvu55DHwNZkt1R3vZwvwKYzvUnxREQiV2IerM0raWB6hiD2npyTO2qFApVAMnIjjlqpHlCgHLS534VKeWbRH6ZYPkNk6XQY/HuGsev7kY74ElOUZ0SsSW7VBpIVBHUe4KtpxUIxcj6Jnx4YYuxcpa79pMKiatH7B4eJikOeh+pJgBMGi0gj468t0q/OAVaJXusOHlk2bJYaph1q4xsGXF/dYVt15sdK5uX2auWG8IpgR2FQYbnefTjcnGHYK1pqwKb2DUgTpnGnmaCfcTlUJMV9tSNUBjnn64UM0ffYOyrEDwMOlkO1g7pRZdOEPNcpdY7oylnqiqrvOu5DC5y1n9aD6oExc2mF+OcMvnXl5crP8DqltaRWdbgaJ4K7d
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2308c848-6f40-4af1-3e5e-08d75d6ee7a1
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 19:25:21.1853
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 54kaE9RDRmOQSdTaBYfy/oD6c4dRnMe4s0q9lZVngVr4T4nbd+FoPmSgaQr/hOCP8H8+fDN6t2Wny7U9CN1/2w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3186
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

Changes from v1 to v2:
- Removed internal tags from commit messages.

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

