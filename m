Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1524368A955
	for <lists+netdev@lfdr.de>; Sat,  4 Feb 2023 11:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbjBDKJh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Feb 2023 05:09:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233443AbjBDKJZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Feb 2023 05:09:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E779868129
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 02:09:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8497F60BE9
        for <netdev@vger.kernel.org>; Sat,  4 Feb 2023 10:09:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D80F9C4339E;
        Sat,  4 Feb 2023 10:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675505363;
        bh=85Vnu7UwR1L3zQW0ljlo9HMrVTCxf7LSxpP5p8lB8Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M1KEaPaSxfhVQ39DJT6EonWLYrf+sncpYjM9/Tfmb9XbBfWZoDVtjXxqOmETXlZhf
         hHmG6kQkvXow5IFYLbKdhUujRXwrlKEY5zU66dhl3Lg/prWuKtU+KF1FDDZdHoipxO
         g/05RobkXpS/Ixm9YbsaggdOUm5zgixcX1y5bFax/89VrhqYBnxc7UFOYGVghHZSFR
         cuZTmhZX8UelijA21FxFyvOR8kQ6J7Qv6YoahF2+0OVcc1wfPKzrZ03Jue/AO29arD
         CWyQcZbbaFx+drN+wucfaCTAY/Nuu3Crxgdka12I+/wUfnAjTU+jVePRpF3WC+EsTv
         H0zbLOTWwfhdQ==
From:   Saeed Mahameed <saeed@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Rahul Rameshbabu <rrameshbabu@nvidia.com>,
        Gal Pressman <gal@nvidia.com>
Subject: [net-next 08/15] net/mlx5: Document previously implemented mlx5 tracepoints
Date:   Sat,  4 Feb 2023 02:08:47 -0800
Message-Id: <20230204100854.388126-9-saeed@kernel.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230204100854.388126-1-saeed@kernel.org>
References: <20230204100854.388126-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

Tracepoints were previously implemented but not documented till this patch
series.

Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Gal Pressman <gal@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
---
 .../ethernet/mellanox/mlx5/tracepoints.rst    | 27 ++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/tracepoints.rst b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/tracepoints.rst
index 04f59189e75a..a9d3e123adc4 100644
--- a/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/tracepoints.rst
+++ b/Documentation/networking/device_drivers/ethernet/mellanox/mlx5/tracepoints.rst
@@ -165,6 +165,20 @@ SF tracepoints:
     ...
     devlink-9830    [038] ..... 26300.404749: mlx5_sf_free: (0000:06:00.0) port_index=32768 controller=0 hw_id=0x8000
 
+- mlx5_sf_activate: trace activation of the SF port::
+
+    $ echo mlx5:mlx5_sf_activate >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    devlink-29841   [008] .....  3669.635095: mlx5_sf_activate: (0000:08:00.0) port_index=32768 controller=0 hw_id=0x8000
+
+- mlx5_sf_deactivate: trace deactivation of the SF port::
+
+    $ echo mlx5:mlx5_sf_deactivate >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    devlink-29994   [008] .....  4015.969467: mlx5_sf_deactivate: (0000:08:00.0) port_index=32768 controller=0 hw_id=0x8000
+
 - mlx5_sf_hwc_alloc: trace allocating of the hardware SF context::
 
     $ echo mlx5:mlx5_sf_hwc_alloc >> /sys/kernel/debug/tracing/set_event
@@ -179,13 +193,20 @@ SF tracepoints:
     ...
     kworker/u128:3-9093    [046] ..... 24625.365771: mlx5_sf_hwc_free: (0000:06:00.0) hw_id=0x8000
 
-- mlx5_sf_hwc_deferred_free : trace deferred freeing of the hardware SF context::
+- mlx5_sf_hwc_deferred_free: trace deferred freeing of the hardware SF context::
 
     $ echo mlx5:mlx5_sf_hwc_deferred_free >> /sys/kernel/debug/tracing/set_event
     $ cat /sys/kernel/debug/tracing/trace
     ...
     devlink-9519    [046] ..... 24624.400271: mlx5_sf_hwc_deferred_free: (0000:06:00.0) hw_id=0x8000
 
+- mlx5_sf_update_state: trace state updates for SF contexts::
+
+    $ echo mlx5:mlx5_sf_update_state >> /sys/kernel/debug/tracing/set_event
+    $ cat /sys/kernel/debug/tracing/trace
+    ...
+    kworker/u20:3-29490   [009] .....  4141.453530: mlx5_sf_update_state: (0000:08:00.0) port_index=32768 controller=0 hw_id=0x8000 state=2
+
 - mlx5_sf_vhca_event: trace SF vhca event and state::
 
     $ echo mlx5:mlx5_sf_vhca_event >> /sys/kernel/debug/tracing/set_event
@@ -193,14 +214,14 @@ SF tracepoints:
     ...
     kworker/u128:3-9093    [046] ..... 24625.365525: mlx5_sf_vhca_event: (0000:06:00.0) hw_id=0x8000 sfnum=88 vhca_state=1
 
-- mlx5_sf_dev_add : trace SF device add event::
+- mlx5_sf_dev_add: trace SF device add event::
 
     $ echo mlx5:mlx5_sf_dev_add>> /sys/kernel/debug/tracing/set_event
     $ cat /sys/kernel/debug/tracing/trace
     ...
     kworker/u128:3-9093    [000] ..... 24616.524495: mlx5_sf_dev_add: (0000:06:00.0) sfdev=00000000fc5d96fd aux_id=4 hw_id=0x8000 sfnum=88
 
-- mlx5_sf_dev_del : trace SF device delete event::
+- mlx5_sf_dev_del: trace SF device delete event::
 
     $ echo mlx5:mlx5_sf_dev_del >> /sys/kernel/debug/tracing/set_event
     $ cat /sys/kernel/debug/tracing/trace
-- 
2.39.1

