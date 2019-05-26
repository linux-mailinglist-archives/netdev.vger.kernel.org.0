Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B68FA2A96B
	for <lists+netdev@lfdr.de>; Sun, 26 May 2019 13:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727767AbfEZLiX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 May 2019 07:38:23 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:45005 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727658AbfEZLiX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 May 2019 07:38:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id c5so5925294pll.11;
        Sun, 26 May 2019 04:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=vHyiWIrxCKbF82jHEx3dPDyuEINmnCFpVzzmHglDTDU=;
        b=Vq9hIrZQXQAcBJNa2Jvwml7Vo4eoyG6F+c+016aZD/7Q6IPGiD1Ngf+Y5PtTFbGEri
         5YwrEmOPv64T4Ff9w9Z7zb4klhEYemZBxiJtHzHQYgZ9n0BeUQhwwfLNOBQEBoSN5Kc7
         9wsTbcVxK9saGxCmm2169a81jE5Qhr4jWOHrwCSwm3S3a9A2LFb8MPRTVJ5tNMez2TV5
         li4n1IZc9KffzwIH+ZRv8y9Px14XacpXwxYyoZpYGNHj+DWrYaecp/7xhgaUaTQB4AD+
         qASL/oNHndLicoUWpBQDTSLxXfZ/WEI2jWiaEGRQoUiLr2YD9F52MjgGkjbqqQcF7+Dd
         iJDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=vHyiWIrxCKbF82jHEx3dPDyuEINmnCFpVzzmHglDTDU=;
        b=D/sk0y0yb1R1D+uh2gZ8cDCIe/23pmAnnJzMsrp6AD3/vb6JgxclpFENPkMOtyAKru
         KDBnA+2Yeq9xy/+ZP/PXiBU9waCl2hHE5EgDNPzFxg6G5iKDzpjTr/WPcTFX2N7O07Hj
         SKUahHkOU/QhWiZrQz0AolJVY/8ObV1rAo9RY2eQDJbXRaPiReph8QGkuxHn6Urq5rFe
         Wh7rjPI2gzZuN3wUgMFqLpVo+TWH8k/IjlCdyJJ7ydOOwUtmqCp3c7W/t6/bxURJX3Eh
         92ETf3qJtD8BguopvQdShtAaTwPekbLiIVIodSMCmwS1wPAPaOuZAFLHIJimDHEdvbNW
         AQ/w==
X-Gm-Message-State: APjAAAXn45zzFA5Gz8f6a+mHqulBCaAYx15SU6PXP6tUhDrUezbsT4w1
        iyqhM+brxZudIVARltIc8+NVtJON
X-Google-Smtp-Source: APXvYqyVScmWg74EtVIen6Cs4u7grE7ear46zwMSqGZTsVgp8Ph3T8Wb2RqlrR0VhJZPGnGfBfPZZQ==
X-Received: by 2002:a17:902:2bc9:: with SMTP id l67mr85855288plb.171.1558870702896;
        Sun, 26 May 2019 04:38:22 -0700 (PDT)
Received: from hari-Inspiron-1545 ([183.83.92.73])
        by smtp.gmail.com with ESMTPSA id f1sm1836101pfg.154.2019.05.26.04.38.19
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 26 May 2019 04:38:22 -0700 (PDT)
Date:   Sun, 26 May 2019 17:08:16 +0530
From:   Hariprasad Kelam <hariprasad.kelam@gmail.com>
To:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] iwlwifi: fix warning iwl-trans.h is included more than once
Message-ID: <20190526113815.GA6328@hari-Inspiron-1545>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

remove duplication include of iwl-trans.h

issue identified by includecheck

Signed-off-by: Hariprasad Kelam <hariprasad.kelam@gmail.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
index fc649b2..f5a56c5 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-devtrace.h
@@ -86,7 +86,6 @@ static inline size_t iwl_rx_trace_len(const struct iwl_trans *trans,
 
 #include <linux/tracepoint.h>
 #include <linux/device.h>
-#include "iwl-trans.h"
 
 
 #if !defined(CONFIG_IWLWIFI_DEVICE_TRACING) || defined(__CHECKER__)
-- 
2.7.4

