Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40AEB1E3666
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 05:20:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387477AbgE0DTm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 23:19:42 -0400
Received: from m17616.mail.qiye.163.com ([59.111.176.16]:12109 "EHLO
        m17616.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387467AbgE0DTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 23:19:41 -0400
Received: from ubuntu.localdomain (unknown [58.251.74.227])
        by m17616.mail.qiye.163.com (Hmail) with ESMTPA id 968B81092B1;
        Wed, 27 May 2020 11:19:35 +0800 (CST)
From:   Wang Wenhu <wenhu.wang@vivo.com>
To:     davem@davemloft.net, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kernel@vivo.com, trivial@kernel.org,
        Wang Wenhu <wenhu.wang@vivo.com>
Subject: [PATCH] drivers: ipa: fix typoes for ipa
Date:   Tue, 26 May 2020 20:19:24 -0700
Message-Id: <20200527031924.34200-1-wenhu.wang@vivo.com>
X-Mailer: git-send-email 2.17.1
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZT1VNS0pCQkJMTkJNTE9LTFlXWShZQU
        hPN1dZLVlBSVdZDwkaFQgSH1lBWS0WKU84HDkVHQxCM0g2Sh4QSU86OjpWVlVISShJWVdZCQ4XHg
        hZQVk1NCk2OjckKS43PllXWRYaDxIVHRRZQVk0MFkG
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6Nyo6GCo4EDg*MyMvCgtDMU1C
        NikaCy5VSlVKTkJLTk9CTkxMQk5OVTMWGhIXVQweFRMOVQwaFRw7DRINFFUYFBZFWVdZEgtZQVlO
        Q1VJTkpVTE9VSUlMWVdZCAFZQUlPS043Bg++
X-HM-Tid: 0a72542478ae9374kuws968b81092b1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Change "transactio" -> "transaction". Also an alignment correction.

Signed-off-by: Wang Wenhu <wenhu.wang@vivo.com>
---
 drivers/net/ipa/gsi.c          | 2 +-
 drivers/net/ipa/ipa_endpoint.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index b671bea0aa7c..688b99a606bf 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1345,7 +1345,7 @@ static void gsi_channel_update(struct gsi_channel *channel)
  * gsi_channel_poll_one() - Return a single completed transaction on a channel
  * @channel:	Channel to be polled
  *
- * @Return:	 Transaction pointer, or null if none are available
+ * @Return:	Transaction pointer, or null if none are available
  *
  * This function returns the first entry on a channel's completed transaction
  * list.  If that list is empty, the hardware is consulted to determine
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index a21534f1462f..b247ae24c0e1 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -340,7 +340,7 @@ int ipa_endpoint_modem_exception_reset_all(struct ipa *ipa)
 	/* We need one command per modem TX endpoint.  We can get an upper
 	 * bound on that by assuming all initialized endpoints are modem->IPA.
 	 * That won't happen, and we could be more precise, but this is fine
-	 * for now.  We need to end the transactio with a "tag process."
+	 * for now.  We need to end the transaction with a "tag process."
 	 */
 	count = hweight32(initialized) + ipa_cmd_tag_process_count();
 	trans = ipa_cmd_trans_alloc(ipa, count);
-- 
2.17.1

