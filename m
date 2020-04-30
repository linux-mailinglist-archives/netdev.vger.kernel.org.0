Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA5E91C0193
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 18:08:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728474AbgD3QG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 12:06:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:50874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbgD3QEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Apr 2020 12:04:38 -0400
Received: from mail.kernel.org (ip5f5ad5c5.dynamic.kabel-deutschland.de [95.90.213.197])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DCAAE208DB;
        Thu, 30 Apr 2020 16:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588262676;
        bh=QUfv6scPo1my4zCr4LFZW2U/OmwyKCvSjBoQt0t5VTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ILVqWCsii4IU1ATzx4qBN0ji2HPtDUiD1ypny4cMcn8WIKumlXEoumCQXrWkhGAsS
         oqJiaJ6yjraaA1oh6BASaq3vxmcTqRowqQ4Stn/vU/B81VCie/cvgBBhe1wx+S7UZI
         FfWKvLFp4pUWT9e9zstR2q/MmWx/VeFkjhTEP+sU=
Received: from mchehab by mail.kernel.org with local (Exim 4.92.3)
        (envelope-from <mchehab@kernel.org>)
        id 1jUBfu-00AxEd-5h; Thu, 30 Apr 2020 18:04:34 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Geoff Levand <geoff@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Ishizaki Kou <kou.ishizaki@toshiba.co.jp>,
        netdev@vger.kernel.org, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH 07/37] docs: networking: convert netconsole.txt to ReST
Date:   Thu, 30 Apr 2020 18:04:02 +0200
Message-Id: <f6772b566eea20879d82b1a2015fc97b137a5f24.1588261997.git.mchehab+huawei@kernel.org>
X-Mailer: git-send-email 2.25.4
In-Reply-To: <cover.1588261997.git.mchehab+huawei@kernel.org>
References: <cover.1588261997.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- add SPDX header;
- add a document title;
- mark code blocks and literals as such;
- mark tables as such;
- add notes markups;
- adjust identation, whitespaces and blank lines;
- add to networking/index.rst.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
---
 .../admin-guide/kernel-parameters.txt         |   2 +-
 Documentation/admin-guide/serial-console.rst  |   2 +-
 Documentation/networking/index.rst            |   1 +
 .../{netconsole.txt => netconsole.rst}        | 125 +++++++++++-------
 drivers/net/Kconfig                           |   4 +-
 drivers/net/ethernet/toshiba/ps3_gelic_net.c  |   2 +-
 drivers/net/ethernet/toshiba/spider_net.c     |   2 +-
 7 files changed, 84 insertions(+), 54 deletions(-)
 rename Documentation/networking/{netconsole.txt => netconsole.rst} (66%)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 25644daa36ea..5a44c1bf85e7 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -638,7 +638,7 @@
 
 			See Documentation/admin-guide/serial-console.rst for more
 			information.  See
-			Documentation/networking/netconsole.txt for an
+			Documentation/networking/netconsole.rst for an
 			alternative.
 
 		uart[8250],io,<addr>[,options]
diff --git a/Documentation/admin-guide/serial-console.rst b/Documentation/admin-guide/serial-console.rst
index a8d1e36b627a..58b32832e50a 100644
--- a/Documentation/admin-guide/serial-console.rst
+++ b/Documentation/admin-guide/serial-console.rst
@@ -54,7 +54,7 @@ You will need to create a new device to use ``/dev/console``. The official
 ``/dev/console`` is now character device 5,1.
 
 (You can also use a network device as a console.  See
-``Documentation/networking/netconsole.txt`` for information on that.)
+``Documentation/networking/netconsole.rst`` for information on that.)
 
 Here's an example that will use ``/dev/ttyS1`` (COM2) as the console.
 Replace the sample values as needed.
diff --git a/Documentation/networking/index.rst b/Documentation/networking/index.rst
index 492658bf7c0d..e58f872d401d 100644
--- a/Documentation/networking/index.rst
+++ b/Documentation/networking/index.rst
@@ -80,6 +80,7 @@ Contents:
    mac80211-injection
    mpls-sysctl
    multiqueue
+   netconsole
 
 .. only::  subproject and html
 
diff --git a/Documentation/networking/netconsole.txt b/Documentation/networking/netconsole.rst
similarity index 66%
rename from Documentation/networking/netconsole.txt
rename to Documentation/networking/netconsole.rst
index 296ea00fd3eb..1f5c4a04027c 100644
--- a/Documentation/networking/netconsole.txt
+++ b/Documentation/networking/netconsole.rst
@@ -1,7 +1,16 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+==========
+Netconsole
+==========
+
 
 started by Ingo Molnar <mingo@redhat.com>, 2001.09.17
+
 2.6 port and netpoll api by Matt Mackall <mpm@selenic.com>, Sep 9 2003
+
 IPv6 support by Cong Wang <xiyou.wangcong@gmail.com>, Jan 1 2013
+
 Extended console support by Tejun Heo <tj@kernel.org>, May 1 2015
 
 Please send bug reports to Matt Mackall <mpm@selenic.com>
@@ -23,34 +32,34 @@ Sender and receiver configuration:
 ==================================
 
 It takes a string configuration parameter "netconsole" in the
-following format:
+following format::
 
  netconsole=[+][src-port]@[src-ip]/[<dev>],[tgt-port]@<tgt-ip>/[tgt-macaddr]
 
    where
-        +             if present, enable extended console support
-        src-port      source for UDP packets (defaults to 6665)
-        src-ip        source IP to use (interface address)
-        dev           network interface (eth0)
-        tgt-port      port for logging agent (6666)
-        tgt-ip        IP address for logging agent
-        tgt-macaddr   ethernet MAC address for logging agent (broadcast)
+	+             if present, enable extended console support
+	src-port      source for UDP packets (defaults to 6665)
+	src-ip        source IP to use (interface address)
+	dev           network interface (eth0)
+	tgt-port      port for logging agent (6666)
+	tgt-ip        IP address for logging agent
+	tgt-macaddr   ethernet MAC address for logging agent (broadcast)
 
-Examples:
+Examples::
 
  linux netconsole=4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
 
-  or
+or::
 
  insmod netconsole netconsole=@/,@10.0.0.2/
 
-  or using IPv6
+or using IPv6::
 
  insmod netconsole netconsole=@/,@fd00:1:2:3::1/
 
 It also supports logging to multiple remote agents by specifying
 parameters for the multiple agents separated by semicolons and the
-complete string enclosed in "quotes", thusly:
+complete string enclosed in "quotes", thusly::
 
  modprobe netconsole netconsole="@/,@10.0.0.2/;@/eth1,6892@10.0.0.3/"
 
@@ -67,14 +76,19 @@ for example:
 
    On distributions using a BSD-based netcat version (e.g. Fedora,
    openSUSE and Ubuntu) the listening port must be specified without
-   the -p switch:
+   the -p switch::
 
-   'nc -u -l -p <port>' / 'nc -u -l <port>' or
-   'netcat -u -l -p <port>' / 'netcat -u -l <port>'
+	nc -u -l -p <port>' / 'nc -u -l <port>
+
+    or::
+
+	netcat -u -l -p <port>' / 'netcat -u -l <port>
 
 3) socat
 
-   'socat udp-recv:<port> -'
+::
+
+   socat udp-recv:<port> -
 
 Dynamic reconfiguration:
 ========================
@@ -92,7 +106,7 @@ netconsole module (or kernel, if netconsole is built-in).
 Some examples follow (where configfs is mounted at the /sys/kernel/config
 mountpoint).
 
-To add a remote logging target (target names can be arbitrary):
+To add a remote logging target (target names can be arbitrary)::
 
  cd /sys/kernel/config/netconsole/
  mkdir target1
@@ -102,12 +116,13 @@ above) and are disabled by default -- they must first be enabled by writing
 "1" to the "enabled" attribute (usually after setting parameters accordingly)
 as described below.
 
-To remove a target:
+To remove a target::
 
  rmdir /sys/kernel/config/netconsole/othertarget/
 
 The interface exposes these parameters of a netconsole target to userspace:
 
+	==============  =================================       ============
 	enabled		Is this target currently enabled?	(read-write)
 	extended	Extended mode enabled			(read-write)
 	dev_name	Local network interface name		(read-write)
@@ -117,12 +132,13 @@ The interface exposes these parameters of a netconsole target to userspace:
 	remote_ip	Remote agent's IP address		(read-write)
 	local_mac	Local interface's MAC address		(read-only)
 	remote_mac	Remote agent's MAC address		(read-write)
+	==============  =================================       ============
 
 The "enabled" attribute is also used to control whether the parameters of
 a target can be updated or not -- you can modify the parameters of only
 disabled targets (i.e. if "enabled" is 0).
 
-To update a target's parameters:
+To update a target's parameters::
 
  cat enabled				# check if enabled is 1
  echo 0 > enabled			# disable the target (if required)
@@ -140,12 +156,12 @@ Extended console:
 
 If '+' is prefixed to the configuration line or "extended" config file
 is set to 1, extended console support is enabled. An example boot
-param follows.
+param follows::
 
  linux netconsole=+4444@10.0.0.1/eth1,9353@10.0.0.2/12:34:56:78:9a:bc
 
 Log messages are transmitted with extended metadata header in the
-following format which is the same as /dev/kmsg.
+following format which is the same as /dev/kmsg::
 
  <level>,<sequnum>,<timestamp>,<contflag>;<message text>
 
@@ -155,12 +171,12 @@ newline is used as the delimeter.
 
 If a message doesn't fit in certain number of bytes (currently 1000),
 the message is split into multiple fragments by netconsole. These
-fragments are transmitted with "ncfrag" header field added.
+fragments are transmitted with "ncfrag" header field added::
 
  ncfrag=<byte-offset>/<total-bytes>
 
 For example, assuming a lot smaller chunk size, a message "the first
-chunk, the 2nd chunk." may be split as follows.
+chunk, the 2nd chunk." may be split as follows::
 
  6,416,1758426,-,ncfrag=0/31;the first chunk,
  6,416,1758426,-,ncfrag=16/31; the 2nd chunk.
@@ -168,39 +184,52 @@ chunk, the 2nd chunk." may be split as follows.
 Miscellaneous notes:
 ====================
 
-WARNING: the default target ethernet setting uses the broadcast
-ethernet address to send packets, which can cause increased load on
-other systems on the same ethernet segment.
+.. Warning::
 
-TIP: some LAN switches may be configured to suppress ethernet broadcasts
-so it is advised to explicitly specify the remote agents' MAC addresses
-from the config parameters passed to netconsole.
+   the default target ethernet setting uses the broadcast
+   ethernet address to send packets, which can cause increased load on
+   other systems on the same ethernet segment.
 
-TIP: to find out the MAC address of, say, 10.0.0.2, you may try using:
+.. Tip::
 
- ping -c 1 10.0.0.2 ; /sbin/arp -n | grep 10.0.0.2
+   some LAN switches may be configured to suppress ethernet broadcasts
+   so it is advised to explicitly specify the remote agents' MAC addresses
+   from the config parameters passed to netconsole.
 
-TIP: in case the remote logging agent is on a separate LAN subnet than
-the sender, it is suggested to try specifying the MAC address of the
-default gateway (you may use /sbin/route -n to find it out) as the
-remote MAC address instead.
+.. Tip::
 
-NOTE: the network device (eth1 in the above case) can run any kind
-of other network traffic, netconsole is not intrusive. Netconsole
-might cause slight delays in other traffic if the volume of kernel
-messages is high, but should have no other impact.
+   to find out the MAC address of, say, 10.0.0.2, you may try using::
 
-NOTE: if you find that the remote logging agent is not receiving or
-printing all messages from the sender, it is likely that you have set
-the "console_loglevel" parameter (on the sender) to only send high
-priority messages to the console. You can change this at runtime using:
+	ping -c 1 10.0.0.2 ; /sbin/arp -n | grep 10.0.0.2
 
- dmesg -n 8
+.. Tip::
 
-or by specifying "debug" on the kernel command line at boot, to send
-all kernel messages to the console. A specific value for this parameter
-can also be set using the "loglevel" kernel boot option. See the
-dmesg(8) man page and Documentation/admin-guide/kernel-parameters.rst for details.
+   in case the remote logging agent is on a separate LAN subnet than
+   the sender, it is suggested to try specifying the MAC address of the
+   default gateway (you may use /sbin/route -n to find it out) as the
+   remote MAC address instead.
+
+.. note::
+
+   the network device (eth1 in the above case) can run any kind
+   of other network traffic, netconsole is not intrusive. Netconsole
+   might cause slight delays in other traffic if the volume of kernel
+   messages is high, but should have no other impact.
+
+.. note::
+
+   if you find that the remote logging agent is not receiving or
+   printing all messages from the sender, it is likely that you have set
+   the "console_loglevel" parameter (on the sender) to only send high
+   priority messages to the console. You can change this at runtime using::
+
+	dmesg -n 8
+
+   or by specifying "debug" on the kernel command line at boot, to send
+   all kernel messages to the console. A specific value for this parameter
+   can also be set using the "loglevel" kernel boot option. See the
+   dmesg(8) man page and Documentation/admin-guide/kernel-parameters.rst
+   for details.
 
 Netconsole was designed to be as instantaneous as possible, to
 enable the logging of even the most critical kernel bugs. It works
diff --git a/drivers/net/Kconfig b/drivers/net/Kconfig
index c822f4a6d166..ad64be98330f 100644
--- a/drivers/net/Kconfig
+++ b/drivers/net/Kconfig
@@ -302,7 +302,7 @@ config NETCONSOLE
 	tristate "Network console logging support"
 	---help---
 	  If you want to log kernel messages over the network, enable this.
-	  See <file:Documentation/networking/netconsole.txt> for details.
+	  See <file:Documentation/networking/netconsole.rst> for details.
 
 config NETCONSOLE_DYNAMIC
 	bool "Dynamic reconfiguration of logging targets"
@@ -312,7 +312,7 @@ config NETCONSOLE_DYNAMIC
 	  This option enables the ability to dynamically reconfigure target
 	  parameters (interface, IP addresses, port numbers, MAC addresses)
 	  at runtime through a userspace interface exported using configfs.
-	  See <file:Documentation/networking/netconsole.txt> for details.
+	  See <file:Documentation/networking/netconsole.rst> for details.
 
 config NETPOLL
 	def_bool NETCONSOLE
diff --git a/drivers/net/ethernet/toshiba/ps3_gelic_net.c b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
index 070dd6fa9401..310e6839c6e5 100644
--- a/drivers/net/ethernet/toshiba/ps3_gelic_net.c
+++ b/drivers/net/ethernet/toshiba/ps3_gelic_net.c
@@ -1150,7 +1150,7 @@ static irqreturn_t gelic_card_interrupt(int irq, void *ptr)
  * gelic_net_poll_controller - artificial interrupt for netconsole etc.
  * @netdev: interface device structure
  *
- * see Documentation/networking/netconsole.txt
+ * see Documentation/networking/netconsole.rst
  */
 void gelic_net_poll_controller(struct net_device *netdev)
 {
diff --git a/drivers/net/ethernet/toshiba/spider_net.c b/drivers/net/ethernet/toshiba/spider_net.c
index 6576271642c1..3902b3aeb0c2 100644
--- a/drivers/net/ethernet/toshiba/spider_net.c
+++ b/drivers/net/ethernet/toshiba/spider_net.c
@@ -1615,7 +1615,7 @@ spider_net_interrupt(int irq, void *ptr)
  * spider_net_poll_controller - artificial interrupt for netconsole etc.
  * @netdev: interface device structure
  *
- * see Documentation/networking/netconsole.txt
+ * see Documentation/networking/netconsole.rst
  */
 static void
 spider_net_poll_controller(struct net_device *netdev)
-- 
2.25.4

