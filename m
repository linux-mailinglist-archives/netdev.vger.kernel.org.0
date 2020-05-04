Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B728F1C39B6
	for <lists+netdev@lfdr.de>; Mon,  4 May 2020 14:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728877AbgEDMoa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 May 2020 08:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728475AbgEDMoY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 May 2020 08:44:24 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33AB1C061A0E
        for <netdev@vger.kernel.org>; Mon,  4 May 2020 05:44:24 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id k12so8231787wmj.3
        for <netdev@vger.kernel.org>; Mon, 04 May 2020 05:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=/VFrQTqtmw8M3JqCJ35gBTW/wMAKmrJTc9j9D0crIWw=;
        b=Q8NsrY1xrrpfulD18ddLN24jVD8dCg8/t0rOV+s6zY1zG0x53P+UQmWm/PE/ecvWhv
         0SpAqocl3w7GolFsj+P21qZPNbRnsddBARwaQZODMYFuQVS4MH3BB8fgYjfU8DIOgISR
         a2HWxEjaFdJsctA6GTgVZpG3KScwZOH2QlhabvIwvnCKK8huMWaTdk6D0j6+ilK+3+7+
         kn8ybMfVDWHPnJQAqlNrFytFfpLNQjTsG2s8c3M/U5SBztimxKNGrW2707pn9fvMIw6M
         eHPoGbaQY2L7m5S0IKWoJfGqweCJAocOIPI+SpYNQYCrZyMNiIsfJJzigWIkBKJ5wQCl
         VlYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=/VFrQTqtmw8M3JqCJ35gBTW/wMAKmrJTc9j9D0crIWw=;
        b=MzMS718Sq8iDUbOeJ6/CPWBEU5YIiHsYbEFuUNlwlJHlAz6mbWZueGivFQ6iR4HB4p
         GMWdff9V8FRuTiDr+uE5aAWgB5vPuzqzJuvvuBGa9VBrYSmyMm6Mdjuvdh2lRjx6NAVm
         dERId89DtYW2wU0EjhsmPfgOw59cBsyLl3uyEzNq2OHe+OtVPvSZBlNwtB3b5mwMu3Cq
         pRKLwIMZ+le6c2e/9hVlMDKZbbXvyelIywsSN25nwBE/51eaOunR604HYoXu9Rl1rvhT
         6sS8zaegK8ya5ofqOUvkHa+PUCS85jV63EVeIqxMva0lvXi5o58oohiEmaIMs0wmQQBb
         e64g==
X-Gm-Message-State: AGi0PubwXXXIvMBoEHysH+T65PeCmLZPKles/kazyeHy9tncvmoXo2Jd
        WR5GBg1w0xSAuLrmpl7OhZI=
X-Google-Smtp-Source: APiQypIXEWUe3xMzWEKDgvz7Hr4DbHJxlfpwZyJ56aIjOwl6kfXIcg6wQjBCTfMZpakW2v0FJ2ya/g==
X-Received: by 2002:a1c:7715:: with SMTP id t21mr13727190wmi.182.1588596262875;
        Mon, 04 May 2020 05:44:22 -0700 (PDT)
Received: from localhost.localdomain ([86.121.118.29])
        by smtp.gmail.com with ESMTPSA id 32sm17343670wrg.19.2020.05.04.05.44.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 May 2020 05:44:22 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com
Cc:     davem@davemloft.net, jiri@resnulli.us, idosch@idosch.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        nikolay@cumulusnetworks.com, roopa@cumulusnetworks.com,
        georg.waibel@sensor-technik.de, o.rempel@pengutronix.de,
        christian.herber@nxp.com
Subject: [RFC 6/6] docs: net: dsa: sja1105: document the best_effort_vlan_filtering option
Date:   Mon,  4 May 2020 15:43:25 +0300
Message-Id: <20200504124325.26758-7-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200504124325.26758-1-olteanv@gmail.com>
References: <20200504124325.26758-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 .../networking/devlink-params-sja1105.txt     | 24 ++++++++++
 Documentation/networking/dsa/sja1105.rst      | 46 +++++++++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/Documentation/networking/devlink-params-sja1105.txt b/Documentation/networking/devlink-params-sja1105.txt
index 5096a4cf923c..576dcc6e2d96 100644
--- a/Documentation/networking/devlink-params-sja1105.txt
+++ b/Documentation/networking/devlink-params-sja1105.txt
@@ -7,3 +7,27 @@ hostprio		[DEVICE, DRIVER-SPECIFIC]
 			your PTP frames.
 			Configuration mode: runtime
 			Type: u8. 0-7 valid.
+
+best_effort_vlan_filtering
+			[DEVICE, DRIVER-SPECIFIC]
+			Allow plain ETH_P_8021Q headers to be used as DSA tags.
+			Benefits:
+			- Can terminate untagged traffic over switch net
+			  devices even when enslaved to a bridge with
+			  vlan_filtering=1.
+			- Can terminate VLAN-tagged traffic over switch net
+			  devices even when enslaved to a bridge with
+			  vlan_filtering=1, with some constraints (no more than
+			  7 VLANs per user port).
+			- Can do QoS based on VLAN PCP and VLAN membership
+			  admission control for autonomously forwarded frames
+			  (regardless of whether they can be terminated on the
+			  CPU or not).
+			Drawbacks:
+			- User cannot use VLANs in range 1024-3071. If the
+			  switch receives frames with such VIDs, it will
+			  misinterpret them as DSA tags.
+			- Switch uses Shared VLAN Learning (FDB lookup uses
+			  only DMAC as key).
+			Configuration mode: runtime
+			Type: bool.
diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 4a8639cba1f3..d963ff2ac1c9 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -77,6 +77,52 @@ change.
 The TPID is restored when ``vlan_filtering`` is requested by the user through
 the bridge layer, and general IP termination becomes no longer possible through
 the switch netdevices in this mode.
+There exists a third configuration option, via ``best_effort_vlan_filtering``.
+This permits termination of some traffic on switch net devices, at the expense
+of losing some VLAN filtering abilities: reduced range of usable VIDs and
+shared VLAN learning.
+The frames which can be terminated on the CPU in this mode are:
+- All untagged frames
+- VLAN-tagged frames, up to 7 different VLANs per user port
+This operating mode is slightly insane to be collated with the default
+``vlan_filtering``, so it is an opt-in that needs to be enabled using a devlink
+parameter. To enable it::
+
+  ip link set dev br0 type bridge vlan_filtering 1
+  [   61.204770] sja1105 spi0.1: Reset switch and programmed static config. Reason: VLAN filtering
+  [   61.239944] sja1105 spi0.1: Disabled switch tagging
+  devlink dev param set spi/spi0.1 name best_effort_vlan_filtering value true cmode runtime
+  [   64.682927] sja1105 spi0.1: Reset switch and programmed static config. Reason: VLAN filtering
+  [   64.711925] sja1105 spi0.1: Enabled switch tagging
+  bridge vlan add dev swp2 vid 1025 untagged pvid
+  RTNETLINK answers: Operation not permitted
+  bridge vlan add dev swp2 vid 100
+  bridge vlan add dev swp2 vid 101 untagged
+  bridge vlan
+  port    vlan ids
+  swp5     1 PVID Egress Untagged
+
+  swp2     1 PVID Egress Untagged
+           100
+           101 Egress Untagged
+
+  swp3     1 PVID Egress Untagged
+
+  swp4     1 PVID Egress Untagged
+
+  br0      1 PVID Egress Untagged
+  bridge vlan add dev swp2 vid 102
+  bridge vlan add dev swp2 vid 103
+  bridge vlan add dev swp2 vid 104
+  bridge vlan add dev swp2 vid 105
+  bridge vlan add dev swp2 vid 106
+  bridge vlan add dev swp2 vid 107
+  [ 3885.216832] sja1105 spi0.1: No more free subvlans
+
+The "No more free subvlans" warning message means that once the capacity is
+exceeded, frames tagged with newly added VLANs (in this case 107) are not able
+to be terminated on the CPU. They are still accepted and forwarded
+autonomously.
 
 The switches have two programmable filters for link-local destination MACs.
 These are used to trap BPDUs and PTP traffic to the master netdevice, and are
-- 
2.17.1

