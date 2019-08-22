Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8582D9A153
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 22:42:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393317AbfHVUli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 16:41:38 -0400
Received: from mail-eopbgr80079.outbound.protection.outlook.com ([40.107.8.79]:41706
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1731895AbfHVUli (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 22 Aug 2019 16:41:38 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lylhOlgaWOomiSjkhu6YjTNWB7KmhktFB5zwDTIx4YKDksF6IhwVNy1Hz7HRTry3Sez6sNEDdoa65ZmyJV5zJBa9Xbypd3dzuiBkPOTB9em1mzpPL1vMdgrg3OOVhLAkB5vF/qLK+RgXecdOYdZ9AGRHeBBlLzl1m/6hU3WZzqR1/hsxNyS+lchgrM0dP9yuHscqJ54mMysR4BeR9yxievDYL0YIQmDd+nW/2ST1OweZtLolOLrWIo1i6G3nY4NSApkVhfQX4CquIAJFZroqQ+uR2IujEfdAhn/pibgO2YRhJJiZZCClwCmXxuzK5Arop3VXV8KkwCPgKRGqnh5sQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPVn3m8hQGhOmaVrlLEBHWyG59K7oS4iAE9EeKC21ig=;
 b=fvpua8OtsK1Wf+UBSWEoLSVg5lDYqzhpQD8HGiBuey5BQyzJuUt9eJED2ly9zZuBWuwuzmjqXI/D/PwH+T9KdbIIQCclDV4KT0t0KJcYYHVV884roadvGbhw47oL8279+15ixNUmMV5rHQCZJbLxjz9xTVKyk4seG4NyGVdyjs/ri4/gHoRj1suHVR5olaQnurVxunj9BNOBkQsAkEJ6uCsoDPiTRzXq/XgckiOId+8Bq2ir1Wmhvysz5jrOYF4wLlTKXgsnNp/AfQKwG2N0pDkjnwCVasKVSlcFxFFp7bo5J/DuTunt0yuRXFttO/QblxqKxJyr0NpIcDHWqlDcPA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GPVn3m8hQGhOmaVrlLEBHWyG59K7oS4iAE9EeKC21ig=;
 b=hxVbptC7TLDVB//k8AW8f5G7XydsrA0zpSzEjrP00vahxFa0lstT+2kgiRCEoIFkFL2pWO/pZZP3CoJlO1gx+j/kSoKBD14AYAuTGxFTeK6YM4gVsOFYoDgVX7xJ4SwxsX6BUOnqFhsD7AYA5QUY2ASfP5/h8ehhUTu25cag/HU=
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com (10.172.216.138) by
 AM4PR0501MB2724.eurprd05.prod.outlook.com (10.172.221.144) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2178.16; Thu, 22 Aug 2019 20:41:34 +0000
Received: from AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a]) by AM4PR0501MB2756.eurprd05.prod.outlook.com
 ([fe80::e414:3306:9996:bb7a%4]) with mapi id 15.20.2178.020; Thu, 22 Aug 2019
 20:41:34 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     "David S. Miller" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Saeed Mahameed <saeedm@mellanox.com>
Subject: [pull request][net 0/4] Mellanox, mlx5 fixes 2019-08-22
Thread-Topic: [pull request][net 0/4] Mellanox, mlx5 fixes 2019-08-22
Thread-Index: AQHVWSn8qHTvCKIWmEiPkAzEMFcpYQ==
Date:   Thu, 22 Aug 2019 20:41:34 +0000
Message-ID: <20190822204121.16954-1-saeedm@mellanox.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: git-send-email 2.21.0
x-originating-ip: [209.116.155.178]
x-clientproxiedby: BYAPR11CA0085.namprd11.prod.outlook.com
 (2603:10b6:a03:f4::26) To AM4PR0501MB2756.eurprd05.prod.outlook.com
 (2603:10a6:200:5c::10)
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 7814a57c-6d13-4399-77e5-08d727411f1e
x-ms-office365-filtering-ht: Tenant
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(5600166)(711020)(4605104)(1401327)(4618075)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(2017052603328)(7193020);SRVR:AM4PR0501MB2724;
x-ms-traffictypediagnostic: AM4PR0501MB2724:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <AM4PR0501MB27248C60A6AE88F5F876DF51BEA50@AM4PR0501MB2724.eurprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3968;
x-forefront-prvs: 01371B902F
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(39860400002)(136003)(376002)(346002)(366004)(199004)(189003)(36756003)(316002)(54906003)(478600001)(476003)(66946007)(64756008)(8936002)(81156014)(50226002)(66556008)(8676002)(81166006)(4326008)(66476007)(486006)(2616005)(102836004)(66066001)(386003)(1076003)(6506007)(7736002)(305945005)(5660300002)(66446008)(26005)(6486002)(6916009)(71190400001)(71200400001)(6116002)(53936002)(256004)(3846002)(14454004)(107886003)(186003)(25786009)(99286004)(52116002)(2906002)(6512007)(6436002)(86362001);DIR:OUT;SFP:1101;SCL:1;SRVR:AM4PR0501MB2724;H:AM4PR0501MB2756.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: TWwyRWkddfRlbdq1Lwy5AFyxhcUR20P58YtJg+S6O2UTAZTNeHDS7JJvPCYqDYGs6MGE7QyNY5INxxLtX3LhcTyRXCYSzbQq8K8mquFFOSLoH+jY/i6PlL8o1YOvOwi5umnXXzBvKs8Wj5uN4tYYnB2eVMuitoKgaSbezsc8hTpS1MTlNzjylzFSzaTf+JFOJUZWfBSRLypqwzbcOyeMHcofihJmKxcCnUy4YuFr0v8ISUPkvxIxZoyAgrtooQZnFiJSZj3l2dVEIwHufNljKjSeW4ItxlnkPpOWN1zfvcFA1BcyM6oPCb33yOJOp5Vt+1JQ8frPjmWKLyuhhkgH7MukwtLetA0vesqkU0bYwNaJFr1vu5TUPsa7KJ2PgkDkSbRJqBrODoKdSPyvJJhth7KrA6EwG7a5U4MSgsecgSE=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7814a57c-6d13-4399-77e5-08d727411f1e
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2019 20:41:34.8150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 1ESalNSus7blhy8SUQjd/Yz6GLqzMEkU4Y+wMNkVP/en+cpB9hNdA0Zj0dxmMZo3g1C6dumIP8zU9WxI8wVkHQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM4PR0501MB2724
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Dave,

This series introduces some fixes to mlx5 driver.

1) Form Moshe, two fixes for firmware health reporter
2) From Eran, two ktls fixes.

Please pull and let me know if there is any problem.

No -stable this time :) ..

Thanks,
Saeed.

---
The following changes since commit cc07db5a5b100bc8eaab5097a23d72f858979750=
:

  gve: Copy and paste bug in gve_get_stats() (2019-08-21 20:50:26 -0700)

are available in the Git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-f=
ixes-2019-08-22

for you to fetch changes up to a195784c105b2907b45fd62307d9ce821da9dc20:

  net/mlx5e: Remove ethernet segment from dump WQE (2019-08-22 13:38:48 -07=
00)

----------------------------------------------------------------
mlx5-fixes-2019-08-22

----------------------------------------------------------------
Eran Ben Elisha (2):
      net/mlx5e: Add num bytes metadata to WQE info
      net/mlx5e: Remove ethernet segment from dump WQE

Moshe Shemesh (2):
      net/mlx5: Fix crdump chunks print
      net/mlx5: Fix delay in fw fatal report handling due to fw report

 .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c | 38 ++++++++++--------=
----
 drivers/net/ethernet/mellanox/mlx5/core/health.c   | 22 +++++++------
 2 files changed, 29 insertions(+), 31 deletions(-)
