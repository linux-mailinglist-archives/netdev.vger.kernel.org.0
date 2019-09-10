Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3157AF2A9
	for <lists+netdev@lfdr.de>; Tue, 10 Sep 2019 23:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726043AbfIJVqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Sep 2019 17:46:02 -0400
Received: from mail-eopbgr60054.outbound.protection.outlook.com ([40.107.6.54]:37381
        "EHLO EUR04-DB3-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725942AbfIJVqB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Sep 2019 17:46:01 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=G8CZQPwZ3tzmGQh/qv+EQ8xVCcTa2CDH1Gj3NgcpHhIyC3/evQ9lBgGh8qrbyFFUOhZG8JBzo57xyfm8szSRwc6rIHOMJzHRAjpaW06uAdbwTXhVqu8W2HBqyjwuN7Gc/MUaXpWtkf5DDYYhvXL9UQMpy2jes8Q8jVkVTXDgjilFOTT3wkJARwdL5gY5GvX4fVPyt5Ods8kw86VQrBnW4HCrfIJNI+e5DNPcBfidfud3KzUltjpxBKR/RS7QKZOsbQkQKuKw70nf1N9GlGag0FIfd0UayYFGVOrNuVepkO7l+Nbo8nQ5M+gVGtr2gdu3S+sQuP0VmrGBaCf2fAm7iQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYlx+opC0i8Ao7GyTutxgnptUY1Ee0DxykuM6rTF3iw=;
 b=EmzLlqBOaQaS/68hOIwed6i8uvr/0Kf/RLeJzAEavuONS1FeCmOukP1uvopWbKG9jibWqR1D65WnW9bKtWQIWiSIjuZl4gy/iEsuZsu/8h8vnJC+V5kUTxSAhCwQpmfand5vuM1beTARzlpnXjv3TIwWsh0MRT1AAQxpwVhijr582jzAaaV1sbVrmsJvuQEGUH9ZYiefBRRU4imvtH35hZaK6hTVmRn6TiLHho6hc89zlMLDuGCz1ZhCuc5EwHRI1EJZSXfokVDQj4uSnbrDFRCJgseBBcduo4qqII6Y6gDg6n/VNOe4IpmMFTUqgcaBgPQ36zKTPMN+N8f0dRIe6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BYlx+opC0i8Ao7GyTutxgnptUY1Ee0DxykuM6rTF3iw=;
 b=Q0dOiIDLjanzkxO8lhhno6KjnB1nhGLI9AmdGHeqid2sE9JzZzrnWVXk30f0tV4dOgNvqF2b5AxNORSdkDS5Bmr9w+CY8raNl/iodotDINlWbOmelhnFOh06QSFJz4t7AEngzoFrCI+3D8JW56bFjqhhjf2tpceLkAFNc9WXQDA=
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com (10.172.227.7) by
 DB6PR0501MB2598.eurprd05.prod.outlook.com (10.168.77.18) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2241.18; Tue, 10 Sep 2019 21:45:57 +0000
Received: from DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43]) by DB6PR0501MB2759.eurprd05.prod.outlook.com
 ([fe80::f839:378:4972:3e43%12]) with mapi id 15.20.2241.018; Tue, 10 Sep 2019
 21:45:57 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net-next 0/3] Mellanox, mlx5 build cleanup 2019-09-10
Thread-Topic: [pull request][net-next 0/3] Mellanox, mlx5 build cleanup
 2019-09-10
Thread-Index: AQHVaCEhO9yAKSm+dEu/1qKabkFc7g==
Date:   Tue, 10 Sep 2019 21:45:57 +0000
Message-ID: <20190910214542.8433-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR06CA0058.namprd06.prod.outlook.com
 (2603:10b6:a03:14b::35) To DB6PR0501MB2759.eurprd05.prod.outlook.com
 (2603:10a6:4:84::7)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a2c37a7d-fc12-4a8a-2db1-08d736384374
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600166)(711020)(4605104)(1401327)(4618075)(2017052603328)(7193020);SRVR:DB6PR0501MB2598;
x-ms-traffictypediagnostic: DB6PR0501MB2598:|DB6PR0501MB2598:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <DB6PR0501MB25988AF244B94FBBCD26E780BEB60@DB6PR0501MB2598.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 01565FED4C
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(366004)(396003)(136003)(39860400002)(376002)(346002)(189003)(199004)(81166006)(102836004)(6916009)(5660300002)(8936002)(5024004)(256004)(6486002)(50226002)(6116002)(7736002)(99286004)(14454004)(36756003)(305945005)(4326008)(52116002)(6436002)(3846002)(107886003)(6506007)(386003)(8676002)(476003)(66066001)(53936002)(6512007)(2616005)(478600001)(64756008)(81156014)(486006)(1076003)(26005)(25786009)(86362001)(66946007)(66476007)(71190400001)(316002)(66556008)(54906003)(71200400001)(2906002)(66446008)(186003);DIR:OUT;SFP:1101;SCL:1;SRVR:DB6PR0501MB2598;H:DB6PR0501MB2759.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 8wgfmzE4IeC/QCillD7HSZH7IZoR8PDaO31RlaTZcH8SIjddZwl64XhQ6jaus1eluLpyP8n/x8B1blgQ+lDdzXrRRKkAZEmOozzn9j6xcCYjOkSyOn9VAjP2fkjWXs2LLhwzKyya+p7b1XFrYnn81Wp0F5l9M0+jD1pJVllYzmeWubkRHhC5Yoa3R9YyqpbGBQNJ0SlVBnObj6dGdC64+pypmHL3F1E2F73/yKzUQfX3N2Y7KZnX4ButRfqdBFmybZxLjsh3CKrziMT5QAh8gr0Q+GasBFFlc5DXskgkaxqseIhwiLf5j6qp8CBLIsR/9EdGvrv5wXzVUdEOdIiQCUCbkvnqdwav/8Ax5INU5xHzDg9ThINFHktHpXI0OxG76DE4BLUO7VA1gK01HoElENOwym+4MH5ZzOXt61f/ULg=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a2c37a7d-fc12-4a8a-2db1-08d736384374
X-MS-Exchange-CrossTenant-originalarrivaltime: 10 Sep 2019 21:45:57.5899
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 4ksGhX7GMoD/qW+4rSh3oB0UBi/p6MHpuX8tuxk2ewzzQw0bdJ98baLnPSIvuary5ggEFkf9BUk+ZaFzHrxbMA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB6PR0501MB2598
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series provides three build warnings cleanup patches for mlx5,
Originally i wanted to wait a bit more and attach more patches to this
series, but apparently this can't wait since already 3 different patches
for the same fix were submitted this week :).

For more information please see tag log below.

Please pull and let me know if there is any problem.

Thanks,
Saeed.

---
The following changes since commit 074be7fd99a29ff36dcb2c036b3b31a6b670b3cf=
:

  Merge branch 'nfp-implement-firmware-loading-policy' (2019-09-10 17:29:27=
 +0100)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-u=
pdates-2019-09-10

for you to fetch changes up to fa355bb1b0373e7fe087cfc830b1b0b9b6130388:

  net/mlx5: FWTrace, Reduce stack usage (2019-09-10 13:43:27 -0700)

----------------------------------------------------------------
mlx5-updates-2019-09-10

Misc build warnings cleanup for mlx5:

1) Reduce stack usage in FW trace
2) Fix addr's type in mlx5dr_icm_dm
3) Fix rt's type in dr_action_create_reformat_action

----------------------------------------------------------------
Nathan Chancellor (2):
      net/mlx5: Fix rt's type in dr_action_create_reformat_action
      net/mlx5: Fix addr's type in mlx5dr_icm_dm

Saeed Mahameed (1):
      net/mlx5: FWTrace, Reduce stack usage

 drivers/net/ethernet/mellanox/mlx5/core/diag/fw_tracer.c       | 7 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/steering/dr_icm_pool.c | 2 +-
 3 files changed, 6 insertions(+), 5 deletions(-)
