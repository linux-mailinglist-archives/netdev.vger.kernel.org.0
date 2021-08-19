Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62BA83F145B
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 09:27:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbhHSH1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 03:27:53 -0400
Received: from mail.cn.fujitsu.com ([183.91.158.132]:12272 "EHLO
        heian.cn.fujitsu.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S231939AbhHSH1s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Aug 2021 03:27:48 -0400
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AuO5Y6qt2dDezUEFlOfkmKnAT7skDStV00zEX?=
 =?us-ascii?q?/kB9WHVpm62j5qSTdZEguCMc5wx+ZJheo7q90cW7IE80lqQFhLX5X43SPzUO0V?=
 =?us-ascii?q?HARO5fBODZsl/d8kPFltJ15ONJdqhSLJnKB0FmsMCS2mKFOudl7N6Z0K3Av4vj?=
 =?us-ascii?q?80s=3D?=
X-IronPort-AV: E=Sophos;i="5.84,334,1620662400"; 
   d="scan'208";a="113116172"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 19 Aug 2021 15:27:11 +0800
Received: from G08CNEXMBPEKD04.g08.fujitsu.local (unknown [10.167.33.201])
        by cn.fujitsu.com (Postfix) with ESMTP id 1FC834D0D4BE;
        Thu, 19 Aug 2021 15:27:09 +0800 (CST)
Received: from G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) by
 G08CNEXMBPEKD04.g08.fujitsu.local (10.167.33.201) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 19 Aug 2021 15:27:04 +0800
Received: from G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.80) by
 G08CNEXJMPEKD02.g08.fujitsu.local (10.167.33.202) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Thu, 19 Aug 2021 15:27:03 +0800
Received: from FNSTPC.g08.fujitsu.local (10.167.226.45) by
 G08CNEXCHPEKD07.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Thu, 19 Aug 2021 15:27:02 +0800
From:   Li Zhijian <lizhijian@cn.fujitsu.com>
To:     <shuah@kernel.org>, <linux-kselftest@vger.kernel.org>,
        <netdev@vger.kernel.org>, <bpf@vger.kernel.org>
CC:     <ast@kernel.org>, <daniel@iogearbox.net>, <andrii@kernel.org>,
        <kafai@fb.com>, <songliubraving@fb.com>, <yhs@fb.com>,
        <kpsingh@kernel.org>, <linux-kernel@vger.kernel.org>,
        <philip.li@intel.com>, <yifeix.zhu@intel.com>,
        Li Zhijian <lizhijian@cn.fujitsu.com>
Subject: [PATCH 3/3] selftests/bpf: add missing files required by test_bpftool.sh for installing
Date:   Thu, 19 Aug 2021 15:24:31 +0800
Message-ID: <20210819072431.21966-3-lizhijian@cn.fujitsu.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210819072431.21966-1-lizhijian@cn.fujitsu.com>
References: <20210819072431.21966-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7BIT
Content-Type:   text/plain; charset=US-ASCII
X-yoursite-MailScanner-ID: 1FC834D0D4BE.A187D
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
X-Spam-Status: No
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

- 'make install' will install bpftool to INSTALL_PATH/bpf/bpftool
- add INSTALL_PATH/bpf to PATH

Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>
---
 tools/testing/selftests/bpf/Makefile        | 4 +++-
 tools/testing/selftests/bpf/test_bpftool.sh | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index f405b20c1e6c..c6ca1b8e33d5 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -85,7 +85,7 @@ TEST_PROGS_EXTENDED := with_addr.sh \
 TEST_GEN_PROGS_EXTENDED = test_sock_addr test_skb_cgroup_id_user \
 	flow_dissector_load test_flow_dissector test_tcp_check_syncookie_user \
 	test_lirc_mode2_user xdping test_cpp runqslower bench bpf_testmod.ko \
-	xdpxceiver xdp_redirect_multi
+	xdpxceiver xdp_redirect_multi test_bpftool.py
 
 TEST_CUSTOM_PROGS = $(OUTPUT)/urandom_read
 
@@ -187,6 +187,8 @@ $(OUTPUT)/runqslower: $(BPFOBJ) | $(DEFAULT_BPFTOOL)
 		    BPFOBJ=$(BPFOBJ) BPF_INCLUDE=$(INCLUDE_DIR) &&	\
 		    cp $(SCRATCH_DIR)/runqslower $@
 
+TEST_GEN_PROGS_EXTENDED += $(DEFAULT_BPFTOOL)
+
 $(TEST_GEN_PROGS) $(TEST_GEN_PROGS_EXTENDED): $(OUTPUT)/test_stub.o $(BPFOBJ)
 
 $(OUTPUT)/test_dev_cgroup: cgroup_helpers.c
diff --git a/tools/testing/selftests/bpf/test_bpftool.sh b/tools/testing/selftests/bpf/test_bpftool.sh
index 6b7ba19be1d0..50cf9d3645d2 100755
--- a/tools/testing/selftests/bpf/test_bpftool.sh
+++ b/tools/testing/selftests/bpf/test_bpftool.sh
@@ -2,9 +2,10 @@
 # SPDX-License-Identifier: GPL-2.0
 # Copyright (c) 2020 SUSE LLC.
 
+# 'make -C tools/testing/selftests/bpf install' will install to SCRIPT_PATH
 SCRIPT_DIR=$(dirname $(realpath $0))
 
 # 'make -C tools/testing/selftests/bpf' will install to BPFTOOL_INSTALL_PATH
 BPFTOOL_INSTALL_PATH="$SCRIPT_DIR"/tools/sbin
-export PATH=$BPFTOOL_INSTALL_PATH:$PATH
+export PATH=$SCRIPT_DIR:$BPFTOOL_INSTALL_PATH:$PATH
 python3 -m unittest -v test_bpftool.TestBpftool
-- 
2.32.0



