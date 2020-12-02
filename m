Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 592412CBD67
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 13:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729948AbgLBMxQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 07:53:16 -0500
Received: from mout.kundenserver.de ([212.227.126.133]:34299 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725859AbgLBMxP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 07:53:15 -0500
Received: from orion.localdomain ([77.7.48.174]) by mrelayeu.kundenserver.de
 (mreue009 [212.227.15.167]) with ESMTPSA (Nemesis) id
 1N9dkD-1k5RtW0OAf-015e18; Wed, 02 Dec 2020 13:50:11 +0100
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
Subject: [PATCH 4/7] net: bluetooth: remove unneeded MODULE_VERSION() usage
Date:   Wed,  2 Dec 2020 13:49:56 +0100
Message-Id: <20201202124959.29209-4-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20201202124959.29209-1-info@metux.net>
References: <20201202124959.29209-1-info@metux.net>
X-Provags-ID: V03:K1:nCLBkwBPP1UoRJ0tO1iADI0GFYjOoRdZUFJs5Lp/rIbhkbOjZHA
 Gi3KyxrgSppVa3+ScKpcp1h9bFCbK9+6A3bAjPetKJnG9rInwq4SvCAyTShfPT2tzdYvX5u
 eYViQAVyzpgqxiGeSTAnW1DqEqvohAstRFH7DSMuo3driC3bf86dRbz8r93tIWBuuXy0CkJ
 axb+hPdAkmrVEQBuPiB0w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:4E/jQnGMiyo=:qQydPqBDgHo4tYcFclcgA0
 Hhs9aDRnQcuILLLXWMsTWQaGKNdoqrWORAI7zAAc901vaVsa58Oxvcp7+sNEomNcM7NuvBhqH
 0P9F+FvKIgDjOHw5yHHIkN5Aspappu0wSfuFszn+tReKtIMVJyXFkUBKHoCcl33YiZyF/aipR
 l1gwoB2RJp4p1bocg72SibDfyfwx0tC25BUnBsuLtMrjAlTxG2x8/JKKO2THZzI1tcad2THMx
 LRq5PjJZ7Ug5wBvSjI4qUwKJfm0PdbgPdOh4J2+OJXzrzxP4SjR/yFQkqifVHeCqmMGYnInAf
 gamcQLT4WpIbNSRPYuejoFj6WeMU9vw17wGStSq31xFR4EbXpCSxoozxXwWbg0ZV8o6Run4vp
 1JWEHqasbBi9joGQQL+ktlriaenntMZs7+YETib1Yfq188iskUk0547IKMFHj
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove MODULE_VERSION(), as it isn't needed at all: the only version
making sense is the kernel version.

Signed-off-by: Enrico Weigelt, metux IT consult <info@metux.net>
---
 net/bluetooth/6lowpan.c      | 3 ---
 net/bluetooth/af_bluetooth.c | 1 -
 net/bluetooth/bnep/core.c    | 1 -
 net/bluetooth/cmtp/core.c    | 1 -
 net/bluetooth/hidp/core.c    | 1 -
 net/bluetooth/rfcomm/core.c  | 1 -
 6 files changed, 8 deletions(-)

diff --git a/net/bluetooth/6lowpan.c b/net/bluetooth/6lowpan.c
index cff4944d5b66..9759515edc6e 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -21,8 +21,6 @@
 
 #include <net/6lowpan.h> /* for the compression support */
 
-#define VERSION "0.1"
-
 static struct dentry *lowpan_enable_debugfs;
 static struct dentry *lowpan_control_debugfs;
 
@@ -1316,5 +1314,4 @@ module_exit(bt_6lowpan_exit);
 
 MODULE_AUTHOR("Jukka Rissanen <jukka.rissanen@linux.intel.com>");
 MODULE_DESCRIPTION("Bluetooth 6LoWPAN");
-MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 4ef6a54403aa..6d587a3b3c56 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -799,6 +799,5 @@ module_exit(bt_exit);
 
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Bluetooth Core ver " VERSION);
-MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_NETPROTO(PF_BLUETOOTH);
diff --git a/net/bluetooth/bnep/core.c b/net/bluetooth/bnep/core.c
index 43c284158f63..96f0eb60deb0 100644
--- a/net/bluetooth/bnep/core.c
+++ b/net/bluetooth/bnep/core.c
@@ -764,6 +764,5 @@ MODULE_PARM_DESC(compress_dst, "Compress destination headers");
 
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Bluetooth BNEP ver " VERSION);
-MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("bt-proto-4");
diff --git a/net/bluetooth/cmtp/core.c b/net/bluetooth/cmtp/core.c
index 07cfa3249f83..9a6306d7f738 100644
--- a/net/bluetooth/cmtp/core.c
+++ b/net/bluetooth/cmtp/core.c
@@ -511,6 +511,5 @@ module_exit(cmtp_exit);
 
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Bluetooth CMTP ver " VERSION);
-MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("bt-proto-5");
diff --git a/net/bluetooth/hidp/core.c b/net/bluetooth/hidp/core.c
index 3b4fa27a44e6..597f5dde434a 100644
--- a/net/bluetooth/hidp/core.c
+++ b/net/bluetooth/hidp/core.c
@@ -1475,6 +1475,5 @@ module_exit(hidp_exit);
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_AUTHOR("David Herrmann <dh.herrmann@gmail.com>");
 MODULE_DESCRIPTION("Bluetooth HIDP ver " VERSION);
-MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("bt-proto-6");
diff --git a/net/bluetooth/rfcomm/core.c b/net/bluetooth/rfcomm/core.c
index f2bacb464ccf..3384da308a9b 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -2240,6 +2240,5 @@ MODULE_PARM_DESC(l2cap_ertm, "Use L2CAP ERTM mode for connection");
 
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Bluetooth RFCOMM ver " VERSION);
-MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("bt-proto-3");
-- 
2.11.0

