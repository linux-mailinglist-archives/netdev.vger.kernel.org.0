Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7B43251A58
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 16:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726241AbgHYN77 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 09:59:59 -0400
Received: from mail-eopbgr80071.outbound.protection.outlook.com ([40.107.8.71]:60483
        "EHLO EUR04-VI1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726432AbgHYN7I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 09:59:08 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=fbpSwMzeX7Lri9OwM7cGfOVuatBWzMX5POK0WixtFnps0DI52e5uY8QJ1FaEXDWbq9REekEid+Mo0Hr3W00nRiVhLC+UGdq00ny3/l4+/83B6v0xWesVRuCHv2zR7Vp1Hyj64S7NYMOjxgtsbc46Hl/U53D0UaGW/H2ocTAR6QRyK+9KfurURytfXpvgQX2GamONwLA6TM2/1e4thi1FmuO3Z0qoIwWRBCr9CgMNqiBr0uGz7jVtbQfVPXFiA6NdZhNYcbTDTTYRS/kjnCiqpoCgtKeiZxascPZMSYf6yjwcYbLEZEW5YQb9SYuwBC2Xu9Mx0uzzFZ6YJV0sRZ2NlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvkU8vjx/B/j1i27s0r0IqbNH323qdEnByiZ5k4+B4M=;
 b=F+/Ar6JUxScxp3lblp5eecI/C9D9jf2lrmR0+YHlrlggz/LxHDaJFhyYfYxkDdzzsQRmuBBcUNQk2ycWlSowyZeKQvqBoOHEajHug0uKaiRM2k+dtNKTTp5fOkoyfdo7CjDn4FkzRGX/LNstcHVoALJxt8bKpTpmXYy7ajU9jAqdYgVZ2ak7LzqfX82SZ1eGpXDgL4ZLodCcLjQAkJP3CRJ3e8z2o8pVDHpYT6UlaqMvlfn2PG4ZpsLYQkRUrcCx+84pzX732BaULimhhq+Zp+kFVgFuRIby4JJ9/7U2vtRScvE7cS59Va+8yMEsxc1eLPV3AUG16p4SfhhbEWebrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=WvkU8vjx/B/j1i27s0r0IqbNH323qdEnByiZ5k4+B4M=;
 b=FxFOYjgYZgGd06aAXfDjZHyexW0icfb3aOcN1ZSi2pZfOySEbPRi4w7cMj1pfXGsXDqMI6YnmyLI0Ax9H+IGimrkRlqQiCKKqilamUhO2qygVcZcbae17cVUxkeDjx2ITz3/4boAdhx/qFzFsll1AWs4ifht9RWmVfsarI/ljnA=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR0502MB3649.eurprd05.prod.outlook.com (2603:10a6:208:22::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25; Tue, 25 Aug
 2020 13:58:59 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5038:5c70:6fef:90a6]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::5038:5c70:6fef:90a6%5]) with mapi id 15.20.3305.026; Tue, 25 Aug 2020
 13:58:59 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     roid@mellanox.com, saeedm@mellanox.com,
        Parav Pandit <parav@mellanox.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next 1/3] devlink: Add comment block for missing port attributes
Date:   Tue, 25 Aug 2020 16:58:37 +0300
Message-Id: <20200825135839.106796-2-parav@mellanox.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200825135839.106796-1-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: AM0PR10CA0048.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:20b:150::28) To AM0PR05MB4866.eurprd05.prod.outlook.com
 (2603:10a6:208:c0::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from c-235-9-1-005.mtl.labs.mlnx (94.188.199.18) by AM0PR10CA0048.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:20b:150::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3305.25 via Frontend Transport; Tue, 25 Aug 2020 13:58:57 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [94.188.199.18]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 20870688-9bae-4e95-eedf-08d848ff02fb
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3649:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr,ExtFwd
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3649D5C8E3BDD3F70F40F3D1D1570@AM0PR0502MB3649.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rEOMb9koDk/avB0gWxi0Jc2zsLm+lHyOCnhc9CsFxt7V4L6fBE/d0x341JDOSdNw9eI2zv8fw5LwMb8FNek0FT/UpgAi95OvBpXKLtHXx/LMvBZbt+/TEvmXzooou8uG6LsccN/zVxZlNZQCakL7zCqf71J3AOZrZ6h2uLoJOFajdc0T88zJqJizyyzWy8nA9nNfRWOjqmkWd5qSfSNqng3Dgsf70KSY5UKszitB0gDTbcvpmwpi3Oy4ZjLGTeTcdZj+g7E7nnMLCNnTbn9EVQmJF+3oFPxikwJBazdNuijtTEClGjZ2afD2Y9YT9kZk2/VqCTzoJhRoD6afqHHRvw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(39860400002)(346002)(366004)(376002)(136003)(396003)(6506007)(6666004)(956004)(86362001)(36756003)(8936002)(54906003)(83380400001)(5660300002)(316002)(8676002)(4326008)(52116002)(6486002)(4744005)(6512007)(1076003)(478600001)(2906002)(2616005)(66946007)(26005)(186003)(66476007)(66556008)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: x4erY+bE52wu2+po+ZRkWiej20YMle6kRJui1A2SdKkglPkL3Dq5IF6eF/Z799Dj5hAYbDEgG7WwTLXmG9hlGcRxJ/NoAoyGZ5/VYSifUrhWFHKeMitbl1ahcRsH3mT0ll7kEakX67lYOFrzjnZf0FoA7puuxdDz+81/1adBy35JXz6dVipyIz85Vk+FcBRCSBIZOOHg9Kg4wbTGIwwJG96V4Zkm0Vnlti5bUl+DUAMa95TBm7Z1wf1gr3W1k643uFIDvbKS46NL7H44PQ7NtXMQTX1acAaeMGbe4McdIYIF024C89wU9RpXexgz3sKA1RZ8FixR+OWoG9j1bpdxT1vF929yRFJI84fCII75R/Hl+nZC4rNx7/jbkn6BmYD5r9bd8lqQRTJmiHCeqb6kjWS5+HuXlr39BTlTkr9viSDg1Mk6mWoI42q2qVPSG5j45JNLTmuPRmW80ZRpGs8kd5n7JkQOfpn9AAGZAt5As/jt9b8KmkTQHyHkxoBQ4B7FmXPn2KQDCBlxUOaIuSq9urKUxxBCWKh1dtQXsnlFb5oRJlN9IXCN/TUKhBGjISymmw4BcTp4OPfIcD21fbVEs6/wAB1PGiXJ+OCdib0g9zdrMVEOWh3kSOEJjPYm6mK83fQ3SYzVG8pWrtv85r8PtA==
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20870688-9bae-4e95-eedf-08d848ff02fb
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Aug 2020 13:58:57.8929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DnqDEoiSwk7hXgX8YrJq8UstKbWlb8ksvQdHvZLX8f0D1LGfNt4WKymdIf8nMqKKIfiXC/GFeSSpPeNTyyYjDw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3649
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add comment block for physical, PF and VF port attributes.

Signed-off-by: Parav Pandit <parav@mellanox.com>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Roi Dayan <roid@mellanox.com>
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

