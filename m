Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE81D480F30
	for <lists+netdev@lfdr.de>; Wed, 29 Dec 2021 04:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238483AbhL2DMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Dec 2021 22:12:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232913AbhL2DMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Dec 2021 22:12:53 -0500
Received: from mail-qt1-x830.google.com (mail-qt1-x830.google.com [IPv6:2607:f8b0:4864:20::830])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F6D7C061574;
        Tue, 28 Dec 2021 19:12:53 -0800 (PST)
Received: by mail-qt1-x830.google.com with SMTP id j17so17830157qtx.2;
        Tue, 28 Dec 2021 19:12:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CWajVAM/CofGIyu/UgB14ELKgBM5UfoqrcGTS6HVdrw=;
        b=M0HYVdM1LB1ODR6IbUkd6r9SdSXTBTIVXhtAwWk/Ps/PNBQK3KHWoJ3rNvIKlJ5vp+
         l2dYHqPYFxLKfYfxvWD8/gfXUl2xCwPLFkmvGcNwMgEVCsVclGKdsgOBTthJn7jpvz94
         l27Yeba35g7gQtwbkfhR09ucZkKE+WKdJVQQSbHaSFMhWrXE9mzUpeKEbJyrL9T8iy4L
         9kNfDSoXF6NWdXgMD6M5kaXhrbu0vB8Tgv5gzMDhSGT8+kPfYtZQreLfRij3zw72eZlh
         HOEL+LyvhrpAKp2WofrK0Pd0au5g8JgtjbRRuPKBynOZ5CkVUMbUT3rVlSZY5yP2ajRh
         BXwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CWajVAM/CofGIyu/UgB14ELKgBM5UfoqrcGTS6HVdrw=;
        b=wg+x83V2bQiRtwESQ6nyfZt+Jr7MbegHj36WDpO9V5UGBoBTtyuuFkAEgja1aR6hn/
         KUN3d9kiDyDo+ZugAfOVdxpJEur1gh7kGB7+lJMaau4L6DfVz+KfyaeqYs3rgNB5issh
         6S8J7mxJbC5jhMkmSTSuNo4FGHChLoWaNo0BjhWmB1kXQIJ2Up7ZApxkq7KoSU9DwRPm
         NoIDLjOsPeZ3lw9AVxoYgcktytpdrSBJ9V/HzLfnfgGjlCOsxvFhNthn6v8wP7olFcSX
         CLoKtKnLb6HgSKQ+afegOLOz3CKugz6SwovwYQSiA7Ux7/Cd9L8d4yQgwF9j3dy+ICzC
         rRJA==
X-Gm-Message-State: AOAM530GmOLCmH/u9g7X6loMsoNA82a6ue7WixU9AIaIH/6DcqJ8Yr2R
        NoDJaJhFLioDkgMQR2s1qow=
X-Google-Smtp-Source: ABdhPJyEjdm/+u2HjWz7v0WCSc3hGEIARUz4YKJ55KY0OnWjnRy8tfYmyj4eiVAB8bq8OCpoUqvbKA==
X-Received: by 2002:a05:622a:14d0:: with SMTP id u16mr21354453qtx.641.1640747572450;
        Tue, 28 Dec 2021 19:12:52 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id t15sm17739972qta.45.2021.12.28.19.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Dec 2021 19:12:51 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: xu.xin16@zte.com.cn
To:     davem@davemloft.net
Cc:     kuba@kernel.org, corbet@lwn.net, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        xu xin <xu.xin16@zte.com.cn>, Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] Documentation: fix outdated interpretation of ip_no_pmtu_disc
Date:   Wed, 29 Dec 2021 03:12:45 +0000
Message-Id: <20211229031245.582451-1-xu.xin16@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xu xin <xu.xin16@zte.com.cn>

The updating way of pmtu has changed, but documentation is still in the
old way. See commit-id 28d35bcdd3925e7293408cdb8aa5f2aac5f0d6e3. So This
patch fix interpretation of ip_no_pmtu_disc.

Besides, min_pmtu seems not to be discoverd, but set.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: xu xin <xu.xin16@zte.com.cn>
---
 Documentation/networking/ip-sysctl.rst | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index c04431144f7a..dd5e53318805 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -25,9 +25,11 @@ ip_default_ttl - INTEGER
 ip_no_pmtu_disc - INTEGER
 	Disable Path MTU Discovery. If enabled in mode 1 and a
 	fragmentation-required ICMP is received, the PMTU to this
-	destination will be set to min_pmtu (see below). You will need
-	to raise min_pmtu to the smallest interface MTU on your system
-	manually if you want to avoid locally generated fragments.
+	destination will be set to the smallest of the old MTU
+        and ip_rt_min_pmtu (see __ip_rt_update_pmtu() in
+        net/ipv4/route.c). You will need to raise min_pmtu to the
+        smallest interface MTU on your system manually if you want to
+        avoid locally generated fragments.
 
 	In mode 2 incoming Path MTU Discovery messages will be
 	discarded. Outgoing frames are handled the same as in mode 1,
@@ -49,7 +51,7 @@ ip_no_pmtu_disc - INTEGER
 	Default: FALSE
 
 min_pmtu - INTEGER
-	default 552 - minimum discovered Path MTU
+	default 552 - minimum set Path MTU
 
 ip_forward_use_pmtu - BOOLEAN
 	By default we don't trust protocol path MTUs while forwarding
-- 
2.25.1

