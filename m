Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5D7317D0C9
	for <lists+netdev@lfdr.de>; Sun,  8 Mar 2020 02:19:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726307AbgCHBTP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Mar 2020 20:19:15 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:44658 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726180AbgCHBTP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Mar 2020 20:19:15 -0500
Received: by mail-pl1-f195.google.com with SMTP id d9so2507762plo.11
        for <netdev@vger.kernel.org>; Sat, 07 Mar 2020 17:19:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KT6C3hBq+Ye+U8+IsNIbubpafwJkyM/3wIAafjLRo+k=;
        b=JSpbULcI3h3cyFK4hT+B96VTyB467coH5CG/fjiSY8y8B+1RGWWfaNNzFF0U4ouOeS
         9SPw97gN9htBgxbomaNcwyK0tlHMDjVpcEDwwib5hohLDz6s6lrw16yegE+ZuCquIIeq
         /S29Kk20MetXK77kotbFjt+LuCuSf8zVPr/7Q0lFPUjGgM0vwKr1t6FhF9hR9V4CFiAA
         16BigyXzfGxxgobfUQZrhoCr9p7doIvbj2G9AVemFg9RMmcSpEFAc640JJiqZCNSeyzR
         xmFGg5+pcJM8wwZmBcqN+SPsAJB05C9OqbRe/rfN5VR8TcQZlj6EQpDJby3DyVsgDlcg
         rzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KT6C3hBq+Ye+U8+IsNIbubpafwJkyM/3wIAafjLRo+k=;
        b=S4VYo9wbAfkVoXt7Rrknu3sexjvaLg1bZ5NogtpatanyO6Khu5GMoBBlJdLOAO97xl
         2IIaDA25TRikoTsxt2ou1qAzrjFCrzzkkv9Z9rNr5kpgiTuaofls2YHBQLa6Y1JeNcCz
         ShCy8XMbqXqgMR2CitbQ8dldovo9diA4oYsIzyZiOQ7DX0bATDy57yVdJUJRNQE57WNA
         suV0uzo869WMVGeQkOQ9hul5qO46AjXAiV7Hc/IqzJ3ID9mjtqiXHXi/krnZr5gjipju
         1ZvZws3vOMGWU62Lg8FMHwIJRoGKaC3+EsUASxzbYAuyUzq7MvAsLES/+kCofQ+ED6Dp
         j72Q==
X-Gm-Message-State: ANhLgQ22SnLAWqMUlKHXxXO/CI4r2ffnIoV6EKCG5tluKIQyR5jO6Vmk
        le6AjDK+vtSjOE+qOVx0FK0=
X-Google-Smtp-Source: ADFU+vt1RvbS1/G2iNUN3UfcnQhbsdpfQTsKm1sQS+n/aPACnIKrTNyv8wyVr5fuTcfpmdZ8PIuC2g==
X-Received: by 2002:a17:90a:de16:: with SMTP id m22mr11033756pjv.142.1583630353657;
        Sat, 07 Mar 2020 17:19:13 -0800 (PST)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id h95sm13855998pjb.48.2020.03.07.17.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Mar 2020 17:19:12 -0800 (PST)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org,
        martinvarghesenokia@gmail.com, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 1/3] bareudp: add module alias
Date:   Sun,  8 Mar 2020 01:19:07 +0000
Message-Id: <20200308011907.6751-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

In the current bareudp code, there is no module alias.
So, RTNL couldn't load bareudp module automatically.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/bareudp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/bareudp.c b/drivers/net/bareudp.c
index 15337e9d4fad..b1210b516137 100644
--- a/drivers/net/bareudp.c
+++ b/drivers/net/bareudp.c
@@ -801,6 +801,7 @@ static void __exit bareudp_cleanup_module(void)
 }
 module_exit(bareudp_cleanup_module);
 
+MODULE_ALIAS_RTNL_LINK("bareudp");
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Martin Varghese <martin.varghese@nokia.com>");
 MODULE_DESCRIPTION("Interface driver for UDP encapsulated traffic");
-- 
2.17.1

