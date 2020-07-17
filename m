Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A0A224037
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726959AbgGQQKt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:10:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726256AbgGQQKp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 12:10:45 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04D77C0619D2;
        Fri, 17 Jul 2020 09:10:45 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id b15so8137459edy.7;
        Fri, 17 Jul 2020 09:10:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=FbYGxcP/Yrk/vgesFSAU9dkekSzyuXuhbycnPIi8KcE=;
        b=LtcCNIYwgHES1T5R1vCeJMAgEGCczap9jEOdYhO/gE80SW15MTdTL8hxlEAF133ay/
         JJN8Na+sfbRaeSgdmTdt+IHdfLw28i9z5rl6a7QPN1lULmuo5vcoylF29SI7bwg1B+hY
         wREWCRL6ZC2b2JtQF/u0aTE2sC5/qV7DO9iXmON/G5MDXdssaknj2VUhnJsBPFCyqnpp
         BDqLpCT3YdYkYhFLXGT81P4yfQ+2Ry3tqGfFgMRrAk9rZmM5yBOHR4ZkjSdstOQAV4Ql
         t1THN5PsiYIfd2GwATfMpNzFVSlC9PJD0dDBRSGO4CL0MJqQXZWwDVslX/3WSQrpyxMZ
         i/7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=FbYGxcP/Yrk/vgesFSAU9dkekSzyuXuhbycnPIi8KcE=;
        b=RptijdXZmsaD04vNS8e1rFcp9yCXQOAm4rWfQETwT5XkIzANwGdDmbuWIGwUOGq1mb
         PeEOOacgM2LCiWhBFCFdYu+5LMj+D++7rUsL+hTn0/P2Xb2yQh0WPUHwZsclf8wfpCNc
         +i6s5hp0Dwl4VQa+k21YqCrsdrDm816/m8H3jjrBl94PAYxckPtGVQKScOOxNBAI4C51
         KJZVRngxcXMRsdk5cMpOkeRIs3a3OEtWDE0+CEN+Tsvwy112iqjjSemJ1FMLjyOtHykT
         PbmcaG9m+sjivRHE5tRz0PjEOUHnx0domWutfRBv0sipdY/7yzdOgUHfjzc8Smi9UzQe
         +xwQ==
X-Gm-Message-State: AOAM532UYDch79vS9KyUmvxMGvkqyVlbYejyCRg41lK77SXvZS5tezwE
        6CHpr+34WpI8XmLpjJx6Shq0QiSU
X-Google-Smtp-Source: ABdhPJxoxHNUBzGn8AEQt3AAj26pGa348dIHZ11YTlEQi8/SeTqVbhumlw8+xRKWEnF1Y0BGPZcJHw==
X-Received: by 2002:a05:6402:204e:: with SMTP id bc14mr10199175edb.128.1595002243624;
        Fri, 17 Jul 2020 09:10:43 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bc23sm8578253edb.90.2020.07.17.09.10.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 09:10:43 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next 1/3] docs: networking: timestamping: rename last section to "Known bugs".
Date:   Fri, 17 Jul 2020 19:10:25 +0300
Message-Id: <20200717161027.1408240-2-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200717161027.1408240-1-olteanv@gmail.com>
References: <20200717161027.1408240-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

One more quirk of the timestamping infrastructure will be documented
shortly. Rename the section from "Other caveats for MAC drivers" to
simply "Known bugs". This uncovers some bad phrasing at the beginning of
the section, which is now corrected.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 Documentation/networking/timestamping.rst | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index 5fa4e2274dd9..9a1f4cb4ce9e 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -711,14 +711,14 @@ discoverable and attachable to a ``struct phy_device`` through Device Tree, and
 for the rest, they use the same mii_ts infrastructure as those. See
 Documentation/devicetree/bindings/ptp/timestamper.txt for more details.
 
-3.2.4 Other caveats for MAC drivers
-^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
-
-Stacked PHCs, especially DSA (but not only) - since that doesn't require any
-modification to MAC drivers, so it is more difficult to ensure correctness of
-all possible code paths - is that they uncover bugs which were impossible to
-trigger before the existence of stacked PTP clocks.  One example has to do with
-this line of code, already presented earlier::
+3.2.4 Known bugs
+^^^^^^^^^^^^^^^^
+
+One caveat with stacked PHCs, especially DSA (but not only) - since that
+doesn't require any modification to MAC drivers, so it is more difficult to
+ensure correctness of all possible code paths - is that they uncover bugs which
+were impossible to trigger before the existence of stacked PTP clocks.
+One example has to do with this line of code, already presented earlier::
 
       skb_shinfo(skb)->tx_flags |= SKBTX_IN_PROGRESS;
 
-- 
2.25.1

