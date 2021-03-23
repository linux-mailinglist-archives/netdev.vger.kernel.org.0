Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC32234555A
	for <lists+netdev@lfdr.de>; Tue, 23 Mar 2021 03:11:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230042AbhCWCLG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 22:11:06 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:56528 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229931AbhCWCKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 22:10:35 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id C716298049C;
        Tue, 23 Mar 2021 10:10:31 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Dan Murphy <dmurphy@ti.com>,
        Wolfgang Grandegger <wg@grandegger.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-can@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: can: Remove duplicate include of regmap.h
Date:   Tue, 23 Mar 2021 10:10:25 +0800
Message-Id: <20210323021026.140460-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZHkhCQh1ISBhNHUoYVkpNSk1PTU5PSElLQkxVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MDI6Dyo*PT8NQzoxLgsQThA1
        TisaCTVVSlVKTUpNT01OT0hJQkxLVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKTE1KNwY+
X-HM-Tid: 0a785cd90dc9d992kuwsc716298049c
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

linux/regmap.h has been included at line 13, so remove the 
duplicate one at line 14.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/can/m_can/tcan4x5x.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/can/m_can/tcan4x5x.h b/drivers/net/can/m_can/tcan4x5x.h
index c66da829b795..e62c030d3e1e 100644
--- a/drivers/net/can/m_can/tcan4x5x.h
+++ b/drivers/net/can/m_can/tcan4x5x.h
@@ -11,7 +11,6 @@
 
 #include <linux/gpio/consumer.h>
 #include <linux/regmap.h>
-#include <linux/regmap.h>
 #include <linux/regulator/consumer.h>
 #include <linux/spi/spi.h>
 
-- 
2.25.1

