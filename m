Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF73D3386D3
	for <lists+netdev@lfdr.de>; Fri, 12 Mar 2021 08:52:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231949AbhCLHwB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Mar 2021 02:52:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231888AbhCLHvv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Mar 2021 02:51:51 -0500
Received: from smtp.gentoo.org (mail.gentoo.org [IPv6:2001:470:ea4a:1:5054:ff:fec7:86e4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E683C061574;
        Thu, 11 Mar 2021 23:51:51 -0800 (PST)
Received: by sf.home (Postfix, from userid 1000)
        id 1F6DB5A22061; Fri, 12 Mar 2021 07:51:41 +0000 (GMT)
From:   Sergei Trofimovich <slyfox@gentoo.org>
To:     linux-kernel@vger.kernel.org
Cc:     Sergei Trofimovich <slyfox@gentoo.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: [PATCH] ia64: tools: add generic errno.h definition
Date:   Fri, 12 Mar 2021 07:51:35 +0000
Message-Id: <20210312075136.2037915-1-slyfox@gentoo.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Noticed missing header when build bpfilter helper:

    CC [U]  net/bpfilter/main.o
  In file included from /usr/include/linux/errno.h:1,
                   from /usr/include/bits/errno.h:26,
                   from /usr/include/errno.h:28,
                   from net/bpfilter/main.c:4:
  tools/include/uapi/asm/errno.h:13:10: fatal error:
    ../../../arch/ia64/include/uapi/asm/errno.h: No such file or directory
     13 | #include "../../../arch/ia64/include/uapi/asm/errno.h"
        |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

CC: linux-kernel@vger.kernel.org
CC: netdev@vger.kernel.org
CC: bpf@vger.kernel.org
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
---
 tools/arch/ia64/include/uapi/asm/errno.h | 1 +
 1 file changed, 1 insertion(+)
 create mode 100644 tools/arch/ia64/include/uapi/asm/errno.h

diff --git a/tools/arch/ia64/include/uapi/asm/errno.h b/tools/arch/ia64/include/uapi/asm/errno.h
new file mode 100644
index 000000000000..4c82b503d92f
--- /dev/null
+++ b/tools/arch/ia64/include/uapi/asm/errno.h
@@ -0,0 +1 @@
+#include <asm-generic/errno.h>
-- 
2.30.2

