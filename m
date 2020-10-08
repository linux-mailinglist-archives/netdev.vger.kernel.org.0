Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6831428787A
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 17:54:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731346AbgJHPyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 11:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729848AbgJHPyX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:23 -0400
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 075ADC061755;
        Thu,  8 Oct 2020 08:54:23 -0700 (PDT)
Received: by mail-pl1-x641.google.com with SMTP id bb1so2973043plb.2;
        Thu, 08 Oct 2020 08:54:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nmiA/KBSwd7784lusScsHT1dwswv584qlu0MA+YYr8Q=;
        b=JqoDZT+ZV4Tkx+iVvMy2g9SdjspWLuC3FH4dQJaEJ5TZ3vCsYZNG8RGk6Sdg1PD0Ws
         ZCSyL+1ikSXRWXg3Qq/EI58YzwCjj8rzwkxIu1ou/PlnmFgGe/eR3gMZzg9ewwwV+YWo
         8M4KrGfMsbGCgdUfAV3mD87B7SgDgJcjx4nGlHAL7pp0hYlfxpbr/AnzmQ7PzFl1nMZo
         v0bKkOeBlakO1CZD6EPt5TXLf/VYvMpAKxhwdb//vbfloEejFa0A1wWSR2jdnaru5sXT
         Def7q1IsCRurbtuMKL0bhcpgBb2eW4toml847hsFVMSsTXbhi87Ira2HgDKzPK+97WiT
         87SA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nmiA/KBSwd7784lusScsHT1dwswv584qlu0MA+YYr8Q=;
        b=dhi6y6LJbeZzQZorKcypCjdQPIcj3yJpA+3cGZnPZBEPLx64NVxtPPwj7gVoiVX99X
         nir45RE0ayFk9kin1tHoo9SlauuFe0gcTfFo8Wg9g1pa6/csh7SSt/jJXGGlk+X9F7WY
         w7VU495aUrWUcJl9FXDiSXfLK0/zzludwi4yTi0sGEfUkM0jitavC5V5YIbrzUoduGd+
         XUWYuhMpoKW3usXTTBc2OqxwH4uWx5S+RBUKRN4mJyoQ4IZguMb+rE10hJCzFLFaaS53
         RAZQ6HTN1hVDa8wZwWp9uz/AmELr2jRx8imZ+a1UCHDZECq8+Um+4xzpCsC5sVIXi/ra
         wddQ==
X-Gm-Message-State: AOAM5317PJwNVX2VnH2qztK5t3q+/QFEfYh9KqCEA2HOAqUnI6zIb8NG
        plcLGoDKhbiVtud3RnVph9c=
X-Google-Smtp-Source: ABdhPJzQSPT+BnGN12b7GhjmTHZAZa09NieEpWrULU7C9Uh8aw5gaRv5exlJXUN6U6N6AonEApbsjQ==
X-Received: by 2002:a17:902:a613:b029:d3:8afc:da51 with SMTP id u19-20020a170902a613b02900d38afcda51mr8048476plq.19.1602172462567;
        Thu, 08 Oct 2020 08:54:22 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:21 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 039/117] iwlwifi: set rs_sta_dbgfs_scale_table_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:51 +0000
Message-Id: <20201008155209.18025-39-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 5ae212c9273d ("[PATCH] iwlwifi: add read rate scale table debugfs function")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/dvm/rs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
index 4fa4eab2d7f3..d013203c7d5a 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rs.c
@@ -3172,6 +3172,7 @@ static const struct file_operations rs_sta_dbgfs_scale_table_ops = {
 	.read = rs_sta_dbgfs_scale_table_read,
 	.open = simple_open,
 	.llseek = default_llseek,
+	.owner = THIS_MODULE,
 };
 static ssize_t rs_sta_dbgfs_stats_table_read(struct file *file,
 			char __user *user_buf, size_t count, loff_t *ppos)
-- 
2.17.1

