Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 547FF1FB96
	for <lists+netdev@lfdr.de>; Wed, 15 May 2019 22:41:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727087AbfEOUlq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 May 2019 16:41:46 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:37360 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726170AbfEOUlp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 May 2019 16:41:45 -0400
Received: by mail-qk1-f193.google.com with SMTP id d10so907797qko.4
        for <netdev@vger.kernel.org>; Wed, 15 May 2019 13:41:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+1CHsa2WC462wxjIx9SO35uJElEqAkBtcRJoeYpg5io=;
        b=M36Eo95f/lGaAnxm657QNRV6PKnCs+TWilAeZRF223cj81P2674mziQ8JxuPAcv4lx
         AhFdNMxuKLLPkCtokIYdg+Vvo2GIA1SoGPUjgI7xxtKMOc0r48RvIIRkeW1JcghVKVTw
         jyoHrGL46wnszdp6K/E/vOiKi3Zmfad2Q5ijQ/Xn9PVArNcVHFjzdpg/+m3C+AyfRxgt
         8TTqalwNKs63CmkqDQqml+oic0oE9Cgi1C4QMVoinP1VA5xKQZpZVLjt29/EUO+ui8NH
         Qc3OfEM1Kl4ddUQ0SfVIBUUaXs7ofl0pGnaBzeDp9vF9lPwQjN0DMdryVCJRZm/s83IB
         5bCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+1CHsa2WC462wxjIx9SO35uJElEqAkBtcRJoeYpg5io=;
        b=WEmv7VmSfiiGBQ8m6GAHMNFDG5NuPWfDbD5GD3x37Gv0t15rkvOMdnc8yFwcb3SNZn
         SWxqzjEzhyhlTVQvzL22NQBOOf3r4S+MRNy/NzGUbKkj5ygfuWP6QgPyMaYQC3KC1LwD
         5KBfJzazI5UEPfa9uz2mOKX4z4TDU8hfwwpTu57LnyFL6HB4MkSFPENjrYduSSJCQLcM
         ZpYNlar++4VwVPs76pDAzIKO6DiuuIEAdI0W0dezd5nZ+egkWMJ9Xyo8aPeH9gK5yM+9
         uf7ni91re9Y4WPgiq1+qL3Y5zNTqUd8G1xS85ueotzqJbRpyUslCaJvSMRjMbJkIGmZ5
         yFkQ==
X-Gm-Message-State: APjAAAU15GGFU5RYDaO8PavsLYC88L4xz9gdTac4MQXDPg/VlSMowbsY
        umS45mKpk4GYUreLecdARyEYKA==
X-Google-Smtp-Source: APXvYqwyMbYVtFlLgroZcO8ja+D5eBf39x3wWa7sBmH2vwiIOTEMCoPBYG2lW7BXWAvkBoGk2xJQJg==
X-Received: by 2002:ae9:e806:: with SMTP id a6mr19467293qkg.247.1557952904639;
        Wed, 15 May 2019 13:41:44 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id t6sm1732172qkt.25.2019.05.15.13.41.42
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 May 2019 13:41:44 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        john.fastabend@gmail.com, vakul.garg@nxp.com, borisp@mellanox.com,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH net 1/3] Documentation: net: move device drivers docs to a submenu
Date:   Wed, 15 May 2019 13:41:21 -0700
Message-Id: <20190515204123.5955-2-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190515204123.5955-1-jakub.kicinski@netronome.com>
References: <20190515204123.5955-1-jakub.kicinski@netronome.com>
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

