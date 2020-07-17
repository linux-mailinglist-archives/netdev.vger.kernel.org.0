Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94895224036
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 18:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726928AbgGQQKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jul 2020 12:10:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726858AbgGQQKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jul 2020 12:10:46 -0400
Received: from mail-ed1-x544.google.com (mail-ed1-x544.google.com [IPv6:2a00:1450:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAD76C0619D3;
        Fri, 17 Jul 2020 09:10:45 -0700 (PDT)
Received: by mail-ed1-x544.google.com with SMTP id d16so8102309edz.12;
        Fri, 17 Jul 2020 09:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9HvSYMPMl6zuTZ43Xfw2roBTeaFPyRGcOh3uQhjnEB8=;
        b=qOaf9qP9tLJQhFlr/TKIlVzwt0WhRF7dvQaVE6bX6myavpI24A8xPv1sCdqh7FFB2S
         Nt14IecLp3k9oszHIwOpU1Vk2DNnRXlDkyGRsPSDC13EVJFP2L3yoSomts7uwas9KWJQ
         XFRHVlgWl8y7S7gnXxmnDyu4wTeYBcq3bpIxK6E0wcqlzgq8JYGGeATcMkB4OAycT0Wr
         0ZzNFx+tY8nhPTFoObnBAN1UCP2rlq6dZlO8PwbPtiOil/Qggraf08VroWos/hZTc65I
         K9CsZl0P8Y4g3QrhCBEy3O42t6AwM5Yt/jaCmuJrlw480dhBAf0JaseYiXNXhv+l4jbT
         aqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9HvSYMPMl6zuTZ43Xfw2roBTeaFPyRGcOh3uQhjnEB8=;
        b=hw7ujsGDtsspjtIhUXnaUoGtreYxruRxr73hCkLqaiFbSfK77j0VYUUOXz5YFhNwB6
         TblBB7yZbL0tZ66oMBuijaYwNuLGK3vBsH410r0b+VLyDfvjlD3OQppwi9OBG7jXJiYK
         KxFV23bEVndQSmBBvVEkeFQ+lBvBMNBVBZ6020E/bn/QZmVygYbVRGuA3260MYKFEyE2
         2EGLeS/ALQs28pdTW5rIQGaLnpMC77Jg3G4Kur8jV13HbxK5p9EejDoPqHcLDVTAwRcO
         9uxbEtrWD5WqJZ90wwg9KrLfU7Wil1DNjrcybJl4s4azfBTEZv4tZplQd6iJaj4esKN3
         pmFg==
X-Gm-Message-State: AOAM531WKt6RBPaeKMebCjUtOXTn/5qgmmyxQ8NTD0fZODbcxR7tCdcZ
        bTgYlj4QiedY+C5XHFKw7UY=
X-Google-Smtp-Source: ABdhPJyWjH5SXTBmFGYLAeJjntVedCIsDZKXevys5+TocHM+hr4S0InSf9CFSxLiRLG8f5n+wce5xQ==
X-Received: by 2002:aa7:dad6:: with SMTP id x22mr9715396eds.310.1595002244579;
        Fri, 17 Jul 2020 09:10:44 -0700 (PDT)
Received: from localhost.localdomain ([188.25.219.134])
        by smtp.gmail.com with ESMTPSA id bc23sm8578253edb.90.2020.07.17.09.10.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2020 09:10:44 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Cc:     richardcochran@gmail.com, sorganov@gmail.com,
        linux-doc@vger.kernel.org
Subject: [PATCH net-next 2/3] docs: networking: timestamping: add one more known issue
Date:   Fri, 17 Jul 2020 19:10:26 +0300
Message-Id: <20200717161027.1408240-3-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200717161027.1408240-1-olteanv@gmail.com>
References: <20200717161027.1408240-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Document the fact that Ethernet PHY timestamping has a fundamentally
flawed corner case (which in fact hits the majority of networking
drivers): a PHY for which its host MAC driver doesn't forward the
phy_mii_ioctl for timestamping is still going to be presented to user
space as functional.

Fixing this inconsistency would require moving the phy_has_tsinfo()
check inside all MAC drivers which are capable of PHY timestamping, to
be in harmony with the existing design for phy_has_hwtstamp() checks.
Instead of doing that, document the preferable solution which is that
offending MAC drivers be fixed instead.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 Documentation/networking/timestamping.rst | 37 +++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/Documentation/networking/timestamping.rst b/Documentation/networking/timestamping.rst
index 9a1f4cb4ce9e..4004c5d2771d 100644
--- a/Documentation/networking/timestamping.rst
+++ b/Documentation/networking/timestamping.rst
@@ -754,3 +754,40 @@ check in their "TX confirmation" portion, not only for
 that PTP timestamping is not enabled for anything other than the outermost PHC,
 this enhanced check will avoid delivering a duplicated TX timestamp to user
 space.
+
+Another known limitation is the design of the ``__ethtool_get_ts_info``
+function::
+
+  int __ethtool_get_ts_info(struct net_device *dev, struct ethtool_ts_info *info)
+  {
+          const struct ethtool_ops *ops = dev->ethtool_ops;
+          struct phy_device *phydev = dev->phydev;
+
+          memset(info, 0, sizeof(*info));
+          info->cmd = ETHTOOL_GET_TS_INFO;
+
+          if (phy_has_tsinfo(phydev))
+                  return phy_ts_info(phydev, info);
+          if (ops->get_ts_info)
+                  return ops->get_ts_info(dev, info);
+
+          info->so_timestamping = SOF_TIMESTAMPING_RX_SOFTWARE |
+                                  SOF_TIMESTAMPING_SOFTWARE;
+          info->phc_index = -1;
+
+          return 0;
+  }
+
+Because the generic function searches first for the timestamping capabilities
+of the attached PHY, and returns them directly without consulting the MAC
+driver, no checking is being done whether the requirements described in `3.2.2
+Ethernet PHYs`_ are implemented or not. Therefore, if the MAC driver does not
+satisfy the requirements for PHY timestamping, and
+``CONFIG_NETWORK_PHY_TIMESTAMPING`` is enabled, then a non-functional PHC index
+(the one corresponding to the PHY) will be reported to user space, via
+``ethtool -T``.
+
+The correct solution to this problem is to implement the PHY timestamping
+requirements in the MAC driver found broken, and submit as a bug fix patch to
+netdev@vger.kernel.org. See :ref:`Documentation/process/stable-kernel-rules.rst
+<stable_kernel_rules>` for more details.
-- 
2.25.1

