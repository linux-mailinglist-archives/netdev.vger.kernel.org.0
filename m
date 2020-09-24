Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1BF4276E79
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 12:18:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgIXKSa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 06:18:30 -0400
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:26251 "EHLO
        mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727003AbgIXKSa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 06:18:30 -0400
IronPort-SDR: DCfxdUB7+wkZiND4NjWP5owk82Lv8LVfOg2wenZiKWydMFcelbo1Q32WqPgTYVOXHg/thHHlxh
 VduG/K0Zk0c7iBn0ZFtZ8PrELGTAGgySK/0vP6Xar5Bm7lKh/wLRPntCn9EV20ExzPV4iJ9f+5
 u04TpeIfONtFInMRU8QKEgxWMN/IRjOHh/1qcO53FoDpUSUGmhbtoUtbmvUxbP1K8HhZERzlkO
 Lr7uGajBGS4fP51WxG6yUvNnqZotkmR9RL64Kz7VARRGUWXRoPDnumFi29e7YYosCDdyiCmAiw
 F+Q=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3A6+o6hR394WyQ1vt9smDT+DRfVm0co7zxezQtwd?=
 =?us-ascii?q?8ZsesXI/rxwZ3uMQTl6Ol3ixeRBMOHsq0C0rqd6f+oGTRZp8rY7jZaKN0Efi?=
 =?us-ascii?q?RGoP1epxYnDs+BBB+zB9/RRAt+Iv5/UkR49WqwK0lfFZW2TVTTpnqv8WxaQU?=
 =?us-ascii?q?2nZkJ6KevvB4Hdkdm82fys9J3PeQVIgye2ba9vIBmsogjdq8sbjZF/JqsyxR?=
 =?us-ascii?q?fFvHlFcPlSyW90OF6fhRnx6tqx8ZJ57yhcp/ct/NNcXKvneKg1UaZWByk8PW?=
 =?us-ascii?q?Av483ruxjDTQ+R6XYZT24bjBlGDRXb4R/jRpv+vTf0ueR72CmBIM35Vqs0Vi?=
 =?us-ascii?q?i476dqUxDnliEKPCMk/W7Ni8xwiKVboA+9pxF63oXZbp2ZOOZ4c6jAe94RWG?=
 =?us-ascii?q?hPUdtLVyFZAo2ycZYBAeQCM+hfoIbzqEADoQe9CAS2GO/i0CNEimPw0KYn0+?=
 =?us-ascii?q?ohCwbG3Ak4EtwOqnvbt9T1O70UUeuozKfI1yvMYO5I1jfn6YjHbhMhquyLUL?=
 =?us-ascii?q?J+a8Xe0kcvGhjejlWTqY3lOS2a1vgXv2eA8eVtTOSigHMopA9tuDag3Nssip?=
 =?us-ascii?q?XXiYIPzFDJ7St3zYUxKNO4SUN2YcCoHZVQuSyHK4d6X98uTmBntig117ALt4?=
 =?us-ascii?q?C2cTUKxZkl2RPRZOCLfYaH7B/nVOifISl0iXZjdbmihBiy6VCtx+nhWsWuzV?=
 =?us-ascii?q?pHrTRJnsPRun0M1xHf8NWLR/p780y8wziAzRrT5ftBIU0skKrbLIMuzaAom5?=
 =?us-ascii?q?oItETDAjf2mELrjK+Kbkkk+van6+DgYrj+op+cMJN7hRv6MqQuncy/Gvg4Ph?=
 =?us-ascii?q?IKX2ic5euzzrnj8lD+QLVPlPI2k6/ZvIjbJcQduKG5HxdY34I+5xqlEjur08?=
 =?us-ascii?q?oUkWMaIF9EeB+LlZXlNlDWLPD9F/i/glCskDlxx/DBO73sGpvNIWLYn7fvZr?=
 =?us-ascii?q?t98E1cyQo1zd9B+5JYEKoOL+zrVk/rqNPYFgM5MxCzw+v/ENVyzJgRWWaIAq?=
 =?us-ascii?q?KCNqPdr0OI5uwuI+mIeI8apiz9J+Ii5/70gn8zgUUdcrWx3ZsLdHC4GexrI0?=
 =?us-ascii?q?aDbnXxhtcOD3sFsxE4TOP0lF2CXz9TZ3KuX60i/DE3EoWmDZ3MRoq1mryOwD?=
 =?us-ascii?q?+7HoFKZmBBEl2MH3npep6fW/cQciKSJtFukjoeWbe8VYArzQuuuxPiy7p7Mu?=
 =?us-ascii?q?rU/TUVtZT929hp6e3TlBUy9SBqAMSHym2CUn97nn0WSD8yx61/v0N9xUmZ0a?=
 =?us-ascii?q?RigPxXC8ZT5/VXXQc+L5LcyPZ6C9/qUALbYtiJUEqmQsmhATwpUt0xxMUObF?=
 =?us-ascii?q?hhG9q8lB/D2jGnA7kLmLyXCpw086bc32TvKMZn0XrG07Mhj1Y+SMtVKWKmnr?=
 =?us-ascii?q?J/9xTUB4PRlUWWibqqerkC0y7T72qD02WOs19CUAJqUqXKQ2ofZk3IotT9/E?=
 =?us-ascii?q?/CSKWuCbs/OAtb1cGCMrdKasHujVheSvfsIs/RY2yqlmerBhaJxrWMY5T2e2?=
 =?us-ascii?q?kHxyrSFhtMrwdG5X+MMQ8WACq9rWPaEDF0U1X1bAek8uByrH6wZkk50w+La1?=
 =?us-ascii?q?Fszfyy4BFRzfKDY+gPxLYJvmEtpmZaBlG4ivzfAduJoUJPZqhQbMk861QPgW?=
 =?us-ascii?q?zQvQJVJZ+xKa1+wFQTJVck93jy3gl6X90T2fMhq2knmVJ/?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2CmQgAocmxf/xCltltgGgEBAQEBPAE?=
 =?us-ascii?q?BAQECAgEBAQECAQEBAQMBAQEBHIFKgRyBfFVfjT6SXpIECwEBAQEBAQEBASQ?=
 =?us-ascii?q?RAQIEAQGES4IuJTgTAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDUgEjI4E?=
 =?us-ascii?q?/EoMmAYJXKbc5hBCFI4FCgTgBiC6FGoFBP4ERg06KNASaV5xggnGDE4Rpf5F?=
 =?us-ascii?q?LDyKhDSuSWaIWgXpNIBiDJAlHGQ2caEIwNwIGCgEBAwlXAT0BjwQBAQ?=
X-IPAS-Result: =?us-ascii?q?A2CmQgAocmxf/xCltltgGgEBAQEBPAEBAQECAgEBAQECA?=
 =?us-ascii?q?QEBAQMBAQEBHIFKgRyBfFVfjT6SXpIECwEBAQEBAQEBASQRAQIEAQGES4IuJ?=
 =?us-ascii?q?TgTAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDUgEjI4E/EoMmAYJXKbc5h?=
 =?us-ascii?q?BCFI4FCgTgBiC6FGoFBP4ERg06KNASaV5xggnGDE4Rpf5FLDyKhDSuSWaIWg?=
 =?us-ascii?q?XpNIBiDJAlHGQ2caEIwNwIGCgEBAwlXAT0BjwQBAQ?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 24 Sep 2020 12:17:57 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/1 nf] selftests: netfilter: add time counter check
Date:   Thu, 24 Sep 2020 12:17:33 +0200
Message-Id: <20200924101733.11479-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Check packets are correctly placed in current year.
Also do a NULL check for another one.

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index 18a1abca32629..087f0e6e71ce7 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -23,6 +23,8 @@ ip -net "$ns0" addr add 127.0.0.1 dev lo
 
 trap cleanup EXIT
 
+currentyear=$(date +%G)
+lastyear=$((currentyear-1))
 ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table inet filter {
 	counter iifcount {}
@@ -33,6 +35,8 @@ table inet filter {
 	counter il4protocounter {}
 	counter imarkcounter {}
 	counter icpu0counter {}
+	counter ilastyearcounter {}
+	counter icurrentyearcounter {}
 
 	counter oifcount {}
 	counter oifnamecount {}
@@ -55,6 +59,8 @@ table inet filter {
 		meta l4proto icmp counter name "il4protocounter"
 		meta mark 42 counter name "imarkcounter"
 		meta cpu 0 counter name "icpu0counter"
+		meta time "$lastyear-01-01" - "$lastyear-12-31" counter name ilastyearcounter
+		meta time "$currentyear-01-01" - "$currentyear-12-31" counter name icurrentyearcounter
 	}
 
 	chain output {
@@ -100,8 +106,7 @@ check_lo_counters()
 
 	for counter in iifcount iifnamecount iifgroupcount iiftypecount infproto4count \
 		       oifcount oifnamecount oifgroupcount oiftypecount onfproto4count \
-		       il4protocounter \
-		       ol4protocounter \
+		       il4protocounter icurrentyearcounter ol4protocounter \
 	     ; do
 		check_one_counter "$counter" "$want" "$verbose"
 	done
@@ -116,6 +121,7 @@ check_one_counter oskuidcounter "1" true
 check_one_counter oskgidcounter "1" true
 check_one_counter imarkcounter "1" true
 check_one_counter omarkcounter "1" true
+check_one_counter ilastyearcounter "0" true
 
 if [ $ret -eq 0 ];then
 	echo "OK: nftables meta iif/oif counters at expected values"
-- 
2.27.0

