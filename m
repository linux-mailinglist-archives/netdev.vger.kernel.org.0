Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 418B61BD90F
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 12:07:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726896AbgD2KG4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 06:06:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgD2KGz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 06:06:55 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1875AC03C1AD;
        Wed, 29 Apr 2020 03:06:55 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id d17so1740963wrg.11;
        Wed, 29 Apr 2020 03:06:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=vlVsWbwsNkl/TxgxYTz0/9lmMnRp6tdTtsm8EAtYlJ4=;
        b=DzAT9g4HMuNbWcTWcRyhoQe7LzTLGkvp0MgaHB5ZxgyA975w/fxClIK0oPEGbqCiBU
         CxOS+oH+/pwy7M6/ytWHwccgbGGC0kkLbNuPzE1OR1xyZcVzMHEes77pPgkrxPCvHfd2
         qnWDh6AKmzaGq8PJ6NF4b4d33uogu9Ps6UqKDznOTrhmrKU46gvYaDiPNyBqL2A5L0E1
         lKgX+EALYSlDRpWMR59zSUhNzdHLDmxyLfdCag/17RKjC28hqTC7rGqBDb/fbLQ6d2BA
         mp107vc0xXr184KR1nRQi8lSr1MGcL0n5w3VnCYVsaNtaDVfaoZZ/pUyPrYPwkYwkenS
         4diQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vlVsWbwsNkl/TxgxYTz0/9lmMnRp6tdTtsm8EAtYlJ4=;
        b=Avz4O0OOn9qa1StrYOQ0Lhxl04KvQMfuiukiJXHXx/LPOskmSZ6JhD0q3YVtm8jDdc
         DhiYd9ekpS1paFZKACsq3C6HmHRNbOoVFm5e8efur1BCEqmoY5CPRFcH66eqTO3CdVXY
         JG3XDw7PXSXDfewG1ymIEDm/1LFt0po2II9h/J5sZtkiwC4kVuTh8tsbhjqVYiY0h6mo
         3l+w1UnfbXQEdirs+oU6ykGPHFi1I28VQrmDliB1Nb7uU/mbN0UnQMHrIH3QjJt7roLI
         HS0EJ/KxG9QcezO1hv+bPrAPLr7ZT2BsJtU3WtxWcjNxsHCchbyoJn5GsO+2YP/8o/QY
         /qZA==
X-Gm-Message-State: AGi0PuZ8nNOfrZ3dXQOXzu+UTBtt1e0IHer9gD2SC/8+AEhYPZSrvO4i
        cUEk5tV0nLq2vRKZHRClHH9g/CkmWD/G
X-Google-Smtp-Source: APiQypJ+qqXT6FoWX5sw904/DgKdvACesRwUHqlH4KyAGBtPhw3T6H3srA8FS0LS+QmJXWRKKqaqAQ==
X-Received: by 2002:adf:dfcd:: with SMTP id q13mr40769863wrn.423.1588154813381;
        Wed, 29 Apr 2020 03:06:53 -0700 (PDT)
Received: from ninjahost.lan (host-2-102-14-195.as13285.net. [2.102.14.195])
        by smtp.gmail.com with ESMTPSA id 1sm7205478wmi.0.2020.04.29.03.06.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2020 03:06:52 -0700 (PDT)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Shannon Nelson <snelson@pensando.io>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        netdev@vger.kernel.org (open list:NETWORKING [GENERAL])
Subject: [PATCH 6/6] net: atm: Add annotation for lec_priv_walk()
Date:   Wed, 29 Apr 2020 11:05:28 +0100
Message-Id: <20200429100529.19645-7-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200429100529.19645-1-jbi.octave@gmail.com>
References: <0/6>
 <20200429100529.19645-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at lec_priv_walk()
warning: context imbalance in lec_priv_walk() - unexpected unlock

The root cause is the missing annotation at lec_priv_walk()
To fix this, __acquire() and __release() annotations
are added in case conditions are not met.
This only instruct  Sparse to shutdown the warning

Add the  __acquire(&priv->lec_arp_lock)
Add __release(&priv->lec_arp_lock) annotation

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 net/atm/lec.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/atm/lec.c b/net/atm/lec.c
index 22415bc11878..6070acaa3d5c 100644
--- a/net/atm/lec.c
+++ b/net/atm/lec.c
@@ -886,12 +886,18 @@ static void *lec_priv_walk(struct lec_state *state, loff_t *l,
 	if (!state->locked) {
 		state->locked = priv;
 		spin_lock_irqsave(&priv->lec_arp_lock, state->flags);
+	} else {
+		/* annotation for sparse */
+		__acquire(&priv->lec_arp_lock);
 	}
 	if (!lec_arp_walk(state, l, priv) && !lec_misc_walk(state, l, priv)) {
 		spin_unlock_irqrestore(&priv->lec_arp_lock, state->flags);
 		state->locked = NULL;
 		/* Partial state reset for the next time we get called */
 		state->arp_table = state->misc_table = 0;
+	} else {
+		/* annotation for sparse */
+		__release(&priv->lec_arp_lock);
 	}
 	return state->locked;
 }
-- 
2.25.3

