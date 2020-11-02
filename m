Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 602932A2972
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 12:29:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728628AbgKBLY2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 06:24:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728592AbgKBLYY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 06:24:24 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 259CEC061A49
        for <netdev@vger.kernel.org>; Mon,  2 Nov 2020 03:24:24 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id e2so9131201wme.1
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 03:24:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=qoHya8gK4WxyN5m7VBMHjfaE3l8Bb6XYk+L0IrwzimU=;
        b=vN7FgK7AgZxvJn6YeBi+P0ktCCfAvqWEQCoVJbdaEPsNdE13QY7S6BlEfbaS0fEltG
         f+r45txAK9RrlAbrSqby3atEOPYqHElzC+0c3YgCRrRmZOXCdFHHzyxCtOcclBAZwMqP
         PaObsX5RsPWYbe2Ak5ToZl2uAH1vIjFasEvv+2ka4Pby17tNAr8WbwZC0AC1Oy+wKLX0
         lwl2TZ/J/0JTNLJlsgcnOdryqmKt1uiqsxCddZdhmhzFJAXtlvYgynCmy/ekRkpl7Wdo
         aaGV538zdcV0sJUcP25b63XiLtpuomauPIXBNf+bDnnYTnPLEdKuleRdnDag9ChGih7/
         spKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=qoHya8gK4WxyN5m7VBMHjfaE3l8Bb6XYk+L0IrwzimU=;
        b=jSqXHNfFEVfxZVMWzgS9DJlgS8qJ2OJaQ5k0RTH7269Mi4e6UmYUT8U4VPdxt7kIb9
         Bxvbsa8zWFu8iN6rwWb6NEut4wzigUVQXFUsK/CBBE327fWskfrUoMuLQ0dIlIh5a+09
         jxT0q/l40xZMf7165b9ykHKmMpXEB1mSXjzk/Qhp7Xfc7kbYUIj9BYgmcRSC5B8C99gX
         vtUCUQFLotRUJY9btOsuLFsu8FxZlNc3Dg/oYrlP4RczWcUieABb8W/xQ4L74TEoo8Sk
         upA+frW8huTQhrOSFpyHfsJlpkw4loyVMpqcRedk18XNvnkWRVxRRU3u7Iduo0OxBLDI
         +cPw==
X-Gm-Message-State: AOAM530EoZFcWoQgghgQuPmth3u3Pjx1AZTxBSl1OX/8iTHP68QpJwb+
        jW6eBRIDSyvUI4imvSuYnbU4Ow==
X-Google-Smtp-Source: ABdhPJx6mTU49MwUqogLkMZY5uvxzgmA/bh5y1uIt3JqqILR6MRKRw+wUZnjf7tSRd0Tb2fAAkhcjA==
X-Received: by 2002:a1c:3503:: with SMTP id c3mr16872354wma.43.1604316262903;
        Mon, 02 Nov 2020 03:24:22 -0800 (PST)
Received: from dell.default ([91.110.221.242])
        by smtp.gmail.com with ESMTPSA id m14sm21867354wro.43.2020.11.02.03.24.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 03:24:22 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 04/41] rsi_91x_usb_ops: Source file headers are not good candidates for kernel-doc
Date:   Mon,  2 Nov 2020 11:23:33 +0000
Message-Id: <20201102112410.1049272-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201102112410.1049272-1-lee.jones@linaro.org>
References: <20201102112410.1049272-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/rsi/rsi_91x_usb_ops.c:22: warning: Incorrect use of kernel-doc format:  * rsi_usb_rx_thread() - This is a kernel thread to receive the packets from
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c:29: warning: Function parameter or member 'common' not described in 'rsi_usb_rx_thread'

Cc: Amitkumar Karwar <amitkarwar@gmail.com>
Cc: Siva Rebbagondla <siva8118@gmail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/rsi/rsi_91x_usb_ops.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
index b1687d22f73f5..4ffcdde1acb1e 100644
--- a/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
+++ b/drivers/net/wireless/rsi/rsi_91x_usb_ops.c
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
-- 
2.25.1

