Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30B202A29E9
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:49:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728852AbgKBLsy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728610AbgKBLpa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:30 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48BC8C061A48
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:28 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id g12so14188530wrp.10
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=S8vpnZmXz9iLnkLUB3C6XR52IXLaRp3UFxZH+gyvs48=;
        b=Isl9bk4BepGjbjN2Gsn8Amc0qbhI3yVqYtwyU13dln8QhJx46A+HtaRtz8cef2AqIg
         jqwcA06LcgAd03VDbCjuWcosIbL27KVy6ElOVejAn4DIHU5NDfuV0u7J/u5oDjpD+5fI
         apB69q5qusne9jhbuWe/6KItNRgQ6eXMj4VZJ+kEoS7u0OIflKpeZGXfSyc04ZrUYnUB
         7BDrLFUjOMMgiIXjpLQhXHhSTVfd19q9TzBehpXveYyoxhQbmsiixu29i+yBekWABtst
         7Ic8apkazKDrGzryyoeqJ+Snh2XfzBoEFtiLxishAjYdyFE+WuBTI101PcsPH5GcX/gL
         Gj1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=S8vpnZmXz9iLnkLUB3C6XR52IXLaRp3UFxZH+gyvs48=;
        b=ZyAlx5SVz7bgGhMNeE3trv/bs7DNtF97wyP4kW5Cc8u3+60ZDDOaoT51MCqqxGEMex
         kl/Sy17S+34XOOiKoaEhRD9P5Ll9ChX8zFLGDfC824Pto5vZY+QEpI0xrJzWHvI4qOMU
         FbSv0M8JG2HsA2zBNqTq4/k7Zzh942X54UV/QGlXl74SF+i/TAcC/zrAN4eqw1j7UuqF
         cM0RJkPkGA1yXa3FvFZdgh5a3tKuTwn27xAB69vbraUTOTI/6oWUSmfqcOZEUMgh7V0E
         9iwNJZsZW2AnKYjL6iWzXUil/md+L0YoyM3nn0TUpP4a9eVtSF5308+IVkNG5TYRf0b1
         CCeQ==
X-Gm-Message-State: AOAM532N1OaIfr/3pBtQ2h9gX3EYFTRLYPOxa3ISHR50ul/cQQFwBYlH
        WCcgH6EKNMmwMcwwwIdAJeCPEZu/2FHi0Q==
X-Google-Smtp-Source: ABdhPJwRTx0erMAvX+JBVQyr1LqvyNTp2cMUC+akvqWOQ0BhhuBie6CoqGiBGKIMRKrWphWdaTiWOA==
X-Received: by 2002:adf:fe48:: with SMTP id m8mr19495866wrs.127.1604317527059;
        Mon, 02 Nov 2020 03:45:27 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:26 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 05/30] net: wimax: i2400m: driver: Demote some non-conformant kernel-docs, fix others
Date:   Mon,  2 Nov 2020 11:44:47 +0000
Message-Id: <20201102114512.1062724-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wimax/i2400m/driver.c:681: warning: Function parameter or member 'i2400m' not described in 'i2400m_dev_reset_handle'
 drivers/net/wimax/i2400m/driver.c:681: warning: Function parameter or member 'reason' not described in 'i2400m_dev_reset_handle'
 drivers/net/wimax/i2400m/driver.c:775: warning: Function parameter or member 'i2400m' not described in 'i2400m_init'
 drivers/net/wimax/i2400m/driver.c:842: warning: Function parameter or member 'bm_flags' not described in 'i2400m_setup'
 drivers/net/wimax/i2400m/driver.c:942: warning: Function parameter or member 'i2400m' not described in 'i2400m_release'

Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/staging/wimax/i2400m/driver.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wimax/i2400m/driver.c b/drivers/staging/wimax/i2400m/driver.c
index dc8939ff78c0e..f5186458bb3d4 100644
--- a/drivers/staging/wimax/i2400m/driver.c
+++ b/drivers/staging/wimax/i2400m/driver.c
@@ -665,7 +665,7 @@ void __i2400m_dev_reset_handle(struct work_struct *ws)
 }
 
 
-/**
+/*
  * i2400m_dev_reset_handle - Handle a device's reset in a thread context
  *
  * Schedule a device reset handling out on a thread context, so it
@@ -685,7 +685,7 @@ int i2400m_dev_reset_handle(struct i2400m *i2400m, const char *reason)
 EXPORT_SYMBOL_GPL(i2400m_dev_reset_handle);
 
 
- /*
+/*
  * The actual work of error recovery.
  *
  * The current implementation of error recovery is to trigger a bus reset.
@@ -766,7 +766,7 @@ void i2400m_bm_buf_free(struct i2400m *i2400m)
 }
 
 
-/**
+/*
  * i2400m_init - Initialize a 'struct i2400m' from all zeroes
  *
  * This is a bus-generic API call.
@@ -831,6 +831,7 @@ EXPORT_SYMBOL_GPL(i2400m_reset);
  * i2400m_setup - bus-generic setup function for the i2400m device
  *
  * @i2400m: device descriptor (bus-specific parts have been initialized)
+ * @bm_flags: boot mode flags
  *
  * Returns: 0 if ok, < 0 errno code on error.
  *
@@ -933,7 +934,7 @@ int i2400m_setup(struct i2400m *i2400m, enum i2400m_bri bm_flags)
 EXPORT_SYMBOL_GPL(i2400m_setup);
 
 
-/**
+/*
  * i2400m_release - release the bus-generic driver resources
  *
  * Sends a disconnect message and undoes any setup done by i2400m_setup()
-- 
2.25.1

