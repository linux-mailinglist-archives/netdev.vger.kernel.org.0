Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B634D252A21
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 11:34:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728358AbgHZJe4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Aug 2020 05:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728273AbgHZJe2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Aug 2020 05:34:28 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA54FC0617BD
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:17 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id w13so1094868wrk.5
        for <netdev@vger.kernel.org>; Wed, 26 Aug 2020 02:34:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hbQ7t0QGJIX1BQrFfjs1A3AU9N9ket4sk5RytzzLdJE=;
        b=PRSz0KINW/7dL8S4WUZCQfxd14f4YMJbSkBmMHyG1/sQbxmgJbiocMe/T8daglorDC
         82MT3w5DXKs4BUDFZ9bXUh2OUgS2NbldfNZvjCgcUdBicoWPOyzI/BFV/5DDflpTHbRK
         zLv56uyXsO0Ewpl/da6nT0Q2P9XMWgRjvzZ0TO4soBXqTnfOGdxr2CYpFowLMwj7bInj
         rwmedvcZrOsJxhEwALwPT+KAXfokSNPEFhCOM6Mpzo+OlkIKxmpu5wGDQ9HIa79SyM6B
         evqqzzuLy045QKid+uDUpQSB8Z+5R8GVMJnXM3r1J20fJjwx3uros9QGhioEqP0eQmiE
         eJOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hbQ7t0QGJIX1BQrFfjs1A3AU9N9ket4sk5RytzzLdJE=;
        b=nOtF7jnULZHhPvtFrG8D6g1y4G4yShVBoVZLwU6PobRh2GxUR6AJTx4b3JtrNoB9y3
         P2xwatyvDlMVshFrW6OBIuAvKWo7IZdTxgtd6PgDMJB15R4dQrvPSx+QVQloBFNuF+ng
         YFI6cmHv0SxIboBxwBNKLZed+UawfvQKALpE8YSTETiLilyAizw0NoOJ8uU5ZEBsR/6h
         qDb3WcVVyq8d+RN0arCcYqWH9S13fEjRq17t15hactml7Wyahiqb6ItqM7f2Y1y+gL+a
         hjpXIMnXLRUJbmoQ83eRIn9+eQkUZz9kK8x/yQ0heLK5Gs1KVG2/SmOp7wXpJcmwo+QP
         QtPg==
X-Gm-Message-State: AOAM533i8MF8wtXiQcQKlgDiMu0Zb/I7+pKG5tHgSIQTl4yrU2V3xtHg
        0s1hMMdaoxpeebl/SD4j9mSW6w==
X-Google-Smtp-Source: ABdhPJyojt+ahgae3vKUeH/4QLEhz8Ub210s3VTJowaHOeDDKiO30miza1Ko42Y4aau/f4Uin3GtRQ==
X-Received: by 2002:adf:e781:: with SMTP id n1mr4587780wrm.195.1598434456444;
        Wed, 26 Aug 2020 02:34:16 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id u3sm3978759wml.44.2020.08.26.02.34.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2020 02:34:15 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Daniel Drake <dsd@gentoo.org>,
        Ulrich Kunitz <kune@deine-taler.de>
Subject: [PATCH 09/30] wireless: zydas: zd1211rw: zd_chip: Fix formatting
Date:   Wed, 26 Aug 2020 10:33:40 +0100
Message-Id: <20200826093401.1458456-10-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200826093401.1458456-1-lee.jones@linaro.org>
References: <20200826093401.1458456-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kerneldoc expects attributes/parameters to be in '@*.: ' format and
gets confused if the variable does not follow the type/attribute
definitions.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1385: warning: Function parameter or member 'rx_frame' not described in 'zd_rx_rate'
 drivers/net/wireless/zydas/zd1211rw/zd_chip.c:1385: warning: Function parameter or member 'status' not described in 'zd_rx_rate'

Cc: Daniel Drake <dsd@gentoo.org>
Cc: Ulrich Kunitz <kune@deine-taler.de>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/zydas/zd1211rw/zd_chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_chip.c b/drivers/net/wireless/zydas/zd1211rw/zd_chip.c
index 0af4b1986e487..0216b1583b48b 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_chip.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_chip.c
@@ -1375,8 +1375,8 @@ static inline u8 zd_rate_from_ofdm_plcp_header(const void *rx_frame)
 
 /**
  * zd_rx_rate - report zd-rate
- * @rx_frame - received frame
- * @rx_status - rx_status as given by the device
+ * @rx_frame: received frame
+ * @rx_status: rx_status as given by the device
  *
  * This function converts the rate as encoded in the received packet to the
  * zd-rate, we are using on other places in the driver.
-- 
2.25.1

