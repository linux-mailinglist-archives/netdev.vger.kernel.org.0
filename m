Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD3F813ECD
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 12:20:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbfEEKT5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 06:19:57 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:52040 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727634AbfEEKTv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 06:19:51 -0400
Received: by mail-wm1-f67.google.com with SMTP id o189so1235262wmb.1
        for <netdev@vger.kernel.org>; Sun, 05 May 2019 03:19:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=aqu/zQS09ewb1G4Wa4WublPI5o5YD4QdubNz+2syEoU=;
        b=IW2sdlUKMrNsEegfcouCUFQX5/hUrMpdOJ2sAlw5SNXalHUL7kJZKlVRd219nD7rkA
         EF5CFXqba5RDgXxLDSuYboenRffuSHjXc46cAAt9BDaFnXIZEcmp3q/1Zo2RXZ7FI4Vl
         3TRR1sB9Y3ez/i1BCDWGeoTM5W1iOpBCKOzPZ9XCCmO+17nEE+vWmOlLtLG78czMoy+A
         OwgAiATsX8lcUAA95XK5f1M/X0TrBakzAJXBOnR+u1Sf+XXD9v6PqY2wTPgzBYxUJDcx
         jFJ5ODbbQPmNBHMHTjcso9Ke+v9/RtJk1GLEoLGxFCA0BVJLQ28QuiBkDdjqGJ7jm7j3
         7LOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=aqu/zQS09ewb1G4Wa4WublPI5o5YD4QdubNz+2syEoU=;
        b=AzKeTaaOpC37RYyiQC9vSZ1xSM7Go7hz7DHFAPrxLh2YsV+ToQI0ePEoETmD0W0aZN
         jrDp6ZKhMfvJTGBeNgyNNo2tOvl5tU5l3JHem/lEtvtSTX2Jyrv/bi3lQiailEk66FYQ
         S2+ru7IooLKZwJ7i7PYnX6LKaTbj6XopL1Rh7QJNgStZwe9KVt0QWbcPGeN6wi3TYZYe
         /UHcxGBgc2oEQ3QO54Q1KqziNr1vIqeeYkQxfA6CTPu+CGXAUXSsIVSibT7v2R3m6PjX
         QqCUmuILofpBEMk0i1pp/ToI0Z3M/5kma8K/Mjt0mVGIBR02FKg/g3TmsKpf7iB4FVsJ
         R8Eg==
X-Gm-Message-State: APjAAAVrAMNIVcH/64fpNAstCV6sVcZQ+2YluVJRMddquUygpcFUhBUP
        dEbd3v4+vBcHVpW+6V/6HiI=
X-Google-Smtp-Source: APXvYqxml/pZZOqsEXKmnN/DuJS61XngkDrRoMEa0bTvfdF1zSkme1j1VPz+8lp+5cWxnN8iRP6pqA==
X-Received: by 2002:a1c:f311:: with SMTP id q17mr13008132wmq.144.1557051589689;
        Sun, 05 May 2019 03:19:49 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id n2sm12333193wra.89.2019.05.05.03.19.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 05 May 2019 03:19:49 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next v3 10/10] Documentation: net: dsa: sja1105: Add info about supported traffic modes
Date:   Sun,  5 May 2019 13:19:29 +0300
Message-Id: <20190505101929.17056-11-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190505101929.17056-1-olteanv@gmail.com>
References: <20190505101929.17056-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This adds a table which illustrates what combinations of management /
regular traffic work depending on the state the switch ports are in.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
Changes in v3:
  - Added a commit description.

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

