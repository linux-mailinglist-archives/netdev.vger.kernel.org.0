Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53684149EE3
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 07:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbgA0GBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 01:01:19 -0500
Received: from mga17.intel.com ([192.55.52.151]:27275 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgA0GBT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Jan 2020 01:01:19 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 26 Jan 2020 22:01:18 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,368,1574150400"; 
   d="scan'208";a="251856274"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 26 Jan 2020 22:01:17 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1ivxSW-0005ad-VO; Mon, 27 Jan 2020 14:01:16 +0800
Date:   Mon, 27 Jan 2020 14:00:19 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Michal Kalderon <michal.kalderon@marvell.com>
Cc:     kbuild-all@lists.01.org, michal.kalderon@marvell.com,
        ariel.elior@marvell.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: [RFC PATCH] qed: Debug feature: qed_dbg_ilt_get_dump_buf_size() can
 be static
Message-ID: <20200127060019.zyygmric5z2mkys3@f53c9c00458a>
References: <20200123105836.15090-12-michal.kalderon@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200123105836.15090-12-michal.kalderon@marvell.com>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Fixes: a4814c4686fc ("qed: Debug feature: ilt and mdump")
Signed-off-by: kbuild test robot <lkp@intel.com>
---
 qed_debug.c |   16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_debug.c b/drivers/net/ethernet/qlogic/qed/qed_debug.c
index dbe917daa04b8..17a9b30e6c625 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_debug.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_debug.c
@@ -5917,9 +5917,9 @@ enum dbg_status qed_dbg_fw_asserts_dump(struct qed_hwfn *p_hwfn,
 	return DBG_STATUS_OK;
 }
 
-enum dbg_status qed_dbg_ilt_get_dump_buf_size(struct qed_hwfn *p_hwfn,
-					      struct qed_ptt *p_ptt,
-					      u32 *buf_size)
+static enum dbg_status qed_dbg_ilt_get_dump_buf_size(struct qed_hwfn *p_hwfn,
+						     struct qed_ptt *p_ptt,
+						     u32 *buf_size)
 {
 	enum dbg_status status = qed_dbg_dev_init(p_hwfn, p_ptt);
 
@@ -5933,11 +5933,11 @@ enum dbg_status qed_dbg_ilt_get_dump_buf_size(struct qed_hwfn *p_hwfn,
 	return DBG_STATUS_OK;
 }
 
-enum dbg_status qed_dbg_ilt_dump(struct qed_hwfn *p_hwfn,
-				 struct qed_ptt *p_ptt,
-				 u32 *dump_buf,
-				 u32 buf_size_in_dwords,
-				 u32 *num_dumped_dwords)
+static enum dbg_status qed_dbg_ilt_dump(struct qed_hwfn *p_hwfn,
+					struct qed_ptt *p_ptt,
+					u32 *dump_buf,
+					u32 buf_size_in_dwords,
+					u32 *num_dumped_dwords)
 {
 	u32 needed_buf_size_in_dwords;
 	enum dbg_status status;
