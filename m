Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25E1D443B2B
	for <lists+netdev@lfdr.de>; Wed,  3 Nov 2021 02:55:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230505AbhKCB6Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 2 Nov 2021 21:58:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230059AbhKCB6Q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 2 Nov 2021 21:58:16 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC413C061714;
        Tue,  2 Nov 2021 18:55:40 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id w9-20020a17090a1b8900b001a6b3b7ec17so226944pjc.3;
        Tue, 02 Nov 2021 18:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HJfUYAzB6ueQrhAI92ibilAFGaCgm0MzputEhf3efzA=;
        b=Li09ampRiF3j9QKq+NGYRxlwJ1xWso40Mmlo0BMlz+eBnG29jJSQG5QRyafo1H+3c7
         3rpzXPka6/u+XMwmYX+63uQm4bXkecEguic3cmQ9fAr5+g1f303UM6Wfc9oYCEXwT0m2
         zwgVxGaDYuE/1XvpX4xGBzlrLa8QUJ4YxfaXZhje9a6qgz0mnFBrJJKL2UOWIF/3flD7
         hcM6MYV8xDCZlwyZGftScvVUL6MwhbYv+fur2sfp51N578aTIDz1JdAUiLb2AcAxyvYi
         60OVuWOA/WlvZ7CM1tC/EJuIGMf/IM33NUXfSce/8IA7zigrNoOrk4NEUkUarcujVt9h
         TZAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HJfUYAzB6ueQrhAI92ibilAFGaCgm0MzputEhf3efzA=;
        b=7sYyBPBX32vN9Dw2HGmNxx99zl2gF+6gpzLmOBWlCEEQu2hDmPJOZ4LUT4Zp5Xgrx4
         Gr7EKQ89ouBnO+FK4hK/QjuXvhtjI4E6KWhc/4LcFIh1qtpeERogBTgLjaxWzgZ4sdGp
         g0AjusCzJlOe2X5A4El+vv7j0YSAqO9KUmMOFIoMrCN0jnddKhUbhcygF8UEArJ1iVnw
         zsxk4spouDHH6L3GDyQ/cq1HulDH/DX+v7GWAOYSKu7h0RYZFVMPY183idmdn0xK3B3V
         yC0SAYJDXG8XSaVoWTYXMVynRvggKgBFX1ZhI2XaQZOnSN5TS2DvMEmrt7uwfZHLzr6z
         HNRQ==
X-Gm-Message-State: AOAM532Nnl1EJA+InK/W8/cgYvcid5WmxzNc5GzowKO9U2tLCtqjHXY9
        BMM/DEuM+kwvwXJUSkdKrB8=
X-Google-Smtp-Source: ABdhPJw8K+9fUZWgJflkUmZJuM+9I6Gn+LFqU75LbCXUjVnSfxgnZ1jQHmZAHqChjRy9+LCZbNXUyg==
X-Received: by 2002:a17:903:2348:b0:141:d60b:ee90 with SMTP id c8-20020a170903234800b00141d60bee90mr20257733plh.15.1635904540248;
        Tue, 02 Nov 2021 18:55:40 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id m6sm192398pgc.17.2021.11.02.18.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Nov 2021 18:55:39 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: deng.changcheng@zte.com.cn
To:     davem@davemloft.net
Cc:     yoshfuji@linux-ipv6.org, dsahern@kernel.org, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Changcheng Deng <deng.changcheng@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH] net: ipv6: Remove unneeded semicolon
Date:   Wed,  3 Nov 2021 01:55:33 +0000
Message-Id: <20211103015533.24124-1-deng.changcheng@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Changcheng Deng <deng.changcheng@zte.com.cn>

Fix the following coccicheck review:
./net/ipv6/seg6.c: 381: 2-3: Review: Unneeded semicolon

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Changcheng Deng <deng.changcheng@zte.com.cn>
---
 net/ipv6/seg6.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv6/seg6.c b/net/ipv6/seg6.c
index 5daa1c3ed83b..a8b5784afb1a 100644
--- a/net/ipv6/seg6.c
+++ b/net/ipv6/seg6.c
@@ -378,7 +378,7 @@ static int __net_init seg6_net_init(struct net *net)
 		kfree(rcu_dereference_raw(sdata->tun_src));
 		kfree(sdata);
 		return -ENOMEM;
-	};
+	}
 #endif
 
 	return 0;
-- 
2.25.1

