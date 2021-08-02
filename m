Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEE423DCEAB
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 04:27:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231958AbhHBC1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Aug 2021 22:27:05 -0400
Received: from mail-m17655.qiye.163.com ([59.111.176.55]:51154 "EHLO
        mail-m17655.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231361AbhHBC1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Aug 2021 22:27:04 -0400
X-Greylist: delayed 483 seconds by postgrey-1.27 at vger.kernel.org; Sun, 01 Aug 2021 22:27:04 EDT
Received: from ubuntu.localdomain (unknown [36.152.145.182])
        by mail-m17655.qiye.163.com (Hmail) with ESMTPA id 504A740109;
        Mon,  2 Aug 2021 10:18:49 +0800 (CST)
From:   zhouchuangao <zhouchuangao@vivo.com>
To:     Ariel Elior <aelior@marvell.com>, GR-everest-linux-l2@marvell.com,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     zhouchuangao <zhouchuangao@vivo.com>
Subject: [PATCH] qed: Remove duplicated include of kernel.h
Date:   Sun,  1 Aug 2021 19:18:38 -0700
Message-Id: <1627870718-54491-1-git-send-email-zhouchuangao@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgPGg8OCBgUHx5ZQUlOS1dZCBgUCR5ZQVlLVUtZV1
        kWDxoPAgseWUFZKDYvK1lXWShZQUhPN1dZLVlBSVdZDwkaFQgSH1lBWUMeQ0tWTkIaHR9KS01JHU
        lIVRMBExYaEhckFA4PWVdZFhoPEhUdFFlBWU9LSFVKSktISkNVS1kG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Njo6Syo*CT9MOTw1FwoCATcW
        Qj0KFCJVSlVKTUlMQ0xLTElCQ0NDVTMWGhIXVQETFA4YEw4aFRwaFDsNEg0UVRgUFkVZV1kSC1lB
        WUhNVUpOSVVKT05VSkNJWVdZCAFZQUpNQkM3Bg++
X-HM-Tid: 0a7b04a81521da01kuws504a740109
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Duplicate include header file <linux/kernel.h>
line 4: #include <linux/kernel.h>
line 7: #include <linux/kernel.h>

Signed-off-by: zhouchuangao <zhouchuangao@vivo.com>
---
 drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c
index c1dd71d..3b84d00 100644
--- a/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c
+++ b/drivers/net/ethernet/qlogic/qed/qed_nvmetcp_fw_funcs.c
@@ -4,7 +4,6 @@
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/pci.h>
-#include <linux/kernel.h>
 #include <linux/list.h>
 #include <linux/mm.h>
 #include <linux/types.h>
-- 
2.7.4

