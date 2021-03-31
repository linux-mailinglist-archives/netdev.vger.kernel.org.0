Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8772D34F5B2
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 03:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232833AbhCaBFA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 21:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232515AbhCaBE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Mar 2021 21:04:27 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2913C061762;
        Tue, 30 Mar 2021 18:04:26 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id q10so1784041pgj.2;
        Tue, 30 Mar 2021 18:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Cw+n4U/6CuqjVQ7Ah/i4LdMbvq6CKAxMhOesJ1eXa5k=;
        b=UYzqeKaG4A+MhdUDxCOwpipIB6gP5lcD6dPIXWrk7LR4yiFz0The2AqPJ5zn0yc4IG
         o6KLa+dyUJxSIWCw5z0NoVx5CFZT/pux23pHMeydNVuf24K6XE+Eft31MYuuURvvpdoV
         leYnCnqZO1nXef9gKCqc+K++vgl3wChTmkA80x+ZzwKnMdnit2AcCi4PQVZYfdofrvtL
         6PYq61kmLMg9wraYUSnmYe75WmdhVrwG1NqrM6AX8VAS4kbB3S60N7IoXTAZglaGlPRL
         b64X8jKVib7KhFVQxk78LunsYbey36FCF7kYoUNn6FCliHDgQVNMbf0FbgzjSUrgZBvD
         q2HQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Cw+n4U/6CuqjVQ7Ah/i4LdMbvq6CKAxMhOesJ1eXa5k=;
        b=gzXCU+vmBMRGy8ec5qWRx9kBUwkk4iui6CJZhkc5Tsy9BHrJcxVLczwrfCRGt1IT2Q
         JZVKmwDmsuyLH6bn9jb+slWyH8DQ/BxZvccZ9m8e98bL5KLjum804sfUxtzZ/s8fR/RW
         Ah5dQnhYrGrgLsWVw6yvoijB7zVIKQJxPVh6FiDpkI794zEagusD/0OSTHnepDjzbd61
         49YQ4YgolxYk2YY79lBK0Ihry0qqpylLtn3M5BiNg2TogLX/Tdh5K1q5nPUg0yBHRswJ
         Xy9f7OQOADnkO0WcQo6mWfE54adyiSg7dsXxnd7uGAg2BB0GS508NvEOMLBw203y5QJC
         gIWw==
X-Gm-Message-State: AOAM5316uueowXlNlnzfoU5WHqL7tBIqTmqNOmY7e+QSGwe+66/FyW6K
        n0Gw/+sy8vfPfgh2/jJ5BJM04wk3tg1z9tKZ
X-Google-Smtp-Source: ABdhPJxPs8THNo3ImdsxQ3hb/RVgq3PlJoRet+ebdmrNfiMhr7e7NpvjPEVXwXfEiSkqChSeL3QzMQ==
X-Received: by 2002:a63:4f56:: with SMTP id p22mr802790pgl.224.1617152666341;
        Tue, 30 Mar 2021 18:04:26 -0700 (PDT)
Received: from localhost.localdomain (123-192-91-35.dynamic.kbronet.com.tw. [123.192.91.35])
        by smtp.gmail.com with ESMTPSA id q19sm215070pff.91.2021.03.30.18.04.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Mar 2021 18:04:25 -0700 (PDT)
From:   Eric Lin <dslin1010@gmail.com>
To:     romieu@fr.zoreil.com, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Cc:     gustavoars@kernel.org
Subject: [PATCH 2/2] net: wireless: Fix typo of 'Networks' in comment
Date:   Wed, 31 Mar 2021 09:04:18 +0800
Message-Id: <20210331010418.1632816-2-dslin1010@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210331010418.1632816-1-dslin1010@gmail.com>
References: <20210331010418.1632816-1-dslin1010@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Eric Lin <dslin1010@gmail.com>
Reported-by: Gustavo A. R. Silva <gustavoars@kernel.org>
---
 drivers/net/wireless/wl3501.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/wl3501.h b/drivers/net/wireless/wl3501.h
index e98e04ee9a2c..5779ffbe5d0f 100644
--- a/drivers/net/wireless/wl3501.h
+++ b/drivers/net/wireless/wl3501.h
@@ -240,7 +240,7 @@ struct iw_mgmt_essid_pset {
 } __packed;
 
 /*
- * According to 802.11 Wireless Netowors, the definitive guide - O'Reilly
+ * According to 802.11 Wireless Networks, the definitive guide - O'Reilly
  * Pg 75
  */ 
 #define IW_DATA_RATE_MAX_LABELS 8
-- 
2.25.1

