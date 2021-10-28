Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182DE43DBE6
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 09:23:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhJ1HZw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 03:25:52 -0400
Received: from out0.migadu.com ([94.23.1.103]:33252 "EHLO out0.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229768AbhJ1HZw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 03:25:52 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1635405804;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=VXi3Ela0bU7orviuWeiG2NP6r/UtKWhGLoJui6UniIo=;
        b=gEo8rej7fcIJJsGfWYod+i8Qe60d17Q14LswQJrg0kV9fFg6b3tLKKCV98fH6q2KKLx04N
        M9TkeCam5MX4lSf70Cq3DKhyfW1aEDC35SemQ9tP6mU0Z/6KRb7jnVX2SlpAMx1mfyz6hP
        WOnAsS4O5gh8lvgAPLI3HYQyRjVAAwk=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     mareklindner@neomailbox.ch, sw@simonwunderlich.de, a@unstable.cc,
        sven@narfation.org
Cc:     b.a.t.m.a.n@lists.open-mesh.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH net-next] batman-adv: Fix the wrong definition
Date:   Thu, 28 Oct 2021 15:23:06 +0800
Message-Id: <20211028072306.1351-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: yajun.deng@linux.dev
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There are three variables that are required at most,
no need to define four variables.

Fixes: 0fa4c30d710d ("batman-adv: Make sysfs support optional")
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 net/batman-adv/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/batman-adv/main.c b/net/batman-adv/main.c
index 3ddd66e4c29e..758035b3796d 100644
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -656,7 +656,7 @@ int batadv_throw_uevent(struct batadv_priv *bat_priv, enum batadv_uev_type type,
 {
 	int ret = -ENOMEM;
 	struct kobject *bat_kobj;
-	char *uevent_env[4] = { NULL, NULL, NULL, NULL };
+	char *uevent_env[3] = {};
 
 	bat_kobj = &bat_priv->soft_iface->dev.kobj;
 
-- 
2.32.0

