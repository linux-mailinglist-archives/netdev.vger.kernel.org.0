Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 873C3CB34C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 04:36:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731961AbfJDCgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 22:36:36 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:52336 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728360AbfJDCgg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 22:36:36 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id 9083BD9F2CCEE641D326;
        Fri,  4 Oct 2019 10:36:34 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Fri, 4 Oct 2019
 10:36:27 +0800
To:     <pkshih@realtek.com>, <kvalo@codeaurora.org>,
        <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>
CC:     <zhengbin13@huawei.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Subject: [PATCH v2] rtlwifi: rtl8192ee: Remove set but not used variable 'err'
Message-ID: <2ca176f2-e9ef-87cd-7f7d-cd51c67da38b@huawei.com>
Date:   Fri, 4 Oct 2019 10:36:16 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes gcc '-Wunused-but-set-variable' warning:

drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c: In function rtl92ee_download_fw:
drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c:111:6: warning: variable err set but not used [-Wunused-but-set-variable]

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: zhengbin <zhengbin13@huawei.com>
---
 drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
index 67305ce..0546242 100644
--- a/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
+++ b/drivers/net/wireless/realtek/rtlwifi/rtl8192ee/fw.c
@@ -108,7 +108,6 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
        struct rtlwifi_firmware_header *pfwheader;
        u8 *pfwdata;
        u32 fwsize;
-       int err;
        enum version_8192e version = rtlhal->version;

        if (!rtlhal->pfirmware)
@@ -146,9 +145,7 @@ int rtl92ee_download_fw(struct ieee80211_hw *hw, bool buse_wake_on_wlan_fw)
        _rtl92ee_write_fw(hw, version, pfwdata, fwsize);
        _rtl92ee_enable_fw_download(hw, false);

-       err = _rtl92ee_fw_free_to_go(hw);
-
-       return 0;
+       return _rtl92ee_fw_free_to_go(hw);
 }

 static bool _rtl92ee_check_fw_read_last_h2c(struct ieee80211_hw *hw, u8 boxnum)
--
2.7.4


