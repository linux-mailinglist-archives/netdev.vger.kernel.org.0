Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 471D6263E6B
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730276AbgIJHTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:19:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726792AbgIJGz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:55:59 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5FEDC0617B1
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:02 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id c18so5396967wrm.9
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=glqW/Gnt3wlpIqCq2zLjhjH68Neg4Dhca059SWlN3nQ=;
        b=x1yK7ffZ3J3xAQzQZqR4Endaib4uWtU22Q6EA7ozusuppeg1M2uuzMZRIC6HH3Vvab
         7mpNSeB5DZIaTyd1bXOfG1yXjX7RqVJTlhMvBIL+LvbVGvcQdaydo6toV8eQVEw6ltf0
         edDwaZZsuVuoktbaZyDJwGAZo9IczmTViYQG6gRewbuJZ7LjgCxLcavKW/GfjEQNPHq1
         Jcg2alLeCcS60W6G5cXsLG9kNUZ4jZ8Ny1eDqsrTZKWLe/BsvV4m6ODpjg5f3bojA3Ty
         7u/3ke4QssHuk3Z4EO1b5Y4RsPz8xhn7XqeYHeWKDgSzYhmBtGd3h4foVJAOpCDowSa/
         Cd1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=glqW/Gnt3wlpIqCq2zLjhjH68Neg4Dhca059SWlN3nQ=;
        b=By6bSfd82NkkHvqWd112hwhAA8IUeQDNGIJe5KDTHiAnK4SlB2fIo3ee9CClQM3tVN
         HxQDOSe8Oq/l6HpPQoUnIilr1XRxHZROJ3JpH5i3riHpB6t/9gOXi2PuSNlMBihcFK8X
         YGiOJL9wiQNM0wTzcbSXJAzTxoDxI92SUTwHWIOMsdkx2Mkh3uxJ26JKAAhVzopgYiaz
         gOB/ugt221grThT7stEpYMQW2N6KAXGRFxC9Q+IKhwYX7bwR/L6wl7jaWQ1uJ2o5wVqv
         fppSgpV/VayPKBk976Kc2wi3uTxslJFEJPs9nKjWqWOHAXBG6ywXUQ0mKEg9+XcsAEPX
         Jotw==
X-Gm-Message-State: AOAM533X/WBNasj++BbjvYCNKFCjyofKZnBvngrfRoXHd4PB/OYRvhF+
        zz1/o82Of1BMgmmWDHStMORjUg==
X-Google-Smtp-Source: ABdhPJyWyDn0B5Bb2+0GgAtTZKtbptRH/1nS13T9408JoXSuaWWHBCv9SYKa/dzSMhzXzH/IMmhyNw==
X-Received: by 2002:adf:e843:: with SMTP id d3mr5240652wrn.290.1599720901447;
        Wed, 09 Sep 2020 23:55:01 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:00 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 07/29] iwlwifi: dvm: sta: Demote a bunch of nonconformant kernel-doc headers
Date:   Thu, 10 Sep 2020 07:54:09 +0100
Message-Id: <20200910065431.657636-8-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:244: warning: Function parameter or member 'priv' not described in 'iwl_prep_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:244: warning: Function parameter or member 'ctx' not described in 'iwl_prep_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:244: warning: Function parameter or member 'addr' not described in 'iwl_prep_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:244: warning: Function parameter or member 'is_ap' not described in 'iwl_prep_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:244: warning: Function parameter or member 'sta' not described in 'iwl_prep_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:332: warning: Function parameter or member 'priv' not described in 'iwl_add_station_common'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:332: warning: Function parameter or member 'ctx' not described in 'iwl_add_station_common'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:332: warning: Function parameter or member 'addr' not described in 'iwl_add_station_common'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:332: warning: Function parameter or member 'is_ap' not described in 'iwl_add_station_common'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:332: warning: Function parameter or member 'sta' not described in 'iwl_add_station_common'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:332: warning: Function parameter or member 'sta_id_r' not described in 'iwl_add_station_common'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:390: warning: Function parameter or member 'priv' not described in 'iwl_sta_ucode_deactivate'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:390: warning: Function parameter or member 'sta_id' not described in 'iwl_sta_ucode_deactivate'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:459: warning: Function parameter or member 'priv' not described in 'iwl_remove_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:459: warning: Function parameter or member 'sta_id' not described in 'iwl_remove_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:459: warning: Function parameter or member 'addr' not described in 'iwl_remove_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:614: warning: Function parameter or member 'priv' not described in 'iwl_clear_ucode_stations'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:614: warning: Function parameter or member 'ctx' not described in 'iwl_clear_ucode_stations'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:648: warning: Function parameter or member 'priv' not described in 'iwl_restore_stations'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:648: warning: Function parameter or member 'ctx' not described in 'iwl_restore_stations'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:790: warning: Function parameter or member 'priv' not described in 'is_lq_table_valid'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:790: warning: Function parameter or member 'ctx' not described in 'is_lq_table_valid'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:790: warning: Function parameter or member 'lq' not described in 'is_lq_table_valid'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:822: warning: Function parameter or member 'priv' not described in 'iwl_send_lq_cmd'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:822: warning: Function parameter or member 'ctx' not described in 'iwl_send_lq_cmd'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:822: warning: Function parameter or member 'lq' not described in 'iwl_send_lq_cmd'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:822: warning: Function parameter or member 'flags' not described in 'iwl_send_lq_cmd'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1270: warning: Function parameter or member 'priv' not described in 'iwlagn_alloc_bcast_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1270: warning: Function parameter or member 'ctx' not described in 'iwlagn_alloc_bcast_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1309: warning: Function parameter or member 'priv' not described in 'iwl_update_bcast_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1309: warning: Function parameter or member 'ctx' not described in 'iwl_update_bcast_station'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1348: warning: Function parameter or member 'priv' not described in 'iwl_sta_tx_modify_enable_tid'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1348: warning: Function parameter or member 'sta_id' not described in 'iwl_sta_tx_modify_enable_tid'
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c:1348: warning: Function parameter or member 'tid' not described in 'iwl_sta_tx_modify_enable_tid'

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
 drivers/net/wireless/intel/iwlwifi/dvm/sta.c | 22 ++++++++++----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
index 51158edce15b0..e622948661fa8 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/sta.c
@@ -234,7 +234,7 @@ static void iwl_set_ht_add_station(struct iwl_priv *priv, u8 index,
 	priv->stations[index].sta.station_flags |= flags;
 }
 
-/**
+/*
  * iwl_prep_station - Prepare station information for addition
  *
  * should be called with sta_lock held
@@ -323,7 +323,7 @@ u8 iwl_prep_station(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 
 #define STA_WAIT_TIMEOUT (HZ/2)
 
-/**
+/*
  * iwl_add_station_common -
  */
 int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
@@ -383,7 +383,7 @@ int iwl_add_station_common(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	return ret;
 }
 
-/**
+/*
  * iwl_sta_ucode_deactivate - deactivate ucode status for a station
  */
 static void iwl_sta_ucode_deactivate(struct iwl_priv *priv, u8 sta_id)
@@ -451,7 +451,7 @@ static int iwl_send_remove_station(struct iwl_priv *priv,
 	return ret;
 }
 
-/**
+/*
  * iwl_remove_station - Remove driver's knowledge of station.
  */
 int iwl_remove_station(struct iwl_priv *priv, const u8 sta_id,
@@ -601,7 +601,7 @@ static void iwl_sta_fill_lq(struct iwl_priv *priv, struct iwl_rxon_context *ctx,
 	link_cmd->sta_id = sta_id;
 }
 
-/**
+/*
  * iwl_clear_ucode_stations - clear ucode station table bits
  *
  * This function clears all the bits in the driver indicating
@@ -636,7 +636,7 @@ void iwl_clear_ucode_stations(struct iwl_priv *priv,
 			       "No active stations found to be cleared\n");
 }
 
-/**
+/*
  * iwl_restore_stations() - Restore driver known stations to device
  *
  * All stations considered active by driver, but not present in ucode, is
@@ -773,7 +773,7 @@ static inline void iwl_dump_lq_cmd(struct iwl_priv *priv,
 }
 #endif
 
-/**
+/*
  * is_lq_table_valid() - Test one aspect of LQ cmd for validity
  *
  * It sometimes happens when a HT rate has been in use and we
@@ -807,7 +807,7 @@ static bool is_lq_table_valid(struct iwl_priv *priv,
 	return true;
 }
 
-/**
+/*
  * iwl_send_lq_cmd() - Send link quality command
  * @init: This command is sent as part of station initialization right
  *        after station has been added.
@@ -1258,7 +1258,7 @@ int iwl_set_dynamic_key(struct iwl_priv *priv,
 	return ret;
 }
 
-/**
+/*
  * iwlagn_alloc_bcast_station - add broadcast station into driver's station table.
  *
  * This adds the broadcast station into the driver's station table
@@ -1298,7 +1298,7 @@ int iwlagn_alloc_bcast_station(struct iwl_priv *priv,
 	return 0;
 }
 
-/**
+/*
  * iwl_update_bcast_station - update broadcast station's LQ command
  *
  * Only used by iwlagn. Placed here to have all bcast station management
@@ -1341,7 +1341,7 @@ int iwl_update_bcast_stations(struct iwl_priv *priv)
 	return ret;
 }
 
-/**
+/*
  * iwl_sta_tx_modify_enable_tid - Enable Tx for this TID in station table
  */
 int iwl_sta_tx_modify_enable_tid(struct iwl_priv *priv, int sta_id, int tid)
-- 
2.25.1

