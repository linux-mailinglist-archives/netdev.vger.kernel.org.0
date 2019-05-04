Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F072A13A83
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 16:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbfEDOAF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 May 2019 10:00:05 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:39396 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727123AbfEDN7z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 May 2019 09:59:55 -0400
Received: by mail-wr1-f66.google.com with SMTP id a9so11337158wrp.6
        for <netdev@vger.kernel.org>; Sat, 04 May 2019 06:59:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fcdZSyklgi7K9FSsRh5grySW4jJiRCGA2nvA+DLoxac=;
        b=oSHPbfl98DmBmbKSi9a1dvQuKJZWIfT9tokPg9BWU2VuFIJhHkplNtcz82JFCT5CE4
         7CVkYpOWXdzpbO7NkcgXWginN9FD30CdWnQIhsoTvCcphb85FoSHBse+yKDD/ZsQ4kIl
         ZjVtqu73KwNmS4a55wkbuppQtXAltxv8vcofwl0rP5QGO+mMRAjiyTdAGbONUeVe95/l
         RY/B1LXlMkxvxvW5u65om2TIpkOtAyNq8OZlh98PJir5Dqr8yMrMyWsX0XWN4x++USh2
         VK+5M7VVFdf6OfFGLUrIr3tY60yy+n6k1e5J820gNO8IbBS6N4lUokELYJIe6I8NHVIX
         GxMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fcdZSyklgi7K9FSsRh5grySW4jJiRCGA2nvA+DLoxac=;
        b=GOy8yap+E2wrnxx1gBatOgO2Yoi1QOin5Rz0/hJFFg564lYGEvliBDj5y/43ipWjmN
         QjOQFzEUDgdJ38AACyiFIed1QYFFSrlfNVK+xxYigyv4wiMswWrZGKdwDB0upi5bIOrO
         GyUntBBCaPzjn+lbSMNmZxPYN5U20/+dfU438dTscF7I+nIURVUjX7yLeE6ED4H58i7h
         NA7uEgHfewWaUFpQVyCHwdusSH/EZJ++7DRNEieiKGlBbPtNz6aofeIeGrj4Q4Vp2bl2
         Y3VlbklvqoT/vcIa5TekdbTmrlSgGPJ++O78cXjZS+zRXPUYXLAr4bIDCP4r00Z+HhB7
         auvA==
X-Gm-Message-State: APjAAAWtEVf+qFjsKZBYjUBRUyqNfqwXM9EMKMTm7O0dRG3Q48qAQw24
        LX0qnPRAbKDdvJMCCLeL/cw=
X-Google-Smtp-Source: APXvYqzSdBO+Ui0VX8Pa/FQhHvSktLjkOR7Bq5Ipf/tHxSBN05DUN+2yQxWBT+zAUcAr/0t84ABPpQ==
X-Received: by 2002:adf:dd4a:: with SMTP id u10mr6449232wrm.152.1556978393846;
        Sat, 04 May 2019 06:59:53 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id s16sm5085940wrg.71.2019.05.04.06.59.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 06:59:53 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v2 9/9] Documentation: net: dsa: sja1105: Add info about supported traffic modes
Date:   Sat,  4 May 2019 16:59:19 +0300
Message-Id: <20190504135919.23185-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504135919.23185-1-olteanv@gmail.com>
References: <20190504135919.23185-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v2:
  - Added clarification about bridging other netdevices with swich
    ports.
  - Removed "Other notable features" section.

 Documentation/networking/dsa/sja1105.rst | 54 ++++++++++++++++++++++++
 1 file changed, 54 insertions(+)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 7c13b40915c0..ea7bac438cfd 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -63,6 +63,38 @@ If that changed setting can be transmitted to the switch through the dynamic
 reconfiguration interface, it is; otherwise the switch is reset and
 reprogrammed with the updated static configuration.
 
+Traffic support
+===============
+
+The switches do not support switch tagging in hardware. But they do support
+customizing the TPID by which VLAN traffic is identified as such. The switch
+driver is leveraging ``CONFIG_NET_DSA_TAG_8021Q`` by requesting that special
+VLANs (with a custom TPID of ``ETH_P_EDSA`` instead of ``ETH_P_8021Q``) are
+installed on its ports when not in ``vlan_filtering`` mode. This does not
+interfere with the reception and transmission of real 802.1Q-tagged traffic,
+because the switch does no longer parse those packets as VLAN after the TPID
+change.
+The TPID is restored when ``vlan_filtering`` is requested by the user through
+the bridge layer, and general IP termination becomes no longer possible through
+the switch netdevices in this mode.
+
+The switches have two programmable filters for link-local destination MACs.
+These are used to trap BPDUs and PTP traffic to the master netdevice, and are
+further used to support STP and 1588 ordinary clock/boundary clock
+functionality.
+
+The following traffic modes are supported over the switch netdevices:
+
++--------------------+------------+------------------+------------------+
+|                    | Standalone |   Bridged with   |   Bridged with   |
+|                    |    ports   | vlan_filtering 0 | vlan_filtering 1 |
++====================+============+==================+==================+
+| Regular traffic    |     Yes    |       Yes        |  No (use master) |
++--------------------+------------+------------------+------------------+
+| Management traffic |     Yes    |       Yes        |       Yes        |
+|    (BPDU, PTP)     |            |                  |                  |
++--------------------+------------+------------------+------------------+
+
 Switching features
 ==================
 
@@ -92,6 +124,28 @@ that VLAN awareness is global at the switch level is that once a bridge with
 ``vlan_filtering`` enslaves at least one switch port, the other un-bridged
 ports are no longer available for standalone traffic termination.
 
+Topology and loop detection through STP is supported.
+
+L2 FDB manipulation (add/delete/dump) is currently possible for the first
+generation devices. Aging time of FDB entries, as well as enabling fully static
+management (no address learning and no flooding of unknown traffic) is not yet
+configurable in the driver.
+
+A special comment about bridging with other netdevices (illustrated with an
+example):
+
+A board has eth0, eth1, swp0@eth1, swp1@eth1, swp2@eth1, swp3@eth1.
+The switch ports (swp0-3) are under br0.
+It is desired that eth0 is turned into another switched port that communicates
+with swp0-3.
+
+If br0 has vlan_filtering 0, then eth0 can simply be added to br0 with the
+intended results.
+If br0 has vlan_filtering 1, then a new br1 interface needs to be created that
+enslaves eth0 and eth1 (the DSA master of the switch ports). This is because in
+this mode, the switch ports beneath br0 are not capable of regular traffic, and
+are only used as a conduit for switchdev operations.
+
 Device Tree bindings and board design
 =====================================
 
-- 
2.17.1

