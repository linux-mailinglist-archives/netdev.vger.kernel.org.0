Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E68E12B0629
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 14:20:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728201AbgKLNUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 08:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727993AbgKLNUF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 Nov 2020 08:20:05 -0500
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74B14C0613D6
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:05 -0800 (PST)
Received: by mail-wm1-x344.google.com with SMTP id p19so6164457wmg.0
        for <netdev@vger.kernel.org>; Thu, 12 Nov 2020 05:20:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8jk6HVNhRUeEoNSWaOGwYJftWHgUEkFSpcCabqTm85s=;
        b=sYfuYLr/GzDr2sN/zXiJloI1wO0uWu41b9GLLElDCpwpM7Zwt/WM1IxysnWMk1jIwZ
         1hMmGzs7IMj+ipZ2lwITHkFGIyrmiHMOIy8aIX6LOo32DuiZZOZ+vJ0JDAWjAEWs6cUb
         FCJYW0Sw2sx5qDJjlXNig5xR7y+dMVX2DaRtkcicQ7QHb1gOW1OT47pxmzuAmwVoPgcK
         9HhL77b7olhyPPl5kKPS0Y+x4Dvs9hI4+IuhVuUD7G/Xxxr+U3BZsjRBDIx3TMQptyA7
         kAW0jNeuYY+O4h/f3And5Obfdr6uCoZRpePi4s/0EWp8kA2kvl9rGObE/sArQAqjlhp1
         1sLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8jk6HVNhRUeEoNSWaOGwYJftWHgUEkFSpcCabqTm85s=;
        b=SLOhhaEeZFz7HaMRKTwVSJEr/whW4LfCOJSoRBH8x6W9FQDZlsyR4ZO2GDz7uHQCWf
         Q5JazeUra317mZWD7MBO0dSyDaHz9vXUsLxyicx/JJtFR8AoIDwam9S82Lpfr39P2VKV
         PZrYshKuLEUeeR22Dj62P4fCxnjAx8hi+n5CST+fJnIuo0UJfutcjjfOkBC59iJHMbSa
         p7SDolGxJNcYwnQFc+z18zhYQ4D4QT8gUFPQ6FdF0f0D2WJn18Fz5QTHlEtE/aV5JtCj
         yVbgFNSG1cIMsexJ9uZNGGV139+nC6PYEyChjbM8WE3EPI5lPZnHm6dS32Ss0QNqhR5j
         zT7g==
X-Gm-Message-State: AOAM530PUAhiSKR1raLnxL702+lCebiS13lDKQxserRWH/iuqAKpJaT+
        Gl2bwMtH3npmjskDXOBJOU05OA==
X-Google-Smtp-Source: ABdhPJwLen6p98hcdn8uIN3ZeTDNPnMc6HQiolBj9ioiwahX9Vbjkh/wrjF9eDHn8Xo4EuMGJudwSw==
X-Received: by 2002:a1c:c203:: with SMTP id s3mr9791779wmf.77.1605187204118;
        Thu, 12 Nov 2020 05:20:04 -0800 (PST)
Received: from dell.default ([91.110.221.159])
        by smtp.gmail.com with ESMTPSA id t136sm2806326wmt.18.2020.11.12.05.20.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Nov 2020 05:20:03 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        linux-wimax@intel.com, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org
Subject: [PATCH 1/6] staging: net: wimax: i2400m: control: Fix some misspellings in i2400m_set_init_config()'s docs
Date:   Thu, 12 Nov 2020 13:19:54 +0000
Message-Id: <20201112131959.2213841-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201112131959.2213841-1-lee.jones@linaro.org>
References: <20201112131959.2213841-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wimax/i2400m/control.c:1195: warning: Function parameter or member 'arg' not described in 'i2400m_set_init_config'
 drivers/net/wimax/i2400m/control.c:1195: warning: Excess function parameter 'arg_size' description in 'i2400m_set_init_config'

Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>
Cc: linux-wimax@intel.com
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org
Cc: devel@driverdev.osuosl.org
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

