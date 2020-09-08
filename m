Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D04260E6A
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 11:12:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729339AbgIHJMs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 05:12:48 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:48805 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729123AbgIHJLz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 05:11:55 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 93C48F48;
        Tue,  8 Sep 2020 05:11:54 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 08 Sep 2020 05:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=k84INhbDo6u7feuPKxCc+uoDw+6SG8XrLakANxANwis=; b=qAVlletv
        3qQbUT5cOJRKqOMO5/FiccxGCwD5FTQHkq83GFKmJ/GSr85IHhrjRwKmgYgZHatD
        Ahe1T/C9gwhnYt2tksIaWARmBLA/kuwP0bT5TKeKqH1jkzAS7mFAwDNz2NWm6MSL
        ySrZqHHRGo9TJ9XM9VuW2clTXrAIrU6VN7KyjYE+VclyMoosJrmZ5a+nVpQrIBGz
        Es7zAR80ocAWNpAu5+LDL51qMPJSVnV9lUyyjE0e8w/yAYrmwQUPdmGRlle2WmMN
        bA2OXjJnnYffY0LysXO12Y6GDRJzwcG85KUl2LjYKhP8Y7b6r4gGvFcN7PeKx70d
        BkvczQtn9d9xMw==
X-ME-Sender: <xms:2kpXX0ySaKD96B28lBdEhM4ou7ZFkBUrMrjmHEZTik7bj10NZepS5A>
    <xme:2kpXX4Su_E1V7JqoOWe7xWFR8yQtwWi_9M6HnQ7ubzMZXms-lTph2pyuiFVG-y96C
    nqxzNfKGIOh-hs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrudehvddguddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepkfguohcuufgthhhimhhmvghluceoihguohhstghhsehiugho
    shgthhdrohhrgheqnecuggftrfgrthhtvghrnhepudetieevffffveelkeeljeffkefhke
    ehgfdtffethfelvdejgffghefgveejkefhnecukfhppeekgedrvddvledrfeeirdduvdek
    necuvehluhhsthgvrhfuihiivgepudejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiug
    hoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:2kpXX2U-cYr_XCCk934OHJTeWS7cYSVuZAxNnLV0_hXiLBnpqGlTSA>
    <xmx:2kpXXyi7RRCMQEIGJ8HvcNAtcZzwWd6Gbw3ptk0G5WziAAJ3QSgNbA>
    <xmx:2kpXX2Bk-ggUP5urW1_ey0CUQs8HD8jYpNhUvZGuJ7Upk-0CRe5FGQ>
    <xmx:2kpXXxMzbT5PPsBBtOhoPdgBMRu0xKSMnOaQww3NcKDvRyC6pFNqFg>
Received: from shredder.mtl.com (igld-84-229-36-128.inter.net.il [84.229.36.128])
        by mail.messagingengine.com (Postfix) with ESMTPA id CD0B4306467E;
        Tue,  8 Sep 2020 05:11:52 -0400 (EDT)
From:   Ido Schimmel <idosch@idosch.org>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, dsahern@gmail.com,
        roopa@nvidia.com, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: [RFC PATCH net-next 19/22] netdevsim: Add devlink resource for nexthops
Date:   Tue,  8 Sep 2020 12:10:34 +0300
Message-Id: <20200908091037.2709823-20-idosch@idosch.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200908091037.2709823-1-idosch@idosch.org>
References: <20200908091037.2709823-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ido Schimmel <idosch@nvidia.com>

The Spectrum ASIC has a dedicated table where nexthops (i.e., adjacency
entries) are populated. The size of this table can be controlled via
devlink-resource.

Add such a resource to netdevsim so that its occupancy will reflect the
number of nexthop objects currently programmed to the device.

By limiting the size of the resource, error paths could be exercised and
tested.

Example output:

# devlink resource show netdevsim/netdevsim10
netdevsim/netdevsim10:
  name IPv4 size unlimited unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
    resources:
      name fib size unlimited occ 4 unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
      name fib-rules size unlimited occ 3 unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
  name IPv6 size unlimited unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
    resources:
      name fib size unlimited occ 1 unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
      name fib-rules size unlimited occ 2 unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none
  name nexthops size unlimited occ 0 unit entry size_min 0 size_max unlimited size_gran 1 dpipe_tables none

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
---
 .../networking/devlink/netdevsim.rst          |  3 ++-
 drivers/net/netdevsim/dev.c                   |  6 +++++
 drivers/net/netdevsim/fib.c                   | 23 ++++++++++++++++++-
 drivers/net/netdevsim/netdevsim.h             |  1 +
 4 files changed, 31 insertions(+), 2 deletions(-)

diff --git a/Documentation/networking/devlink/netdevsim.rst b/Documentation/networking/devlink/netdevsim.rst
index 2a266b7e7b38..02c2d20dc673 100644
--- a/Documentation/networking/devlink/netdevsim.rst
+++ b/Documentation/networking/devlink/netdevsim.rst
@@ -46,7 +46,7 @@ Resources
 =========
 
 The ``netdevsim`` driver exposes resources to control the number of FIB
-entries and FIB rule entries that the driver will allow.
+entries, FIB rule entries and nexthops that the driver will allow.
 
 .. code:: shell
 
@@ -54,6 +54,7 @@ entries and FIB rule entries that the driver will allow.
     $ devlink resource set netdevsim/netdevsim0 path /IPv4/fib-rules size 16
     $ devlink resource set netdevsim/netdevsim0 path /IPv6/fib size 64
     $ devlink resource set netdevsim/netdevsim0 path /IPv6/fib-rules size 16
+    $ devlink resource set netdevsim/netdevsim0 path /nexthops size 16
     $ devlink dev reload netdevsim/netdevsim0
 
 Driver-specific Traps
diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
index 32f339fedb21..d4f3a1eea800 100644
--- a/drivers/net/netdevsim/dev.c
+++ b/drivers/net/netdevsim/dev.c
@@ -320,6 +320,12 @@ static int nsim_dev_resources_register(struct devlink *devlink)
 		return err;
 	}
 
+	/* Resources for nexthops */
+	err = devlink_resource_register(devlink, "nexthops", (u64)-1,
+					NSIM_RESOURCE_NEXTHOPS,
+					DEVLINK_RESOURCE_ID_PARENT_TOP,
+					&params);
+
 out:
 	return err;
 }
diff --git a/drivers/net/netdevsim/fib.c b/drivers/net/netdevsim/fib.c
index deea17a0e79c..3ec0f8896efe 100644
--- a/drivers/net/netdevsim/fib.c
+++ b/drivers/net/netdevsim/fib.c
@@ -42,6 +42,7 @@ struct nsim_fib_data {
 	struct notifier_block fib_nb;
 	struct nsim_per_fib_data ipv4;
 	struct nsim_per_fib_data ipv6;
+	struct nsim_fib_entry nexthops;
 	struct rhashtable fib_rt_ht;
 	struct list_head fib_rt_list;
 	spinlock_t fib_lock;	/* Protects hashtable, list and accounting */
@@ -104,6 +105,9 @@ u64 nsim_fib_get_val(struct nsim_fib_data *fib_data,
 	case NSIM_RESOURCE_IPV6_FIB_RULES:
 		entry = &fib_data->ipv6.rules;
 		break;
+	case NSIM_RESOURCE_NEXTHOPS:
+		entry = &fib_data->nexthops;
+		break;
 	default:
 		return 0;
 	}
@@ -129,6 +133,9 @@ static void nsim_fib_set_max(struct nsim_fib_data *fib_data,
 	case NSIM_RESOURCE_IPV6_FIB_RULES:
 		entry = &fib_data->ipv6.rules;
 		break;
+	case NSIM_RESOURCE_NEXTHOPS:
+		entry = &fib_data->nexthops;
+		break;
 	default:
 		WARN_ON(1);
 		return;
@@ -866,12 +873,20 @@ static u64 nsim_fib_ipv6_rules_res_occ_get(void *priv)
 	return nsim_fib_get_val(data, NSIM_RESOURCE_IPV6_FIB_RULES, false);
 }
 
+static u64 nsim_fib_nexthops_res_occ_get(void *priv)
+{
+	struct nsim_fib_data *data = priv;
+
+	return nsim_fib_get_val(data, NSIM_RESOURCE_NEXTHOPS, false);
+}
+
 static void nsim_fib_set_max_all(struct nsim_fib_data *data,
 				 struct devlink *devlink)
 {
 	enum nsim_resource_id res_ids[] = {
 		NSIM_RESOURCE_IPV4_FIB, NSIM_RESOURCE_IPV4_FIB_RULES,
-		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES
+		NSIM_RESOURCE_IPV6_FIB, NSIM_RESOURCE_IPV6_FIB_RULES,
+		NSIM_RESOURCE_NEXTHOPS,
 	};
 	int i;
 
@@ -929,6 +944,10 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 					  NSIM_RESOURCE_IPV6_FIB_RULES,
 					  nsim_fib_ipv6_rules_res_occ_get,
 					  data);
+	devlink_resource_occ_get_register(devlink,
+					  NSIM_RESOURCE_NEXTHOPS,
+					  nsim_fib_nexthops_res_occ_get,
+					  data);
 	return data;
 
 err_rhashtable_destroy:
@@ -941,6 +960,8 @@ struct nsim_fib_data *nsim_fib_create(struct devlink *devlink,
 
 void nsim_fib_destroy(struct devlink *devlink, struct nsim_fib_data *data)
 {
+	devlink_resource_occ_get_unregister(devlink,
+					    NSIM_RESOURCE_NEXTHOPS);
 	devlink_resource_occ_get_unregister(devlink,
 					    NSIM_RESOURCE_IPV6_FIB_RULES);
 	devlink_resource_occ_get_unregister(devlink,
diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/netdevsim.h
index 284f7092241d..5e01169da01f 100644
--- a/drivers/net/netdevsim/netdevsim.h
+++ b/drivers/net/netdevsim/netdevsim.h
@@ -145,6 +145,7 @@ enum nsim_resource_id {
 	NSIM_RESOURCE_IPV6,
 	NSIM_RESOURCE_IPV6_FIB,
 	NSIM_RESOURCE_IPV6_FIB_RULES,
+	NSIM_RESOURCE_NEXTHOPS,
 };
 
 struct nsim_dev_health {
-- 
2.26.2

