Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5102CBD5C
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:55:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727639AbgLBMxM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:53:12 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:54633 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgLBMxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:53:12 -0500
Received: from orion.localdomain ([77.7.48.174]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N6srH-1k75n72UEp-018Nq0; Wed, 02 Dec 2020 13:50:06 +0100
From:   "Enrico Weigelt, metux IT consult" <info@metux.net>
To:     linux-kernel@vger.kernel.org
Cc:     davem@davemloft.net, kuba@kernel.org, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        marcel@holtmann.org, johan.hedberg@gmail.com, roopa@nvidia.com,
        nikolay@nvidia.com, edumazet@google.com, kuznet@ms2.inr.ac.ru,
        yoshfuji@linux-ipv6.org, jmaloy@redhat.com, ying.xue@windriver.com,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        tipc-discussion@lists.sourceforge.net,
        linux-hyperv@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 1/7] net: 8021q: remove unneeded MODULE_VERSION() usage
Date:   Wed,  2 Dec 2020 13:49:53 +0100
Message-Id: <20201202124959.29209-1-info@metux.net>
X-Mailer: git-send-email 2.11.0
X-Provags-ID: V03:K1:14LCbfn7CIm5dANaBLGKWLgN3xQE4jDUCMo9evmbx9Co8uVlQ6w
 AJFD6ZJ02fqB/4hkD8UvpR4MIY+/p78jpG5aWRjgTooqf+IEH1eqCBcShQ2vV0dQpZD0PsW
 05u5MlL8i5N7ZlPrZ7WXbFUNvvFZsQXgZIGpcP3ZrL1oewC6MVHvqtu//f0C4Yd8k+NfXYW
 VmowlQvXdv7smIRHA6edw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:UEMJ2Q5iJaA=:yleuAQn1i2Rjq/ui4VdE+g
 jyh2pVLY6s01oGU46RcJlPLxSSX8L2w/MBwEmg20CK/7Y310Z8JlnqRGDpqOM2nJS5End/sP4
 /9Y1onXdJEthEHAa9BhU58Pusym8OBWDtyGF2XsodDUOCLKO8Al2CEIPKNwkS7PYWLzUetR1u
 6d1JaWAKKnYd0bQb4e/+Rn24Bv8Hwjp283Oc/mJZgpdGd1YNZapCGRlUHnDPGMvLvbAQ4suoX
 K+qAXCsVWaWIdCkwo5qNVHF2IP7XbGZ74/fYL0MRsOi+/PZ9Ibn6yD2QQuUvJzs0/dmQvKbzv
 sAqugRZrYpsuSsj3PnTQPdjGB8zs3Qs8ObLlivdv6bthFn3+TxlFxmTZJ66mNuyYS4u/hwzBI
 cHIUHiSeDY4ksdHCmLz6WWwusj+S5xSj2/yUf7nw695XokUprP0W5b5CKP7Zw
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
index f292e0267bb9..683e9e825b9e 100644
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
@@ -687,7 +682,7 @@ static int __init vlan_proto_init(void)
 {
 	int err;
 
-	pr_info("%s v%s\n", vlan_fullname, vlan_version);
+	pr_info("802.1Q VLAN Support\n");
 
 	err = register_pernet_subsys(&vlan_net_ops);
 	if (err < 0)
@@ -743,4 +738,3 @@ module_init(vlan_proto_init);
 module_exit(vlan_cleanup_module);
 
 MODULE_LICENSE("GPL");
-MODULE_VERSION(DRV_VERSION);
-- 
2.11.0

