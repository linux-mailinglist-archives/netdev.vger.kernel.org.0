Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3ED5314DED
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 12:11:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232305AbhBILKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Feb 2021 06:10:05 -0500
Received: from mail-il-dmz.mellanox.com ([193.47.165.129]:60157 "EHLO
        mellanox.co.il" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S232410AbhBILH4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Feb 2021 06:07:56 -0500
Received: from Internal Mail-Server by MTLPINE1 (envelope-from ayal@mellanox.com)
        with SMTP; 9 Feb 2021 13:00:19 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (dev-l-vrt-210.mtl.labs.mlnx [10.234.210.1])
        by labmailer.mlnx (8.13.8/8.13.8) with ESMTP id 119B0JmJ025187;
        Tue, 9 Feb 2021 13:00:19 +0200
Received: from dev-l-vrt-210.mtl.labs.mlnx (localhost [127.0.0.1])
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Debian-8ubuntu1) with ESMTP id 119B0IVP022999;
        Tue, 9 Feb 2021 13:00:18 +0200
Received: (from ayal@localhost)
        by dev-l-vrt-210.mtl.labs.mlnx (8.15.2/8.15.2/Submit) id 119B0HHV022998;
        Tue, 9 Feb 2021 13:00:17 +0200
From:   Aya Levin <ayal@nvidia.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>
Cc:     netdev@vger.kernel.org, Tariq Toukan <tariqt@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>, Aya Levin <ayal@nvidia.com>
Subject: [PATCH net-next] devlink: Fix dmac_filter trap name, align to its documentation
Date:   Tue,  9 Feb 2021 12:59:55 +0200
Message-Id: <1612868395-22884-1-git-send-email-ayal@nvidia.com>
X-Mailer: git-send-email 1.8.4.3
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

%s/dest_mac_filter/dmac_filter/g

Fixes: e78ab164591f ("devlink: Add DMAC filter generic packet trap")
Signed-off-by: Aya Levin <ayal@nvidia.com>
Reported-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
---
 include/net/devlink.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/devlink.h b/include/net/devlink.h
index 47b4b063401b..853420db5d32 100644
--- a/include/net/devlink.h
+++ b/include/net/devlink.h
@@ -1090,7 +1090,7 @@ enum devlink_trap_group_generic_id {
 #define DEVLINK_TRAP_GENERIC_NAME_BLACKHOLE_NEXTHOP \
 	"blackhole_nexthop"
 #define DEVLINK_TRAP_GENERIC_NAME_DMAC_FILTER \
-	"dest_mac_filter"
+	"dmac_filter"
 
 #define DEVLINK_TRAP_GROUP_GENERIC_NAME_L2_DROPS \
 	"l2_drops"
-- 
2.14.1

