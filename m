Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0875C244929
	for <lists+netdev@lfdr.de>; Fri, 14 Aug 2020 13:44:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727986AbgHNLoF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Aug 2020 07:44:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728060AbgHNLjy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Aug 2020 07:39:54 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01A16C061386
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:54 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id r4so8041107wrx.9
        for <netdev@vger.kernel.org>; Fri, 14 Aug 2020 04:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3CIaL9kwctZltECceeOkMasHCAXmIM+a/cYObSy4ff4=;
        b=MmCFyrglks64su5tIBCIBbKp02c/3IxLmE2VWCQNGkN+nu7SA1AiyusR5q/f41X9pW
         cArMJ9rMffav9+UF5+u7lq5rZtTrZI0W0KMBmWTMsb605BjYmW7sXr1A/dYMJz6vrUla
         4dPxEAssYLx9/SKjKI/9sDVekVpdNLwgmiDVb4EuYYeoqBAlV8aT7rWGGynALuJzeBiT
         i0JGOrO1Nj9aWClAcmFhvE9J59UF3SnDGDhv8TBukXzNiCGCYcU4DmNn3BL1Ddob1D8F
         oRZm0lzH6JcJ/d4JALvBoF0iSnyuXaRQrGgzSY7zWqspHBA7fRAw1rfVdUWcyoqfZAth
         mUoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3CIaL9kwctZltECceeOkMasHCAXmIM+a/cYObSy4ff4=;
        b=Ey0nsW8oovEFGdwDeM803T9rP8mmfcYRaI4KAzqr8GL7i+BJWKlWY4bcjv5/vfSu+G
         YqTCSTs6OsF/62JCnqFozZ0NQxGeu7SqFK0AxjS0GPzEE6uta5iv+0wer7mNrrpUs2Bg
         ijKTBlwOrDHZgwj1Zc7W5ilBcPcyizOyHHedcLgecpAEqVtwPt17RIP+IRZaua0o8Z5p
         Ao5MvOTHhlLuvtlMJ+hKfQ7o4w6a4TxmgrqATxrdCZvLvX1Jvo4iGsDNCKCOV9G3LR3g
         V1BoaRfPyuCzqJRshak/EXN5CoAbx4S2/NlX2gPo8cTWrSfla4qMAJobXMkO2Owgm61h
         K0kA==
X-Gm-Message-State: AOAM5305L0EFScxY9Wyl7/J3hkZSu06aRigpnWZYmLI91qFL71ouBmKY
        2uUW0Kwj2OYJpcHc7Zz2niawRLfaAsYd7g==
X-Google-Smtp-Source: ABdhPJwYYxsy14mnQDgzv7nCyt5+IIP2KulipeI/kMbK+FmmiJ08CPwhxf+74vWSEAWVYyOnNQnyfw==
X-Received: by 2002:a5d:4b0c:: with SMTP id v12mr2338935wrq.199.1597405192700;
        Fri, 14 Aug 2020 04:39:52 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id 32sm16409129wrh.18.2020.08.14.04.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2020 04:39:52 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 08/30] net: wireless: ath: carl9170: Mark 'ar9170_qmap' as __maybe_unused
Date:   Fri, 14 Aug 2020 12:39:11 +0100
Message-Id: <20200814113933.1903438-9-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200814113933.1903438-1-lee.jones@linaro.org>
References: <20200814113933.1903438-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

'ar9170_qmap' is used in some source files which include carl9170.h,
but not all of them.  Mark it as __maybe_unused to show that this is
not only okay, it's expected.

Fixes the following W=1 kernel build warning(s)

 from drivers/net/wireless/ath/carl9170/carl9170.h:57,
 In file included from drivers/net/wireless/ath/carl9170/carl9170.h:57,
 drivers/net/wireless/ath/carl9170/carl9170.h:71:17: warning: ‘ar9170_qmap’ defined but not used [-Wunused-const-variable=]

 NB: Snipped - lots of these repeat

Cc: Christian Lamparter <chunkeey@googlemail.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/carl9170/carl9170.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/carl9170/carl9170.h b/drivers/net/wireless/ath/carl9170/carl9170.h
index 237d0cda1bcb0..9d86253081bce 100644
--- a/drivers/net/wireless/ath/carl9170/carl9170.h
+++ b/drivers/net/wireless/ath/carl9170/carl9170.h
@@ -68,7 +68,7 @@
 
 #define PAYLOAD_MAX	(CARL9170_MAX_CMD_LEN / 4 - 1)
 
-static const u8 ar9170_qmap[__AR9170_NUM_TXQ] = { 3, 2, 1, 0 };
+static const u8 __maybe_unused ar9170_qmap[__AR9170_NUM_TXQ] = { 3, 2, 1, 0 };
 
 #define CARL9170_MAX_RX_BUFFER_SIZE		8192
 
-- 
2.25.1

