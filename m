Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1DB6F1DE046
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 08:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728489AbgEVG4Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 02:56:24 -0400
Received: from mga14.intel.com ([192.55.52.115]:18662 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728459AbgEVG4W (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 May 2020 02:56:22 -0400
IronPort-SDR: trZD76JWh3zXn0ukwn7sGL+ngZ5+0gpBnfYHZFNS4WwDyuGH5Nr6j0PR4TlpdH6zjITfXJtGWU
 JadSDCt9AdCQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 May 2020 23:56:12 -0700
IronPort-SDR: r0dTcGU83VCNOZhnnVx0ROXFofCNu+3ZLY3/jdW3lRvrRHR7jEC2JxfR4Enrl6lF5WdFRwMZ/m
 m+vsTjWSEZBQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,420,1583222400"; 
   d="scan'208";a="290017783"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga004.fm.intel.com with ESMTP; 21 May 2020 23:56:11 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 16/17] ice: remove unnecessary backslash
Date:   Thu, 21 May 2020 23:56:06 -0700
Message-Id: <20200522065607.1680050-17-jeffrey.t.kirsher@intel.com>
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

Self-explanatory.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_adminq_cmd.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
index 8767a78038e0..979e9c6254af 100644
--- a/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
+++ b/drivers/net/ethernet/intel/ice/ice_adminq_cmd.h
@@ -541,7 +541,7 @@ struct ice_sw_rule_lkup_rx_tx {
 #define ICE_SINGLE_ACT_OTHER_ACTS		0x3
 #define ICE_SINGLE_OTHER_ACT_IDENTIFIER_S	17
 #define ICE_SINGLE_OTHER_ACT_IDENTIFIER_M	\
-				(0x3 << \ ICE_SINGLE_OTHER_ACT_IDENTIFIER_S)
+				(0x3 << ICE_SINGLE_OTHER_ACT_IDENTIFIER_S)
 
 	/* Bit 17:18 - Defines other actions */
 	/* Other action = 0 - Mirror VSI */
-- 
2.26.2

