Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C37B919ABE1
	for <lists+netdev@lfdr.de>; Wed,  1 Apr 2020 14:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732509AbgDAMlX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Apr 2020 08:41:23 -0400
Received: from m12-18.163.com ([220.181.12.18]:58128 "EHLO m12-18.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732316AbgDAMlX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Apr 2020 08:41:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=NrNcQ
        5AcP/v9wCkl8YeFZmZSdYI+aBTdNLOjG71q84k=; b=JFkliO2PlIRcxv+M5acv7
        19DFA2x63Uatkx4AFtVXEnKrakbw7AJAejN7faNnQxRBphK5Nx/TqRm0O+Ui0T7z
        grcoyEcKSAMssSGsWo0sYllqEGa9zxq5W4EBqZYnaJQ3bNluKbGla79V4xsh2jnv
        pQXPz+QWF/Geh6WuZIwF5Y=
Received: from localhost.localdomain (unknown [125.82.11.8])
        by smtp14 (Coremail) with SMTP id EsCowABnHIrUi4Rer6NlCA--.30791S4;
        Wed, 01 Apr 2020 20:40:54 +0800 (CST)
From:   Hu Haowen <xianfengting221@163.com>
To:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hu Haowen <xianfengting221@163.com>
Subject: [PATCH] bnx2x: correct a comment mistake in grammar
Date:   Wed,  1 Apr 2020 20:40:50 +0800
Message-Id: <20200401124050.19742-1-xianfengting221@163.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: EsCowABnHIrUi4Rer6NlCA--.30791S4
X-Coremail-Antispam: 1Uf129KBjvdXoWruFWUZw4fAw18tF4rKw45KFg_yoWkJFc_Kr
        yUXF4fXr45WrWS9r48Cr43Xa4Sk3y8W348WF4ag3ySyr9Fkr4UAan5AF1fJw15Ww48JF9x
        Gryfta47AwnIgjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUboUDtUUUUU==
X-Originating-IP: [125.82.11.8]
X-CM-SenderInfo: h0ld0wxhqj3xtqjsjii6rwjhhfrp/xtbBDxb4AFPALKSxVAAAsf
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is not right in grammar to spell "Its not". The right one is "It's
not".

And this line is also over 80 characters. So I broke it into two lines
as well in order to make that line not be more than 80 characters.

Signed-off-by: Hu Haowen <xianfengting221@163.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
index 9638d65d8261..517caedc0a87 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_link.c
@@ -6874,7 +6874,8 @@ int bnx2x_link_update(struct link_params *params, struct link_vars *vars)
 			case PORT_HW_CFG_PHY_SELECTION_FIRST_PHY_PRIORITY:
 			/* In this option, the first PHY makes sure to pass the
 			 * traffic through itself only.
-			 * Its not clear how to reset the link on the second phy
+			 * It's not clear how to reset the link on the second
+			 * phy.
 			 */
 				active_external_phy = EXT_PHY1;
 				break;
-- 
2.20.1


