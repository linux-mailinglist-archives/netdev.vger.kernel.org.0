Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5638814007C
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 01:06:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729214AbgAQAG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 19:06:56 -0500
Received: from mail-eopbgr70079.outbound.protection.outlook.com ([40.107.7.79]:19560
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726752AbgAQAG4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Jan 2020 19:06:56 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xh97l9TSUM6FEATjNAEpx2YcD8cg4y61kjKPU/ZDJgQjO7rpVU7tl4ThwsmSkxpa1pioqOl4bSrnr45cD9dBMAFiIcKtByWROQ4elQaQvnzwrdkqShKpLQ+/fInIULeVOIamScPHAk0d6lQ8pXnegjSOarLD8YurclvUrFXVL8Z6uZr78OLYMn7ejy2CbErz8bg20+ZiNarzTHlcBoCzTC9q4zkxW8J5iMrpFDbTPF2tmql673Ns3I2jzTGDg9jPUxZLv9iXj9zfQoFR0Wirq5J5QKKj4jn8pGYOSZubl4hj4JnrhMzARbBzPbhB3pLa4SKeyREICQNVz9G3CDBz1g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sLfR/mfqvlUVA/xvYtBSuIl1vTKalSKbD/gHjbuAr8=;
 b=FCyEOQqVrwCjhzq0qFDCWSzLTmB5YrrqH9OQhf8s1Ps4duty2c3HvpSzOQd+MaX7ieuZpOIKb+J9UTY/m/6SK79g62vWB4d5xAfP9RtZ+CzQiN5Bj0ubF0ElGtfq5JUMUNhqY58vm0ABAu5oanUa470sZgAPOODXLSAirc19MxfM1Ab9Sd6ZSzISDcKHN/Tihe4srWGnpbfUgFsWFQf7GyF9oMBxL+sWfjbAxkA/+dGGLb7uW7id2BlqooNdj655vpe/wWrKWDBY8cQgC4fcAKpXEMEVQCC4lDvR8tXvmym0s+RGjLNurYfWXhi89YQF1jKGMZb+LycbUdZLs5NOIg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5sLfR/mfqvlUVA/xvYtBSuIl1vTKalSKbD/gHjbuAr8=;
 b=OWe3iaaW/6C72NSo5+HymBm+ztI53lXjcFq9QhaoGxyyqC4onEU8C47W3hRYofFLIC9q27i6EvgQkL04KK4bjgS2Ct/Qz96g0o8Pph41VHAVoQ64FENH9zUnai5+ekkeIqHlX/663HAAPb3gV0E68/RTfFcTZcvlNed4e3ikk2I=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4990.eurprd05.prod.outlook.com (20.177.49.211) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2623.10; Fri, 17 Jan 2020 00:06:51 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d830:96fc:e928:c096%6]) with mapi id 15.20.2644.015; Fri, 17 Jan 2020
 00:06:51 +0000
Received: from smtp.office365.com (209.116.155.178) by BYAPR03CA0003.namprd03.prod.outlook.com (2603:10b6:a02:a8::16) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2644.18 via Frontend Transport; Fri, 17 Jan 2020 00:06:49 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [net-next 00/16][pull request] Mellanox, mlx5 E-Switch chains and
 prios
Thread-Topic: [net-next 00/16][pull request] Mellanox, mlx5 E-Switch chains
 and prios
Thread-Index: AQHVzMoEz1pPFMc0fki5yV8ADtm43A==
Date:   Fri, 17 Jan 2020 00:06:50 +0000
Message-ID: <20200117000619.696775-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.24.1
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0003.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::16) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 3b905482-72aa-40e3-7c3c-08d79ae126e9
x-ms-traffictypediagnostic: VI1PR05MB4990:|VI1PR05MB4990:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4990F7978CC7A4F6EA90354ABE310@VI1PR05MB4990.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:4303;
x-forefront-prvs: 0285201563
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(376002)(396003)(366004)(39860400002)(136003)(346002)(189003)(199004)(64756008)(6512007)(52116002)(66476007)(26005)(81166006)(86362001)(16526019)(316002)(81156014)(8676002)(2616005)(66556008)(186003)(6486002)(956004)(71200400001)(36756003)(508600001)(66446008)(54906003)(1076003)(5660300002)(2906002)(6506007)(4326008)(110136005)(8936002)(66946007)(6666004)(107886003)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4990;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Rlo3UzNChDJT8pu/fR5/+BoNnW+nH0xXO3Ra5KBXyp/GfqqOOETbFX39p1ijRQUtAWB3/AzKmsc4aTQoEuDuyKcTiUIab8xFKa2EtcnIhSWfKXXBUKUTv6xJiih2qKJDVkhWkhDqJ/xGOR3Fh75bEppdP/W6BJJzErG+BjsuYmdsCHacvj2qp9zYs8lSNLOl2IvdrUO5XDiEI5nCyyATL/BmFGlWJTwTo7+zhJ7XUOseQZO4GYPlqtzQ1RmhzctBnOMq6eopmClOlAHvqKn4seY5C7viw23j6VOUl+cMWVKoCEHCAV1No9mmmZvOAUoBqVAcFSvSFeJkwJEl+utnBR7xO5s1dfP8HteSvjVaCvEHgiBHqwXFj1rhhivvkdnQ+f2Cj/w+6W0G4lf1aQzYLzHyEzPbO5nA3R0HbqahoJETlDdqVGPBhbuoMzpwvt8Ic0Faui8jPfS26KneDL1J8lg7SNB9hN3L+mK6gMqRfQd6UDZ4tJdQhOXNDRSb/SGvXOE7UI0LnzzdN5ywGaQ3DQ5Bt7pQhAX/5eE5aWII0G8=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b905482-72aa-40e3-7c3c-08d79ae126e9
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Jan 2020 00:06:51.2066
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: CNeU3wcRpn8IHoKapQQk63hbH7tFZjfkfFwuHugCueEWTfVl7SFrp40QsN60i4tKVY/rXn+j83pcGN7ioQzm/g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4990
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave/Jakub,

This series has two parts,=20

1) A merge commit with mlx5-next branch that include updates for mlx5
HW layouts needed for this and upcoming submissions.=20

2) From Paul, Increase the number of chains and prios

Currently the Mellanox driver supports offloading tc rules that
are defined on the first 4 chains and the first 16 priorities.
The restriction stems from the firmware flow level enforcement
requiring a flow table of a certain level to point to a flow
table of a higher level. This limitation may be ignored by setting
the ignore_flow_level bit when creating flow table entries.
Use unmanaged tables and ignore flow level to create more tables than
declared by fs_core steering. Manually manage the connections between the
tables themselves.

HW table is instantiated for every tc <chain,prio> tuple. The miss rule
of every table either jumps to the next <chain,prio> table, or continues
to slow_fdb. This logic is realized by following this sequence:

1. Create an auto-grouped flow table for the specified priority with
    reserved entries

Reserved entries are allocated at the end of the flow table.
Flow groups are evaluated in sequence and therefore it is guaranteed
that the flow group defined on the last FTEs will be the last to evaluate.

Define a "match all" flow group on the reserved entries, providing
the platform to add table miss actions.

2. Set the miss rule action to jump to the next <chain,prio> table
    or the slow_fdb.

3. Link the previous priority table to point to the new table by
    updating its miss rule.

Please pull and let me know if there's any problem.

Thanks,
Saeed.

---

The following changes since commit 12e9e0d0d97cc4f2aa9a858ac8a5741f321b5287=
:

  Merge branch 'mlx5-next' of git://git.kernel.org/pub/scm/linux/kernel/git=
/saeed/linux (2020-01-16 15:48:24 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git for-net-nex=
t

for you to fetch changes up to 278d51f24330718aefd7fe86996a6da66fd345e7:

  net/mlx5: E-Switch, Increase number of chains and priorities (2020-01-16 =
15:48:58 -0800)

----------------------------------------------------------------

Aharon Landau (1):
  net/mlx5e: Add discard counters per priority

Aya Levin (2):
  net/mlx5: Expose resource dump register mapping
  net/mlx5e: Expose FEC feilds and related capability bit

Eran Ben Elisha (3):
  net/mlx5: Add structures layout for new MCAM access reg groups
  net/mlx5: Read MCAM register groups 1 and 2
  net/mlx5: Add structures and defines for MIRC register

Hamdan Igbaria (1):
  net/mlx5: Add copy header action struct layout

Paul Blakey (9):
  net/mlx5: Add mlx5_ifc definitions for connection tracking support
  net/mlx5: Refactor mlx5_create_auto_grouped_flow_table
  net/mlx5: fs_core: Introduce unmanaged flow tables
  net/mlx5: Add ignore level support fwd to table rules
  net/mlx5: Allow creating autogroups with reserved entries
  net/mlx5: ft: Use getter function to get ft chain
  net/mlx5: ft: Check prio and chain sanity for ft offload
  net/mlx5: E-Switch, Refactor chains and priorities
  net/mlx5: E-Switch, Increase number of chains and priorities

 drivers/infiniband/hw/mlx5/main.c             |  10 +-
 .../net/ethernet/mellanox/mlx5/core/Makefile  |   2 +-
 .../mellanox/mlx5/core/en_fs_ethtool.c        |   9 +-
 .../net/ethernet/mellanox/mlx5/core/en_rep.c  |  28 +-
 .../ethernet/mellanox/mlx5/core/en_stats.c    |   1 +
 .../net/ethernet/mellanox/mlx5/core/en_tc.c   |  27 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.c |   7 +-
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  27 +-
 .../mellanox/mlx5/core/eswitch_offloads.c     | 298 ++-----
 .../mlx5/core/eswitch_offloads_chains.c       | 758 ++++++++++++++++++
 .../mlx5/core/eswitch_offloads_chains.h       |  30 +
 .../mlx5/core/eswitch_offloads_termtbl.c      |  11 +-
 .../net/ethernet/mellanox/mlx5/core/fs_cmd.c  |   3 +
 .../net/ethernet/mellanox/mlx5/core/fs_core.c |  96 ++-
 .../net/ethernet/mellanox/mlx5/core/fs_core.h |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  15 +-
 include/linux/mlx5/device.h                   |  14 +-
 include/linux/mlx5/driver.h                   |   4 +-
 include/linux/mlx5/fs.h                       |  20 +-
 include/linux/mlx5/mlx5_ifc.h                 | 222 ++++-
 20 files changed, 1222 insertions(+), 361 deletions(-)
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offload=
s_chains.c
 create mode 100644 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offload=
s_chains.h

--=20
2.24.1

