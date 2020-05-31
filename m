Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10A2B1E99D5
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 20:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728263AbgEaS0G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 31 May 2020 14:26:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbgEaS0F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 31 May 2020 14:26:05 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 972EDC061A0E
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 11:26:05 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id z5so7128818ejb.3
        for <netdev@vger.kernel.org>; Sun, 31 May 2020 11:26:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EvaqJi/74WGWQg2Fs84pm4eOFkHVIXzwHgQluTo/yyk=;
        b=MRtmTlJSuxf9VzAW8cSXuIOC15nDbWKppxJwH8vwXUTGx3QeH5NmI2ZTOiy6fJ5yw5
         YK9o8nL9TwKxVPvKl85uKQrzjmRVYYLWdJAMmXax3pj7R4RkNAdM+UbPE9SpGVHtf7kh
         PyDe0jKZXxtZOH/iCXp+rKpIBGwZqnetehrsyuwJ8xbGvj+Hrv85YEFE1EM5ctDtdvAh
         vMK0PD2cPpHLaV0YIji+NTZv/L/3qPw/41fhmFcUJPuByDBl+V8GRHkF303qIrZp4HST
         2UQic1ITfS4yMZfqURfMkkENoueW+AbfpACaon/Vf1kgoOPDR52MVBpANctPBKAmJHup
         I3Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EvaqJi/74WGWQg2Fs84pm4eOFkHVIXzwHgQluTo/yyk=;
        b=KlLLrP4AYC5BsZCW6foSI1O9UKQ8i0jdvz3vUQr4ibS3wbnltED1vRVBen/rMOx/6k
         OrsvS5LtyIaOA8wBrU71FI6BSQyiwNEVv2Uc2xtKtL+YbDW7T5XfAQrUwj7+YJyiymzd
         lSUEpqTFjmebhPbZ7GhpQwySwv/cnXDaNijo+G6G5O9oecd03REdInpItmC0qee+nRcq
         tZEWAMpd7YIVn96z3+3mnBrw48khXs7w4MZ3L4sGNrp8qDl66JiktdVgbmT2HvhRnc7/
         llmB2UuMmYgJF9fj9Iz/ODOnDEFcV0VNopHvO1Oqiz/smI4RNjrfWt1RvaNriEi9/ozM
         yLBw==
X-Gm-Message-State: AOAM531eHFlXcZB0KyTh4rdiXPokfn6qynLkE4/JTFU2ZB86cP6g26Ch
        um5qCd7kBX0EU+xCFspHoRGN4uUN
X-Google-Smtp-Source: ABdhPJyuO76sDyZsBoK04g1PVb9MZXYo56a4aKShjliIFLoPsaAAW7thu7RGs06wgmq2ZVdyweA/UA==
X-Received: by 2002:a17:906:d93c:: with SMTP id rn28mr4040101ejb.190.1590949564375;
        Sun, 31 May 2020 11:26:04 -0700 (PDT)
Received: from localhost.localdomain ([188.25.147.193])
        by smtp.gmail.com with ESMTPSA id p13sm4046340edx.69.2020.05.31.11.26.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 31 May 2020 11:26:03 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH v2 net-next] net: dsa: sja1105: suppress -Wmissing-prototypes in sja1105_vl.c
Date:   Sun, 31 May 2020 21:25:51 +0300
Message-Id: <20200531182551.1515185-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Newer C compilers are complaining about the fact that there are no
function prototypes in sja1105_vl.c for the non-static functions.
Give them what they want.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/dsa/sja1105/sja1105_vl.c | 2 +-
 drivers/net/dsa/sja1105/sja1105_vl.h | 2 ++
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/sja1105/sja1105_vl.c b/drivers/net/dsa/sja1105/sja1105_vl.c
index f37611885376..bdfd6c4e190d 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.c
+++ b/drivers/net/dsa/sja1105/sja1105_vl.c
@@ -3,7 +3,7 @@
  */
 #include <net/tc_act/tc_gate.h>
 #include <linux/dsa/8021q.h>
-#include "sja1105.h"
+#include "sja1105_vl.h"
 
 #define SJA1105_SIZE_VL_STATUS			8
 
diff --git a/drivers/net/dsa/sja1105/sja1105_vl.h b/drivers/net/dsa/sja1105/sja1105_vl.h
index 323fa0535af7..173d78963fed 100644
--- a/drivers/net/dsa/sja1105/sja1105_vl.h
+++ b/drivers/net/dsa/sja1105/sja1105_vl.h
@@ -4,6 +4,8 @@
 #ifndef _SJA1105_VL_H
 #define _SJA1105_VL_H
 
+#include "sja1105.h"
+
 #if IS_ENABLED(CONFIG_NET_DSA_SJA1105_VL)
 
 int sja1105_vl_redirect(struct sja1105_private *priv, int port,
-- 
2.25.1

