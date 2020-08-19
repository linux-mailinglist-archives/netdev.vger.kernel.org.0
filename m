Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E4B0249718
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:24:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727079AbgHSHY0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:24:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726847AbgHSHYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:24:11 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C2B6C06134A
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:10 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id 184so1132004wmb.0
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XaDsSQHVumJ0BUhRTLnjnxnZZONxfiwBrtcxIjkBvh8=;
        b=ziVC/1++Ib88HqfjC3EoHwZGANIpB5jltCZO3nejpCxFeZFY0hEcY9Rt2NkQSgdj4w
         PScZGLSd1YxB9ZlcmgCF6H2voYIxHDd/cvXl3p0RUyBKEHyZvS5kVcOs7ge3aHRXm8k7
         kQe/RrcbOkv1rNeVoVs0Jm6ikRmWm6Gq88oOD1EaPK32bd5MNp6c9EL/5HiGb6/moAqu
         s6PEHHYVzxtJ6ic0sJujck1COtO3EM2AzExF1cilJnPAMr/W40eYKkFsj0ylk2Rfwg4f
         IdlDdqLky+c7ikhRKVfrIoZb1zB0PoDadbiSonR6JWz9mOz9orQIcK/f1FJyLzfm5WPv
         pZHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XaDsSQHVumJ0BUhRTLnjnxnZZONxfiwBrtcxIjkBvh8=;
        b=YR19TduJ6pG96L0F/WSTEb8QST5ga0C+szEjqMWGHR3IxqxNoe6Cl3W4tNG+RMpVCR
         D871iMiRHtbCf6XOYmSTDBcKm0LwSqTy+cAJeEwlt6AYRW2H2EmDVhUN5Pasct7nNde3
         1jDgttUq4behR30+btne6AHoPMzqzyLsh2+irZttOdGtkySkG3jeWnjKm1qUkt5tuGKh
         zhj39Ghde1ybpiAJfZPTAH6ufbrDmDmC0bG/qwXQt5Adb+hwl8vjI8/dMFhVWWPA0Pej
         oWCExf0gGoLfSP87eaibutaDvg93ypXaCUoBZtzt0j13NWVki3uhur/0samArZwstHEk
         xUJA==
X-Gm-Message-State: AOAM530HGwmFt9RUw7PFpamiv38T5uO+V0hZjRv22wdG4Q1CbGLuwVnd
        sI9BFI8MQwwMC3lCXmV7UUloqw==
X-Google-Smtp-Source: ABdhPJzjydxh5RW2AnV46iOp6h8091Mjz/MKc4QW6Xm7U6kw+aXK8DwN977c9dsDaoTBL5nabk1SUA==
X-Received: by 2002:a7b:c1c2:: with SMTP id a2mr3452861wmj.74.1597821848883;
        Wed, 19 Aug 2020 00:24:08 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:08 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 03/28] wireless: rsi_91x_core: File header should not be kernel-doc
Date:   Wed, 19 Aug 2020 08:23:37 +0100
Message-Id: <20200819072402.3085022-4-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/rsi/rsi_91x_core.c:23: warning: Incorrect use of kernel-doc format:  * rsi_determine_min_weight_queue() - This function determines the queue with
 drivers/net/wireless/rsi/rsi_91x_core.c:30: warning: Function parameter or member 'common' not described in 'rsi_determine_min_weight_queue'

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/rsi/rsi_91x_core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_core.c b/drivers/net/wireless/rsi/rsi_91x_core.c
index 3644d7d994638..2d49c5b5eefb4 100644
--- a/drivers/net/wireless/rsi/rsi_91x_core.c
+++ b/drivers/net/wireless/rsi/rsi_91x_core.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.25.1

