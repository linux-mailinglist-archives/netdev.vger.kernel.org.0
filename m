Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C048428789E
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731690AbgJHPzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbgJHPzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:13 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3562C061755;
        Thu,  8 Oct 2020 08:55:12 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id x13so1718650pfa.9;
        Thu, 08 Oct 2020 08:55:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=2lngko9sd4ZthONHIlR14GNg4E9vClJ67xyhcTzXBhM=;
        b=eM5CfMZY5sMGEuouVvWiVSxZY6yPwrH4cNVGnAZ1dkIk3yC1lSHejmHjoXRCn9zqXz
         LckedFBuO344pLMCn9AG0CREUTdWgO1g7WzzH8YGzKiynw8g9gOjHZc3fTsKR+oi4eKm
         wO2wg393yVTvlAMpxAJA8ZFiD8w5jNiBoHnmHRhmwfEpoevOvA9TaWBsdF7Kcw6pnAQA
         caAEIEF9yoUQpQ7XwAPmG/kHh+CLtfx92ACsXnvGRVWmzNkHk6mBH0aP1zkmUR7P478O
         HW7bEnO67UcX5a+jQVtlO8pOK8ONBLr1sb1MO3uNRX26Vj5MeRI7RRAtkT8feyoaGOck
         yXVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=2lngko9sd4ZthONHIlR14GNg4E9vClJ67xyhcTzXBhM=;
        b=rPggKZRJftP8mKiO66ihJd4cN3v1azuF6QTLO8zPCcVxI9hDM+zQOicMTvy80XBMOE
         c+uEzhiWIHAygolsF67YIZHNQVa9oyhIk6gyrXOMIyV5fE57LFAuNc83+NcKfCkMDQ0y
         sKERstYlDFGJ0i8NnEO3mXgXmChHmRfwdML1UjvK8nZQkXvRgS8UcXmf0LG1Ez0mH/7F
         HhYDhMAvc/629Cv4ElFL+UKW9b41EB54sE6XfNx0jZc/+ld3bom3s2HviGzNSVOzGxRp
         Q5pH03p9ohNA5NvtPd1LZAAytUSN8sZZrBu7japfP/6n4sEfPjwbySPwG1Wcuc40G1qo
         VPUA==
X-Gm-Message-State: AOAM531uT2Fx88Y+F7Q8qASMLKK3EMx4poOkm0m+ue925NuHIpZizpfo
        p305CiG4AZj4nudBmrdFzBA=
X-Google-Smtp-Source: ABdhPJw61MfLzAFPBYvFafD8ao1D6fz5e8AstdYFNPEBeIH0SIodhqC64tebcghodKUA8P5lNunX8Q==
X-Received: by 2002:a05:6a00:8c5:b029:13e:ce2c:88bd with SMTP id s5-20020a056a0008c5b029013ece2c88bdmr8388138pfu.0.1602172512340;
        Thu, 08 Oct 2020 08:55:12 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:11 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 055/117] iwlwifi: set rs_sta_dbgfs_stats_table_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:07 +0000
Message-Id: <20201008155209.18025-55-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 4bc85c1324aa ("Revert "iwlwifi: split the drivers for agn and legacy devices 3945/4965"")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlegacy/3945-rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlegacy/3945-rs.c b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
index 0af9e997c9f6..f98297541184 100644
--- a/drivers/net/wireless/intel/iwlegacy/3945-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/3945-rs.c
@@ -836,6 +836,7 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = il3945_sta_dbgfs_stats_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static void
-- 
2.17.1

