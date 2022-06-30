Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D52C562174
	for <lists+netdev@lfdr.de>; Thu, 30 Jun 2022 19:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236037AbiF3RqZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jun 2022 13:46:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235857AbiF3RqX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Jun 2022 13:46:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2880B36681;
        Thu, 30 Jun 2022 10:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DAC85B82CA6;
        Thu, 30 Jun 2022 17:46:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A356C341CA;
        Thu, 30 Jun 2022 17:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656611179;
        bh=Rw8NVSmOhVgPgEB7d+qSSTT8iamB0Ukg28mZj2wZjn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m3e9P03GjXeUEASBp5p/ArVk+QYSFKNXcE87s8DjwCPKWbvUXGBXsGlxpPbMA4gwq
         /jv1aPgAlK70Zaa5SzbN1WLWx21hzHAyyrRPqizhssks/zSKSJuhY2LlvdCA9wDQp/
         fclgNPuJt9De5s7N0eZbJ1WYIaQs3qGUzoBYqO+N+KoF9+tsSNXufO0D1k2W7IPNaD
         9tVnNbjtx5fr7ZgWY7r5fCSTb0M3XBB+S9XBTTcOQuB7a8+hu1fQGvIYGCSLJudJss
         A4gnSLgLxz10S0KuHf+yEGo2f0zonXYhfUHgJsy0fcILYooed5i7NAqqfBp3mDZvO/
         zVcN6vARArv1g==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        corbet@lwn.net, linux-doc@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net 3/3] docs: netdev: add a cheat sheet for the rules
Date:   Thu, 30 Jun 2022 10:46:07 -0700
Message-Id: <20220630174607.629408-4-kuba@kernel.org>
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

Summarize the rules we see broken most often and which may
be less familiar to kernel devs who are used to working outside
of netdev.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 Documentation/process/maintainer-netdev.rst | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/Documentation/process/maintainer-netdev.rst b/Documentation/process/maintainer-netdev.rst
index 7fb5100d195d..e57eb5bd3692 100644
--- a/Documentation/process/maintainer-netdev.rst
+++ b/Documentation/process/maintainer-netdev.rst
@@ -6,6 +6,15 @@
 netdev FAQ
 ==========
 
+tl;dr
+-----
+
+ - designate your patch to a tree - ``[PATCH net]`` or ``[PATCH net-next]``
+ - for fixes the ``Fixes:`` tag is required, regardless of the tree
+ - don't post large series (> 15 patches), break them up
+ - don't repost your patches within one 24h period
+ - reverse xmas tree
+
 What is netdev?
 ---------------
 It is a mailing list for all network-related Linux stuff.  This
-- 
2.36.1

