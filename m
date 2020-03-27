Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D574B195D38
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 18:56:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727575AbgC0R4E (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 13:56:04 -0400
Received: from mail-db8eur05on2063.outbound.protection.outlook.com ([40.107.20.63]:40096
        "EHLO EUR05-DB8-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726275AbgC0R4D (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 13:56:03 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UcbaHa5ugC1FY75uCTxTf+AVaECwvd8+9VyLsdIhr3308KqJpPOPB2Ne1C+kSB1uc2q+ea8QWwrvWxaV5ScDufgasgopGwGWFSNzksxxMkWjq7pudZ9sqhyhqWJhJ+HWzHuSrp7QN0olI2/Luq2O6WZxZtYSdr6fc2Vjjl8YmIZp1Mw83vzeyogd2lMTr7T0omf2/IfAbIkFecsaeO4/ZN+h+/Xcgua2bFaDa0MGFevmJNLg88FRiYXhETpsnEXoCKXfV+sr6mt+1Kg7aZ2vLULPt5L11aS9fJbLrbkBlCrVc8WwCuHDIiNWC1X/5Uuosyv2MNdiGdTJdBFMKs8iUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3EFswhgFeayjhVqdaDwfPgi1dBerinANSep2m/avzU=;
 b=M2DiUsTGOo0p1IKSF5oYC4N3XjgGENufeK3DSGnSF9oQMeBFOWAMEWESU91nN4qMOxAGbfxYMNOcse9dy+/qZW7ed+mqevBR7M3ZF3n0sYC3IXN1H86+pO6Ieqsum0qbwj4qgaBFyg9M4hL/KiaGHe92kLWKfYqqrd1szHIVu9uPSQ+TkQAM7dg8eiP6NFFbHaoWWlb7uTbfVO4NohOA2giul2jkI2uVal6MHtexNX/wbP1zbyDOeiohjPzKreyQUxS+39yLR/bYxem0NBXZd3eBY2oiH5/n/al5fXaisFckZK45yYTTz5Kyekt4fUpdZmLSKKwX+ByjrYgFCmvpYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=g3EFswhgFeayjhVqdaDwfPgi1dBerinANSep2m/avzU=;
 b=bLKFFAuN7CBv1DP2wdiYzm+/2636xh0Fy+2Dsg0wMqiE3jImPvMm7gkIZlivFBo+JVIlFWQwPcQR1OZMmUV2L4YU6juwFSKnr7JfVUhLZxW04d0pcPm7aP0bNlps8j1DqcNPEspZNa9tmJ8Oe3BisbKcQ2Rwk6zOswmU6h7xeuE=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=petrm@mellanox.com; 
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com (20.176.168.150) by
 HE1PR05MB3402.eurprd05.prod.outlook.com (10.170.244.16) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2856.18; Fri, 27 Mar 2020 17:55:57 +0000
Received: from HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b]) by HE1PR05MB4746.eurprd05.prod.outlook.com
 ([fe80::e9a8:7b1c:f82a:865b%6]) with mapi id 15.20.2835.023; Fri, 27 Mar 2020
 17:55:57 +0000
From:   Petr Machata <petrm@mellanox.com>
To:     netdev@vger.kernel.org
Cc:     Petr Machata <petrm@mellanox.com>, David Ahern <dsahern@gmail.com>
Subject: [PATCH iproute2-next 2/3] man: tc-pedit: Add examples for dsfield and retain
Date:   Fri, 27 Mar 2020 20:55:09 +0300
Message-Id: <837315b74b1fdfc4a08362c18f3a1544d8fe1092.1585331173.git.petrm@mellanox.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1585331173.git.petrm@mellanox.com>
References: <cover.1585331173.git.petrm@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PR3P189CA0019.EURP189.PROD.OUTLOOK.COM
 (2603:10a6:102:52::24) To HE1PR05MB4746.eurprd05.prod.outlook.com
 (2603:10a6:7:a3::22)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from dev-r-vrt-156.mtr.labs.mlnx (37.142.13.130) by PR3P189CA0019.EURP189.PROD.OUTLOOK.COM (2603:10a6:102:52::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2856.19 via Frontend Transport; Fri, 27 Mar 2020 17:55:56 +0000
X-Mailer: git-send-email 2.20.1
X-Originating-IP: [37.142.13.130]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 46278a22-8305-4a2a-af9f-08d7d2781a1e
X-MS-TrafficTypeDiagnostic: HE1PR05MB3402:|HE1PR05MB3402:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <HE1PR05MB34020C8AFE0704C2B27A6C9BDBCC0@HE1PR05MB3402.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-Forefront-PRVS: 0355F3A3AE
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:HE1PR05MB4746.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(10009020)(4636009)(366004)(376002)(136003)(396003)(39860400002)(346002)(6916009)(26005)(2906002)(66476007)(66946007)(6506007)(8936002)(36756003)(86362001)(5660300002)(81156014)(6666004)(6512007)(66556008)(8676002)(81166006)(316002)(186003)(16526019)(2616005)(956004)(52116002)(54906003)(478600001)(4326008)(6486002);DIR:OUT;SFP:1101;
Received-SPF: None (protection.outlook.com: mellanox.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JJ/21U1pX8klo97VkFdgj/8rgd7oqrGC1oeLd6D0Sg1oLPbv5NCZ4FyDoo0ohj+NpphYHcDATRz3ZN/iZN1mNsKZC2eRMX5fwvsZskCY3njY21BOogRxcEDgUnQrUz3xOvW8GxAgZB6WBNKyu9A/2yd2dp19Uqtn6TqOLswzHsCRKcDOeBsM32BjB/qkJmG1HTj7TdemUTORIxQUqGqDKzT1IzCVj5ZfEQDClfYIVDe0QOoCnXdK8zLEmUwE3p+LzCwslIvfyHmwDyI5bdywAy3yWAN4TcvKLAGyM657YDYCpes23yVI+gwvh5vMFowiF0GIpF5Dz41eMMIcNClmwfYH0r75Q8mbSZaMTJQ3C7/JdqGf9V7SEzXh4fGEDCUDBIvHbeJUVckUO6Y+RGMTgAsEMdHDXv16NHMwmXvhHrwgiSAx29ceJyR2h3XH4H/3
X-MS-Exchange-AntiSpam-MessageData: lcckmn/RxsdCqpVw3szZSwvcg0Lwo7ZHm1q5FdszmDohHVi7aGU4SxVuafZYgzUI0MfgWqsDVHLtCFTfzkMe7NZxA6RhV6MHIJgERng24Lp1+d7+CzzNofmEDoDbLqvHnhBWDskSrNyWh6nT2ttg+g==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 46278a22-8305-4a2a-af9f-08d7d2781a1e
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Mar 2020 17:55:57.5080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: MdkSLElhn1sdWRHqDThpPU3l5+6jZtwKQTRby5btYPcZ4qP4gP/yu4MjS1JlsQp/Hwsw2L4fNFtWkB2n92eERQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR05MB3402
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Describe a way to update just the DSCP and just the ECN part of the
dsfield. That is useful on its own, but also it shows how retain works.

Signed-off-by: Petr Machata <petrm@mellanox.com>
---
 man/man8/tc-pedit.8 | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/man/man8/tc-pedit.8 b/man/man8/tc-pedit.8
index b44b0263..54b91d3d 100644
--- a/man/man8/tc-pedit.8
+++ b/man/man8/tc-pedit.8
@@ -377,6 +377,28 @@ tc filter add dev eth0 parent ffff: u32 \\
 	action pedit ex munge tcp dport set 22
 .EE
 .RE
+
+To rewrite just part of a field, use the
+.B retain
+directive. E.g. to overwrite the DSCP part of a dsfield with $DSCP, without
+touching ECN:
+
+.RS
+.EX
+tc filter add dev eth0 ingress flower ... \\
+	action pedit ex munge ip dsfield set $((DSCP << 2)) retain 0xfc
+.EE
+.RE
+
+And vice versa, to set ECN to e.g. 1 without impacting DSCP:
+
+.RS
+.EX
+tc filter add dev eth0 ingress flower ... \\
+	action pedit ex munge ip dsfield set 1 retain 0x3
+.EE
+.RE
+
 .SH SEE ALSO
 .BR tc (8),
 .BR tc-htb (8),
-- 
2.20.1

