Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C0413A5907
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 16:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbhFMO1q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 10:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231755AbhFMO1p (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Jun 2021 10:27:45 -0400
Received: from mail-qk1-x72f.google.com (mail-qk1-x72f.google.com [IPv6:2607:f8b0:4864:20::72f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1AD8C061574
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 07:25:31 -0700 (PDT)
Received: by mail-qk1-x72f.google.com with SMTP id i68so32443551qke.3
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 07:25:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eGlbIuvyPrFNLTch5ZKTb6/OjYTk+PwqYaQbu3V8zPQ=;
        b=oqaRvE8jB+7n1H4nBHIMCTj2LiwFRUly4eylqaqfiSyyh543eVzrJJFv6MG8G4WE5W
         y69rUuXgFAUGQMyMyWaCnDYQv7gfXV28v+sbDKuKRvcMDGcjyHW8oTkwulrp8DQ6kfy/
         Yb74BWN6hyGYjzSs7g+yhu4PUyE+eJYV896ZWAZfVEUra0cFelqOuGcqgpxOVqkLMXCS
         st2bZRd81/o1X7OasCDE7Je+CIkXxadJYZwwM/fXIV8z3MIMcWAQUeBjljMMKIbV1bTL
         gFvFmPwAW1FNW9DGkYh5MeGNvKKNcZitdyqBb6eiKu9ky+k5Ovhvz0PMQAybU2Js8cJC
         szeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eGlbIuvyPrFNLTch5ZKTb6/OjYTk+PwqYaQbu3V8zPQ=;
        b=KedjDpqzIxtn17d5Xpl8ZHZ/SF0Xm6vNA42PTxU8Gio4vOkkw7YMk2GKtGMyDwyZZg
         Vk/i1BGoNaXvb7TWbFu2oZaQm+C4BEGHJ6ffnhFocJnGQgGr8O2ZYOuDPZ9D00uhjAhR
         G85xdU5Tj4IhZuUNLs3dkje5dlLHXOE7oXHIfOQsN5NZrqdq71tlCdb/GSZjf7c+XHXZ
         gMWE6wY2TsvqPkg1SdO0uWBuEkq0dIP6LdL87Z1ZKST9c7rjX2qzaVWDBQkqrucmQ5cr
         U2DEQwdH6GyRwBtaDxus5VEHO9e2OLns8xuYJHvKMIzCQcFs6UqAaAyK4+PM2sjcHmFl
         x40A==
X-Gm-Message-State: AOAM531zydyFQvsDzAB/ruFGapAP07fW06RiQo9YEbuIB8S4aotXJyiB
        u+Oj9T4FXS0gmBO23fswcA8645EmYcqXbhKa
X-Google-Smtp-Source: ABdhPJzJ+AiQWnCTCvXFMB+pZH4H093khqB/qnW44kfCsTUaYElCAhFbAx/XtPexOv7CSULREjkPag==
X-Received: by 2002:a37:a095:: with SMTP id j143mr12310329qke.68.1623594330603;
        Sun, 13 Jun 2021 07:25:30 -0700 (PDT)
Received: from presto.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id z3sm8382706qkj.40.2021.06.13.07.25.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Jun 2021 07:25:30 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     subashab@codeaurora.org, stranche@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org
Cc:     lkp@intel.com, bjorn.andersson@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH net-next v2 1/1] net: qualcomm: rmnet: always expose a few functions
Date:   Sun, 13 Jun 2021 09:25:22 -0500
Message-Id: <20210613142522.3585441-1-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

A recent change tidied up some conditional code, avoiding the use of
some #ifdefs.  Unfortunately, if CONFIG_IPV6 was not enabled, it
meant that two functions were referenced but never defined.

The easiest fix is to just define stubs for these functions if
CONFIG_IPV6 is not defined.  This will soon be simplified further
by some other development in the works...

Reported-by: kernel test robot <lkp@intel.com>
Fixes: 75db5b07f8c39 ("net: qualcomm: rmnet: eliminate some ifdefs")
Signed-off-by: Alex Elder <elder@linaro.org>
---
v2: Rebased on current net-next/master; this fixes a bug there.

 .../net/ethernet/qualcomm/rmnet/rmnet_map_data.c  | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
index a6ce22f60a00c..39fba3a347fa6 100644
--- a/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
+++ b/drivers/net/ethernet/qualcomm/rmnet/rmnet_map_data.c
@@ -153,6 +153,14 @@ rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
 	priv->stats.csum_ok++;
 	return 0;
 }
+#else
+static int
+rmnet_map_ipv6_dl_csum_trailer(struct sk_buff *skb,
+			       struct rmnet_map_dl_csum_trailer *csum_trailer,
+			       struct rmnet_priv *priv)
+{
+	return 0;
+}
 #endif
 
 static void rmnet_map_complement_ipv4_txporthdr_csum_field(void *iphdr)
@@ -223,6 +231,13 @@ rmnet_map_ipv6_ul_csum_header(struct ipv6hdr *ipv6hdr,
 
 	rmnet_map_complement_ipv6_txporthdr_csum_field(ipv6hdr);
 }
+#else
+static void
+rmnet_map_ipv6_ul_csum_header(void *ip6hdr,
+			      struct rmnet_map_ul_csum_header *ul_header,
+			      struct sk_buff *skb)
+{
+}
 #endif
 
 static void rmnet_map_v5_checksum_uplink_packet(struct sk_buff *skb,
-- 
2.27.0

