Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 85EBC123C48
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 02:16:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbfLRBPz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Dec 2019 20:15:55 -0500
Received: from mail-ot1-f67.google.com ([209.85.210.67]:40816 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726227AbfLRBPz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Dec 2019 20:15:55 -0500
Received: by mail-ot1-f67.google.com with SMTP id i15so263739oto.7;
        Tue, 17 Dec 2019 17:15:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d+ndbyvc/xD98taLiNNXwi7PgRFqCDT7vLcEGC7qSs0=;
        b=klfD6ikoFcBcQTz83KNWoTyZ3DWEyEpYlYh420dAZkyObXgJYGu+A7bbLmBULVM/fr
         VOhKZJHI63y5oNRdCC81ooP6oIfGBAKtQGngys2D4isGSmUHJTQ50RYpWkbkZaKIy0Y3
         hBYpNUSesVnLVTCu1LR6I+2o6trC05hzbujAGHz7dxMMliEtiJcxSVCSRyj9d4NqhFjt
         o6NT2CtbLtj0o+ufN4mXKcBHhVYvNO4nqimaTBVsR+FzN4IDWlXYfJf1a09VxbgRAHlN
         OODXoNk+puIAM66JXIZ+Z9m0A9U96BRQUftCHn5EBVycPDFNw0XfetdlBfFuLXSEATEM
         ArZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=d+ndbyvc/xD98taLiNNXwi7PgRFqCDT7vLcEGC7qSs0=;
        b=QAHf1aYsC7kWaaA2aUicA2twbn0ukQnT50ChrCRDItvGsszx5MdbxgiPbWPdCk1i1t
         yhLVmAb0q52crfZJYsyEFkuHhIYq4rZwGH2PGhoZKeRoEnuzZVOAoOLeNZl5HPQ4V9pC
         jIgzCIqH6qCzn83mOsCix0hKwxJt/KYi2xCoqFrONpgDhssDMJBVp+40rUr6eR0TYQkG
         aUKqtIgf1GXv4vB3KjHbVeVxEgzjr8UbNNMw8AMy5jmrJP9DatHnKoOJfiaxOeDC5zD6
         MqX3WV79GBBMDHpitpRxairICJOE4NGuoJeN496Paq4BBdnBbDxAv/mB8bxD+UTDXeN6
         WpUQ==
X-Gm-Message-State: APjAAAVO29EfS/tFyAMwsOqicaPskI/Yc9dTJyks5ZPD4mgGH/er2DAp
        XdDKPMNvS6GoiqBuEP3X1eE=
X-Google-Smtp-Source: APXvYqxrNwmRwujD+Yy4djLv6WsgbcLhkN1LpMKWV/Q29CvujkUrnsk3sIX6i+0NCjpzzGU0irxPHw==
X-Received: by 2002:a05:6830:1e84:: with SMTP id n4mr115298otr.267.1576631754206;
        Tue, 17 Dec 2019 17:15:54 -0800 (PST)
Received: from localhost.localdomain ([2604:1380:4111:8b00::1])
        by smtp.gmail.com with ESMTPSA id w12sm186001otk.75.2019.12.17.17.15.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Dec 2019 17:15:53 -0800 (PST)
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com,
        Nathan Chancellor <natechancellor@gmail.com>
Subject: [PATCH] hostap: Adjust indentation in prism2_hostapd_add_sta
Date:   Tue, 17 Dec 2019 18:15:46 -0700
Message-Id: <20191218011545.40557-1-natechancellor@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
X-Patchwork-Bot: notify
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clang warns:

../drivers/net/wireless/intersil/hostap/hostap_ap.c:2511:3: warning:
misleading indentation; statement is not part of the previous 'if'
[-Wmisleading-indentation]
        if (sta->tx_supp_rates & WLAN_RATE_5M5)
        ^
../drivers/net/wireless/intersil/hostap/hostap_ap.c:2509:2: note:
previous statement is here
        if (sta->tx_supp_rates & WLAN_RATE_2M)
        ^
1 warning generated.

This warning occurs because there is a space before the tab on this
line. Remove it so that the indentation is consistent with the Linux
kernel coding style and clang no longer warns.

Fixes: ff1d2767d5a4 ("Add HostAP wireless driver.")
Link: https://github.com/ClangBuiltLinux/linux/issues/813
Signed-off-by: Nathan Chancellor <natechancellor@gmail.com>
---

Sorry for sending a patch for an "Obselete" driver (especially one as
trivial as this) but it is still a warning from clang and shows up on
all{yes,mod}config.

 drivers/net/wireless/intersil/hostap/hostap_ap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intersil/hostap/hostap_ap.c b/drivers/net/wireless/intersil/hostap/hostap_ap.c
index 0094b1d2b577..3ec46f48cfde 100644
--- a/drivers/net/wireless/intersil/hostap/hostap_ap.c
+++ b/drivers/net/wireless/intersil/hostap/hostap_ap.c
@@ -2508,7 +2508,7 @@ static int prism2_hostapd_add_sta(struct ap_data *ap,
 		sta->supported_rates[0] = 2;
 	if (sta->tx_supp_rates & WLAN_RATE_2M)
 		sta->supported_rates[1] = 4;
- 	if (sta->tx_supp_rates & WLAN_RATE_5M5)
+	if (sta->tx_supp_rates & WLAN_RATE_5M5)
 		sta->supported_rates[2] = 11;
 	if (sta->tx_supp_rates & WLAN_RATE_11M)
 		sta->supported_rates[3] = 22;
-- 
2.24.1

