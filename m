Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A1D0418097D
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 21:45:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727631AbgCJUp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 16:45:56 -0400
Received: from mga14.intel.com ([192.55.52.115]:54080 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726704AbgCJUpl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 10 Mar 2020 16:45:41 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 10 Mar 2020 13:45:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,538,1574150400"; 
   d="scan'208";a="441431028"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga005.fm.intel.com with ESMTP; 10 Mar 2020 13:45:38 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jacob Keller <jacob.e.keller@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next v2 15/15] ice: fix incorrect size description of ice_get_nvm_version
Date:   Tue, 10 Mar 2020 13:45:34 -0700
Message-Id: <20200310204534.2071912-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
References: <20200310204534.2071912-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jacob Keller <jacob.e.keller@intel.com>

The function comment for ice_get_nvm_version indicated that the ver_hi
and ver_lo values were 16 bits. In fact, they are only uint8_t values,
meaning that they have a maximum size of 8 bits. Fix the comment to
match the correct size.

Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_common.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_common.c b/drivers/net/ethernet/intel/ice/ice_common.c
index 1fe54f08f162..e574a70fcc99 100644
--- a/drivers/net/ethernet/intel/ice/ice_common.c
+++ b/drivers/net/ethernet/intel/ice/ice_common.c
@@ -620,8 +620,8 @@ static void ice_get_itr_intrl_gran(struct ice_hw *hw)
  * @oem_ver: 8 bit NVM version
  * @oem_build: 16 bit NVM build number
  * @oem_patch: 8 NVM patch number
- * @ver_hi: high 16 bits of the NVM version
- * @ver_lo: low 16 bits of the NVM version
+ * @ver_hi: high 8 bits of the NVM version
+ * @ver_lo: low 8 bits of the NVM version
  */
 void
 ice_get_nvm_version(struct ice_hw *hw, u8 *oem_ver, u16 *oem_build,
-- 
2.24.1

