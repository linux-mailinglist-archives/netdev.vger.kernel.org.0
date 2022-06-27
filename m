Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E7C855DA6E
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240289AbiF0MQq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jun 2022 08:16:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233238AbiF0MQo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jun 2022 08:16:44 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CD98DED0;
        Mon, 27 Jun 2022 05:16:44 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id h9-20020a17090a648900b001ecb8596e43so9230421pjj.5;
        Mon, 27 Jun 2022 05:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gzxBbJxhdHK6PNoavR99hps1yhOfCLiWPLboRKYj7ko=;
        b=ZRFbVcvsBqhinQXNr/BOVOG9sV99j1Dkygit4IkDetSqhua+BHHR6GqN5kV1qSnThz
         xIaiZ3SYUUAoXBZVhNgovSnGPg6F2yJOiZ/JVVa7dFDoHGNLVGe8FROiDZwnMefWq/G6
         ohPY9NdesHaJYPKSfhgQgU/xcW8rzUT9kgrzm8SuVV1BbKTi1VxbLATSiE13Zwkeg0Mn
         N1A9yQ8ekUkK8wWu6MKX09H4SNITQrJZZR/uzQeI360+EnGCpXu6srsBvpmDwdJ/G13o
         WWIg1foMw6ZmcZoDMjvA0khfRBdx8qnwYADyLxoNpFup+fno95QRfRBgVRoun4OBFpUE
         2G7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=gzxBbJxhdHK6PNoavR99hps1yhOfCLiWPLboRKYj7ko=;
        b=Efmosx55uethjpNLWm6LUvGs2BIYIiSeXBsl/TvjzubqkBuZrE9W96PFOIMhWqgLd/
         e5g3wkitAgOyHZYA1XDtDJhRcE3Jntewpwz5mQ6mTC/MLDF07FiQh1GdxNbidAzn5f6P
         YU4DaiT0Ob/FQewjDLivGeGnybK7k/W3j70NdE0mw3Gqov/fEbIcNS4Z7TVnK0zCOXWU
         WgaM9tbXSuz2URfE+2ckXEaWu24z9lZvnEYAEOiKpkcaVdAJ1H0714MB9fxR9Jx5dIS0
         rGtjyVuefPYe9HIhaPq7+N5B7qmmg9+IMdjCYGEXgUqwT97zKcIYxKe3DtO/hBShLXak
         uLVg==
X-Gm-Message-State: AJIora84SPPddxmwUyQ8Izqd/WuqupDn5Q8mfWrYNrUpJ5IY160OWfPF
        AeBH5fRUjJ1PFzm9VD8d8SY=
X-Google-Smtp-Source: AGRyM1tg6C4UQ21pl4+ohFSN9n9PXFWmzvYebZbqdMhPyjty+7iSxesWjR6H5X46le/MTfoHBdLS4A==
X-Received: by 2002:a17:90b:1d84:b0:1ed:5918:74e3 with SMTP id pf4-20020a17090b1d8400b001ed591874e3mr8785846pjb.173.1656332203802;
        Mon, 27 Jun 2022 05:16:43 -0700 (PDT)
Received: from localhost.localdomain ([203.205.141.82])
        by smtp.gmail.com with ESMTPSA id h6-20020a170902680600b00163ffe73300sm7057389plk.137.2022.06.27.05.16.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jun 2022 05:16:43 -0700 (PDT)
From:   menglong8.dong@gmail.com
X-Google-Original-From: imagedong@tencent.com
To:     kuba@kernel.org
Cc:     mathew.j.martineau@linux.intel.com, matthieu.baerts@tessares.net,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, mptcp@lists.linux.dev,
        linux-kernel@vger.kernel.org, Menglong Dong <imagedong@tencent.com>
Subject: [PATCH net-next] net: mptcp: fix some spelling mistake in mptcp
Date:   Mon, 27 Jun 2022 20:16:25 +0800
Message-Id: <20220627121626.1595732-1-imagedong@tencent.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

codespell finds some spelling mistake in mptcp:

net/mptcp/subflow.c:1624: interaces ==> interfaces
net/mptcp/pm_netlink.c:1130: regarless ==> regardless

Just fix them.

Signed-off-by: Menglong Dong <imagedong@tencent.com>
---
 net/mptcp/pm_netlink.c | 2 +-
 net/mptcp/subflow.c    | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/mptcp/pm_netlink.c b/net/mptcp/pm_netlink.c
index e099f2a12504..3de83e2a2611 100644
--- a/net/mptcp/pm_netlink.c
+++ b/net/mptcp/pm_netlink.c
@@ -1127,7 +1127,7 @@ void mptcp_pm_nl_subflow_chk_stale(const struct mptcp_sock *msk, struct sock *ss
 			}
 			unlock_sock_fast(ssk, slow);
 
-			/* always try to push the pending data regarless of re-injections:
+			/* always try to push the pending data regardless of re-injections:
 			 * we can possibly use backup subflows now, and subflow selection
 			 * is cheap under the msk socket lock
 			 */
diff --git a/net/mptcp/subflow.c b/net/mptcp/subflow.c
index 654cc602ff2c..8c3e699d3387 100644
--- a/net/mptcp/subflow.c
+++ b/net/mptcp/subflow.c
@@ -1621,7 +1621,7 @@ int mptcp_subflow_create_socket(struct sock *sk, struct socket **new_sock)
 	/* the newly created socket really belongs to the owning MPTCP master
 	 * socket, even if for additional subflows the allocation is performed
 	 * by a kernel workqueue. Adjust inode references, so that the
-	 * procfs/diag interaces really show this one belonging to the correct
+	 * procfs/diag interfaces really show this one belonging to the correct
 	 * user.
 	 */
 	SOCK_INODE(sf)->i_ino = SOCK_INODE(sk->sk_socket)->i_ino;
-- 
2.36.1

