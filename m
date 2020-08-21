Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7B2B24CF2E
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728680AbgHUHWz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:22:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728048AbgHUHQ7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:16:59 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5AD9C061342
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:58 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id t2so593349wma.0
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:16:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=XEuMBeNYRk5zJO3oK7+mBcMmVKwq5vw1RsgSJVTkf20=;
        b=DW/Phlyh+obGNUw4ueWjW09DI2bFN0XqZQ17caLwo4M+AdomYyyhlVByH8rGyHrLtn
         co9NN9ONnNCGbNVBnL8SdFh1crPr6lAC6TaxCrc04aq+M/Ly13/A6wpK2IXQpv13T9/6
         QoG+RKq3yqtKw/NsyM8hrWsveQQ18tLTi/R7ei8FB3Cai0eVKOEIFZWmtGUE9+6Ac5uI
         uZa+A7mcx2O61LOkpNf4Q/a1F6FlY1cl7tiGY3Np2UKv9gJBbLHozqeCHj9+NLNcFGwa
         wfrCxzM7nAh0g2jkWr09e3TnMGs4G3hkyc82fts7FG20H/jJ3Km/pYreoWksVN44EpQu
         spTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XEuMBeNYRk5zJO3oK7+mBcMmVKwq5vw1RsgSJVTkf20=;
        b=dsjYW4SHE46ij1sxvPIIgKD2zvGgqMLv0+NtWZHKMYx2lXZuiCeFLujuJttAmhaV8u
         PTzU0RqAq4DTG7cxiDSiafH2UKPHp1nHitjTtyqWW23XV32aoNMm4N97Mn6IeRMR3FOR
         NDR6A3a6ENbSLmvCNhQ2ZsrXA+mL9oFxrg+mgCJxxEsL2rQXc8w538ophJpJqD0WuEGV
         g1l90Zz2aWfl2qYpA89LBtiNXqcCeUogWGuvyceVCrtOYyyEbGalS9e6zAl5d0nsOUh9
         BsUHOC2OR+eeLS7CEU6tANwo8MNAx4aGY6sx+mDML87e6mbPOJxLr47bsB4yVcb5yB9e
         bXhw==
X-Gm-Message-State: AOAM533Nuj79/NpXQogU/N7HcSffucOliLnu+X9JYZ2gLkM/LkMFh70Y
        bimxyPJgjJ0fN2EtmpVzapGr5w==
X-Google-Smtp-Source: ABdhPJxKn/3N6VpBa20RtxaeEKSSfLRS9ZrkKA5GIeXUlsBd3G0Q3GNDUuSyv5SNp1nk0oR0j+QcuA==
X-Received: by 2002:a1c:720d:: with SMTP id n13mr1650662wmc.103.1597994217415;
        Fri, 21 Aug 2020 00:16:57 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.16.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:16:56 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 07/32] wireless: intel: iwlwifi: dvm: rx: Demote a couple of nonconformant kernel-doc headers
Date:   Fri, 21 Aug 2020 08:16:19 +0100
Message-Id: <20200821071644.109970-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/dvm/rx.c:145: warning: Function parameter or member 'priv' not described in 'iwlagn_good_plcp_health'
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c:145: warning: Function parameter or member 'cur_ofdm' not described in 'iwlagn_good_plcp_health'
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c:145: warning: Function parameter or member 'cur_ofdm_ht' not described in 'iwlagn_good_plcp_health'
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c:145: warning: Function parameter or member 'msecs' not described in 'iwlagn_good_plcp_health'
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c:939: warning: Function parameter or member 'priv' not described in 'iwl_setup_rx_handlers'

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
 drivers/net/wireless/intel/iwlwifi/dvm/rx.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
index 673d60784bfad..9d55ece050200 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/rx.c
@@ -132,7 +132,7 @@ static void iwlagn_rx_beacon_notif(struct iwl_priv *priv,
 	priv->ibss_manager = le32_to_cpu(beacon->ibss_mgr_status);
 }
 
-/**
+/*
  * iwl_good_plcp_health - checks for plcp error.
  *
  * When the plcp error is exceeding the thresholds, reset the radio
@@ -929,7 +929,7 @@ static void iwlagn_rx_noa_notification(struct iwl_priv *priv,
 		kfree_rcu(old_data, rcu_head);
 }
 
-/**
+/*
  * iwl_setup_rx_handlers - Initialize Rx handler callbacks
  *
  * Setup the RX handlers for each of the reply types sent from the uCode
-- 
2.25.1

