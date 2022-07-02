Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFE62563DE5
	for <lists+netdev@lfdr.de>; Sat,  2 Jul 2022 05:12:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbiGBDMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 23:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbiGBDMP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 23:12:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0024037A37
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 20:12:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A89A61C4F
        for <netdev@vger.kernel.org>; Sat,  2 Jul 2022 03:12:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF994C341CE;
        Sat,  2 Jul 2022 03:12:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656731533;
        bh=ijGVsT06kuU0X/TQHyfW7ArSmZQVHiqpQ+C+wY5SvHk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KqmVMzhizhMu7fp5Xmu/aVeE0ibqLe25HImx9P//8BcmYDz4JRDPFhBVtP9YBhGOC
         0TO3yBYZwrYdmJZI+gVr6kVJ1oCFZ5ceuTdSANTAjax8++/ht7Qba219OiffsYzyDx
         OdqbNyAFCdwS920Fr/QL7s6Bj+x6v2vMYa4hZrR3+y+lgxzfE8HkWheXWAe0e0ByzN
         tQb7oGH11Yf3obNR8ejwtInxEV8rlp+o+baggtyysfrUQXlqSjYI7ZCsx354GhkQh1
         n/aXf6Gva+2POUsu9stlgYeGSa0WS0URA7nPXSwP7nmxeLaGekATa7237zgbwMrE6m
         Xbwxjoc1zN7wA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        andrew@lunn.ch, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 2/3] docs: netdev: document reverse xmas tree
Date:   Fri,  1 Jul 2022 20:12:08 -0700
Message-Id: <20220702031209.790535-3-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220702031209.790535-1-kuba@kernel.org>
References: <20220702031209.790535-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Similarly to the 15 patch rule the reverse xmas tree is not
documented.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/process/maintainer-netdev.rst | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
index 79a10d05031e..8a9dae7a0524 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -197,6 +197,19 @@ Is the comment style convention different for the networking content?
    * another line of text
    */
 
+What is "reverse xmas tree"?
+----------------------------
+
+Netdev has a convention for ordering local variables in functions.
+Order the variable declaration lines longest to shortest, e.g.::
+
+  struct scatterlist *sg;
+  struct sk_buff *skb;
+  int err, i;
+
+If there are dependencies between the variables preventing the ordering
+move the initialization out of line.
+
 I am working in existing code which uses non-standard formatting. Which formatting should I use?
 ------------------------------------------------------------------------------------------------
 Make your code follow the most recent guidelines, so that eventually all code
-- 
2.36.1

