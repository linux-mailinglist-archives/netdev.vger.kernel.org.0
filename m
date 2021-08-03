Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13A6B3DF849
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 01:14:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbhHCXOc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 19:14:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232864AbhHCXOb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 19:14:31 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DE8D760F56;
        Tue,  3 Aug 2021 23:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628032460;
        bh=M8ItDQ92UG8jAZ6xq/140khubH0ks0zS3tj0C1FDnGU=;
        h=From:To:Cc:Subject:Date:From;
        b=FwYHaPtWQlZA7bD+xueJeCKMUQo2ZLiJDG/J2nMfLK4VDmF2sVWNolB8wrbaEJlcZ
         xOyEGgyQJmWZL/JSjK63zZa/cqUWOp55SK4IhJjGVZy6FPd0T0iu/ckS1RiGtiKekA
         0vyoqsqI9Ww3Zmg7ur5tOAhCbHYnWLiQMnvLZ02REt7z8WqS2tevZZ30D6gHLKlbE4
         T6I4gx5JL7+BFL/3BmboUSjI1eR/3k/2HkgoFNwJPOsu7CzwNs3BmZSSUjt034bLey
         AWCIlWlHHukPPzsw4rQm68K1J7Pa2ntEauRKVRgsy95nxe3xv77BShpRi1F7+w90WV
         Oal2OU1wyNqWQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     corbet@lwn.net, linux-doc@vger.kernel.org,
        xiyou.wangcong@gmail.com, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net] docs: networking: netdevsim rules
Date:   Tue,  3 Aug 2021 16:14:15 -0700
Message-Id: <20210803231415.3067296-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are aspects of netdevsim which are commonly
misunderstood and pointed out in review. Cong
suggest we document them.

Suggested-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 91b2cf712801..e26532f49760 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -228,6 +228,23 @@ before posting to the mailing list. The patchwork build bot instance
 gets overloaded very easily and netdev@vger really doesn't need more
 traffic if we can help it.
 
+netdevsim is great, can I extend it for my out-of-tree tests?
+-------------------------------------------------------------
+
+No, `netdevsim` is a test vehicle solely for upstream tests.
+(Please add your tests under tools/testing/selftests/.)
+
+We also give no guarantees that `netdevsim` won't change in the future
+in a way which would break what would normally be considered uAPI.
+
+Is netdevsim considered a "user" of an API?
+-------------------------------------------
+
+Linux kernel has a long standing rule that no API should be added unless
+it has a real, in-tree user. Mock-ups and tests based on `netdevsim` are
+strongly encouraged when adding new APIs, but `netdevsim` in itself
+is **not** considered a use case/user.
+
 Any other tips to help ensure my net/net-next patch gets OK'd?
 --------------------------------------------------------------
 Attention to detail.  Re-read your own work as if you were the
-- 
2.31.1

