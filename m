Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24F9E28788D
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731625AbgJHPys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731617AbgJHPyo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:44 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAF86C061755;
        Thu,  8 Oct 2020 08:54:44 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id b26so4346244pff.3;
        Thu, 08 Oct 2020 08:54:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/ZxWZQcmYThvumwflbvzb4h1bQFNFENF6qfUqfiTIuw=;
        b=px6uTwoDJ0AlBn7VC+wZ3Up84aK/oimCWtKPqLiIcpuhjzolQ8AVFqxjdljl7TFrPB
         TrcKKIJ8iiAtff8jiziSy97ya7l0+vPZHGZD7RO4bYdYdr/4aFu+1kHDsA+v3IyOPpbM
         cg7HDprveJOC1B+6O4RFX0tvY8VXJrPzcdJtJKyN410vPfrfUjymCO1qChSvIexH6FzX
         ufj0MPV8OUg4f5tHMZzw+f1MYVAIbbksNR7UCHTnN8Zmy6ZgNOKMp7Agcivkaeqo/kN/
         BxJwESe+hC21pgT/hYcq0lx/jVGHadt/lBDmoVHYzCkEM+QTLT6wynxGQrIjmXL+ksEw
         3f0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/ZxWZQcmYThvumwflbvzb4h1bQFNFENF6qfUqfiTIuw=;
        b=Hq5Pfn/IUR4c1Wv63+EDj31/F2fkhjv3KCI12zTDaJ7zcUB96St3q1LYsRDLXZIeGw
         /0nkKVqilJj4cof+LTXmqRhnqS64L1GhN/imLQjtNgau12pI1OKlZUAwSaDmvcJbIK+n
         Jyy09cziuV0tDYxnIyfPMXNfb7my6ir6uq2szdPsm4Ys2FJD1LYFO4dt6wsZIKwqvpHY
         P5IryKy4J+r90Xal5bh4J5uYs92v29CM4OwWZRN0vtF8zus2FG69fz/p/o4Z/syNJG51
         UOs4b+XHVIluzWL93mllOzw5L3Vz4arCJjH3hZgYIt9JzwQ0DFN9F3Mu6uQlSeMnjvsz
         xUqg==
X-Gm-Message-State: AOAM533tHW9IVdlh1fmdqzfm7ke274ipT2qIurQ5qm4wuU2+PMwzTOt6
        kMNm09hK3MMh3w44RzNxk5U=
X-Google-Smtp-Source: ABdhPJwlafIgb1IsavkqpfnlRY40td1DHhG0/tOjV2GX/P1po2VXIOmhVaS1GqI408ftUhXGw2KX8A==
X-Received: by 2002:a17:90b:ed3:: with SMTP id gz19mr7487287pjb.53.1602172484303;
        Thu, 08 Oct 2020 08:54:44 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:43 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 046/117] iwlwifi: mvm: set rs_sta_dbgfs_drv_tx_stats_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:58 +0000
Message-Id: <20201008155209.18025-46-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 757cf23b4b4b ("iwlwifi: mvm: add per rate tx stats")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/mvm/rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
index 5b81cb1bdd3b..6fc2c841a873 100644
--- a/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/mvm/rs.c
@@ -4042,6 +4042,7 @@ static const struct file_operations rs_sta_dbgfs_drv_tx_stats_ops = {
 	.write = rs_sta_dbgfs_drv_tx_stats_write,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t iwl_dbgfs_ss_force_read(struct file *file,
-- 
2.17.1

