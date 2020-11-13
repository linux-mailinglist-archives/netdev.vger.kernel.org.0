Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 61F382B2764
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:46:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726692AbgKMVp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:45:56 -0500
Received: from mga06.intel.com ([134.134.136.31]:18962 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726156AbgKMVpM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:45:12 -0500
IronPort-SDR: gSxp0QZH9DFLuzZ78KpRDiXq+Y/e7qnD/j/XKxb7S9/j61x9QVg11G0l7ucrPB1t8+HEhBYgT3
 P38pWXr9TeGQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9804"; a="232153170"
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="232153170"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Nov 2020 13:44:58 -0800
IronPort-SDR: Ui2tgVEBlj4UleParMjfnOS2b8P4Ih8P84+s98yiTNjEsaMl9gxQGQApApsrn0Lq5YuJ3KgNil
 tHLOzpD7Oqqg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.77,476,1596524400"; 
   d="scan'208";a="532715897"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 13 Nov 2020 13:44:58 -0800
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Aaron Brown <aaron.f.brown@intel.com>
Subject: [net-next v3 12/15] ice: cleanup misleading comment
Date:   Fri, 13 Nov 2020 13:44:26 -0800
Message-Id: <20201113214429.2131951-13-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
References: <20201113214429.2131951-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

The maximum Admin Queue buffer size and NVM shadow RAM sector size are both
4 Kilobytes. Some comments refer to those as 4Kb which can be confused with
4 Kilobits. Update the comments to use the commonly used KB symbol instead.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_nvm.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_nvm.c b/drivers/net/ethernet/intel/ice/ice_nvm.c
index cd442a5415d1..dc0d82c844ad 100644
--- a/drivers/net/ethernet/intel/ice/ice_nvm.c
+++ b/drivers/net/ethernet/intel/ice/ice_nvm.c
@@ -55,7 +55,7 @@ ice_aq_read_nvm(struct ice_hw *hw, u16 module_typeid, u32 offset, u16 length,
  *
  * Reads a portion of the NVM, as a flat memory space. This function correctly
  * breaks read requests across Shadow RAM sectors and ensures that no single
- * read request exceeds the maximum 4Kb read for a single AdminQ command.
+ * read request exceeds the maximum 4KB read for a single AdminQ command.
  *
  * Returns a status code on failure. Note that the data pointer may be
  * partially updated if some reads succeed before a failure.
@@ -81,10 +81,10 @@ ice_read_flat_nvm(struct ice_hw *hw, u32 offset, u32 *length, u8 *data,
 	do {
 		u32 read_size, sector_offset;
 
-		/* ice_aq_read_nvm cannot read more than 4Kb at a time.
+		/* ice_aq_read_nvm cannot read more than 4KB at a time.
 		 * Additionally, a read from the Shadow RAM may not cross over
 		 * a sector boundary. Conveniently, the sector size is also
-		 * 4Kb.
+		 * 4KB.
 		 */
 		sector_offset = offset % ICE_AQ_MAX_BUF_LEN;
 		read_size = min_t(u32, ICE_AQ_MAX_BUF_LEN - sector_offset,
-- 
2.26.2

