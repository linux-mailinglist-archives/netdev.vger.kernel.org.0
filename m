Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 830C13A09AA
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 03:53:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233136AbhFIBz1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 21:55:27 -0400
Received: from m12-11.163.com ([220.181.12.11]:34979 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233113AbhFIBzS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 21:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=DNLwM
        zXXlvjlktYKcoSn4X8coBC5DxgHYYWPX96rHT0=; b=S62U3fMhV8wTOUPn+u/tG
        RXeq3sRT4igDYm36il31KsoTnY50gpBwwbAUr0bMwWYYvKXAdl9NgeZoTtmK1Vb1
        apJJ8g5oG3LfwqOTldpM+JUBqBMwODSY2bU1hLaqZJdw2zOP/bLLAtlvnuD+DEgf
        RhVtfVbCBlOOEyF53jPFzs=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowAB3bZUAH8Bg8AIKhA--.8S2;
        Wed, 09 Jun 2021 09:53:08 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] net: appletalk: fix some mistakes in grammar
Date:   Tue,  8 Jun 2021 18:52:57 -0700
Message-Id: <20210609015257.15262-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowAB3bZUAH8Bg8AIKhA--.8S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF1rGw1UZr18uw1DGFW5trb_yoW8Gr48pr
        n5ur4jgan3GrnrKw1kWan2qrWUuF4DWay3uFy3Ar4Svr15Gr9xGF1DXrya9FW5KryrJayS
        vr9rWFWIv3WUJ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bUlk3UUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiQgWsg1aD-MMl-gAAsZ
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

Fix some mistakes in grammar.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/appletalk/ddp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/appletalk/ddp.c b/net/appletalk/ddp.c
index ebda397fa95a..8ade5a4ceaf5 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -707,7 +707,7 @@ static int atif_ioctl(int cmd, void __user *arg)
 
 		/*
 		 * Phase 1 is fine on LocalTalk but we don't do
-		 * EtherTalk phase 1. Anyone wanting to add it go ahead.
+		 * EtherTalk phase 1. Anyone wanting to add it, go ahead.
 		 */
 		if (dev->type == ARPHRD_ETHER && nr->nr_phase != 2)
 			return -EPROTONOSUPPORT;
@@ -828,7 +828,7 @@ static int atif_ioctl(int cmd, void __user *arg)
 		nr = (struct atalk_netrange *)&(atif->nets);
 		/*
 		 * Phase 1 is fine on Localtalk but we don't do
-		 * Ethertalk phase 1. Anyone wanting to add it go ahead.
+		 * Ethertalk phase 1. Anyone wanting to add it, go ahead.
 		 */
 		if (dev->type == ARPHRD_ETHER && nr->nr_phase != 2)
 			return -EPROTONOSUPPORT;
@@ -2018,7 +2018,7 @@ module_init(atalk_init);
  * by the network device layer.
  *
  * Ergo, before the AppleTalk module can be removed, all AppleTalk
- * sockets be closed from user space.
+ * sockets should be closed from user space.
  */
 static void __exit atalk_exit(void)
 {
-- 
2.25.1

