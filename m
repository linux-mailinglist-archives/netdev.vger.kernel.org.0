Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4EDE93D8
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 00:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726397AbfJ2XqI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Oct 2019 19:46:08 -0400
Received: from mail-eopbgr150084.outbound.protection.outlook.com ([40.107.15.84]:58441
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726089AbfJ2XqI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Oct 2019 19:46:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jMEOwycCB0AZdyuA+Avbf3B9RTmxuTIHUrHnxT/yAMfz7qUl7RrcUZnb4DddIfD0x6xouRHUGI5EVbxR/4ucq5PfB3S3tIl01t2sEA8fHPk7UXk5J1XwBdUnDXWVLyYqXqDoRJmPgbkziVno0pqslZ7P0txe6/tarFGl7b2U5K68gWtaT6eEl+sSRzDwIBYjYA3i3HmEwrIGlGLDLoyVp29UQjWUNxnsqV+WD6KsWvTn2ZaZh3q+Aj7pTfxufXm2omFVjmFeb0cIahX75ekVk+DnSHuFFkDoJuWJqNXf2jHjI9SeGUufQ1u+Ya3uWb1MYXB0/WVSJcNfCTZFrqotEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmSQZeVXlUnlcqN+zu5IIUeykSQfYoNSVYK5NVJYt8I=;
 b=bM98PaRxRSEF4G8Ve+fOCTvwE5DlK7KYKF7ccTBuDqp+sQLn/MhVAJCenR3eDEDhtnVWEilMp5E6ZHGhkcec8nneXMCaFr/OETdlQakpJoyWxJH7c8/OJgHszOf6H8dNGhVbRlTdrKSbdLqqMN/hZAVZIxLO3xsQPtgedKNCRrMd5z+Th3cgXh69tdCzzMKMMZxSY/FFBafngqCK1AnQudF1yjn9wZH5yD8KHhfSzxvRgwIf9tX980nGzZ0Ev2zjWTTXGUWLfz5CySI5a7F+A9RgjBao37FL7fsFg3epnwOdyCStRxZ3nQ3i+3U1i0TF0Eiu/bqKq0Vsfa1i63psfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rmSQZeVXlUnlcqN+zu5IIUeykSQfYoNSVYK5NVJYt8I=;
 b=m82giVAbnGfJ4uK/DTIQtEVXvAbxacRv4F6ws7h61z4N3DW8NBihmrWL2X59CNhd6xlvGRfylRLO60pQpZoakV2XgXpI+Wyv4RWaUU1AO8Fsmi2JxWDb/QrZpLmWr2riLraurYFKWBamcZMItunO3vzDEkXMRNQFRa6VsntH044=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB6157.eurprd05.prod.outlook.com (20.178.123.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2387.20; Tue, 29 Oct 2019 23:45:50 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2387.027; Tue, 29 Oct 2019
 23:45:50 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net V2 00/11] Mellanox, mlx5 fixes 2019-10-24
Thread-Topic: [pull request][net V2 00/11] Mellanox, mlx5 fixes 2019-10-24
Thread-Index: AQHVjrL+sRZxiB6cXEm7YnaqNjAP6A==
Date:   Tue, 29 Oct 2019 23:45:50 +0000
Message-ID: <20191029234526.3145-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [73.15.39.150]
x-clientproxiedby: BYAPR08CA0050.namprd08.prod.outlook.com
 (2603:10b6:a03:117::27) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 715572d8-1d21-486e-32a3-08d75cca20be
x-ms-traffictypediagnostic: VI1PR05MB6157:|VI1PR05MB6157:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB6157B47A9C51AD7AD912AA45BE610@VI1PR05MB6157.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2089;
x-forefront-prvs: 0205EDCD76
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(39860400002)(366004)(346002)(396003)(376002)(199004)(189003)(6486002)(4001150100001)(486006)(4326008)(2616005)(476003)(6512007)(66556008)(71200400001)(66446008)(66066001)(6116002)(8676002)(54906003)(2906002)(7736002)(316002)(6916009)(81166006)(81156014)(478600001)(107886003)(8936002)(50226002)(6436002)(1076003)(25786009)(36756003)(3846002)(14454004)(71190400001)(86362001)(305945005)(14444005)(99286004)(256004)(26005)(6506007)(386003)(66476007)(52116002)(66946007)(102836004)(186003)(64756008)(5660300002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB6157;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: Sy/Xt8+F5Ev21xM21Ri4Ch2MoT+NRoC9t62KR8jj4A4ABCh38IzXuDULQP/33BQhqZ/cDcmxJpJdGE5NF4vAhxEBqSVRLFCdPmdmT/l4v848gZCF+mh1cwIA/ZLYP7Uec30btWprOTLh9TCuYNE4V0aoSnZOW1Fn438BfYgxeXXBzqJxC7VhhKbDKZkbqwfzNmmmVB+emI8Bf4Fl7MDndVwB/dkHPBAgy+3aRaF/GhDxqLewq8OMad6keyL8NjpV3hReDFIivOjvoT//A/fVkpi67YtTqIjh202Tq49W7X8+TV47xpUjfE+UJmYFzFRzqjqUu26anTgfxB9Po0bqsMyHaQdMBW3s7D1+li3OnZaWNlbfqqdtoGm8jTI1teAUCbwIKFhGhezhXxnHybIqbZuEriYjLlnPJS7Un+2NPM2lU6iKbyTEBZMpE+Pje2z3
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 715572d8-1d21-486e-32a3-08d75cca20be
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Oct 2019 23:45:50.1977
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: lgY1544IM6/+WH/jJ7DgKbeNfAk7AKnNqujzmMqTdIDi2Q1aQ5q00t6/uvEXqfo4gDUAEO79uy8lJyzy7UZaUg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB6157
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces misc fixes to mlx5 driver.

v1->v2:
 - Dropped the kTLS counter documentation patch, Tariq will fix it and
   send it later.
 - Added a new fix for link speed mode reporting.
  ('net/mlx5e: Initialize link modes bitmap on stack')

Please pull and let me know if there is any problem.

For -stable v4.14
  ('net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget')

For -stable v4.19
  ('net/mlx5e: Fix ethtool self test: link speed')
=20
For -stable v5.2
  ('net/mlx5: Fix flow counter list auto bits struct')
  ('net/mlx5: Fix rtable reference leak')

For -stable v5.3
  ('net/mlx5e: Remove incorrect match criteria assignment line')
  ('net/mlx5e: Determine source port properly for vlan push action')
  ('net/mlx5e: Initialize link modes bitmap on stack')

Thanks,
Saeed.

---
The following changes since commit 6f3ef5c25cc762687a7341c18cbea5af54461407=
:

  wimax: i2400: Fix memory leak in i2400m_op_rfkill_sw_toggle (2019-10-29 1=
6:20:25 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-10-24

for you to fetch changes up to 926b37f76fb0a22fe93c8873c819fd167180e85c:

  net/mlx5e: Initialize on stack link modes bitmap (2019-10-29 16:27:20 -07=
00)

----------------------------------------------------------------
mlx5-fixes-2019-10-24

----------------------------------------------------------------
Aya Levin (2):
      net/mlx5e: Fix ethtool self test: link speed
      net/mlx5e: Initialize on stack link modes bitmap

Dmytro Linkin (2):
      net/mlx5e: Determine source port properly for vlan push action
      net/mlx5e: Remove incorrect match criteria assignment line

Eli Britstein (1):
      net/mlx5: Fix NULL pointer dereference in extended destination

Maor Gottlieb (1):
      net/mlx5e: Replace kfree with kvfree when free vhca stats

Maxim Mikityanskiy (1):
      net/mlx5e: Fix handling of compressed CQEs in case of low NAPI budget

Parav Pandit (1):
      net/mlx5: Fix rtable reference leak

Roi Dayan (1):
      net/mlx5: Fix flow counter list auto bits struct

Vlad Buslov (2):
      net/mlx5e: Only skip encap flows update when encap init failed
      net/mlx5e: Don't store direct pointer to action's tunnel info

 .../ethernet/mellanox/mlx5/core/en/hv_vhca_stats.c |  4 +--
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun.c    | 12 ++++++--
 .../net/ethernet/mellanox/mlx5/core/en_ethtool.c   |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_rep.c   |  4 +--
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c    |  5 +++-
 .../net/ethernet/mellanox/mlx5/core/en_selftest.c  | 15 ++--------
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    | 34 +++++++++++++++++-=
----
 .../ethernet/mellanox/mlx5/core/eswitch_offloads.c |  1 -
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  | 22 ++++++++++----
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c   |  3 +-
 include/linux/mlx5/mlx5_ifc.h                      |  3 +-
 11 files changed, 67 insertions(+), 38 deletions(-)
