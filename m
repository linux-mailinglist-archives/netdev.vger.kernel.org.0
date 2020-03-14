Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 077F6185449
	for <lists+netdev@lfdr.de>; Sat, 14 Mar 2020 04:41:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726605AbgCNDlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Mar 2020 23:41:07 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:42886 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726559AbgCNDlH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Mar 2020 23:41:07 -0400
Received: by mail-ot1-f67.google.com with SMTP id 66so12313508otd.9
        for <netdev@vger.kernel.org>; Fri, 13 Mar 2020 20:41:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ODvQm7I1R8oQFiKWbyZvHkjHtUzE99mqtt7tG1Qrc4A=;
        b=YinwBM1qw/x6pNIDcIjyVMjQ8B2RnEmHHtdboOVUAQGFaFtlQzTIY+arR2dUd+xYVT
         /unAgNusqxByS26YLzbQAolitC3H+IGdzYQS887uclsUZxPsPN4Rkc9yQeRknZmINgpe
         w/3rs4P6IbK1IIX/95iNqJcErDQcBZF12M81jE8wyeN9xscjzq45hOH3yk8wqOF/VEwl
         uxG3nkw9dQsbAyXy211kJuGvCSPC2/TjnSmE2wMZ61V0iU4T91+PZ5rpFTk5jNzxEGGk
         waDdKeLjphJn5xiFbWfgyWWrdymCutNCgTBbX8CdnV51J8hp81b+kkOt4rvL7ufIvMFk
         nX2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ODvQm7I1R8oQFiKWbyZvHkjHtUzE99mqtt7tG1Qrc4A=;
        b=ZE8vjXJmf/h/lYOvkpNsUIy4EeRRsj5EG4P0F7q7BReJGagBP7AN5zvKdTwVWZ4G+S
         zTIA3tOuiy732ceifm5COXhfPLwgbTgBvZW6TzuN8MLzWuEGqNilzmAcbbxwuUKPJdQz
         iAFUN+3g4eR5Hvyj2QS7zEj2TMkrC2Ms6MSq88MpL8jlyLmqMKI4uBb6Je8tjdlNtX+R
         0zJRD327CGpvMIjmSHH1Dejy9d5e/JWOUDhpY/oVnl9WeSBGAyyxD3JL2OVVF4ZIc1uj
         5TprQ3TVbtFVw4+PqJoDrQcaIHwXCtp5+Tr1defY4NYVJlh4iYuDnE9lPPqU6hhXI6gR
         fPpQ==
X-Gm-Message-State: ANhLgQ1pp5h6Hcd3o9ogio6ESjh9sF2FsHAPwdkaUe4nO7XgkyMfeT1B
        g/YHe0318TeAaxUTAEVDPy8=
X-Google-Smtp-Source: ADFU+vtiXwqoP7ZCh6brbdMfiZ3AiC7Y64r/MDI/OQPmKC/SawBOyuJQ1xXZnjmdk0jy6Z1I+uHYxg==
X-Received: by 2002:a9d:3f4b:: with SMTP id m69mr12954778otc.146.1584157266403;
        Fri, 13 Mar 2020 20:41:06 -0700 (PDT)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id m21sm2138101otq.35.2020.03.13.20.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2020 20:41:05 -0700 (PDT)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     paulb@mellanox.com
Cc:     davem@davemloft.net, jakub.kicinski@netronome.com,
        jiri@mellanox.com, netdev@vger.kernel.org, ozsh@mellanox.com,
        roid@mellanox.com, saeedm@mellanox.com, vladbu@mellanox.com,
        clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH -next] net/mlx5: Add missing inline to stub esw_add_restore_rule
Date:   Fri, 13 Mar 2020 20:40:20 -0700
Message-Id: <20200314034019.3374-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.26.0.rc1
In-Reply-To: <1581847296-19194-8-git-send-email-paulb@mellanox.com>
References: <1581847296-19194-8-git-send-email-paulb@mellanox.com>
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When CONFIG_MLX5_ESWITCH is unset, clang warns:

In file included from drivers/net/ethernet/mellanox/mlx5/core/main.c:58:
drivers/net/ethernet/mellanox/mlx5/core/eswitch.h:670:1: warning: unused
function 'esw_add_restore_rule' [-Wunused-function]
esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
^
1 warning generated.

This stub function is missing inline; add it to suppress the warning.

Fixes: 11b717d61526 ("net/mlx5: E-Switch, Get reg_c0 value on CQE")
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 2e0417dd8ce3..470a16e63242 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -666,7 +666,7 @@ static inline const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 
 static inline void mlx5_eswitch_update_num_of_vfs(struct mlx5_eswitch *esw, const int num_vfs) {}
 
-static struct mlx5_flow_handle *
+static inline struct mlx5_flow_handle *
 esw_add_restore_rule(struct mlx5_eswitch *esw, u32 tag)
 {
 	return ERR_PTR(-EOPNOTSUPP);
-- 
2.26.0.rc1

