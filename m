Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D60F405C5A
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 19:49:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242042AbhIIRvE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 13:51:04 -0400
Received: from guitar.tcltek.co.il ([192.115.133.116]:39072 "EHLO
        mx.tkos.co.il" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241621AbhIIRvD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 13:51:03 -0400
Received: from tarshish.tkos.co.il (unknown [10.0.8.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx.tkos.co.il (Postfix) with ESMTPS id 9124D440E2F;
        Thu,  9 Sep 2021 20:49:31 +0300 (IDT)
From:   Baruch Siach <baruch@tkos.co.il>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        Baruch Siach <baruch@tkos.co.il>
Subject: [PATCH] net/packet: clarify source of pr_*() messages
Date:   Thu,  9 Sep 2021 20:49:47 +0300
Message-Id: <3ca9c4b3d77fb729f6741cb00d461da3bc6b2096.1631209787.git.baruch@tkos.co.il>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add pr_fmt macro to spell out the source of messages in prefix.

Before this patch:

  packet size is too long (1543 > 1518)

With this patch:

  af_packet: packet size is too long (1543 > 1518)

Signed-off-by: Baruch Siach <baruch@tkos.co.il>
---
 net/packet/af_packet.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 543365f58e97..2a2bc64f75cf 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -46,6 +46,8 @@
  *					Copyright (C) 2011, <lokec@ccs.neu.edu>
  */
 
+#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
+
 #include <linux/ethtool.h>
 #include <linux/types.h>
 #include <linux/mm.h>
-- 
2.33.0

