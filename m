Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4BCE1DE045
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728478AbgEVG4X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:23 -0400
Received: from mga14.intel.com ([192.55.52.115]:18662 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728426AbgEVG4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:22 -0400
IronPort-SDR: yxSg34oB37KJCqnsHAbL3IpTgqqZinwPkH3BQDkMSZnBIar+Gk04s1DjTsyJvYHkIaOhnAABlQ
 YkrxI3UDp1og==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:11 -0700
IronPort-SDR: e58ENbSDiTOBfNCiozdqv4MxQ2skGVYJlsHmTcCNl/tzYXoJY5DrqhZ+kmCHThnIcgYu/9P1s+
 1hJ2i3ZnNSuw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017780"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 15/17] ice: remove unnecessary check
Date:   Thu, 21 May 2020 23:56:05 -0700
Message-Id: <20200522065607.1680050-16-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
References: <20200522065607.1680050-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

The variable status cannot be zero due to a prior check of it; remove this
check.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_main.c b/drivers/net/ethernet/intel/ice/ice_main.c
index fffb3433969c..c3e5c4334e26 100644
--- a/drivers/net/ethernet/intel/ice/ice_main.c
+++ b/drivers/net/ethernet/intel/ice/ice_main.c
@@ -149,7 +149,7 @@ static int ice_init_mac_fltr(struct ice_pf *pf)
 	/* We aren't useful with no MAC filters, so unregister if we
 	 * had an error
 	 */
-	if (status && vsi->netdev->reg_state == NETREG_REGISTERED) {
+	if (vsi->netdev->reg_state == NETREG_REGISTERED) {
 		dev_err(ice_pf_to_dev(pf), "Could not add MAC filters error %s. Unregistering device\n",
 			ice_stat_str(status));
 		unregister_netdev(vsi->netdev);
-- 
2.26.2

