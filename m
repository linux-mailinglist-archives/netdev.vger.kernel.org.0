Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF69B263DC7
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 08:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730150AbgIJG4s (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:56:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgIJGze (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:55:34 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40564C0617A1
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:54:59 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id m6so5450075wrn.0
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zkp7Qawe8Rxm7rdSdovVzLB4vK2dfikmYIjnToE95fQ=;
        b=g4Fdn7VI3qS/0gbKFqeDt0A+g/bA7MA6ER7mw9ftQp+3TrJ4Kw6f9kSDHIo1+/T0S+
         xx0yXKaOzIRtC/8JALHIt5XNd6sSbAG75GJJ5AgZnq1srmEA7SMAUw8r0k9phE1XHvqK
         Agoogui317QVrQ47SGp4msYMODcouLsg+23tBGV+EapWbavM0wqdmT9vED2x26EGVvNe
         FFYyi8U0PcnWPQr4bt49V+cI5ZXDZ4ZKUZoMXRGi8FUTszmmrnnzOoKy4BktSoYtMU3u
         sH8VMxHJOAZrxnlqFBDSx9P9U9g6GQjirr5x6rgSUY9nnehuO/2ItFtUgwG0DZ7RHsX3
         NPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zkp7Qawe8Rxm7rdSdovVzLB4vK2dfikmYIjnToE95fQ=;
        b=soEl4VMARqgKxGjKNo+VMAOccvcC3BvgFziC794wRIK8vgCYayKem41Hsz3pCUiISi
         sSxRYT/XKRlssupxuCJFob0yOYWR1FWbAy/3LEcuyfWHEEYn12kkw/AFJFVuD7ed+UhK
         CZVdXteOSiIvwpqSP5dhB0rVus6mTNZu8UR2SNUJI2wyr+g4FeoHbStvq/CTbglH0X+M
         d0KrnXwrE+JQC3hld2BnpTr0EyMAJAJOQNFszAegZGNUy6+zmY67LAa7klUetcD0Zx3Z
         x48mnTwX7DqvwjCdxQzQipOdSVr9TfEu6qiIUrgA5SylB/sVAtoAaKyOwQJ+5zZmm4FP
         Zl6Q==
X-Gm-Message-State: AOAM530GyI2YybT1+VUaZZmu1qGi4gHi4MaTMy8qwbp95adunnWbuZ4y
        ZrRFoc6uCdX1Kn4gi4gLKlLKtQ==
X-Google-Smtp-Source: ABdhPJyjOu6hXaydDo4atC4QK0jbmaE/9TXZntfJi0qvF6dUD2Zb7u35wQpvQTUIKuHeiPjC0Yztjg==
X-Received: by 2002:a5d:53d1:: with SMTP id a17mr7085295wrw.98.1599720897900;
        Wed, 09 Sep 2020 23:54:57 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.54.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:54:57 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 04/29] iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
Date:   Thu, 10 Sep 2020 07:54:06 +0100
Message-Id: <20200910065431.657636-5-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Neither of these headers attempt to document any function parameters.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/dvm/lib.c:121: warning: Function parameter or member 'priv' not described in 'iwlagn_txfifo_flush'
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c:121: warning: Function parameter or member 'scd_q_msk' not described in 'iwlagn_txfifo_flush'
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c:779: warning: Function parameter or member 'priv' not described in 'iwlagn_set_rxon_chain'
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c:779: warning: Function parameter or member 'ctx' not described in 'iwlagn_set_rxon_chain'

Cc: Johannes Berg <johannes.berg@intel.com>
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Cc: Luca Coelho <luciano.coelho@intel.com>
Cc: Intel Linux Wireless <linuxwifi@intel.com>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/intel/iwlwifi/dvm/lib.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
index eab94d2f46b1e..3b937a7dd4032 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/lib.c
@@ -110,7 +110,7 @@ int iwlagn_manage_ibss_station(struct iwl_priv *priv,
 				  vif->bss_conf.bssid);
 }
 
-/**
+/*
  * iwlagn_txfifo_flush: send REPLY_TXFIFO_FLUSH command to uCode
  *
  * pre-requirements:
@@ -769,7 +769,7 @@ static u8 iwl_count_chain_bitmap(u32 chain_bitmap)
 	return res;
 }
 
-/**
+/*
  * iwlagn_set_rxon_chain - Set up Rx chain usage in "staging" RXON image
  *
  * Selects how many and which Rx receivers/antennas/chains to use.
-- 
2.25.1

