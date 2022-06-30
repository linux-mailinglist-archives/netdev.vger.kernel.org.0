Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15D2B562176
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 19:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235454AbiF3RqY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 13:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233809AbiF3RqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 13:46:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D72D93631E;
        Thu, 30 Jun 2022 10:46:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 816B2B82CDC;
        Thu, 30 Jun 2022 17:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E87AFC341CE;
        Thu, 30 Jun 2022 17:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656611179;
        bh=nRxG9EQmsmZXlwycPlp/D2dNgl4WJgyzycRRP9JNzJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HQqW0ZKfniTpGuOfS6HPGn6si5TsjebdyeNp8YU0wVMdYdzq4GpwdrYSGwvnlwcIV
         fR+/TydmmPXVMGZKAwS4Cs32+8hujQKweOCdMJnsiJXfRr8+xjRxNjvWb2bhjcMCjh
         nGMNeQZ+I3PPzMrLgDsWQ0NEu1yYcBSdOrAiwgK/yyR5dbdkzn/vy81n5g2IdcfXmf
         RHftS2DSsleRoHPP0Gpsg9J9SIvuzNBBVWN+cOotsfAeBUNJcoHmthrD+QsKKq5AHz
         t9b2944w5gVF8QuKw1B4Mwme7S3lFsnOhL2UPhWs3kTSfUtWJfl8QyTEqpSjWSnZ0g
         c0zDyygWRPslg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 2/3] docs: netdev: document reverse xmas tree
Date:   Thu, 30 Jun 2022 10:46:06 -0700
Message-Id: <20220630174607.629408-3-kuba@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220630174607.629408-1-kuba@kernel.org>
References: <20220630174607.629408-1-kuba@kernel.org>
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
index 862b6508fc22..7fb5100d195d 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -191,6 +191,19 @@ Is the comment style convention different for the networking content?
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

