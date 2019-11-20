Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BDA9E10465C
	for <lists+netdev@lfdr.de>; Wed, 20 Nov 2019 23:22:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfKTWW0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 17:22:26 -0500
Received: from mail-eopbgr10048.outbound.protection.outlook.com ([40.107.1.48]:31714
        "EHLO EUR02-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726358AbfKTWWZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 17:22:25 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YyWL8BwA7YOmlKc9SSZDRacTdA42JXTFv7loerm5SNweF47bPzP/rLmts1olDIkwXNaHDpvXO+Y5mXGHrdVaDk6ec8QLTV/W5iPap/ybVmmRFhvTfClePFuPq8BgQPG+tOzFw+sGR9WSOnZU5xJj+P7DaeWUg7yJnaVbhSRUZ3BzYxUaiUMaI9FxiJMO79OXYkOUdPBIMRrqPoYmOxxQRcib7wuM+vEm4qC2SN3cHubuhbqxLsKNYWYVVw7bBVBPrhYuqPqsqFFrbHYSk5sWq2fLa6MztuEjAk7v8PHvso1u5rWNdxOtXegiG552x3YpGjibQhQkQsO8OkK31tMh2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ihsl6FMboNVvQ1CHXI62fJBlDCrEPdPnNWus7JO6WX4=;
 b=eyixXeiKnWmgKeLg7YWazI9EKp7hpAUVSNhVbAxQpmMvHH5M22UZOcsA3VoYNNEsa1lP+H7k8+LsSbPZ+4A/WjUBWZRew0Kkv17N6qNkIcEXZYbLESyS0AyBN1g1Rp4N/2FxGgochEgC+tSriAAMT9NJaWh6aNb9F0LzcW73EquhUGNz+H4D87m8+DqJowkAchWiHEpFupWwdWJ7i8tXYQ2k9MO1KUlTxGMg9QN6BQ+1ElP+74G85xvjxrVldPXlHdSkO+S0Pvz24ySIg7vof1tdnkhkJqeTaIbSvz/zC1nkyiZqHYsdbBwCbuzon7vKKOLK3uBUbvpYj1QTcRcG3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ihsl6FMboNVvQ1CHXI62fJBlDCrEPdPnNWus7JO6WX4=;
 b=d9J8qitLXI5VHazMxtsJ4wCq+ixiU0oRJcp0BsBEezXsNVn9/8M4OFB+XLszxW+m9+9oeMIRVQq34gP+Xv0TjjCVo7/AKjqtELTqe77dDwWvTEBbsWVZhSQUqQfs85vy712OLOHhGqGXGSmMXo5HDAFDBC4IPlppdP5p/ar8Qec=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB5341.eurprd05.prod.outlook.com (20.178.8.218) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2474.17; Wed, 20 Nov 2019 22:22:21 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2474.015; Wed, 20 Nov 2019
 22:22:21 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 0/5] Mellanox, mlx5-next updates 2019-11-20
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, mlx5-next updates 2019-11-20
Thread-Index: AQHVn/D5J01bRWykDkqcH1UDlc+PeQ==
Date:   Wed, 20 Nov 2019 22:22:21 +0000
Message-ID: <20191120222128.29646-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR03CA0001.namprd03.prod.outlook.com
 (2603:10b6:a02:a8::14) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 5302b7cf-5952-4849-b723-08d76e081c27
x-ms-traffictypediagnostic: VI1PR05MB5341:|VI1PR05MB5341:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB53411BA91523A5A8CD3E7BBEBE4F0@VI1PR05MB5341.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6430;
x-forefront-prvs: 02272225C5
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(346002)(366004)(396003)(39860400002)(376002)(199004)(189003)(476003)(102836004)(316002)(99286004)(66476007)(15650500001)(8936002)(14454004)(386003)(2906002)(6506007)(52116002)(110136005)(6436002)(6486002)(66556008)(54906003)(2616005)(66446008)(478600001)(64756008)(66066001)(66946007)(6636002)(5660300002)(486006)(50226002)(81166006)(71190400001)(71200400001)(7736002)(186003)(305945005)(81156014)(36756003)(25786009)(8676002)(4326008)(6512007)(450100002)(14444005)(256004)(86362001)(6116002)(3846002)(1076003)(26005);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB5341;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: JmGBa+jGlm1PIfiCeDpwvTPhT0Nlf3u4/fgRDgTkcbBpspWafpS1T16l7EgA3vs4T/ca6MynrdkjeaZNkoE9q1Gtnr7boYsjnlqdnOMgBCdhB7bnaYmz7mZkZS6pcM5/2IzUU3LY7QLhzWk4Ecfa5ntJlUbilWWC9ajwLsex4effjlmLCqbefiHzw/T69JFCanpZdFXr+7HcUmdUU/KJJOgDEhLPuRn7djKW93/5qzquc/1Z709qmKwsYh6GMNLMZJaR1EHUdkfZau4oac5JLez5XbrsUZp6Saeae61cvNFstp8SJYed6MaJya3DlbUEn7hBI4lYdgrcvFjfTREgWOYuDPHNlXZyfNRLR1+R75aHz/K77duWtMxR6MXypCKFZRT+XZPgd6a04bkchKyUbphD6A83gTcqe2kCPE3Ds+4FW7P0YaVV3kQ18IxVQbPv
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5302b7cf-5952-4849-b723-08d76e081c27
X-MS-Exchange-CrossTenant-originalarrivaltime: 20 Nov 2019 22:22:21.1130
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: JCAm8JHjamrSx8NKORKmjnXTYQ2DdRU6XWQ+HC1ZP3LTJEXnbDaO0BMtFV1Ox0TjpMMYJDGyMVaT4JDdc3MP3Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB5341
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This series adds misc updates to mlx5 shared header files and, to include
new HW layouts for registers that are going to be used in upcoming
submission to net-next.

From Aya, Resource dump registers for devlink health dump.
From Eran, MCAM and MIRC registers for firmware flash re-activate flow.
From Leon, Don't write read only fields to vport context.

In case of no objection this series will be applied to mlx5-next tree
and sent later as pull request to both net-next and rdma-next trees,
with the corresponding features on top.

Thanks,
Saeed.

---

Aya Levin (1):
  net/mlx5: Expose resource dump register mapping

Eran Ben Elisha (3):
  net/mlx5: Add structures layout for new MCAM access reg groups
  net/mlx5: Read MCAM register groups 1 and 2
  net/mlx5: Add structures and defines for MIRC register

Leon Romanovsky (1):
  net/mlx5: Don't write read-only fields in MODIFY_HCA_VPORT_CONTEXT
    command

 drivers/net/ethernet/mellanox/mlx5/core/fw.c  |  15 +-
 .../net/ethernet/mellanox/mlx5/core/vport.c   |  27 +--
 include/linux/mlx5/device.h                   |  14 +-
 include/linux/mlx5/driver.h                   |   4 +-
 include/linux/mlx5/mlx5_ifc.h                 | 162 +++++++++++++++++-
 5 files changed, 193 insertions(+), 29 deletions(-)

--=20
2.21.0

