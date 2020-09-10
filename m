Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 068D8263DC3
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 08:56:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgIJGz4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 02:55:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726893AbgIJGy5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:54:57 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FFB9C0613ED
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:54:55 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id j2so5417881wrx.7
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kFIC75bauZ6Rpz/avISlwE77tX9e6rPrMyzEdUSYEvc=;
        b=opyAAeBSR896y84hVzRW6SofLr9HSSArQIQNg4NVZmAylAtOL03MJFXDP56Bh4eWyn
         UDhyPO/K0xgJ8DoBCtEilkJIVwhnNJZyjusioUI8UPp0ruDyH5qgOhN+bF6OJpcoHfph
         kxwg2hN6zF4xUj7gdqCTcoqqfGCcv64nbey8y591Wle6cg7hoyW8yoyz5ORBb4FKViZj
         cSswzXPMQcm2LvJyc/aa2RUYa4ihM1TC216Gt8idJkOez2+KvyGjaMy4+sF/GuTkBoZD
         W+APFxMoM6aLidvcWJqjFmAlEdpSyQw1WaSHbHuK7s+0+rf4t1RH/Nu/balqzEp4H9vN
         C1dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kFIC75bauZ6Rpz/avISlwE77tX9e6rPrMyzEdUSYEvc=;
        b=sFensQ4PsclfE7dpNljPPlut8Tmi8dfpzf8vIUUjVqPlvVXJv/6sK0Ttg7E6EvZiLa
         Kfwjsqb1PiDVdMX2miaM/1y4TpqBpaF/GHi9igXxfHOjnlWfbjSfKS1cbGRdma0Dyc/H
         udF7BcZ2lfReuO/qvwVDO3f5OVVBF2XTnbux6kxcl2Cndj8121qhQdl7CxgqRsVgNt47
         94bddNQYD4O+ZFcx4f6I5ohe2Awmy2taZX9ZN8oAcIzDQaKQG0+59lZuD2usxn5Lroxy
         HOEiEyV9V42MHFtZjqOU5c3g6JcZ3/I3paobZ1dMal6Zk17IN5Yt7My+ddLxW1CmsXTc
         NDPA==
X-Gm-Message-State: AOAM530SjJp7AB5PHk0tOp4UAF6QppOYiGqesONXSb1OaF/yJ0cbASg/
        3KQ1CyALc6XxMx/6qN0ITpwf6Q==
X-Google-Smtp-Source: ABdhPJx8DeWDe6U8fQ7m/kdq1bE91DUEiWHtZrjxC5GmjapY+vNFcT0KX1Tl4rz0nkHRc3EaNMtaIA==
X-Received: by 2002:adf:f58b:: with SMTP id f11mr7404003wro.250.1599720894463;
        Wed, 09 Sep 2020 23:54:54 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.54.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:54:53 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 01/29] iwlwifi: dvm: Demote non-compliant kernel-doc headers
Date:   Thu, 10 Sep 2020 07:54:03 +0100
Message-Id: <20200910065431.657636-2-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

None of these headers attempt to document any function parameters.

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/intel/iwlwifi/dvm/main.c:388: warning: Function parameter or member 't' not described in 'iwl_bg_statistics_periodic'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:545: warning: Function parameter or member 't' not described in 'iwl_bg_ucode_trace'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:771: warning: Function parameter or member 'priv' not described in 'iwl_alive_start'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'priv' not described in 'iwl_print_event_log'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'start_idx' not described in 'iwl_print_event_log'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'num_events' not described in 'iwl_print_event_log'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'mode' not described in 'iwl_print_event_log'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'pos' not described in 'iwl_print_event_log'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'buf' not described in 'iwl_print_event_log'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1692: warning: Function parameter or member 'bufsz' not described in 'iwl_print_event_log'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'priv' not described in 'iwl_print_last_event_logs'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'capacity' not described in 'iwl_print_last_event_logs'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'num_wraps' not described in 'iwl_print_last_event_logs'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'next_entry' not described in 'iwl_print_last_event_logs'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'size' not described in 'iwl_print_last_event_logs'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'mode' not described in 'iwl_print_last_event_logs'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'pos' not described in 'iwl_print_last_event_logs'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'buf' not described in 'iwl_print_last_event_logs'
 drivers/net/wireless/intel/iwlwifi/dvm/main.c:1772: warning: Function parameter or member 'bufsz' not described in 'iwl_print_last_event_logs'

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
 drivers/net/wireless/intel/iwlwifi/dvm/main.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/dvm/main.c b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
index b882705ff66df..461af58311561 100644
--- a/drivers/net/wireless/intel/iwlwifi/dvm/main.c
+++ b/drivers/net/wireless/intel/iwlwifi/dvm/main.c
@@ -374,7 +374,7 @@ int iwl_send_statistics_request(struct iwl_priv *priv, u8 flags, bool clear)
 					&statistics_cmd);
 }
 
-/**
+/*
  * iwl_bg_statistics_periodic - Timer callback to queue statistics
  *
  * This callback is provided in order to send a statistics request.
@@ -533,7 +533,7 @@ static void iwl_continuous_event_trace(struct iwl_priv *priv)
 	priv->event_log.next_entry = next_entry;
 }
 
-/**
+/*
  * iwl_bg_ucode_trace - Timer callback to log ucode event
  *
  * The timer is continually set to execute every
@@ -762,7 +762,7 @@ static void iwl_send_bt_config(struct iwl_priv *priv)
 		IWL_ERR(priv, "failed to send BT Coex Config\n");
 }
 
-/**
+/*
  * iwl_alive_start - called after REPLY_ALIVE notification received
  *                   from protocol/runtime uCode (initialization uCode's
  *                   Alive gets handled by iwl_init_alive_start()).
@@ -1682,9 +1682,8 @@ static void iwl_dump_nic_error_log(struct iwl_priv *priv)
 
 #define EVENT_START_OFFSET  (4 * sizeof(u32))
 
-/**
+/*
  * iwl_print_event_log - Dump error event log to syslog
- *
  */
 static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 			       u32 num_events, u32 mode,
@@ -1762,7 +1761,7 @@ static int iwl_print_event_log(struct iwl_priv *priv, u32 start_idx,
 	return pos;
 }
 
-/**
+/*
  * iwl_print_last_event_logs - Dump the newest # of event log to syslog
  */
 static int iwl_print_last_event_logs(struct iwl_priv *priv, u32 capacity,
-- 
2.25.1

