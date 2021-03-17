Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21D5233E86D
	for <lists+netdev@lfdr.de>; Wed, 17 Mar 2021 05:27:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229792AbhCQE1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Mar 2021 00:27:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCQE0l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Mar 2021 00:26:41 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBEA8C06174A;
        Tue, 16 Mar 2021 21:26:29 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id t4so37708831qkp.1;
        Tue, 16 Mar 2021 21:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UAePd2rnygsdnsyXuv6mA0DvkDM4G5iCOPbKYR8KnfA=;
        b=TUENOgqwp0RcG7cUSv/IoSnbdYmot2EaAPg8f133Gpcjlck9N48TosyQKBN4jhRm6F
         FshHd++qREzvrRmv2nyqKOP0z6qSK9dJao9Co3hHA9DYPR0Tc8qV08p2hpMyWhH34lgh
         diOOYdPMeaa+IOI6MmPRb5xoVbIrsiotmBjcw79hzmN2nBiRSP1U+zhdQQovQG9HRfjz
         g9YMNC3lvtmXNfWAWOwXtbnCrz30WLOQgnlyIMk3Noikxy7IyN+Um0yVXCntmjDktcmE
         M5FSGvYrXDltyrIFHbg/+Iv7dAlir/YjAg+RdDhCIrCoseamL0F1ReNgtR4xcMG9jDWe
         Ec7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=UAePd2rnygsdnsyXuv6mA0DvkDM4G5iCOPbKYR8KnfA=;
        b=sbOlSVVLWtX9UIxJYqvTcbeHXH51FCMx/8kxCN6z77nGJs7pAwQw8Iulx5YUAcRlLf
         CVMOtmPD5NWKtNjv1KS0sVePpcjOeKqdgyDKzmhuj9+o6fV3ZZaVCk3qQJfQwdB1J9Z2
         f8ey/uEIoOA/5G4NfwRJjmdgOWhDONHptddFer5uoyY8Vuv4Cx62wOZeRkicYxaJJp6w
         Jdtut+X1mqjGAQzMwtk/82JTW4GShwtZxVzXabzCwrstYD1eoz4DGPigsAFGUeHwJGWg
         LwLbUgb2rSPz8vPTWMgjf08arg4nlgJZm1PKwTAa1lmHg4Qyo8PTjB1T/yCfMzlLBjtN
         l8ng==
X-Gm-Message-State: AOAM530wFMlSOvP0eR75ouO26UOYDtnBrJNGnbJimsmDjDpXYaUoFjo5
        v76jhT60VKEEiUskC2sPXZA=
X-Google-Smtp-Source: ABdhPJwcs4m28tAdz0LxicKJZAh82Tqd/a+q2SchpdWvR3KPdyhrgC57f8DlPKPtG7BXqcv/HtLLbQ==
X-Received: by 2002:a37:a58f:: with SMTP id o137mr2634342qke.482.1615955189003;
        Tue, 16 Mar 2021 21:26:29 -0700 (PDT)
Received: from localhost.localdomain ([37.19.198.5])
        by smtp.gmail.com with ESMTPSA id f136sm17025857qke.24.2021.03.16.21.26.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Mar 2021 21:26:28 -0700 (PDT)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     luciano.coelho@intel.com, kvalo@codeaurora.org,
        davem@davemloft.net, kuba@kernel.org, gil.adam@intel.com,
        unixbhaskar@gmail.com, johannes.berg@intel.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org
Subject: [PATCH] wireless: intel: iwlwifi: fw: api: Absolute rudimentary typo fixes in the file power.h
Date:   Wed, 17 Mar 2021 09:55:40 +0530
Message-Id: <20210317042540.4097078-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


s/folowing/following/
s/Celsuis/Celsius/
s/temerature/temperature/  ...twice


Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/fw/api/power.h | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
index 798417182d54..f7c7852127d3 100644
--- a/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
+++ b/drivers/net/wireless/intel/iwlwifi/fw/api/power.h
@@ -54,7 +54,7 @@ struct iwl_ltr_config_cmd_v1 {
  * @flags: See &enum iwl_ltr_config_flags
  * @static_long: static LTR Long register value.
  * @static_short: static LTR Short register value.
- * @ltr_cfg_values: LTR parameters table values (in usec) in folowing order:
+ * @ltr_cfg_values: LTR parameters table values (in usec) in following order:
  *	TX, RX, Short Idle, Long Idle. Used only if %LTR_CFG_FLAG_UPDATE_VALUES
  *	is set.
  * @ltr_short_idle_timeout: LTR Short Idle timeout (in usec). Used only if
@@ -493,7 +493,7 @@ union iwl_ppag_table_cmd {
  *      Roaming Energy Delta Threshold, otherwise use normal Energy Delta
  *      Threshold. Typical energy threshold is -72dBm.
  * @bf_temp_threshold: This threshold determines the type of temperature
- *	filtering (Slow or Fast) that is selected (Units are in Celsuis):
+ *	filtering (Slow or Fast) that is selected (Units are in Celsius):
  *	If the current temperature is above this threshold - Fast filter
  *	will be used, If the current temperature is below this threshold -
  *	Slow filter will be used.
@@ -501,12 +501,12 @@ union iwl_ppag_table_cmd {
  *      calculated for this and the last passed beacon is greater than this
  *      threshold. Zero value means that the temperature change is ignored for
  *      beacon filtering; beacons will not be  forced to be sent to driver
- *      regardless of whether its temerature has been changed.
+ *      regardless of whether its temperature has been changed.
  * @bf_temp_slow_filter: Send Beacon to driver if delta in temperature values
  *      calculated for this and the last passed beacon is greater than this
  *      threshold. Zero value means that the temperature change is ignored for
  *      beacon filtering; beacons will not be forced to be sent to driver
- *      regardless of whether its temerature has been changed.
+ *      regardless of whether its temperature has been changed.
  * @bf_enable_beacon_filter: 1, beacon filtering is enabled; 0, disabled.
  * @bf_debug_flag: beacon filtering debug configuration
  * @bf_escape_timer: Send beacons to to driver if no beacons were passed
--
2.30.2

