Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 33F2136F42E
	for <lists+netdev@lfdr.de>; Fri, 30 Apr 2021 04:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229863AbhD3C6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 22:58:37 -0400
Received: from mail-m176218.qiye.163.com ([59.111.176.218]:33240 "EHLO
        mail-m176218.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229577AbhD3C6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 22:58:37 -0400
X-Greylist: delayed 424 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Apr 2021 22:58:36 EDT
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m176218.qiye.163.com (Hmail) with ESMTPA id BADDB32009B;
        Fri, 30 Apr 2021 10:50:42 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Yan-Hsuan Chuang <tony0620emma@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] rtw88: Remove duplicate include of coex.h
Date:   Fri, 30 Apr 2021 10:49:50 +0800
Message-Id: <20210430024951.33406-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZQ0xJGlYZS0NLGkIeGUkZS09VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        9ISFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Mio6Hjo*Cz8SQ0gzNjRWMjow
        Ew4KFDhVSlVKTUpCTE5KS09ITktMVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKTExDNwY+
X-HM-Tid: 0a7920af7fadd978kuwsbaddb32009b
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In commit fb8517f4fade4 ("rtw88: 8822c: add CFO tracking"),
"coex.h" was added here which caused the duplicate include.
Remove the later duplicate include.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/wireless/realtek/rtw88/rtw8822c.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw88/rtw8822c.c b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
index 6cb593cc33c2..1cb7059e06d9 100644
--- a/drivers/net/wireless/realtek/rtw88/rtw8822c.c
+++ b/drivers/net/wireless/realtek/rtw88/rtw8822c.c
@@ -17,7 +17,6 @@
 #include "util.h"
 #include "bf.h"
 #include "efuse.h"
-#include "coex.h"
 
 #define IQK_DONE_8822C 0xaa
 
-- 
2.25.1

