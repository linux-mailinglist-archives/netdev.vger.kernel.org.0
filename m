Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7632ECA61
	for <lists+netdev@lfdr.de>; Thu,  7 Jan 2021 07:11:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbhAGGLV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jan 2021 01:11:21 -0500
Received: from mail.kevlo.org ([220.134.220.36]:27377 "EHLO mail.kevlo.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbhAGGLT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Jan 2021 01:11:19 -0500
Received: from localhost (ns.kevlo.org [local])
        by ns.kevlo.org (OpenSMTPD) with ESMTPA id 746f951c;
        Thu, 7 Jan 2021 14:10:38 +0800 (CST)
Date:   Thu, 7 Jan 2021 14:10:38 +0800
From:   Kevin Lo <kevlo@kevlo.org>
To:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org
Cc:     Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: [PATCH] igc: check return value of ret_val in
 igc_config_fc_after_link_up
Message-ID: <X/al3kv9JKN8nhFw@ns.kevlo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check return value from ret_val to make error check actually work.

Fixes: 4eb8080143a9 ("igc: Add setup link functionality")
Signed-off-by: Kevin Lo <kevlo@kevlo.org>
---
diff --git a/drivers/net/ethernet/intel/igc/igc_mac.c b/drivers/net/ethernet/intel/igc/igc_mac.c
index 09cd0ec7ee87..67b8ffd21d8a 100644
--- a/drivers/net/ethernet/intel/igc/igc_mac.c
+++ b/drivers/net/ethernet/intel/igc/igc_mac.c
@@ -638,7 +638,7 @@ s32 igc_config_fc_after_link_up(struct igc_hw *hw)
 	}
 
 out:
-	return 0;
+	return ret_val;
 }
 
 /**
