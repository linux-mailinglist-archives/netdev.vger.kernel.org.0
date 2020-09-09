Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9AA5F2635EE
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 20:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgIIS0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 14:26:08 -0400
Received: from mailrelay105.isp.belgacom.be ([195.238.20.132]:5249 "EHLO
        mailrelay105.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725975AbgIIS0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 14:26:06 -0400
IronPort-SDR: zA9XNXEXspEXpvQAk0e0EupO3hw14WwrAkNg2p18c00um0kWtImOjXUXDKjIKJ6dn+mKrW/8ik
 f3jPcfGEfL8I/U+QWJSotKeaqR/5cjXRhHyBqr1Whyek7Pdk8Ppbw7/VAiGlQTB5TypClQZvpL
 sZrb7XFOu1kQeXlm+Qj5eLnJxAcAOtxzli+ga8bvvwyBgDSC2mZZj4vec7h1xvtgMwgTImibVl
 QF6Nma1Gnsf8D2Ssnh/+7o8B9licIZ535M83fniN+HXuoGLLQfn2h1Rz32rjv0RT6V5KjLACWr
 pt4=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AeDLf1BBpoPA3EDn6N3DJUyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSP36oc+wAkXT6L1XgUPTWs2DsrQY0rSQ6v29EjxRqb+681k6OKRWUB?=
 =?us-ascii?q?EEjchE1ycBO+WiTXPBEfjxciYhF95DXlI2t1uyMExSBdqsLwaK+i764jEdAA?=
 =?us-ascii?q?jwOhRoLerpBIHSk9631+ev8JHPfglEnjWwba5zIRmssAnctskbjYRhJ6s11x?=
 =?us-ascii?q?DEvmZGd+NKyG1yOFmdhQz85sC+/J5i9yRfpfcs/NNeXKv5Yqo1U6VWACwpPG?=
 =?us-ascii?q?4p6sLrswLDTRaU6XsHTmoWiBtIDBPb4xz8Q5z8rzH1tut52CmdIM32UbU5Ui?=
 =?us-ascii?q?ms4qt3VBPljjoMOjgk+2/Vl8NwlrpWrhK/qRJizYDaY4abO/VxcK7GYd8XRn?=
 =?us-ascii?q?BMUtpLWiBdHo+xaZYEAeobPeZfqonwv1sAogGlCgmtHuzvzCJDiH/s3aIkzu?=
 =?us-ascii?q?suDxvG3A08ENINrX/Zq9v1O70JXuC716TI1jbDbvNQ2Tjj9IjEaAsuru+VUL?=
 =?us-ascii?q?92bMHexlUhGRnfgVWMtYzqISmV1uIVvmaV7OdtUeKhhm8npg1vrDWhxtohhp?=
 =?us-ascii?q?XUio4Jy13K+ip3zZs7KNCmVUN2YdypHYVfuS2GOYV4TccvTWFotiokzrALv4?=
 =?us-ascii?q?OwcisSyJk/wxPTduaLf5WL7x79TuqdPDZ1iXJ/dL6ihhu/91WrxPfmWcmuyl?=
 =?us-ascii?q?lKqzJIktzLtn8QyRPe8tOHSv5h/ke53jaPyhzT5vlEIU8qkarbLIYswro3lp?=
 =?us-ascii?q?UPq0vDGi/2mELtjK+KbEkk/u+o5Pj9bbXiu5CcMIp0hRv/MqQogsC/AOI4PR?=
 =?us-ascii?q?YSX2WD/emwyafv8VD6TblUlPE6j6jUvZDAKcgGp6O1GwpV3Zwi6xa7ATemyt?=
 =?us-ascii?q?MYnXwfIVJLYh2IlIbpNkrVIPD7Dfa/hUqjkCtxy//dILLtGo/NIWTbkLf9Yb?=
 =?us-ascii?q?Z97FZRyBIpwt9E45JUDaoMIPTtVU/tutzYDxs5MxCqzOb9Etl90ZkeWW2XCK?=
 =?us-ascii?q?+DLKzSqUOI5v4oI+SUZ48aoivyK/w76PHylnI5n0ESfbWn3ZsWbHC4AuppI1?=
 =?us-ascii?q?+DbXrrmNcBHn8AvhAiQ+zylF2CTTlTam68X6My/Tw7E56mDZ3HRo+zhryNxj?=
 =?us-ascii?q?q0EYNObGBcFl+MCWvod5mDW/oUbiKdPNNhkjIFVbilV48uywuuuBbnxLV5MO?=
 =?us-ascii?q?rb5CkYuIn91Nh6+eLTjws+9T9qAMSH1WGCUWV0knkPRz8s06B1uVZ9xUub0a?=
 =?us-ascii?q?hkn/xYEsRe6O9OUgcgK5Hc0/J1BMr3Wg/aeNeGVkqmQtunATE1UtI+3cUOb1?=
 =?us-ascii?q?x6G9W4gRDJxzCqDKMNl7yXGJw09brR337vKMZh1nnJyrchgkI4QstAK2KmnL?=
 =?us-ascii?q?Rz9wvNCI7TlUWWiaKqeb4b3C7X+2eJ1XCOs11AUA5sTaXFWmgSZkXMotvi6E?=
 =?us-ascii?q?PPVKSuCbcnMwtH18GCNrFGZcb3ggYOePC2IN3UZ2WZnWqsCxeM2r6WKo3wdC?=
 =?us-ascii?q?FV3yzRDEUPuwYe4XiHMRQzHGGmuW2aRDJxPUnzeUfh969ypSCVVEgxmi+DZU?=
 =?us-ascii?q?xo0fKb4BMZiOadQPBbirwNsikJsDZlGluhmdjbXYnT7zF9dblRNItuqGxM0n?=
 =?us-ascii?q?jU4lRw?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2AdEgCXHVlf/xCltltfHAEBATwBAQQ?=
 =?us-ascii?q?EAQECAQEHAQEcgUqBHCACAQEBgVdVX406klGQGYFpCwEBAQEBAQEBASMRAQI?=
 =?us-ascii?q?EAQGES4IUJTgTAgMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDUgEjI4E/EoM?=
 =?us-ascii?q?mAYJXKbUihBCEdYFCgTYCAQEBAQGIJ4UZgUE/hF+EJIYQBJonnEOCb4MNhF1?=
 =?us-ascii?q?+kTsPIaBWklGhaoF6TSAYgyQJRxkNnGhCMDcCBgoBAQMJVwE9AY0yAQE?=
X-IPAS-Result: =?us-ascii?q?A2AdEgCXHVlf/xCltltfHAEBATwBAQQEAQECAQEHAQEcg?=
 =?us-ascii?q?UqBHCACAQEBgVdVX406klGQGYFpCwEBAQEBAQEBASMRAQIEAQGES4IUJTgTA?=
 =?us-ascii?q?gMBAQEDAgUBAQYBAQEBAQEFBAGGD0WCNyKDUgEjI4E/EoMmAYJXKbUihBCEd?=
 =?us-ascii?q?YFCgTYCAQEBAQGIJ4UZgUE/hF+EJIYQBJonnEOCb4MNhF1+kTsPIaBWklGha?=
 =?us-ascii?q?oF6TSAYgyQJRxkNnGhCMDcCBgoBAQMJVwE9AY0yAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 09 Sep 2020 20:26:01 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH 1/3 nf] selftests: netfilter: add cpu counter check
Date:   Wed,  9 Sep 2020 20:25:36 +0200
Message-Id: <20200909182536.23730-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

run task on first CPU with netfilter counters reset and check
cpu meta after another ping

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index d250b84dd5bc3..17b2d6eaa2044 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -33,6 +33,7 @@ table inet filter {
 	counter infproto4count {}
 	counter il4protocounter {}
 	counter imarkcounter {}
+	counter icpu0counter {}
 
 	counter oifcount {}
 	counter oifnamecount {}
@@ -54,6 +55,7 @@ table inet filter {
 		meta nfproto ipv4 counter name "infproto4count"
 		meta l4proto icmp counter name "il4protocounter"
 		meta mark 42 counter name "imarkcounter"
+		meta cpu 0 counter name "icpu0counter"
 	}
 
 	chain output {
@@ -119,6 +121,18 @@ check_one_counter omarkcounter "1" true
 
 if [ $ret -eq 0 ];then
 	echo "OK: nftables meta iif/oif counters at expected values"
+else
+	exit $ret
+fi
+
+#First CPU execution and counter
+taskset -p 01 $$ > /dev/null
+ip netns exec "$ns0" nft reset counters > /dev/null
+ip netns exec "$ns0" ping -q -c 1 127.0.0.1 > /dev/null
+check_one_counter icpu0counter "2" true
+
+if [ $ret -eq 0 ];then
+	echo "OK: nftables meta cpu counter at expected values"
 fi
 
 exit $ret
-- 
2.27.0

