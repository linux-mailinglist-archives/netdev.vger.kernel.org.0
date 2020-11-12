Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0980A2B062C
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728242AbgKLNUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728219AbgKLNUJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:20:09 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D6CC0613D1
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:07 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id c9so5233762wml.5
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=1EvnHF8fJtxX0TvIRevhCbYRdcfG85M/ScXKW761pZc=;
        b=UlKfMiMkOGEGNZogzeC2joDgluOiMtaAKYZlbLR89inDce3Y2gmRzUDP6cATJW6rik
         yJi37oJWC8h0dmq5PmaPrHP/j4w7FBozQtvEi5jTt1yX7Z+1EcZbAou78CciHQAbfaid
         eWYtsROUDZao8rm4Kpy+o/1rfO6WLhZay8uLC9lvRiixueauO6xI7EF+fi4M/b+Kd7n/
         gwnf1w0L3Mmksa29walXzQR5t0/yCu2Sa+yh3ZKiVnfT8EppB3DXaVh7gZMzOqprPy0K
         LhcWxqEHzao6mX15IC8JcjUvRoiZUIrm0Vu0ZQpG4yqpl+uLT3Ft5Gczz6jAwUn0d9cs
         gAsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=1EvnHF8fJtxX0TvIRevhCbYRdcfG85M/ScXKW761pZc=;
        b=uO3UbiKroAZ/hQ6ytnPlvNAjnm604BLrcjmheUJ8Ue3o81THRXyGFCQ4HCnKkurzv+
         pnQy1luzYM2ja7uwekuAbGvcQ3p4D9dXrUX3pBhHy/SCGefvcXzlbrsYW+OmON8emKRP
         qkhJIxgkhWWKCa8sDrtchnsl1AJCeJRPGd26Y8zOhtRPotWX9/0iudsBSJh5I0wFXlRe
         rQUj9ZQUoTu+PdQTa38C5xoe8x0bIM3clA7J3Ir+HoITL3EJLgW699I/ZlV1oVemsE6a
         Ozp7moN8/vCqv2mYiswou2zxAzahrTBONyTjFtERc5Y91OMgMnqM7NYZPcSNVKRn+Dh4
         RhFw==
X-Gm-Message-State: AOAM531TwBI2uwzVvnIeKVX9rBWIRpeR0O6KWLYQsEqL4EmpeBUh0Xlp
        XJsCRvAGAzuttRjzM0gpEMiO2w==
X-Google-Smtp-Source: ABdhPJyAbNw54rZ5sKbQTYvSpBDpkfMWvOWBElV+daUrnbBIKx42dx1uFwwk5hOuGumsR8Sx+2h9Rw==
X-Received: by 2002:a7b:c925:: with SMTP id h5mr9598763wml.5.1605187206038;
        Thu, 12 Nov 2020 05:20:06 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id t136sm2806326wmt.18.2020.11.12.05.20.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 05:20:05 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 2/6] staging: net: wimax: i2400m: driver: Demote some non-conformant kernel-docs, fix others
Date:   Thu, 12 Nov 2020 13:19:55 +0000
Message-Id: <20201112131959.2213841-3-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112131959.2213841-1-lee.jones@linaro.org>
References: <20201112131959.2213841-1-lee.jones@linaro.org>
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

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: devel@driverdev.osuosl.org
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

