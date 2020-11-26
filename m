Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8EAA92C559D
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 14:35:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390234AbgKZNcH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 08:32:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390162AbgKZNcF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 08:32:05 -0500
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47D3C061A48
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:03 -0800 (PST)
Received: by mail-wr1-x441.google.com with SMTP id i2so2158207wrs.4
        for <netdev@vger.kernel.org>; Thu, 26 Nov 2020 05:32:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+vFZOkUefLCl7nJCk+wo/i30e9zgv5BRI5+nbv5AY5Q=;
        b=kjVrW8dhiO8nZ52TeUAv9+gDBak/v52Pu4Jx7mojNyf/YW4ukLxMS81piFZUzkjm8U
         IDUSfX430q01/MpPLislyS6R3lSNeyE8dKk7wYA69rH+T+JFkps+XUA4JEw+BhX24SY0
         Kzob0dGLZsEiEZq4ZPMJCLt9VyY6etSnfvwBJElAznIPXmBwn4h+fpzGyjGBvfuM+FT9
         JbqtrS5QGq019isdVJgoT0GsdzJsf/SvSWXeTdqi0LX+QGOhapAgkXfJTSC9M6ipuUDb
         KR7y+Dcv1NV3fQsG4zumxkGKSjRuE/XcF3fTVK9mir/IKGn1bW/h8f03h9FxyN6Gpcpb
         QoPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+vFZOkUefLCl7nJCk+wo/i30e9zgv5BRI5+nbv5AY5Q=;
        b=ZFi+Hz7L7vyt7fLIkSS0LO505dHR35r8wy+1dO2QqkPh3dZlOwvd/wNfnH5nW8fZ47
         i2ROBendYiz6I6vidEQ6Lh7lvhNYZC4lmlAp2P0uDqjJNHC+2apbXQ4BADPbA/vNlRqo
         36B1sCxAZUgAwx5pXDOcX7G297EAnOzJYQ7f6sCB9uQ8WLUp502A7efjbRlpshUFRCrE
         ndm5sbIS2U6+Ure3aO8WhPvPFPY5EgdQmegdaNV/PTnHRdeAKzbhCMbgoYlO1MJMwYL+
         n9u/8zOOLv6wYgJekcag50B4cCrv7GE9XnyRau+R7indXXnfx+MZAAzzZUMi3y0YrZ7m
         rdlg==
X-Gm-Message-State: AOAM5307WP2WGR04cw5oyTeGSzliAE7eTSlaCTC0WnTCgmdeVwftbrnx
        7un6Yywoy+2LmTbn0IoEcx+kiG7+nCFTM9yV
X-Google-Smtp-Source: ABdhPJzc142GrUm38WbUb+V8FN+5I7D047T9oeIlEft7/95j5iqGh5CGV/eDsji1tke2f7iX62RrFQ==
X-Received: by 2002:a5d:654b:: with SMTP id z11mr3804664wrv.291.1606397522484;
        Thu, 26 Nov 2020 05:32:02 -0800 (PST)
Received: from dell.default ([91.110.221.235])
        by smtp.gmail.com with ESMTPSA id n10sm8701001wrv.77.2020.11.26.05.32.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2020 05:32:01 -0800 (PST)
From:   Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org, kvalo@codeaurora.org
Cc:     linux-kernel@vger.kernel.org,
        QCA ath9k Development <ath9k-devel@qca.qualcomm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Subject: [PATCH 05/17] ath9k: ar9485_initvals: Remove unused const variable 'ar9485_fast_clock_1_1_baseband_postamble'
Date:   Thu, 26 Nov 2020 13:31:40 +0000
Message-Id: <20201126133152.3211309-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201126133152.3211309-1-lee.jones@linaro.org>
References: <20201126133152.3211309-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/ath9k/ar9485_initvals.h:1009:18: warning: ‘ar9485_fast_clock_1_1_baseband_postamble’ defined but not used [-Wunused-const-variable=]

Cc: QCA ath9k Development <ath9k-devel@qca.qualcomm.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/ath9k/ar9485_initvals.h | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
index bdf6f107f6f1e..4afe52c0456e9 100644
--- a/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
+++ b/drivers/net/wireless/ath/ath9k/ar9485_initvals.h
@@ -1006,13 +1006,6 @@ static const u32 ar9485_1_1_soc_preamble[][2] = {
 	{0x00007048, 0x00000002},
 };
 
-static const u32 ar9485_fast_clock_1_1_baseband_postamble[][3] = {
-	/* Addr      5G_HT20     5G_HT40   */
-	{0x00009e00, 0x03721821, 0x03721821},
-	{0x0000a230, 0x0000400b, 0x00004016},
-	{0x0000a254, 0x00000898, 0x00001130},
-};
-
 static const u32 ar9485_1_1_baseband_postamble[][5] = {
 	/* Addr      5G_HT20     5G_HT40     2G_HT40     2G_HT20   */
 	{0x00009810, 0xd00a8005, 0xd00a8005, 0xd00a8005, 0xd00a8005},
-- 
2.25.1

