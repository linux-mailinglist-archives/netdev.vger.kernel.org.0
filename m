Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65BCE252A4B
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:37:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728376AbgHZJh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:37:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728360AbgHZJfG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:35:06 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6B8C06134D
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:33 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id o21so1081439wmc.0
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=B4E9cSfXHfJFsjO894WOptYPwQ5/EooDFGNjs8a9MbA=;
        b=r726au1UQ7kMPGArZ786mhNfI/fKyc+1LUzeKJihwwMlnchKe/lERgKWP64vUe1I1Y
         Y0gkWO+MPKS9vCVA2CQ+NstGLZ63RejpdbctRvfT/O7Br7lKyGN2whD+FK7eGP6I0w0u
         Sq6lNnWp4FSZ8OzaKrEziBms5T7UgFNJ3+KNg8l3iN7zNMfgcCvZIckv1RLy+/1a1foE
         zfbyQo4Ui+txno8sEohJnzczCJrpoaoIp4z/btaJoG/G/DCpeSfEQdE9xuNW5GrxPtxv
         UwaPGRS5aS9vlfJLt/8F40AvQeYwr5xL+xXX9FEUqRWEatyULgQBmdICjlGQjsnkwmQb
         632w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=B4E9cSfXHfJFsjO894WOptYPwQ5/EooDFGNjs8a9MbA=;
        b=nXa8zvieNWriczTRsdljRPfAHYtAd+bqvmg3YRoM5nGV7teneH9BdrBU0wT2UoqSAd
         qq31DEcHql7zSa1RikQ8jUvvxwNzLNvf4ywbEec/OHrjYPpNnU+oEDma9VS/IbMZ7Chm
         AHpNWAVww3IwLecmZIn4dE6/ynt9sDPaIf2uftcsgXKL73bgGQi56VdbBX3Pvth33wPR
         SakEkwyeOzzIBiWV6qUGj91kWP+SVRhkY/HJHn0AD/C8jYg9wfdWNSVXd7bpfNusJMaT
         9orUT+7ytcVwYuW/dLIIMkXVRWcwqD890LEIYRP5YnwR+FBTabYgBp+QjW0OZ6FN1o4M
         oLkw==
X-Gm-Message-State: AOAM530L6MZahrsb/opqxniymb6NFNXomIwlRAM6H6NqT/W++lkVC2/W
        GlBso844skAXNR4/IG1QDRReAA==
X-Google-Smtp-Source: ABdhPJyBLvA6umNRRhVN3ftfM9O0qrl1SQRnCExSXd25zEos5hTnBsQI0+4oZ30F+EHrD5r3+cToow==
X-Received: by 2002:a1c:e4c3:: with SMTP id b186mr6112239wmh.84.1598434471957;
        Wed, 26 Aug 2020 02:34:31 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:31 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 22/30] wireless: rsi: rsi_91x_sdio_ops: File headers are not good kernel-doc candidates
Date:   Wed, 26 Aug 2020 10:33:53 +0100
Message-Id: <20200826093401.1458456-23-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c:24: warning: Incorrect use of kernel-doc format:  * rsi_sdio_master_access_msword() - This function sets the AHB master access
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c:32: warning: Function parameter or member 'adapter' not described in 'rsi_sdio_master_access_msword'
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c:32: warning: Function parameter or member 'ms_word' not described in 'rsi_sdio_master_access_msword'

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/rsi/rsi_91x_sdio_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
index 449f6d23c5e36..7825c9a889d36 100644
--- a/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_sdio_ops.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.25.1

