Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4651318F48
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231563AbhBKP7K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 10:59:10 -0500
Received: from mx0a-0016f401.pphosted.com ([67.231.148.174]:3240 "EHLO
        mx0b-0016f401.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S230098AbhBKP53 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 10:57:29 -0500
Received: from pps.filterd (m0045849.ppops.net [127.0.0.1])
        by mx0a-0016f401.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 11BFuH3e009035;
        Thu, 11 Feb 2021 07:56:39 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=marvell.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-transfer-encoding : content-type; s=pfpt0220;
 bh=B/l0FIfNZlJvfBNIcbkduTaDEIa/8/6n+r6v57ctzhI=;
 b=BVJc1o3FvGYbqpYiqfG//IrmGFgQqzurjseD9hCwB/k+Vyb5+dv/3BbofqBnbwYsee5f
 NbOyFtGRa1VqOmZjB+ePS4ChDepbRuhBPPiGkeae0W8w8wHqEKuNn4F/BQ4z2qg+Y0aU
 QAAuU0EMcyQHsdMY0NwtjKAHIGe4YCZXW0wCATBBGNklCPYSlAano30Em/whbfCWyyO/
 NaL59MAphEir24+ZSHiWN66VkwXAWCCPSDusNDOFIM6ZAsofcNrb8txrKQbRuAlL0siN
 I/fg1kxfotnZgEP9My2IuQAXfjlWENTdCzj0p4lkV6sEXxNvucl3RzXqXwkeIxuZSsga fg== 
Received: from dc5-exch01.marvell.com ([199.233.59.181])
        by mx0a-0016f401.pphosted.com with ESMTP id 36hsbrqj62-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Thu, 11 Feb 2021 07:56:39 -0800
Received: from SC-EXCH02.marvell.com (10.93.176.82) by DC5-EXCH01.marvell.com
 (10.69.176.38) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:56:38 -0800
Received: from DC5-EXCH02.marvell.com (10.69.176.39) by SC-EXCH02.marvell.com
 (10.93.176.82) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Thu, 11 Feb
 2021 07:56:37 -0800
Received: from maili.marvell.com (10.69.176.80) by DC5-EXCH02.marvell.com
 (10.69.176.39) with Microsoft SMTP Server id 15.0.1497.2 via Frontend
 Transport; Thu, 11 Feb 2021 07:56:37 -0800
Received: from EL-LT0043.marvell.com (unknown [10.193.38.106])
        by maili.marvell.com (Postfix) with ESMTP id 446AF3F7040;
        Thu, 11 Feb 2021 07:56:36 -0800 (PST)
From:   Igor Russkikh <irusskikh@marvell.com>
To:     <netdev@vger.kernel.org>
CC:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Igor Russkikh <irusskikh@marvell.com>
Subject: [PATCH v2 net-next 1/2] samples: pktgen: allow to specify delay parameter via new opt
Date:   Thu, 11 Feb 2021 16:56:25 +0100
Message-ID: <20210211155626.25213-2-irusskikh@marvell.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210211155626.25213-1-irusskikh@marvell.com>
References: <20210211155626.25213-1-irusskikh@marvell.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.369,18.0.737
 definitions=2021-02-11_07:2021-02-11,2021-02-11 signatures=0
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DELAY may now be explicitly specified via common parameter -w

Signed-off-by: Igor Russkikh <irusskikh@marvell.com>
---
 samples/pktgen/parameters.sh                           | 10 +++++++++-
 samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh |  3 ---
 samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh    |  3 ---
 samples/pktgen/pktgen_sample01_simple.sh               |  3 ---
 samples/pktgen/pktgen_sample02_multiqueue.sh           |  1 -
 samples/pktgen/pktgen_sample03_burst_single_flow.sh    |  3 ---
 samples/pktgen/pktgen_sample04_many_flows.sh           |  3 ---
 samples/pktgen/pktgen_sample05_flow_per_thread.sh      |  3 ---
 .../pktgen_sample06_numa_awared_queue_irq_affinity.sh  |  1 -
 9 files changed, 9 insertions(+), 21 deletions(-)

diff --git a/samples/pktgen/parameters.sh b/samples/pktgen/parameters.sh
index ff0ed474fee9..70cc2878d479 100644
--- a/samples/pktgen/parameters.sh
+++ b/samples/pktgen/parameters.sh
@@ -19,12 +19,13 @@ function usage() {
     echo "  -v : (\$VERBOSE)   verbose"
     echo "  -x : (\$DEBUG)     debug"
     echo "  -6 : (\$IP6)       IPv6"
+    echo "  -w : (\$DELAY)     Tx Delay value (us)"
     echo ""
 }
 
 ##  --- Parse command line arguments / parameters ---
 ## echo "Commandline options:"
-while getopts "s:i:d:m:p:f:t:c:n:b:vxh6" option; do
+while getopts "s:i:d:m:p:f:t:c:n:b:w:vxh6" option; do
     case $option in
         i) # interface
           export DEV=$OPTARG
@@ -66,6 +67,10 @@ while getopts "s:i:d:m:p:f:t:c:n:b:vxh6" option; do
 	  export BURST=$OPTARG
 	  info "SKB bursting: BURST=$BURST"
           ;;
+        w)
+	  export DELAY=$OPTARG
+	  info "DELAY=$DELAY"
+          ;;
         v)
           export VERBOSE=yes
           info "Verbose mode: VERBOSE=$VERBOSE"
@@ -100,6 +105,9 @@ if [ -z "$THREADS" ]; then
     export THREADS=1
 fi
 
+# default DELAY
+[ -z "$DELAY" ] && export DELAY=0 # Zero means max speed
+
 export L_THREAD=$(( THREADS + F_THREAD - 1 ))
 
 if [ -z "$DEV" ]; then
diff --git a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
index 1b6204125d2d..30a610b541ad 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_netif_receive.sh
@@ -50,9 +50,6 @@ if [ -n "$DST_PORT" ]; then
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
-# Base Config
-DELAY="0"        # Zero means max speed
-
 # General cleanup everything since last run
 pg_ctrl "reset"
 
diff --git a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
index e607cb369b20..a6195bd77532 100755
--- a/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
+++ b/samples/pktgen/pktgen_bench_xmit_mode_queue_xmit.sh
@@ -33,9 +33,6 @@ if [ -n "$DST_PORT" ]; then
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
-# Base Config
-DELAY="0"        # Zero means max speed
-
 # General cleanup everything since last run
 pg_ctrl "reset"
 
diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen/pktgen_sample01_simple.sh
index a4e250b45dce..c2ad1fa32d3f 100755
--- a/samples/pktgen/pktgen_sample01_simple.sh
+++ b/samples/pktgen/pktgen_sample01_simple.sh
@@ -31,9 +31,6 @@ if [ -n "$DST_PORT" ]; then
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
-# Base Config
-DELAY="0"        # Zero means max speed
-
 # Flow variation random source port between min and max
 UDP_SRC_MIN=9
 UDP_SRC_MAX=109
diff --git a/samples/pktgen/pktgen_sample02_multiqueue.sh b/samples/pktgen/pktgen_sample02_multiqueue.sh
index cb2495fcdc60..49e1e81a2945 100755
--- a/samples/pktgen/pktgen_sample02_multiqueue.sh
+++ b/samples/pktgen/pktgen_sample02_multiqueue.sh
@@ -17,7 +17,6 @@ source ${basedir}/parameters.sh
 [ -z "$COUNT" ] && COUNT="100000" # Zero means indefinitely
 
 # Base Config
-DELAY="0"        # Zero means max speed
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 
 # Flow variation random source port between min and max
diff --git a/samples/pktgen/pktgen_sample03_burst_single_flow.sh b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
index fff50765a5aa..f9b67affb567 100755
--- a/samples/pktgen/pktgen_sample03_burst_single_flow.sh
+++ b/samples/pktgen/pktgen_sample03_burst_single_flow.sh
@@ -42,9 +42,6 @@ if [ -n "$DST_PORT" ]; then
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
-# Base Config
-DELAY="0"  # Zero means max speed
-
 # General cleanup everything since last run
 pg_ctrl "reset"
 
diff --git a/samples/pktgen/pktgen_sample04_many_flows.sh b/samples/pktgen/pktgen_sample04_many_flows.sh
index 2cd6b701400d..ac2d037a6160 100755
--- a/samples/pktgen/pktgen_sample04_many_flows.sh
+++ b/samples/pktgen/pktgen_sample04_many_flows.sh
@@ -34,9 +34,6 @@ fi
 [ -z "$FLOWS" ]     && FLOWS="8000"
 [ -z "$FLOWLEN" ]   && FLOWLEN="10"
 
-# Base Config
-DELAY="0"  # Zero means max speed
-
 if [[ -n "$BURST" ]]; then
     err 1 "Bursting not supported for this mode"
 fi
diff --git a/samples/pktgen/pktgen_sample05_flow_per_thread.sh b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
index 4cb6252ade39..85256484c86f 100755
--- a/samples/pktgen/pktgen_sample05_flow_per_thread.sh
+++ b/samples/pktgen/pktgen_sample05_flow_per_thread.sh
@@ -31,9 +31,6 @@ if [ -n "$DST_PORT" ]; then
     validate_ports $UDP_DST_MIN $UDP_DST_MAX
 fi
 
-# Base Config
-DELAY="0"  # Zero means max speed
-
 # General cleanup everything since last run
 pg_ctrl "reset"
 
diff --git a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
index 728106060a02..7c73ab8fbe3c 100755
--- a/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
+++ b/samples/pktgen/pktgen_sample06_numa_awared_queue_irq_affinity.sh
@@ -15,7 +15,6 @@ root_check_run_with_sudo "$@"
 source ${basedir}/parameters.sh
 
 # Base Config
-DELAY="0"        # Zero means max speed
 [ -z "$COUNT" ]     && COUNT="20000000"   # Zero means indefinitely
 [ -z "$CLONE_SKB" ] && CLONE_SKB="0"
 
-- 
2.25.1

