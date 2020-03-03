Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 740F017692D
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 01:15:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726942AbgCCAPq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Mar 2020 19:15:46 -0500
Received: from mail-eopbgr140089.outbound.protection.outlook.com ([40.107.14.89]:56068
        "EHLO EUR01-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726752AbgCCAPq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Mar 2020 19:15:46 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IPEriEc+XV4WiozyO54bHtpCY6leMJjloOYptskOtDKaI9VvbzYl8J3mug1CCfReQ9vZuSFTTa4ndEUWgwdwk/KRwqaTSlweSnwEF8yR12vTGArwXqkxJqz3Cmrq9+xQ0OMeKSSDiD1mAAo4VaZ2flWOvh1o7ZxvwkkIRKM6WJrkZqcnUprm7WzdztfTuQOwkloPmghQseNl0ybQe6BCFBD175Vsa8ZKfUBRkPiAygbBHbe9TVO64lUIUj/IfDb+6o67I2Fee9QyLOGVzo3HUgexeaGYXsxMnUyoCMVhyvpkE+LenD/fq2BWfxl1+FG4MfXMBVhZD9WKUvAV0qacJQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0txpnFbcz//geZkKV4YNZzNjCuNzkLoH2BhYJDoJ/YU=;
 b=QEio904VggQ3iqOyWTxNycwv43qMaaOxSkBp/AOKT7bV2wLqWVIiRZO6BOUAOB/5J+LlEltOQv51CP8wO4iuELan6SyqsnbXa+DHJnZzSbIhKCSMk7ic0k4ut1jdGQuD6UMyHiXVu6L0vvH4vCU9eoOVUVt8ehVmc8NvVmN7mFZsuhBtlp597tTv1y+OcsdFWhu+bSYkfduo8tQm7OFMQA6XYotFnYaVRfj+BTjPIEq5blJZi+MpIRomn8oa1FBEKqBBYd7aMTl5ELLqrVEvEAJEcy69K9TnfiCDD0HWMcfjXdQZn+/Eyr7B3YB6kPGb2Sqd/sN8jGA39e6bPwxNdg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0txpnFbcz//geZkKV4YNZzNjCuNzkLoH2BhYJDoJ/YU=;
 b=p8kcxBajd1jKmCp8Sq4o8JhcagjTnWBctXGuCgLyBy3cqdGuJqujjCnolPBN876hYY2GaKHufJBg2G4iyy04Ar5eJSKcHcoxA4Lris7L276cS0lbBIzU6VlvLRBeGqjRTzIfE+T6g6qFRiq3IYE19GHlJHyRKKyH+DVgICCo/To=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=saeedm@mellanox.com; 
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com (20.177.51.151) by
 VI1PR05MB3166.eurprd05.prod.outlook.com (10.170.237.147) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2772.15; Tue, 3 Mar 2020 00:15:42 +0000
Received: from VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2]) by VI1PR05MB5102.eurprd05.prod.outlook.com
 ([fe80::8cea:6c66:19fe:fbc2%7]) with mapi id 15.20.2772.019; Tue, 3 Mar 2020
 00:15:42 +0000
From:   Saeed Mahameed <saeedm@mellanox.com>
To:     Leon Romanovsky <leonro@mellanox.com>,
        Saeed Mahameed <saeedm@mellanox.com>
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org
Subject: [PATCH mlx5-next 0/4] Mellanox, mlx5 next updates 2020-03-02
Date:   Mon,  2 Mar 2020 16:15:18 -0800
Message-Id: <20200303001522.54067-1-saeedm@mellanox.com>
X-Mailer: git-send-email 2.24.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BYAPR08CA0018.namprd08.prod.outlook.com
 (2603:10b6:a03:100::31) To VI1PR05MB5102.eurprd05.prod.outlook.com
 (2603:10a6:803:5e::23)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from smtp.office365.com (209.116.155.178) by BYAPR08CA0018.namprd08.prod.outlook.com (2603:10b6:a03:100::31) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.19 via Frontend Transport; Tue, 3 Mar 2020 00:15:40 +0000
X-Mailer: git-send-email 2.24.1
X-Originating-IP: [209.116.155.178]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7ba483ff-ec1f-42a0-9a99-08d7bf080255
X-MS-TrafficTypeDiagnostic: VI1PR05MB3166:|VI1PR05MB3166:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR05MB316679A6AF9F2AC649DA8927BEE40@VI1PR05MB3166.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-Forefront-PRVS: 03319F6FEF
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10009020)(4636009)(396003)(136003)(376002)(39860400002)(366004)(346002)(189003)(199004)(110136005)(316002)(52116002)(6512007)(6506007)(8936002)(6666004)(6486002)(36756003)(86362001)(81156014)(81166006)(8676002)(1076003)(2616005)(16526019)(4326008)(15650500001)(450100002)(5660300002)(4744005)(2906002)(186003)(956004)(478600001)(26005)(66476007)(66946007)(66556008)(7049001)(54420400002);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR05MB3166;H:VI1PR05MB5102.eurprd05.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fgO7zWhJ/RH1QBbTxMwfqe7StyUNwNlxU5BGOkdaZUbcROd2SGhti1adB9bjfm9+s40VmrCRUQRASrd5zepEsqVNuJqilfWdL9D44AcxJ8qKqtPv40HVZhunOQ072imxYNpr33t5cXIE005Tb7JsxILwoauAyp4hAShc5tVJN9HGhne9R/5a/ZLEzst15WZxyFvzYJrhWB07QXTBYwS5Xh7zwNl/D1UWmGJBjOH6PDX7fUmc89LDhOqkBCcuY0jCYWY+WlqVektIDf8ORD/9ezejiJy0khaBMcD2JJYR0CNGHO/K03i50jKv0eFxsAe7PARntsUCiqRGQsN3ssuw1TPAxBQjrCAdqPmZl/5oVGtF00DjIkSTGKpGa6NZGkZOEf1frSk/4AF/j86eY59nZz7r+1Hae24Ekl3cpx7LbSu7FlGvyrUtYp2s3lIv+lvduZpyzmhXOzj6qQd1WMzjfov0lnsBqDECtOGzctnrYRpn9nRo2DxdtE9tfSzsLDzDdNywjms9Ih48U1r3ZhiravKhfeCYbluv/yFz5AfqX3M=
X-MS-Exchange-AntiSpam-MessageData: qumvnWmCFZt4ZlqXnuTsvxfasdCv4vjeigif2/8UrgP/wBLMHYBWe7B58wSJ7zXYpV39+K38q008zcL+niDzwv8bTVJbZxiViuiDkZwLcKW2qODj/LfTzXD0Ua2k7Vku45gcb7EAj/evIDn5kIqdAQ==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7ba483ff-ec1f-42a0-9a99-08d7bf080255
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Mar 2020 00:15:42.0500
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0wypoCMSmZZpetLMhQ5CYmju0FBn4QqPogFMcOygYbib7RZ27w8QSDDFOJBrCWWy/vKPtn5fT5Xs+av02iiivg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR05MB3166
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding some HW bits and definitions to mlx5-next shared branch for
upcoming mlx5 features. 
Nothing major, for more info please see individual commit messages.

In case of no objection, the patches will be applied to mlx5-next and
sent in a future pull request to net-next and/or rdma-next with the
respective upcoming features.

Thanks,
Saeed.

Eli Cohen (1):
  net/mlx5: HW bit for goto chain offload support

Mark Bloch (1):
  net/mlx5: Expose link speed directly

Saeed Mahameed (1):
  net/mlx5: Introduce TLS and IPSec objects enums

Vu Pham (1):
  net/mlx5: Introduce egress acl forward-to-vport capability

 drivers/net/ethernet/mellanox/mlx5/core/lib/crypto.c |  2 +-
 include/linux/mlx5/mlx5_ifc.h                        | 11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

-- 
2.24.1

