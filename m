Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57959201FAC
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 04:15:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731710AbgFTCP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 22:15:28 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:57094 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730293AbgFTCPZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Jun 2020 22:15:25 -0400
X-Greylist: delayed 415 seconds by postgrey-1.27 at vger.kernel.org; Fri, 19 Jun 2020 22:15:24 EDT
Date:   Sat, 20 Jun 2020 02:08:25 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=protonmail.com;
        s=protonmail; t=1592618908;
        bh=+Liyh+rEtLQV3uxQzvticpn7VtCP6QD0DCNNkTw1GHQ=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=PcgTro7WpkThVFh5j028yQYEpUujYv6oMj3YQzzsbGGwbZLvmFTXlq4QbWfFE9gvg
         VI5H36EhTL/ZtLTPSa0S1UZdwfFLp0QsVLFpr4dmXfsy0oS14qHTbHCiL2Ae6568PW
         EvydGR1aN76T6ODlUOQyS77WhF54Mf361OKi5D4U=
To:     netdev@vger.kernel.org
From:   Rob Gill <rrobgill@protonmail.com>
Cc:     Rob Gill <rrobgill@protonmail.com>
Reply-To: Rob Gill <rrobgill@protonmail.com>
Subject: [PATCH] net Add MODULE_DESCRIPTION entries to network modules
Message-ID: <20200620020756.18707-1-rrobgill@protonmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on mail.protonmail.ch
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The user tool modinfo is used to get information on kernel modules, includi=
ng a
description where it is available.

This patch adds a brief MODULE_DESCRIPTION to the following modules:

9p
drop_monitor
esp4_offload
esp6_offload
fou
fou6
ila
sch_fq
sch_fq_codel
sch_hhf

Signed-off-by: Rob Gill <rrobgill@protonmail.com>
---
 net/9p/mod.c             | 1 +
 net/core/drop_monitor.c  | 1 +
 net/ipv4/esp4_offload.c  | 1 +
 net/ipv4/fou.c           | 1 +
 net/ipv6/esp6_offload.c  | 1 +
 net/ipv6/fou6.c          | 1 +
 net/ipv6/ila/ila_main.c  | 1 +
 net/sched/sch_fq.c       | 1 +
 net/sched/sch_fq_codel.c | 1 +
 net/sched/sch_hhf.c      | 1 +
 10 files changed, 10 insertions(+)

diff --git a/net/9p/mod.c b/net/9p/mod.c
index c1b62428d..512656685 100644
--- a/net/9p/mod.c
+++ b/net/9p/mod.c
@@ -189,3 +189,4 @@ MODULE_AUTHOR("Latchesar Ionkov <lucho@ionkov.net>");
 MODULE_AUTHOR("Eric Van Hensbergen <ericvh@gmail.com>");
 MODULE_AUTHOR("Ron Minnich <rminnich@lanl.gov>");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Plan 9 Resource Sharing Support (9P2000)");
diff --git a/net/core/drop_monitor.c b/net/core/drop_monitor.c
index 2ee7bc4c9..b09bebead 100644
--- a/net/core/drop_monitor.c
+++ b/net/core/drop_monitor.c
@@ -1721,3 +1721,4 @@ module_exit(exit_net_drop_monitor);
 MODULE_LICENSE("GPL v2");
 MODULE_AUTHOR("Neil Horman <nhorman@tuxdriver.com>");
 MODULE_ALIAS_GENL_FAMILY("NET_DM");
+MODULE_DESCRIPTION("Monitoring code for network dropped packet alerts");
diff --git a/net/ipv4/esp4_offload.c b/net/ipv4/esp4_offload.c
index d14133eac..5bda5aeda 100644
--- a/net/ipv4/esp4_offload.c
+++ b/net/ipv4/esp4_offload.c
@@ -361,3 +361,4 @@ module_exit(esp4_offload_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
 MODULE_ALIAS_XFRM_OFFLOAD_TYPE(AF_INET, XFRM_PROTO_ESP);
+MODULE_DESCRIPTION("IPV4 GSO/GRO offload support");
diff --git a/net/ipv4/fou.c b/net/ipv4/fou.c
index dcc79ff54..abd083415 100644
--- a/net/ipv4/fou.c
+++ b/net/ipv4/fou.c
@@ -1304,3 +1304,4 @@ module_init(fou_init);
 module_exit(fou_fini);
 MODULE_AUTHOR("Tom Herbert <therbert@google.com>");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Foo over UDP");
diff --git a/net/ipv6/esp6_offload.c b/net/ipv6/esp6_offload.c
index 55addea19..1ca516fb3 100644
--- a/net/ipv6/esp6_offload.c
+++ b/net/ipv6/esp6_offload.c
@@ -395,3 +395,4 @@ module_exit(esp6_offload_exit);
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Steffen Klassert <steffen.klassert@secunet.com>");
 MODULE_ALIAS_XFRM_OFFLOAD_TYPE(AF_INET6, XFRM_PROTO_ESP);
+MODULE_DESCRIPTION("IPV6 GSO/GRO offload support");
diff --git a/net/ipv6/fou6.c b/net/ipv6/fou6.c
index 091f94184..430518ae2 100644
--- a/net/ipv6/fou6.c
+++ b/net/ipv6/fou6.c
@@ -224,3 +224,4 @@ module_init(fou6_init);
 module_exit(fou6_fini);
 MODULE_AUTHOR("Tom Herbert <therbert@google.com>");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Foo over UDP (IPv6)");
diff --git a/net/ipv6/ila/ila_main.c b/net/ipv6/ila/ila_main.c
index 257d2b681..36c58aa25 100644
--- a/net/ipv6/ila/ila_main.c
+++ b/net/ipv6/ila/ila_main.c
@@ -120,3 +120,4 @@ module_init(ila_init);
 module_exit(ila_fini);
 MODULE_AUTHOR("Tom Herbert <tom@herbertland.com>");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("IPv6: Identifier Locator Addressing (ILA)");
diff --git a/net/sched/sch_fq.c b/net/sched/sch_fq.c
index 8f06a808c..2fb76fc0c 100644
--- a/net/sched/sch_fq.c
+++ b/net/sched/sch_fq.c
@@ -1075,3 +1075,4 @@ module_init(fq_module_init)
 module_exit(fq_module_exit)
 MODULE_AUTHOR("Eric Dumazet");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Fair Queue Packet Scheduler");
diff --git a/net/sched/sch_fq_codel.c b/net/sched/sch_fq_codel.c
index 436160be9..459a78405 100644
--- a/net/sched/sch_fq_codel.c
+++ b/net/sched/sch_fq_codel.c
@@ -721,3 +721,4 @@ module_init(fq_codel_module_init)
 module_exit(fq_codel_module_exit)
 MODULE_AUTHOR("Eric Dumazet");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Fair Queue CoDel discipline");
diff --git a/net/sched/sch_hhf.c b/net/sched/sch_hhf.c
index be35f03b6..420ede875 100644
--- a/net/sched/sch_hhf.c
+++ b/net/sched/sch_hhf.c
@@ -721,3 +721,4 @@ module_exit(hhf_module_exit)
 MODULE_AUTHOR("Terry Lam");
 MODULE_AUTHOR("Nandita Dukkipati");
 MODULE_LICENSE("GPL");
+MODULE_DESCRIPTION("Heavy-Hitter Filter (HHF)");
--=20
2.17.1


