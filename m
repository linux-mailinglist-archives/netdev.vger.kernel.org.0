Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2290A350A86
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 01:08:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhCaXHr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 19:07:47 -0400
Received: from mga14.intel.com ([192.55.52.115]:62994 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230380AbhCaXH1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 19:07:27 -0400
IronPort-SDR: PJ2VO+TcVYs4gqP5tZT6x+KajQoYw2DDKhQXm8A9ip5E2kx2PSfIEBtjqwuND+trux3nwt47PJ
 0FThSZbGDZnQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9940"; a="191587982"
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="191587982"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Mar 2021 16:07:24 -0700
IronPort-SDR: Y99dIU/gQiTUD16/a5xds3TnkQvkqWzQqxQZXYIVjMRjOV7K6oTWSLJ9ANqvzwbO8pOZxksyNZ
 MEVcVH0YgNGg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,295,1610438400"; 
   d="scan'208";a="610680130"
Received: from anguy11-desk2.jf.intel.com ([10.166.244.147])
  by fmsmga005.fm.intel.com with ESMTP; 31 Mar 2021 16:07:24 -0700
From:   Tony Nguyen <anthony.l.nguyen@intel.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     Qi Zhang <qi.z.zhang@intel.com>, netdev@vger.kernel.org,
        sassmann@redhat.com, anthony.l.nguyen@intel.com,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: [PATCH net-next 09/15] ice: rename ptype bitmap
Date:   Wed, 31 Mar 2021 16:08:52 -0700
Message-Id: <20210331230858.782492-10-anthony.l.nguyen@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
References: <20210331230858.782492-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Qi Zhang <qi.z.zhang@intel.com>

Align all ptype bitmap to follow ice_ptypes_xxx prefix.

Signed-off-by: Qi Zhang <qi.z.zhang@intel.com>
Tested-by: Tony Brelinski <tonyx.brelinski@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_flow.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_flow.c b/drivers/net/ethernet/intel/ice/ice_flow.c
index 8e8bfc6fa2b4..571245799646 100644
--- a/drivers/net/ethernet/intel/ice/ice_flow.c
+++ b/drivers/net/ethernet/intel/ice/ice_flow.c
@@ -238,7 +238,7 @@ static const u32 ice_ptypes_ipv6_il[] = {
 };
 
 /* Packet types for packets with an Outer/First/Single IPv4 header - no L4 */
-static const u32 ice_ipv4_ofos_no_l4[] = {
+static const u32 ice_ptypes_ipv4_ofos_no_l4[] = {
 	0x10C00000, 0x04000800, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -262,7 +262,7 @@ static const u32 ice_ptypes_arp_of[] = {
 };
 
 /* Packet types for packets with an Innermost/Last IPv4 header - no L4 */
-static const u32 ice_ipv4_il_no_l4[] = {
+static const u32 ice_ptypes_ipv4_il_no_l4[] = {
 	0x60000000, 0x18043008, 0x80000002, 0x6010c021,
 	0x00000008, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -274,7 +274,7 @@ static const u32 ice_ipv4_il_no_l4[] = {
 };
 
 /* Packet types for packets with an Outer/First/Single IPv6 header - no L4 */
-static const u32 ice_ipv6_ofos_no_l4[] = {
+static const u32 ice_ptypes_ipv6_ofos_no_l4[] = {
 	0x00000000, 0x00000000, 0x43000000, 0x10002000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -286,7 +286,7 @@ static const u32 ice_ipv6_ofos_no_l4[] = {
 };
 
 /* Packet types for packets with an Innermost/Last IPv6 header - no L4 */
-static const u32 ice_ipv6_il_no_l4[] = {
+static const u32 ice_ptypes_ipv6_il_no_l4[] = {
 	0x00000000, 0x02180430, 0x0000010c, 0x086010c0,
 	0x00000430, 0x00000000, 0x00000000, 0x00000000,
 	0x00000000, 0x00000000, 0x00000000, 0x00000000,
@@ -749,8 +749,8 @@ ice_flow_proc_seg_hdrs(struct ice_flow_prof_params *params)
 				   ICE_FLOW_PTYPE_MAX);
 		} else if ((hdrs & ICE_FLOW_SEG_HDR_IPV4) &&
 			   !(hdrs & ICE_FLOW_SEG_HDRS_L4_MASK_NO_OTHER)) {
-			src = !i ? (const unsigned long *)ice_ipv4_ofos_no_l4 :
-				(const unsigned long *)ice_ipv4_il_no_l4;
+			src = !i ? (const unsigned long *)ice_ptypes_ipv4_ofos_no_l4 :
+				(const unsigned long *)ice_ptypes_ipv4_il_no_l4;
 			bitmap_and(params->ptypes, params->ptypes, src,
 				   ICE_FLOW_PTYPE_MAX);
 		} else if (hdrs & ICE_FLOW_SEG_HDR_IPV4) {
@@ -760,8 +760,8 @@ ice_flow_proc_seg_hdrs(struct ice_flow_prof_params *params)
 				   ICE_FLOW_PTYPE_MAX);
 		} else if ((hdrs & ICE_FLOW_SEG_HDR_IPV6) &&
 			   !(hdrs & ICE_FLOW_SEG_HDRS_L4_MASK_NO_OTHER)) {
-			src = !i ? (const unsigned long *)ice_ipv6_ofos_no_l4 :
-				(const unsigned long *)ice_ipv6_il_no_l4;
+			src = !i ? (const unsigned long *)ice_ptypes_ipv6_ofos_no_l4 :
+				(const unsigned long *)ice_ptypes_ipv6_il_no_l4;
 			bitmap_and(params->ptypes, params->ptypes, src,
 				   ICE_FLOW_PTYPE_MAX);
 		} else if (hdrs & ICE_FLOW_SEG_HDR_IPV6) {
-- 
2.26.2

