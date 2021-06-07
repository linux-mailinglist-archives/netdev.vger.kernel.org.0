Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D42539D989
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 12:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230255AbhFGKYM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 06:24:12 -0400
Received: from m12-15.163.com ([220.181.12.15]:32894 "EHLO m12-15.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230097AbhFGKYL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 06:24:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=/dZ2f
        mv2oUKXYfG7Nec1EKOUsYIgVLd4MmVJRQOEOM8=; b=pdVh7ke6umNuqwvlFs4x5
        KWKJV4CoxT3Jv3VNxbb6D2o/pSVHtQ5lZWXGepPFHfiKESaCU68embjui0Y2FdxQ
        QaKdn0YvwkSsG9iR4zUuueFoc0FY9mEiyc3tO1yEBc+4opeaKcdpJ98YZDzxLUOZ
        W7jFYodZOpwSzBeOo4wAww=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp11 (Coremail) with SMTP id D8CowAA34simvb1gsNMmAA--.101S2;
        Mon, 07 Jun 2021 14:33:20 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] atm: [br2864] fix spelling mistakes
Date:   Sun,  6 Jun 2021 23:33:07 -0700
Message-Id: <20210607063307.376988-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: D8CowAA34simvb1gsNMmAA--.101S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrZF4xXw1fZw1UXrWUGr1rJFb_yoWfWwbEgw
        nYvw1fWrWUJr1Sy342yrsxJryIq347uFySg3Z2kFyrJ345JwsYga4kur95Ar1xWF47Awnx
        CFZava1SqF129jkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IUe17K3UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/1tbiyhCqg1QHMTv4oQAAsz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

interrupt should be changed to interrupting.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/atm/br2684.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/atm/br2684.c b/net/atm/br2684.c
index 3e17a5ecaa94..dd2a8dabed84 100644
--- a/net/atm/br2684.c
+++ b/net/atm/br2684.c
@@ -93,8 +93,8 @@ struct br2684_dev {
  * This lock should be held for writing any time the list of devices or
  * their attached vcc's could be altered.  It should be held for reading
  * any time these are being queried.  Note that we sometimes need to
- * do read-locking under interrupt context, so write locking must block
- * the current CPU's interrupts
+ * do read-locking under interrupting context, so write locking must block
+ * the current CPU's interrupts.
  */
 static DEFINE_RWLOCK(devs_lock);
 
-- 
2.25.1

