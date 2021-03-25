Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E570348949
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 07:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbhCYGmi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Mar 2021 02:42:38 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:12254 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbhCYGmN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Mar 2021 02:42:13 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id D8FD2980360;
        Thu, 25 Mar 2021 14:42:09 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Wan Jiabing <wanjiabing@vivo.com>,
        libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net
Subject: [PATCH] drivers: net: wireless: struct lbs_private is declared duplicately
Date:   Thu, 25 Mar 2021 14:41:51 +0800
Message-Id: <20210325064154.854245-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGEsfHUIZTBoeHRgeVkpNSk1NTk9OSEtKTElVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6NDY6Nhw4Mj8QFj4PPB4XSUg*
        Oi4wFDpVSlVKTUpNTU5PTkhKS09CVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKQ09MNwY+
X-HM-Tid: 0a78681e7619d992kuwsd8fd2980360
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct lbs_private has been declared at 22nd line.
Remove the duplicate.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 drivers/net/wireless/marvell/libertas/decl.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/marvell/libertas/decl.h b/drivers/net/wireless/marvell/libertas/decl.h
index 5d1e30e0c5db..c1e0388ef01d 100644
--- a/drivers/net/wireless/marvell/libertas/decl.h
+++ b/drivers/net/wireless/marvell/libertas/decl.h
@@ -23,7 +23,6 @@ struct lbs_private;
 typedef void (*lbs_fw_cb)(struct lbs_private *priv, int ret,
 		const struct firmware *helper, const struct firmware *mainfw);
 
-struct lbs_private;
 struct sk_buff;
 struct net_device;
 struct cmd_ds_command;
-- 
2.25.1

