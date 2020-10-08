Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9668A28799A
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732086AbgJHQAu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:00:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729947AbgJHPxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:53:48 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF1CC0613D3;
        Thu,  8 Oct 2020 08:53:48 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id c6so2959182plr.9;
        Thu, 08 Oct 2020 08:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=eGFJIgP053ScE+PFF1Ivd3oGlVY7ykLxtYi1ouJSioY=;
        b=gls/p8OuzTkk61NIYH6ttm05V3El7H3svT1l2pGM9oFjtD3D6x8xUJyiDRgVvS2NH/
         DezwkNHM8I8oDnKKAaZHZ16ik6TWjxzhoR3LXEcqlEfpfVbRPQa5ci1f58JkP6NS74vB
         CPAUrJFfRgz1EGQv+3rkVSJO1+DPk8oVz9Y2mSU6POwh2YVfVRp0SVPhXzYe8J7Wa+gu
         FX2yIysimaUhQrgC/MKtdvVPqX9uJ9ju7kSqmQpeBzYC/w0H1LiHw0KlVheC2u6jF9IO
         BsisPogS5fdZ6RH9S0GzgNyzW3tBualuLLh7SrqYykvc+Uc85aMX3QpXLwuQgKMh3ecs
         /73w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=eGFJIgP053ScE+PFF1Ivd3oGlVY7ykLxtYi1ouJSioY=;
        b=h6jzeIM6WYYwCWPYvIQYesd+zKpOlVx49gDKn4k4Dtwm3mXxQhHOHZTPtwTZxI0p2H
         fFYKaPBKhQYSX0CEYpz4n3BwwP4LAcpA+TyqMnMbKkP/771nuJ/o+QG9bTUjjDGsyw5g
         MfN8Pc/YV/uMYECh8seNIxl6svFg2EWWj1rTtUcy578uPFd6wV1JLj+nrjFP0gkrWeDK
         h5W7Py8YfYoGRKFaPRP0ZuOmEdmGkc9dpdV33KtMSkkXBIQU1lZyn+/uFRyZnHSa1+Yv
         GYy2obQuAOo5jjEBQ2zV5+E5J32kd6F5Qa2dxa6bgB6BH8bv+RDcsnDO9XJMudxhJ7RO
         zBdA==
X-Gm-Message-State: AOAM531ybf33qipJkopfN2eaP+8Yy4FZ1WrQZJTx9uQuTc9tL2um/niz
        xBMGerO7+GgcCnR6S6PalOQ=
X-Google-Smtp-Source: ABdhPJxsWZMb7ZJCJUG6Q992Mp5ALpIFeteOEDbadcmPYxSfOk5F56jNKdsmk6Cd46ZPPg7cqIpzfg==
X-Received: by 2002:a17:902:b088:b029:d3:f20c:ed85 with SMTP id p8-20020a170902b088b02900d3f20ced85mr8315735plr.8.1602172428348;
        Thu, 08 Oct 2020 08:53:48 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.53.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:53:47 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 028/117] i2400m: set i2400m_tx_stats_fops.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:40 +0000
Message-Id: <20201008155209.18025-28-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: c71228caf91e ("i2400m: debugfs controls")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wimax/i2400m/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wimax/i2400m/debugfs.c b/drivers/net/wimax/i2400m/debugfs.c
index 9eda1535f777..144f8a7e98af 100644
--- a/drivers/net/wimax/i2400m/debugfs.c
+++ b/drivers/net/wimax/i2400m/debugfs.c
@@ -141,6 +141,7 @@ const struct file_operations i2400m_tx_stats_fops = {
 	.read =		i2400m_tx_stats_read,
 	.write =	i2400m_tx_stats_write,
 	.llseek =	default_llseek,
+	.owner =	THIS_MODULE,
 };
 
 
-- 
2.17.1

