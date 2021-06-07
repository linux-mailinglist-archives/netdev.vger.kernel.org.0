Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA9E139D518
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 08:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230207AbhFGGk3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 02:40:29 -0400
Received: from m12-11.163.com ([220.181.12.11]:36584 "EHLO m12-11.163.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229498AbhFGGk2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 02:40:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
        s=s110527; h=From:Subject:Date:Message-Id:MIME-Version; bh=2r79z
        HB8lgl3dUvf+w3zMGVsp+hgssJhFNBRhWN5wVQ=; b=jQc9OVPUMSFgLZJx7pFrA
        4l36XRmP3hVBTf/pWqxCBRft6iC4uwHmXUCkK0FyhXiN09EjnbjTP0Wt8bi/6f/v
        NO/9aUHoVmB3mDAl7l9811faMZFAQvQDo8N1ooXZ48nZ+WukRAS7SXkYUc5nQuAj
        InmjjyGDJweu0ThpLj/OTo=
Received: from ubuntu.localdomain (unknown [218.17.89.92])
        by smtp7 (Coremail) with SMTP id C8CowAA3Mprivr1gxM6vgg--.2222S2;
        Mon, 07 Jun 2021 14:38:27 +0800 (CST)
From:   13145886936@163.com
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>
Subject: [PATCH] net/atm/common.c fix a spelling mistake
Date:   Sun,  6 Jun 2021 23:38:19 -0700
Message-Id: <20210607063819.377166-1-13145886936@163.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: C8CowAA3Mprivr1gxM6vgg--.2222S2
X-Coremail-Antispam: 1Uf129KBjvdXoWrur1rAw43tF43AF1fZF48tFb_yoWxtrXEkw
        1kZ3W0grWUAFySywsrJr43Zr4xXa4rWr15CFn7Ca48J34DXr4rK395KF4kXry3WrW7ZF9x
        Z3Z0yr45tF17tjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUvcSsGvfC2KfnxnUUI43ZEXa7IU501v3UUUUU==
X-Originating-IP: [218.17.89.92]
X-CM-SenderInfo: 5zrdx5xxdq6xppld0qqrwthudrp/xtbBRwSqg1PAC+eXigAAsI
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: gushengxian <gushengxian@yulong.com>

iff should be changed to if.

Signed-off-by: gushengxian <gushengxian@yulong.com>
---
 net/atm/common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/atm/common.c b/net/atm/common.c
index 1cfa9bf1d187..55e92982a484 100644
--- a/net/atm/common.c
+++ b/net/atm/common.c
@@ -328,7 +328,7 @@ static int check_ci(const struct atm_vcc *vcc, short vpi, int vci)
 			return -EADDRINUSE;
 	}
 
-	/* allow VCCs with same VPI/VCI iff they don't collide on
+	/* allow VCCs with same VPI/VCI if they don't collide on
 	   TX/RX (but we may refuse such sharing for other reasons,
 	   e.g. if protocol requires to have both channels) */
 
-- 
2.25.1

