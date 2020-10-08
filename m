Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B682287986
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732078AbgJHQAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730169AbgJHPzZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:55:25 -0400
Received: from mail-pg1-x541.google.com (mail-pg1-x541.google.com [IPv6:2607:f8b0:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 076BDC061755;
        Thu,  8 Oct 2020 08:55:25 -0700 (PDT)
Received: by mail-pg1-x541.google.com with SMTP id o25so4678614pgm.0;
        Thu, 08 Oct 2020 08:55:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=hnBhJK9M3cDN/3MrcX0Hb7CvhlHNqO5pN/DaNQb4/bk=;
        b=reydX1Ehm8V2GjhHZTyDwBBNzCJu5eg1905BNOIKcAdfwnpthErWa0fLDKl1N6PTD/
         P+Mb9MA/VZXJe79g15havimgdU1JhdIarlWoBlNNQkAjagFQ8P9ypyxAz1zR2dKqYqjz
         Dz/HIrqr/hZRe+aKDP9NR1fyfx9Hi9cc0MqCRDnRmXhkUq/NGDZhzJ7ooiB4V94fd8k1
         tJP7ZZke1pVGVvzokUSfUjOMgymBafiGg/3WydxpZ9BSLzWjXBzK+GhMJIG4zyPAJKM9
         PEjlStHoV9NpAMfiHYKg1phVmZKRS2mnTVdTkXSiylSWhq0ZY1V6sLjjms4g0c9RtWQw
         Ypcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=hnBhJK9M3cDN/3MrcX0Hb7CvhlHNqO5pN/DaNQb4/bk=;
        b=uO9vuBlX1RoQNTzaiagf0UyvyZjw4r5QcSXSYm3GRqg0G/3YSaUjP2gv0m1kCAqDyB
         dJjNQvEC2KD9JeqYAqx+uZ8TF1ph3AhS68rmDgDKfVVMcqep68y5jC4LKz3kfYZJRAQc
         c8Vf9OK0BBiQiLD2VmjNdKeN1DeH7XZ4Y6qxIqm64F7Hb9SsSakJnByNZqJTcsrf+kPv
         06O4yxWzWCbfdf5P9+zu/fzpDxr5prnrj993tvVU4D4SV1lQPcvhXBBur3Flj2FmMa5t
         DwwnIE0cBBOhLbTkxb9GOdGT78XplOV7JhATXSt1V0RS5PKqUqVDjWwqyP9y8YsTZur9
         FbRw==
X-Gm-Message-State: AOAM531wMWhtshpCTlPbhpgvb4xcIunbheqd5wTg64fis2dFOA+rmhR3
        2bHvufdFzRC7b8FNzm3ZIxg=
X-Google-Smtp-Source: ABdhPJzUev43nfkPyclxRA0xCfNiWzK2Cx9ViQa9gloHWQIjjEMv5UwTt/zBsq3yqnslT4ptQGyZRw==
X-Received: by 2002:a63:b18:: with SMTP id 24mr5529398pgl.214.1602172524620;
        Thu, 08 Oct 2020 08:55:24 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:55:23 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 059/117] iwlagn: set rs_sta_dbgfs_rate_scale_data_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:51:11 +0000
Message-Id: <20201008155209.18025-59-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 38167459da50 ("iwlagn: show current rate scale data in debugfs")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index 4075cb53bc73..48b945594f4c 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -3243,6 +3243,7 @@ static const struct file_operations rs_sta_dbgfs_rate_scale_data_ops = {
 	.read = rs_sta_dbgfs_rate_scale_data_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 
 static void rs_add_debugfs(void *priv, void *priv_sta,
-- 
2.17.1

