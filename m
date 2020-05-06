Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 855511C7548
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 17:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729438AbgEFPrO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 11:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729148AbgEFPrN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 11:47:13 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93D4BC061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 08:47:13 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id n11so945514pgl.9
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 08:47:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=my6Nl83bIoL5iwRQhs+wXrxy12W6scxePc37sQf7baI=;
        b=dVQ73/4uLXAwc5MwPCrg4sROVJNLYzga/FfF15xx6/3YkFVWkCBQ2AkLYqVjv4hRiD
         LI96O1gArropdNTX4cSlO5qt/5mPZXpjidaoHkb/jy18wjWrqouscidKOniYb1QuxUao
         3NxtDGDODRflRvKMbcpmLHd56xzOvkvChzjQXB4U+m7BBTKdlzaR7tuNYBtDcuKaaF3Y
         w4tM25WEXc/YLa79vPcO10FrenrmZvACoNokbPR7SNQvZKubyJfesXFlCY60BKavfJBU
         TOyeY/Blq2Um+Lab5yqciq6h4uXnsWYct6FhenYg9g9/Y3GLRsBbZumizLrEcqJ/JqoB
         ITCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=my6Nl83bIoL5iwRQhs+wXrxy12W6scxePc37sQf7baI=;
        b=ozcPidvCU7iT3ZP3X/cVVIuQ/qnxXhzVv1Zyz2/PSIy1be8XnoPgN38aXqy79x1wro
         9F2eS2ukUa4uRy3GHul1brAo9DZCZNl2uR+wo047wQCbr/OoaFipl3cEpjEiJEzgEn5G
         +rk1EjzlC9Jq581fLue3G2iiWBnyOr8hUHVl4aEIDKCDpJqvtxLwuFBeJi6iLvohfm5z
         bXWe6TZDfyZCb2H6FCXHJDEb7qMu50u/gr9Ge7vpZYhmz8MGfh9FYEKew27/q5YaNsER
         6MdA7lF8UOcQZTsBeKNCiJDvPNORPOedt83/EHflflsoeEw47gxEV6dTn8M8/ZaPDGkz
         J0ow==
X-Gm-Message-State: AGi0PuZ1U2Lvfe9yrEeZZo2sjVcOi4Z1LJGoeeekwazvFhLq+lpb4yts
        sVI7/7ERKUlyNYeWdZ1mnVw=
X-Google-Smtp-Source: APiQypLV+qsacLMbDvBzIpxiCjLDkBf1KSJsLesgMWQm7B6bPRak4/TkL8177MrQDFxBFITYhVsGdA==
X-Received: by 2002:a62:1dd2:: with SMTP id d201mr8631744pfd.54.1588780033112;
        Wed, 06 May 2020 08:47:13 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id r21sm4961318pjo.2.2020.05.06.08.47.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2020 08:47:12 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com
Subject: [PATCH net-next 1/2] hsr: remove incorrect comment
Date:   Wed,  6 May 2020 15:47:02 +0000
Message-Id: <20200506154702.12432-1-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The hsr_netdev_notify() deals with hsr master notification event because
of debugfs.
So, comment for hsr_netdev_notify() is not correct.

Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 net/hsr/hsr_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/hsr/hsr_main.c b/net/hsr/hsr_main.c
index e2564de67603..332eeb2d9802 100644
--- a/net/hsr/hsr_main.c
+++ b/net/hsr/hsr_main.c
@@ -127,7 +127,7 @@ struct hsr_port *hsr_port_get_hsr(struct hsr_priv *hsr, enum hsr_port_type pt)
 }
 
 static struct notifier_block hsr_nb = {
-	.notifier_call = hsr_netdev_notify,	/* Slave event notifications */
+	.notifier_call = hsr_netdev_notify,
 };
 
 static int __init hsr_init(void)
-- 
2.17.1

