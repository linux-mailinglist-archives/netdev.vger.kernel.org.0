Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FE12878B1
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731734AbgJHPze (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:55:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730114AbgJHPzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:18 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A539EC0613D3;
        Thu,  8 Oct 2020 08:55:18 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id d23so2964708pll.7;
        Thu, 08 Oct 2020 08:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qCio2tJg2lTUTBkvGAUFb0+rsX4JAZvslEUHcVRdzr8=;
        b=GefW8PYO6D7RndDKqWCIMQJZPyBh3jNqq2i9EFUULs4DpDrb/VXpoSpG6fTFEA3+Mz
         vagsVvUzcEunxu/wHfswwhg1gh2tIFXeMLorxictWx0Ttjbgt5csAQ6fSAJ2bHWHgXUT
         TMh87r5lgNxDTjINA6ftNwvSIRX+IV3FnB6Zv5rCZX2Y5oenIeI9LlxvHWqdL2oR/CwU
         4VqB0TvtI5VzzZPMhdMgPuYBppJ9atAMVRzWQzvURhPChOUevRwBCi16i1hYj4RHhE1N
         Vh/KFd0M3ygSOm+0lomvk2Q9KIUk/yblUbRYxc/gXuW6pXE+vzzAtEjATmJVkMRKJJWI
         MHyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qCio2tJg2lTUTBkvGAUFb0+rsX4JAZvslEUHcVRdzr8=;
        b=YkQDVOIYWQJsTXE38tt9jBHdbLJvwF/VEp62r7KDoZ2I+/bnNoHsdHwBG2MGrwrCU4
         ZPLyYjtD4+PjVSYx4sGEmIOlWPekv2/8n5T7KJmyBIQkZ+bAljcRG5vttOtChehdnWJT
         Ay5tLtAUcXARZv18ADiVR7wP1iEJej8rlye6oUhLNCLg9VRBjULPv447wMxs2JS4Rahj
         hqdsN43HtsoIj+jloFR7UuUFAbrLwpoRPwVPerdUZvUd2s3404Fd/2WU4i5ByotJTrWf
         Byb9XV6kGovjXI6fXljjuXwOMYjpnpRJKzw3lhXMuvLNrOV9wXWTXA+br+9d4uO5dyss
         Wugw==
X-Gm-Message-State: AOAM533Mb65NN7/MpGQ46y01FqsXYBRW6LVsPsvVhXppa7WIg+rxWfVt
        FaW2TpPnPECs37JF/rDlfFj4XOmDSoU=
X-Google-Smtp-Source: ABdhPJy4LDME/81FJtjwtsrr2FaEi0X/a0wNFyCR7WyVrNqI0KP/PNroMzHkVqo7QRLUSbOuZsxrcw==
X-Received: by 2002:a17:902:b592:b029:d3:8dc4:391e with SMTP id a18-20020a170902b592b02900d38dc4391emr8460545pls.76.1602172518244;
        Thu, 08 Oct 2020 08:55:18 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:17 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 057/117] iwlwifi: set rs_sta_dbgfs_stats_table_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:09 +0000
Message-Id: <20201008155209.18025-57-ap420073@gmail.com>
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
index 43fff3fd18e7..6592726235d4 100644
--- a/drivers/net/wireless/intel/iwlegacy/4965-rs.c
+++ b/drivers/net/wireless/intel/iwlegacy/4965-rs.c
@@ -2715,6 +2715,7 @@ static const struct file_operations rs_sta_dbgfs_stats_table_ops = {
 	.read = il4965_rs_sta_dbgfs_stats_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static ssize_t
-- 
2.17.1

