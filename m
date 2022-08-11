Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC80E58FBC1
	for <lists+netdev@lfdr.de>; Thu, 11 Aug 2022 14:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235002AbiHKMBC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Aug 2022 08:01:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234867AbiHKMBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Aug 2022 08:01:01 -0400
Received: from bg5.exmail.qq.com (bg4.exmail.qq.com [43.154.54.12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD5A074CEB
        for <netdev@vger.kernel.org>; Thu, 11 Aug 2022 05:00:59 -0700 (PDT)
X-QQ-mid: bizesmtp72t1660219210tid1pnkj
Received: from localhost.localdomain ( [182.148.14.53])
        by bizesmtp.qq.com (ESMTP) with 
        id ; Thu, 11 Aug 2022 20:00:08 +0800 (CST)
X-QQ-SSF: 01000000002000G0V000B00A0000000
X-QQ-FEAT: +ynUkgUhZJlh4QU7qlyOKL9KPfT5yeQDGoJeb9eymFsmNRXZSqmNgGXKbA4yp
        TzLuw9LDdvVs7CJ8s9Yrhgz0Owuc4YFYUO1Jx6mxN2mDEqgbdPq5CSpDB/7hq4nYeBbtBI8
        AVMsd5hR6R3oUh3BL5IQIWarQP9vZen+YWmIP5dWHN5OnWYe1mvgn9/n4LGKYzLHlPmk0ir
        fuwTAq2Zp+WUyV01QZkp3F+Nsga0hBhnSqt2hVMWTwCEaFN+jOY4EMsJG+BS0M++MOG+Qkf
        XQvdTo70QGAdcaBsYZMsKlIUPlZOXjfSgUzhkjKMN1PBWgwq8Us2QxgPSaUXCn6SfAXh/KA
        7V2+zgsRPWdYyV3t8a0jNdzB3dliM5F3/66drp9G9yXsQlfpG6vzOd47u8jk+IhXOYRJaxA
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     davem@davemloft.net
Cc:     gregory.greenman@intel.com, kvalo@kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, luciano.coelho@intel.com,
        johannes.berg@intel.com, mordechay.goodstein@intel.com,
        nathan.errera@intel.com, quic_srirrama@quicinc.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jason Wang <wangborong@cdjrlc.com>
Subject: [PATCH] wifi: iwlwifi: Fix comment typo
Date:   Thu, 11 Aug 2022 19:59:58 +0800
Message-Id: <20220811115958.8423-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybglogicsvr:qybglogicsvr6
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The double `if' is duplicated in the comment, remove one.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
index ff0d3b3df140..323588e262a6 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.c
@@ -2724,7 +2724,7 @@ int iwl_mvm_sta_rx_agg(struct iwl_mvm *mvm, struct ieee80211_sta *sta,
 		/*
 		 * The division below will be OK if either the cache line size
 		 * can be divided by the entry size (ALIGN will round up) or if
-		 * if the entry size can be divided by the cache line size, in
+		 * the entry size can be divided by the cache line size, in
 		 * which case the ALIGN() will do nothing.
 		 */
 		BUILD_BUG_ON(SMP_CACHE_BYTES % sizeof(baid_data->entries[0]) &&
-- 
2.36.1

