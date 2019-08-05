Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E427882518
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 20:55:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbfHESzE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 14:55:04 -0400
Received: from mga06.intel.com ([134.134.136.31]:43661 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730229AbfHESzC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Aug 2019 14:55:02 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 05 Aug 2019 11:55:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,350,1559545200"; 
   d="scan'208";a="373801234"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.96])
  by fmsmga006.fm.intel.com with ESMTP; 05 Aug 2019 11:55:01 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>
Subject: [net-next v2 4/8] i40e: fix code comments
Date:   Mon,  5 Aug 2019 11:54:55 -0700
Message-Id: <20190805185459.12846-5-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
References: <20190805185459.12846-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Found a code comment that needed TLC to correct their formatting.

Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
---
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
index 12f04f36e357..6d0289e60e01 100644
--- a/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
+++ b/drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c
@@ -2159,7 +2159,7 @@ static int i40e_vc_config_queues_msg(struct i40e_vf *vf, u8 *msg)
 		 * VF does not know about these additional VSIs and all
 		 * it cares is about its own queues. PF configures these queues
 		 * to its appropriate VSIs based on TC mapping
-		 **/
+		 */
 		if (vf->adq_enabled) {
 			if (idx >= ARRAY_SIZE(vf->ch)) {
 				aq_ret = I40E_ERR_NO_AVAILABLE_VSI;
-- 
2.21.0

