Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C15D35E12B
	for <lists+netdev@lfdr.de>; Tue, 13 Apr 2021 16:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230448AbhDMOQ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Apr 2021 10:16:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:41940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229558AbhDMOQy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Apr 2021 10:16:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B0D3C61242;
        Tue, 13 Apr 2021 14:16:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618323390;
        bh=qmOyqdlMXcdUSgYEBLrreDqaVDuuTYoJlXsPFvU5yf0=;
        h=From:To:Cc:Subject:Date:From;
        b=Qv2sH0UOdXRt6xDfCn5ATldJKv3b1d8MuKMUH0PTR3EXN9HLoT/Ss0yKTEAimapN9
         YAsWtNnT2E/VvZVxCPg8kgVAT4KnY4SYS2ZXYTQTKdhKIGVmdTVv6fav9+gHkW+Imx
         K2xVJV/clMYv1mPS1dod0qqOUgelYs37gSSNMLIxFUXmrICORHXKxeEi0w37MPWaOK
         MnnbfgbdDjkjpCHz1xzxYDq/IbX5P1/unLhkcnqTO4HQeYoqzslBEDs6qkdWX3ng7k
         4pMA2lgYAYRJF6mXhOLyYFq/1sfQd6DSm1Iby+hZuZfbLRHkfV+QMtAJWWEO9bDBhp
         hel5ZTXuny6Aw==
From:   Arnd Bergmann <arnd@kernel.org>
To:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: Space: remove hp100 probe
Date:   Tue, 13 Apr 2021 16:16:17 +0200
Message-Id: <20210413141627.2414092-1-arnd@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

The driver was removed last year, but the static initialization got left
behind by accident.

Fixes: a10079c66290 ("staging: remove hp100 driver")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/net/Space.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/Space.c b/drivers/net/Space.c
index 7bb699d7c422..a61cc7b26a87 100644
--- a/drivers/net/Space.c
+++ b/drivers/net/Space.c
@@ -59,9 +59,6 @@ static int __init probe_list2(int unit, struct devprobe2 *p, int autoprobe)
  * look for EISA/PCI cards in addition to ISA cards).
  */
 static struct devprobe2 isa_probes[] __initdata = {
-#if defined(CONFIG_HP100) && defined(CONFIG_ISA)	/* ISA, EISA */
-	{hp100_probe, 0},
-#endif
 #ifdef CONFIG_3C515
 	{tc515_probe, 0},
 #endif
-- 
2.29.2

