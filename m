Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DCD4618FD8
	for <lists+netdev@lfdr.de>; Fri,  4 Nov 2022 06:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230261AbiKDFKF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Nov 2022 01:10:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiKDFKE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Nov 2022 01:10:04 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D33926C2
        for <netdev@vger.kernel.org>; Thu,  3 Nov 2022 22:09:59 -0700 (PDT)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20221104050956epoutp029e844dade102149c3bfb0ff9638d6651~kSYTDIFx73212332123epoutp02Z
        for <netdev@vger.kernel.org>; Fri,  4 Nov 2022 05:09:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20221104050956epoutp029e844dade102149c3bfb0ff9638d6651~kSYTDIFx73212332123epoutp02Z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1667538596;
        bh=kFXiZY9u9FX3UKuxEiw+Kz+AMuZoZ4ULT/KUjFkXCn0=;
        h=From:To:Cc:Subject:Date:References:From;
        b=fu/K/pikNq5QXbVVfKFE0HJyZqmwnvn/gzC63N1Nr4FQmL0SoprrL5fiJnF9XWvjy
         ErItbocHrI5z6UkDBKx/+JPcUcaYGoJypJwfE3B7DshQQ6ifGQJXE9LOgxFkHsudtv
         j5K/xHOnCqiUTm1D1OK+DA4QJX1tnpR0NXQ7Ahbg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20221104050955epcas5p25a1a29f6c3f40d263d7d248130bdff48~kSYSScPMM1390813908epcas5p2l;
        Fri,  4 Nov 2022 05:09:55 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.174]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4N3TFt0MzPz4x9Q9; Fri,  4 Nov
        2022 05:09:54 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
        04.AF.39477.1AE94636; Fri,  4 Nov 2022 14:09:53 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20221104050835epcas5p21514293206d887aa3d6c746d529dc2f2~kSXHPQVCp0883508835epcas5p2p;
        Fri,  4 Nov 2022 05:08:35 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20221104050835epsmtrp2b0ac17b844e76936b270c2277ef7ebbe~kSXHOPsX10166101661epsmtrp2N;
        Fri,  4 Nov 2022 05:08:35 +0000 (GMT)
X-AuditID: b6c32a4a-259fb70000019a35-b9-63649ea18e0f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A6.CC.18644.35E94636; Fri,  4 Nov 2022 14:08:35 +0900 (KST)
Received: from cheetah.sa.corp.samsungelectronics.net (unknown
        [107.109.115.53]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20221104050833epsmtip28b294adbf295f9083024bf59522d5f68~kSXFRcQwl2150221502epsmtip2g;
        Fri,  4 Nov 2022 05:08:32 +0000 (GMT)
From:   Vivek Yadav <vivek.2311@samsung.com>
To:     rcsekar@samsung.com, wg@grandegger.com, mkl@pengutronix.de,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, pankaj.dubey@samsung.com,
        ravi.patel@samsung.com, alim.akhtar@samsung.com
Cc:     linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vivek Yadav <vivek.2311@samsung.com>
Subject: [PATCH] can: m_can: sort header inclusion alphabetically
Date:   Fri,  4 Nov 2022 10:46:17 +0530
Message-Id: <20221104051617.21173-1-vivek.2311@samsung.com>
X-Mailer: git-send-email 2.17.1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmlu7CeSnJBmv7rS0ezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERl
        22SkJqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAXa2kUJaY
        UwoUCkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM7Y
        11pYMFOs4s6hyywNjLOEuxg5OCQETCQ+3vDpYuTiEBLYzShx6dE/NgjnE6NEb89NKOczo8T3
        HxPYuxg5wTquX93ACpHYxShxfWYbO4TTyiQx/dsHZpAqNgEticedC1hAbBGBu4wS1xZnguxj
        FqiWOHCEDyQsLOAocebiAUYQm0VAVWLHgTdMICW8AtYSR18kQOySl1i94QAzyHgJga/sEjsO
        nWeCSLhIXOj7ywJhC0u8Or4F6jgpic/v9rJB2MkSO/51skLYGRILJu5hhLDtJQ5cmcMCcY6m
        xPpd+hBhWYmpp9aBjWcW4JPo/f0EahWvxI55MLaKxIvPE1ghIScl0XtOGCLsITHj5hKwsJBA
        rMTMA+4TGGVnIcxfwMi4ilEytaA4Nz212LTAKC+1HB5Hyfm5mxjB6VDLawfjwwcf9A4xMnEw
        HmKU4GBWEuH9tC05WYg3JbGyKrUoP76oNCe1+BCjKTDAJjJLiSbnAxNyXkm8oYmlgYmZmZmJ
        pbGZoZI47+IZWslCAumJJanZqakFqUUwfUwcnFINTLz53/5K3p3ollw/61Glpu87hdffdx5i
        WKFd9VoqTnvZooWJs1a8WPt8xi3eGm4ZXkeW+4bMlmG/LA+7/Nm9Pijk3/ytRZ7zchS1RX8U
        TNL/aj3P4c92O6bkWJ3vwhbPV+347qmjfLws3evm2/v/Eh/vMHqRwLAobolMMfOv56uWSfvd
        aJuTVuk76yfjUc6FctfFX5+xt0o7Z30wMSRo5e3cj6KTv3iKv4oo+bjoWO6PmSrmM3YF9vD8
        +6RV/vPknzdsUZ+FVvPaiB/RD2v7c+xCzZmZX69dnST8QVd00YOYrKXch81edtf8YbN69+2w
        EvOjaVqsjbte9ZcUcCdvFF3lJ9Yct8Q3Nu3HekNGtsdKLMUZiYZazEXFiQDASpl9EAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrDLMWRmVeSWpSXmKPExsWy7bCSvG7wvJRkg9lTWSwezNvGZjHnfAuL
        xdNjj9gtLmzrY7VY9X0qs8XlXXPYLNYvmsJicWyBmMW3028YLRZt/cJu8fDDHnaLWRd2sFr8
        WniYxWLpvZ2sDnweW1beZPJYsKnU4+Ol24wem1Z1snn0/zXweL/vKptH35ZVjB6fN8kFcERx
        2aSk5mSWpRbp2yVwZexrLSyYKVZx59BllgbGWcJdjJwcEgImEtevbmDtYuTiEBLYwShx69NT
        doiElMSUMy9ZIGxhiZX/nrNDFDUzSew6chqsiE1AS+Jx5wKwIhGBl4wSLWfZQGxmgXqJd2du
        gtUICzhKnLl4gBHEZhFQldhx4A1TFyMHB6+AtcTRFwkQ8+UlVm84wDyBkWcBI8MqRsnUguLc
        9NxiwwKjvNRyveLE3OLSvHS95PzcTYzgANXS2sG4Z9UHvUOMTByMhxglOJiVRHg/bUtOFuJN
        SaysSi3Kjy8qzUktPsQozcGiJM57oetkvJBAemJJanZqakFqEUyWiYNTqoFp5g7T6S8PzGNu
        L40p9Iqx5ItuOLt7ku3LyF7WsL6Y73XH3K/leqf/C2D4/62zl2HvZKWiPWoLmp52HPqnnu+r
        Efhi4aQJ9VcNpRe0hjjavIsqNK15unBT3aTKdSdzrhq9OjyvY5fEW+cZkT+OuXZ+vb6S+2Z4
        VIb48l0p37nVHb77NkYLy2Z272VPEb1emvPh6Mq+d5unfX9xoUGeLfMt860ChUdzJ33rn+sz
        XUPnk5/qLnczW+9Za6bPcHS5d+rezimWze0PfK1/vsv2ut7K7NHwYY/1px8RBsc+RW6XS5QO
        MqtRKJvsJVogKPFsSQ7jlGYtmfDq5TblG9XlWc7OSrPpadqR/9VFiz1xxTIlluKMREMt5qLi
        RACisYHbvwIAAA==
X-CMS-MailID: 20221104050835epcas5p21514293206d887aa3d6c746d529dc2f2
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20221104050835epcas5p21514293206d887aa3d6c746d529dc2f2
References: <CGME20221104050835epcas5p21514293206d887aa3d6c746d529dc2f2@epcas5p2.samsung.com>
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sort header inclusion alphabetically.

Suggested-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Vivek Yadav <vivek.2311@samsung.com>
---
 drivers/net/can/m_can/m_can.c          |  8 ++++----
 drivers/net/can/m_can/m_can.h          | 16 ++++++++--------
 drivers/net/can/m_can/m_can_platform.c |  2 +-
 3 files changed, 13 insertions(+), 13 deletions(-)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 59deb185fd6b..145f55d4b9b4 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -9,20 +9,20 @@
  */
 
 #include <linux/bitfield.h>
+#include <linux/can/dev.h>
 #include <linux/ethtool.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
+#include <linux/phy/phy.h>
+#include <linux/pinctrl/consumer.h>
 #include <linux/platform_device.h>
 #include <linux/pm_runtime.h>
-#include <linux/iopoll.h>
-#include <linux/can/dev.h>
-#include <linux/pinctrl/consumer.h>
-#include <linux/phy/phy.h>
 
 #include "m_can.h"
 
diff --git a/drivers/net/can/m_can/m_can.h b/drivers/net/can/m_can/m_can.h
index 52563c048732..a839dc71dc9b 100644
--- a/drivers/net/can/m_can/m_can.h
+++ b/drivers/net/can/m_can/m_can.h
@@ -7,27 +7,27 @@
 #define _CAN_M_CAN_H_
 
 #include <linux/can/core.h>
+#include <linux/can/dev.h>
 #include <linux/can/rx-offload.h>
+#include <linux/clk.h>
 #include <linux/completion.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/dma-mapping.h>
 #include <linux/freezer.h>
-#include <linux/slab.h>
-#include <linux/uaccess.h>
-#include <linux/clk.h>
-#include <linux/delay.h>
 #include <linux/interrupt.h>
 #include <linux/io.h>
+#include <linux/iopoll.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/netdevice.h>
 #include <linux/of.h>
 #include <linux/of_device.h>
-#include <linux/pm_runtime.h>
-#include <linux/iopoll.h>
-#include <linux/can/dev.h>
-#include <linux/pinctrl/consumer.h>
 #include <linux/phy/phy.h>
+#include <linux/pinctrl/consumer.h>
+#include <linux/pm_runtime.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
 
 /* m_can lec values */
 enum m_can_lec_type {
diff --git a/drivers/net/can/m_can/m_can_platform.c b/drivers/net/can/m_can/m_can_platform.c
index eee47bad0592..b5a5bedb3116 100644
--- a/drivers/net/can/m_can/m_can_platform.c
+++ b/drivers/net/can/m_can/m_can_platform.c
@@ -5,8 +5,8 @@
 //
 // Copyright (C) 2018-19 Texas Instruments Incorporated - http://www.ti.com/
 
-#include <linux/platform_device.h>
 #include <linux/phy/phy.h>
+#include <linux/platform_device.h>
 
 #include "m_can.h"
 
-- 
2.17.1

