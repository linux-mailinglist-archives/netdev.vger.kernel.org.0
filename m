Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AE7624EF88
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 21:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726894AbgHWTkq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 15:40:46 -0400
Received: from mx2.suse.de ([195.135.220.15]:50846 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726880AbgHWTkn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 Aug 2020 15:40:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DD1E9AECB;
        Sun, 23 Aug 2020 19:41:11 +0000 (UTC)
Received: by lion.mk-sys.cz (Postfix, from userid 1000)
        id 4971D6030D; Sun, 23 Aug 2020 21:40:42 +0200 (CEST)
Message-Id: <2a867b56995e69ed7ff21e4dcf5ed607f33629ff.1598210544.git.mkubecek@suse.cz>
In-Reply-To: <cover.1598210544.git.mkubecek@suse.cz>
References: <cover.1598210544.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool v2 9/9] build: add -Wextra to default CFLAGS
To:     netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>
Date:   Sun, 23 Aug 2020 21:40:42 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As a result of previous commits, ethtool source now builds with gcc
versions 7-11 without any compiler warning with "-Wall -Wextra". Add
"-Wextra" to default cflags to make sure that any new warnings are
caught as early as possible.

Suggested-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 38dde098c1e6..aca0ad7bc773 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-AM_CFLAGS = -Wall
+AM_CFLAGS = -Wall -Wextra
 AM_CPPFLAGS = -I$(top_srcdir)/uapi
 LDADD = -lm
 
-- 
2.28.0

