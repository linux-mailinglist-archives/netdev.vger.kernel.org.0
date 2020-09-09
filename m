Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C17E9262678
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:51:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726408AbgIIEv0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:51:26 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:57634
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725975AbgIIEvU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 00:51:20 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GFbvKyqS/G0os85iT+05vLz3b3NvJ37grra+077suXu6JNdxeHPyUQdBJqK8arn7srz4sSiFY/2WG0Or4iRrMBlA4rtt4WvsESpIBOmKima+rMmA5CY/UqHp2Z744KGKntLNHWPRMYx5vvUNs+o8kq1tb2sYneuGtfe+VHub8v2BNzTBeP8YrBPrb5aLwwF+2YyTKuQjGvgjeTdjJAeEba8Kl6iDCJO7TknoL/3IbANDh8BW1dGRFvG6Q+2Zuk7uKij6iB71ADSsbkS8MKukkZ/MizWBfKv2TG+uXO5pLujrLCTXWzvuD9ttEybR85ue9SNjD+ES6M9wzzm8hMuqPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8s0CFFPlwqqltQ9x84JqJN9AgppuA3KaOR0DFpKyI4=;
 b=dEdWyh/JljnGJCyqiMga6aBl9tVb44BQGAWJKUP8AA+RCyvZLaBLD1SrH0RsD/DA3wTF19P0iBlAi/0lb0JDrObCz2bX19cqSWLvaUDP1hv2G0xJBsV4/LKO+Nx9GYZuT3PrcJkregtCIANmCQTNZODy1+wAT74LWgowViRgOp54446lnlSWKRNEx3V/serqG3juktVL27G4EkdW+h9igfmWNThNKunZL1o6WaK8yjelDEcidRQ5Sy1u6BsgywGM/gCgFhY2dgB+i7YY+FBDBHcDVNeSMrdL++54R10Y7cc62ihVT3POeDKfiu9XGmle1+CRXXbayafm8XWrk2gDhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F8s0CFFPlwqqltQ9x84JqJN9AgppuA3KaOR0DFpKyI4=;
 b=LbW0CiBWXoNyQPhuhQaR0Xtabfij+IqfH5qz3QhsdZCEO4uTfp8idTcMsS9u+6PaU9O6hkbKEQYfSoa/iqjKKOAfUYNojQPc0h1TwovBCu0a42wQoYWW2MlQqjrNdcn1kPoC8DF8mEgtEoUDUxPMw6fSvNkPK1CiHDir/RqEFqk=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR0502MB3650.eurprd05.prod.outlook.com (2603:10a6:208:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Wed, 9 Sep
 2020 04:51:08 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 04:51:08 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>,
        Roi Dayan <roid@nvidia.com>
Subject: [PATCH net-next v3 2/6] devlink: Add comment block for missing port attributes
Date:   Wed,  9 Sep 2020 07:50:34 +0300
Message-Id: <20200909045038.63181-3-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200909045038.63181-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
 <20200909045038.63181-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SN6PR04CA0091.namprd04.prod.outlook.com
 (2603:10b6:805:f2::32) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN6PR04CA0091.namprd04.prod.outlook.com (2603:10b6:805:f2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 04:51:06 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: c0a7f676-7812-474e-019e-08d8547bf705
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3650:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR0502MB36502397C47DE0DB376AFC42D1260@AM0PR0502MB3650.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YzN5eQtHnWqf0MKI9w23Anjc+KI0qT5PpH34CFfx2jv05UkwHwWrLrTem3pzYQc0usvuo+Pse8XFzSE0RmaRDTPGtSpL0z9FsXXj2OKesRT5Q7Wn5ztrB2wEnkKXNt1/61Q3X+VuOBD8Htlk/K8FPWF2BG8RidtFzLjEok1Bz9/mOeeYGVeK+H3V0nKljFOO7SZJDskPvtsJpMrleTas6ryroLOsSJtxtkjK+i3C+f2NPC5nEiUsjK1AJT6/W9aqySY5Rxd9CXrlI/bOFHmu8cKZxMftu/6jJ0YOtnCl+E0XzeW5lV1jhUxnC7ApKVzYJCvFrA9eLpXBeqfy1BjAaw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(4744005)(8936002)(6506007)(186003)(16526019)(956004)(2616005)(26005)(6512007)(316002)(4326008)(54906003)(508600001)(6486002)(8676002)(5660300002)(36756003)(2906002)(52116002)(66946007)(83380400001)(1076003)(66476007)(66556008)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: 79InrsUEANB3OFUi0MtigLgLl/LELv/KXsk13+63TXeHX1rDJHnN8GCOwGZtYYGfbaavhyU8QWn1Rya5vv5TzeXNXLZPvtZFGONlNbzS91r3U/ErcDvY6WbfOXUiYbq1z6mZ+EJcFBMHqvnjHjGAK1v7/RbYxqgiQkB/0QqQMdo3h/mFabEBlWDE0G9cveiJeyaHHyYeIVcEs87dL+gV7vaf4zoMA4ZpnHFjAqm2Dluk0WyyvzqLQkUcBINxiqxEXstEIeHNL5zEfhjPW0Pn7R6d61nUEBsTMdsUJuIjgGunWrlrK4ZBRSVblwVUhNeUNNBYPy85+0KGXtWBVPCJxQBzurfMHa9odko0dH2cwSlayPoN2vs1U8t+jWkHIuoPjn62da9QOZrRwIzJg63ITFZy8OCwSlEpInB9i4oGWBQVVGMotgCjTw8X6p3xeZyFHLNZ6Fh5bv5UZNxXDRiGnhsCCYCAt7wcb/6hqFUN56ccWjT84kWlHNIUgQoYLrrlyfDuL+aeNB0YzkgMfOSRP/hTLaZ4MqrtK/7mnuizwQU94oah2xFnAXmUa3tEjTxAfpirKB3UWLEx8bzk6yG29X/XXIctFUyKmI7plUUNuOEORtYJsZIkuJe8RsGZsXJxVf9YSNziwQOj9K13kJrTKg==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c0a7f676-7812-474e-019e-08d8547bf705
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 04:51:07.9173
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X1l1V5d2hjcUfQuTC5T2OzZx23a7M+FdpXbFh/7inEYbMdzD1hfwdFyV8/bP3SXmTOGrhSQEUK7AHXZ3LtPPPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3650
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Parav Pandit <parav@nvidia.com>

Add comment block for physical, PF and VF port attributes.

Signed-off-by: Parav Pandit <parav@nvidia.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
---
 include/net/devlink.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 8f3c8a443238..3c7ba3e1f490 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -73,6 +73,9 @@ struct devlink_port_pci_vf_attrs {
  * @splittable: indicates if the port can be split.
  * @lanes: maximum number of lanes the port supports. 0 value is not passed to netlink.
  * @switch_id: if the port is part of switch, this is buffer with ID, otherwise this is NULL
+ * @phys: physical port attributes
+ * @pci_pf: PCI PF port attributes
+ * @pci_vf: PCI VF port attributes
  */
 struct devlink_port_attrs {
 	u8 split:1,
-- 
2.26.2

