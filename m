Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D87C1261330
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 17:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729422AbgIHPHm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 11:07:42 -0400
Received: from mail-eopbgr130087.outbound.protection.outlook.com ([40.107.13.87]:37001
        "EHLO EUR01-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1730232AbgIHPEW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Sep 2020 11:04:22 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ntVbhHG721DYafag0iExAVtCGNaQPl9s85DSkL4GCtewQtbQ4SDA/WTNvn/sBE6lrWzYW/U7RU4mf4Pal69prjQjony7PVv0NamxTI5KPjPajHu0GA1VXhIhD1nhzd56YG5n8PVSgcezQWQZf0ts1SOyrQMG4MFS/4eoCQWJXA6LFXPj1gpwSQ4EzaSLIaI/7z0z92Vgv+QxkW+WlLPcJrxTUsceb8hOQkUUzMkh7yzNY9wC13LpVm5s4xlzcTzCoAMRuFRfzO2bDEpBeJFxl8wLPgeI0DT1jovaivUJlwYTxPmFiV2W0gvA1zrcWcTP4y3+rQ24yaWlW3nN/jdItw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUT/27PDKkI0NfoeAfOR1z/6TCNH+IYwpmLalCWiyIo=;
 b=TMCojpgZpe5/jovRcEkclbhcEXLtAGTND6fXQM1GuCoV3H+x0DafCo5MSTC5ETxdXFag/JJxK3uvUn15eOcjHFzNT/P5rMTa+dfSniU1d52x7JKZm2y1ZG4ZIIq+DYL1DRkc4JbLeYTfNieDo9OvY5YEjWuqJVjRetwgwXH4xevwEOnHgQSZUezPcWmKuwJfzn/yrBr7hGInECDQG7QJMQIS5tVxB2oTQgwUw74ANgU1XozKDb5Jruv2pz2XmMMQhzomfqoKPR2xWv6dWKOoGnjhAf4zERA6EiMGkOavkPJyLf9MoSP2vRx3OJNamVMouVr1n0OYKfRdAARqYxogJA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUT/27PDKkI0NfoeAfOR1z/6TCNH+IYwpmLalCWiyIo=;
 b=Tk6WCo51sDAJcb6IipB2Pd1pyx0+qDb/d1SuFd9TImp9A2ZFcKa4IUa2thymtNyHZI05/4YaaIMhgRgQcdgy4G0tpMjXNKcfWwo1CkKTWiCGpL104ewvSyFYxKPKFWX9tNKPl3eRh70NB4/9f2ewq2EPGIf1hiK/21klIL/Gar4=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR05MB4353.eurprd05.prod.outlook.com (2603:10a6:208:67::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.15; Tue, 8 Sep
 2020 14:43:15 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3348.019; Tue, 8 Sep 2020
 14:43:15 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v2 3/6] devlink: Move structure comments outside of structure
Date:   Tue,  8 Sep 2020 17:42:38 +0300
Message-Id: <20200908144241.21673-4-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908144241.21673-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
 <20200908144241.21673-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SA9PR11CA0020.namprd11.prod.outlook.com
 (2603:10b6:806:6e::25) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SA9PR11CA0020.namprd11.prod.outlook.com (2603:10b6:806:6e::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Tue, 8 Sep 2020 14:43:13 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 43ec1440-5ed2-497b-e285-08d85405846b
X-MS-TrafficTypeDiagnostic: AM0PR05MB4353:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR05MB43539C22C6FF14FB746A9247D1290@AM0PR05MB4353.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: zwxv5jDyxvOKKYyPWz2IxsWXu0xKubg5LerFOAHQiacFThsnI/bsElhGAeuaa4L966jWPBhYC/4m48msTF6T/vKkmXjOqn2CvAChjRLgAVvkXqr8Heugn4bRGgtDbAbpVU1AEpHVkWUum/8AVTsCg0INRzNahaZVdQcnaO/AC6cxTTdIK7OgIEf80GxiIlHlDfrAkNuVwD2A2cFg7wrAb70omeT039/OqfJ/z3uVK89fAnVtJaZEvLZyNjR/zaCtaTXt/1sCvFEk1MWKsYKsLjkVtVfVNDVm1JCjtoqo3r5iRrmLVi/gwsARE+9Lwaljl7L+/alQvlHtOxnQ+fSpCw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(6486002)(6666004)(498600001)(26005)(1076003)(6512007)(6506007)(86362001)(4326008)(52116002)(54906003)(5660300002)(2906002)(36756003)(66946007)(8676002)(83380400001)(66556008)(66476007)(956004)(16526019)(8936002)(2616005)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: ph02zm1EGiV9zrKElISDfXzZAz9I9mFYtqZJ2i4CrVjRLghjOM+0Gjo0sen7xlwFVP3GJ1quQyIdR+x2XeBkru56ehFDXrjUJlMQ20uLUl9gB33KsJ6IQNwuisUs91H3n0XBtHGqXJy8K1P8PecNkRovt6reZ8d0JkIiuyWdKbIEkx17BovPX1CxGjiPAs9ypFNxND4uUF2iyaJfSfo9Zj0gsPeOqtBve0IxMTJ0Amh8BHVuyPd3Y2+gN3oS2ct9QohxEam/nJ5q8kXM7wUl3LsBxkb/Wt45icDE73hxmBSNVc9rs5ga8GhFUtTEnppnGTIwKdJykF029SJTyGV8DLj+d94NXZJkjCjGFdL+b4aUQ+FWjhdiSQE1X+jsiPnH5VOCWYD9ZzwG71sBXAHmUa5mFovxJ+YeHJ15KSgEldpcgNDKNAoo6g1awgC+/zjXlx0am4uc7XCLeKRGUa5nurdnOeg5tKP/ETd9rx+C3kuvfctYoJHR+BolBc8Vq89+SYva4A6TZg7zwnPG1BWF/NoC8Q2QnsLqacKd+VkXYpemN8OwliyvvH5bPjtW1lzT8VcD0BWZzQih18pKBGxEHjTy9CeOHf8SS3kwyyG2d7332meapvYcKVvclcLIaDpFKDd5g7gAR4A0QW2ShK/20g==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43ec1440-5ed2-497b-e285-08d85405846b
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Sep 2020 14:43:15.0465
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +PMLO4gB+T6eHNpPXS2z+4GFl6+JUGY50CLgvQjmzhtBAhCx9LbfdLZobU1NYcGQcx9FxYFFMJv3VTJw5u+GLQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR05MB4353
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

To add more fields to the PCI PF and VF port attributes, follow standard
structure comment format.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
---
Changelog:
v2->v3:
 - New patch
---
 include/net/devlink.h | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 3c7ba3e1f490..efff9274d248 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -57,13 +57,22 @@ struct devlink_port_phys_attrs {
 	u32 split_subport_number; /* If the port is split, this is the number of subport. */
 };
 
+/**
+ * struct devlink_port_pci_pf_attrs - devlink port's PCI PF attributes
+ * @pf: Associated PCI PF number for this port.
+ */
 struct devlink_port_pci_pf_attrs {
-	u16 pf;	/* Associated PCI PF for this port. */
+	u16 pf;
 };
 
+/**
+ * struct devlink_port_pci_vf_attrs - devlink port's PCI VF attributes
+ * @pf: Associated PCI PF number for this port.
+ * @vf: Associated PCI VF for of the PCI PF for this port.
+ */
 struct devlink_port_pci_vf_attrs {
-	u16 pf;	/* Associated PCI PF for this port. */
-	u16 vf;	/* Associated PCI VF for of the PCI PF for this port. */
+	u16 pf;
+	u16 vf;
 };
 
 /**
-- 
2.26.2

