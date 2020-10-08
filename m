Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72AEB287993
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 18:01:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731600AbgJHQAi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 12:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731604AbgJHPyK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 11:54:10 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D7C1C061755;
        Thu,  8 Oct 2020 08:54:10 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id n9so4641747pgf.9;
        Thu, 08 Oct 2020 08:54:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=5ZO2ElXGMMwApl/ZmLhQFUcHmK3CxaaCCzXn5YZAuEQ=;
        b=fRm40/82YYywOHwJq01N2WxvFNO7xJhSmhFWbjqvG3ytOWT6IRjrBjH1B+UZsj43qN
         HWWiF1ih/sYM6m/vGsCGMUiyfs64Gk2ZggbjWIarmZKDzNE9SgoHY4TZ+7iRoXPDcHRy
         TLueaGp2ghx7BnCCdx/VwXDjE1WbZwM+UU3Nu8c3HbsDmXp9KlmApuDFZN7fci4GWNP8
         dr+p1cYOKG3xwbV9KEJgceu1Wj6R76fec6ORenSDfc8uYYi/FoQYBbYZo8ywpHS2sGtz
         sZFmb+ft1Rg+XTFTT3ItEyu53hijmISVQ9QJxw/frss6ZdJwhPNZaRgF5azmTjB/O5sG
         kmtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=5ZO2ElXGMMwApl/ZmLhQFUcHmK3CxaaCCzXn5YZAuEQ=;
        b=FUum+ag9msajbgwE8c0YMrhqAnp2fKXfkiEAa7u2gL/uMLxBNSB+SBeGzz+XgJUldW
         kuYV5TY5rjlwpm2w6ODtB3ySyIOp5eFurkpiZeeQjrVOrUv1P9SMXSmDNcSHI4jt4xps
         dKhpuCuSAMDZT95dCgBmCVTG+0EJbmvE+XGIlF+vTC7nMiEZF/fJDfJHuCg1r9O8oyUl
         cKFUlyddy6MMfsYT4AIoX4Ic+cPKwL6N0oiEkU5sxlqFXElYoWIks+A82Oi0uS61AgD0
         kj4skhU8kHwAwzwYf6KIqzENOf026q5RlRz0wjoZ7m7rl5v/7lfQ16HpEe2YKZGDuOBp
         /z7w==
X-Gm-Message-State: AOAM530BJlYsAUgVk78imQQguC8TmaPyGwRH3Dt3L5HTXk9YLOlDZIcl
        05Ul0B7rx0LCJwy/q1zZ6cxcKLgSlzw=
X-Google-Smtp-Source: ABdhPJz8/sxbLhnWP+Sxzv0bLjRqwNVVo0FNhE25xq2oSmNyVJ8GCa4TczdH/tDjQCLtCyH+aPOQIA==
X-Received: by 2002:a17:90a:1ce:: with SMTP id 14mr8972810pjd.209.1602172450127;
        Thu, 08 Oct 2020 08:54:10 -0700 (PDT)
Received: from localhost.localdomain ([180.70.143.152])
        by smtp.gmail.com with ESMTPSA id f1sm5917929pjh.20.2020.10.08.08.54.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 08:54:09 -0700 (PDT)
From:   Taehee Yoo <ap420073@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ap420073@gmail.com, linux-wireless@vger.kernel.org,
        wil6210@qti.qualcomm.com, b43-dev@lists.infradead.org,
        linux-bluetooth@vger.kernel.org
Subject: [PATCH net 035/117] wl12xx: set DEBUGFS_FWSTATS_FILE_ARRAY.owner to THIS_MODULE
Date:   Thu,  8 Oct 2020 15:50:47 +0000
Message-Id: <20201008155209.18025-35-ap420073@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201008155209.18025-1-ap420073@gmail.com>
References: <20201008155209.18025-1-ap420073@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

If THIS_MODULE is not set, the module would be removed while debugfs is
being used.
It eventually makes kernel panic.

Fixes: 2f01a1f58889 ("wl12xx: add driver")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
---
 drivers/net/wireless/ti/wl1251/debugfs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ti/wl1251/debugfs.c b/drivers/net/wireless/ti/wl1251/debugfs.c
index d48746e640cc..0b09ffec9027 100644
--- a/drivers/net/wireless/ti/wl1251/debugfs.c
+++ b/drivers/net/wireless/ti/wl1251/debugfs.c
@@ -35,6 +35,7 @@ static const struct file_operations name## _ops = {			\
 	.read = name## _read,						\
 	.open = simple_open,						\
 	.llseek	= generic_file_llseek,					\
+	.owner = THIS_MODULE,						\
 };
 
 #define DEBUGFS_ADD(name, parent)					\
-- 
2.17.1

