Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 255FB1BE966
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:59:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgD2U7g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:59:36 -0400
Received: from mail.zx2c4.com ([192.95.5.64]:36243 "EHLO mail.zx2c4.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726852AbgD2U7f (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Apr 2020 16:59:35 -0400
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTP id 299b0953;
        Wed, 29 Apr 2020 20:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=from:to:cc
        :subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=mail; bh=nrqat2j/+Sl2RuPDBkzeiiXTA
        b4=; b=oV4rqqod7Z8GMhkERlE3SorWXdFtV6JRxbDrDMsGLlRdP/Nt7HQF5gANb
        i3sZ+9KCMg9ewJLBrMAKi30Kt7GeU3R0RoUAbdq8/4dERPJP0Ghbr4YVVWxHvf7/
        b5iSoRlQQLX5545UEdaK/F4G25ncEjrL4YsdO0mgXMZbjQYu9fnLBxxYbs7YgnP4
        ZyddLGGivQsNUq0CQ1dIjdvVKoBUsfMoh4yn/6zKqq3bPmI1eICDldJmD05cpJ2L
        BhzFbtm0FGGnOlgIjWGzIrT8mvUzQ6tcvTnZnYEvWvCPAC4xa3tQ8aGSxCekb1qe
        FeBqyZYPFvTMDBFM40R1zKv3fFlzA==
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 56f7676f (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 29 Apr 2020 20:47:42 +0000 (UTC)
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Sultan Alsawaf <sultan@kerneltoast.com>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
Subject: [PATCH net 1/3] wireguard: send: remove errant newline from packet_encrypt_worker
Date:   Wed, 29 Apr 2020 14:59:20 -0600
Message-Id: <20200429205922.295361-2-Jason@zx2c4.com>
In-Reply-To: <20200429205922.295361-1-Jason@zx2c4.com>
References: <20200429205922.295361-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sultan Alsawaf <sultan@kerneltoast.com>

This commit removes a useless newline at the end of a scope, which
doesn't add anything in the way of organization or readability.

Signed-off-by: Sultan Alsawaf <sultan@kerneltoast.com>
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
---
 drivers/net/wireguard/send.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireguard/send.c b/drivers/net/wireguard/send.c
index 7348c10cbae3..3e030d614df5 100644
--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -304,7 +304,6 @@ void wg_packet_encrypt_worker(struct work_struct *work)
 		}
 		wg_queue_enqueue_per_peer(&PACKET_PEER(first)->tx_queue, first,
 					  state);
-
 	}
 }
 
-- 
2.26.2

