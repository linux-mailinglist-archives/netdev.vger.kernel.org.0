Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E10E196341
	for <lists+netdev@lfdr.de>; Sat, 28 Mar 2020 04:05:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727183AbgC1DFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 23:05:46 -0400
Received: from szxga04-in.huawei.com ([45.249.212.190]:12142 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726291AbgC1DFp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Mar 2020 23:05:45 -0400
Received: from DGGEMS412-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id E9E78A342D228A8D8D03;
        Sat, 28 Mar 2020 11:05:39 +0800 (CST)
Received: from localhost (10.173.223.234) by DGGEMS412-HUB.china.huawei.com
 (10.3.19.212) with Microsoft SMTP Server id 14.3.487.0; Sat, 28 Mar 2020
 11:05:30 +0800
From:   YueHaibing <yuehaibing@huawei.com>
To:     <yhchuang@realtek.com>, <kvalo@codeaurora.org>,
        <davem@davemloft.net>
CC:     <linux-wireless@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] rtw88: Make two functions static
Date:   Sat, 28 Mar 2020 11:05:24 +0800
Message-ID: <20200328030524.16032-1-yuehaibing@huawei.com>
X-Mailer: git-send-email 2.10.2.windows.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.173.223.234]
X-CFilter-Loop: Reflected
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix sparse warnings:

drivers/net/wireless/realtek/rtw88/fw.c:633:4: warning:
 symbol 'rtw_get_rsvd_page_probe_req_location' was not declared. Should it be static?
drivers/net/wireless/realtek/rtw88/fw.c:650:5: warning:
 symbol 'rtw_get_rsvd_page_probe_req_size' was not declared. Should it be static?

Reported-by: Hulk Robot <hulkci@huawei.com>
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/realtek/rtw88/fw.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/fw.c b/drivers/net/wireless/realtek/rtw88/fw.c
index 05c430b3489c..9192ab26e39b 100644
--- a/drivers/net/wireless/realtek/rtw88/fw.c
+++ b/drivers/net/wireless/realtek/rtw88/fw.c
@@ -630,8 +630,8 @@ void rtw_fw_set_pg_info(struct rtw_dev *rtwdev)
 	rtw_fw_send_h2c_command(rtwdev, h2c_pkt);
 }
 
-u8 rtw_get_rsvd_page_probe_req_location(struct rtw_dev *rtwdev,
-					struct cfg80211_ssid *ssid)
+static u8 rtw_get_rsvd_page_probe_req_location(struct rtw_dev *rtwdev,
+					       struct cfg80211_ssid *ssid)
 {
 	struct rtw_rsvd_page *rsvd_pkt;
 	u8 location = 0;
@@ -647,8 +647,8 @@ u8 rtw_get_rsvd_page_probe_req_location(struct rtw_dev *rtwdev,
 	return location;
 }
 
-u16 rtw_get_rsvd_page_probe_req_size(struct rtw_dev *rtwdev,
-				     struct cfg80211_ssid *ssid)
+static u16 rtw_get_rsvd_page_probe_req_size(struct rtw_dev *rtwdev,
+					    struct cfg80211_ssid *ssid)
 {
 	struct rtw_rsvd_page *rsvd_pkt;
 	u16 size = 0;
-- 
2.17.1


