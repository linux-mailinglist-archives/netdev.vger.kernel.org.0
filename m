Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 87EF3430999
	for <lists+netdev@lfdr.de>; Sun, 17 Oct 2021 16:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237042AbhJQOHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Oct 2021 10:07:36 -0400
Received: from smtpbg604.qq.com ([59.36.128.82]:45528 "EHLO smtpbg604.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236660AbhJQOHf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 17 Oct 2021 10:07:35 -0400
X-QQ-mid: bizesmtp38t1634479512t0h13aby
Received: from localhost.localdomain (unknown [125.70.163.155])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sun, 17 Oct 2021 22:05:10 +0800 (CST)
X-QQ-SSF: 01000000008000B0C000B00A0000000
X-QQ-FEAT: rn/rQ7Qm5gWdCk5JbhbQSTGJnjljZ1hDnk+3bFOOdNKN64lt9zw7RqM9MW/mM
        nb3yCUEYgjCRG6VDdOdGHuXTSwVuhOv0Fopv5Cdi7RjJWgrT2G/jTGfAwWwgBarAD8pER+L
        bpBt60qXXRM7LfJUxyAhBm76bjTAdATbTFc9cioO20EalVDlH8jzmAz14/ITcGOnwvbQFGj
        TtHQKDsaRO7MFNNhxIDqSuH/4XxwgLeUYzWVRKBS2cQxcObwuFJQLbg6l5rdT439SITY0qr
        clT4Q496+04telqpO9hkVu/rFIk9MVD2yVHhLND7ifDBwK1vAGCQRaxQNqKe5zDlEgoQBic
        jyLW2veJguQ24Dz1EK+zxHLwU/QpQ==
X-QQ-GoodBg: 0
From:   Huilong Deng <denghuilong@cdjrlc.com>
To:     nbd@nbd.name, lorenzo.bianconi83@gmail.com, kvalo@codeaurora.org
Cc:     colin.king@canonical.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Huilong Deng <denghuilong@cdjrlc.com>
Subject: [PATCH] mt76: Return true/false (not 1/0) from bool functions
Date:   Sun, 17 Oct 2021 22:03:38 +0800
Message-Id: <20211017140338.65469-1-denghuilong@cdjrlc.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Huilong Deng <denghuilong@cdjrlc.com>
---
 drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
index 996d48cca18a..bd2939ebcbf4 100644
--- a/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
+++ b/drivers/net/wireless/mediatek/mt76/mt7615/usb_sdio.c
@@ -169,7 +169,7 @@ bool mt7663_usb_sdio_tx_status_data(struct mt76_dev *mdev, u8 *update)
 	mt7615_mac_sta_poll(dev);
 	mt7615_mutex_release(dev);
 
-	return 0;
+	return false;
 }
 EXPORT_SYMBOL_GPL(mt7663_usb_sdio_tx_status_data);
 
-- 
2.32.0

