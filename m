Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0F7F215D
	for <lists+netdev@lfdr.de>; Wed,  6 Nov 2019 23:05:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727559AbfKFWFm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Nov 2019 17:05:42 -0500
Received: from mail-eopbgr20050.outbound.protection.outlook.com ([40.107.2.50]:38020
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726779AbfKFWFm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Nov 2019 17:05:42 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nPYCTyxpPOWxy64cw+lDGwhY5468GE1tE/bNuef53lmV1OdbFMN64/p9l69lml63vOmBukBWLwe6CZS+gUVeDnQ3+fw68QINL1+43DHcFWqYxg4Rk15qmaCD/ZJf361B3C4l3OZ9BDp023Iz2mf718kII3W9MiAV+rxoJLGYCXtOYZMCDvLNLnMrx2OXDaKwlYI2AN9xnngyXUQvkbvF5qUo8ZyIUSptIxvOB1fcNwzLBjl24vbkMDQxa/EphDqRGn+FQWemXeQ2aClrJsZUHYijwz3u8Ot0KteTySw07oBo4WgSYq3Mq/pdYsBJwf90T4zZw/ZxGx35cltROsfijA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PnNc7R8lIQzTPyE0H4Q10WVYBq7cPf0AR8PQDwEyGA=;
 b=HoTx18dOvt3ljzWEBjJVYLzOdraoqNWf5jnrnJH+1ZaBxlsTcBgmGBRllSowOlP4Je1ZYjSH8d9l700A3TFKdXdNX9UI0/BfNtizrIM1/CA+aXr+tqdPeHNyevVbyalViPA1OQIB28minoZWMuAwVe5jtwIAGBI0mBsp3UsZe/D4IZD7lEtd/1rJrUSzgBVAGcqB3o57hs4z805z9PBpUJ41yUMQR+38qEx2ionpcArf/vlztVUbH9xu5/cU5kt/FSvkLg/mO31TMX1vEsgwBihO+Fr8iu9S9l59DlmS5CZk83CQkmZ76vcphr54vMazXczVw3Qz09WOut6DagXigA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5PnNc7R8lIQzTPyE0H4Q10WVYBq7cPf0AR8PQDwEyGA=;
 b=G8h9SE1zenRApSVgKdiMaJDy01un52L0xfiY0PilNJYJna1N0V5C3y85zkr/7v7WVlPaJ3bTOgebeHTouuzyMafMIcqSsin55iP/07QR5tDoF5Q2cI4hFGIegRhtESvV88hyPDx+3JnWJpvWs3L7GeLAPg8y1KJigWBu67EyQX8=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5549.eurprd05.prod.outlook.com (20.177.203.87) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2408.24; Wed, 6 Nov 2019 22:05:38 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2408.024; Wed, 6 Nov 2019
 22:05:38 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/4] Mellanox, mlx5 fixes 2019-11-06
Thread-Topic: [pull request][net 0/4] Mellanox, mlx5 fixes 2019-11-06
Thread-Index: AQHVlO5SU6K0h9cGTUCcQXXxR8u8ew==
Date:   Wed, 6 Nov 2019 22:05:38 +0000
Message-ID: <20191106220523.18855-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0041.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::18) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 0c9ae00b-fa22-4a67-d4db-08d7630574b8
x-ms-traffictypediagnostic: VI1PR05MB5549:|VI1PR05MB5549:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB5549FE70E0FC7D27315C1154BE790@VI1PR05MB5549.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:773;
x-forefront-prvs: 02135EB356
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(366004)(376002)(346002)(199004)(189003)(66066001)(71200400001)(6512007)(6486002)(316002)(476003)(25786009)(305945005)(36756003)(14444005)(86362001)(66476007)(66556008)(52116002)(64756008)(256004)(66946007)(2616005)(4326008)(386003)(26005)(186003)(7736002)(50226002)(107886003)(478600001)(6506007)(102836004)(8936002)(1076003)(66446008)(14454004)(99286004)(81166006)(5660300002)(6916009)(486006)(8676002)(81156014)(54906003)(6436002)(6116002)(3846002)(2906002)(71190400001);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5549;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: gToxC58PozmFS6hH8Lh0rkj6G8Wd01eZdgjjERpzs1rkU4EvmA45q+5OJYO4NZakIf/0AYdP81yEdvYdszAiyqNoArVsPtJ93fQXUVoetgCIAz39tnWTirRf72ks0HCxu0CBrDLLs83rMNe6bAYNV/J74N1F3RFqF+2LIksnRiktPfrYGGcu+Z93GaaXyF7OOn35nni53LeI6t0dfdqqx8ikd+qZYUaH3wCGfbgXitYaJDogU9y0AKGH54RZEtnGzUzR2leYezitud8Uni/rJ0hVzsu89Jm+my6g7/TylwqraOeNAoz3VXhjUn/nTkpNWMy4Duh9xl7UZfTWzz5cQFkDiRQzjInusV6akDhaB/OpA+fPzrcztmu6Ybqn1v+OhW0Hg0Ea/j+b709FR4AjNBOXauUWW1nLiqbK+2fB8+7GTSejDg9ZNjEhW0d3Xb6h
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0c9ae00b-fa22-4a67-d4db-08d7630574b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 06 Nov 2019 22:05:38.2369
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: jsDL5qrxNISU2k8DA8J4ycv8EtkINmm6lfw4bZJWSljcW2zjVrsc5LNQmyP0nozUmUR5c4wmLtaXllDFYGEcBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5549
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

Please pull and let me know if there is any problem.

No -stable this time.

Thanks,
Saeed.

---
The following changes since commit cc59dbcc5ddda532c9da054977d2dfc8f7338735=
:

  Merge branch 'net-bcmgenet-restore-internal-EPHY-support' (2019-11-06 10:=
46:22 -0800)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-11-06

for you to fetch changes up to 950d3af70ea89cf7ac51d734a634174013631192:

  net/mlx5e: Use correct enum to determine uplink port (2019-11-06 14:03:55=
 -0800)

----------------------------------------------------------------
mlx5-fixes-2019-11-06

----------------------------------------------------------------
Alex Vesker (2):
      net/mlx5: DR, Fix memory leak in modify action destroy
      net/mlx5: DR, Fix memory leak during rule creation

Dmytro Linkin (1):
      net/mlx5e: Use correct enum to determine uplink port

Roi Dayan (1):
      net/mlx5e: Fix eswitch debug print of max fdb flow

 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads.c         | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch_offloads_termtbl.c | 3 ++-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c       | 1 +
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_rule.c         | 2 ++
 4 files changed, 6 insertions(+), 2 deletions(-)
