Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476631D2DC6
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 13:03:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726101AbgENLC7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 07:02:59 -0400
Received: from m17616.mail.qiye.163.com ([59.111.176.16]:57125 "EHLO
        m17616.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgENLC6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 07:02:58 -0400
Received: from ubuntu.localdomain (unknown [58.251.74.227])
        by m17616.mail.qiye.163.com (Hmail) with ESMTPA id 9A62510998B;
        Thu, 14 May 2020 19:02:54 +0800 (CST)
From:   Wang Wenhu <wenhu.wang@vivo.com>
To:     Alex Elder <elder@kernel.org>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, Wang Wenhu <wenhu.wang@vivo.com>
Subject: [PATCH] drivers: ipa: fix typos for ipa_smp2p structure doc
Date:   Thu, 14 May 2020 04:02:22 -0700
Message-Id: <20200514110222.3402-1-wenhu.wang@vivo.com>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZTlVDS0JCQkJCT0lMTEJOT1lXWShZQU
        hPN1dZLVlBSVdZCQ4XHghZQVk1NCk2OjckKS43PlkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6M006Nio6QjgyNzBLK0scFDFK
        UT4KC0lVSlVKTkNCT05PSkxNQkhOVTMWGhIXVQweFRMOVQwaFRw7DRINFFUYFBZFWVdZEgtZQVlO
        Q1VJTkpVTE9VSUlMWVdZCAFZQUpDS083Bg++
X-HM-Tid: 0a7212d9fa799374kuws9a62510998b
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove the duplicate "mutex", and change "Motex" to "Mutex". Also I
recommend it's easier for understanding to make the "ready-interrupt"
a bundle for it is a parallel description as "shutdown" which is appended
after the slash.

Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
Cc: Alex Elder <elder@kernel.org>
---
 drivers/net/ipa/ipa_smp2p.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index 4d33aa7ebfbb..a5f7a79a1923 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -53,7 +53,7 @@
  * @clock_on:		Whether IPA clock is on
  * @notified:		Whether modem has been notified of clock state
  * @disabled:		Whether setup ready interrupt handling is disabled
- * @mutex mutex:	Motex protecting ready interrupt/shutdown interlock
+ * @mutex:		Mutex protecting ready-interrupt/shutdown interlock
  * @panic_notifier:	Panic notifier structure
 */
 struct ipa_smp2p {
-- 
2.17.1

