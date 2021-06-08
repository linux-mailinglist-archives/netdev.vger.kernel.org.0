Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BE83E39ED4E
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 06:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbhFHEFX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 00:05:23 -0400
Received: from m12-14.163.com ([220.181.12.14]:50336 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230364AbhFHEFW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 00:05:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=DNLwM
        zXXlvjlktYKcoSn4X8coBC5DxgHYYWPX96rHT0=; b=EEHEvwBBYleu7Mavthg4P
        snP3WunlHyF2QSc1YDllrXCx+M+8dUo0efFp+Et0X0rLMMOw052xOLP82JlxZ2I7
        zfnBoT1BgKhBxDQNH8vKyNRr79zyuHGTgv7HP7cfYg5MKYMlx406ClUZvGEiwH+w
        hwEO8DsNQAB8xiVmzJIMmc=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowAB3wGQH7L5gZ0okNg--.59165S2;
        Tue, 08 Jun 2021 12:03:20 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] net: appletalk: fix some mistakes in grammar
Date:   Mon,  7 Jun 2021 21:03:12 -0700
Message-Id: <20210608040312.2440-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowAB3wGQH7L5gZ0okNg--.59165S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF1rGw1UZr18uw1DGFW5trb_yoW8Gr48pr
        n5ur4jgan3GrnrKw1kWan2qrWUuF4DWay3uFy3Ar4Svr15Gr9xGF1DXrya9FW5KryrJayS
        vr9rWFWIv3WUJ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bbrcfUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiygirg1QHMUdy5AAAsZ
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

