Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 907B81547C6
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 16:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727687AbgBFPTN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 10:19:13 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:38074 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727563AbgBFPR7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 10:17:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Sender:Content-Transfer-Encoding:
        MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:
        Reply-To:Content-Type:Content-ID:Content-Description;
        bh=9h37LNRT4TQ+jg7PGN9p0cblxBVnWIynsEAVhRhcbvw=; b=IkuQW28IaV0PzbFPcEZtuoBGxy
        MI3+Yz2J7nZIdZct2v3buZ0CcuSt20aCDZHAi9afxfggHuuA0v5PcFp8BaXj17BmQF+qneNGzct+O
        jdhGXca5Qqr/XjYT43tQ8WhjWk3RtJr4/Djr1dNydsRqUcVrvqrgp2JjvFySx+tO/ejnvPiXds4Ld
        10KhWaDJfFX8Nbu9Y13qelRHFntUqarztVdI5EVyKCAXMGLZ53YUztgMOJM/FMBeGdmLtYOAqAp8G
        c7BhU7KrH7JVDd/l3Q1Ev0zv2Yn5Am8eH7fgeUhPbxZkNb3uyERCUSkb18Y002sRkXq5BNJFneONe
        FhkodhJw==;
Received: from [179.95.15.160] (helo=bombadil.infradead.org)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iziul-0005jd-HP; Thu, 06 Feb 2020 15:17:59 +0000
Received: from mchehab by bombadil.infradead.org with local (Exim 4.92.3)
        (envelope-from <mchehab@bombadil.infradead.org>)
        id 1iziud-002oW5-NY; Thu, 06 Feb 2020 16:17:51 +0100
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Media Mailing List <linux-media@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org
Subject: [PATCH 21/28] docs: networking: convert fib_trie.txt to ReST
Date:   Thu,  6 Feb 2020 16:17:41 +0100
Message-Id: <494446737ab19b024792b00901405698fc0d6b07.1581002063.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <cover.1581002062.git.mchehab+huawei@kernel.org>
References: <cover.1581002062.git.mchehab+huawei@kernel.org>
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
index 889216cdf00d..5f0ab638ef3f 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -53,6 +53,7 @@ Contents:
    dns_resolver
    driver
    eql
+   fib_trie
 
 .. only::  subproject and html
 
-- 
2.24.1

