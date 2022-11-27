Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37368639B6F
	for <lists+netdev@lfdr.de>; Sun, 27 Nov 2022 15:46:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbiK0Oqx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 27 Nov 2022 09:46:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiK0Oqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 27 Nov 2022 09:46:52 -0500
Received: from smtp.smtpout.orange.fr (smtp-23.smtpout.orange.fr [80.12.242.23])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 167B4C76F
        for <netdev@vger.kernel.org>; Sun, 27 Nov 2022 06:46:50 -0800 (PST)
Received: from pop-os.home ([86.243.100.34])
        by smtp.orange.fr with ESMTPA
        id zIveos02xGPMszIveoBAEd; Sun, 27 Nov 2022 15:46:49 +0100
X-ME-Helo: pop-os.home
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sun, 27 Nov 2022 15:46:49 +0100
X-ME-IP: 86.243.100.34
From:   Christophe JAILLET <christophe.jaillet@wanadoo.fr>
To:     Eric Van Hensbergen <ericvh@gmail.com>,
        Latchesar Ionkov <lucho@ionkov.net>,
        Dominique Martinet <asmadeus@codewreck.org>,
        Christian Schoenebeck <linux_oss@crudebyte.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        v9fs-developer@lists.sourceforge.net, netdev@vger.kernel.org
Subject: [PATCH] 9p: Remove unneeded idr.h #include in the net/9p directory
Date:   Sun, 27 Nov 2022 15:46:45 +0100
Message-Id: <9e386018601d7e4a9e5d7da8fc3e9555ebb25c87.1669560387.git.christophe.jaillet@wanadoo.fr>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The 9p net files don't use IDR or IDA functionalities. So there is no point
in including <linux/idr.h>.
Remove it.

Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
---
 net/9p/trans_fd.c     | 1 -
 net/9p/trans_rdma.c   | 1 -
 net/9p/trans_virtio.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/net/9p/trans_fd.c b/net/9p/trans_fd.c
index eeea0a6a75b6..06ec9f7d3318 100644
--- a/net/9p/trans_fd.c
+++ b/net/9p/trans_fd.c
@@ -20,7 +20,6 @@
 #include <linux/un.h>
 #include <linux/uaccess.h>
 #include <linux/inet.h>
-#include <linux/idr.h>
 #include <linux/file.h>
 #include <linux/parser.h>
 #include <linux/slab.h>
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 6ff706760676..33a9ac6f2d55 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -21,7 +21,6 @@
 #include <linux/un.h>
 #include <linux/uaccess.h>
 #include <linux/inet.h>
-#include <linux/idr.h>
 #include <linux/file.h>
 #include <linux/parser.h>
 #include <linux/semaphore.h>
diff --git a/net/9p/trans_virtio.c b/net/9p/trans_virtio.c
index e757f0601304..19bccfa0d593 100644
--- a/net/9p/trans_virtio.c
+++ b/net/9p/trans_virtio.c
@@ -22,7 +22,6 @@
 #include <linux/un.h>
 #include <linux/uaccess.h>
 #include <linux/inet.h>
-#include <linux/idr.h>
 #include <linux/file.h>
 #include <linux/highmem.h>
 #include <linux/slab.h>
-- 
2.34.1

