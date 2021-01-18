Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52CBE2F9E1D
	for <lists+netdev@lfdr.de>; Mon, 18 Jan 2021 12:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390152AbhARL1e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Jan 2021 06:27:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390095AbhARLRL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Jan 2021 06:17:11 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A7CAC061786;
        Mon, 18 Jan 2021 03:15:57 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id j12so662876pjy.5;
        Mon, 18 Jan 2021 03:15:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MEcP/jXGbBiYAGjKbm8TZg9WyvuGSXiAJBLZ0ICy+xU=;
        b=V70qUeYBNTQokBJye3dL3FuBAVfXkSgWh/fMzFEbJ4Om7rCtcsLelbvJPsulTyLdAm
         2WnY0h9ffnh6LaxREqaACV7oWOmsI19Am+NKEDsloMQ/KV3vd6mpy+xSCGtVHc+/Qg1E
         nXfcVyHmTAtrSIfpD5Q9KslTfScWx4Mot+DI6FMrNrgqI7JPsVsvdBB7ehEvZUUZajs7
         7kV7YycSpaxLAZ9K1o3X5Y4B8ni+1EykAmIRl6/5TqXmSHfjJyr/HER+4Sk9yE2X7zEX
         hKgNq3m/zwknGQQpvdL8UMT6WV/maGHLj9BNpYXYUtRxOkY8c/EgFBR5FI9cXk3VVIvo
         bQHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MEcP/jXGbBiYAGjKbm8TZg9WyvuGSXiAJBLZ0ICy+xU=;
        b=H9HxcMT8yH8//7L3bNxZtJRTS2Vi7m/DExwwhQF3oXaPsI+lgH3ghFF/HKy4eQRQs+
         GhpMzMZWq4qfR2DfH6CJM1eSMvqawxZc0bTmQJJTSOMKmeGIIAUfTuInJvBasd4hf4GH
         RoazHyjLQ5NQep3FatEEl8PoXKYWYFMveUhCM8oRUSf6IfYJohPpJAQT7v4grgff0oje
         OH58NzavYE9r+0VzmSFJmVQ2YoH0p/Q5QjsVC+2RW4n0XuZ0GR1sgPsCvlGEe5cC2x/S
         QJMA8yPB1ZIfix8Lnbuv1yW186EB+/m4htZc4OliibwkVzGBMuzgUthFqQp3ekm4tcCo
         4uuQ==
X-Gm-Message-State: AOAM532qEWaTmL+xH1Seelj4IixzqtfRppTr4TdIdo459VsjdD+/TsTH
        PlgLzRrho0uYQ7i99fpYuxg=
X-Google-Smtp-Source: ABdhPJzIA7f6QITJZVgUDFUwqyAqFe8mQ4Y6gMz9weJZceNtPamkoh7FYxO04+is9qPJPNBoSj7/ng==
X-Received: by 2002:a17:902:7149:b029:db:a6de:4965 with SMTP id u9-20020a1709027149b02900dba6de4965mr25938179plm.3.1610968556564;
        Mon, 18 Jan 2021 03:15:56 -0800 (PST)
Received: from localhost ([178.236.46.205])
        by smtp.gmail.com with ESMTPSA id p9sm15708032pfq.136.2021.01.18.03.15.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Jan 2021 03:15:55 -0800 (PST)
From:   menglong8.dong@gmail.com
X-Google-Original-From: dong.menglong@zte.com.cn
To:     kuba@kernel.org
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Menglong Dong <dong.menglong@zte.com.cn>
Subject: [PATCH net-next] net: tun: fix misspellings using codespell tool
Date:   Mon, 18 Jan 2021 03:15:39 -0800
Message-Id: <20210118111539.35886-1-dong.menglong@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

Some typos are found out by codespell tool:

$ codespell -w -i 3 ./drivers/net/tun.c
aovid  ==> avoid

Fix typos found by codespell.

Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
---
 drivers/net/tun.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/tun.c b/drivers/net/tun.c
index 702215596889..62690baa19bc 100644
--- a/drivers/net/tun.c
+++ b/drivers/net/tun.c
@@ -2735,7 +2735,7 @@ static int tun_set_iff(struct net *net, struct file *file, struct ifreq *ifr)
 		err = register_netdevice(tun->dev);
 		if (err < 0)
 			goto err_detach;
-		/* free_netdev() won't check refcnt, to aovid race
+		/* free_netdev() won't check refcnt, to avoid race
 		 * with dev_put() we need publish tun after registration.
 		 */
 		rcu_assign_pointer(tfile->tun, tun);
-- 
2.25.1

