Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C0CC3333A9
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 04:13:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231299AbhCJDMf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 22:12:35 -0500
Received: from mail-m17635.qiye.163.com ([59.111.176.35]:44894 "EHLO
        mail-m17635.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhCJDMD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Mar 2021 22:12:03 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Tue, 09 Mar 2021 22:12:03 EST
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by mail-m17635.qiye.163.com (Hmail) with ESMTPA id 139E94002EC;
        Wed, 10 Mar 2021 11:06:14 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Karsten Keil <isdn@linux-pingi.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] drivers: isdn: mISDN: fix spelling typo of 'wheter'
Date:   Wed, 10 Mar 2021 11:06:03 +0800
Message-Id: <1615345563-1293-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZQxoYGU0aHk0fQh0aVkpNSk5IT05OTE9ITk1VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hNSlVLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Kww6Dww5Cj8JKQ08Dy0CLzwQ
        IkIKCx9VSlVKTUpOSE9OTkxPTUJNVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFKTkxCNwY+
X-HM-Tid: 0a781a196184d991kuws139e94002ec
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

wheter -> whether

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 drivers/isdn/mISDN/l1oip_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/isdn/mISDN/l1oip_core.c b/drivers/isdn/mISDN/l1oip_core.c
index b57dcb8..facbd88
--- a/drivers/isdn/mISDN/l1oip_core.c
+++ b/drivers/isdn/mISDN/l1oip_core.c
@@ -200,7 +200,7 @@
 
  The complete socket opening and closing is done by a thread.
  When the thread opened a socket, the hc->socket descriptor is set. Whenever a
- packet shall be sent to the socket, the hc->socket must be checked wheter not
+ packet shall be sent to the socket, the hc->socket must be checked whether not
  NULL. To prevent change in socket descriptor, the hc->socket_lock must be used.
  To change the socket, a recall of l1oip_socket_open() will safely kill the
  socket process and create a new one.
-- 
2.7.4

