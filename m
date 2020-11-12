Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 733122B0637
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728218AbgKLNU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:20:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728298AbgKLNUO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:20:14 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAAD3C061A04
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:12 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id s8so5946288wrw.10
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8bT6NBr573z4dRmUGzdy7vOSo0LG9hQOBgI7J9L19n0=;
        b=mgsPSO4Vv1I0HLl+/EpK+bO64s6O30aHTiVXWSNkXtrWiKVu0TONIobdV8BewmbFoU
         gmKhJSfyHbxWuLsrWBbzord4ktUmXpF/JfK8W7GPrkQpwdmHOCV99d8/+u7G6rslcGi4
         T7UW3lD2hbNoZmZOzUqmApvnILA+G/TnMnWP9S6Fb06hjZ+dXQJLn9aSiGrAPx5fGakG
         W8pK1mZW+Frwk+3qur8oKSxcbaZ9gHPuCo6A+OdWIrnZZab8C+2zIpftvjynOTmNKUNw
         JwbYgaKPc/iqYVbpiSRhuVSUKBDzj1++R3rOQjwnVHgJo4nJXLSIHVdqHdgJiPjH6K/o
         DZBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8bT6NBr573z4dRmUGzdy7vOSo0LG9hQOBgI7J9L19n0=;
        b=hSfjOzhbwrb9oQZYPUCu6M/psn1QEyVGfoPkz8FCypBlMjYshQ1YZnMrSxTU4FV1qN
         bHVEpyaXZtcbx+sWMUkG0L/UCjGf/hK/viN/9srac44X6Ixr+pJvsBmg9m5DWkbEcamO
         rasbJoJXsslBHSC4E1eWF8oWYYYdCNNIGP1ntyiyWsBvzNvBMoAnbOybW15W1fVOw71Q
         WOoEHTrlSW+vRxwskPm+YKTbRvs8Z6qAMwIqnF0QCY/0w4BjXUFomouTJl+dmgkdBSjI
         vvvL7yZvMV0b8GjoiX0V7jqNzRMJU5i7tAucKCJfZsWJfFOpjqVZ+mZlTOBluN6XDHod
         xYPA==
X-Gm-Message-State: AOAM5305cSl8gWW6F5YuQhIAXf924VO2CHCeQecwEe+f9Z2utFF79cdS
        3fta63qe8HPMw/aMdOyok31Ggg==
X-Google-Smtp-Source: ABdhPJyI+2L0X57vYtQloasVb3OMTpYuD6fawy7Bq6HwXGcJSYZ6xpBDXg1Jb9tIfoXKnZ4Ww4pnvw==
X-Received: by 2002:adf:ebcb:: with SMTP id v11mr35129463wrn.408.1605187211647;
        Thu, 12 Nov 2020 05:20:11 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id t136sm2806326wmt.18.2020.11.12.05.20.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 05:20:11 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Yanir Lubetkin <yanirx.lubetkin@intel.com>,
        netdev@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 6/6] staging: net: wimax: i2400m: fw: Fix incorrectly spelt function parameter in documentation
Date:   Thu, 12 Nov 2020 13:19:59 +0000
Message-Id: <20201112131959.2213841-7-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112131959.2213841-1-lee.jones@linaro.org>
References: <20201112131959.2213841-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wimax/i2400m/fw.c:647: warning: Function parameter or member '__chunk_len' not described in 'i2400m_download_chunk'
 drivers/net/wimax/i2400m/fw.c:647: warning: Excess function parameter 'chunk_len' description in 'i2400m_download_chunk'

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Yanir Lubetkin <yanirx.lubetkin@intel.com>
Cc: netdev@vger.kernel.org
Cc: devel@driverdev.osuosl.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/staging/wimax/i2400m/fw.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wimax/i2400m/fw.c b/drivers/staging/wimax/i2400m/fw.c
index 9970857063374..edb5eba0898b0 100644
--- a/drivers/staging/wimax/i2400m/fw.c
+++ b/drivers/staging/wimax/i2400m/fw.c
@@ -636,7 +636,7 @@ ssize_t i2400m_bm_cmd(struct i2400m *i2400m,
  *
  * @i2400m: device descriptor
  * @chunk: the buffer to write
- * @chunk_len: length of the buffer to write
+ * @__chunk_len: length of the buffer to write
  * @addr: address in the device memory space
  * @direct: bootrom write mode
  * @do_csum: should a checksum validation be performed
-- 
2.25.1

