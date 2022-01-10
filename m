Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDF94896AA
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 11:47:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244125AbiAJKrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 05:47:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235222AbiAJKrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 05:47:02 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26B3FC06173F;
        Mon, 10 Jan 2022 02:47:02 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id hv15so5699348pjb.5;
        Mon, 10 Jan 2022 02:47:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pY10rB3otKHYN/zyCOaytbgVsZbjDHmRjoptsEgakk4=;
        b=DlbdsL4/vcmWrhWDTfRizebiGQUO8oU7YSvF1AMp3Qs6/e9K2xp9Lr6Sd377V7dfzY
         cObPvqBMdHDbUVJVrJc2glnLTAHnKAankmXDYNmkh9KoMH63tG7KHdahXqMHUJqNZ7KB
         988UW3ii7fNuyVuiCH9EibqpkVKB//AXUPLj9vuIf/af7ij00ROK3XW2mjkW0xRgYFR6
         9Sq2tsDbQhmPfgwMSSN2iYXqWstTloqnhGv8a+whKo38TocRRD+BS1GOjEIYSO43kGXz
         JLaa1CEn0GM+c9KwzEkO6BunbcLDXVoX5MYhKABA8VLcdjyq50FQpdWXpovEsHpj+TWu
         r+cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pY10rB3otKHYN/zyCOaytbgVsZbjDHmRjoptsEgakk4=;
        b=Zk9FaaVz4VwS+Gk1C5pl9p+iC0+xOk+6Jyvj8uosGleW0pKIJEhKQheX/ObYgXWM4y
         xlNkYsUZjKySduWjWxs81fZkdQ1xn8clkhxEuxLVPVPZM4EMmLh7u5OJ8pdrKs1sxFCu
         yNu6LN1BP7kPXk8kThm9McK6i3i/jxFeUu/y7pLGi/lN2IGeYrt7rzUbYV1HW3O4/BsU
         NrreJ31Dxr7wLH3OwIQOkPRG4nBKi4DfsKjbsOCYjegEnWsuwrfG1svP497AwL8YtkPS
         5HsVLF1S2WNtSICCULZSU+4WMrkYfWg8wnQWBUswKaUd9su63m13nZYCr7H3HnGeeI67
         ioKg==
X-Gm-Message-State: AOAM530N+I0NFvrdRGXBFHK1o4+Ym7ONFqc6Ocpt2BwaQvD6FE9bbW7s
        RUsJYUmlKq6lmE8zD+Z/BskZ8KD2PNg=
X-Google-Smtp-Source: ABdhPJzFJTakr/Mtd3uTh0LT2vS9i9iNtOUr4VcCKhundTvvfs4Uf2zoApHQdOQVvslMbWwJEaeF/A==
X-Received: by 2002:a17:90a:748e:: with SMTP id p14mr26973573pjk.231.1641811621723;
        Mon, 10 Jan 2022 02:47:01 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id b11sm5350574pge.84.2022.01.10.02.46.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 02:47:01 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     jesse.brandeburg@intel.com
Cc:     anthony.l.nguyen@intel.com, davem@davemloft.net, kuba@kernel.org,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, CGEL ZTE <cgel.zte@gmail.com>
Subject: [PATCH] ethernet/intel: remove redundant ret variable
Date:   Mon, 10 Jan 2022 10:46:56 +0000
Message-Id: <20220110104656.646861-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value directly instead of taking this in another redundant
variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
Signed-off-by: CGEL ZTE <cgel.zte@gmail.com>
---
 drivers/net/ethernet/intel/iavf/iavf_main.c | 9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c b/drivers/net/ethernet/intel/iavf/iavf_main.c
index 504fea4e90fb..a138dc64b8b7 100644
--- a/drivers/net/ethernet/intel/iavf/iavf_main.c
+++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
@@ -1517,7 +1517,6 @@ static void iavf_fill_rss_lut(struct iavf_adapter *adapter)
 static int iavf_init_rss(struct iavf_adapter *adapter)
 {
 	struct iavf_hw *hw = &adapter->hw;
-	int ret;
 
 	if (!RSS_PF(adapter)) {
 		/* Enable PCTYPES for RSS, TCP/UDP with IPv4/IPv6 */
@@ -1533,9 +1532,8 @@ static int iavf_init_rss(struct iavf_adapter *adapter)
 
 	iavf_fill_rss_lut(adapter);
 	netdev_rss_key_fill((void *)adapter->rss_key, adapter->rss_key_size);
-	ret = iavf_config_rss(adapter);
 
-	return ret;
+	return iavf_config_rss(adapter);
 }
 
 /**
@@ -4689,8 +4687,6 @@ static struct pci_driver iavf_driver = {
  **/
 static int __init iavf_init_module(void)
 {
-	int ret;
-
 	pr_info("iavf: %s\n", iavf_driver_string);
 
 	pr_info("%s\n", iavf_copyright);
@@ -4701,8 +4697,7 @@ static int __init iavf_init_module(void)
 		pr_err("%s: Failed to create workqueue\n", iavf_driver_name);
 		return -ENOMEM;
 	}
-	ret = pci_register_driver(&iavf_driver);
-	return ret;
+	return pci_register_driver(&iavf_driver);
 }
 
 module_init(iavf_init_module);
-- 
2.25.1

