Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0DAE3FF78A
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 01:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347966AbhIBXBN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 19:01:13 -0400
Received: from smtp-relay-canonical-1.canonical.com ([185.125.188.121]:34162
        "EHLO smtp-relay-canonical-1.canonical.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232013AbhIBXBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Sep 2021 19:01:11 -0400
Received: from localhost (1.general.cking.uk.vpn [10.172.193.212])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-canonical-1.canonical.com (Postfix) with ESMTPSA id C12D03F355;
        Thu,  2 Sep 2021 23:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1630623611;
        bh=zxH+g8t4PZrVfiI57swIAzkUwA2FmWiTdfMr+NnQJMA=;
        h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type;
        b=B80WzTLnZUHU54B0/LAdvPgTRMM17lpanljV2PalqiZcLX3kvNYmQz9LM45ZT/cpP
         nBHJybLbbtLsbPtUpKzLOK9+FXvHcojxLRqUk9/1MALKekXeGsjgZTrWFTb8PfU/4j
         w90jfBfu7hzqT6nw0pt67Qp3KyPt8Y0ILh1NDqsb0msr1NHXCs3zDETgE4825N5h8h
         pw8Ofjf572el9rCvtXkIOndN6ZqR/apG1eL66RgpvPGP1Nlz+FizlTJ2KwE2Z7iRsa
         zRmKGd87d2THrlonp9uo+voBbP+nyamGxtXk1zNiP4PYWdTrx9WWHxeaZ27TUzG5It
         8jr4b3eiQwEfA==
From:   Colin King <colin.king@canonical.com>
To:     Jon Maloy <jmaloy@redhat.com>, Ying Xue <ying.xue@windriver.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] tipc: clean up inconsistent indenting
Date:   Fri,  3 Sep 2021 00:00:11 +0100
Message-Id: <20210902230011.58478-1-colin.king@canonical.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

There is a statement that is indented one character too deeply,
clean this up.

Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 net/tipc/socket.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index e3105ba407c7..a0a27d87f631 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -1426,7 +1426,7 @@ static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dlen)
 	if (ua) {
 		if (!tipc_uaddr_valid(ua, m->msg_namelen))
 			return -EINVAL;
-		 atype = ua->addrtype;
+		atype = ua->addrtype;
 	}
 
 	/* If socket belongs to a communication group follow other paths */
-- 
2.32.0

