Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B2E035604C
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 02:30:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245554AbhDGA2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Apr 2021 20:28:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:47196 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242921AbhDGA2r (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 6 Apr 2021 20:28:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2F5FE61399;
        Wed,  7 Apr 2021 00:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617755319;
        bh=fTr1qb5LSVkUGl7tJ+BHYOHkKExlG5wx7gZWUgXHS80=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQaL7DZ1Yv2Go5Y3nkA16H+1sJAGV2poEZXU7uSy1KcQOOX+Fwtlqcy/EKpdahlX9
         N4BI0x32yVYgZzlBPaeORNbeYBI2moLQDGyqARkfec69aVrVMHShDMKMvFvUsDFFmN
         IH93veDFf/4dZxKOsPJrNzfXmeAvwoJJgwM7nWIS3RNQ6tJ7xnrP60O9MeyUQ6RgFi
         wheUN68FBMAKMcnITSpzwoNsHWcaVaSA0XAXYETlixNJviyunvAt5nlByBfOHjocEI
         g9LhdO36hBs72Ufe32w3gXSyY2AaOP9ME2ZBN5IQEz1rIxIancxmR5qGzq10ncuENj
         r3VI+U5wtcsIw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, f.fainelli@gmail.com,
        mkubecek@suse.cz, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 1/3] ethtool: un-kdocify extended link state
Date:   Tue,  6 Apr 2021 17:28:25 -0700
Message-Id: <20210407002827.1861191-2-kuba@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210407002827.1861191-1-kuba@kernel.org>
References: <20210407002827.1861191-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extended link state structures and enums use kdoc headers
but then do not describe any of the members.

Convert to normal comments.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 include/linux/ethtool.h      |  4 +---
 include/uapi/linux/ethtool.h | 26 ++++++--------------------
 2 files changed, 7 insertions(+), 23 deletions(-)

diff --git a/include/linux/ethtool.h b/include/linux/ethtool.h
index ec4cd3921c67..a2b1a21ee7fd 100644
--- a/include/linux/ethtool.h
+++ b/include/linux/ethtool.h
@@ -87,9 +87,7 @@ u32 ethtool_op_get_link(struct net_device *dev);
 int ethtool_op_get_ts_info(struct net_device *dev, struct ethtool_ts_info *eti);
 
 
-/**
- * struct ethtool_link_ext_state_info - link extended state and substate.
- */
+/* Link extended state and substate. */
 struct ethtool_link_ext_state_info {
 	enum ethtool_link_ext_state link_ext_state;
 	union {
diff --git a/include/uapi/linux/ethtool.h b/include/uapi/linux/ethtool.h
index cde753bb2093..dc87ba092891 100644
--- a/include/uapi/linux/ethtool.h
+++ b/include/uapi/linux/ethtool.h
@@ -579,9 +579,7 @@ struct ethtool_pauseparam {
 	__u32	tx_pause;
 };
 
-/**
- * enum ethtool_link_ext_state - link extended state
- */
+/* Link extended state */
 enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_AUTONEG,
 	ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE,
@@ -595,10 +593,7 @@ enum ethtool_link_ext_state {
 	ETHTOOL_LINK_EXT_STATE_OVERHEAT,
 };
 
-/**
- * enum ethtool_link_ext_substate_autoneg - more information in addition to
- * ETHTOOL_LINK_EXT_STATE_AUTONEG.
- */
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_AUTONEG. */
 enum ethtool_link_ext_substate_autoneg {
 	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_PARTNER_DETECTED = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_AN_ACK_NOT_RECEIVED,
@@ -608,9 +603,7 @@ enum ethtool_link_ext_substate_autoneg {
 	ETHTOOL_LINK_EXT_SUBSTATE_AN_NO_HCD,
 };
 
-/**
- * enum ethtool_link_ext_substate_link_training - more information in addition to
- * ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE.
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_LINK_TRAINING_FAILURE.
  */
 enum ethtool_link_ext_substate_link_training {
 	ETHTOOL_LINK_EXT_SUBSTATE_LT_KR_FRAME_LOCK_NOT_ACQUIRED = 1,
@@ -619,9 +612,7 @@ enum ethtool_link_ext_substate_link_training {
 	ETHTOOL_LINK_EXT_SUBSTATE_LT_REMOTE_FAULT,
 };
 
-/**
- * enum ethtool_link_ext_substate_logical_mismatch - more information in addition
- * to ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH.
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_LINK_LOGICAL_MISMATCH.
  */
 enum ethtool_link_ext_substate_link_logical_mismatch {
 	ETHTOOL_LINK_EXT_SUBSTATE_LLM_PCS_DID_NOT_ACQUIRE_BLOCK_LOCK = 1,
@@ -631,19 +622,14 @@ enum ethtool_link_ext_substate_link_logical_mismatch {
 	ETHTOOL_LINK_EXT_SUBSTATE_LLM_RS_FEC_IS_NOT_LOCKED,
 };
 
-/**
- * enum ethtool_link_ext_substate_bad_signal_integrity - more information in
- * addition to ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY.
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_BAD_SIGNAL_INTEGRITY.
  */
 enum ethtool_link_ext_substate_bad_signal_integrity {
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_LARGE_NUMBER_OF_PHYSICAL_ERRORS = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_BSI_UNSUPPORTED_RATE,
 };
 
-/**
- * enum ethtool_link_ext_substate_cable_issue - more information in
- * addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE.
- */
+/* More information in addition to ETHTOOL_LINK_EXT_STATE_CABLE_ISSUE. */
 enum ethtool_link_ext_substate_cable_issue {
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_UNSUPPORTED_CABLE = 1,
 	ETHTOOL_LINK_EXT_SUBSTATE_CI_CABLE_TEST_FAILURE,
-- 
2.30.2

