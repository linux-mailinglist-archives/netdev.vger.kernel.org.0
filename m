Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 819D344F1D8
	for <lists+netdev@lfdr.de>; Sat, 13 Nov 2021 07:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233645AbhKMGjU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 13 Nov 2021 01:39:20 -0500
Received: from smtpbg604.qq.com ([59.36.128.82]:59469 "EHLO smtpbg604.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229487AbhKMGjT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 13 Nov 2021 01:39:19 -0500
X-QQ-mid: bizesmtp53t1636785364ty024pn4
Received: from localhost.localdomain (unknown [125.69.41.88])
        by esmtp6.qq.com (ESMTP) with 
        id ; Sat, 13 Nov 2021 14:36:02 +0800 (CST)
X-QQ-SSF: 01000000000000C0F000B00A0000000
X-QQ-FEAT: +i7PuHLNsE5Em7ScpKM6WOjGRq1tr2ekLk5l6HmvAquVxadrH+RsFxKOriVay
        blqSvcNr+eQzlaOHtkpacRs5dSqL6AL3ph+4b0kDXCdpVVRJJg5tK3y/oN4schE+poAi57C
        r4jeyC0nRIHXbtX/URpgxHuI9o7f51/t7EVMBYP9I6xqvGTCJEMcgKgg0wY/32TCPUiBymW
        1CbTKH7i0KvyH8s6ThIg6c7rjjA0rdcc1xhLZjLcW2Ak0fEcVEE+xMj7ieVKFLIAAm4lL92
        sinsvwhaJEuJJfuq3QUaczlWfxg3vo/vAn0gePl9eRT78KBrmpTYb/JXIZEr7F5SOzk0lyM
        n9k7/RYeH7Bjqe5J8HnZ+ma9RAcHDS011JY68pG
X-QQ-GoodBg: 0
From:   Jason Wang <wangborong@cdjrlc.com>
To:     davem@davemloft.net
Cc:     kvalo@codeaurora.org, kuba@kernel.org, wangborong@cdjrlc.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] net: wireless: ti: no need to initialise statics to false
Date:   Sat, 13 Nov 2021 14:35:51 +0800
Message-Id: <20211113063551.257804-1-wangborong@cdjrlc.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: bizesmtp:cdjrlc.com:qybgspam:qybgspam4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Static variables do not need to be initialized to false. The
compiler will do that.

Signed-off-by: Jason Wang <wangborong@cdjrlc.com>
---
 drivers/net/wireless/ti/wlcore/sdio.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ti/wlcore/sdio.c b/drivers/net/wireless/ti/wlcore/sdio.c
index 9fd8cf2d270c..72fc41ac83c0 100644
--- a/drivers/net/wireless/ti/wlcore/sdio.c
+++ b/drivers/net/wireless/ti/wlcore/sdio.c
@@ -26,7 +26,7 @@
 #include "wl12xx_80211.h"
 #include "io.h"
 
-static bool dump = false;
+static bool dump;
 
 struct wl12xx_sdio_glue {
 	struct device *dev;
-- 
2.33.0

