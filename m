Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3344E3639
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 17:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409608AbfJXPMI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Oct 2019 11:12:08 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:37100 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2409601AbfJXPMI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Oct 2019 11:12:08 -0400
Received: by mail-pl1-f194.google.com with SMTP id p13so785656pll.4;
        Thu, 24 Oct 2019 08:12:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=D/0gh8iCctdTGEMvU3sJnefOfV6UStdjIGzOfvoBHNE=;
        b=H4/JyP3I6ZBOaWndgpyylmETE7dbpU5EAZ1pEAENRLW6SXLmnbhblTa3LQuIk23wHB
         gUJflM6FQvXhseyyS+RKser/a136qzVgaawJQSflA4AEtjIKAjw7zFdRjE3OBp1v6aIw
         sIOLDtHibJF9ozZPeMtnYZz+nsyHT5Kxfu9+KX4v2JA5Hk8Xvvfgu/jJXnfBgfx2MIZs
         3tjC1/lQ/Hsfi0LGM/xtskaOdkOMFolGFohvmMrWnCBJejczilqeVieRxPeMF5Bd76K0
         1paKw/jh/k6KDEUM2NapcA+GzPLZ4Pg9Dpawfv0zfAcTGwYX3ikmA7nHRwVJQnfyYSdS
         xWpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=D/0gh8iCctdTGEMvU3sJnefOfV6UStdjIGzOfvoBHNE=;
        b=aGeije0mj7yw6ATlf3jyFlGYlx/4R4T33RQQ9HjzfCuqaVYQC7+DWqyOQziW+tCBlp
         oS6yrUYWY+PnlQmAAEe//+cRbVNbzo3NSc4NgVWfQ5f6/E4AidxxRsoN+we17oWli7jp
         2LZlDsp7szUP8+EO92xvvfZ4Zm2QVIPZLTSz8h4A99RcN0Xu7bqhqdQh193UmPGs2+zS
         Awis4CXYCHwzUVFC7TA7fwJt6OyDiKgNp69QtkIgYU6d437+DRhNtZqhFJuDNCI8cKNk
         bfFEz+hXaic+T450xdjP4CCNZJkplLW5ahXcoput164H/meZfrrJdjDKsibXgyy8lM8E
         wN5Q==
X-Gm-Message-State: APjAAAWq9nm6hWa2B4aG+OZQtsrH0JW7X2vmfmKVC/M+b9Z991BBHsSx
        YgbUURoiGsZb4x2iOOeXYgo8MrV3/BuZyA==
X-Google-Smtp-Source: APXvYqwImggu94yIxE//05ayD8VbKsumlgqtNN5+1iMaUe5/mf+r3CP52BhswyvUYn3sidMU1UHuxw==
X-Received: by 2002:a17:902:a50a:: with SMTP id s10mr17098744plq.59.1571929927634;
        Thu, 24 Oct 2019 08:12:07 -0700 (PDT)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id z12sm30480588pfj.41.2019.10.24.08.12.04
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 24 Oct 2019 08:12:06 -0700 (PDT)
Date:   Thu, 24 Oct 2019 20:42:00 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Yangbo Lu <yangbo.lu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] net: dpaa2: Use the correct style for SPDX License Identifier
Message-ID: <20191024151155.GA3340@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style in
header files related to DPAA2 Ethernet driver supporting
Freescale SoCs with DPAA2. For C header files
Documentation/process/license-rules.rst mandates C-like comments
(opposed to C source files where C++ style should be used)

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h | 2 +-
 drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h | 2 +-
 drivers/net/ethernet/freescale/dpaa2/dprtc.h     | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h
index ff2e177395d4..df2458a5e9ef 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-ptp.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright 2018 NXP
  */
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h b/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
index 720cd50f5895..4ac05bfef338 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc-cmd.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright 2013-2016 Freescale Semiconductor Inc.
  * Copyright 2016-2018 NXP
diff --git a/drivers/net/ethernet/freescale/dpaa2/dprtc.h b/drivers/net/ethernet/freescale/dpaa2/dprtc.h
index be7914c1634d..311c184e1aef 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dprtc.h
+++ b/drivers/net/ethernet/freescale/dpaa2/dprtc.h
@@ -1,4 +1,4 @@
-// SPDX-License-Identifier: GPL-2.0
+/* SPDX-License-Identifier: GPL-2.0 */
 /*
  * Copyright 2013-2016 Freescale Semiconductor Inc.
  * Copyright 2016-2018 NXP
-- 
2.17.1

