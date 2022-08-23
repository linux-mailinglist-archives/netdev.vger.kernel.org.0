Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CF0E559EF8E
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 01:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbiHWXJP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 19:09:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbiHWXJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 19:09:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71EB30540
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 16:09:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90354B821E7
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 23:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BA95C433D7;
        Tue, 23 Aug 2022 23:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661296148;
        bh=nqOL621Jqd0MALk3BHo2Ojx5l1z7pqmJWBVSYyzhads=;
        h=From:To:Cc:Subject:Date:From;
        b=XvZQaUTtpgxgrAiWhmCGZ9f87S2LRhwrdusY7FO4GmM80ZtbFt5MuHWjqipnBJG8M
         dD7FYqtZmuDgOdY6Gq2AJCKaTKtmIALac0gQHoi9xjFFsRsn7BfsHNKpaXxj12O5Lg
         ol8WCFgktYAlEQX+bBghrZ1ucV59LGnskoNd4iYZB4cTcS18n1XTMP/ZyOkknSt4Ss
         fwvjjEdg2Ygpf5q5W7Nld75U4FH0EC3IYrhoY0c10MiBUnltLRcKzy8M+MswROb0YQ
         gOPq1XuODAenUJM4UQDjP57rCAdOjaU6Y3q6gXYHiHVEHeh7n6YBLTrANluTsRaI1E
         qvETaHeblVFdw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Stephen Hemminger <stephen@networkplumber.org>
Subject: [PATCH net-next] docs: fix the table in admin-guide/sysctl/net.rst
Date:   Tue, 23 Aug 2022 16:09:06 -0700
Message-Id: <20220823230906.663137-1-kuba@kernel.org>
X-Mailer: git-send-email 2.37.2
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

The table marking length needs to be adjusted after removal
and reshuffling.

Fixes: 1202cdd66531 ("Remove DECnet support from kernel")
Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
--
CC: Stephen Hemminger <stephen@networkplumber.org>
---
 Documentation/admin-guide/sysctl/net.rst | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
index 82879a9d5683..65087caf82d4 100644
--- a/Documentation/admin-guide/sysctl/net.rst
+++ b/Documentation/admin-guide/sysctl/net.rst
@@ -31,9 +31,9 @@ see only some of them, depending on your kernel's configuration.
 
 Table : Subdirectories in /proc/sys/net
 
- ========= =================== = ========== ==================
+ ========= ================== = ========== ==================
  Directory Content               Directory  Content
- ========= =================== = ========== ==================
+ ========= ================== = ========== ==================
  802       E802 protocol         mptcp     Multipath TCP
  appletalk Appletalk protocol    netfilter Network Filter
  ax25      AX25                  netrom     NET/ROM
@@ -42,7 +42,7 @@ Table : Subdirectories in /proc/sys/net
  ethernet  Ethernet protocol     unix      Unix domain sockets
  ipv4      IP version 4          x25       X.25 protocol
  ipv6      IP version 6
- ========= =================== = ========== ==================
+ ========= ================== = ========== ==================
 
 1. /proc/sys/net/core - Network core options
 ============================================
-- 
2.37.2

