Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6FE0B2F5C1C
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 09:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728397AbhANIHF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jan 2021 03:07:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:59242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728117AbhANIHD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Jan 2021 03:07:03 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7D94423A77;
        Thu, 14 Jan 2021 08:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610611501;
        bh=3zVDkTpXYYSPlX83jUVJYOwCXXEP5O6e+4oOu3uM/QQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UhqyF9OQDpRzHo+RuUu93fWzsPAekpJ9luHJdjIEoiUWVb8S+YhToX5JNdCVm8aXl
         a7+PFmWftb+KKlFEsNfqEJ0QLnfdzzvaTFBSMNXem5E4DcfmQoMjGL4OCqbyQ2muba
         qbosviT6WawO50HEqLH01OkHL6ziejZ8J7XP/DZXf82n+9s+g1KgriIjOio7oUBvdR
         NLxpn9rmhVEdNQ9NsZ79hPRoZdBWNmfHsDr+1wBw6DUchUB+ehDvlwB1YTIBGXhEgy
         PT+VnHrcU7Uj+OQ3K6DlMkSOne5MrpOA9qRpDYvRKqrpYYYjnGvqbIZfo8TigeQJng
         wLTQRvWKM8Keg==
Received: by mail.kernel.org with local (Exim 4.94)
        (envelope-from <mchehab@kernel.org>)
        id 1kzxco-00EQ6s-AE; Thu, 14 Jan 2021 09:04:58 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jon Maloy <jmaloy@redhat.com>,
        Ying Xue <ying.xue@windriver.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net
Subject: [PATCH v6 12/16] net: tip: fix a couple kernel-doc markups
Date:   Thu, 14 Jan 2021 09:04:48 +0100
Message-Id: <9d205b0e080153af0fbddee06ad0eb23457e1b1b.1610610937.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <cover.1610610937.git.mchehab+huawei@kernel.org>
References: <cover.1610610937.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: Mauro Carvalho Chehab <mchehab@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A function has a different name between their prototype
and its kernel-doc markup:

	../net/tipc/link.c:2551: warning: expecting prototype for link_reset_stats(). Prototype was for tipc_link_reset_stats() instead
	../net/tipc/node.c:1678: warning: expecting prototype for is the general link level function for message sending(). Prototype was for tipc_node_xmit() instead

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 net/tipc/link.c | 2 +-
 net/tipc/node.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/tipc/link.c b/net/tipc/link.c
index a6a694b78927..115109259430 100644
--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -2544,7 +2544,7 @@ void tipc_link_set_queue_limits(struct tipc_link *l, u32 min_win, u32 max_win)
 }
 
 /**
- * link_reset_stats - reset link statistics
+ * tipc_link_reset_stats - reset link statistics
  * @l: pointer to link
  */
 void tipc_link_reset_stats(struct tipc_link *l)
diff --git a/net/tipc/node.c b/net/tipc/node.c
index 83d9eb830592..008670d1f43e 100644
--- a/net/tipc/node.c
+++ b/net/tipc/node.c
@@ -1665,7 +1665,7 @@ static void tipc_lxc_xmit(struct net *peer_net, struct sk_buff_head *list)
 }
 
 /**
- * tipc_node_xmit() is the general link level function for message sending
+ * tipc_node_xmit() - general link level function for message sending
  * @net: the applicable net namespace
  * @list: chain of buffers containing message
  * @dnode: address of destination node
-- 
2.29.2

