Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAEA4249722
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 09:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbgHSHZd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 03:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727836AbgHSHYs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Aug 2020 03:24:48 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 763D7C061361
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:21 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id a15so20430433wrh.10
        for <netdev@vger.kernel.org>; Wed, 19 Aug 2020 00:24:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Zkp7Qawe8Rxm7rdSdovVzLB4vK2dfikmYIjnToE95fQ=;
        b=fBVItS+8uy4PAXVGRqKYqcnn9vyXIUkhYylVMPeahGvVrQto2p/kFHnE+EcYz8Ok5U
         0EptKYfI49bLYwsG662WDdFSVeqWNpy97/8Sny+D87UA+KwPnTCRIAR9EsOFKILlnA/Y
         7ocVDTmDlbuuCImjyvNzHsVM7FNVjvugAXJE6vv688eHXV4ASY4SPSbC1kbHPQHML8hG
         DjyK/P1ZEi3fDD30U2G8O46bBOX8i2yXFGoZGbibtjrZ4Ya+LMZTWP2HaiV70lEqTZM2
         mTuabOI+q0FndjZ/4xpKFuIGJro9fL46/+WJda9KOOHv6zRw5Uz6scFS2ha+5RE5euaS
         805g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Zkp7Qawe8Rxm7rdSdovVzLB4vK2dfikmYIjnToE95fQ=;
        b=bcepRJY/8TQP5dq9fB35fmlGGsW1FqoiUYX3yXbqAhNDLNqDIMyG9F3sYBpko8QC4E
         tzOLuy9dnFjWaEdkBqvqnxOZkjuYARfAGWQvT3wlhWBQUt05fKmGLrXx34r8jVvRVX0g
         Lf2kytLG6jWRmPXq6gvhLpYsDLQyJGE6ZlnDP5msclOVGn9CAp2mcbuMT9OnNnYS0lUB
         BVhT9Lv7qP1sW5OxXalXcQ8IhKhuuXPhK9QglXqoOW/duqpji8i7uFEAhYV/cBhwGkHX
         wWH52J/Q8CuyqI8fq/zxZqo5fQhqsnRsky9DrF91jqPD7Zvqa4m+IYYGcelUpA4SRwgE
         O/cg==
X-Gm-Message-State: AOAM533tRWetX6oIiXEkZG2Nj1TTCNwUXM8Ez9If7PwlOVI2VJ9wMSKy
        ftdjHrSCaaeoU5etHZfoBt37l7JqYmMQyw==
X-Google-Smtp-Source: ABdhPJxSZ+TVjacVOaXJET7sX7pS2ZMFGfwgWGTctOu11RcWXc/86twvo3Hbv9eAa3q10tv3lzLa/Q==
X-Received: by 2002:adf:8445:: with SMTP id 63mr2657230wrf.375.1597821860190;
        Wed, 19 Aug 2020 00:24:20 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id c145sm3795808wmd.7.2020.08.19.00.24.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Aug 2020 00:24:19 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>
Subject: [PATCH 12/28] wireless: intel: iwlwifi: dvm: lib: Demote non-compliant kernel-doc headers
Date:   Wed, 19 Aug 2020 08:23:46 +0100
Message-Id: <20200819072402.3085022-13-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200819072402.3085022-1-lee.jones@linaro.org>
References: <20200819072402.3085022-1-lee.jones@linaro.org>
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

