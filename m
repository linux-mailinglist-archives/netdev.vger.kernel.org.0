Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54CCB2EA7BB
	for <lists+netdev@lfdr.de>; Tue,  5 Jan 2021 10:39:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728602AbhAEJgp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Jan 2021 04:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727260AbhAEJgo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Jan 2021 04:36:44 -0500
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD3EBC061574;
        Tue,  5 Jan 2021 01:36:03 -0800 (PST)
Received: by mail-wr1-x42e.google.com with SMTP id c5so35454581wrp.6;
        Tue, 05 Jan 2021 01:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=CBEgq3lGKdv8uL6EZCtDkPUPdtOI/LvqjfEie+xNIH4=;
        b=HJiFrO0cyFUE3EdhkZ9ieByRFQCmu2tX+0L8OoIw4Wob2ig1rJoDxLCjxIQnyLdkES
         SioIrCKKqRUCdIYJRnHHT7DH2PlW/UdIRpSfWuZwCmLdKhc/OUZpvSuRfBlbneWGJyz7
         ZpTpMHZr6MH21FebXJKTorOtdY/31zxbsf5Oig5Tf7niL6jH0Jca7W5tA9EZaHf7eFrf
         s8GfCy82KvLI/Z3W+VmSKjwi6MWD0zldc+X9455cJLoiLVNFmAuolk+7rC2oCndiGKB2
         dSf4ivxSDbGtUAPA+FpgOuqJARYz4fUdzftUMx+JZT7jv1z3acWwet08NEa4KajaJGVY
         ua/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=CBEgq3lGKdv8uL6EZCtDkPUPdtOI/LvqjfEie+xNIH4=;
        b=WIpM7WD9q9hXlBAPvdZY4Ye7JhmXUtjBbt/LSz+jpJseNDF/33i/zLe4q6c8Y8fJXO
         +xQnSi/xBAhPKVe+JZaWOdCgoNlzpmJ9IukvUcKI4/YhyenUBtr6shgh8VwC29Eww12X
         a2i3daHDaUFRW+Xtu9mZyYuuuk5PlkLITumYNyb/WYfdoVu0FWy5T2RLKJ1WO5XZ/axI
         2kj5DwrOhuW7LliaLNLfKwoM86LDk23pmuXFIRlPz7FH6zOTBTjA1PQ5cnEKMb0lS+nS
         CQ67WytgHHwDAMxIO0W58UKVSUlyWPqrUm2HI5efh8JAwmoJBpeQ3rz+NeXTbmlqfa0P
         heaw==
X-Gm-Message-State: AOAM533ki9cTmSRAdSw4rMEBDwz9c/GWU6E1ukAi52QxSoiQnfzyXK/A
        5OiwhUJiAGl9NaRPf5CU0c0=
X-Google-Smtp-Source: ABdhPJzbwhnvkmHNN5DP1N2v4XP1Us0fHF241cvauNZBE+WGFQnXleX6Na2ODfxxGTIz0yr5/IiMsg==
X-Received: by 2002:adf:e512:: with SMTP id j18mr83068277wrm.52.1609839361280;
        Tue, 05 Jan 2021 01:36:01 -0800 (PST)
Received: from felia.fritz.box ([2001:16b8:2d99:1a00:4199:29a0:95cf:5dfe])
        by smtp.gmail.com with ESMTPSA id j10sm3532540wmj.7.2021.01.05.01.36.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 05 Jan 2021 01:36:00 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
To:     George Cherian <george.cherian@marvell.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org
Cc:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha Sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Randy Dunlap <rdunlap@infradead.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>
Subject: [PATCH] docs: octeontx2: tune rst markup
Date:   Tue,  5 Jan 2021 10:35:53 +0100
Message-Id: <20210105093553.31879-1-lukas.bulwahn@gmail.com>
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
applies cleanly on current master (v5.11-rc2) and next-20201205

George, please ack.
Jonathan, please pick this minor formatting clean-up patch.

 .../ethernet/marvell/octeontx2.rst            | 59 +++++++++++--------
 1 file changed, 34 insertions(+), 25 deletions(-)

diff --git a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
index d3fcf536d14e..00bdc10fe2b8 100644
--- a/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
+++ b/Documentation/networking/device_drivers/ethernet/marvell/octeontx2.rst
@@ -165,45 +165,54 @@ Devlink health reporters
 NPA Reporters
 -------------
 The NPA reporters are responsible for reporting and recovering the following group of errors
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
+For eg::
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

