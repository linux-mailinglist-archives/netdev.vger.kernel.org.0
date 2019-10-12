Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1313CD4F18
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 12:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729165AbfJLKom (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 06:44:42 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:3703 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727507AbfJLKml (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Oct 2019 06:42:41 -0400
Received: from DGGEMS414-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 65E7B40191098360B728;
        Sat, 12 Oct 2019 18:42:38 +0800 (CST)
Received: from localhost (10.133.213.239) by DGGEMS414-HUB.china.huawei.com
 (10.3.19.214) with Microsoft SMTP Server id 14.3.439.0; Sat, 12 Oct 2019
 18:42:26 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <johannes.berg@intel.com>, <emmanuel.grumbach@intel.com>,
        <luciano.coelho@intel.com>, <linuxwifi@intel.com>,
        <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <sara.sharon@intel.com>, <shahar.s.matityahu@intel.com>,
        <ilan.peer@intel.com>, <liad.kaufman@intel.com>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] iwlwifi: mvm: Move static keyword to the front of declarations
Date:   Sat, 12 Oct 2019 18:41:14 +0800
Message-ID: <20191012104114.21356-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.133.213.239]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

gcc warn about this:

drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:342:1:
 warning: static is not at beginning of declaration [-Wold-style-declaration]
drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c:349:1:
 warning: static is not at beginning of declaration [-Wold-style-declaration]

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
index d31f96c..0358c67 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c
@@ -339,14 +339,14 @@ int iwl_mvm_init_fw_regd(struct iwl_mvm *mvm)
 	return ret;
 }
 
-const static u8 he_if_types_ext_capa_sta[] = {
+static const u8 he_if_types_ext_capa_sta[] = {
 	 [0] = WLAN_EXT_CAPA1_EXT_CHANNEL_SWITCHING,
 	 [2] = WLAN_EXT_CAPA3_MULTI_BSSID_SUPPORT,
 	 [7] = WLAN_EXT_CAPA8_OPMODE_NOTIF,
 	 [9] = WLAN_EXT_CAPA10_TWT_REQUESTER_SUPPORT,
 };
 
-const static struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
+static const struct wiphy_iftype_ext_capab he_iftypes_ext_capa[] = {
 	{
 		.iftype = NL80211_IFTYPE_STATION,
 		.extended_capabilities = he_if_types_ext_capa_sta,
-- 
2.7.4


