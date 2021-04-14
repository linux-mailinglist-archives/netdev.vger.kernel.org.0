Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED7BD35F1E2
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 13:08:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236765AbhDNLHW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 07:07:22 -0400
Received: from mail-m17635.qiye.163.com ([59.111.176.35]:33792 "EHLO
        mail-m17635.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235926AbhDNLHT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 07:07:19 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17635.qiye.163.com (Hmail) with ESMTPA id 8F3AE40031E;
        Wed, 14 Apr 2021 19:06:53 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Edward Cree <ecree.xilinx@gmail.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] sfc: Remove duplicate argument
Date:   Wed, 14 Apr 2021 19:06:45 +0800
Message-Id: <20210414110645.8128-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGU0eSFZOTE4YTUxKTExCQ0pVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWUFZT0tIVUpKS0
        hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Pkk6Pxw6Oj8VOBM3Ehk6MxUZ
        LRQwFBZVSlVKTUpDSEJDT0pPSk9LVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKTEhINwY+
X-HM-Tid: 0a78d01003e1d991kuws8f3ae40031e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix the following coccicheck warning:

./drivers/net/ethernet/sfc/enum.h:80:7-28: duplicated argument to |

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/ethernet/sfc/enum.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/sfc/enum.h b/drivers/net/ethernet/sfc/enum.h
index 3332cdf2918a..cd590e0685e5 100644
--- a/drivers/net/ethernet/sfc/enum.h
+++ b/drivers/net/ethernet/sfc/enum.h
@@ -78,7 +78,6 @@ enum efx_loopback_mode {
 			    (1 << LOOPBACK_XAUI) |		\
 			    (1 << LOOPBACK_GMII) |		\
 			    (1 << LOOPBACK_SGMII) |		\
-			    (1 << LOOPBACK_SGMII) |		\
 			    (1 << LOOPBACK_XGBR) |		\
 			    (1 << LOOPBACK_XFI) |		\
 			    (1 << LOOPBACK_XAUI_FAR) |		\
-- 
2.25.1

