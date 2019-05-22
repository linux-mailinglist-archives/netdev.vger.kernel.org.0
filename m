Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 244BE25BD1
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 03:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728202AbfEVB52 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 21:57:28 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:38890 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726466AbfEVB52 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 21:57:28 -0400
Received: by mail-qk1-f195.google.com with SMTP id a64so513388qkg.5
        for <netdev@vger.kernel.org>; Tue, 21 May 2019 18:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+1CHsa2WC462wxjIx9SO35uJElEqAkBtcRJoeYpg5io=;
        b=ZwriqPrS9aPv8K1ucV2GDHAThVBhoP4e0mTCR0R4MirpQa9e0b8rYDFMslnAUTQ5zN
         RoXzLAZySOMaZJ5mZsVTo2FLAThBXvQuzq3guiszLRROul5NtFvsahs78NXhgVKRkigf
         5D88Wm1Fciqk2U6tmnCCIsm5cOuKJIi49GFDSYC+suSCpt14Qzn9hXC1wp2UkK/CgWtq
         FL9tzmUoORINqMqMGzzEQVtRaOVMc7oMBfl3FQwvWlQm3eEy4+btWzuPoH2d92xSFmbD
         7D5PC9KnvophE6x322WGm4BQ8VZxW/9zxsEDVg4bPya9BS6Q0RjFWBC9TLxxzkQXnWpu
         MA1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+1CHsa2WC462wxjIx9SO35uJElEqAkBtcRJoeYpg5io=;
        b=UXQP7Z3IXoD/+CCKxTuQg1sZzAePmJkrOsI214oKZGyyRJQpq854NdRmVV7WeHsxGS
         dbXPXbW6AZbhfqJTOWeYpNmmURC7TFMIKAaeRunJHh20puPp/S6Tfg4EGxhP5/Rwd73b
         yrGe4fbBReOUyJad0m6ZZC3lVpcLXVyIbRi6so3SBtQ91EJjOSEJPnnxDr7fTM06LfJr
         7EcIEYL78A3WIPtxSgZLRFRs4e0fF1CA+eoCGofNdPOBpMMJ8F23pnrP2vcvLHwQz28N
         iydjfYVI0hbAj88lwSEpoSBkeeQJjMppJlvsPRP6RBsbx+b/VQ7JqtYYbACxKubxpTFG
         rZMA==
X-Gm-Message-State: APjAAAUB5XXEsos5kQSxW38p8Eec4YgxqO7fGjzeN65xbA0kLKiUUXnr
        Vbi2lVpPBogNGnONE7r2FJWPJA==
X-Google-Smtp-Source: APXvYqyglGUCLyOuJMNnzjtVKodDpBt5eeiNNq6dwXvTT4Q8hdPKJc8c8LNjUmK/7hiS0piTVp58Ag==
X-Received: by 2002:a37:9b10:: with SMTP id d16mr67811743qke.41.1558490247439;
        Tue, 21 May 2019 18:57:27 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id l16sm9614901qtj.60.2019.05.21.18.57.25
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 May 2019 18:57:26 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        john.fastabend@gmail.com, vakul.garg@nxp.com, borisp@mellanox.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH net v2 1/3] Documentation: net: move device drivers docs to a submenu
Date:   Tue, 21 May 2019 18:57:12 -0700
Message-Id: <20190522015714.4077-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190522015714.4077-1-jakub.kicinski@netronome.com>
References: <20190522015714.4077-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Some of the device drivers have really long document titles
making the networking table of contents hard to look through.
Place vendor drivers under a submenu.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Acked-by: Dave Watson <davejwatson@fb.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
---
 .../networking/device_drivers/index.rst       | 30 +++++++++++++++++++
 Documentation/networking/index.rst            | 14 +--------
 2 files changed, 31 insertions(+), 13 deletions(-)
 create mode 100644 Documentation/networking/device_drivers/index.rst

diff --git a/Documentation/networking/device_drivers/index.rst b/Documentation/networking/device_drivers/index.rst
new file mode 100644
index 000000000000..75fa537763a4
--- /dev/null
+++ b/Documentation/networking/device_drivers/index.rst
@@ -0,0 +1,30 @@
+.. SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
+
+Vendor Device Drivers
+=====================
+
+Contents:
+
+.. toctree::
+   :maxdepth: 2
+
+   freescale/dpaa2/index
+   intel/e100
+   intel/e1000
+   intel/e1000e
+   intel/fm10k
+   intel/igb
+   intel/igbvf
+   intel/ixgb
+   intel/ixgbe
+   intel/ixgbevf
+   intel/i40e
+   intel/iavf
+   intel/ice
+
+.. only::  subproject
+
+   Indices
+   =======
+
+   * :ref:`genindex`
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index f390fe3cfdfb..7a2bfad6a762 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -11,19 +11,7 @@ Linux Networking Documentation
    batman-adv
    can
    can_ucan_protocol
-   device_drivers/freescale/dpaa2/index
-   device_drivers/intel/e100
-   device_drivers/intel/e1000
-   device_drivers/intel/e1000e
-   device_drivers/intel/fm10k
-   device_drivers/intel/igb
-   device_drivers/intel/igbvf
-   device_drivers/intel/ixgb
-   device_drivers/intel/ixgbe
-   device_drivers/intel/ixgbevf
-   device_drivers/intel/i40e
-   device_drivers/intel/iavf
-   device_drivers/intel/ice
+   device_drivers/index
    dsa/index
    devlink-info-versions
    ieee802154
-- 
2.21.0

