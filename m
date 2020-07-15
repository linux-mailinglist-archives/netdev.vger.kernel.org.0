Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B268722029F
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 05:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728504AbgGOC7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 22:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728487AbgGOC7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 22:59:38 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A45CFC061755;
        Tue, 14 Jul 2020 19:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description;
        bh=2X3Tt8qjXevwhad97b+dYLiPIuCQP4Yu59ya7pQYiUo=; b=kkDj4LY1a1zWRCcXb2MTsbMjn4
        nJWcGLBLqS6x0fXRaO4hk7jgy+L7/MCOqIka9SP57/ZxGU8SJkAgFOSa0qlatyLgt2WrgDLaA4irJ
        pGLXfoyQVrrhVoNMP9K0f0D8D9lfqcuLhOqvN7hiouI3ALmgpMYvng8IHjcv+tiDqLntszui7rF6j
        U1xesN+Ic748ozfBAxNcJ8ehOkzUxhFb5C2EFxyCfBq0EEa63ooNYgd0YEtPBzT0Pm2FopPM/qXMb
        foKGOlORV+HMOIrHQd3crt5mJFfazbhNOQjJxQuMw2TZoKUcH2pRhw9P98CPskK2NVtzJnqZpRsiR
        aTIrhqYQ==;
Received: from [2601:1c0:6280:3f0::19c2] (helo=smtpauth.infradead.org)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jvXdw-0001FT-Nj; Wed, 15 Jul 2020 02:59:37 +0000
From:   Randy Dunlap <rdunlap@infradead.org>
To:     linux-kernel@vger.kernel.org
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 09/13 net-next] net: dsa.h: drop duplicate word in comment
Date:   Tue, 14 Jul 2020 19:59:10 -0700
Message-Id: <20200715025914.28091-9-rdunlap@infradead.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200715025914.28091-1-rdunlap@infradead.org>
References: <20200715025914.28091-1-rdunlap@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Drop doubled word "to" in a comment.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
---
 include/net/dsa.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20200714.orig/include/net/dsa.h
+++ linux-next-20200714/include/net/dsa.h
@@ -612,7 +612,7 @@ struct dsa_switch_ops {
 	 * MTU change functionality. Switches can also adjust their MRU through
 	 * this method. By MTU, one understands the SDU (L2 payload) length.
 	 * If the switch needs to account for the DSA tag on the CPU port, this
-	 * method needs to to do so privately.
+	 * method needs to do so privately.
 	 */
 	int	(*port_change_mtu)(struct dsa_switch *ds, int port,
 				   int new_mtu);
