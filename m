Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF5521B865D
	for <lists+netdev@lfdr.de>; Sat, 25 Apr 2020 13:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726117AbgDYL4W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 07:56:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726060AbgDYL4W (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 07:56:22 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67544C09B04B;
        Sat, 25 Apr 2020 04:56:22 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id h69so5970151pgc.8;
        Sat, 25 Apr 2020 04:56:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=blyNpwJH0tDYVCiSTx7/2yaYq9p1CculusRqY7fpsWI=;
        b=WL1JbucFohVFnUcZjY29S7QZa5qDzem7Bft9YbbmHjPYi5GgJbiefnJfxBNDrfg5L3
         z9rDUAtppZpTvPGVECI8X8RyWJlNPlqbwa2U7SDgYvbjXEdkmh6+ZbOSH89Srz8xQtsI
         ZFljFfHIgpnahGZUz+kP7sZe8SqXfk5G0yWV6avx2e8MgtnKVG//a4oSuC1rRtlvJsMP
         Xpcl3QZDih5dTBWpWDAdl647mTry53MHeKTGoh99U5kuIp5jdD1e5wmU/1DiUt4uI9ec
         MvaYeVJ5ZKv30TxP4k1bHfnISq+R/+u3SWl3bM02VPbWi89axJTJ8c3Djkn12dE+KYh0
         Ks+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=blyNpwJH0tDYVCiSTx7/2yaYq9p1CculusRqY7fpsWI=;
        b=JCyXFD8d1Qc+DRqeTS3bGNqmPflabzo3dY1HR0wm9eFYDrACs4wUi2uzIvkvIg3AZV
         sfgONM62TF6/FAO98EUEkRSOSgF/YLqT8qxMZIsmxuz2obnDCjyhdePpT7Hqm3myQGqo
         gTk8eKJrE3TNow2KcmYgpjurBNtyY6bLjYZ2oJVGnLZrixtLhq97ZNJFuyS9G8uPdq4n
         t275boFVTvcm22VrsZQ1PZ+4H7fRTlFJt9kkbC82W2WnuxhBVZqkaydn//pSF4GdX/3O
         oga2cGWz9lUE9YH8YO5MUv297UjYG+XOU36ODPqCzrCl/tMKpFkaC8kzYn8/oRYFCtzG
         c0og==
X-Gm-Message-State: AGi0PuYemkXjFF2L7AkuFnzpBzw3AMurBPKhr2TVpB3hpTiNsqTZo1ce
        wQZ/rTkn8G7LaYTdhUpoIp8=
X-Google-Smtp-Source: APiQypLF4P75esfGN9Zm3TfjLbDlBrQ0dJKzlzjL/OHC3J2709yj8nlfzpyMwcHoJMZL/Q0etpn0mw==
X-Received: by 2002:a63:65c1:: with SMTP id z184mr14356487pgb.316.1587815781919;
        Sat, 25 Apr 2020 04:56:21 -0700 (PDT)
Received: from localhost ([176.122.158.64])
        by smtp.gmail.com with ESMTPSA id t11sm8061247pfl.122.2020.04.25.04.56.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 25 Apr 2020 04:56:21 -0700 (PDT)
From:   Dejin Zheng <zhengdejin5@gmail.com>
To:     davem@davemloft.net, tglx@linutronix.de, netdev@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, Dejin Zheng <zhengdejin5@gmail.com>
Subject: [PATCH net-next v1] ethernet: ks8842: delete unnecessary goto label
Date:   Sat, 25 Apr 2020 19:56:12 +0800
Message-Id: <20200425115612.17171-1-zhengdejin5@gmail.com>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

the label of err_register is not necessary, so delete it to
simplify code.

Signed-off-by: Dejin Zheng <zhengdejin5@gmail.com>
---
 drivers/net/ethernet/micrel/ks8842.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/micrel/ks8842.c b/drivers/net/ethernet/micrel/ks8842.c
index f3f6dfe3eddc..213ca33a9967 100644
--- a/drivers/net/ethernet/micrel/ks8842.c
+++ b/drivers/net/ethernet/micrel/ks8842.c
@@ -1204,7 +1204,7 @@ static int ks8842_probe(struct platform_device *pdev)
 	strcpy(netdev->name, "eth%d");
 	err = register_netdev(netdev);
 	if (err)
-		goto err_register;
+		goto err_get_irq;
 
 	platform_set_drvdata(pdev, netdev);
 
@@ -1213,7 +1213,6 @@ static int ks8842_probe(struct platform_device *pdev)
 
 	return 0;
 
-err_register:
 err_get_irq:
 	iounmap(adapter->hw_addr);
 err_ioremap:
-- 
2.25.0

