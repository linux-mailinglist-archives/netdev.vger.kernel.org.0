Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA363A21CA
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 03:12:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhFJBOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 21:14:11 -0400
Received: from m12-14.163.com ([220.181.12.14]:41175 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229507AbhFJBOK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 21:14:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=3h/2w
        Jd0fcVHmR9VRzN29jJAh+D2ucyN1yZs5xlkmQk=; b=Y1baCS3czXsgUoz445YK3
        sXWbMnqLlDMjxpEH3i6Dzj1ZiLpS8v96zSlDmRPNZDwJhLxz6MjRuDoUeOkgpKSC
        vnD/ablpt7lZCm5nyAu3O5M1IIbRtGaGXJ1NEEeWJc3X15GYqFZJlpqRRYym79lq
        wSnTXV8aDgC3vZNGj903/M=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowACX4GTjZsFgH8ysNw--.6543S2;
        Thu, 10 Jun 2021 09:12:04 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] vsock/vmci: remove the repeated word "be"
Date:   Wed,  9 Jun 2021 18:11:59 -0700
Message-Id: <20210610011159.34485-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowACX4GTjZsFgH8ysNw--.6543S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrurWrAr43CFykWFy7CF18AFb_yoWfJrX_A3
        4fWF4jgF4UXrsayay7CrW8XF15J34F9F1I9anrCa48Ga4rArWYgrnxWr4fWFnrC343ZFy5
        tr1kGFyftwnrtjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU5bXo3UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBzgWtg1QHM18lpgAAsZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Remove the repeated word "be".

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/vmw_vsock/vmci_transport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/vmw_vsock/vmci_transport.c b/net/vmw_vsock/vmci_transport.c
index c99bc4ce78e2..e617ed93f06b 100644
--- a/net/vmw_vsock/vmci_transport.c
+++ b/net/vmw_vsock/vmci_transport.c
@@ -1248,7 +1248,7 @@ vmci_transport_recv_connecting_server(struct sock *listener,
 	vsock_remove_pending(listener, pending);
 	vsock_enqueue_accept(listener, pending);
 
-	/* Callers of accept() will be be waiting on the listening socket, not
+	/* Callers of accept() will be waiting on the listening socket, not
 	 * the pending socket.
 	 */
 	listener->sk_data_ready(listener);
-- 
2.25.1

