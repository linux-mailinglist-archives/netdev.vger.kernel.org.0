Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E283A2FF794
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 22:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727246AbhAUVs4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 16:48:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726817AbhAUVsC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jan 2021 16:48:02 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEF10C06174A
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 13:47:21 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id r12so4748689ejb.9
        for <netdev@vger.kernel.org>; Thu, 21 Jan 2021 13:47:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nFBGVrQMhP/doQBKxQrwiuIwaLmh9z6Gvgpf1qs9CgI=;
        b=N1TYUwAPz7hjvu/FeVBk4oWdQruqMf6hQ+FhnkpDM2Gc8uayGNdZZHLkb8r93HSJfT
         72mPOF9MZwziA/8UvFQLAyFO+wTo75EKt13akudS0Yo+0soznPwiqPysW/FmEHqcHD9e
         UhkST2xxChaiwtHsNsCphGjIlN02wsCdXUT8iE5w6/1KRJpsrRXUmIowupLHSvnt39Kl
         7nnlOt5Ri8Z/0sv8eGNyD47wMBMpTh5F3JxpE7vLf6fdaJbI04zAGsk9kbP5NxZIyg3+
         jtVXqwmzvL3mAOtIZIYS8xznfIEQIjS45Lhbv3qSJqlXssh97hCWTukPiKoPAIRMzqn5
         l6BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=nFBGVrQMhP/doQBKxQrwiuIwaLmh9z6Gvgpf1qs9CgI=;
        b=E6KazHMAxuoE918Rl9HBbQOJD+yq24YG4af/7chJBPncTcKAFFTljdvPKYlDXFZvKo
         L3aNJyDWDU/0a7RSr13CDbR3z+KPq49CsXiq0sNEk2dX0jK6Qh0qYq25NbrtlHyzfiCt
         OEPi+6p8YVwjuIbMWWdZlluYqME+rZTRHV639AzLwtn7gdSRHpBFmzrEzKMb+FNGQxRm
         JD/57+lTPCK2WibA37kV4r2ko1PD9h6eOZnotBFf2DkR7IuWm3Cvh+OQh0T4FLHHHJFu
         SiNHRyTVv7IKKTerJpL6+P6Ze3nWxQ7HeWpu8bA2YokouKKx0IL5OuZIUK16FidmCVY6
         ACnQ==
X-Gm-Message-State: AOAM530XrVp8E3F2jkv/px4KTdBeb8wsjkCUVWWzLS3XrqgFXlqYhkrU
        T+RFFUR9Znv5ToLslleWnKJZBRFk3sk=
X-Google-Smtp-Source: ABdhPJyWvkRGNHMOE714aeU/c6lFQtQiCBsR8sBoCI4eCCmmJtD07IchqG15IF9ord7yt+Pq+vjbCw==
X-Received: by 2002:a17:906:2f07:: with SMTP id v7mr954701eji.343.1611265640613;
        Thu, 21 Jan 2021 13:47:20 -0800 (PST)
Received: from localhost.localdomain (5-12-227-87.residential.rdsnet.ro. [5.12.227.87])
        by smtp.gmail.com with ESMTPSA id hr3sm2753925ejc.41.2021.01.21.13.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Jan 2021 13:47:20 -0800 (PST)
From:   Vladimir Oltean <olteanv@gmail.com>
To:     David Ahern <dsahern@gmail.com>, netdev@vger.kernel.org
Cc:     Vinicius Costa Gomes <vinicius.gomes@intel.com>,
        Vedang Patel <vedang.patel@intel.com>
Subject: [PATCH iproute2] man: tc-taprio.8: document the full offload feature
Date:   Thu, 21 Jan 2021 23:47:08 +0200
Message-Id: <20210121214708.2477352-1-olteanv@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

Since this feature's introduction in commit 9c66d1564676 ("taprio: Add
support for hardware offloading") from kernel v5.4, it never got
documented in the man pages. Due to this reason, we see customer reports
of seemingly contradictory information: the community manpages claim
there is no support for full offload, nonetheless many silicon vendors
have already implemented it.

This patch documents the full offload feature (enabled by specifying
"flags 2" to the taprio qdisc) and gives one more example that tries to
illustrate some of the finer points related to the usage.

Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
---
 man/man8/tc-taprio.8 | 58 ++++++++++++++++++++++++++++++++++++++------
 1 file changed, 50 insertions(+), 8 deletions(-)

diff --git a/man/man8/tc-taprio.8 b/man/man8/tc-taprio.8
index e1d19ba19089..ed3a2c06e0e9 100644
--- a/man/man8/tc-taprio.8
+++ b/man/man8/tc-taprio.8
@@ -92,7 +92,11 @@ in the schedule;
 clockid
 .br
 Specifies the clock to be used by qdisc's internal timer for measuring
-time and scheduling events.
+time and scheduling events. This argument must be omitted when using the
+full-offload feature (flags 0x2), since in that case, the clockid is
+implicitly /dev/ptpN (where N is given by
+.B ethtool -T eth0 | grep 'PTP Hardware Clock'
+), and therefore not necessarily synchronized with the system's CLOCK_TAI.
 
 .TP
 sched-entry
@@ -115,13 +119,26 @@ before moving to the next entry.
 .TP
 flags
 .br
-Specifies different modes for taprio. Currently, only txtime-assist is
-supported which can be enabled by setting it to 0x1. In this mode, taprio will
-set the transmit timestamp depending on the interval in which the packet needs
-to be transmitted. It will then utililize the
-.BR etf(8)
-qdisc to sort and transmit the packets at the right time. The second example
-can be used as a reference to configure this mode.
+This is a bit mask which specifies different modes for taprio.
+.RS
+.TP
+.I 0x1
+Enables the txtime-assist feature. In this mode, taprio will set the transmit
+timestamp depending on the interval in which the packet needs to be
+transmitted. It will then utililize the .BR etf(8) qdisc to sort and transmit
+the packets at the right time. The second example can be used as a reference to
+configure this mode.
+.TP
+.I 0x2
+Enables the full-offload feature. In this mode, taprio will pass the gate
+control list to the NIC which will execute cyclically it in hardware.
+When using full-offload, there is no need to specify the
+.B clockid
+argument.
+
+The txtime-assist and full-offload features are mutually exclusive, i.e.
+setting flags to 0x3 is invalid.
+.RE
 
 .TP
 txtime-delay
@@ -178,5 +195,30 @@ for more information about configuring the ETF qdisc.
               offload delta 200000 clockid CLOCK_TAI
 .EE
 
+The following is an example to enable the full-offload mode in taprio. The
+.B base-time
+is 200 ns and the
+.B cycle-time
+is implicitly calculated as the sum of all
+.B sched-entry
+durations (i.e. 20 us + 20 us + 60 us = 100 us). Because the
+.B base-time
+is when the administratively configured schedule will become operational, this
+in turn means that the hardware will start executing the schedule at a PTP time
+equal to the smallest integer multiple of 100 us, plus 200 ns, that is larger
+than the NIC's current PTP time.
+
+.EX
+# tc qdisc add dev eth0 parent root taprio \\
+              num_tc 8 \\
+              map 0 1 2 3 4 5 6 7 \\
+              queues 1@0 1@1 1@2 1@3 1@4 1@5 1@6 1@7 \\
+              base-time 200 \\
+              sched-entry S 80 20000 \\
+              sched-entry S a0 20000 \\
+              sched-entry S df 60000 \\
+              flags 0x2
+.EE
+
 .SH AUTHORS
 Vinicius Costa Gomes <vinicius.gomes@intel.com>
-- 
2.25.1

