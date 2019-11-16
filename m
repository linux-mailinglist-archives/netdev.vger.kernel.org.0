Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 50ADDFEB5F
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 10:43:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726918AbfKPJlI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 04:41:08 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:36393 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726257AbfKPJlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 04:41:08 -0500
Received: by mail-pj1-f68.google.com with SMTP id cq11so281604pjb.3;
        Sat, 16 Nov 2019 01:41:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=qiKpDqxor3KUPMlSYGxk73RwYW/8ZTPLFV2q2AOqPwA=;
        b=W0ha5aHVkIGBLHwz/gdctkLmI4Oql1roTIHHOzCoD2VoPA6H+wa/xnBl+cs8UD5BOM
         TqAAMleVYFKgE2Fh9xJGTXJI+98T1GYERAcv8VsFeRYFOv9E3ABzxWRepgCXeTf0qvHG
         TpGjaFD0g0tdxsfZaFCTEbp6AdWP/Sl4yKGW4Qzun0mjABtnyHTIS4jeWCNU4zs1qKfN
         oO3rDQh9uMU9bDV92eZUvEnJZsEfyb+l0D8nfKPdWsliLYKJOodSv+T3soY8EXSfn8LX
         kwkoWAoO9zMkkLsIaqzq1+quFn+N8iuofy4HbNUqvGUavZmmx4JzID4nyCsj8j9A7pOa
         Dafg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=qiKpDqxor3KUPMlSYGxk73RwYW/8ZTPLFV2q2AOqPwA=;
        b=Ok0oRygxD8b6BpY2+FT6U4TlZ1IZeyp6cfcUUhWlcBYi/H8cOSiLSLqzdp4Trf604p
         uPwmVLatqOcKnHSQZ5qA5qdN1inOVfnPxp1ZoliNKaogyKv3wo6m6YcPrsxE1OAFDoFg
         SFbTDmurPs+RnhXvMCKQLoEbZBSWdKiQVlQ9rApTOWBHCPdW85ZsPlzT2yQTu0iwf53C
         w44RbeSg34grl9t0G4irqfCV4D+QX9banAlQ4NkNTy5YcTjXp3HexF38rubd40jmLkQr
         9CKLGsKbiY8pCEY0V59Qxus6mE895M0CQnLloWylnM7Bk2rgZc80+JofSpSrq2nEZaqH
         CY4A==
X-Gm-Message-State: APjAAAUpMf208Fry1A72Nz/zWF7y9nQV65DGetGfilLIbGplaV+ssfcB
        pCmEXDY/4hZchV432fUVccM=
X-Google-Smtp-Source: APXvYqyW6+jLj/VO7pVPjaOQjAqUjgSvy7AbiRgLXW2biey8wHyiwFbIYDRR3iLvuMHbxUJ9v7EUHQ==
X-Received: by 2002:a17:902:547:: with SMTP id 65mr19631123plf.239.1573897267640;
        Sat, 16 Nov 2019 01:41:07 -0800 (PST)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id q70sm16531609pjq.26.2019.11.16.01.41.03
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Nov 2019 01:41:07 -0800 (PST)
Date:   Sat, 16 Nov 2019 15:10:59 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: stmmac: Use the correct style for SPDX License
 Identifier
Message-ID: <20191116094055.GA4863@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style in
header files related to STMicroelectronics based Multi-Gigabit
Ethernet driver. For C header files Documentation/process/license-rules.rst
mandates C-like comments (opposed to C source files where
C++ style should be used).

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/ethernet/stmicro/stmmac/dwmac5.h   | 2 +-
 drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h | 2 +-
 drivers/net/ethernet/stmicro/stmmac/hwif.h     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
index 775db776b3cc..23fecf68f781 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwmac5.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 // Copyright (c) 2017 Synopsys, Inc. and/or its affiliates.
 // stmmac Support for 5.xx Ethernet QoS cores
 
diff --git a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
index 99037386080a..9d08a934fe4f 100644
--- a/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
+++ b/drivers/net/ethernet/stmicro/stmmac/dwxgmac2.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 /*
  * Copyright (c) 2018 Synopsys, Inc. and/or its affiliates.
  * stmmac XGMAC definitions.
diff --git a/drivers/net/ethernet/stmicro/stmmac/hwif.h b/drivers/net/ethernet/stmicro/stmmac/hwif.h
index 509daeefdb79..aa5b917398fe 100644
--- a/drivers/net/ethernet/stmicro/stmmac/hwif.h
+++ b/drivers/net/ethernet/stmicro/stmmac/hwif.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: (GPL-2.0 OR MIT)
+/* SPDX-License-Identifier: (GPL-2.0 OR MIT) */
 // Copyright (c) 2018 Synopsys, Inc. and/or its affiliates.
 // stmmac HW Interface Callbacks
 
-- 
2.17.1

