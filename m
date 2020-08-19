Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72BFE249734
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728208AbgHSH1K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:27:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728054AbgHSH0J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:26:09 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6557FC0612EC
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:35 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id t14so1120679wmi.3
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bBzEfUvbe/jRxzO40K//jsXnpXNEErVa5XTqzMamXvQ=;
        b=ZPoMu5Mnjwjb2haLK/vWqa5/tiSHCy/nDwn5iNOZzCWhgKIwRtvzNmPbfgsLA9mSCg
         zRsT6Dl3A9atOt/5phe5ubnK5JMjdzGrA9GilbM4MIWx0166QKyIhojxdypPKC0V5VDK
         ZnHPLtq4hiYgQpqPWykjq7DJjbaoLzs6L0cejAK7tQXF8sxNxm0iuYv7Nd5EYpxeEDOw
         RUaCF1WLEKZeRwSl8QLaQmUP5olDYJQF4zxPVdACZYfdP6T2oZBQsW3yHRvpA7zVcJGA
         Z+xgsDSv/moQJLnT66JMqJgQB0tQMC3JT8GO+kBXgvwGJ4Ol5gE7zRGJOHjC5RGCSU6z
         qE8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bBzEfUvbe/jRxzO40K//jsXnpXNEErVa5XTqzMamXvQ=;
        b=mbpxWyoe69Co62+i4uY2N4d0ZjEuc8FP35/14lGh+AmsVKLjYHk591UmdJ6QtBpph1
         LTvS/Dqa8GMmkCGAKm883NklgYnZK18mYWzP7g2rY6eoBFkSTchp+i9RA1Cz40x2OWla
         gdHhtQ5YXpAirNKOjFodbcpPtSI58+cRI3+e78gaqrR1tyYokLW36Y1Ibx9FFA/eYHNq
         K2H3IGa/jYtEQqSxpMe1qCfm1xo0CaxYjmUwTFrXnEWFz7cmra+sPpZRhSWqBRdXnuFa
         crwGd+8S+nTXO8kPpWzYyEi4fFSPiqElfhxiTaaymqU6xJDu+UIfJzj17gmZeT7oaVbz
         afug==
X-Gm-Message-State: AOAM530mxTq8s7NaO28OP72jJaI3d7HtDX5/sHNJHy8uzL5ZvyD7EGP7
        paqbmawC6o2uidZbohepFI3oXw==
X-Google-Smtp-Source: ABdhPJzJQETs3WOG9GwjxbvsGTLFleTEdZEW9PtH52FjwBnrRIrjVmDc7IjdsZMb1v2iOUU/ZscM1w==
X-Received: by 2002:a7b:cf08:: with SMTP id l8mr3322744wmg.183.1597821874070;
        Wed, 19 Aug 2020 00:24:34 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:33 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>
Subject: [PATCH 23/28] wireless: rsi: rsi_91x_hal: File header comments should not be kernel-doc
Date:   Wed, 19 Aug 2020 08:23:57 +0100
Message-Id: <20200819072402.3085022-24-lee.jones@linaro.org>
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

 drivers/net/wireless/rsi/rsi_91x_hal.c:25: warning: cannot understand function prototype: 'struct ta_metadata metadata_flash_content[] = '

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/rsi/rsi_91x_hal.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_hal.c b/drivers/net/wireless/rsi/rsi_91x_hal.c
index 6f8d5f9a9f7e6..3f7e3cfb6f00d 100644
--- a/drivers/net/wireless/rsi/rsi_91x_hal.c
+++ b/drivers/net/wireless/rsi/rsi_91x_hal.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.25.1

