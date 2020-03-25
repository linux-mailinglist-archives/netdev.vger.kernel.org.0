Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8C67D1931F4
	for <lists+netdev@lfdr.de>; Wed, 25 Mar 2020 21:32:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727358AbgCYUce (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 16:32:34 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:34872 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727236AbgCYUce (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 16:32:34 -0400
Received: by mail-pg1-f195.google.com with SMTP id 7so1730377pgr.2
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 13:32:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7b97IanHsNU9FtGW//Ik5a5LL3T3hq6twS325QzHtXs=;
        b=owuGPeUDxoesgUw0imrcs81O9+rGvTeI26D21Pv9WKRAKgN+fJQRGJnHyZm1v/JNl4
         2uAj1Ycqr8Zv2sX5ECsI2r4hYLcfqKvoChlOap6FRsFfEMHosrkZIPSNYbv3ZWlYG/32
         MYTT9LYDUlRua+PIBBfILWnZG1eOCyt/GH06+u1//rXgkigtD5Bt/7LJthZwrKenlCRD
         9wyilIM57Vi52l53WIpn+DwydZmcQSSJM19SjhAF0jeFGcD9ksUFw5wr5WlPoEat0trQ
         bsZ4laLeD2kgtiEt+3+3+wguZjl3/7/D0PF3da4HjyyuPk4E3NhwXuppqJ2ab2cPYBTo
         tQ6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=7b97IanHsNU9FtGW//Ik5a5LL3T3hq6twS325QzHtXs=;
        b=srmzveao3ENDqncTCFytRxHKpxtwxPkV6JC+/vdCcr8l3s3ZGaeXiQFUaMHhCAnRRs
         Wm2MuhPR6YTediKEKDkKSwocytyYX89bW5nqufOmx0hTweFP+rAH3KQBgiAuK2ARu7ux
         RBJ38dPntj/LIi7kd3gAN7mDOpa2H44b6UoNGmKxgSaWRsL/WbvHYDyLFJngN/QfJ6il
         DuKFp411/COocXDHgVGtSSqePksyVvUrnpa7PxjfWvvSGjuQKrB6r1HvlNbuSLnJ2XyA
         OVggyg2YFyBb1KoWnZXHlsNmFHYlrv5JBK4ybRkk+jDPkTnPjR1wYfYVwiYXFW4rEPzq
         6wsQ==
X-Gm-Message-State: ANhLgQ2FZUTNEjbX2jPbr9TNekzwTbGPm14ZSJnSxD9LeUPY1FQ0+1PH
        jN7RR04aY0/QPaXEnpB9GIU=
X-Google-Smtp-Source: ADFU+vtY6TNAfiCgRhVX7rxvFzhHfURgZe00Qsfq78IvkBPpocZLipFCFCw2BAfgdhe8G3+9MkUffg==
X-Received: by 2002:a62:7c8b:: with SMTP id x133mr5152058pfc.229.1585168351789;
        Wed, 25 Mar 2020 13:32:31 -0700 (PDT)
Received: from jian-dev.svl.corp.google.com ([2620:15c:2c4:201:83ec:eccf:6871:57])
        by smtp.gmail.com with ESMTPSA id q185sm5736pfb.154.2020.03.25.13.32.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Mar 2020 13:32:31 -0700 (PDT)
From:   Jian Yang <jianyang.kernel@gmail.com>
To:     davem@davemloft.net, netdev@vger.kernel.org
Cc:     Willem de Bruijn <willemb@google.com>,
        Jian Yang <jianyang@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next] selftests: move timestamping selftests to net folder
Date:   Wed, 25 Mar 2020 13:32:07 -0700
Message-Id: <20200325203207.221383-1-jianyang.kernel@gmail.com>
X-Mailer: git-send-email 2.25.1.696.g5e7596f4ac-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jian Yang <jianyang@google.com>

For historical reasons, there are several timestamping selftest targets
in selftests/networking/timestamping. Move them to the standard
directory for networking tests: selftests/net.

Signed-off-by: Jian Yang <jianyang@google.com>
Acked-by: Willem de Bruijn <willemb@google.com>
---
 tools/testing/selftests/Makefile                      |  1 -
 tools/testing/selftests/net/.gitignore                |  6 +++++-
 tools/testing/selftests/net/Makefile                  |  4 +++-
 tools/testing/selftests/net/config                    |  2 ++
 .../timestamping => net}/hwtstamp_config.c            |  0
 .../{networking/timestamping => net}/rxtimestamp.c    |  0
 .../{networking/timestamping => net}/timestamping.c   |  0
 .../{networking/timestamping => net}/txtimestamp.c    |  0
 .../{networking/timestamping => net}/txtimestamp.sh   |  2 +-
 .../selftests/networking/timestamping/.gitignore      |  4 ----
 .../selftests/networking/timestamping/Makefile        | 11 -----------
 .../testing/selftests/networking/timestamping/config  |  2 --
 12 files changed, 11 insertions(+), 21 deletions(-)
 rename tools/testing/selftests/{networking/timestamping => net}/hwtstamp_config.c (100%)
 rename tools/testing/selftests/{networking/timestamping => net}/rxtimestamp.c (100%)
 rename tools/testing/selftests/{networking/timestamping => net}/timestamping.c (100%)
 rename tools/testing/selftests/{networking/timestamping => net}/txtimestamp.c (100%)
 rename tools/testing/selftests/{networking/timestamping => net}/txtimestamp.sh (98%)
 delete mode 100644 tools/testing/selftests/networking/timestamping/.gitignore
 delete mode 100644 tools/testing/selftests/networking/timestamping/Makefile
 delete mode 100644 tools/testing/selftests/networking/timestamping/config

diff --git a/tools/testing/selftests/Makefile b/tools/testing/selftests/Makefile
index 6ec503912bea..6155761242a2 100644
--- a/tools/testing/selftests/Makefile
+++ b/tools/testing/selftests/Makefile
@@ -35,7 +35,6 @@ TARGETS += mqueue
 TARGETS += net
 TARGETS += net/mptcp
 TARGETS += netfilter
-TARGETS += networking/timestamping
 TARGETS += nsfs
 TARGETS += pidfd
 TARGETS += powerpc
diff --git a/tools/testing/selftests/net/.gitignore b/tools/testing/selftests/net/.gitignore
index 91f9aea853b1..997c65dcad68 100644
--- a/tools/testing/selftests/net/.gitignore
+++ b/tools/testing/selftests/net/.gitignore
@@ -23,4 +23,8 @@ so_txtime
 tcp_fastopen_backup_key
 nettest
 fin_ack_lat
-reuseaddr_ports_exhausted
\ No newline at end of file
+reuseaddr_ports_exhausted
+hwtstamp_config
+rxtimestamp
+timestamping
+txtimestamp
diff --git a/tools/testing/selftests/net/Makefile b/tools/testing/selftests/net/Makefile
index 48063fd69924..d4e38bd5175d 100644
--- a/tools/testing/selftests/net/Makefile
+++ b/tools/testing/selftests/net/Makefile
@@ -13,6 +13,7 @@ TEST_PROGS += test_vxlan_fdb_changelink.sh so_txtime.sh ipv6_flowlabel.sh
 TEST_PROGS += tcp_fastopen_backup_key.sh fcnal-test.sh l2tp.sh traceroute.sh
 TEST_PROGS += fin_ack_lat.sh
 TEST_PROGS += reuseaddr_ports_exhausted.sh
+TEST_PROGS += txtimestamp.sh
 TEST_PROGS_EXTENDED := in_netns.sh
 TEST_GEN_FILES =  socket nettest
 TEST_GEN_FILES += psock_fanout psock_tpacket msg_zerocopy reuseport_addr_any
@@ -21,9 +22,10 @@ TEST_GEN_FILES += udpgso udpgso_bench_tx udpgso_bench_rx ip_defrag
 TEST_GEN_FILES += so_txtime ipv6_flowlabel ipv6_flowlabel_mgr
 TEST_GEN_FILES += tcp_fastopen_backup_key
 TEST_GEN_FILES += fin_ack_lat
+TEST_GEN_FILES += reuseaddr_ports_exhausted
+TEST_GEN_FILES += hwtstamp_config rxtimestamp timestamping txtimestamp
 TEST_GEN_PROGS = reuseport_bpf reuseport_bpf_cpu reuseport_bpf_numa
 TEST_GEN_PROGS += reuseport_dualstack reuseaddr_conflict tls
-TEST_GEN_FILES += reuseaddr_ports_exhausted
 
 KSFT_KHDR_INSTALL := 1
 include ../lib.mk
diff --git a/tools/testing/selftests/net/config b/tools/testing/selftests/net/config
index b8503a8119b0..3b42c06b5985 100644
--- a/tools/testing/selftests/net/config
+++ b/tools/testing/selftests/net/config
@@ -12,6 +12,7 @@ CONFIG_IPV6_VTI=y
 CONFIG_DUMMY=y
 CONFIG_BRIDGE=y
 CONFIG_VLAN_8021Q=y
+CONFIG_IFB=y
 CONFIG_NETFILTER=y
 CONFIG_NETFILTER_ADVANCED=y
 CONFIG_NF_CONNTRACK=m
@@ -27,5 +28,6 @@ CONFIG_NFT_CHAIN_NAT_IPV6=m
 CONFIG_NFT_CHAIN_NAT_IPV4=m
 CONFIG_NET_SCH_FQ=m
 CONFIG_NET_SCH_ETF=m
+CONFIG_NET_SCH_NETEM=y
 CONFIG_TEST_BLACKHOLE_DEV=m
 CONFIG_KALLSYMS=y
diff --git a/tools/testing/selftests/networking/timestamping/hwtstamp_config.c b/tools/testing/selftests/net/hwtstamp_config.c
similarity index 100%
rename from tools/testing/selftests/networking/timestamping/hwtstamp_config.c
rename to tools/testing/selftests/net/hwtstamp_config.c
diff --git a/tools/testing/selftests/networking/timestamping/rxtimestamp.c b/tools/testing/selftests/net/rxtimestamp.c
similarity index 100%
rename from tools/testing/selftests/networking/timestamping/rxtimestamp.c
rename to tools/testing/selftests/net/rxtimestamp.c
diff --git a/tools/testing/selftests/networking/timestamping/timestamping.c b/tools/testing/selftests/net/timestamping.c
similarity index 100%
rename from tools/testing/selftests/networking/timestamping/timestamping.c
rename to tools/testing/selftests/net/timestamping.c
diff --git a/tools/testing/selftests/networking/timestamping/txtimestamp.c b/tools/testing/selftests/net/txtimestamp.c
similarity index 100%
rename from tools/testing/selftests/networking/timestamping/txtimestamp.c
rename to tools/testing/selftests/net/txtimestamp.c
diff --git a/tools/testing/selftests/networking/timestamping/txtimestamp.sh b/tools/testing/selftests/net/txtimestamp.sh
similarity index 98%
rename from tools/testing/selftests/networking/timestamping/txtimestamp.sh
rename to tools/testing/selftests/net/txtimestamp.sh
index 70a8cda7fd53..eea6f5193693 100755
--- a/tools/testing/selftests/networking/timestamping/txtimestamp.sh
+++ b/tools/testing/selftests/net/txtimestamp.sh
@@ -76,7 +76,7 @@ main() {
 }
 
 if [[ "$(ip netns identify)" == "root" ]]; then
-	../../net/in_netns.sh $0 $@
+	./in_netns.sh $0 $@
 else
 	main $@
 fi
diff --git a/tools/testing/selftests/networking/timestamping/.gitignore b/tools/testing/selftests/networking/timestamping/.gitignore
deleted file mode 100644
index d9355035e746..000000000000
--- a/tools/testing/selftests/networking/timestamping/.gitignore
+++ /dev/null
@@ -1,4 +0,0 @@
-timestamping
-rxtimestamp
-txtimestamp
-hwtstamp_config
diff --git a/tools/testing/selftests/networking/timestamping/Makefile b/tools/testing/selftests/networking/timestamping/Makefile
deleted file mode 100644
index 1de8bd8ccf5d..000000000000
--- a/tools/testing/selftests/networking/timestamping/Makefile
+++ /dev/null
@@ -1,11 +0,0 @@
-# SPDX-License-Identifier: GPL-2.0
-CFLAGS += -I../../../../../usr/include
-
-TEST_GEN_FILES := hwtstamp_config rxtimestamp timestamping txtimestamp
-TEST_PROGS := txtimestamp.sh
-
-all: $(TEST_PROGS)
-
-top_srcdir = ../../../../..
-KSFT_KHDR_INSTALL := 1
-include ../../lib.mk
diff --git a/tools/testing/selftests/networking/timestamping/config b/tools/testing/selftests/networking/timestamping/config
deleted file mode 100644
index a13e3169b0a4..000000000000
--- a/tools/testing/selftests/networking/timestamping/config
+++ /dev/null
@@ -1,2 +0,0 @@
-CONFIG_IFB=y
-CONFIG_NET_SCH_NETEM=y
-- 
2.25.1.696.g5e7596f4ac-goog

