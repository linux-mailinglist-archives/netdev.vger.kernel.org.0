Return-Path: <netdev+bounces-9371-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6EE7E728A04
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:13:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 29B662814A9
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:13:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05D4934CFF;
	Thu,  8 Jun 2023 21:12:11 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EF302D279
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:12:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32A1C433A0;
	Thu,  8 Jun 2023 21:12:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258728;
	bh=sdPMttPAC7NLqbfsAKC51kUhhrDKGJbXSmLqmflSMtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMfVBTvbK/cL7MzPApPg69zEVSwmfkDFGPbo0Y0yX3tLQR9k+tf0BsBLgoJTqrxoL
	 S54YyM56lfbpAgxDEkeIW0DpDm2xXQKTxdwC4ORvAasXPkulMOZlSFu7sYKEtfKu1d
	 /kY0LRo9fhFv4Fuk2Cy6rDE3NKIlkzTUVkxArMiu+6ib9n0lxRc5GmDOlcZIayfhs/
	 Ht34AyHmz1Ev8seNH6FD81A7RDr+rAKCBEjuFmGIkjYDga13kmfEZc9IKfEfinS7Th
	 oi/19buwsSDobpOPa1v4mrf1wDeT1Oyawbyz4ZCQjvW9FtOK8N3HaHWXQHm+p0tHte
	 xvwpszRtn86fw==
From: Jakub Kicinski <kuba@kernel.org>
To: davem@davemloft.net
Cc: netdev@vger.kernel.org,
	edumazet@google.com,
	pabeni@redhat.com,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 02/12] tools: ynl: regen: cleanup user space header includes
Date: Thu,  8 Jun 2023 14:11:50 -0700
Message-Id: <20230608211200.1247213-3-kuba@kernel.org>
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

Remove unnecessary includes.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 tools/net/ynl/generated/devlink-user.c   | 4 +---
 tools/net/ynl/generated/fou-user.c       | 4 +---
 tools/net/ynl/generated/handshake-user.c | 4 +---
 tools/net/ynl/generated/netdev-user.c    | 4 +---
 4 files changed, 4 insertions(+), 12 deletions(-)

diff --git a/tools/net/ynl/generated/devlink-user.c b/tools/net/ynl/generated/devlink-user.c
index c3204e20b971..4604b6829fd0 100644
--- a/tools/net/ynl/generated/devlink-user.c
+++ b/tools/net/ynl/generated/devlink-user.c
@@ -4,13 +4,11 @@
 /* YNL-GEN user source */
 
 #include <stdlib.h>
+#include <string.h>
 #include "devlink-user.h"
 #include "ynl.h"
 #include <linux/devlink.h>
 
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
 #include <libmnl/libmnl.h>
 #include <linux/genetlink.h>
 
diff --git a/tools/net/ynl/generated/fou-user.c b/tools/net/ynl/generated/fou-user.c
index c08c85a6b6c4..23c8f347547e 100644
--- a/tools/net/ynl/generated/fou-user.c
+++ b/tools/net/ynl/generated/fou-user.c
@@ -4,13 +4,11 @@
 /* YNL-GEN user source */
 
 #include <stdlib.h>
+#include <string.h>
 #include "fou-user.h"
 #include "ynl.h"
 #include <linux/fou.h>
 
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
 #include <libmnl/libmnl.h>
 #include <linux/genetlink.h>
 
diff --git a/tools/net/ynl/generated/handshake-user.c b/tools/net/ynl/generated/handshake-user.c
index 72eb1c52a8fc..7c204bf4c7cb 100644
--- a/tools/net/ynl/generated/handshake-user.c
+++ b/tools/net/ynl/generated/handshake-user.c
@@ -4,13 +4,11 @@
 /* YNL-GEN user source */
 
 #include <stdlib.h>
+#include <string.h>
 #include "handshake-user.h"
 #include "ynl.h"
 #include <linux/handshake.h>
 
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
 #include <libmnl/libmnl.h>
 #include <linux/genetlink.h>
 
diff --git a/tools/net/ynl/generated/netdev-user.c b/tools/net/ynl/generated/netdev-user.c
index 3db6921b9fab..fe0da71f653c 100644
--- a/tools/net/ynl/generated/netdev-user.c
+++ b/tools/net/ynl/generated/netdev-user.c
@@ -4,13 +4,11 @@
 /* YNL-GEN user source */
 
 #include <stdlib.h>
+#include <string.h>
 #include "netdev-user.h"
 #include "ynl.h"
 #include <linux/netdev.h>
 
-#include <stdlib.h>
-#include <stdio.h>
-#include <string.h>
 #include <libmnl/libmnl.h>
 #include <linux/genetlink.h>
 
-- 
2.40.1


