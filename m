Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21B4B444EAC
	for <lists+netdev@lfdr.de>; Thu,  4 Nov 2021 07:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbhKDGQ6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 02:16:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229994AbhKDGQ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Nov 2021 02:16:57 -0400
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D264FC061714;
        Wed,  3 Nov 2021 23:14:19 -0700 (PDT)
Received: by mail-pl1-x636.google.com with SMTP id s24so5633506plp.0;
        Wed, 03 Nov 2021 23:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CY0g4bler+redJ2KBxth7Hep1EHLAUy4HJiTBP93euQ=;
        b=TLADRbDEwJMELEE5PRnFFOR0GmsRkvuI9eTwDfiwKSvjbApsHtjg6qPmAM/N/OyTLB
         vnKMWV2IlVfFBbgA0AulJs4I3qJJhjnf1AQeMlHEadNSDv1gHiTGEFP9ApepPbivyArv
         081EHncKrikTKfMp0AubA/snl2q/mjeJzB5vviLbeGtSjs5oVt74v++TiX8nmqNIrEYc
         ZlAjkvs4ZMc0XuXQGDWFj42W5qxxzJJCWm9pND67MEYIc/uiM5KpjcesD82Vtp4BehVY
         0YUX5CXTMw563Fdd6ZTcXYLOoqJQYAQfojxV2kl4wGhNjWk4+VDAbawRmRJU4+valNZ4
         116g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=CY0g4bler+redJ2KBxth7Hep1EHLAUy4HJiTBP93euQ=;
        b=zvjBCzlm8mLbtLz95XAI3CLjNo2Hcb3xT899fDv2ZA5zSi3JYh6G9WtteUt7gVcH8S
         fUXx2osRm0b8G+HhSdIJYaPgZ49+RGsE3kaNHuzVqM9hcteVMOMwOKuJwUhIgXMZTPpW
         xFprBPOKZ1l8SKz/PiEfmuf5kEbg9/pP3OsbROpc8kZYiuX9I2ZCoqmi+ZEUicn3yF8X
         RydBjdTR34Nf18e+QWRquV6UvSPvzwONQ51UCbgqhxolfNw1ZsIK0Wd6LmAeVoSH8KuH
         58rLanh5/eUr8cvQHkvIB65Q1cpuaxJXEBn5sbD22YJfFJoa+PK+lRbCBJLlsxxV6uJL
         QZwQ==
X-Gm-Message-State: AOAM533LlsyNpX/vvnfR6rPhtNOGOaz06GiAS5b16HtJSEnkxMs+ZRdJ
        uCmFaCE7srRZY3g6iFjSHIM=
X-Google-Smtp-Source: ABdhPJx+n5bvNcg2GHxRzhM+4VzxoL0ifwYnNMCzkEOD29PyVMAaGBLR4vEabpypiksyW4I348UMCQ==
X-Received: by 2002:a17:90b:33d0:: with SMTP id lk16mr15661261pjb.66.1636006459401;
        Wed, 03 Nov 2021 23:14:19 -0700 (PDT)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id fw21sm6588312pjb.25.2021.11.03.23.14.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Nov 2021 23:14:19 -0700 (PDT)
From:   cgel.zte@gmail.com
X-Google-Original-From: luo.penghao@zte.com.cn
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, luo penghao <luo.penghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH linux-next] mac80211: Remove unused assignment statements
Date:   Thu,  4 Nov 2021 06:14:11 +0000
Message-Id: <20211104061411.1744-1-luo.penghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: luo penghao <luo.penghao@zte.com.cn>

The assignment of these three local variables in the file will not
be used in the corresponding functions, so they should be deleted.

The clang_analyzer complains as follows:

net/mac80211/wpa.c:689:2 warning:
net/mac80211/wpa.c:883:2 warning:
net/mac80211/wpa.c:452:2 warning:

Value stored to 'hdr' is never read

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: luo penghao <luo.penghao@zte.com.cn>
---
 net/mac80211/wpa.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/net/mac80211/wpa.c b/net/mac80211/wpa.c
index 4eed23e..7ed0d26 100644
--- a/net/mac80211/wpa.c
+++ b/net/mac80211/wpa.c
@@ -449,7 +449,6 @@ static int ccmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb,
 	    (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE))
 		return 0;
 
-	hdr = (struct ieee80211_hdr *) pos;
 	pos += hdrlen;
 
 	pn64 = atomic64_inc_return(&key->conf.tx_pn);
@@ -686,7 +685,6 @@ static int gcmp_encrypt_skb(struct ieee80211_tx_data *tx, struct sk_buff *skb)
 	    (info->control.hw_key->flags & IEEE80211_KEY_FLAG_PUT_IV_SPACE))
 		return 0;
 
-	hdr = (struct ieee80211_hdr *)pos;
 	pos += hdrlen;
 
 	pn64 = atomic64_inc_return(&key->conf.tx_pn);
@@ -881,8 +879,6 @@ ieee80211_crypto_cs_decrypt(struct ieee80211_rx_data *rx)
 	if (skb_linearize(rx->skb))
 		return RX_DROP_UNUSABLE;
 
-	hdr = (struct ieee80211_hdr *)rx->skb->data;
-
 	rx_pn = key->u.gen.rx_pn[qos_tid];
 	skb_pn = rx->skb->data + hdrlen + cs->pn_off;
 
-- 
2.15.2


