Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 881D719C3D6
	for <lists+netdev@lfdr.de>; Thu,  2 Apr 2020 16:21:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387854AbgDBOSG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Apr 2020 10:18:06 -0400
Received: from mail-pf1-f195.google.com ([209.85.210.195]:40490 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733195AbgDBOSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Apr 2020 10:18:05 -0400
Received: by mail-pf1-f195.google.com with SMTP id c20so1813126pfi.7;
        Thu, 02 Apr 2020 07:18:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=sV9tqvN+vUsyclDdwQsodCiDkYsbUmI0zD+TvEKC7qc=;
        b=q8n6vkBIA8dUONiHy5uZswo71uL9A604LdVul9lHMn41yd5Xl1Jzvj/PQf6kq8Fdi3
         deRNP+evO0vErW2JdOHESfh4oCrIzS7X+Or/Ryl6ada27/8kV+00c62o36YVmNm3bXAh
         niUJKP78LuRxoXbZyJKvSiv8+O+J7rN0ZlcV58yUSf5J0Ri54PXHO8aglrSGbfTwJGNH
         mCB6C7CTQpA1WHsbiT7wK/drP5IxUUyEU+cWICUE00vvv8HwdZjNosrg47VEPp8idvRK
         tYBNGKqpvz+D+IQCU4wX++r+x4iKBXyp0t0izDX1ETCzZ2NMtdusDzQBbXw103jza8Vo
         RuHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=sV9tqvN+vUsyclDdwQsodCiDkYsbUmI0zD+TvEKC7qc=;
        b=CY7tkgf3JQFT6vn2QfYkS0ySgGuCom7TGHBSAOgKGii2Yld2Ut0g/9yijMchQ4RX/P
         xstm8LGRJofFF1uz88TccSlOYlqxmOmYHQ1P/b5ieWHGl6J/YHDTYo4yKyhamyiXnjmt
         2DBmSiZz2BWFHI3NvHJxVNtDBC4cOAaRjtG2sUSMGrUTZ/y+aIzB5VhJDzlOiE0IWFpi
         lcJAgD+CyITmLIyYsxwF+tNlG4oZaxB7VRDs1iUnI7gpwYWhBn7W2nCH3V80r2s4PsYM
         5NehSSDh8cRzm0TvF5r9yenHMW2KgydHgD63+f2IlyqNxsXP9nKgj1wkh6i/+g1ExDWE
         91Bw==
X-Gm-Message-State: AGi0PubqGn3S08VASMm8y/AuFKQUL0i3beEjDz7YsIMLK4X0kyMUrJsG
        h4BraBmSp564RB5/lIWoBjJl4/7X
X-Google-Smtp-Source: APiQypKzNpovHvEBeYUUJnNJcVcgCL02kvy3XkA8JBR55L1Xtym3V6pWuaeOTyojCvb39rlyVeyYow==
X-Received: by 2002:a63:29c1:: with SMTP id p184mr3613563pgp.37.1585837084468;
        Thu, 02 Apr 2020 07:18:04 -0700 (PDT)
Received: from VM_0_35_centos.localdomain ([150.109.62.251])
        by smtp.gmail.com with ESMTPSA id r63sm3887237pfr.42.2020.04.02.07.18.02
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 02 Apr 2020 07:18:03 -0700 (PDT)
From:   Qiujun Huang <hqjagain@gmail.com>
To:     amitkarwar@gmail.com, siva8118@gmail.com, kvalo@codeaurora.org
Cc:     davem@davemloft.net, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Qiujun Huang <hqjagain@gmail.com>
Subject: [PATCH] rsi: fix a typo "throld" -> "threshold"
Date:   Thu,  2 Apr 2020 22:17:58 +0800
Message-Id: <1585837078-6149-1-git-send-email-hqjagain@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

There is a typo in debug message. Fix it.
s/throld/threshold

Signed-off-by: Qiujun Huang <hqjagain@gmail.com>
---
 drivers/net/wireless/rsi/rsi_91x_mac80211.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_91x_mac80211.c b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
index 4400882..5c0adb0 100644
--- a/drivers/net/wireless/rsi/rsi_91x_mac80211.c
+++ b/drivers/net/wireless/rsi/rsi_91x_mac80211.c
@@ -832,7 +832,7 @@ static void rsi_mac80211_bss_info_changed(struct ieee80211_hw *hw,
 		common->cqm_info.last_cqm_event_rssi = 0;
 		common->cqm_info.rssi_thold = bss_conf->cqm_rssi_thold;
 		common->cqm_info.rssi_hyst = bss_conf->cqm_rssi_hyst;
-		rsi_dbg(INFO_ZONE, "RSSI throld & hysteresis are: %d %d\n",
+		rsi_dbg(INFO_ZONE, "RSSI threshold & hysteresis are: %d %d\n",
 			common->cqm_info.rssi_thold,
 			common->cqm_info.rssi_hyst);
 	}
-- 
1.8.3.1

