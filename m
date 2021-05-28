Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F205A39448F
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:54:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236441AbhE1O4G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:56:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47077 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236018AbhE1Oz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:55:59 -0400
Received: from mail-ua1-f69.google.com ([209.85.222.69])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmdsV-00040S-0m
        for netdev@vger.kernel.org; Fri, 28 May 2021 14:54:23 +0000
Received: by mail-ua1-f69.google.com with SMTP id z43-20020a9f372e0000b029020dcb32d820so2037385uad.2
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 07:54:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=aZ/yEEfClIlXQJ5jqul7RvuQr6Fao3s7oVlySYMna4M=;
        b=MMNwJIQ7sZvms9CRGZOJhKxmeRORMRiaInzB3kKpu1ydcbtOzmAgQ/TNhPcC8BQQAa
         +GMRbpgRyrk3AW/jvxGiY/rswqXpQQWvDRacy/KnTmeqe2QaaY8SxnXhpHp1SuqDHaGV
         mBBJdwDr2OqP+GXmr6SIWFcEfGtMZNbYoWbkFZY0zyACVHModBvLP0hZfghtHyRui4jM
         fQhuy1w9jRmhzd6XIgAvOxDV9xz1W5FbNo4z21624VOb8spgCyn0u4nfJhUtRfL2QzOi
         cfexEb7mYGB8ltL0xs1v165fwAAFhF47VN2k7fkDCTqYnPT05QgXa3ljvEcUwqTAlbff
         hVOg==
X-Gm-Message-State: AOAM531DqudWVnNw1QMeKUor6ftWBqsHlpbjRnWUkihH9T4yvF2rPcEA
        F+UV3qKCtktd02bTpCBfDCrnTa3+bgNx2qWsJAPq4rUb8FuRCGSF8ITonsNpuT4ykN0JYAl8UqO
        hStMBOGJ3Ob8OOAuw3pos2C+GUs9J1YwIaw==
X-Received: by 2002:a05:6102:10d1:: with SMTP id t17mr7796934vsr.0.1622213662205;
        Fri, 28 May 2021 07:54:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzkdAq4gRZn+/xWVZNC69A9lFxo0CNOXTTIt/ja4jcZ0FIGsH/Icj4ZQcpxEoounbYrk5FFZg==
X-Received: by 2002:a05:6102:10d1:: with SMTP id t17mr7796916vsr.0.1622213661990;
        Fri, 28 May 2021 07:54:21 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id v132sm737783vkd.1.2021.05.28.07.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 07:54:21 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 02/11] nfc: mei_phy: drop ftrace-like debugging messages
Date:   Fri, 28 May 2021 10:53:21 -0400
Message-Id: <20210528145330.125055-2-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
References: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that the kernel has ftrace, any debugging calls that just do "made
it to this function!" and "leaving this function!" can be removed.
Better to use standard debugging tools.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/mei_phy.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/drivers/nfc/mei_phy.c b/drivers/nfc/mei_phy.c
index 0f43bb389566..e56cea716cd2 100644
--- a/drivers/nfc/mei_phy.c
+++ b/drivers/nfc/mei_phy.c
@@ -98,8 +98,6 @@ static int mei_nfc_if_version(struct nfc_mei_phy *phy)
 	size_t if_version_length;
 	int bytes_recv, r;
 
-	pr_info("%s\n", __func__);
-
 	memset(&cmd, 0, sizeof(struct mei_nfc_cmd));
 	cmd.hdr.cmd = MEI_NFC_CMD_MAINTENANCE;
 	cmd.hdr.data_size = 1;
@@ -146,8 +144,6 @@ static int mei_nfc_connect(struct nfc_mei_phy *phy)
 	size_t connect_length, connect_resp_length;
 	int bytes_recv, r;
 
-	pr_info("%s\n", __func__);
-
 	connect_length = sizeof(struct mei_nfc_cmd) +
 			sizeof(struct mei_nfc_connect);
 
@@ -320,8 +316,6 @@ static int nfc_mei_phy_enable(void *phy_id)
 	int r;
 	struct nfc_mei_phy *phy = phy_id;
 
-	pr_info("%s\n", __func__);
-
 	if (phy->powered == 1)
 		return 0;
 
@@ -363,8 +357,6 @@ static void nfc_mei_phy_disable(void *phy_id)
 {
 	struct nfc_mei_phy *phy = phy_id;
 
-	pr_info("%s\n", __func__);
-
 	mei_cldev_disable(phy->cldev);
 
 	phy->powered = 0;
-- 
2.27.0

