Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 889F91BB127
	for <lists+netdev@lfdr.de>; Tue, 28 Apr 2020 00:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726916AbgD0WE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 18:04:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:48122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726363AbgD0WCA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 18:02:00 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B0529221ED;
        Mon, 27 Apr 2020 22:01:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588024916;
        bh=yhwdUWx9RSIe5YyttDq2rStcupVQmYSCHy6p57D1Ig0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x/G2dMJ4uEfZWsiz3V48FHy/MEX4bawWiFzBARTQGqaEkeS4AJkkPJVI6XMxRpuV8
         bf7hlE2FL67CnyGG14Xk/pV9aGjCfBl9ZZLfZymsMadz/Y2fegE3dJWg1lIONyOKoX
         Pgo3wMFmKiTgR0uD053clvhg5DVf/4bNVWUZHWk0=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jTBp5-000IpE-10; Tue, 28 Apr 2020 00:01:55 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: [PATCH 20/38] docs: networking: convert fib_trie.txt to ReST
Date:   Tue, 28 Apr 2020 00:01:35 +0200
Message-Id: <5f770e8ff6a81f7378fc7bf8374d11b15f7f3b8a.1588024424.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588024424.git.mchehab+huawei@kernel.org>
References: <cover.1588024424.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- adjust title markup;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../networking/{fib_trie.txt => fib_trie.rst}    | 16 ++++++++++------
 Documentation/networking/index.rst               |  1 +
 2 files changed, 11 insertions(+), 6 deletions(-)
 rename Documentation/networking/{fib_trie.txt => fib_trie.rst} (96%)

diff --git a/Documentation/networking/fib_trie.txt b/Documentation/networking/fib_trie.rst
similarity index 96%
rename from Documentation/networking/fib_trie.txt
rename to Documentation/networking/fib_trie.rst
index fe719388518b..f1435b7fcdb7 100644
--- a/Documentation/networking/fib_trie.txt
+++ b/Documentation/networking/fib_trie.rst
@@ -1,8 +1,12 @@
-			LC-trie implementation notes.
+.. SPDX-License-Identifier: GPL-2.0
+
+============================
+LC-trie implementation notes
+============================
 
 Node types
 ----------
-leaf 
+leaf
 	An end node with data. This has a copy of the relevant key, along
 	with 'hlist' with routing table entries sorted by prefix length.
 	See struct leaf and struct leaf_info.
@@ -13,7 +17,7 @@ trie node or tnode
 
 A few concepts explained
 ------------------------
-Bits (tnode) 
+Bits (tnode)
 	The number of bits in the key segment used for indexing into the
 	child array - the "child index". See Level Compression.
 
@@ -23,7 +27,7 @@ Pos (tnode)
 
 Path Compression / skipped bits
 	Any given tnode is linked to from the child array of its parent, using
-	a segment of the key specified by the parent's "pos" and "bits" 
+	a segment of the key specified by the parent's "pos" and "bits"
 	In certain cases, this tnode's own "pos" will not be immediately
 	adjacent to the parent (pos+bits), but there will be some bits
 	in the key skipped over because they represent a single path with no
@@ -56,8 +60,8 @@ full_children
 Comments
 ---------
 
-We have tried to keep the structure of the code as close to fib_hash as 
-possible to allow verification and help up reviewing. 
+We have tried to keep the structure of the code as close to fib_hash as
+possible to allow verification and help up reviewing.
 
 fib_find_node()
 	A good start for understanding this code. This function implements a
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 9ef6ef42bdc5..807abe25ae4b 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -55,6 +55,7 @@ Contents:
    dns_resolver
    driver
    eql
+   fib_trie
 
 .. only::  subproject and html
 
-- 
2.25.4

