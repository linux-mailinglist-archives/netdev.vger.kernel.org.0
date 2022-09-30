Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5F21F5F164B
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 00:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232775AbiI3WqC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 18:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232760AbiI3Wp5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 18:45:57 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 999481C934C
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 15:45:53 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id g8so4393374iob.0
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 15:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=Ffl2rBL/CAul7r1Sahb9q5pSjjryBRAHq+nIonW6JE0=;
        b=QBMgy2RLBsmD58YotXztPMiKQ78qdclN7Wl30qtjRO36Y7fbuA2BR/T63742Clqn3+
         CnRJueCtHoM2OkyNaJxgliWPet6XXOmiqNHUrbiTfPzbddwtDaIO7q8WEd1mH8kyPcwc
         XYuRWWc0+fwOJrs2V1Ivg7Tm6WSZYPlpdHeQmUeR85YoPQzwqRVwRo3E3Rj4ERjnm2eg
         eILtxgyz3+LJtG4XVvMj3hg58pFcbZ5W1BmXG9O/bFou+GMHEv4N8HVGt2pvHLlAEZoK
         eQS/mGSJer8K5JgjSYgK9pt754J5qjcghhZUEF+gNsAiFPombIbfwJQSvwJ1+fRNy1iZ
         7Jxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=Ffl2rBL/CAul7r1Sahb9q5pSjjryBRAHq+nIonW6JE0=;
        b=dhJanGHC2sB/oHccQgmgGISCTNj/oOdXpKjoZbxoIN3/b7jULzcr40DeBr8TZC8wVL
         gZJhKLz2g8HhE6TX/fv0fjXBniz5sTrVk1znVbolYya/t1g2IKZigiKLeB5VZwvSFnlG
         ORctSLVO8eglpCfro/fz5X7z+hWBq/4TIqArdb1MP4MnPj547cqZkH4vOg1CyaoGAuyd
         EfK7zCTIrixxzJ8/7i61m7PMOwLTf+Ul32ZbGu/vnZ6FZeHG5r2+kHrEhyjTH6EeEPmV
         b3dpkJLvE+DeEZvcyAdOQGxz2aiCg3wboZMpy089NT5ae/p1hE+H1MYCa2JmjYOXxTg/
         IOLg==
X-Gm-Message-State: ACrzQf3gPjR/ROjI4XVVOQ4G2yXL9H+lqzUd385WW+OJJfVcwI3t+rQW
        Oq1F7basyHim0xEN+knG+xfQtA==
X-Google-Smtp-Source: AMsMyM71Jm/PG1htrvas7razpRUPAjrQ8sUkpcuXvLA1kM/Vyb8MovuyXPrMrtKH9gv8JfUhnz7Ozg==
X-Received: by 2002:a05:6602:491:b0:672:18ce:8189 with SMTP id y17-20020a056602049100b0067218ce8189mr4931392iov.170.1664577952677;
        Fri, 30 Sep 2022 15:45:52 -0700 (PDT)
Received: from localhost.localdomain ([98.61.227.136])
        by smtp.gmail.com with ESMTPSA id z5-20020a05663822a500b0035a723e5b23sm1382383jas.7.2022.09.30.15.45.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Sep 2022 15:45:52 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com
Cc:     mka@chromium.org, evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next] net: ipa: update copyrights
Date:   Fri, 30 Sep 2022 17:45:49 -0500
Message-Id: <20220930224549.3503434-1-elder@linaro.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some source files state copyright dates that are earlier than the
last modification of the file.  Change the copyright year to 2022 in
all such cases.

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/gsi.c           | 2 +-
 drivers/net/ipa/gsi.h           | 2 +-
 drivers/net/ipa/gsi_private.h   | 2 +-
 drivers/net/ipa/gsi_reg.h       | 2 +-
 drivers/net/ipa/gsi_trans.c     | 2 +-
 drivers/net/ipa/gsi_trans.h     | 2 +-
 drivers/net/ipa/ipa.h           | 2 +-
 drivers/net/ipa/ipa_cmd.c       | 2 +-
 drivers/net/ipa/ipa_cmd.h       | 2 +-
 drivers/net/ipa/ipa_data.h      | 2 +-
 drivers/net/ipa/ipa_endpoint.c  | 2 +-
 drivers/net/ipa/ipa_endpoint.h  | 2 +-
 drivers/net/ipa/ipa_interrupt.c | 2 +-
 drivers/net/ipa/ipa_interrupt.h | 2 +-
 drivers/net/ipa/ipa_main.c      | 2 +-
 drivers/net/ipa/ipa_mem.c       | 2 +-
 drivers/net/ipa/ipa_modem.c     | 2 +-
 drivers/net/ipa/ipa_modem.h     | 2 +-
 drivers/net/ipa/ipa_power.c     | 2 +-
 drivers/net/ipa/ipa_power.h     | 2 +-
 drivers/net/ipa/ipa_qmi.c       | 2 +-
 drivers/net/ipa/ipa_qmi.h       | 2 +-
 drivers/net/ipa/ipa_qmi_msg.c   | 2 +-
 drivers/net/ipa/ipa_qmi_msg.h   | 2 +-
 drivers/net/ipa/ipa_reg.c       | 2 +-
 drivers/net/ipa/ipa_reg.h       | 2 +-
 drivers/net/ipa/ipa_resource.c  | 2 +-
 drivers/net/ipa/ipa_smp2p.c     | 2 +-
 drivers/net/ipa/ipa_smp2p.h     | 2 +-
 drivers/net/ipa/ipa_sysfs.c     | 2 +-
 drivers/net/ipa/ipa_sysfs.h     | 2 +-
 drivers/net/ipa/ipa_table.c     | 2 +-
 drivers/net/ipa/ipa_table.h     | 2 +-
 drivers/net/ipa/ipa_uc.c        | 2 +-
 drivers/net/ipa/ipa_uc.h        | 2 +-
 drivers/net/ipa/ipa_version.h   | 2 +-
 36 files changed, 36 insertions(+), 36 deletions(-)

diff --git a/drivers/net/ipa/gsi.c b/drivers/net/ipa/gsi.c
index f8036ee78647f..96b7c08d4a45e 100644
--- a/drivers/net/ipa/gsi.c
+++ b/drivers/net/ipa/gsi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2021 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/gsi.h b/drivers/net/ipa/gsi.h
index 0fc25a6ae006c..49dcadba4e0b9 100644
--- a/drivers/net/ipa/gsi.h
+++ b/drivers/net/ipa/gsi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2021 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #ifndef _GSI_H_
 #define _GSI_H_
diff --git a/drivers/net/ipa/gsi_private.h b/drivers/net/ipa/gsi_private.h
index af4cc13864e21..ccfcbe73f80f8 100644
--- a/drivers/net/ipa/gsi_private.h
+++ b/drivers/net/ipa/gsi_private.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #ifndef _GSI_PRIVATE_H_
 #define _GSI_PRIVATE_H_
diff --git a/drivers/net/ipa/gsi_reg.h b/drivers/net/ipa/gsi_reg.h
index b36fd10a57d69..3763359f208f7 100644
--- a/drivers/net/ipa/gsi_reg.h
+++ b/drivers/net/ipa/gsi_reg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2015-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2021 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #ifndef _GSI_REG_H_
 #define _GSI_REG_H_
diff --git a/drivers/net/ipa/gsi_trans.c b/drivers/net/ipa/gsi_trans.c
index 03e54fc4376a6..dff08e00daf50 100644
--- a/drivers/net/ipa/gsi_trans.c
+++ b/drivers/net/ipa/gsi_trans.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/gsi_trans.h b/drivers/net/ipa/gsi_trans.h
index af8c4c6719d11..52f0ec59b64a9 100644
--- a/drivers/net/ipa/gsi_trans.h
+++ b/drivers/net/ipa/gsi_trans.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 #ifndef _GSI_TRANS_H_
 #define _GSI_TRANS_H_
diff --git a/drivers/net/ipa/ipa.h b/drivers/net/ipa/ipa.h
index 349643cf2b442..09ead433ec38e 100644
--- a/drivers/net/ipa/ipa.h
+++ b/drivers/net/ipa/ipa.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #ifndef _IPA_H_
 #define _IPA_H_
diff --git a/drivers/net/ipa/ipa_cmd.c b/drivers/net/ipa/ipa_cmd.c
index f762d7d5f31fa..9eed45f1035de 100644
--- a/drivers/net/ipa/ipa_cmd.c
+++ b/drivers/net/ipa/ipa_cmd.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2021 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/ipa_cmd.h b/drivers/net/ipa/ipa_cmd.h
index 9215ddad10107..8e4243c1f0bbe 100644
--- a/drivers/net/ipa/ipa_cmd.h
+++ b/drivers/net/ipa/ipa_cmd.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 #ifndef _IPA_CMD_H_
 #define _IPA_CMD_H_
diff --git a/drivers/net/ipa/ipa_data.h b/drivers/net/ipa/ipa_data.h
index e15eb3cd3e333..664a568a1382e 100644
--- a/drivers/net/ipa/ipa_data.h
+++ b/drivers/net/ipa/ipa_data.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2021 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 #ifndef _IPA_DATA_H_
 #define _IPA_DATA_H_
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index 0da02d8d238d1..7e76643d64f23 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2021 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/ipa_endpoint.h b/drivers/net/ipa/ipa_endpoint.h
index 28e0a7386fd72..d8dfa24f52140 100644
--- a/drivers/net/ipa/ipa_endpoint.h
+++ b/drivers/net/ipa/ipa_endpoint.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 #ifndef _IPA_ENDPOINT_H_
 #define _IPA_ENDPOINT_H_
diff --git a/drivers/net/ipa/ipa_interrupt.c b/drivers/net/ipa/ipa_interrupt.c
index d0142b17a2757..c269432f9c2ee 100644
--- a/drivers/net/ipa/ipa_interrupt.c
+++ b/drivers/net/ipa/ipa_interrupt.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2014-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 
 /* DOC: IPA Interrupts
diff --git a/drivers/net/ipa/ipa_interrupt.h b/drivers/net/ipa/ipa_interrupt.h
index 231390cea52a2..f31fd9965fdc6 100644
--- a/drivers/net/ipa/ipa_interrupt.h
+++ b/drivers/net/ipa/ipa_interrupt.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #ifndef _IPA_INTERRUPT_H_
 #define _IPA_INTERRUPT_H_
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index a0f6212aa3c35..3461ad3029ab8 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2021 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/ipa_mem.c b/drivers/net/ipa/ipa_mem.c
index 9abf473be1dd0..f84c6830495a4 100644
--- a/drivers/net/ipa/ipa_mem.c
+++ b/drivers/net/ipa/ipa_mem.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2021 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index c8b1c4d9c5073..423422a2a445f 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2014-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2021 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 
 #include <linux/errno.h>
diff --git a/drivers/net/ipa/ipa_modem.h b/drivers/net/ipa/ipa_modem.h
index e64ccc2402e9d..d85718db9a575 100644
--- a/drivers/net/ipa/ipa_modem.h
+++ b/drivers/net/ipa/ipa_modem.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #ifndef _IPA_MODEM_H_
 #define _IPA_MODEM_H_
diff --git a/drivers/net/ipa/ipa_power.c b/drivers/net/ipa/ipa_power.c
index db5ac7552286e..8420f93128a26 100644
--- a/drivers/net/ipa/ipa_power.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2021 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 
 #include <linux/clk.h>
diff --git a/drivers/net/ipa/ipa_power.h b/drivers/net/ipa/ipa_power.h
index 6f84f057a2095..896f052e51a1c 100644
--- a/drivers/net/ipa/ipa_power.h
+++ b/drivers/net/ipa/ipa_power.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #ifndef _IPA_POWER_H_
 #define _IPA_POWER_H_
diff --git a/drivers/net/ipa/ipa_qmi.c b/drivers/net/ipa/ipa_qmi.c
index 6f874f99b910c..8295fd4b70d16 100644
--- a/drivers/net/ipa/ipa_qmi.c
+++ b/drivers/net/ipa/ipa_qmi.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2013-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/ipa_qmi.h b/drivers/net/ipa/ipa_qmi.h
index 856ef629ccc8d..1c236826c17ab 100644
--- a/drivers/net/ipa/ipa_qmi.h
+++ b/drivers/net/ipa/ipa_qmi.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #ifndef _IPA_QMI_H_
 #define _IPA_QMI_H_
diff --git a/drivers/net/ipa/ipa_qmi_msg.c b/drivers/net/ipa/ipa_qmi_msg.c
index 75d3fc0092e92..97c0befe8d86f 100644
--- a/drivers/net/ipa/ipa_qmi_msg.c
+++ b/drivers/net/ipa/ipa_qmi_msg.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #include <linux/stddef.h>
 #include <linux/soc/qcom/qmi.h>
diff --git a/drivers/net/ipa/ipa_qmi_msg.h b/drivers/net/ipa/ipa_qmi_msg.h
index 9651aa59b5968..e29663965f434 100644
--- a/drivers/net/ipa/ipa_qmi_msg.h
+++ b/drivers/net/ipa/ipa_qmi_msg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #ifndef _IPA_QMI_MSG_H_
 #define _IPA_QMI_MSG_H_
diff --git a/drivers/net/ipa/ipa_reg.c b/drivers/net/ipa/ipa_reg.c
index fb4663bcf14bd..22f067741d9b2 100644
--- a/drivers/net/ipa/ipa_reg.c
+++ b/drivers/net/ipa/ipa_reg.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 
 #include <linux/io.h>
diff --git a/drivers/net/ipa/ipa_reg.h b/drivers/net/ipa/ipa_reg.h
index f81381891a2e4..bd28e2aee59b4 100644
--- a/drivers/net/ipa/ipa_reg.h
+++ b/drivers/net/ipa/ipa_reg.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2021 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 #ifndef _IPA_REG_H_
 #define _IPA_REG_H_
diff --git a/drivers/net/ipa/ipa_resource.c b/drivers/net/ipa/ipa_resource.c
index 5376b71f45984..a257f0e5e3618 100644
--- a/drivers/net/ipa/ipa_resource.c
+++ b/drivers/net/ipa/ipa_resource.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2021 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/ipa_smp2p.c b/drivers/net/ipa/ipa_smp2p.c
index 2112336120391..5620dc271fac3 100644
--- a/drivers/net/ipa/ipa_smp2p.c
+++ b/drivers/net/ipa/ipa_smp2p.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/ipa_smp2p.h b/drivers/net/ipa/ipa_smp2p.h
index 59cee31a73836..9b969b03d1a4b 100644
--- a/drivers/net/ipa/ipa_smp2p.h
+++ b/drivers/net/ipa/ipa_smp2p.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 #ifndef _IPA_SMP2P_H_
 #define _IPA_SMP2P_H_
diff --git a/drivers/net/ipa/ipa_sysfs.c b/drivers/net/ipa/ipa_sysfs.c
index c0c8641cdd14a..5cbc15a971f9d 100644
--- a/drivers/net/ipa/ipa_sysfs.c
+++ b/drivers/net/ipa/ipa_sysfs.c
@@ -1,6 +1,6 @@
 // SPDX-License-Identifier: GPL-2.0
 
-/* Copyright (C) 2021 Linaro Ltd. */
+/* Copyright (C) 2021-2022 Linaro Ltd. */
 
 #include <linux/kernel.h>
 #include <linux/types.h>
diff --git a/drivers/net/ipa/ipa_sysfs.h b/drivers/net/ipa/ipa_sysfs.h
index 4a3ffd1e4e3fb..58ba22810bab4 100644
--- a/drivers/net/ipa/ipa_sysfs.h
+++ b/drivers/net/ipa/ipa_sysfs.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2021 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 #ifndef _IPA_SYSFS_H_
 #define _IPA_SYSFS_H_
diff --git a/drivers/net/ipa/ipa_table.c b/drivers/net/ipa/ipa_table.c
index 02cab1b59f21a..510ff2dc8999a 100644
--- a/drivers/net/ipa/ipa_table.c
+++ b/drivers/net/ipa/ipa_table.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2021 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/ipa_table.h b/drivers/net/ipa/ipa_table.h
index 1538e2e1732fe..395189f75d784 100644
--- a/drivers/net/ipa/ipa_table.h
+++ b/drivers/net/ipa/ipa_table.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2021 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 #ifndef _IPA_TABLE_H_
 #define _IPA_TABLE_H_
diff --git a/drivers/net/ipa/ipa_uc.c b/drivers/net/ipa/ipa_uc.c
index cf21f1a87a880..f0ee472810153 100644
--- a/drivers/net/ipa/ipa_uc.c
+++ b/drivers/net/ipa/ipa_uc.c
@@ -1,7 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2018-2020 Linaro Ltd.
+ * Copyright (C) 2018-2022 Linaro Ltd.
  */
 
 #include <linux/types.h>
diff --git a/drivers/net/ipa/ipa_uc.h b/drivers/net/ipa/ipa_uc.h
index 23847f934d64e..8514096e6f36f 100644
--- a/drivers/net/ipa/ipa_uc.h
+++ b/drivers/net/ipa/ipa_uc.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 #ifndef _IPA_UC_H_
 #define _IPA_UC_H_
diff --git a/drivers/net/ipa/ipa_version.h b/drivers/net/ipa/ipa_version.h
index 58f7b43b4db3b..7870e0cc3d7c9 100644
--- a/drivers/net/ipa/ipa_version.h
+++ b/drivers/net/ipa/ipa_version.h
@@ -1,7 +1,7 @@
 /* SPDX-License-Identifier: GPL-2.0 */
 
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
- * Copyright (C) 2019-2020 Linaro Ltd.
+ * Copyright (C) 2019-2022 Linaro Ltd.
  */
 #ifndef _IPA_VERSION_H_
 #define _IPA_VERSION_H_
-- 
2.34.1

