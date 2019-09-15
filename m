Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D886BB2DA8
	for <lists+netdev@lfdr.de>; Sun, 15 Sep 2019 03:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727428AbfIOBxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 21:53:54 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:37977 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727217AbfIOBxw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 21:53:52 -0400
Received: by mail-wm1-f67.google.com with SMTP id o184so6443100wme.3
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 18:53:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Vyt1BUycDxbtNeB6ICgMD2o3mamJh9TM7X8icRGK/v8=;
        b=j0zVIV2a1rMqnPCopJji0UfeS0ojDageS74vuhLhi55AKLJW0GFoHCcFSiPsrwVNkm
         xjOt6yBDaeNHIa8KAv9a08tALvHEhCVweid37vl1DHWiLHc+ntSX9LW0MJ4dT0MWT7Yk
         i/OdmCULjovHuF73VsBZaV9sNjy7cnhIejPraRHrfIdeRH+1fYrQSeemlhgqi/ZF2T8I
         c7MGXdlgg3CWMlb4pw+lSiPlHwqNSjeDR9fBsrtiOS9ZaU4EI/eK9K98QOhAxUSCAdVV
         hIC24fuycaXk//3pwn/06EVqcVEMilbm1+0qYVtiWbr1H8o5qo4t5xy55ORBIV9ORCln
         0hlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Vyt1BUycDxbtNeB6ICgMD2o3mamJh9TM7X8icRGK/v8=;
        b=bT/XeMqf+02cHuyjr2a3bbcAUVXK+aAekQk5RAN6xiDLkZvrE/IWpHqayOK9hFbAff
         7F95kqpruKjUqIqv6nhUA9LfuGaW6YEU02fvmEHv1mhnwKGl8QHUFFRZYNXX5aGIo4it
         NOh6WYWgPhPQfEwr14BJwTNIdP9wJtrewoGRXopRJ/mXNwgCnYjAeIPSYwKRKTyOnUwh
         NWu47A55G0a0LmVfiaEOlHrLf60+J6HU/764MQDBoKq3jqI/yVYAzY11pOFnR2lB+MDM
         BGz+O/qpCdvndAPL+CE7qf0IKWnlmDsgiTt36U8crQRb7HW4DQEh9v4Vst8pmXI5uc1b
         om6w==
X-Gm-Message-State: APjAAAXuweqOCdr8zXEezzfmEAjvDhFlo7cPjkGRVT+Pf8lPB9uIWrws
        S6D64IIZMzcvGgYTALdjjoY=
X-Google-Smtp-Source: APXvYqxgnCphhbfXcBnxvXxnyL7IoS9+WHIaG6OhCpWHwHGXODlXBGcyTi2ZR3zaYMKLKEpsBxaz+Q==
X-Received: by 2002:a1c:bcd6:: with SMTP id m205mr8454156wmf.129.1568512429060;
        Sat, 14 Sep 2019 18:53:49 -0700 (PDT)
Received: from localhost.localdomain ([86.124.196.40])
        by smtp.gmail.com with ESMTPSA id p19sm5627044wmg.31.2019.09.14.18.53.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Sep 2019 18:53:48 -0700 (PDT)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     f.fainelli@gmail.com, vivien.didelot@gmail.com, andrew@lunn.ch,
        davem@davemloft.net, vinicius.gomes@intel.com,
        vedang.patel@intel.com, richardcochran@gmail.com
Cc:     weifeng.voon@intel.com, jiri@mellanox.com, m-karicheri2@ti.com,
        Jose.Abreu@synopsys.com, ilias.apalodimas@linaro.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        kurt.kanzenbach@linutronix.de, joergen.andreasen@microchip.com,
        netdev@vger.kernel.org, Vladimir Oltean <olteanv@gmail.com>
Subject: [PATCH v3 net-next 7/7] docs: net: dsa: sja1105: Add info about the time-aware scheduler
Date:   Sun, 15 Sep 2019 04:53:14 +0300
Message-Id: <20190915015314.26605-8-olteanv@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20190915015314.26605-1-olteanv@gmail.com>
References: <20190915015314.26605-1-olteanv@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

While not an exhaustive usage tutorial, this describes the details
needed to build more complex scenarios.

Signed-off-by: Vladimir Oltean <olteanv@gmail.com>
---
 Documentation/networking/dsa/sja1105.rst | 90 ++++++++++++++++++++++++
 1 file changed, 90 insertions(+)

diff --git a/Documentation/networking/dsa/sja1105.rst b/Documentation/networking/dsa/sja1105.rst
index cb2858dece93..2eaa6edf9c5b 100644
--- a/Documentation/networking/dsa/sja1105.rst
+++ b/Documentation/networking/dsa/sja1105.rst
@@ -146,6 +146,96 @@ enslaves eth0 and eth1 (the DSA master of the switch ports). This is because in
 this mode, the switch ports beneath br0 are not capable of regular traffic, and
 are only used as a conduit for switchdev operations.
 
+Offloads
+========
+
+Time-aware scheduling
+---------------------
+
+The switch supports a variation of the enhancements for scheduled traffic
+specified in IEEE 802.1Q-2018 (formerly 802.1Qbv). This means it can be used to
+ensure deterministic latency for priority traffic that is sent in-band with its
+gate-open event in the network schedule.
+
+This capability can be managed through the tc-taprio offload ('flags 2'). The
+difference compared to the software implementation of taprio is that the latter
+would only be able to shape traffic originated from the CPU, but not
+autonomously forwarded flows.
+
+The device has 8 traffic classes, and maps incoming frames to one of them based
+on the VLAN PCP bits (if no VLAN is present, the port-based default is used).
+As described in the previous sections, depending on the value of
+``vlan_filtering``, the EtherType recognized by the switch as being VLAN can
+either be the typical 0x8100 or a custom value used internally by the driver
+for tagging. Therefore, the switch ignores the VLAN PCP if used in standalone
+or bridge mode with ``vlan_filtering=0``, as it will not recognize the 0x8100
+EtherType. In these modes, injecting into a particular TX queue can only be
+done by the DSA net devices, which populate the PCP field of the tagging header
+on egress. Using ``vlan_filtering=1``, the behavior is the other way around:
+offloaded flows can be steered to TX queues based on the VLAN PCP, but the DSA
+net devices are no longer able to do that. To inject frames into a hardware TX
+queue with VLAN awareness active, it is necessary to create a VLAN
+sub-interface on the DSA master port, and send normal (0x8100) VLAN-tagged
+towards the switch, with the VLAN PCP bits set appropriately.
+
+Management traffic (having DMAC 01-80-C2-xx-xx-xx or 01-19-1B-xx-xx-xx) is the
+notable exception: the switch always treats it with a fixed priority and
+disregards any VLAN PCP bits even if present. The traffic class for management
+traffic is configurable through ``CONFIG_NET_DSA_SJA1105_HOSTPRIO``, which by
+default has a value of 7 (highest priority).
+
+Below is an example of configuring a 500 us cyclic schedule on egress port
+``swp5``. The traffic class gate for management traffic (7) is open for 100 us,
+and the gates for all other traffic classes are open for 400 us::
+
+  #!/bin/bash
+
+  set -e -u -o pipefail
+
+  NSEC_PER_SEC="1000000000"
+
+  gatemask() {
+          local tc_list="$1"
+          local mask=0
+
+          for tc in ${tc_list}; do
+                  mask=$((${mask} | (1 << ${tc})))
+          done
+
+          printf "%02x" ${mask}
+  }
+
+  if ! systemctl is-active --quiet ptp4l; then
+          echo "Please start the ptp4l service"
+          exit
+  fi
+
+  now=$(phc_ctl /dev/ptp1 get | gawk '/clock time is/ { print $5; }')
+  # Phase-align the base time to the start of the next second.
+  sec=$(echo "${now}" | gawk -F. '{ print $1; }')
+  base_time="$(((${sec} + 1) * ${NSEC_PER_SEC}))"
+
+  tc qdisc add dev swp5 parent root handle 100 taprio \
+          num_tc 8 \
+          map 0 1 2 3 5 6 7 \
+          queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \
+          base-time ${base_time} \
+          sched-entry S $(gatemask 7) 100000 \
+          sched-entry S $(gatemask "0 1 2 3 4 5 6") 400000 \
+          flags 2
+
+It is possible to apply the tc-taprio offload on multiple egress ports. There
+are hardware restrictions related to the fact that no gate event may trigger
+simultaneously on two ports. The driver checks the consistency of the schedules
+against this restriction and errors out when appropriate. Schedule analysis is
+needed to avoid this, which is outside the scope of the document.
+
+At the moment, the time-aware scheduler can only be triggered based on a
+standalone clock and not based on PTP time. This means the base-time argument
+from tc-taprio is ignored and the schedule starts right away. It also means it
+is more difficult to phase-align the scheduler with the other devices in the
+network.
+
 Device Tree bindings and board design
 =====================================
 
-- 
2.17.1

