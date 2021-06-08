Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 535CC39EBF4
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 04:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbhFHC1u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 22:27:50 -0400
Received: from m12-14.163.com ([220.181.12.14]:59335 "EHLO m12-14.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231503AbhFHC1t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 22:27:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=yBMmM
        54KDZIxVMl8qj7WE3ycDDyRNvRFccsKD+T2FHg=; b=U2UgxxqUVB1tAwUWm23ZV
        tJ7tlJ0cwixItxYbqACKczylAr1xIpQvtCu4RH5oXVsJRHmVW53vMxrrJuxuCMyx
        w/FRBAvBeyhv33U7v9Ng0fQIh7f1pjF+gfk3HrzgPmFmtm9dT2tFJbOL4wEQAaHb
        utNXm2erP3QTN8NBST+Qjk=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp10 (Coremail) with SMTP id DsCowAD3UnAt1b5gOokXNg--.58682S2;
        Tue, 08 Jun 2021 10:25:50 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] net: appletalk: fix some mistakes in grammar
Date:   Mon,  7 Jun 2021 19:25:46 -0700
Message-Id: <20210608022546.7587-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DsCowAD3UnAt1b5gOokXNg--.58682S2
X-Coremail-Antispam: 1Uf129KBjvJXoWxJF1rGw15ArykZr1xtFWxXrb_yoW8Gr4rpr
        n5ur4Ygan5JrnrKwnrWan2qrW8uF4kWay3uFyayF4SvF15Gr93GF4DXrWavF45GryrJFWS
        9rZrWFWIva4UJw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07bUc_fUUUUU=
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBRxKrg1PAC-HN+gAAsj
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
index ebda397fa95a..bc76b2fa3dfb 100644
--- a/net/appletalk/ddp.c
+++ b/net/appletalk/ddp.c
@@ -707,7 +707,7 @@ static int atif_ioctl(int cmd, void __user *arg)
 
 		/*
 		 * Phase 1 is fine on LocalTalk but we don't do
-		 * EtherTalk phase 1. Anyone wanting to add it go ahead.
+		 * EtherTalk phase 1. Anyone wanting to add it goes ahead.
 		 */
 		if (dev->type == ARPHRD_ETHER && nr->nr_phase != 2)
 			return -EPROTONOSUPPORT;
@@ -828,7 +828,7 @@ static int atif_ioctl(int cmd, void __user *arg)
 		nr = (struct atalk_netrange *)&(atif->nets);
 		/*
 		 * Phase 1 is fine on Localtalk but we don't do
-		 * Ethertalk phase 1. Anyone wanting to add it go ahead.
+		 * Ethertalk phase 1. Anyone wanting to add it goes ahead.
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

