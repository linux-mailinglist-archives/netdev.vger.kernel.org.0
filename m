Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE18ECE84
	for <lists+netdev@lfdr.de>; Sat,  2 Nov 2019 12:44:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726554AbfKBLov (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 2 Nov 2019 07:44:51 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:36023 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726163AbfKBLov (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 2 Nov 2019 07:44:51 -0400
Received: by mail-pf1-f194.google.com with SMTP id v19so8797162pfm.3;
        Sat, 02 Nov 2019 04:44:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=rzWL+hAxC2iURjLjtw57tQnderpopP1O5i0c1dhzA0Q=;
        b=qCYV37fL/9le4oEMegVwCWSrWxYsX1vYoh+YPOMRTNznpEFk10wfg85McyOWj9gmJb
         ajoH/Zt4FvcnHMM3zNIErcXpO0tNbs4Me++ZVaxuvEGm88zKm2RYY7+IDiqaRWVkRHRc
         Djpcb/oqiExRH5GCiaQ1G7ras988F1tWBrGjLRF2f9/lTckSo3NC6Uf2RdxgA5xXvKXV
         IdYFcnnNgGAp+dGlFxTcfs8K0Qy5jlqLBHOF8YO17RYtSHgLJAxmkBKDy3J+DVRlV6eJ
         ArzQMLwpv7+20sjUL7EIfGVSDe+m/Y09WQOUEsJsaIJTJw++jvKVvq3zNzqQOrOMnG/3
         SAsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=rzWL+hAxC2iURjLjtw57tQnderpopP1O5i0c1dhzA0Q=;
        b=Gjs6aES0M/vcvojbZOQY5wxR1oV34Ik9uwZ8MSUcMRpSG/fIRC95yD06a3D7U8I2ld
         5Bk32772ltmQrCcTzZCTTZqHbGoDEmODVW5ww+k7Wd5XkubQmfGELpjAWa55Rqow4R5d
         IYH7wGCv2K472zDb5ITOVbxKYKNtx5+peigZ2wFAmMb8oGwOevGCIWrCXtyuMoXt+Oe7
         Nt+qfKv767g/PXdu7Gsamk4O8Aj5OaLbtf5r4BC+n9az93lDIdjEu9A7XImMASDxkBI9
         ZcptXa/L7DKiO79HzRZEkNXyMBCL+yc1sKzHXgl+6BTCbJvmAEdJqqCsA5AJgtURP8Hn
         fTOA==
X-Gm-Message-State: APjAAAUTBLj0OgO1FDsnBripTxgXpsh1+g3jEojmt74mHp9A+5lHQMUa
        EKTPCJ5G/+VvGEb1z44kmGI=
X-Google-Smtp-Source: APXvYqxhR2X4yuBMnd/+ilsOWbf5zm4q56yfuu9p3l9KOMHvy7GIAzNfUaZrkIfNWO7rybK/nlndsw==
X-Received: by 2002:a63:7247:: with SMTP id c7mr19407548pgn.311.1572695090305;
        Sat, 02 Nov 2019 04:44:50 -0700 (PDT)
Received: from nishad ([2401:4900:36c3:b226:e981:2e26:83a4:d2df])
        by smtp.gmail.com with ESMTPSA id s13sm6374879pfe.94.2019.11.02.04.44.46
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 02 Nov 2019 04:44:49 -0700 (PDT)
Date:   Sat, 2 Nov 2019 17:14:42 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Yisen Zhuang <yisen.zhuang@huawei.com>,
        Salil Mehta <salil.mehta@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: hns3: Use the correct style for SPDX License Identifier
Message-ID: <20191102114436.GA4375@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style in
header files related to Hisilicon network devices. For C header files
Documentation/process/license-rules.rst mandates C-like comments
(opposed to C source files where C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/ethernet/hisilicon/hns3/hnae3.h             | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h         | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h  | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h  | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h | 2 +-
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h   | 2 +-
 7 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hnae3.h b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
index e48023643f4c..016b834c202e 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hnae3.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hnae3.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 // Copyright (c) 2016-2017 Hisilicon Limited.
 
 #ifndef __HNAE3_H
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
index 0725dc52341e..4ee9f5a124f6 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3_enet.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 // Copyright (c) 2016-2017 Hisilicon Limited.
 
 #ifndef __HNS3_ENET_H
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
index 919911fe02ae..5579ac991545 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_cmd.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 // Copyright (c) 2016-2017 Hisilicon Limited.
 
 #ifndef __HCLGE_CMD_H
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h
index 278f21e02736..b04702e65689 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_dcb.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 // Copyright (c) 2016-2017 Hisilicon Limited.
 
 #ifndef __HCLGE_DCB_H__
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
index 9e59f0e074be..844a9e2e526c 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 // Copyright (c) 2016-2017 Hisilicon Limited.
 
 #ifndef __HCLGE_MAIN_H
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
index ef095d9c566f..dd9a1218a7b0 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_mdio.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 // Copyright (c) 2016-2017 Hisilicon Limited.
 
 #ifndef __HCLGE_MDIO_H
diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
index 95ef6e1204cf..45bcb67f90fd 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_tm.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0+
+/* SPDX-License-Identifier: GPL-2.0+ */
 // Copyright (c) 2016-2017 Hisilicon Limited.
 
 #ifndef __HCLGE_TM_H
-- 
2.17.1

