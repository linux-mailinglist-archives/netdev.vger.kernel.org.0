Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 809423DA9EE
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 19:18:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232593AbhG2RSQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 13:18:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbhG2RSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Jul 2021 13:18:03 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07A3CC0613D5;
        Thu, 29 Jul 2021 10:17:59 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id o5so11976084ejy.2;
        Thu, 29 Jul 2021 10:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=89CgPT3VkrqPxNLqY/6UFH61Wf0AdKuC1cOTr/8rVjg=;
        b=P/UlxHpng+VrreQnHWQ2u5qsblJMhHsWX774JkuVi/e7Y/ale0KCt0/9OJuvZdg0SL
         8Z/1quHw9niI6DqAWAsrVHFkm7KXAvowR/ZOZNv2YY4GQ5SUaEYu/jvwCez/RQ6e84dC
         LotNewEyYAihDQeffUvYTtPFuEdVJjoqG6VAWDGj2uFLyGlbAShrOcTNlMdzCNTXpUGV
         eRVt/Fd0qbgge+wl0CJYjn5ybtphlR2DtLR5d6mwwr+jswUuMTIFXnB53l+8X8uPw6t0
         0chyrhh0MtPQjG1gRFP4+miS041abdHvMTJewvT90qulr5V8D3BrWnRv0cmgNUQzQyZQ
         4RrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=89CgPT3VkrqPxNLqY/6UFH61Wf0AdKuC1cOTr/8rVjg=;
        b=qNqYAZyN8XfZ9NFSUrE8qGb7foQ0qiriPeG0ts37ySW8uBwJDQj/vKmSDSpr+Q89+E
         GpR2oa8yEDYrYrCgJxao4ygAz9+pRgMK3RYmg+CDqxpQA/CRclso2hA+yuz5ostoazby
         x0Zzuygrfetun2CgeyO55p+2QcZasEEgRn3+Uuv9c1xTpSohSgdAP4b0Et6+4ilnM8ti
         tlLTepBbf7uJs2hCJnJHwt1e6oyyvnqCZEw5OyCA0RBphQPiokp8knsxc8Mn4O+ybndl
         P7+w1k3qys8LkhrZNBmPOTAzl81TSU0mvM1JYtqKbN3BjZD57K3XJ9zMxqf/PiusDcmV
         0R/A==
X-Gm-Message-State: AOAM5321ZFtkYeVPuVhiImj4hFAy01GwkgULRSJ3cmZA/ldLHGIyF2jZ
        URugg500tUZMPn4VHNFzR/w=
X-Google-Smtp-Source: ABdhPJzRrIAt3p+sob5R9V8cAZbz7Mjfw33Lnw99WHDXoaPeyA4FIUVabER3LiG4GY215y9qBC5TgQ==
X-Received: by 2002:a17:906:b30d:: with SMTP id n13mr5654322ejz.401.1627579077506;
        Thu, 29 Jul 2021 10:17:57 -0700 (PDT)
Received: from yoga-910.localhost ([82.76.66.29])
        by smtp.gmail.com with ESMTPSA id df14sm1451612edb.90.2021.07.29.10.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 10:17:56 -0700 (PDT)
From:   Ioana Ciornei <ciorneiioana@gmail.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        Ioana Ciornei <ioana.ciornei@nxp.com>
Subject: [PATCH net-next 9/9] docs: networking: dpaa2: document mirroring support on the switch
Date:   Thu, 29 Jul 2021 20:19:01 +0300
Message-Id: <20210729171901.3211729-10-ciorneiioana@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210729171901.3211729-1-ciorneiioana@gmail.com>
References: <20210729171901.3211729-1-ciorneiioana@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>

Document the mirroring capabilities of the dpaa2-switch driver,
any restrictions that are imposed and some example commands.

Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>
---
 .../freescale/dpaa2/switch-driver.rst         | 43 +++++++++++++++++++
 1 file changed, 43 insertions(+)

diff --git a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst
index 863ca6bd8318..8bf411b857d4 100644
--- a/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst
+++ b/Documentation/networking/device_drivers/ethernet/freescale/dpaa2/switch-driver.rst
@@ -172,3 +172,46 @@ Example 4: Use a single shared filter block on both eth5 and eth6::
                 action trap
         $ tc filter add block 1 ingress protocol ipv4 flower src_ip 192.168.1.1 skip_sw \
                 action mirred egress redirect dev eth3
+
+Mirroring
+~~~~~~~~~
+
+The DPAA2 switch supports only per port mirroring and per VLAN mirroring.
+Adding mirroring filters in shared blocks is also supported.
+
+When using the tc-flower classifier with the 802.1q protocol, only the
+''vlan_id'' key will be accepted. Mirroring based on any other fields from the
+802.1q protocol will be rejected::
+
+        $ tc qdisc add dev eth8 ingress_block 1 clsact
+        $ tc filter add block 1 ingress protocol 802.1q flower skip_sw vlan_prio 3 action mirred egress mirror dev eth6
+        Error: fsl_dpaa2_switch: Only matching on VLAN ID supported.
+        We have an error talking to the kernel
+
+If a mirroring VLAN filter is requested on a port, the VLAN must to be
+installed on the switch port in question either using ''bridge'' or by creating
+a VLAN upper device if the switch port is used as a standalone interface::
+
+        $ tc qdisc add dev eth8 ingress_block 1 clsact
+        $ tc filter add block 1 ingress protocol 802.1q flower skip_sw vlan_id 200 action mirred egress mirror dev eth6
+        Error: VLAN must be installed on the switch port.
+        We have an error talking to the kernel
+
+        $ bridge vlan add vid 200 dev eth8
+        $ tc filter add block 1 ingress protocol 802.1q flower skip_sw vlan_id 200 action mirred egress mirror dev eth6
+
+        $ ip link add link eth8 name eth8.200 type vlan id 200
+        $ tc filter add block 1 ingress protocol 802.1q flower skip_sw vlan_id 200 action mirred egress mirror dev eth6
+
+Also, it should be noted that the mirrored traffic will be subject to the same
+egress restrictions as any other traffic. This means that when a mirrored
+packet will reach the mirror port, if the VLAN found in the packet is not
+installed on the port it will get dropped.
+
+The DPAA2 switch supports only a single mirroring destination, thus multiple
+mirror rules can be installed but their ''to'' port has to be the same::
+
+        $ tc filter add block 1 ingress protocol 802.1q flower skip_sw vlan_id 200 action mirred egress mirror dev eth6
+        $ tc filter add block 1 ingress protocol 802.1q flower skip_sw vlan_id 100 action mirred egress mirror dev eth7
+        Error: fsl_dpaa2_switch: Multiple mirror ports not supported.
+        We have an error talking to the kernel
-- 
2.31.1

