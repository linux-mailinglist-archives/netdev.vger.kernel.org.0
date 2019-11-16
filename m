Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CE8DFEB54
	for <lists+netdev@lfdr.de>; Sat, 16 Nov 2019 10:21:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727422AbfKPJUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 16 Nov 2019 04:20:55 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:36673 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbfKPJUy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 16 Nov 2019 04:20:54 -0500
Received: by mail-pf1-f195.google.com with SMTP id b19so7853675pfd.3;
        Sat, 16 Nov 2019 01:20:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=GGXaHDFHZ+2+1WtNE16sJMzf7vyeAFnb5+gKH7ZhGsQ=;
        b=eADdUdImeONTuusTm6sLbAaB/+zl0npKpqx00adk3wuTJDA5gTr+loTKl/IJh903OM
         /O8wmWWK57hQsobqUdU6aY/9yr8sKiut7ZeMocm4niFTBg1nPqx5HaR8L/2NPA12L7U4
         V4Tg5ssc4ukqrObYzVT/bxvfmbyg49ovyzyZ5XHtn87RwceJAXq+9SlJ1kyNFxYQoqxU
         dyKsLCBnfqUzGkt9yY/XK5xLngf9jtyfM1lQ0M2GZricXzWFLmpjy1Tk4RI9P5vuV8qT
         fpPBtzFkVOdUgBsxH2Pp0t6F0O+X0DkwjEPvuo5m2M2uCsdGTXjiFgHYSvwOQrI9hl20
         UkhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=GGXaHDFHZ+2+1WtNE16sJMzf7vyeAFnb5+gKH7ZhGsQ=;
        b=GjCKKD4hYDUO7fCkHqBXm/tRLe7vZ/mzxVEIz03ZfA7YsbYTD/77t0fw2xb7HZS5gX
         1MbXMSwZakrPiFHTju8zwUi8gylLdR7VPZlkLtHomzCnGMpIh2BwAjcbTmj1shusEhmC
         C+oS+Jja0S+6FDs20S0DOwAP78+sdjs/+xdny5YRP8w4uzJGPRqWMFhVX+z8Xstm95uh
         IJh2oHaJn/c/BvIBl9oG6WfrEVi7Tre2zxtI0dTWDhAOtspsaIYQ7Chq//lXBKwxF3ZB
         qaCMCIHq3VhJGVjuChWttbBYlrMw9iNnbm9Uo7rnLrw5GbiaxojYIsCoE0xOmrCplSbI
         9Ybw==
X-Gm-Message-State: APjAAAUnB1yekZ/hb6Asz4xkFKTFla2YFMImT+zNRwZYoClOHVjYxH9e
        03xObiyPAy5TpIb8ArJiv30=
X-Google-Smtp-Source: APXvYqwQBw6GfezNO8rLaeZ9qWi0JJCVBlWN4XFzwkiENqhWHC+SPvprxLEhu1y9zp6N662a+qQlnw==
X-Received: by 2002:a63:c04f:: with SMTP id z15mr1859320pgi.52.1573896053697;
        Sat, 16 Nov 2019 01:20:53 -0800 (PST)
Received: from nishad ([106.51.232.103])
        by smtp.gmail.com with ESMTPSA id 67sm13796014pjz.27.2019.11.16.01.20.49
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 16 Nov 2019 01:20:53 -0800 (PST)
Date:   Sat, 16 Nov 2019 14:50:45 +0530
From:   Nishad Kamdar <nishadkamdar@gmail.com>
To:     Sunil Goutham <sgoutham@marvell.com>,
        Linu Cherian <lcherian@marvell.com>,
        Geetha sowjanya <gakula@marvell.com>,
        Jerin Jacob <jerinj@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Joe Perches <joe@perches.com>,
        Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= 
        <u.kleine-koenig@pengutronix.de>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] octeontx2-af: Use the correct style for SPDX License
 Identifier
Message-ID: <20191116092042.GA4313@nishad>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch corrects the SPDX License Identifier style in
header files related to Marvell OcteonTX2 network devices.
It uses an expilict block comment for the SPDX License
Identifier.

Changes made by using a script provided by Joe Perches here:
https://lkml.org/lkml/2019/2/7/46.

Suggested-by: Joe Perches <joe@perches.com>
Signed-off-by: Nishad Kamdar <nishadkamdar@gmail.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.h         | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h   | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/common.h      | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/mbox.h        | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/npc.h         | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu.h         | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h     | 4 ++--
 drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h  | 4 ++--
 9 files changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
index 206dc5dc1df8..5c1f389e3320 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Marvell OcteonTx2 CGX driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 CGX driver
  *
  * Copyright (C) 2018 Marvell International Ltd.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
index fb3ba4968a9b..473d9751601f 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx_fw_if.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Marvell OcteonTx2 CGX driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 CGX driver
  *
  * Copyright (C) 2018 Marvell International Ltd.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/common.h b/drivers/net/ethernet/marvell/octeontx2/af/common.h
index e332e82fc066..413c3f254cf8 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/common.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/common.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Marvell OcteonTx2 RVU Admin Function driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RVU Admin Function driver
  *
  * Copyright (C) 2018 Marvell International Ltd.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
index 76a4575d18ff..75439fce0505 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/mbox.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Marvell OcteonTx2 RVU Admin Function driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RVU Admin Function driver
  *
  * Copyright (C) 2018 Marvell International Ltd.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc.h b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
index 8d6d90fdfb73..5d4df315a0e1 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Marvell OcteonTx2 RVU Admin Function driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RVU Admin Function driver
  *
  * Copyright (C) 2018 Marvell International Ltd.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
index b2ce957605bb..da649f6a5573 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/npc_profile.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Marvell OcteonTx2 RVU Admin Function driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RVU Admin Function driver
  *
  * Copyright (C) 2018 Marvell International Ltd.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
index c9d60b0554c0..5222e4228905 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Marvell OcteonTx2 RVU Admin Function driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RVU Admin Function driver
  *
  * Copyright (C) 2018 Marvell International Ltd.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
index 09a8d61f3144..1ea92a2e7cfe 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_reg.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Marvell OcteonTx2 RVU Admin Function driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RVU Admin Function driver
  *
  * Copyright (C) 2018 Marvell International Ltd.
  *
diff --git a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
index f920dac74e6c..84a39063a8bb 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
+++ b/drivers/net/ethernet/marvell/octeontx2/af/rvu_struct.h
@@ -1,5 +1,5 @@
-/* SPDX-License-Identifier: GPL-2.0
- * Marvell OcteonTx2 RVU Admin Function driver
+/* SPDX-License-Identifier: GPL-2.0 */
+/*  Marvell OcteonTx2 RVU Admin Function driver
  *
  * Copyright (C) 2018 Marvell International Ltd.
  *
-- 
2.17.1

