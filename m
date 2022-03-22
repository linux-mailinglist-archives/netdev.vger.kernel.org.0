Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E15664E383C
	for <lists+netdev@lfdr.de>; Tue, 22 Mar 2022 06:13:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbiCVFM3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Mar 2022 01:12:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236653AbiCVFM0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Mar 2022 01:12:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF591C8
        for <netdev@vger.kernel.org>; Mon, 21 Mar 2022 22:10:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3CC7F61361
        for <netdev@vger.kernel.org>; Tue, 22 Mar 2022 05:10:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA30C340EC;
        Tue, 22 Mar 2022 05:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647925857;
        bh=e2F9mOHyz9T030cNhxLPIyjKF5ZN7XrMq5PHqKmVZ3A=;
        h=From:To:Cc:Subject:Date:From;
        b=LYFjWicMaIXJ1oUjk0VHSTUMsAp1ufMynagmbmUTyS4Qb4IHn1kfozR2+u4AVRp6z
         zs3wgNcgQ8BanGoi39JeB97BtwhVu9UlVJboWTRI190zrkYgnaUKvB1qXimH/yHp/v
         /jxEc6ncD3sbKnIPYBSZviUhevyOpgJIW7d5YsQFtrlNSp/GFOKkpodSGhm4SwkdC3
         9GklRMsf8oO0oQ/J3rL4MlSADBEQSHxx/Moko8aRzLv+ONy3cfHcogRQlvFz4ZpBzP
         y6yBflbdVa6Rm8MXdFUn8KInBgKTRuy9choPb8nobCmXH17xj387LR11NCfVruYBa4
         Q/egnIYSSyh1Q==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     edumazet@google.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] netdevice: add missing dm_private kdoc
Date:   Mon, 21 Mar 2022 22:10:53 -0700
Message-Id: <20220322051053.1883186-1-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Building htmldocs complains:
  include/linux/netdevice.h:2295: warning: Function parameter or member 'dm_private' not described in 'net_device'

Fixes: b26ef81c46ed ("drop_monitor: remove quadratic behavior")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/netdevice.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index e01a8ce7181f..cd7a597c55b1 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1899,6 +1899,8 @@ enum netdev_ml_priv_type {
  *	@garp_port:	GARP
  *	@mrp_port:	MRP
  *
+ *	@dm_private:	Drop monitor private
+ *
  *	@dev:		Class/net/name entry
  *	@sysfs_groups:	Space for optional device, statistics and wireless
  *			sysfs groups
-- 
2.34.1

