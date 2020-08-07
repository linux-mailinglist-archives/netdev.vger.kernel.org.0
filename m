Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B54E423F311
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 21:32:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726428AbgHGTcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Aug 2020 15:32:06 -0400
Received: from mailrelay110.isp.belgacom.be ([195.238.20.137]:57873 "EHLO
        mailrelay110.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725893AbgHGTcG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Aug 2020 15:32:06 -0400
IronPort-SDR: EKkHPZmFIQsR2DeSxGORNFwOAvV6Cqsba2MVemjr7NDO1g79M4jg6ZJ06fdDyG81ctz7TbHd67
 iIsja1UyDQ7XhHcWpYj/lGYGcdo/ajqAWzEfHeRAnG4k5Ei2NgjHNCE9RWJCvsZ8I3VsmF+VgW
 y54ln5Zh6/IwRm2zSItliz0sz8b3fpRmRbtgtnsAFtg5vMMZqOEZraTvxpb+0lJJLvjYkGCJeq
 ckZVxvc19rwJusVJKHw7qOJnvYG8K02WWL9RxlvXrLO/br+tzs250ZxBJi0AcacZrrXGyAer5g
 3ZU=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3A4JqgLxzU5lRYuJfXCy+O+j09IxM/srCxBDY+r6?=
 =?us-ascii?q?Qd0usQKfad9pjvdHbS+e9qxAeQG9mCtbQU0aGP6PuocFdDyK7JiGoFfp1IWk?=
 =?us-ascii?q?1NouQttCtkPvS4D1bmJuXhdS0wEZcKflZk+3amLRodQ56mNBXdrXKo8DEdBA?=
 =?us-ascii?q?j0OxZrKeTpAI7SiNm82/yv95HJbAhEmTuwbalxIRmoogndq8cbjIV/Iast1x?=
 =?us-ascii?q?XFpWdFdf5Lzm1yP1KTmBj85sa0/JF99ilbpuws+c1dX6jkZqo0VbNXAigoPG?=
 =?us-ascii?q?Az/83rqALMTRCT6XsGU2UZiQRHDg7Y5xznRJjxsy/6tu1g2CmGOMD9UL45VS?=
 =?us-ascii?q?i+46ptVRTljjoMOTwk/2HNksF+jLxVrg+vqRJ8xIDbb46bOeFicq7eZ94WWX?=
 =?us-ascii?q?BMUtpNWyFHH4iyb5EPD+0EPetAr4fyvUABrRqkCgmqGejhyiVIiWHr0qIkye?=
 =?us-ascii?q?QhEB3J3A89FN8JvnTbts76NKkJXOCuz6nJzTPDYO1K2Tvn84fHbAksrPeRVr?=
 =?us-ascii?q?1/bcTf01MgFx/ZjlqOs4zlOSuY2OoOvmWf7+RtVOKih3Appg9xvzWj2toghp?=
 =?us-ascii?q?XIi4waxV7J6Ct0zZgoKNC4SkN2f9GqHIdeuS+VM4Z4QsMsT39stSs817YIuo?=
 =?us-ascii?q?a7cTAOxZg63RLTdv+Kf5aS7h7+VeucIS10iG9kdb+5mh2861KvyvfmWcmxyF?=
 =?us-ascii?q?tKqy1FncTSuX0VzBzT79SHSuN6/ke8xTaDzwDT5f9AIUAzjafbL5khzaIqmZ?=
 =?us-ascii?q?oXsUTDGTT2mFnsgK+ScUUr5vKn6+D6bbXho5+TLY50igfmPqQvnMywH/g4Px?=
 =?us-ascii?q?AKUmSG4+iwyb7u8VPjTLlXj/A7krPVvI3bKMgDo662GQ5V0oIt6xalCDem1c?=
 =?us-ascii?q?wVnXcdI11edhKKlJPpO1LOIfD+E/i/n06gnyx1yPzeJL3uHo3NLmTfkLfmZb?=
 =?us-ascii?q?t981RTxxE3zdBY/J9UDK8OIO79Wk/wsNzYEgE2Mxauz+bgEtV92ZsUWXiTDa?=
 =?us-ascii?q?+BLKPSrViI6/osI+aWeYAVvCjyJOQ+6v7ok3A5hVEdfait3ZsLdn+4BO5qI0?=
 =?us-ascii?q?KDYXrjmt0BC3sFvhIiTOz2j12PSTBTZnipUqIn+jE7EoamApnFRoy3nbOOwj?=
 =?us-ascii?q?+xHodKaWBeFlCMDXDoep2CW/gSdCKSLM5hkjgYVbe/UY8tzAyhuxHky7V5Ku?=
 =?us-ascii?q?rZ4TMYtZ3929hv/eHTlg899SZyD8uD12GBVWZ0nnkHRzUuxqBwvVR9ykuf0a?=
 =?us-ascii?q?h/m/FXCdtT5+lXXQcmK5HT1el6Bsv0Wg3fYteJRlemQtG6AT4vVNI92dgOY1?=
 =?us-ascii?q?xyG9+6lBDMwzKqA6MJl7yMHJE09LzT32TsKMlj1XbLz7chj1Y4TctVL2Gmhb?=
 =?us-ascii?q?Bw9xLVB4HXl0WVjaGqdb4T3CTV7meM0XKOvF1EUA53SajFU2oQaVDYrdni/U?=
 =?us-ascii?q?PCTL+vCbI5PQtd08KNMbVFOZXVigBeTf3nP/zYbn6/mmOsCAzOwamDKMLpcm?=
 =?us-ascii?q?kZ0S71DkUYnQEX4Xuccw8kCWPprX32FyB0EV/pJU/hosdkr3buYEY+zgiMJ2?=
 =?us-ascii?q?N72ra44B8ehrTIRfoZ0JofuzYnpikyFlvrjIGeMMaJuwc0JPYUWtg6+loSjW?=
 =?us-ascii?q?8=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2ArBADUqy1f/xCltltgHQEBAQEJARI?=
 =?us-ascii?q?BBQUBR4FDgxlUX401kiyRegsBAQEBAQEBAQEnDQECBAEBhEyCOSU4EwIDAQE?=
 =?us-ascii?q?BAwIFAQEGAQEBAQEBBQQBhg9Fgjcig0YLASMjgT8JCYMmAYJXKbY9M4QQhSK?=
 =?us-ascii?q?BQIE4iB+FCoFBP4ERg06EH4YVBLYigmyDC4RZfZEmDyGgDZIroUOBek0gGIM?=
 =?us-ascii?q?kCUcZDZxoQjA3AgYIAQEDCVcBPQGPLl8BAQ?=
X-IPAS-Result: =?us-ascii?q?A2ArBADUqy1f/xCltltgHQEBAQEJARIBBQUBR4FDgxlUX?=
 =?us-ascii?q?401kiyRegsBAQEBAQEBAQEnDQECBAEBhEyCOSU4EwIDAQEBAwIFAQEGAQEBA?=
 =?us-ascii?q?QEBBQQBhg9Fgjcig0YLASMjgT8JCYMmAYJXKbY9M4QQhSKBQIE4iB+FCoFBP?=
 =?us-ascii?q?4ERg06EH4YVBLYigmyDC4RZfZEmDyGgDZIroUOBek0gGIMkCUcZDZxoQjA3A?=
 =?us-ascii?q?gYIAQEDCVcBPQGPLl8BAQ?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 07 Aug 2020 21:32:04 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 2/3 linux-next] selftests: netfilter: add MTU arguments to flowtables
Date:   Fri,  7 Aug 2020 21:31:50 +0200
Message-Id: <20200807193150.12684-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add some documentation, default values defined in original
script and Originator/Link/Responder arguments
using getopts like in tools/power/cpupower/bench/cpufreq-bench_plot.sh

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 .../selftests/netfilter/nft_flowtable.sh      | 30 +++++++++++++++----
 1 file changed, 24 insertions(+), 6 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 68a183753c6c3..e98cac6f8bfdd 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -2,13 +2,18 @@
 # SPDX-License-Identifier: GPL-2.0
 #
 # This tests basic flowtable functionality.
-# Creates following topology:
+# Creates following default topology:
 #
 # Originator (MTU 9000) <-Router1-> MTU 1500 <-Router2-> Responder (MTU 2000)
 # Router1 is the one doing flow offloading, Router2 has no special
 # purpose other than having a link that is smaller than either Originator
 # and responder, i.e. TCPMSS announced values are too large and will still
 # result in fragmentation and/or PMTU discovery.
+#
+# You can check with different Orgininator/Link/Responder MTU eg:
+# sh nft_flowtable.sh -o1000 -l500 -r100
+#
+
 
 # Kselftest framework requirement - SKIP code is 4.
 ksft_skip=4
@@ -78,11 +83,24 @@ ip -net nsr2 addr add dead:2::1/64 dev veth1
 # ns2 is going via nsr2 with a smaller mtu, so that TCPMSS announced by both peers
 # is NOT the lowest link mtu.
 
-ip -net nsr1 link set veth0 mtu 9000
-ip -net ns1 link set eth0 mtu 9000
+omtu=9000
+lmtu=1500
+rmtu=2000
+
+while getopts "o:l:r:" o
+do
+	case $o in
+		o) omtu=$OPTARG;;
+		l) lmtu=$OPTARG;;
+		r) rmtu=$OPTARG;;
+	esac
+done
+
+ip -net nsr1 link set veth0 mtu $omtu
+ip -net ns1 link set eth0 mtu $omtu
 
-ip -net nsr2 link set veth1 mtu 2000
-ip -net ns2 link set eth0 mtu 2000
+ip -net nsr2 link set veth1 mtu $rmtu
+ip -net ns2 link set eth0 mtu $rmtu
 
 # transfer-net between nsr1 and nsr2.
 # these addresses are not used for connections.
@@ -136,7 +154,7 @@ table inet filter {
       # as PMTUd is off.
       # This rule is deleted for the last test, when we expect PMTUd
       # to kick in and ensure all packets meet mtu requirements.
-      meta length gt 1500 accept comment something-to-grep-for
+      meta length gt $lmtu accept comment something-to-grep-for
 
       # next line blocks connection w.o. working offload.
       # we only do this for reverse dir, because we expect packets to
-- 
2.27.0

