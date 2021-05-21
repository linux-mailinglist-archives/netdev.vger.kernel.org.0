Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AF9BA38CF8D
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbhEUVCi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:02:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhEUVCh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 17:02:37 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26F9CC061574
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 14:01:14 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id t15so24772218edr.11
        for <netdev@vger.kernel.org>; Fri, 21 May 2021 14:01:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kTOtqOFUwKzHokq2SSHlfYiNf8ytzv8+9XyCcxDCH+c=;
        b=nbkAitHr2qVrngtHJ3Yz/HtebkJEkOHlU2Vf8pGxOezb7REeMOcNWWNFrZujUey1WY
         2ETN/pvTLJtfQLdm7+V8Zq2KKWoDhaVekRH8mxS5KFaHQ7drfT5JbQ/yr3JrDj3yed2D
         QUm60XJtBENRO8YQwypbcmzptEIkwcktrhDiKSU8EwtZF2nzDJonaRg/bkXtRktzXIDT
         5TEeh9WMShxs36dH/76RPo6YNarnK6U1vI61MxXPA8eOgmapvLpC+h9/V/HktvM2Sy5K
         p8EHZS/l7fo9c9HVk8nh1SVKTGVMNA9OHZf/M/2kZnr67EPNra0Hz1X4fPcv8kn8MChv
         73DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kTOtqOFUwKzHokq2SSHlfYiNf8ytzv8+9XyCcxDCH+c=;
        b=VopUCTSSpQaORxzSNADHQu3tHsdYofnv8WO4qvBDsZXdpiqReDdW6PmJR1jt2iLpnh
         iJocuYK6DrLFa6Fh6SPZNUchuVSXhFZfKsCiwhHK0L5kYzJUtbrv3y1YbxxMTtCUjzjp
         3MFlGQYEguJ9ChJCIiNeG6O6KcDADPaTaYAneRH8+jPTftUbiPO9aI53D50YAPoipJG/
         tOcU1u1oV+E9p325rp+ao5giAYRfYq5C/BDbU2ASA5MvUJlxRTDFfmALd2CyIXrE2Fz9
         yvxtG2q8XkX/RCdIOq3uwVcNTIm10eHVjC+xMjoptsgHAd8rwc5/i3m9918L5nFutT4F
         W69Q==
X-Gm-Message-State: AOAM531Oc9PaZhrxg5ZpX8oIjHk3KULIFBD1U6Z7b66Wv1gP9W1hAX3M
        2rbrfzs88rqUPvobXBXqEY7J2u67ZTU=
X-Google-Smtp-Source: ABdhPJw7tk15BpvSxRq2PYcuPfhxDmCXIpQ7UA5+iLOqEp855M/peTlUY1P635+Rt49mKEWpaaeSwQ==
X-Received: by 2002:aa7:c7c5:: with SMTP id o5mr13067706eds.31.1621630872094;
        Fri, 21 May 2021 14:01:12 -0700 (PDT)
Received: from yoga-910.localhost ([188.26.52.84])
        by smtp.gmail.com with ESMTPSA id ia23sm78639ejc.70.2021.05.21.14.01.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 May 2021 14:01:11 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Cc:     ruxandra.radulescu@nxp.com, Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH] MAINTAINERS: remove Ioana Radulescu from dpaa2-eth
Date:   Sat, 22 May 2021 00:01:00 +0300
Message-Id: <20210521210100.2858070-1-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Remove Ioana Radulescu from dpaa2-eth since she is no longer working on
the DPAA2 set of drivers.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index bd7aff0c120f..53f524913738 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -5569,7 +5569,6 @@ F:	drivers/soc/fsl/dpio
 
 DPAA2 ETHERNET DRIVER
 M:	Ioana Ciornei <ioana.ciornei@nxp.com>
-M:	Ioana Radulescu <ruxandra.radulescu@nxp.com>
 L:	netdev@vger.kernel.org
 S:	Maintained
 F:	Documentation/networking/device_drivers/ethernet/freescale/dpaa2/ethernet-driver.rst
-- 
2.31.1

