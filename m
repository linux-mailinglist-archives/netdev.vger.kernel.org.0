Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9FC4430E25
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 05:23:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231327AbhJRDZs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 23:25:48 -0400
Received: from szxga01-in.huawei.com ([45.249.212.187]:29901 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230429AbhJRDZr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Oct 2021 23:25:47 -0400
Received: from dggemv711-chm.china.huawei.com (unknown [172.30.72.57])
        by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4HXhtH6hxpzbmRn;
        Mon, 18 Oct 2021 11:19:03 +0800 (CST)
Received: from dggpeml500017.china.huawei.com (7.185.36.243) by
 dggemv711-chm.china.huawei.com (10.1.198.66) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Mon, 18 Oct 2021 11:23:35 +0800
Received: from huawei.com (10.175.103.91) by dggpeml500017.china.huawei.com
 (7.185.36.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.15; Mon, 18 Oct
 2021 11:23:35 +0800
From:   Yang Yingliang <yangyingliang@huawei.com>
To:     <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <linux-wireless@vger.kernel.org>
CC:     <pkshih@realtek.com>, <kuba@kernel.org>, <davem@davemloft.net>,
        <kvalo@codeaurora.org>
Subject: [PATCH net-next] rtw89: fix return value check in rtw89_cam_send_sec_key_cmd()
Date:   Mon, 18 Oct 2021 11:31:02 +0800
Message-ID: <20211018033102.1813058-1-yangyingliang@huawei.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-Originating-IP: [10.175.103.91]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 dggpeml500017.china.huawei.com (7.185.36.243)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the return value check which testing the wrong variable
in rtw89_cam_send_sec_key_cmd().

Reported-by: Hulk Robot <hulkci@huawei.com>
Fixes: e3ec7017f6a2 ("rtw89: add Realtek 802.11ax driver")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
---
 drivers/net/wireless/realtek/rtw89/cam.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/cam.c b/drivers/net/wireless/realtek/rtw89/cam.c
index c1e8c76c6aca..ad7a8155dbed 100644
--- a/drivers/net/wireless/realtek/rtw89/cam.c
+++ b/drivers/net/wireless/realtek/rtw89/cam.c
@@ -77,7 +77,7 @@ static int rtw89_cam_send_sec_key_cmd(struct rtw89_dev *rtwdev,
 		return 0;
 
 	ext_skb = rtw89_cam_get_sec_key_cmd(rtwdev, sec_cam, true);
-	if (!skb) {
+	if (!ext_skb) {
 		rtw89_err(rtwdev, "failed to get ext sec key command\n");
 		return -ENOMEM;
 	}
-- 
2.25.1

