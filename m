Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF91A130411
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:52:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbgADTwl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:52:41 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:33399 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbgADTwl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:52:41 -0500
Received: from orion.localdomain ([95.114.65.70]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1N6bsG-1jmdkd0icQ-0180xh; Sat, 04 Jan 2020 20:52:09 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        marcel@holtmann.org, johan.hedberg@gmail.com,
        roopa@cumulusnetworks.com, nikolay@cumulusnetworks.com,
        edumazet@google.com, kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        jon.maloy@ericsson.com, ying.xue@windriver.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 1/8] net: 8021q: remove unneeded MODULE_VERSION() usage
Date:   Sat,  4 Jan 2020 20:51:24 +0100
Message-Id: <20200104195131.16577-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:DUOrLYqXKtl8pRCBke7g4p2qlUJHYsLFb883aZwwRQAyiSsQXdT
 cy4bqnEYpTvE2T7ZW2zmyRvoH9reEOrH+MCZw1+MTfEwclx1qtJJ+z9F0An+vNLD57fidnW
 iekCAJ+XZ3u5qQI4aHADVsFfAROL8S8ePLXhBCHYTNrg+oAOpgce5KbMpkzHThP9fVnaK2u
 dw99EkkdAMJWuXX6rXgCw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:VvZJXNrGmTM=:3/L+iYL2SDXV5M3uG6JcT1
 sbVVqyUggaxakdBmx6vlSFM9NRK6OYv9mISDkjQAM+dGpXa0m+BNpMiP0jPmFVVA4lJLEpcV8
 /WNf4HCYPv1hKczaua13+mF1Cx/JG90C9DTg+9MQnoPiBM7hxjEE0zjaA2G5N15gXt63gUW1X
 304gM8cV6s4X14STp3U19LjjRN9S70ftbC+I3M/FbAvzImCNZl9p47QLaVnJ3jiBCaFnhq+y4
 4bu+swHZtsbNmpOCzuFREH4ruFNQNGIGvdavgU/T4RzyxmFIE8NdZbZbwKhq1xZaaat0sNvJt
 5vwpC+lZtAHVZkNTMJhS/pRloeKaKdLbt/UEvbIHUnprcFvZdZfe6ulqaTyCteGgn9M+ooM15
 tQo+DNSMBHWbINyFMcTju0yYl6YE7wRQBjR3Ad1PCv2MbdlniogWIlMb2f0vG7QsD6CVbOAvi
 ongj0p4vdHcA/qXb6BkueIjdn54vJc3n2FU2Px+yassEOWno+5K5WMW2Y7RtJkgyI4rND1RZG
 oiqwSsx7tRxwxoDjHX2ol9wjbbidnKOcNVdWBvMNPSUUXvVfH2P/Qh5GYWH4ddmjfX6OigGbl
 2nKH/xJfZ3NeDwwf+3uZMuaeWlRuVTvsrG+N/B01h55qTE9Q+5LZ2GQODM3VAKv/TYFkWphz/
 cnhQeuDYPzpL4FPiGuFA9yoyBvD+okzIToXErulKu1C7lV6o0fg0NjObpRUTQwbNO6ag2jgul
 c6GetK92ee1+uhoRlYpFoJqwavmkTKu9gpUUQV+WZaP49K9Q00DgMIiP4Fkjlj0f8jRZQ/Zbe
 3/PRCteVkjCVOj3YS69w8lEt99PpY2nWtVLzW8DJh4dvE9BPnva3meP8ZJNgPt/Tpt3YaxeYq
 DRh1ul25K858EuZdVNKA==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it isn't needed at all: the only version
making sense is the kernel version.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/8021q/vlan.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/net/8021q/vlan.c b/net/8021q/vlan.c
index d4bcfd8f95bf..ded7bf7229cf 100644
--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -36,15 +36,10 @@
 #include "vlan.h"
 #include "vlanproc.h"
 
-#define DRV_VERSION "1.8"
-
 /* Global VLAN variables */
 
 unsigned int vlan_net_id __read_mostly;
 
-const char vlan_fullname[] = "802.1Q VLAN Support";
-const char vlan_version[] = DRV_VERSION;
-
 /* End of global variables definitions. */
 
 static int vlan_group_prealloc_vid(struct vlan_group *vg,
@@ -683,7 +678,7 @@ static int __init vlan_proto_init(void)
 {
 	int err;
 
-	pr_info("%s v%s\n", vlan_fullname, vlan_version);
+	pr_info("802.1Q VLAN Support\n");
 
 	err = register_pernet_subsys(&vlan_net_ops);
 	if (err < 0)
@@ -739,4 +734,3 @@ module_init(vlan_proto_init);
 module_exit(vlan_cleanup_module);
 
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-- 
2.11.0

