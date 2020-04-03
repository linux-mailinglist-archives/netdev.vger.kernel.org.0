Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4081619E145
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 01:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728712AbgDCXGF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Apr 2020 19:06:05 -0400
Received: from mail-eopbgr20069.outbound.protection.outlook.com ([40.107.2.69]:53598
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728589AbgDCXGE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Apr 2020 19:06:04 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GLJDHagkZheXOoKIkoKB7GuMybDeR70Ih4goVb/Jd1Qn+SdnPXZbfl84AZUpOpO1GMdAoEYRhrpM0wMRmFJ/FHn0MfBMytxkPMnRJLnXp00uDCrd4nLyrZe5dBXVqHCOIolzSILgat3ecH6lWCK9sE6fJRPHzS6naGuqdGxJI7jaSGxT8kc/e1QkrKRFuxDsuI6mlMGMcXvw7CG4YLiBCWvho/ZjZ8qMzXcuL6nUdU42hi4LE9QJxmTE3IgpWneFPpMpIUfcJ85La+YKUKOhS7kHzMLmEugTuOb0HZTbVFE11sQ7F+Sm3tqTTmdvz6oV3oU7RW89OYAKyIIH0T1cqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkCLE/16/oHyoGapVluiY7V6/Sfh/8p89aqDkkq7heg=;
 b=hXkb1Gc2hrdCu9hbov4bWi8kkonowntcpCVHDOWAn5M2RZm6DqSWUhrCfMnDGpbEqV4d7A3UVxDiavay9BCaIXR35xlnKFCRbaWfLwA94FBBDbm+Jx3UT29N5hLivBCvYZbBgBDgFtKWquOvO9bLk4zcYFBk6VtrgiGFSl0W4xGSjxAWtTbZQl8ZwIlAUskkiXR6c9XfMOZ4LjOd/SBLrf8JIJVF/unXwtAXCdBAEAyxfLQQCP/Ouirgp3dLSGvd0hVIBUDPBRqynlheMnltq1wozk6uXcz34W5gpOJkDkxVGp4OuqONaQzo0N81lccOOitFtPciJLwrkM7rS9u2yQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WkCLE/16/oHyoGapVluiY7V6/Sfh/8p89aqDkkq7heg=;
 b=B/4OJ6V6gX7DTKeXwaKCXorjDcbBXqetNApU33xDyNKSRsxfyHDgEPy8Yp+KBnkeSvoPn+1LMmen8rsH1g9aEg1hGTRfyoCj5IFkW/fZjXPyPApDIF5za2ZClDKMojAtjsOhabkeqVl1zj09JRac+/qmVjl7S4iOETCBQAqsB8w=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (2603:10a6:7:a3::22) by
 HE1PR05MB4652.eurprd05.prod.outlook.com (2603:10a6:7:99::25) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2878.17; Fri, 3 Apr 2020 23:05:59 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2856.019; Fri, 3 Apr 2020
 23:05:59 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Ido Schimmel <idosch@mellanox.com>
Subject: [PATCH iproute2-next v2 3/3] man: tc-pedit: Drop the claim that pedit ex is only for IPv4
Date:   Sat,  4 Apr 2020 02:05:31 +0300
Message-Id: <70688719f6ed31ad78c2ef92018851d3d706e5e7.1585954968.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1585954968.git.petrm@mellanox.com>
References: <cover.1585954968.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P193CA0039.EURP193.PROD.OUTLOOK.COM
 (2603:10a6:102:51::14) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P193CA0039.EURP193.PROD.OUTLOOK.COM (2603:10a6:102:51::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2878.16 via Frontend Transport; Fri, 3 Apr 2020 23:05:57 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 7589ff7d-e71f-4c7a-e8c4-08d7d8239244
X-MS-TrafficTypeDiagnostic: HE1PR05MB4652:|HE1PR05MB4652:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB4652041BD36417BFC3735AECDBC70@HE1PR05MB4652.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-Forefront-PRVS: 0362BF9FDB
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(396003)(376002)(366004)(39860400002)(136003)(346002)(4744005)(54906003)(6916009)(107886003)(2616005)(956004)(36756003)(86362001)(81166006)(52116002)(2906002)(5660300002)(8676002)(8936002)(478600001)(81156014)(16526019)(186003)(66556008)(6506007)(6486002)(316002)(26005)(66476007)(66946007)(6666004)(4326008)(6512007);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 8BGCQl6Z2EkfciPiCSOpRg4Ef/k2NpELoJpVWnCWG+usSBrNPUqypFbgpomkhixre5enGnhIDqGiSfpVfxVCwdDeGeBwcPuhE96T7e+K129867sPhnxnfbAVwTehFC2ueAzIeTCveGKmsabvsAqvXE/q0+WVwqqKLKXoNW+BC7uT7Tqksez/jE9YtiEhZG2dYfieTJKXXxzO/KHUUcKyD0HDxv+j7IpdKmEy9osgld6k//ClVG3Fuma4U/55kQrN0IbFjAWOoRz0eC19rWuyFBGHkTknzl2RQUkN02cAtS6kckvv3gj+YO1opIsKgiPzA6CAMvyx91cQfuS6Yw+8/EQPVO0KVNEP7WozzB9Fk4Nu63li1eaFjE7Z8MfEwRx+lTMxZLLaFXo+zLNBSeYcfoRXU/W8bTw10ZKAw5mgcdwgBDjRWcoHpLWhyKmWUYbt
X-MS-Exchange-AntiSpam-MessageData: t3cfcV8O4epfV072WMOLgEKNfKeZqNzxxiEg1vNRTsSZIl+DXmYZiAtKxKBlAvvs9XXuKnWvJYzK7ZQwNLxPPwLmhyD5EjkZTXL5HVaTonqCEFRWhErHFI4tVO6NT+F9h4h3xOtDIfJ8Tvx8mlFXpw==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7589ff7d-e71f-4c7a-e8c4-08d7d8239244
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Apr 2020 23:05:58.9666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 83q4eojFqLsOARKCk6uUr7q297eDm6y5Hbgwin3Hvd/KX3c9tCAr2mYLxvU9DyWt5lndlh8Ua8b11o/0rAv6sg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB4652
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This sentence predates addition of extended pedit for IPv6 packets.

Reported-by: Ido Schimmel <idosch@mellanox.com>
Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc-pedit.8 | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index d2b37ef0..376ad4a8 100644
--- a/man/man8/tc-pedit.8
+++ b/man/man8/tc-pedit.8
@@ -90,8 +90,7 @@ action can be used to change arbitrary packet data. The location of data to
 change can either be specified by giving an offset and size as in
 .IR RAW_OP ,
 or for header values by naming the header and field to edit the size is then
-chosen automatically based on the header field size. Currently this is supported
-only for IPv4 headers.
+chosen automatically based on the header field size.
 .SH OPTIONS
 .TP
 .B ex
-- 
2.20.1

