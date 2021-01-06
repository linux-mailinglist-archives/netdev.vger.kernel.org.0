Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 800C62EC0F6
	for <lists+netdev@lfdr.de>; Wed,  6 Jan 2021 17:18:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727365AbhAFQSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jan 2021 11:18:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727273AbhAFQSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jan 2021 11:18:24 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E767C06134C;
        Wed,  6 Jan 2021 08:17:44 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c5so2930158wrp.6;
        Wed, 06 Jan 2021 08:17:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=d3NVlNatfm0P1wuR1e8ONPfbyHqMhsXuVlJCZwTJO1A=;
        b=EaUpeLMszQu8MNpCM/62eyGBU/TZRVH8o1qDP40DTXR3cU8Y/NVqm512GZxetz3vjS
         TcY7n8A/6Z/G6MMoC8Mg+wpWayx1TrIw+q797er4/7sSdK0VLq71sigWi8d8tlSqa4e/
         11iw16GSnlWZ4GJnh9zVpaDKql/nopwX/oRsSgb+iaJEjtKZy0YPWmaiI2caqtMSZrxG
         YUQieTZB4ebeDLhJK2Dnf+fDEQXkkU3LRnySCjEb1I8ahjjmPWQA79FLsFnsSVnjOUWa
         6aWxsdWZ+94DPyw2rbQXGA0LCH3VLX5am64XaIIKdCFThBXkFuOtMc1lmTHiqqXEIwJV
         KYWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=d3NVlNatfm0P1wuR1e8ONPfbyHqMhsXuVlJCZwTJO1A=;
        b=DpalVC38ni8arI0KzO0lXYebN9h+ogLRHSZsQJFOQFldZSOxyzHg93U7A/wo5NlqB1
         Hf+cmTPGtmrxztoEjBHCw4/s9o9mQiFQ7MnsI28GGwGGUBSbfUayIB9nDBWjUtyDiaa5
         UH6tBFpgLI/5+hFiJnFO1isMEB2CAeBD/LLyh0+0ixZVPXOWonTZL6qhiazOg1U92S6P
         F5c1nGr267PvmGbM8IuHb7cdhylet68zMCyaTTYdM6nWkIKD39FRHQWV/K2HzsYlLejY
         ugDvowvla7iIP5ftfWJTxLufSCef81cBweDb6ZlSNAuXvIjldMkA3e0mDLRnezSYitDk
         7tYw==
X-Gm-Message-State: AOAM532qPtuZKruSVbVcb7a978kcIXKRueL+PMmLYyhYjls9+osFhg7t
        mcBb3NONzA7IoyKA/aiqeus=
X-Google-Smtp-Source: ABdhPJwDZBbwhW3R7r/kMRQ6y3srhWrUH1dlXd8rPSbWPsHdQ57pGfZgg67rcf/09oSiVyFSfHUUBA==
X-Received: by 2002:adf:902a:: with SMTP id h39mr4927486wrh.147.1609949862778;
        Wed, 06 Jan 2021 08:17:42 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2db6:2e00:1065:c83e:b188:32c2])
        by smtp.gmail.com with ESMTPSA id o13sm4151928wrh.88.2021.01.06.08.17.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 08:17:42 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     George Cherian <george.cherian@marvell.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha Sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH v2] docs: octeontx2: tune rst markup
Date:   Wed,  6 Jan 2021 17:17:35 +0100
Message-Id: <20210106161735.21751-1-lukas.bulwahn@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 80b9414832a1 ("docs: octeontx2: Add Documentation for NPA health
reporters") added new documentation with improper formatting for rst, and
caused a few new warnings for make htmldocs in octeontx2.rst:169--202.

Tune markup and formatting for better presentation in the HTML view.

Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
---
v1 -> v2: minor stylistic tuning as suggested by Randy

applies cleanly on current master (v5.11-rc2) and next-20210106

George, please ack.
Jonathan, please pick this minor formatting clean-up patch.

 .../ethernet/marvell/octeontx2.rst            | 62 +++++++++++--------
 1 file changed, 36 insertions(+), 26 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
index d3fcf536d14e..61e850460e18 100644
--- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
+++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
@@ -164,46 +164,56 @@ Devlink health reporters
 
 NPA Reporters
 -------------
-The NPA reporters are responsible for reporting and recovering the following group of errors
+The NPA reporters are responsible for reporting and recovering the following group of errors:
+
 1. GENERAL events
+
    - Error due to operation of unmapped PF.
    - Error due to disabled alloc/free for other HW blocks (NIX, SSO, TIM, DPI and AURA).
+
 2. ERROR events
+
    - Fault due to NPA_AQ_INST_S read or NPA_AQ_RES_S write.
    - AQ Doorbell Error.
+
 3. RAS events
+
    - RAS Error Reporting for NPA_AQ_INST_S/NPA_AQ_RES_S.
+
 4. RVU events
+
    - Error due to unmapped slot.
 
-Sample Output
--------------
-~# devlink health
-pci/0002:01:00.0:
-  reporter hw_npa_intr
-      state healthy error 2872 recover 2872 last_dump_date 2020-12-10 last_dump_time 09:39:09 grace_period 0 auto_recover true auto_dump true
-  reporter hw_npa_gen
-      state healthy error 2872 recover 2872 last_dump_date 2020-12-11 last_dump_time 04:43:04 grace_period 0 auto_recover true auto_dump true
-  reporter hw_npa_err
-      state healthy error 2871 recover 2871 last_dump_date 2020-12-10 last_dump_time 09:39:17 grace_period 0 auto_recover true auto_dump true
-   reporter hw_npa_ras
-      state healthy error 0 recover 0 last_dump_date 2020-12-10 last_dump_time 09:32:40 grace_period 0 auto_recover true auto_dump true
+Sample Output::
+
+	~# devlink health
+	pci/0002:01:00.0:
+	  reporter hw_npa_intr
+	      state healthy error 2872 recover 2872 last_dump_date 2020-12-10 last_dump_time 09:39:09 grace_period 0 auto_recover true auto_dump true
+	  reporter hw_npa_gen
+	      state healthy error 2872 recover 2872 last_dump_date 2020-12-11 last_dump_time 04:43:04 grace_period 0 auto_recover true auto_dump true
+	  reporter hw_npa_err
+	      state healthy error 2871 recover 2871 last_dump_date 2020-12-10 last_dump_time 09:39:17 grace_period 0 auto_recover true auto_dump true
+	   reporter hw_npa_ras
+	      state healthy error 0 recover 0 last_dump_date 2020-12-10 last_dump_time 09:32:40 grace_period 0 auto_recover true auto_dump true
 
 Each reporter dumps the
+
  - Error Type
  - Error Register value
  - Reason in words
 
-For eg:
-~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_gen
- NPA_AF_GENERAL:
-         NPA General Interrupt Reg : 1
-         NIX0: free disabled RX
-~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_intr
- NPA_AF_RVU:
-         NPA RVU Interrupt Reg : 1
-         Unmap Slot Error
-~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_err
- NPA_AF_ERR:
-        NPA Error Interrupt Reg : 4096
-        AQ Doorbell Error
+For example::
+
+	~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_gen
+	 NPA_AF_GENERAL:
+	         NPA General Interrupt Reg : 1
+	         NIX0: free disabled RX
+	~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_intr
+	 NPA_AF_RVU:
+	         NPA RVU Interrupt Reg : 1
+	         Unmap Slot Error
+	~# devlink health dump show  pci/0002:01:00.0 reporter hw_npa_err
+	 NPA_AF_ERR:
+	        NPA Error Interrupt Reg : 4096
+	        AQ Doorbell Error
-- 
2.17.1

