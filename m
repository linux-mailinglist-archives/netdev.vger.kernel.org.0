Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C40EF5BF5
	for <lists+netdev@lfdr.de>; Sat,  9 Nov 2019 00:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727148AbfKHXpX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 18:45:23 -0500
Received: from mail-eopbgr70072.outbound.protection.outlook.com ([40.107.7.72]:11398
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726227AbfKHXpX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 18:45:23 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UKUfys1Q6dJ1V2aE2ip0Kfm3bYNXzeXVmDOeK58D0kyE5DOtNQ87KXpPNldJEkX13AwHNXdvK0TKHmnrQmRcNv24o6HLzwzd5n5R2ckSG67/DsxBC5Ondmbg5DXDMvwp8siqrRUyX5VcWaDPJnXJ1PRwBhuFbtVvqJ00QCuCDoXIGWUHUWiKfwRmAFE+KgaeOPyN0RT3AA3trmoCqDCpjTTl0M/YFtCKOtCNBfoabFp76U6KH0BkRwv5+ZmGVKYPUbE5KlpJ6dq3KJmSFQA7YaEp7mMYmwQ5L1HJyNvXfRzH6mngQp63Pgt7I905+6TQkl6fnxiLaTD3VR5aIhlpEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8GCrlNU+8x7qv3Pu8JSN2u9XdEAIRRhpmcnL0R+l3k=;
 b=UNb8M9Aj8vfLq4q2IdIBt2NIgEWsBYKGHcvw2kMLDo2zpbwaJMGbhQBfiBo4hv8DivyU+hyrSfdBJE5wKzi/q0CG7mjx3CGcxU6JVUTzRAyf4w3YzXAiVXZ/xsPNqOllmrVEl/UMhlYlAINR8bjRLcjOSfcq1ibS9i3i5UNCzqUztgIVm6sDrWlo/t2RvK467H+5rzYMfq1HhURO+e1Ya79JI0bsqxrGOPvLCCpUCEXtWz1s0X3EhlTGGHrt5aYcISGtjKcmWHcdZ1cBSTDQAmImd+z8Wa0XR1k9t2LMjSokmXJRRSTE+bCWYtDs15xrapuoK4BlmYJPnavxvKpLYg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=n8GCrlNU+8x7qv3Pu8JSN2u9XdEAIRRhpmcnL0R+l3k=;
 b=Wo57puq/9/SuatKFNh77T2WZqSm8NDhUrPMN2P/rqcYUpNVihZ/DFc4ErgOGMIncEohQ2FXwWyc/ST0HDczcemOQyGQ1zKTN4tDYbsJQyVodCjHMWlvGcKf2GzBWFKADO4VYEs8Wn/9YTo4wtMEAVrhe93E1MozO+R885dXnO2s=
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB4334.eurprd05.prod.outlook.com (52.133.14.30) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Fri, 8 Nov 2019 23:45:18 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::d41a:9a5d:5482:497e%5]) with mapi id 15.20.2430.023; Fri, 8 Nov 2019
 23:45:18 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Saeed Mahameed <saeedm@mellanox.com>,
        Leon Romanovsky <leonro@mellanox.com>
CC:     Jiri Pirko <jiri@mellanox.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Subject: [PATCH mlx5-next 0/5] Mellanox, mlx5 roce enable devlink parameter
Thread-Topic: [PATCH mlx5-next 0/5] Mellanox, mlx5 roce enable devlink
 parameter
Thread-Index: AQHVlo6Tcf69cInxPkuJQUqWBpS4Rw==
Date:   Fri, 8 Nov 2019 23:45:17 +0000
Message-ID: <20191108234451.31660-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR21CA0030.namprd21.prod.outlook.com
 (2603:10b6:a03:114::40) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: c74c87f9-ff52-4d1e-afe3-08d764a5b599
x-ms-traffictypediagnostic: VI1PR05MB4334:|VI1PR05MB4334:
x-ms-exchange-purlcount: 1
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <VI1PR05MB4334B3E0D74174EA491C5A10BE7B0@VI1PR05MB4334.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 0215D7173F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(346002)(366004)(136003)(396003)(376002)(39860400002)(189003)(199004)(53754006)(2616005)(102836004)(36756003)(450100002)(52116002)(486006)(71200400001)(1076003)(71190400001)(6636002)(14454004)(4326008)(966005)(478600001)(110136005)(256004)(66946007)(25786009)(66476007)(66556008)(64756008)(66446008)(86362001)(5660300002)(316002)(6506007)(6116002)(8936002)(50226002)(3846002)(186003)(6436002)(6486002)(81156014)(6306002)(8676002)(26005)(14444005)(2906002)(305945005)(99286004)(6512007)(386003)(7736002)(66066001)(54906003)(81166006)(476003);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB4334;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: xSaukwSdGIJ4ZHCzehf3DAuOhLfhvsqOOpMNVnymo6/EAMVrPlwPkB5Wu7WaLrs4HF9lR7Yi8wqFpkt8k/CMOq+RjQMO5UTdh4urS0C3jFO1N5O7sxIjvKFZodNHCEf8VI5R00+D2mnRWxsbaUSnLw5eR3ck3sXxM240WcjuYnGxmEfHD0B4devb6pEhYQjw1dZu/EPEhnAsjh4rkKHzj+qfWZZXJKY9R3OkoJmvH2JuDsdiJu50fvcpXCBUYRvcECVwrXZJmdGSmPeun0oBdISZh7CaKG9d2DMrvFDs7EgO+4R6Yii1uz+ToGUuT/971Q0AJ0Fv0ALuCtafPrfTuTir3vNb96IeGZPglo5ib3yxQYkjAW2Lrt2zEI+qdelQaCdEj6Pmfc/KZOwPkderp4+95C0W8wRG00SBlV/RyelSQOChtFH9WEJuv+3a2fI+OmVbPS62G1mz/KoccmllqakCGJ0AtwY4x9eEKourR2Y=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c74c87f9-ff52-4d1e-afe3-08d764a5b599
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Nov 2019 23:45:17.9061
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ZohH+QqsH9yhr4VqEnbh9qedndP1f2PeGbrYD+ZxBAb1eRzwo61iPcOV29FPStY1YdsIxQ8cqPFQfVCk5a7PJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB4334
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Currently RoCE is always enabled by default in mlx5 and there is no option
for the user to disable it.

This change introduces new generic devlink param "enable_roce".=20
User should set desired param value and reload the driver to get
desired configuration.

Two options for reload:
1) reload mlx5_ib driver.
2) reload via devlink, once the devlink mlx5 reload support [1]
lands in net-next branch, after this series is applied.

mlx5 devlink reload is not part of this patchset since it depends on
changes from net-next tree.

RoCE will still be enabled by default after this change.

In case of no objection this series will be applied to mlx5-next branch
and sent later as pull request to both rdma-next and net-next branches.

[1] https://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git/commit/=
?h=3Dnet-next-mlx5&id=3D0915d89b86e379b26457ba50656e9257193eaa60

Thanks,
Saeed.

---

Michael Guralnik (5):
  devlink: Add new "enable_roce" generic device param
  net/mlx5: Document flow_steering_mode devlink param
  net/mlx5: Handle "enable_roce" devlink param
  IB/mlx5: Rename profile and init methods
  IB/mlx5: Load profile according to RoCE enablement state

 .../device_drivers/mellanox/mlx5.rst          | 21 ++++++++++
 .../networking/devlink-params-mlx5.txt        | 17 ++++++++
 Documentation/networking/devlink-params.txt   |  4 ++
 drivers/infiniband/hw/mlx5/ib_rep.c           |  2 +-
 drivers/infiniband/hw/mlx5/ib_rep.h           |  2 +-
 drivers/infiniband/hw/mlx5/main.c             | 39 ++++++++++---------
 .../net/ethernet/mellanox/mlx5/core/devlink.c | 22 +++++++++++
 include/linux/mlx5/driver.h                   | 11 ++++++
 include/net/devlink.h                         |  4 ++
 net/core/devlink.c                            |  5 +++
 10 files changed, 106 insertions(+), 21 deletions(-)
 create mode 100644 Documentation/networking/devlink-params-mlx5.txt

--=20
2.21.0

