Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CA5249770
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:30:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727976AbgHSHaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726939AbgHSHYP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:24:15 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85D4BC06134E
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:12 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id k20so1112607wmi.5
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=kFIC75bauZ6Rpz/avISlwE77tX9e6rPrMyzEdUSYEvc=;
        b=lgBo+nLfWw6UD+4pt1UTY/3TXHxDnstMrcNhEXl7QEcvc5h/hM0LeUSSXQEJQQJ1o/
         JR2AZRhWNJk/NU4uxKd521AxM8XLlKmwKHwCpCIji5uCxzp/sIne5zll2Tc6MdgEse/H
         9OMRSEnvpPMQLhNCN5EjGfWho9jctYaqnf9oMAyXnLM5TsZBiD0Km+WA1WKErkMt0zmH
         QQ4alnk4V03ep2zWKQk0LCBVTy66yYt7mhumvKHSbGfyZ9ZueSNxSRiAb//NLqXqe/ur
         K9EGBqezMx/VP2exyAfHV8+521PHWEr4oMxAjX3ZxFtz+k4s/ry3PJ7aIaAZWNiH7MfQ
         ohPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=kFIC75bauZ6Rpz/avISlwE77tX9e6rPrMyzEdUSYEvc=;
        b=lO0C47xXKdKjIg6WozekxR/9upOw8Mhkkj7xlqXLMGZq7cVTzdUu0xv1Kfnkqj6kKK
         2OVNGiu42RNhN35zctLI0DHHkDDsu4jgDSX67EswI7B7Jhj/tO/4CJ8/ivXHvKINil2y
         mdPqBuHm8kkVBvdrH+zn/1uv/0ad2DrtNtWU4ePy7vVjW5gd0OlDq8bStz4mpNJzpY8z
         O6QP/ikqB2s4kd5r6OT0iQPpQ0xbVDRRSdihrUZyJJPWB8TTQb+Ji6e+BgrCRGGqxDEm
         gtCrjMRsZ6E3c+Lc5OI/LPxBHeXWPeOI0F2i48pHWnFVv2MIr4Zx3jvIkTes2A/M6FIc
         1PIw==
X-Gm-Message-State: AOAM533aFBnFCHuQVuP0gDBovoMRXcWdwOWvv0ZQUOhk6uPlQ1OYG9w2
        7nFE3+m/pVOPn1JDPOJR5wQ00A==
X-Google-Smtp-Source: ABdhPJxep9SAfEgQ3UqQQk5ZftteMUPLH4iMlYCMWjOj95LkdbfBmgFRoszaYn7hm9krZoUxri1XdQ==
X-Received: by 2002:a1c:f60e:: with SMTP id w14mr3408680wmc.19.1597821851203;
        Wed, 19 Aug 2020 00:24:11 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:10 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 05/28] wireless: intel: dvm: Demote non-compliant kernel-doc headers
Date:   Wed, 19 Aug 2020 08:23:39 +0100
Message-Id: <20200819072402.3085022-6-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
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

