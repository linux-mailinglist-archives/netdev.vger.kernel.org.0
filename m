Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0238D6A9812
	for <lists+netdev@lfdr.de>; Fri,  3 Mar 2023 13:59:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjCCM7c (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Mar 2023 07:59:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42706 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbjCCM7a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Mar 2023 07:59:30 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868DC521D3;
        Fri,  3 Mar 2023 04:59:27 -0800 (PST)
Received: from localhost.localdomain (unknown [182.179.171.187])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id C769E6602FB8;
        Fri,  3 Mar 2023 12:59:22 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1677848365;
        bh=MDOqV2RHO0eQ1qKkCRXV3uNsxpoqYhQQGsWN9W/E1oE=;
        h=From:To:Cc:Subject:Date:From;
        b=RLZn0njeawNYwS1ZNGYzL18IRaIhIRcVIfa36KBsISaD3ae31IG0Gw66EjuwZhdK+
         fgsNEO9yRSGCom1UqHVWFS8qCV2QsiXIRwHgOMCUon3J1APkxaKK9nH8WvIuXLJ0GY
         Iak0zz1BJUvuZjz4kaQlKs5BhROOUTLDtavEz2M17TOj1U1a3x8hBzI6lrkIuTGPyF
         a/334sk7prYwg9yxcVx2RPG/bdXTzkELSZMlrsy4FfWDJ1MECJjfhiKT5BLmRsKwiS
         yai/ee0YUTXhoSIhJ1M+yUGcady0xUyjTs2guC53Gl+rKuLFOyZxbqhjizbKhvLRqT
         r1ieOWXIRuS+w==
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
To:     Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        kernel@collabora.com, kernel-janitors@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qede: remove linux/version.h
Date:   Fri,  3 Mar 2023 17:58:44 +0500
Message-Id: <20230303125844.2050449-1-usama.anjum@collabora.com>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

make versioncheck reports the following:
./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.

So remove linux/version.h from both of these files.

Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
---
 drivers/net/ethernet/qlogic/qede/qede.h         | 1 -
 drivers/net/ethernet/qlogic/qede/qede_ethtool.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/qede/qede.h b/drivers/net/ethernet/qlogic/qede/qede.h
index f90dcfe9ee68..6ff1bd48d2aa 100644
--- a/drivers/net/ethernet/qlogic/qede/qede.h
+++ b/drivers/net/ethernet/qlogic/qede/qede.h
@@ -7,7 +7,6 @@
 #ifndef _QEDE_H_
 #define _QEDE_H_
 #include <linux/compiler.h>
-#include <linux/version.h>
 #include <linux/workqueue.h>
 #include <linux/netdevice.h>
 #include <linux/interrupt.h>
diff --git a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
index 8034d812d5a0..374a86b875a3 100644
--- a/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
+++ b/drivers/net/ethernet/qlogic/qede/qede_ethtool.c
@@ -4,7 +4,6 @@
  * Copyright (c) 2019-2020 Marvell International Ltd.
  */
 
-#include <linux/version.h>
 #include <linux/types.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
-- 
2.39.2

