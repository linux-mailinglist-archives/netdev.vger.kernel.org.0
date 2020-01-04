Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D9A1113041F
	for <lists+netdev@lfdr.de>; Sat,  4 Jan 2020 20:53:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726515AbgADTwp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Jan 2020 14:52:45 -0500
Received: from mout.kundenserver.de ([217.72.192.74]:33733 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726307AbgADTwo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Jan 2020 14:52:44 -0500
Received: from orion.localdomain ([95.114.65.70]) by mrelayeu.kundenserver.de
 (mreue109 [212.227.15.183]) with ESMTPSA (Nemesis) id
 1Mi2Bb-1jImZZ3gKf-00e89S; Sat, 04 Jan 2020 20:52:13 +0100
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
Subject: [PATCH 5/8] net: bluetooth: remove unneeded MODULE_VERSION() usage
Date:   Sat,  4 Jan 2020 20:51:28 +0100
Message-Id: <20200104195131.16577-5-info@metux.net>
X-Mailer: git-send-email 2.11.0
In-Reply-To: <20200104195131.16577-1-info@metux.net>
References: <20200104195131.16577-1-info@metux.net>
X-Provags-ID: V03:K1:rqA9KHBG4cysDCokVxgm9Sj+YPWcsUNju7xr0PpY/iJlLx1AnGC
 5RZj76Enp58YNH9g0fqLvKXPzgCpzljXiNYc3I3D44rXQwcjCpwI6G7ZRwzO8DA0IwXF693
 97K4gNDoeKoJ9tvibFytZ0/+qxiRt8ncCmlIpyluZ87QlBMz5TImajPVGCSw8uhHfovz65b
 699C9ZVmaF1AfBfIqpYLw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:Tuf0pe90wXk=:rWkZWxUGjuC0GX/5ngcmin
 Xj6VzgAh8RrksJIeD2YdxtBpHEJPWVE//m1Vs3X48bw51sGYUBBrn5wlo1tPLXOt40AAU3Ful
 5eclNIwRfdlGunG/I7fw4SQpTFDI+0dipUUylX/qcty5kJN0HiQvONr9jysNbICdBmNKz+o5P
 Fw2bQemWYa3JWU+iBMG/WMbgt1JgJb9Tc3Xk83TB51MV6A9OmupcCY1Eg877/ynGcSzBnL+dL
 2bB6471/uKuj8Vv5+gLU/3sv0wky3FzGJnQxkvPebgxvYA4a/uqaL9x7qg/ByBKXCtdjCUJyF
 6BJzh8FOzrhyzeTTscVMhouuID/mhmpkAwePcJlk2mObf0RO3b2q7XzxiD8X0sNQ2P6tyFq8X
 u6bO5U8UdqRAfkmLren4wzXLSobBcpkTwcLSFUExq2WZdkWi4Gw4pU4c3aBk47rTy0BeGhQvL
 Qn8ekWquBHZYGOUUsuI3dwOV6REobGz6f9fx2VY3XMBg72I5lI0gyGvor5FS1IGXPdYXOdT59
 sqOZQfDa/mU6XAQ78JWuJF8jDn1E15YnhVNjOkP8EfQtHvK4A3Rd3ZM/6O5NrImoHVTJhThst
 9PDJkUsJeJ57hJbSJAWPtsE4jWNqo2pOhwNi+LOYVbbELA7ArXuVnwj3QqpAhtpmOjYxVrtCW
 dBUv6Dyjsd0ZeO5iUETPVFLSGHmPp2aAflUybgPl3/t00Ow0BP+2Xc4YUNgPWJ1XeZkbQWRrZ
 NAZIxoQ5GhKlXpuWSe86BOmNADRG2nD6W7o22eYWTp9seqccwz0kbL3KdqYRz6fjxdZN4wi0O
 TtZzkCLKTWV0z0eVEQpdnOwZCYLJ3mOb9vL1I0sUSoYsQNJrk058bcDnkF3y/K8xREw6XWrG1
 s1V5QzVKUrXsZyBVu9vQ==
Sender: netdev-owner@vger.kernel.org
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
index 4febc82a7c76..76fabc65b8a9 100644
--- a/net/bluetooth/6lowpan.c
+++ b/net/bluetooth/6lowpan.c
@@ -21,8 +21,6 @@
 
 #include <net/6lowpan.h> /* for the compression support */
 
-#define VERSION "0.1"
-
 static struct dentry *lowpan_enable_debugfs;
 static struct dentry *lowpan_control_debugfs;
 
@@ -1303,5 +1301,4 @@ module_exit(bt_6lowpan_exit);
 
 MODULE_AUTHOR("Jukka Rissanen <jukka.rissanen@linux.intel.com>");
 MODULE_DESCRIPTION("Bluetooth 6LoWPAN");
-MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
diff --git a/net/bluetooth/af_bluetooth.c b/net/bluetooth/af_bluetooth.c
index 3fd124927d4d..1a6972fac1f7 100644
--- a/net/bluetooth/af_bluetooth.c
+++ b/net/bluetooth/af_bluetooth.c
@@ -798,6 +798,5 @@ module_exit(bt_exit);
 
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
index bef84b95e2c4..a225ae5f1849 100644
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
index 3a9e9d9670be..e621fbb451b3 100644
--- a/net/bluetooth/rfcomm/core.c
+++ b/net/bluetooth/rfcomm/core.c
@@ -2245,6 +2245,5 @@ MODULE_PARM_DESC(l2cap_ertm, "Use L2CAP ERTM mode for connection");
 
 MODULE_AUTHOR("Marcel Holtmann <marcel@holtmann.org>");
 MODULE_DESCRIPTION("Bluetooth RFCOMM ver " VERSION);
-MODULE_VERSION(VERSION);
 MODULE_LICENSE("GPL");
 MODULE_ALIAS("bt-proto-3");
-- 
2.11.0

