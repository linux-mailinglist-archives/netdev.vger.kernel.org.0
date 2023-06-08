Return-Path: <netdev+bounces-9372-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4129A728A06
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:13:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E764A2814A9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:13:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C083834D73;
	Thu,  8 Jun 2023 21:12:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1C6734477
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CDACC433A1;
	Thu,  8 Jun 2023 21:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258728;
	bh=5B2RO3RKhnK9Jhgm16WdJDVhtoS0BxAfX7e4Nj0zxGs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OmxiCV0K1ubrzvxpM0Wfrk3AbXOWthyQ/OAxjMV4BfSWqu9FCuA4EaAGxOwiIq4j9
	 3nGElqG3Rh/rIx1ZdvcqWyS9YTM457Q9dfRGkQiUmmPJb5biLnS3kA6iQE+6pq1S3W
	 Wz18b9pKTgzLAGHk9mgymc/0GQ4vAzJXGjxCZH3plUH32tInewSIxCdvibk7ZFIyqc
	 tCnAymrm5UGW3Sswrsa5ukwPFs73j0YaTMEYUqHGIMKAso/KONF+qRl3AVOCg3tK8r
	 g/3HdB0ohszLorPT2/3+uBLWnKYSoZ/9BMepxDnuYZyCUI4xpy+h12cInN0v/5AjeM
	 P+XS/YZN8taFA==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 03/12] tools: ynl-gen: complete the C keyword list
Date: Thu,  8 Jun 2023 14:11:51 -0700
Message-Id: <20230608211200.1247213-4-kuba@kernel.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230608211200.1247213-1-kuba@kernel.org>
References: <20230608211200.1247213-1-kuba@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

C keywords need to be avoided when naming things.
Complete the list (ethtool has at least one thing called "auto").

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/ynl-gen-c.py | 35 ++++++++++++++++++++++++++++++++++-
 1 file changed, 34 insertions(+), 1 deletion(-)

diff --git a/tools/net/ynl/ynl-gen-c.py b/tools/net/ynl/ynl-gen-c.py
index e1b86b1fba66..9b6ff256f80e 100755
--- a/tools/net/ynl/ynl-gen-c.py
+++ b/tools/net/ynl/ynl-gen-c.py
@@ -1172,7 +1172,40 @@ op_mode_to_wrapper = {
 }
 
 _C_KW = {
-    'do'
+    'auto',
+    'bool',
+    'break',
+    'case',
+    'char',
+    'const',
+    'continue',
+    'default',
+    'do',
+    'double',
+    'else',
+    'enum',
+    'extern',
+    'float',
+    'for',
+    'goto',
+    'if',
+    'inline',
+    'int',
+    'long',
+    'register',
+    'return',
+    'short',
+    'signed',
+    'sizeof',
+    'static',
+    'struct',
+    'switch',
+    'typedef',
+    'union',
+    'unsigned',
+    'void',
+    'volatile',
+    'while'
 }
 
 
-- 
2.40.1


