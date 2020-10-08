Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA1C2878A3
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730071AbgJHPzX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731696AbgJHPzV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:21 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1FC8C061755;
        Thu,  8 Oct 2020 08:55:21 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id r10so4644049pgb.10;
        Thu, 08 Oct 2020 08:55:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=LQvHmLfurWZzkIkTeRs/2Uiw+HtCPVHfX0BT7xx2ems=;
        b=l2rFkQ+ZoEJuL18HqLoc/B66Kkt0hs0KY77SVrIFUuSVbPDlXDiTaIQq6GFnkXA7ZB
         SbMtQ+sSgbGBKiTDqyX6gFnZ1JmnuZFn8rzJCOiE2h793wBrdILePkEqtuhsSFKqhk0y
         YqomUVWCIvu+lQ/VVoSvPpnkOqRSDsDodEDQ4RRN7Tf1jppFyPPCj9YbjryV/5nLOpS1
         Qf+ZjD7yOrnTApjbBA8QCuDOWSb3Nsu6dQAspp7hxY+7I5L5KufE/suqps4AbvQdZJyH
         l1wtURQixZdSVNLaF1sf1/74X2G6DM20BeBHa2dzj/jAbfFIliY5+fSHzHnHqn26Byxn
         aJIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=LQvHmLfurWZzkIkTeRs/2Uiw+HtCPVHfX0BT7xx2ems=;
        b=d2/6UoCIa0FIcOT4RQpnpbpHOGUYZukr4Uoxh6abDzzNqK7P2tVV35yW93FCO4Jw6h
         UIs5vrY2p8MFKqcwEqsJyaGuIgPhIuO8MPRLeu8+ubWuuWMpJcn+hOxYfw6I1H0LAEuP
         4ZFlOCZ1MyhI3uEzDB4boc7ISYgkfCIpDR1g7GqCRmNqAGu1B9E+an2RFf2//A2IJeaf
         JAy8dgtlA/pvTh17/B0MMQIn4TeQPWVurZ4Nq9Yc1fSPXuNaTpNfdLzWd3Jx+YLW3XZz
         3rBjwr0ynZiTLHLzXo7vt57uqspm4YZqvTugXmD1FWaFHkwI4vprYmHZfmEi8wSQDqWG
         xlUA==
X-Gm-Message-State: AOAM531lrzJ6JAwpalCaQjpa/Ys5mgt+DYHhPvglp1a3Slx1huu8ZsEo
        k0xWt9OTVYfRJEEEsi8A5X0=
X-Google-Smtp-Source: ABdhPJx2BrtSKiB6MEzRXlg5Bhn/LWFQZddJlKOp94nbWYgMLybFFlEIx+p85zPttj/SrfTtXsVe4Q==
X-Received: by 2002:aa7:8f17:0:b029:152:349f:34df with SMTP id x23-20020aa78f170000b0290152349f34dfmr8440789pfr.54.1602172521320;
        Thu, 08 Oct 2020 08:55:21 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:20 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 058/117] iwlwifi: set rs_sta_dbgfs_rate_scale_data_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:10 +0000
Message-Id: <20201008155209.18025-58-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: be663ab67077 ("iwlwifi: split the drivers for agn and legacy devices 3945/4965")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/4965-rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/4965-rs.c b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
index 6592726235d4..5e3a30d553dc 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2744,6 +2744,7 @@ static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = il4965_rs_sta_dbgfs_rate_scale_data_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static void
-- 
2.17.1

