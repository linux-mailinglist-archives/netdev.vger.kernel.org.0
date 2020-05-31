Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 158591E979A
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 14:36:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728225AbgEaMg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 08:36:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:12466 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728153AbgEaMg0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 31 May 2020 08:36:26 -0400
IronPort-SDR: cWbV+kXLEUAGRat74pw2pWQOWIxwokAVsP1NWFeiW9kxns09tRxwqkwKAT5V6K1FDuIax3HpgQ
 GpAjqD1qUzCA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 May 2020 05:36:24 -0700
IronPort-SDR: FuJwTpE0HjfKieN86eLsaWvkU8T3Lmatv3Bhn98ceaUXy1JIgR3cOqsDY/U+OMh8MLevQv49iB
 EC7Tq+IeQmhg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,456,1583222400"; 
   d="scan'208";a="303345445"
Received: from jtkirshe-desk1.jf.intel.com ([134.134.177.86])
  by fmsmga002.fm.intel.com with ESMTP; 31 May 2020 05:36:24 -0700
From:   Jeff Kirsher <jeffrey.t.kirsher@intel.com>
To:     davem@davemloft.net
Cc:     Bruce Allan <bruce.w.allan@intel.com>, netdev@vger.kernel.org,
        nhorman@redhat.com, sassmann@redhat.com,
        Andrew Bowers <andrewx.bowers@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [net-next 10/14] ice: fix function signature style format
Date:   Sun, 31 May 2020 05:36:15 -0700
Message-Id: <20200531123619.2887469-11-jeffrey.t.kirsher@intel.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
References: <20200531123619.2887469-1-jeffrey.t.kirsher@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bruce Allan <bruce.w.allan@intel.com>

Where possible, cuddle multiple lines of function signatures to be
consistent throughout the code.

Signed-off-by: Bruce Allan <bruce.w.allan@intel.com>
Tested-by: Andrew Bowers <andrewx.bowers@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
---
 drivers/net/ethernet/intel/ice/ice_controlq.c |  3 +--
 drivers/net/ethernet/intel/ice/ice_sched.c    | 12 ++++--------
 drivers/net/ethernet/intel/ice/ice_switch.c   |  9 +++------
 3 files changed, 8 insertions(+), 16 deletions(-)

diff --git a/drivers/net/ethernet/intel/ice/ice_controlq.c b/drivers/net/ethernet/intel/ice/ice_controlq.c
index 479a74efc536..1e18021aa073 100644
--- a/drivers/net/ethernet/intel/ice/ice_controlq.c
+++ b/drivers/net/ethernet/intel/ice/ice_controlq.c
@@ -769,8 +769,7 @@ enum ice_status ice_create_all_ctrlq(struct ice_hw *hw)
  *
  * Destroys the send and receive queue locks for a given control queue.
  */
-static void
-ice_destroy_ctrlq_locks(struct ice_ctl_q_info *cq)
+static void ice_destroy_ctrlq_locks(struct ice_ctl_q_info *cq)
 {
 	mutex_destroy(&cq->sq_lock);
 	mutex_destroy(&cq->rq_lock);
diff --git a/drivers/net/ethernet/intel/ice/ice_sched.c b/drivers/net/ethernet/intel/ice/ice_sched.c
index d63acd2fcf79..0475134295e4 100644
--- a/drivers/net/ethernet/intel/ice/ice_sched.c
+++ b/drivers/net/ethernet/intel/ice/ice_sched.c
@@ -1714,8 +1714,7 @@ ice_sched_cfg_vsi(struct ice_port_info *pi, u16 vsi_handle, u8 tc, u16 maxqs,
  * This function removes single aggregator VSI info entry from
  * aggregator list.
  */
-static void
-ice_sched_rm_agg_vsi_info(struct ice_port_info *pi, u16 vsi_handle)
+static void ice_sched_rm_agg_vsi_info(struct ice_port_info *pi, u16 vsi_handle)
 {
 	struct ice_sched_agg_info *agg_info;
 	struct ice_sched_agg_info *atmp;
@@ -1947,8 +1946,7 @@ ice_sched_cfg_node_bw_alloc(struct ice_hw *hw, struct ice_sched_node *node,
  *
  * Save or clear CIR bandwidth (BW) in the passed param bw_t_info.
  */
-static void
-ice_set_clear_cir_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
+static void ice_set_clear_cir_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
 {
 	if (bw == ICE_SCHED_DFLT_BW) {
 		clear_bit(ICE_BW_TYPE_CIR, bw_t_info->bw_t_bitmap);
@@ -1967,8 +1965,7 @@ ice_set_clear_cir_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
  *
  * Save or clear EIR bandwidth (BW) in the passed param bw_t_info.
  */
-static void
-ice_set_clear_eir_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
+static void ice_set_clear_eir_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
 {
 	if (bw == ICE_SCHED_DFLT_BW) {
 		clear_bit(ICE_BW_TYPE_EIR, bw_t_info->bw_t_bitmap);
@@ -1993,8 +1990,7 @@ ice_set_clear_eir_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
  *
  * Save or clear shared bandwidth (BW) in the passed param bw_t_info.
  */
-static void
-ice_set_clear_shared_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
+static void ice_set_clear_shared_bw(struct ice_bw_type_info *bw_t_info, u32 bw)
 {
 	if (bw == ICE_SCHED_DFLT_BW) {
 		clear_bit(ICE_BW_TYPE_SHARED, bw_t_info->bw_t_bitmap);
diff --git a/drivers/net/ethernet/intel/ice/ice_switch.c b/drivers/net/ethernet/intel/ice/ice_switch.c
index 0156b73df1b1..ff7d16ac693e 100644
--- a/drivers/net/ethernet/intel/ice/ice_switch.c
+++ b/drivers/net/ethernet/intel/ice/ice_switch.c
@@ -1612,8 +1612,7 @@ ice_remove_rule_internal(struct ice_hw *hw, u8 recp_id,
  * check for duplicates in this case, removing duplicates from a given
  * list should be taken care of in the caller of this function.
  */
-enum ice_status
-ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
+enum ice_status ice_add_mac(struct ice_hw *hw, struct list_head *m_list)
 {
 	struct ice_aqc_sw_rules_elem *s_rule, *r_iter;
 	struct ice_fltr_list_entry *m_list_itr;
@@ -1914,8 +1913,7 @@ ice_add_vlan_internal(struct ice_hw *hw, struct ice_fltr_list_entry *f_entry)
  * @hw: pointer to the hardware structure
  * @v_list: list of VLAN entries and forwarding information
  */
-enum ice_status
-ice_add_vlan(struct ice_hw *hw, struct list_head *v_list)
+enum ice_status ice_add_vlan(struct ice_hw *hw, struct list_head *v_list)
 {
 	struct ice_fltr_list_entry *v_list_itr;
 
@@ -2145,8 +2143,7 @@ ice_find_ucast_rule_entry(struct ice_hw *hw, u8 recp_id,
  * the entries passed into m_list were added previously. It will not attempt to
  * do a partial remove of entries that were found.
  */
-enum ice_status
-ice_remove_mac(struct ice_hw *hw, struct list_head *m_list)
+enum ice_status ice_remove_mac(struct ice_hw *hw, struct list_head *m_list)
 {
 	struct ice_fltr_list_entry *list_itr, *tmp;
 	struct mutex *rule_lock; /* Lock to protect filter rule list */
-- 
2.26.2

