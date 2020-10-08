Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0A91287994
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732083AbgJHQAj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:00:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730012AbgJHPxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:52 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3C83C0613D4;
        Thu,  8 Oct 2020 08:53:51 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id l126so4338313pfd.5;
        Thu, 08 Oct 2020 08:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=P9298AG1dm6vfs+dshDdtQyz3vMsR0EKf8MkvhRZOlo=;
        b=asLmgsKAsat7YqoU7OgFtc4rXWkYd9uCR//A16sXfAY3Ef+sOlkno0v7O54mj26uWU
         2Q2bMFfZ2pi/22cA/vBL73xy0Au8cqQ7ErwTRDLbfobqnQdJijuU8d/W7e+log/vxCnP
         LTbMSx6VdwW/efWaVC5QcvAlenVcRZZtb4FTtIbEH/O5BULZK8JVbK90u65SQ2DS00uX
         SKVdvxQ9QlVClfstF4WG7v0TTDIIkdLZSzJRYH4yuRu0g8vMTTZXD18/Ppg6R3V9669a
         CFOApXaVIGTKjh0YxzVlIiyraOfrbYiGqa45UDWefZ4ThMl4GOQit8/7dfPsUVHiVEg7
         wpkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=P9298AG1dm6vfs+dshDdtQyz3vMsR0EKf8MkvhRZOlo=;
        b=IbH+UoHqUrWR0pivw/6NpM1vj4AldT4ugoJsNKniefXjYHQWQZodkPg4ntkbF/0z7M
         BYOw1CQ57lL79TuEYK6BbblpAXWwRTA/y7K4pzgt3xsAJa6tiMT13d7ks1MxTxeRu7jf
         xRujagl1KNhKvihjAXpOCJoBOuQhJYw6Oj5rltTlJMWi81ykOrccU/p7CQ3UaGhJze41
         V5Oj54jNjXZ8p66Wv114SIJLL9MYaaUNt/n5TtiFFbqCFDOjpMPmP+MKrB+Q0UWpPOIE
         7TmpUBf27SMkvKuog4reVNlkHL1+07uGnlFE9ZPA06BOd/y+UyZ/8Jtc+L/BwYgcHE+k
         kpaQ==
X-Gm-Message-State: AOAM530/PaDJyosxRvgb4DTMWUPJhVpSujsgtjl6eOg84mZr2cFcrw13
        3hLlRO5M8LH1t/KeRFZTGS4=
X-Google-Smtp-Source: ABdhPJyCN6uWEoc7pNtVBtqCaj2k7X+qYmBxgweeTk1Lsv/8X70TsV2p31uSpO58w0Yk2LjSoEk87g==
X-Received: by 2002:a05:6a00:8c5:b029:13e:ce2c:88bd with SMTP id s5-20020a056a0008c5b029013ece2c88bdmr8383825pfu.0.1602172431446;
        Thu, 08 Oct 2020 08:53:51 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:50 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 029/117] dpaa2-eth: set dpaa2_dbg_cpu_ops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:41 +0000
Message-Id: <20201008155209.18025-29-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 091a19ea6e34 ("dpaa2-eth: add debugfs statistics")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
index 56d9927fbfda..765577386fc7 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-debugfs.c
@@ -59,6 +59,7 @@ static const struct file_operations dpaa2_dbg_cpu_ops = {
 	.read = seq_read,
 	.llseek = seq_lseek,
 	.release = single_release,
+	.owner = THIS_MODULE,
 };
 
 static char *fq_type_to_str(struct dpaa2_eth_fq *fq)
-- 
2.17.1

