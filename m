Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35C043DE463
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 04:29:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233641AbhHCC33 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 22:29:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:58976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233730AbhHCC3O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 22:29:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D283261050;
        Tue,  3 Aug 2021 02:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627957744;
        bh=+h3YV6FJ1MoqvDXa1r4wCypAQ+Ni4rXfSfXya7XsCno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOglagP8gPoJ8C5uCL6X5Wm3hDRdCFRZG4Roj3Gqlp20iG4mgKJy4hvoXU3jsbts/
         1ZmBFlJyGKKIy0EJFpPaz31EqN9xyqxyQNJWw8H/Vot7ieQ1Dfs1nc/vyNTW2RVHZs
         3UrdG/hrh1HZIrKhlGqFD4sz0MLN+6K37zyaVUk2By1h5g5Rox/moezrkqVpypD6vL
         zV07pOPnFOl9BXgGJfn9ucY58t1K6gYObTlMZgkY0wCx8VLo5w9Ure0dMbdYQjSUJa
         kSUuwZaOc+We4Nj3an52q7DsiSuETh7nb7fgHSE7jX9GdgQnWVpKMkVIP/Xmtiv8LI
         lFzzd+u/55tnw==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, Roi Dayan <roid@nvidia.com>,
        Maor Dickman <maord@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: [net-next 10/16] net/mlx5e: Remove redundant tc act includes
Date:   Mon,  2 Aug 2021 19:28:47 -0700
Message-Id: <20210803022853.106973-11-saeed@kernel.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210803022853.106973-1-saeed@kernel.org>
References: <20210803022853.106973-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Roi Dayan <roid@nvidia.com>

Since the code changed to use the flow action infra
there is no usage of tcf values from those includes.
Remove those.

Signed-off-by: Roi Dayan <roid@nvidia.com>
Reviewed-by: Maor Dickman <maord@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 1a606dc8bed5..9671fb0e1432 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -34,19 +34,13 @@
 #include <net/flow_offload.h>
 #include <net/sch_generic.h>
 #include <net/pkt_cls.h>
-#include <net/tc_act/tc_gact.h>
-#include <net/tc_act/tc_skbedit.h>
 #include <linux/mlx5/fs.h>
 #include <linux/mlx5/device.h>
 #include <linux/rhashtable.h>
 #include <linux/refcount.h>
 #include <linux/completion.h>
-#include <net/tc_act/tc_mirred.h>
-#include <net/tc_act/tc_vlan.h>
-#include <net/tc_act/tc_tunnel_key.h>
 #include <net/tc_act/tc_pedit.h>
 #include <net/tc_act/tc_csum.h>
-#include <net/tc_act/tc_mpls.h>
 #include <net/psample.h>
 #include <net/arp.h>
 #include <net/ipv6_stubs.h>
-- 
2.31.1

