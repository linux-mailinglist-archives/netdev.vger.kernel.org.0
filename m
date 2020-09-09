Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AECE26267B
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 06:51:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726789AbgIIEvi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 00:51:38 -0400
Received: from mail-eopbgr30051.outbound.protection.outlook.com ([40.107.3.51]:57634
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725948AbgIIEvZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Sep 2020 00:51:25 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KgQy1wAloc6EXHF/VljAMvzZBJfxgzp2NzpzdKQWDIRq5L2fFFI4EuFGjQOcIrdFpn+kz5rNM5vkAX3Zjoxw6dvuGHMYLWna47qYalMINDHmvYGgdPS1It7fFdLfuOUElai3ZCvKs7ypwWb7tCUbi6wCXnbQOcl2euZzv6EcsLuAm1BFOuGCp6pL8Vy+ANy/sU5y287lzDY1/HwfdGtJHfNcDZ/hPKSG3RCuiCRSuqGBZ/dFiYPVpypCszdFLR0wP38gX3PcG2m07EHH50jfPhh9PbrNryxgA6VzstHlmroDhSo6GamrRCoxxELoeQx7k+QDn9H35yD69gbJuTi/gQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUT/27PDKkI0NfoeAfOR1z/6TCNH+IYwpmLalCWiyIo=;
 b=bYt0L7MlT0zoqkuhHfFAFrR9Wn3JWCRAMRcPkAfBfkyQbeu/JFnD2L03BCClMB9IHL69Eg7glIlULLo3AmkonLA3J7I7vaNqRd1aT4HFt5VzijRmZM7sO3eV97byN915XaqgAJ+ls8LdmlmTyqHhFx1rXSxg2rUbKaisL2rV36DXMB78BHC7jRRB85euA6oyExr/8es0JirVidlMmKi0pyuth+2FIqh5kQP0Jdk968LEeMULx8iCEYsKxRCmbslbRjUZ4nw/zoc7siqFcqJ7hVRwcb/k6pZxz9Iis4CIalmuLS8tK6YQdit39TCblxq8ad6YCn9uzU4bFaL5pvcbEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=mellanox.com; dmarc=pass action=none header.from=mellanox.com;
 dkim=pass header.d=mellanox.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Mellanox.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AUT/27PDKkI0NfoeAfOR1z/6TCNH+IYwpmLalCWiyIo=;
 b=NfJta8vTdp6/v51kdEDBXyVPAoHitvZdCiCczeSZbckU83TAScKmdWvc4+aeAd6k3SkK+2kHDCiR0ojmNoob2Cii8H41pfb6wAxADue/062aZMvJbWTWl8+vyZkhY47+naX9Z1vD4iChA78TC0dfYVUuB5Px2JJaExWNZjlMCbU=
Authentication-Results: kernel.org; dkim=none (message not signed)
 header.d=none;kernel.org; dmarc=none action=none header.from=mellanox.com;
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com (2603:10a6:208:c0::32)
 by AM0PR0502MB3650.eurprd05.prod.outlook.com (2603:10a6:208:1c::32) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3348.16; Wed, 9 Sep
 2020 04:51:09 +0000
Received: from AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18]) by AM0PR05MB4866.eurprd05.prod.outlook.com
 ([fe80::349f:cbf4:ddcf:ce18%3]) with mapi id 15.20.3370.016; Wed, 9 Sep 2020
 04:51:09 +0000
From:   Parav Pandit <parav@mellanox.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     Parav Pandit <parav@nvidia.com>, Jiri Pirko <jiri@nvidia.com>
Subject: [PATCH net-next v3 3/6] devlink: Move structure comments outside of structure
Date:   Wed,  9 Sep 2020 07:50:35 +0300
Message-Id: <20200909045038.63181-4-parav@mellanox.com>
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
Received: from sw-mtx-036.mtx.labs.mlnx (208.176.44.194) by SN6PR04CA0091.namprd04.prod.outlook.com (2603:10b6:805:f2::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3370.16 via Frontend Transport; Wed, 9 Sep 2020 04:51:08 +0000
X-Mailer: git-send-email 2.26.2
X-Originating-IP: [208.176.44.194]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 30751a2c-cac2-4f17-56dc-08d8547bf819
X-MS-TrafficTypeDiagnostic: AM0PR0502MB3650:
X-LD-Processed: a652971c-7d2e-4d9b-a6a4-d149256f461b,ExtAddr
X-Microsoft-Antispam-PRVS: <AM0PR0502MB3650F5AC57C541DDB3039A3CD1260@AM0PR0502MB3650.eurprd05.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GitN9uj4VUGviCrIx3lQoprCDibXchqaTHP9AeszwUf5gLugtqNdFJG/qKmYe1OGKRYku7QYKrAW43CsUjg0Gr/UT/dA2kt5KE4xpGC+FHNJ02f+eAVAFa8doSoq1Fr468O1IlzV9wKt44TQ1q/KNEW5AvnXzi+KmsmKXuH1+q3rfdASThxfqrtEeaDhLgCDvLS0ZwF/h0BKCeBRZb8Suwe7X785k3T8H1IWPj7nPLRs6v5lTQGZgHX68CSndHKOlh9F8ff587pBN4wxC1LHwKuSCQoIdRs5sAC7kOmMpktVRCuBH3nyg4n25dv+1kDTXRs11bYd5Po9mC6l42AbVg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR05MB4866.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(366004)(396003)(346002)(136003)(39860400002)(8936002)(6506007)(186003)(16526019)(956004)(2616005)(26005)(6512007)(316002)(4326008)(54906003)(508600001)(6486002)(8676002)(5660300002)(36756003)(2906002)(52116002)(66946007)(83380400001)(1076003)(66476007)(66556008)(6666004)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: M9lcCodnqRBCgYY8WJ0eXwp88UlF5CHNxRkF2JQCuG2ir3aHJOGOh6dr09PMAf1NWg8UrMAUAGgGKfPgu2T3RtYAwIw4BR6bAgEE8l7LdGF+Z9/J3Nv7LqgEGQe4mNVUcHL5x18paHRdckm7N9Z3do7kEM15ZmZWVpqWH1D0xq7dWsEw6mjfMFA6w02P93UCdGJh6kZtxYn2bsUEwg5gVy8usxzAgkGVIhysdLa196yk56SRjqdYXgugs1zAA/tQBPsNKFcp5H0mhooOSb1732db/JVtAVPMXnLzr6EB/G7ooIKez5UyOZnrGIaPqU8cHL9rTIJd53CTZXqt4FoK3pUkPyz2Aoq01Pu4nLidgzMo8r2dO/DfYML5dnhCn25QPZIzELIg7v4tRxrrxGB7dCck+jRXru54uXfU0Y3vib6yUrVLju9l8mcc4wlCK4hfB3q5Wyyx9d2j5agBHl5IV5VhHrWPehHIM0bxCkb+evkP7S1HOqJmYs0iVHvnLGiyMnRDCYiqIgOWbDaeLpFJfLIMMD9GBNcbfYBuY+mmhBGgUA4Qo53VAXSpX2RTVZ+9ss2r+oBBhS9vCXQahbgJQBznKGr92FRWGUVSeHwDWVKn/tJYEpim+nKbu0j1nRyKLvx3raqjkqxB6aGm7ncHzg==
X-MS-Exchange-Transport-Forked: True
X-OriginatorOrg: Mellanox.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 30751a2c-cac2-4f17-56dc-08d8547bf819
X-MS-Exchange-CrossTenant-AuthSource: AM0PR05MB4866.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2020 04:51:09.6883
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: a652971c-7d2e-4d9b-a6a4-d149256f461b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CCmYhJWxXIh32o3u7frwsLT+b2E7N9gP4tCQvgfZrc11/KzIjQasdxjimyGoN/oZ+SkHxFPRLU2eOHMYMqeW8g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR0502MB3650
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

