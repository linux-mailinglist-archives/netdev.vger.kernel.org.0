Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7F973D6DC6
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 07:03:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235063AbhG0FDA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 01:03:00 -0400
Received: from mx21.baidu.com ([220.181.3.85]:42734 "EHLO baidu.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S234867AbhG0FC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 01:02:59 -0400
Received: from BJHW-Mail-Ex02.internal.baidu.com (unknown [10.127.64.12])
        by Forcepoint Email with ESMTPS id B2F71E783FFD8FFD276F;
        Tue, 27 Jul 2021 13:02:54 +0800 (CST)
Received: from BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) by
 BJHW-Mail-Ex02.internal.baidu.com (10.127.64.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 27 Jul 2021 13:02:54 +0800
Received: from LAPTOP-UKSR4ENP.internal.baidu.com (172.31.63.8) by
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.14; Tue, 27 Jul 2021 13:02:53 +0800
From:   Cai Huoqing <caihuoqing@baidu.com>
To:     <luciano.coelho@intel.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>, <kuba@kernel.org>,
        <johannes.berg@intel.com>, <nathan.errera@intel.com>,
        <avraham.stern@intel.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Cai Huoqing <caihuoqing@baidu.com>
Subject: [PATCH] iwlwifi: mvm: Change "ERR_PTR(EINVAL)" to "ERR_PTR(-EINVAL)"
Date:   Tue, 27 Jul 2021 13:02:47 +0800
Message-ID: <20210727050247.610-1-caihuoqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: BC-Mail-Ex12.internal.baidu.com (172.31.51.52) To
 BJHW-MAIL-EX27.internal.baidu.com (10.127.64.42)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Use "ERR_PTR(-EINVAL)" instead of "ERR_PTR(EINVAL)"

Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/sta.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
index 32b4d1935788..4d9952e3343f 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/sta.h
@@ -133,7 +133,7 @@ struct iwl_mvm_vif;
  * and no TID data as this is also not needed.
  * One thing to note, is that these stations have an ID in the fw, but not
  * in mac80211. In order to "reserve" them a sta_id in %fw_id_to_mac_id
- * we fill ERR_PTR(EINVAL) in this mapping and all other dereferencing of
+ * we fill ERR_PTR(-EINVAL) in this mapping and all other dereferencing of
  * pointers from this mapping need to check that the value is not error
  * or NULL.
  *
-- 
2.25.1

