Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AD4A435EB9
	for <lists+netdev@lfdr.de>; Thu, 21 Oct 2021 12:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230374AbhJUKK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Oct 2021 06:10:57 -0400
Received: from mail.netfilter.org ([217.70.188.207]:33832 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230105AbhJUKKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Oct 2021 06:10:48 -0400
Received: from localhost.localdomain (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3697463F42;
        Thu, 21 Oct 2021 12:06:48 +0200 (CEST)
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     netfilter-devel@vger.kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org
Subject: [PATCH net 7/8] selftests: netfilter: remove stray bash debug line
Date:   Thu, 21 Oct 2021 12:08:20 +0200
Message-Id: <20211021100821.964677-8-pablo@netfilter.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211021100821.964677-1-pablo@netfilter.org>
References: <20211021100821.964677-1-pablo@netfilter.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Florian Westphal <fw@strlen.de>

This should not be there.

Fixes: 2de03b45236f ("selftests: netfilter: add flowtable test script")
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 tools/testing/selftests/netfilter/nft_flowtable.sh | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 427d94816f2d..d4ffebb989f8 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -199,7 +199,6 @@ fi
 # test basic connectivity
 if ! ip netns exec ns1 ping -c 1 -q 10.0.2.99 > /dev/null; then
   echo "ERROR: ns1 cannot reach ns2" 1>&2
-  bash
   exit 1
 fi
 
-- 
2.30.2

