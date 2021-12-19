Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 040F147A0F7
	for <lists+netdev@lfdr.de>; Sun, 19 Dec 2021 15:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233109AbhLSOdh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Dec 2021 09:33:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbhLSOdg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Dec 2021 09:33:36 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BA9C061574;
        Sun, 19 Dec 2021 06:33:36 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id rj2-20020a17090b3e8200b001b1944bad25so1943768pjb.5;
        Sun, 19 Dec 2021 06:33:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bloZrCVqRUO0XWlsx8uFnJ5nfLTUAStdw+Bdzqr4Jpc=;
        b=UR5JnfdwwpPad1keUL5xoiEe6qqpen8up2zUM/X0o/X3P3EwTuE1rgjQ0omqeQGzEk
         aJDuPUiYK9h+hBZTVYu52/vyM8qE/gGz4xRhqCZODBiJqBXcJvs56FORs39AjAUNcdIZ
         VO5dJDf/WEBUSfhCVpTp5WSZseN8yHCPz8pbDX8N6FihCTMDux5wmwTM15Ju/Hhgis66
         JV/tKeL9RK5pXXu5BgdUWhuIjnPAJTjWU25uBDClSNbivldPcqwltKhMTwNa/hvdPX0q
         KT+t4WbjFKpruPMnJh5X/2nULvJ7iJt4TNoepVpYsBZAlkaOia8MtRDAxLCMC21wXHPD
         4qkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=bloZrCVqRUO0XWlsx8uFnJ5nfLTUAStdw+Bdzqr4Jpc=;
        b=UWyZosltAd+fJvteIDsGmfGX/p6AYNngbHyZ4/qbkur9smw9L7GdqiWIz5a2HnI9RR
         0g9yywFwglhkR6yXYx4Er4ZcmyYOs3DqAidpGArZvQNTtNkqVKEwLdFpFmTA+25SLW8F
         vmmlN1hwwbFL41BZ7Kjkn9fdzSkgsWXszq+dR8nJPnaUbAE9XCvKATS1izGWko/GP81s
         tUuJP+INv8B5h7tX17uPqqCEICY1rSG3yuZy5Z4RhLs7GgM4f7ZAxmejrTERWWU8l22c
         1NWKK+63tZyognq4v3+lk6TMMlQEe09IponQBQzd0VqEdzUbCc0WW99AUc9TLZjWP+Xs
         8XkA==
X-Gm-Message-State: AOAM530+NFR5KBgq46nYBc6SgRwwhz3hPjcgnjA87964yJpPX5XmDpre
        JnhTnkkF+qJjlpeKi/owtrRB3QOQbXMscw==
X-Google-Smtp-Source: ABdhPJwanfxQfrGAVBEW1EKHePDcIFZS+W6lVDgWbZYKuwxwPvkB0jPn9e6KFijI5bYYFL8yp1LdUw==
X-Received: by 2002:a17:902:bd94:b0:148:8b76:71e3 with SMTP id q20-20020a170902bd9400b001488b7671e3mr12281233pls.56.1639924415095;
        Sun, 19 Dec 2021 06:33:35 -0800 (PST)
Received: from ubuntu.. ([103.115.202.103])
        by smtp.gmail.com with ESMTPSA id j7sm15690625pfu.164.2021.12.19.06.33.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Dec 2021 06:33:34 -0800 (PST)
From:   Rohit Chavan <roheetchavan@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rohit Chavan <roheetchavan@gmail.com>
Subject: [PATCH] staging: net: Fixing style problems suggested by checkpatch
Date:   Sun, 19 Dec 2021 20:02:35 +0530
Message-Id: <20211219143235.15995-1-roheetchavan@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Rohit Chavan <roheetchavan@gmail.com>
---
 drivers/net/macvtap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/macvtap.c b/drivers/net/macvtap.c
index 6b12902a803f..4e39792703a5 100644
--- a/drivers/net/macvtap.c
+++ b/drivers/net/macvtap.c
@@ -30,14 +30,13 @@ struct macvtap_dev {
 	struct tap_dev    tap;
 };
 
-/*
- * Variables for dealing with macvtaps device numbers.
- */
+/* Variables for dealing with macvtaps device numbers. */
 static dev_t macvtap_major;
 
 static const void *macvtap_net_namespace(struct device *d)
 {
 	struct net_device *dev = to_net_dev(d->parent);
+
 	return dev_net(dev);
 }
 
@@ -47,6 +46,7 @@ static struct class macvtap_class = {
 	.ns_type = &net_ns_type_operations,
 	.namespace = macvtap_net_namespace,
 };
+
 static struct cdev macvtap_cdev;
 
 #define TUN_OFFLOADS (NETIF_F_HW_CSUM | NETIF_F_TSO_ECN | NETIF_F_TSO | \
-- 
2.32.0

