Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC9E1D5675
	for <lists+netdev@lfdr.de>; Fri, 15 May 2020 18:47:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726367AbgEOQqt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 12:46:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726171AbgEOQqs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 12:46:48 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCB4BC061A0C;
        Fri, 15 May 2020 09:46:48 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id 4so2503837qtb.4;
        Fri, 15 May 2020 09:46:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lhyrD7fgcAIDzketu+eiu4fOBdbGHW2Sbb4y7tusfjc=;
        b=ciiFFIfJa2m5ZMcG1Egga+yCC0p/qlLtMIDWP5VpB+mIrZHz4n6taU/dk2jphDQ81e
         WCcDaCCgBCWIvvHLuwsQdEFJ8pHS1EOXPM5Lf6VNpf2b224OJ6d23un0Zigl79hN/BUU
         CpRSCOvP+yZyZ4PCU4xcV8z95vYxJukoRcI6AJVsmxCWhirZtiLVYVnKu8KDQeeC4mgs
         yuCOQ8dbRZGOdesKQmO7Q6/GKdTUbCw5XTxxJtZ51tU2/RZqGoQPsgiwZp/229BEjZJ2
         7rIy0CHojmbbJBiPijyme0lplBYyNdlxoqHPW6Lj6EZR4xcHyubFmI3+VxV50mc5hSw/
         vSGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=lhyrD7fgcAIDzketu+eiu4fOBdbGHW2Sbb4y7tusfjc=;
        b=U3g0bVcElHQHkZp3B0yewhs0ycCrQ1V+I6o+RPm7eTiMAWnoZhki/wEwAw2oO71nZu
         CKdCTET2fqrO39uXl/Yx/Rg4Zu0QAC9EtppAz9V1TqYCNGLclbMABtczmuPH8AwAionJ
         dabnXmD7Aw0sE7ZX7tsqLLZ3CvCqjQ/oPnGHYXMHYJrWY6cQ6SxFd9tqIoeZ/0vpG2Di
         P0VVOWaMOfIZujNW37ceGBSxiK8UDFvNSzgXWPdMSP8D9RxTXy4h9ErY8w5zJwUQ+6xp
         STlLHLSd0/b7gNIeEUZ8inN6jANca/gyXpJ0nM4tQxZIvYZe4sqBwzDG++CHyB42loeE
         aKqg==
X-Gm-Message-State: AOAM533fPXYVRyrjo5cNnEYL+ilTJD/AOeLnphRH1+QqfvADzL3BDmjt
        RPD/YAVoPGjiqXIj/lobGbZBtbM9vwY=
X-Google-Smtp-Source: ABdhPJwpwHs3AHa06mvPBXiioFkqQ+A/KU8cTdGp2lopcCxfDXqA5koTGvbygFwLoeRwS7qhmrLCCw==
X-Received: by 2002:ac8:7619:: with SMTP id t25mr4431652qtq.130.1589561207503;
        Fri, 15 May 2020 09:46:47 -0700 (PDT)
Received: from alpha-Inspiron-5480.lan ([170.84.225.240])
        by smtp.gmail.com with ESMTPSA id g20sm1918530qki.75.2020.05.15.09.46.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 May 2020 09:46:46 -0700 (PDT)
From:   Ramon Fontes <ramonreisfontes@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, Ramon Fontes <ramonreisfontes@gmail.com>
Subject: [PATCH] mac80211_hwsim: report the WIPHY_FLAG_SUPPORTS_5_10_MHZ capability
Date:   Fri, 15 May 2020 13:46:40 -0300
Message-Id: <20200515164640.97276-1-ramonreisfontes@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index 0528d4cb4..67f97ac36 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -2995,6 +2995,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
 	hw->wiphy->flags |= WIPHY_FLAG_SUPPORTS_TDLS |
 			    WIPHY_FLAG_HAS_REMAIN_ON_CHANNEL |
 			    WIPHY_FLAG_AP_UAPSD |
+                            WIPHY_FLAG_SUPPORTS_5_10_MHZ |
 			    WIPHY_FLAG_HAS_CHANNEL_SWITCH;
 	hw->wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR |
 			       NL80211_FEATURE_AP_MODE_CHAN_WIDTH_CHANGE |
-- 
2.25.1

