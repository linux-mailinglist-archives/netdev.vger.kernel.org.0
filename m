Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 617BA24EF2A
	for <lists+netdev@lfdr.de>; Sun, 23 Aug 2020 20:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726461AbgHWSQS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 Aug 2020 14:16:18 -0400
Received: from mailrelay102.isp.belgacom.be ([195.238.20.129]:53454 "EHLO
        mailrelay102.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725867AbgHWSQR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 Aug 2020 14:16:17 -0400
IronPort-SDR: KRjEKcX+MFJ7e8uWssBY0r0Frzl3tUAv4DXnRBN775yGG6uJ9bv8R2kbT59a+I30yMRy0rVG8R
 mm0B8BiTYRabS08t8fniIUww7GDQMooCaW43fEOicfitRHH8tD4IldXxrtlr269GV5OWwK2QAQ
 DFIP5iw6/KI/9sEfnhOoIXWkHdVO5pE3lq9l0xA1suMyu2ypp/+P8Ny6UVVgC2ONknN6XeDKlS
 J9Ey8yiO8zBj5UQsQ7HrTOuTYekUN6H2dShxllfe4rUGT4DWduJZNYpp/EKDpusNQ8KvyuTQqd
 ANQ=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3AfXOzXxxfXzIUxk7XCy+O+j09IxM/srCxBDY+r6?=
 =?us-ascii?q?Qd0ugVIvad9pjvdHbS+e9qxAeQG9mCtbQd0rSd6vq5EUU7or+5+EgYd5JNUx?=
 =?us-ascii?q?JXwe43pCcHRPC/NEvgMfTxZDY7FskRHHVs/nW8LFQHUJ2mPw6arXK99yMdFQ?=
 =?us-ascii?q?viPgRpOOv1BpTSj8Oq3Oyu5pHfeQpFiCe8bL9oMRm6sATcusYLjYd8N6o61w?=
 =?us-ascii?q?fErGZPd+lK321jOEidnwz75se+/Z5j9zpftvc8/MNeUqv0Yro1Q6VAADspL2?=
 =?us-ascii?q?466svrtQLeTQSU/XsTTn8WkhtTDAfb6hzxQ4r8vTH7tup53ymaINH2QLUpUj?=
 =?us-ascii?q?ms86tnVBnlgzoBOjUk8m/Yl9Zwgbpbrhy/uhJxzY3aboaaO/RxZa7RYdAXSH?=
 =?us-ascii?q?BdUstLSyBNHoWxZJYPAeobOuZYqpHwqVsUohSlBAmjHuXvwSJIiH/sw6I1zv?=
 =?us-ascii?q?ouERvH3AM8HNIFrXPZrNvvO6gJX+C417LIzTbDbvNQxzj99JLEfQs/rvyVW7?=
 =?us-ascii?q?97bMXex1U1GQzfklWQtZLqPymT1ukVvWaW7O5tW+KuhmMntQ18rDihy9owho?=
 =?us-ascii?q?XUmo4Yy1/K+ypkzYs7O9C1VU52bNy6HZVfqy2UOYR4T8ciTW9opio3zrsLso?=
 =?us-ascii?q?O4cigS0JkqwwPTZ+aaf4WL/B7vTvudLDZ4iX5/Zb6yhhC/+lW6xOLmTMm7yl?=
 =?us-ascii?q?NKozJAktnLq38CyQTe6tOCSvth5keh3iuP1xzL5uFEP080ka3bJoYlwr43ip?=
 =?us-ascii?q?Ucq0DDHi/xmEXtkK+abEEk+u+05Ov9ZrXpu5icN4puhQH/NKQigs2/AeImPQ?=
 =?us-ascii?q?gSR2WW/fmw2Kf+8UD6XrlGlOA6n6jZvZzAOMgWp7a1AwpP3YYi7xa/AS2m0N?=
 =?us-ascii?q?MdnXQfIlJKYgmIj4byNlHVI/D5DfG/jEqwkDtx3P/JIKXtAo/RIXjbjLfhYb?=
 =?us-ascii?q?F95lZEyAUp1t9f45VUB6oHIP3tRk/xut3YDhslMwOq2ebrEtJ91pkRWWiXGK?=
 =?us-ascii?q?+WLLvSsUOU5uIoO+SMZ5Uatyv5K/c7+/Hjlnk5lkEBfamn3JsXbGy4Eep8I0?=
 =?us-ascii?q?mDZnrsmNgBG38QvgUiVOzqlEGCUTlLana8UaMx/So7CJ68DYfHWI+thqaN0z?=
 =?us-ascii?q?qlEZdOfGBJFkiMEWv0d4WDQ/oMczmdItVgkjwaVLihTJQs1QuwuwDny7poNP?=
 =?us-ascii?q?bU9jcEupLk0dh///fTmg0q9TxoE8Sd1HmAT2dqkWMUST823aR/oVBjxVeZyK?=
 =?us-ascii?q?R3nuJXFcJN6PNNSQo6K5HcwPJgC9zoWQLOYM2JSFC4TdWiGz0xScgxw9AWaU?=
 =?us-ascii?q?ZnB9qilgzD3zatA7INi7OLA4Y0/bzA33fvPcl9zm3L1K8/gFk6TMtPNGmmhr?=
 =?us-ascii?q?Jh+AjJHYLJlF+Zl6myf6QGwCHN7HuDzXaJvExAVg5/T7nFUm0BaUvIttn5+E?=
 =?us-ascii?q?zCQKG0Cbg9MQtO19SCKq1UZd3tl1lGQ+3jONvGaWKrh2iwHQqIxq+LbIfydW?=
 =?us-ascii?q?USxj7SCEYfngAI/naHNQ4+CTm9o27EFzNhCwGnX0S56eB0rHSTSEIowQCOc0?=
 =?us-ascii?q?B7kb2v9VpdhvWQT/4Y9rQJpCkgryl5BhC6xd2SQ9SfjxF9ZqFRZ5Ux7RMPzm?=
 =?us-ascii?q?jDthJ8ObS6Iqxij0JYeANy7G300BAiJIxKkMEs5F0wwQZ/M6OT0xsVeTqS07?=
 =?us-ascii?q?jrOazRJ3W09h35OP2e4U3XzNvDovRH0/8/sVi25Aw=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2BgCQArsUJf/xCltltfHgEBCxIMR4F?=
 =?us-ascii?q?FgxhUX404kkqSAgsBAQEBAQEBAQEnDQECBAEBhEyCRyU4EwIDAQEBAwIFAQE?=
 =?us-ascii?q?GAQEBAQEBBQQBhg9FQxYBgV0ig1IBIyOBPwkJgyYBglcpslCEEIRpgUCBOAG?=
 =?us-ascii?q?II4UZgUE/hF+KNASPRqZ5gm2DDIRafpExDyGgMpJDoVqBek0gGIMkCUcZDZx?=
 =?us-ascii?q?oQjA3AgYKAQEDCVcBPQGMBYQfAQE?=
X-IPAS-Result: =?us-ascii?q?A2BgCQArsUJf/xCltltfHgEBCxIMR4FFgxhUX404kkqSA?=
 =?us-ascii?q?gsBAQEBAQEBAQEnDQECBAEBhEyCRyU4EwIDAQEBAwIFAQEGAQEBAQEBBQQBh?=
 =?us-ascii?q?g9FQxYBgV0ig1IBIyOBPwkJgyYBglcpslCEEIRpgUCBOAGII4UZgUE/hF+KN?=
 =?us-ascii?q?ASPRqZ5gm2DDIRafpExDyGgMpJDoVqBek0gGIMkCUcZDZxoQjA3AgYKAQEDC?=
 =?us-ascii?q?VcBPQGMBYQfAQE?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 23 Aug 2020 20:16:15 +0200
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de,
        sbrivio@redhat.com
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, Fabian Frederick <fabf@skynet.be>
Subject: [PATCH V2 2/5 nf] selftests: netfilter: exit on invalid parameters
Date:   Sun, 23 Aug 2020 20:15:59 +0200
Message-Id: <20200823181559.13306-1-fabf@skynet.be>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

exit script with comments when parameters are wrong during address
addition. No need for a message when trying to change MTU with lower
values: output is self-explanatory.
Use short testing sequence to avoid shellcheck warnings
(suggested by Stefano Brivio).

Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
V2: avoid shellcheck warnings

 .../testing/selftests/netfilter/nft_flowtable.sh  | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools/testing/selftests/netfilter/nft_flowtable.sh
index 28e32fddf9b2c..dc05c99405979 100755
--- a/tools/testing/selftests/netfilter/nft_flowtable.sh
+++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
@@ -96,10 +96,16 @@ do
 	esac
 done
 
-ip -net nsr1 link set veth0 mtu $omtu
+if ! ip -net nsr1 link set veth0 mtu $omtu; then
+	exit 1
+fi
+
 ip -net ns1 link set eth0 mtu $omtu
 
-ip -net nsr2 link set veth1 mtu $rmtu
+if ! ip -net nsr2 link set veth1 mtu $rmtu; then
+	exit 1
+fi
+
 ip -net ns2 link set eth0 mtu $rmtu
 
 # transfer-net between nsr1 and nsr2.
@@ -120,7 +126,10 @@ for i in 1 2; do
   ip -net ns$i route add default via 10.0.$i.1
   ip -net ns$i addr add dead:$i::99/64 dev eth0
   ip -net ns$i route add default via dead:$i::1
-  ip netns exec ns$i sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null
+  if ! ip netns exec ns$i sysctl net.ipv4.tcp_no_metrics_save=1 > /dev/null; then
+	echo "ERROR: Check Originator/Responder values (problem during address addition)"
+	exit 1
+  fi
 
   # don't set ip DF bit for first two tests
   ip netns exec ns$i sysctl net.ipv4.ip_no_pmtu_disc=1 > /dev/null
-- 
2.27.0

