Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF227350FDE
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 09:10:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233404AbhDAHKA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Apr 2021 03:10:00 -0400
Received: from mail-m17637.qiye.163.com ([59.111.176.37]:28044 "EHLO
        mail-m17637.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbhDAHJd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Apr 2021 03:09:33 -0400
Received: from wanjb-virtual-machine.localdomain (unknown [36.152.145.182])
        by mail-m17637.qiye.163.com (Hmail) with ESMTPA id C56E8980436;
        Thu,  1 Apr 2021 15:09:30 +0800 (CST)
From:   Wan Jiabing <wanjiabing@vivo.com>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kael_w@yeah.net, Wan Jiabing <wanjiabing@vivo.com>
Subject: [PATCH] include: net: Remove repeated struct declaration
Date:   Thu,  1 Apr 2021 15:08:22 +0800
Message-Id: <20210401070823.994760-1-wanjiabing@vivo.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZSEpJSkNNQhhNT0xNVkpNSkxJTUtCTEpLSklVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6PxA6CRw*CD8JFjQ#QwMSAiML
        HUwKCRpVSlVKTUpMSU1LQkxKSUJNVTMWGhIXVQwaFRESGhkSFRw7DRINFFUYFBZFWVdZEgtZQVlI
        TVVKTklVSk9OVUpDSVlXWQgBWUFKTk5INwY+
X-HM-Tid: 0a788c4403b2d992kuwsc56e8980436
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

struct ctl_table_header is declared twice. One is declared
at 46th line. The blew one is not needed. Remove the duplicate.

Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
---
 include/net/net_namespace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/include/net/net_namespace.h b/include/net/net_namespace.h
index dcaee24a4d87..47457048ab86 100644
--- a/include/net/net_namespace.h
+++ b/include/net/net_namespace.h
@@ -407,7 +407,6 @@ int register_pernet_device(struct pernet_operations *);
 void unregister_pernet_device(struct pernet_operations *);
 
 struct ctl_table;
-struct ctl_table_header;
 
 #ifdef CONFIG_SYSCTL
 int net_sysctl_init(void);
-- 
2.25.1

