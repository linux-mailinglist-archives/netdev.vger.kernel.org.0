Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 436EA2047C7
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 05:05:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732114AbgFWDFQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 23:05:16 -0400
Received: from out20-49.mail.aliyun.com ([115.124.20.49]:46115 "EHLO
        out20-49.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731690AbgFWDFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 23:05:16 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.1963569|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_system_inform|0.0456264-0.000926188-0.953447;FP=18262275217699229393|4|2|5|0|-1|-1|-1;HT=e01l07447;MF=aiden.leong@aibsd.com;NM=1;PH=DS;RN=4;RT=4;SR=0;TI=SMTPD_---.HqyYtR0_1592881512;
Received: from ubuntu(mailfrom:aiden.leong@aibsd.com fp:SMTPD_---.HqyYtR0_1592881512)
          by smtp.aliyun-inc.com(10.147.42.198);
          Tue, 23 Jun 2020 11:05:13 +0800
From:   Aiden Leong <aiden.leong@aibsd.com>
To:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH v2] GUE: Fix a typo
Date:   Mon, 22 Jun 2020 20:04:58 -0700
Message-Id: <20200623030459.13508-1-aiden.leong@aibsd.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix a typo in gue.h

Signed-off-by: Aiden Leong <aiden.leong@aibsd.com>
---
 include/net/gue.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/gue.h b/include/net/gue.h
index 3a6595bfa641..e42402f180b7 100644
--- a/include/net/gue.h
+++ b/include/net/gue.h
@@ -21,7 +21,7 @@
  * |                                                               |
  * +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
  *
- * C bit indicates contol message when set, data message when unset.
+ * C bit indicates control message when set, data message when unset.
  * For a control message, proto/ctype is interpreted as a type of
  * control message. For data messages, proto/ctype is the IP protocol
  * of the next header.
-- 
2.25.1

