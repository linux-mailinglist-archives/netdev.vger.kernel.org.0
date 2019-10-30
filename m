Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0FFC7EA4ED
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 21:44:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726945AbfJ3Uos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 16:44:48 -0400
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:61631
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726483AbfJ3Uor (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 16:44:47 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n5upgRTCOsf/tnVblvwr0ew46KN4mZ7hbvRVCeZiwoBr8IRe2/VV6+ShS7BlMw6PoG7UQevaiq6IoBhV3WCcQU8JfTswPmsx8Pr3G65s+SDhIw3Y6iVMmQXDU2TOWL3l6bvJm1t3BW7CiYPVjmprSI1E6+Kxpn5o6JbRkP/MvSjGClv0SYKLtK8dm4G+5deaZQcNebuT2c6hV/mKS5iTTceqyZ25Xww72UcPfImxVKj5kbceZKHWVWS9G3cqDnaPD8pB3Qg4yXIZDDxuHganR6jBjcYH6oKnemrloCeVKOEWjDHSAsX7QTYApamuxAvhLeL2SfBRxc3qhwb4qogMbQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WumTBpjOu5Gr9XJn6eLmdM60poEhWajZkuaVoKJP50Q=;
 b=dg+x2fr1Gf13t6xtasqVIVv31OyL70dvO2mr32APtEizYF6L91tFbdCZMq9dd1dyVBZY/5ZxH40bfLapiNQ7ZyTgQjYnPLM/2Ap57C/Pr4q2l+UI2RTTD+qCeVyZJc8xpJve8HMmYEWLJj4sgINbYqmODs3888j2o6y41oPsOd5oCZjVb33PW3PW8UilLLyEGdRv8ahS1ZftjVwQOMajqBzv3yveH0LBu7NhM/fxdSKE/Nc/SInal0OBl5bTb3p8MJqZkaBXYdCoDyBSlbxIM3yCqO3M4mz3G7udTeFTNdIZ6WzODYv9YYw+lcLiFF4ioiiMg/QxqtlogLiNFx69fg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WumTBpjOu5Gr9XJn6eLmdM60poEhWajZkuaVoKJP50Q=;
 b=Zh0pFE8eefBe2z158FE8OZ4k1OiY9vwyOFgKBvf1+O1Jgh9Awp1o4HVsiTAoqjYt8CB1MYuITBoL7UH2c6ZNNwrBq8Lex0Yti/TauSHUYypddIE4ap/udaJDWSA+ngzmmfsxVnwbOUZCs049Dkn1+149sv2qzDiC7XOsvoNJ684=
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com (10.171.189.29) by
 AM4PR05MB3267.eurprd05.prod.outlook.com (10.171.188.28) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Wed, 30 Oct 2019 20:44:43 +0000
Received: from AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc]) by AM4PR05MB3313.eurprd05.prod.outlook.com
 ([fe80::59bd:e9d7:eaab:b2cc%4]) with mapi id 15.20.2408.016; Wed, 30 Oct 2019
 20:44:42 +0000
From:   Ariel Levkovich <lariel@mellanox.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Saeed Mahameed <saeedm@mellanox.com>,
        "sd@queasysnail.net" <sd@queasysnail.net>,
        "sbrivio@redhat.com" <sbrivio@redhat.com>,
        "nikolay@cumulusnetworks.com" <nikolay@cumulusnetworks.com>,
        Jiri Pirko <jiri@mellanox.com>,
        "dsahern@gmail.com" <dsahern@gmail.com>,
        Ariel Levkovich <lariel@mellanox.com>
Subject: [PATCH net-next 0/3] VGT+ support
Thread-Topic: [PATCH net-next 0/3] VGT+ support
Thread-Index: AQHVj2Lb0MIiol1yEUantlGMOLeCAQ==
Date:   Wed, 30 Oct 2019 20:44:42 +0000
Message-ID: <1572468274-30748-1-git-send-email-lariel@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [94.188.199.18]
x-mailer: git-send-email 1.8.3.1
x-clientproxiedby: AM0PR06CA0066.eurprd06.prod.outlook.com
 (2603:10a6:208:aa::43) To AM4PR05MB3313.eurprd05.prod.outlook.com
 (2603:10a6:205:9::29)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=lariel@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 58943cb0-ed1f-4363-cde1-08d75d79fdb9
x-ms-traffictypediagnostic: AM4PR05MB3267:|AM4PR05MB3267:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR05MB32673D5DF8D5F411C578CFAABA600@AM4PR05MB3267.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 02065A9E77
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(376002)(39860400002)(136003)(366004)(346002)(199004)(189003)(14454004)(1730700003)(6486002)(476003)(486006)(8936002)(186003)(6512007)(478600001)(316002)(26005)(54906003)(81166006)(2616005)(6436002)(81156014)(8676002)(50226002)(5640700003)(86362001)(107886003)(25786009)(99286004)(52116002)(386003)(2906002)(102836004)(2501003)(6116002)(14444005)(71200400001)(36756003)(71190400001)(6506007)(64756008)(66556008)(4720700003)(2351001)(66446008)(66476007)(3846002)(7736002)(6916009)(5660300002)(66066001)(305945005)(256004)(4326008)(66946007);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR05MB3267;H:AM4PR05MB3313.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: KEdQ5SXRKyjUMG51y5Bl1yhKTe4oH1r9RSqEk33j5xf6hxClwp1RX8uU3s7ErJUZj3YGHJqWGUFsXjiTOAHLxreeu9qgHsfWrsLmhjQoESRQvn5A1jO1/CQw/Q7Pjr6h/2iw5EUDbRwy8xlGc6SzX6/5RlQ1ktoYIjTMo5Mp91Xvv0CREjYJzRavjpREHPVEpvAl8ujx/u9d5vUxra1u8pkrIzCWfwsV+yp4CIIZh+FX5MycR9LPm1yllNVi5WnLcE6L0iea2p8Z7uQAkdxOKWsu2NYetf1j+AKR+wXL5p53WGeVlut7ePjAnP+Wmg8YTLooRkXbTqtWPM7aZ0VkQ3WYqElWDVsDWCJiSF7KU9JLHj6M9SVrtJZInOpQS4wirbzKd7pahkNhsY0SvUuQL2mkBDEfUdszuW9xC1Qck5sJXtPDXrB1ZekOaooqr8qO
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58943cb0-ed1f-4363-cde1-08d75d79fdb9
X-MS-Exchange-CrossTenant-originalarrivaltime: 30 Oct 2019 20:44:42.7661
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 51c6nIXunnG4UpFT6szOD427rkAPxw8JFaoEwGoHboTM4FKeGtEpWoJX5FipuJAqjWpiS8CJRW80xbhLYJLkFg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR05MB3267
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

