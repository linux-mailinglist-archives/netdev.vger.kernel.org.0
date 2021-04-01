Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07097351102
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 10:41:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhDAIlL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 04:41:11 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:18350 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229459AbhDAIky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 04:40:54 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id 116E99800B6;
        Thu,  1 Apr 2021 16:40:52 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     Karsten Graul <kgraul@linux.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-s390@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] net: smc: Remove repeated struct declaration
Date:   Thu,  1 Apr 2021 16:40:29 +0800
Message-Id: <20210401084030.1002882-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGh0ZGB1JSUpNQk1CVkpNSkxJTU1PTklITExVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MBg6HSo6Sz8ROCsIOBotCSI1
        OQIwCkNVSlVKTUpMSU1NT05JTEtLVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKTUJLNwY+
X-HM-Tid: 0a788c97a764d992kuws116e99800b6
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct smc_clc_msg_local is declared twice. One is declared at
301st line. The blew one is not needed. Remove the duplicate.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 net/smc/smc_core.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/net/smc/smc_core.h b/net/smc/smc_core.h
index e8e448771f85..6d6fd1397c87 100644
--- a/net/smc/smc_core.h
+++ b/net/smc/smc_core.h
@@ -410,7 +410,6 @@ static inline void smc_set_pci_values(struct pci_dev *pci_dev,
 
 struct smc_sock;
 struct smc_clc_msg_accept_confirm;
-struct smc_clc_msg_local;
 
 void smc_lgr_cleanup_early(struct smc_connection *conn);
 void smc_lgr_terminate_sched(struct smc_link_group *lgr);
-- 
2.25.1

