Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD7DE4EA6FF
	for <lists+netdev@lfdr.de>; Tue, 29 Mar 2022 07:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232387AbiC2FK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 01:10:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232303AbiC2FKm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 01:10:42 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 786A1A1AE;
        Mon, 28 Mar 2022 22:08:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 08828B816AF;
        Tue, 29 Mar 2022 05:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5251DC34113;
        Tue, 29 Mar 2022 05:08:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648530530;
        bh=iG4nUMUQvCfeB3hYqsLbEyek7IQMg3zQLz65BIzoLOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mNb98lZQO0A/6FW9d7cNpbAzgI/DLFXJPGqqideZ2CSQUHvTepPOjto3nKbMOjjlH
         bydygwBPua5Lceum340B6hSe3jCRff0A4LRqd+E9mHu+2GXT3VPCI3yOSRnK8UFz7/
         K78elL2DF2cSbp57quEs5jGcd3wPDw6yVKqqf4gRY62YBlmGCkKhTShIbaiM+qTAtg
         DAdfUf4OYWskJUIRVWvIocWCA8108kgA/f92+1cmj/881lYuokNNR6EVPGbFipkPc0
         /clh2c6krvtWxQ+EzrJP1Ft1JHqOcjLLwELs5WIdlxYPJbkBdjZjeQgPhVrgvSpCWR
         W7g+o0oFD3VWQ==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net v2 12/14] docs: netdev: call out the merge window in tag checking
Date:   Mon, 28 Mar 2022 22:08:28 -0700
Message-Id: <20220329050830.2755213-13-kuba@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220329050830.2755213-1-kuba@kernel.org>
References: <20220329050830.2755213-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the most important case to the question about "where are we
in the cycle" - the case of net-next being closed.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/networking/netdev-FAQ.rst | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/Documentation/networking/netdev-FAQ.rst b/Documentation/networking/netdev-FAQ.rst
index 294ad9b0162d..a18e4e671e85 100644
--- a/Documentation/networking/netdev-FAQ.rst
+++ b/Documentation/networking/netdev-FAQ.rst
@@ -103,7 +103,9 @@ So where are we now in this cycle?
 
 and note the top of the "tags" section.  If it is rc1, it is early in
 the dev cycle.  If it was tagged rc7 a week ago, then a release is
-probably imminent.
+probably imminent. If the most recent tag is a final release tag
+(without an ``-rcN`` suffix) - we are most likely in a merge window
+and ``net-next`` is closed.
 
 How can I tell the status of a patch I've sent?
 -----------------------------------------------
-- 
2.34.1

