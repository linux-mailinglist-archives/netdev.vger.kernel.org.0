Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 298C7240029
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 23:24:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbgHIVYk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 17:24:40 -0400
Received: from mx2.suse.de ([195.135.220.15]:57548 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgHIVYj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 9 Aug 2020 17:24:39 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 039E8ABE9
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 21:24:58 +0000 (UTC)
Received: by localhost (Postfix, from userid 1000)
        id 104577F447; Sun,  9 Aug 2020 23:24:38 +0200 (CEST)
Message-Id: <12f1db189afc7798ff4d53326221ee6758628bc3.1597007533.git.mkubecek@suse.cz>
In-Reply-To: <cover.1597007532.git.mkubecek@suse.cz>
References: <cover.1597007532.git.mkubecek@suse.cz>
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool 7/7] build: add -Wextra to default CFLAGS
To:     netdev@vger.kernel.org
Date:   Sun,  9 Aug 2020 23:24:38 +0200 (CEST)
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
---
 Makefile.am | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/Makefile.am b/Makefile.am
index 2abb2742c335..099182e8d6ad 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -1,4 +1,4 @@
-AM_CFLAGS = -Wall
+AM_CFLAGS = -Wall -Wextra
 AM_CPPFLAGS = -I$(top_srcdir)/uapi
 LDADD = -lm
 
-- 
2.28.0

