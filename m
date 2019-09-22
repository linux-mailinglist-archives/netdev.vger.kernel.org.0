Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A97A2BA855
	for <lists+netdev@lfdr.de>; Sun, 22 Sep 2019 21:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439084AbfIVTCJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 Sep 2019 15:02:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2395407AbfIVTCI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 22 Sep 2019 15:02:08 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06F262070C;
        Sun, 22 Sep 2019 19:02:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569178927;
        bh=uJycNw4DL+U+YCISpHKsr1iB52emBHrVSbHwAuMW0VY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DES2T/ltkwgIglMSkJEZlAAa6LvlEnCGCfBijM9HNofsBN2Sjch7exj8EClOemrd/
         YvDonNU1WpsHmkL65fUPrFanvJScbMUH7CKo9gs9gEhfibuchRbsgXm5CUu9dwisWT
         UDb2qo5yokg2LdcG52bGz4i1brDIKsbWofhnQaHY=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Kevin Easton <kevin@guarana.org>,
        syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com,
        Kalle Valo <kvalo@codeaurora.org>,
        Sasha Levin <sashal@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH AUTOSEL 4.4 41/44] libertas: Add missing sentinel at end of if_usb.c fw_table
Date:   Sun, 22 Sep 2019 15:00:59 -0400
Message-Id: <20190922190103.4906-41-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190922190103.4906-1-sashal@kernel.org>
References: <20190922190103.4906-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Kevin Easton <kevin@guarana.org>

[ Upstream commit 764f3f1ecffc434096e0a2b02f1a6cc964a89df6 ]

This sentinel tells the firmware loading process when to stop.

Reported-and-tested-by: syzbot+98156c174c5a2cad9f8f@syzkaller.appspotmail.com
Signed-off-by: Kevin Easton <kevin@guarana.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/libertas/if_usb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/libertas/if_usb.c b/drivers/net/wireless/libertas/if_usb.c
index dff08a2896a38..d271eaf1f9499 100644
--- a/drivers/net/wireless/libertas/if_usb.c
+++ b/drivers/net/wireless/libertas/if_usb.c
@@ -49,7 +49,8 @@ static const struct lbs_fw_table fw_table[] = {
 	{ MODEL_8388, "libertas/usb8388_v5.bin", NULL },
 	{ MODEL_8388, "libertas/usb8388.bin", NULL },
 	{ MODEL_8388, "usb8388.bin", NULL },
-	{ MODEL_8682, "libertas/usb8682.bin", NULL }
+	{ MODEL_8682, "libertas/usb8682.bin", NULL },
+	{ 0, NULL, NULL }
 };
 
 static struct usb_device_id if_usb_table[] = {
-- 
2.20.1

