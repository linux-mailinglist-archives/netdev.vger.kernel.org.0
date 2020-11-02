Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E3AC2A29B8
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:46:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728655AbgKBLpw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:45:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728607AbgKBLp1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:45:27 -0500
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32465C061A47
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:45:27 -0800 (PST)
Received: by mail-wr1-x444.google.com with SMTP id n15so14255786wrq.2
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:45:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=UI9R8pRGKqPSITi9y8opWbYC7XAAhjSoyXUvokLORX4=;
        b=mEp+m8Xhrz9N/YGJLRO6c2twOaJT24f6qd/l+oej5MSobh+oZAOjuxMu4Zzij0Nqil
         HOrcMHfUNHdNECZzN0b7YtsAoBeyyfzGO07oOZTKWy/Io0RWtagh+VLSh9bie5qgQTx+
         6jsT+jCNOnLVWXz/Kc2BxjCtrh2Qo8pE2S2sQd2VVqewC7fD2HYroG/27m/nQ4TYImgX
         sNLGwV4ObpMpmu+mbVhZI1x+z20A3G/mJosGd51gxmJwavGSfArCGiR6Gwwvy6NXUaAL
         Y6bQNfXLujT/YtCoVVcKP56AnwUTpQXy1h45KQ22HtqNfXSvzIs6Pie9t09yVi8aBxwK
         kneA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=UI9R8pRGKqPSITi9y8opWbYC7XAAhjSoyXUvokLORX4=;
        b=QbUxWeE+/1EvmP7xzomqJCiKZBqk33MctXQJI5OHfxOdcR0FN1qesfFvNxQDUX7FgH
         ip0T3nWI5orHVf1pTq+tjwK5xHcBiL5QUQktJpEzJ8qBVNdaKQB0wqcOU+aSYXSudD8u
         SFgQYHbtkO3kqMj8f6ZNUtRIWnFmplZ7qV0letbhCh6VQvuK1qCtXsmx59SizOLhS5R3
         eNRrhhz7EvGYa9OV4e6tpVWw8qcNEY3+6J27WgGdSOyWs9GdKSNAihpHD36oZMEjRFUh
         9N+zRtohAhud0Df2rtDvVI9TZnQYHCYEPZqvbRbm6bMwPxird2uUV5uw2KDQiOSLdKBf
         TYJw==
X-Gm-Message-State: AOAM530rAvx6bu+/bmbUzhjrUdbwQnO3Rn0unn/1Vrc7hbjCEzbPXjIe
        gtwSbWfm4A4Q8ktezb5Dku8b9w==
X-Google-Smtp-Source: ABdhPJzLCe0UVqCjxOxtF46/ekMeCDXDavB+LsuZEq0PQMFxWtAJOdlBewan7+tdB3iwhNknzTT8WQ==
X-Received: by 2002:a5d:4001:: with SMTP id n1mr20203003wrp.426.1604317525943;
        Mon, 02 Nov 2020 03:45:25 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id g66sm15545352wmg.37.2020.11.02.03.45.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:45:25 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net
Cc:     Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org
Subject: [PATCH 04/30] net: wimax: i2400m: control: Fix some misspellings in i2400m_set_init_config()'s docs
Date:   Mon,  2 Nov 2020 11:44:46 +0000
Message-Id: <20201102114512.1062724-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102114512.1062724-1-lee.jones@linaro.org>
References: <20201102114512.1062724-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wimax/i2400m/control.c:1195: warning: Function parameter or member 'arg' not described in 'i2400m_set_init_config'
 drivers/net/wimax/i2400m/control.c:1195: warning: Excess function parameter 'arg_size' description in 'i2400m_set_init_config'

Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/staging/wimax/i2400m/control.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wimax/i2400m/control.c b/drivers/staging/wimax/i2400m/control.c
index fe885aa56cf37..1e270b2101e86 100644
--- a/drivers/staging/wimax/i2400m/control.c
+++ b/drivers/staging/wimax/i2400m/control.c
@@ -1183,11 +1183,11 @@ static int i2400m_cmd_get_state(struct i2400m *i2400m)
  * Set basic configuration settings
  *
  * @i2400m: device descriptor
- * @args: array of pointers to the TLV headers to send for
+ * @arg: array of pointers to the TLV headers to send for
  *     configuration (each followed by its payload).
  *     TLV headers and payloads must be properly initialized, with the
  *     right endianess (LE).
- * @arg_size: number of pointers in the @args array
+ * @args: number of pointers in the @arg array
  */
 static int i2400m_set_init_config(struct i2400m *i2400m,
 				  const struct i2400m_tlv_hdr **arg,
-- 
2.25.1

