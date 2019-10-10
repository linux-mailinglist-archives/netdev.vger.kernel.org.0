Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B5A67D3007
	for <lists+netdev@lfdr.de>; Thu, 10 Oct 2019 20:13:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726924AbfJJSNW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 14:13:22 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:40241 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726387AbfJJSNV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 14:13:21 -0400
Received: by mail-qk1-f196.google.com with SMTP id y144so6462497qkb.7;
        Thu, 10 Oct 2019 11:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=nhEdCojs+IGVHVpYHr8vIlo3+XqeHqDkpO3pbb3i3gY=;
        b=veUad5m3bEuSV9Tg6KGXINcNmU+w/q4ZRAHY1SoCHi3kqvf2fEsPmUiSSyz1WiK0sm
         MuJxOy41RWthtBX4qEKlqFLzIL0OEJFOa1TPvXQo8LRbrWGz4IqdZ5wM2egeeHCsqnyX
         dQju1Q1M+o44QpktDAbkkJipGQTPnj7l/PEpByJ2/3+Zk6OLjKy2U+Cc5L3D3MRCQ4+4
         s6mtRoIoBHmK7ZvAJ8evyYm0xxZ1p+IPwfstjgxrfNqCJhPrbb243jT6TOwWc3RA89LL
         AENNW1g/0fyR8H/7rVxY6GQH+zQwmXsTrj7m276ohY3dgkg7+gbQvP63XVs010HQbQDC
         eedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=nhEdCojs+IGVHVpYHr8vIlo3+XqeHqDkpO3pbb3i3gY=;
        b=sj+eWuaJN38U3GOUr/eq+oDudap6BECvbNbK/wJeUlLMJFe0vx4BqV2lFpz3WEJds8
         lOGUPJ4sXKliDug8Wq3i6Ohy0e9WoJVYIJrjfKMa/DzwBN38JmQL8Jz0U4AIeHlRwDFp
         51J/MaHHiy5nu88K1jk9D7Qk6p3DjiNzaweg6JuSlonMq7U7lSNCIJKjVuNe276ecVEr
         xljEVm7bXyzSmxsp65LizHnix4rGGDmzQP8t0Rh35Wrdy/Vf8dFwJ4OwbF8Hx1LUTV2U
         SZhsLGjOosu92ZpQ1T7WV0S+ZQaZgbzSSgCVQOz9ACjY8qTbpxBVEqPTrDW5ns2FZDts
         KKgg==
X-Gm-Message-State: APjAAAVLsBBrE9L4dY0lxUDrdeEWpTvnSvgrcV4PYMWkNGnV57KWGTHt
        vVglA11n/TOOWoGhMGm69ZARw/cx7WY=
X-Google-Smtp-Source: APXvYqwSekl87KP1FWqb1bGCMEhBPT7rz8TJ+HdVIXkSH7Sop42boPG7YIqvxAwlbveQPKGoRRuOUg==
X-Received: by 2002:a37:278f:: with SMTP id n137mr10874754qkn.423.1570731198638;
        Thu, 10 Oct 2019 11:13:18 -0700 (PDT)
Received: from alpha-Inspiron-5480.lan ([170.84.225.105])
        by smtp.gmail.com with ESMTPSA id 60sm2967275qta.77.2019.10.10.11.13.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Oct 2019 11:13:17 -0700 (PDT)
From:   Ramon Fontes <ramonreisfontes@gmail.com>
To:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Cc:     johannes@sipsolutions.net, kvalo@codeaurora.org,
        davem@davemloft.net, Ramon Fontes <ramonreisfontes@gmail.com>
Subject: [PATCH 2/2] mac80211_hwsim: adding support for OCB
Date:   Thu, 10 Oct 2019 15:13:07 -0300
Message-Id: <20191010181307.11821-2-ramonreisfontes@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20191010181307.11821-1-ramonreisfontes@gmail.com>
References: <20191010181307.11821-1-ramonreisfontes@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

OCB (Outside the Context of a BSS) interfaces are necessary for the IEEE 802.11p standard

Signed-off-by: Ramon Fontes <ramonreisfontes@gmail.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index c20103792..ae41b05e7 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1570,7 +1570,8 @@ static void mac80211_hwsim_beacon_tx(void *arg, u8 *mac,
 
 	if (vif->type != NL80211_IFTYPE_AP &&
 	    vif->type != NL80211_IFTYPE_MESH_POINT &&
-	    vif->type != NL80211_IFTYPE_ADHOC)
+	    vif->type != NL80211_IFTYPE_ADHOC &&
+	    vif->type != NL80211_IFTYPE_OCB)
 		return;
 
 	skb = ieee80211_beacon_get(hw, vif);
@@ -2745,7 +2746,8 @@ static void mac80211_hwsim_he_capab(struct ieee80211_supported_band *sband)
 	 BIT(NL80211_IFTYPE_P2P_CLIENT) | \
 	 BIT(NL80211_IFTYPE_P2P_GO) | \
 	 BIT(NL80211_IFTYPE_ADHOC) | \
-	 BIT(NL80211_IFTYPE_MESH_POINT))
+	 BIT(NL80211_IFTYPE_MESH_POINT) | \
+	 BIT(NL80211_IFTYPE_OCB))
 
 static int mac80211_hwsim_new_radio(struct genl_info *info,
 				    struct hwsim_new_radio_params *param)
-- 
2.17.1

