Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D4A6136E0
	for <lists+netdev@lfdr.de>; Sat,  4 May 2019 03:19:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727353AbfEDBTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 21:19:02 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43063 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727279AbfEDBSu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 May 2019 21:18:50 -0400
Received: by mail-wr1-f67.google.com with SMTP id q10so1202832wrj.10;
        Fri, 03 May 2019 18:18:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=GMxx0hfNg0S6TyYo+/TlCXzUzs2MTlBPjkoBkX7WuR4=;
        b=ThXkQdds0bXV/6iNdU9sDDldrsniUrWXyrr5niTtye0xU22q6V/0VxKudOQJh1wIyI
         rDtXjfgFLeIIGvlgjoPUrZtH3GNN2lqjLWuF0l8QQRdktK0Wd5cZo1pewyuJCMeuk68S
         Ezf8PxdCFC9g78a1Xo9p4XZCcX5igkqsoi+ld5VEAMtyGt5MwUQcvBnYy9WPMDNNDkvm
         /Xed7J6Q5cCrexRAcTYmW/cPzUiZOps770YC2Uah0WjPjYfM1qQ6qziz1nQmo/+5UzrV
         rfCoHjPhpV9Dh7gDKwvBgUctMxSZ6XogIjFop8LtuzHcR4fnVO7ulgDaqQHnrv4Ir25E
         M5ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=GMxx0hfNg0S6TyYo+/TlCXzUzs2MTlBPjkoBkX7WuR4=;
        b=qh5jPTQ3INlCe8VibX3JcMy0Fmns+3bvEsB6nIV+msDSNZL6s/vJyLp0heS3sLcNB6
         LsuV0wlsLzmcKzgJRG4OMLQnPQIozDCru85JLXX5xSVskV4muu0nW64RZomdoLzGQM2H
         wpnmWCxNdWdrdr/iKldYFrtip1ZxYKaOVCqb4bQPnPGjUNY3tSPNn7XX9uGss8J4iSEg
         6o4Ad11WB5fSTJVNM5lEW4s5WY83SZcaW7MxjgkXfGRoj0pK8ZpOAQBFJrSjnMo0JuUw
         ylNPtgkMDLn0GGtbSycWvFTXI2+GfKa5/vbSmmTISWgRueGrnQSHvdUTiQHYl3YMCDze
         JmXg==
X-Gm-Message-State: APjAAAW24QFzftgEKuVbRuVPt7neYdtcPOECFNuP8paowbRpsPy2BuhO
        FfJXbWkv1gvEpB9ou0bnRV8=
X-Google-Smtp-Source: APXvYqxYVrjTJI6PgE5QIuCBsBKS8TK3l7sDnzcY0OsQIxwXzxX+gMarSylz7ciXcVQfRQFRABerwg==
X-Received: by 2002:adf:f2c9:: with SMTP id d9mr9461622wrp.36.1556932728532;
        Fri, 03 May 2019 18:18:48 -0700 (PDT)
Received: from localhost.localdomain (5-12-225-227.residential.rdsnet.ro. [5.12.225.227])
        by smtp.gmail.com with ESMTPSA id t1sm3937639wro.34.2019.05.03.18.18.47
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 May 2019 18:18:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH net-next 9/9] Documentation: net: dsa: sja1105: Add info about supported traffic modes
Date:   Sat,  4 May 2019 04:18:26 +0300
Message-Id: <20190504011826.30477-10-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190504011826.30477-1-olteanv@gmail.com>
References: <20190504011826.30477-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 Documentation/networking/dsa/sja1105.rst | 49 ++++++++++++++++++++++++
 1 file changed, 49 insertions(+)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index 7c13b40915c0..a70a04164d07 100644
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
 
@@ -92,6 +124,23 @@ that VLAN awareness is global at the switch level is that once a bridge with
 ``vlan_filtering`` enslaves at least one switch port, the other un-bridged
 ports are no longer available for standalone traffic termination.
 
+Topology and loop detection through STP is supported.
+
+L2 FDB manipulation (add/delete/dump) is currently possible for the first
+generation devices. Aging time of FDB entries, as well as enabling fully static
+management (no address learning and no flooding of unknown traffic) is not yet
+configurable in the driver.
+
+Other notable features
+======================
+
+The switches have a PTP Hardware Clock that can be steered through SPI and used
+for timestamping management traffic on ingress and egress.
+Also, the T, Q and S devices support TTEthernet (an implementation of SAE
+AS6802 from TTTech), which is a set of Ethernet QoS enhancements somewhat
+similar in behavior to IEEE TSN (time-aware shaping, time-based policing).
+Configuring these features is currently not supported in the driver.
+
 Device Tree bindings and board design
 =====================================
 
-- 
2.17.1

