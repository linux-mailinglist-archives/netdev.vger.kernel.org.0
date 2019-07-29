Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7515578C57
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 15:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727549AbfG2NKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 09:10:05 -0400
Received: from mx2.suse.de ([195.135.220.15]:42638 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726167AbfG2NKF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jul 2019 09:10:05 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 715FAAD08;
        Mon, 29 Jul 2019 13:10:04 +0000 (UTC)
Received: by unicorn.suse.cz (Postfix, from userid 1000)
        id 1E301E0E3B; Mon, 29 Jul 2019 15:10:03 +0200 (CEST)
From:   Michal Kubecek <mkubecek@suse.cz>
Subject: [PATCH ethtool] gitignore: ignore vim swapfiles and patches
To:     "John W. Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Message-Id: <20190729131003.1E301E0E3B@unicorn.suse.cz>
Date:   Mon, 29 Jul 2019 15:10:03 +0200 (CEST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The .*.swp files are created by vim to hold the undo/redo log. Add them to
.gitignore to prevent "git status" or "git gui" from showing them whenever
some file is open in editor.

Add also *.patch to hide patches created by e.g. "git format-patch".

Signed-off-by: Michal Kubecek <mkubecek@suse.cz>
---
 .gitignore | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/.gitignore b/.gitignore
index f1165a2c9037..c4df588c37ea 100644
--- a/.gitignore
+++ b/.gitignore
@@ -27,3 +27,6 @@ autom4te.cache
 .deps
 test-*.log
 test-*.trs
+
+.*.swp
+*.patch
-- 
2.22.0

