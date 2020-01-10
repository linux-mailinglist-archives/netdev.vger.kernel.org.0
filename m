Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F264136683
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 06:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbgAJFRa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 00:17:30 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:42724 "EHLO
        mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726671AbgAJFR3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jan 2020 00:17:29 -0500
Received: from pps.filterd (m0001303.ppops.net [127.0.0.1])
        by m0001303.ppops.net (8.16.0.42/8.16.0.42) with SMTP id 00A5CFgY015581
        for <netdev@vger.kernel.org>; Thu, 9 Jan 2020 21:17:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=from : to : cc : subject
 : date : message-id : in-reply-to : references : mime-version :
 content-type; s=facebook; bh=wKGWQv10BLOHB1U8fxwHFhH0Wek0n3/qg92CvH2GY7U=;
 b=j8Uwf6vKFpPVnDaErBpL1VEdDNJ0P00Gpv8VSyLjytBaCd3C1etZrXOYx0qZyuyCTk5k
 m6nJl2fTF+FKAJfYhgRnXOrl42D+1QRWAzI65UV+bSmyAbdgYWn+tyLRLTXHF1CJ5Ttc
 Wd+EaFSx+rqJZlotXVpLxxZYgl2Uep/gERo= 
Received: from mail.thefacebook.com (mailout.thefacebook.com [199.201.64.23])
        by m0001303.ppops.net with ESMTP id 2xdrhwymku-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT)
        for <netdev@vger.kernel.org>; Thu, 09 Jan 2020 21:17:28 -0800
Received: from intmgw001.41.prn1.facebook.com (2620:10d:c081:10::13) by
 mail.thefacebook.com (2620:10d:c081:35::130) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA) id 15.1.1713.5;
 Thu, 9 Jan 2020 21:17:25 -0800
Received: by devbig012.ftw2.facebook.com (Postfix, from userid 137359)
        id 556C12EC158B; Thu,  9 Jan 2020 21:17:24 -0800 (PST)
Smtp-Origin-Hostprefix: devbig
From:   Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Hostname: devbig012.ftw2.facebook.com
To:     <bpf@vger.kernel.org>, <netdev@vger.kernel.org>, <ast@fb.com>,
        <daniel@iogearbox.net>
CC:     <andrii.nakryiko@gmail.com>, <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Smtp-Origin-Cluster: ftw2c04
Subject: [PATCH bpf-next 3/3] selftests/bpf: further clean up Makefile output
Date:   Thu, 9 Jan 2020 21:17:16 -0800
Message-ID: <20200110051716.1591485-4-andriin@fb.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200110051716.1591485-1-andriin@fb.com>
References: <20200110051716.1591485-1-andriin@fb.com>
X-FB-Internal: Safe
MIME-Version: 1.0
Content-Type: text/plain
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.138,18.0.572
 definitions=2020-01-10_01:2020-01-10,2020-01-09 signatures=0
X-Proofpoint-Spam-Details: rule=fb_default_notspam policy=fb_default score=0 phishscore=0
 lowpriorityscore=0 priorityscore=1501 spamscore=0 impostorscore=0
 mlxscore=0 mlxlogscore=716 malwarescore=0 adultscore=0 suspectscore=9
 clxscore=1015 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-1910280000 definitions=main-2001100045
X-FB-Internal: deliver
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Further clean up Makefile output:
- hide "entering directory" messages;
- silvence sub-Make command echoing;
- succinct MKDIR messages.

Also remove few test binaries that are not produced anymore from .gitignore.

Signed-off-by: Andrii Nakryiko <andriin@fb.com>
---
 tools/testing/selftests/bpf/.gitignore |  2 --
 tools/testing/selftests/bpf/Makefile   | 10 +++++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/tools/testing/selftests/bpf/.gitignore b/tools/testing/selftests/bpf/.gitignore
index 301ac12d5d69..1d14e3ab70be 100644
--- a/tools/testing/selftests/bpf/.gitignore
+++ b/tools/testing/selftests/bpf/.gitignore
@@ -22,11 +22,9 @@ get_cgroup_id_user
 test_skb_cgroup_id_user
 test_socket_cookie
 test_cgroup_storage
-test_select_reuseport
 test_flow_dissector
 flow_dissector_load
 test_netcnt
-test_section_names
 test_tcpnotify_user
 test_libbpf
 test_tcp_check_syncookie_user
diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftests/bpf/Makefile
index c0a18994db87..c28e67548f45 100644
--- a/tools/testing/selftests/bpf/Makefile
+++ b/tools/testing/selftests/bpf/Makefile
@@ -83,9 +83,12 @@ TEST_CUSTOM_PROGS = urandom_read
 # $3 - target (assumed to be file); only file name will be emitted;
 # $4 - optional extra arg, emitted as-is, if provided.
 ifeq ($(V),1)
+Q =
 msg =
 else
+Q = @
 msg = @$(info $(1)$(if $(2), [$(2)]) $(notdir $(3)))$(if $(4), $(4))
+MAKEFLAGS += --no-print-directory
 endif
 
 # override lib.mk's default rules
@@ -147,14 +150,14 @@ DEFAULT_BPFTOOL := $(OUTPUT)/tools/usr/local/sbin/bpftool
 BPFTOOL ?= $(DEFAULT_BPFTOOL)
 
 $(DEFAULT_BPFTOOL): force
-	$(MAKE) -C $(BPFTOOLDIR) DESTDIR=$(OUTPUT)/tools install
+	$(Q)$(MAKE) -C $(BPFTOOLDIR) DESTDIR=$(OUTPUT)/tools install
 
 $(BPFOBJ): force
-	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
+	$(Q)$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/
 
 BPF_HELPERS := $(OUTPUT)/bpf_helper_defs.h $(wildcard $(BPFDIR)/bpf_*.h)
 $(OUTPUT)/bpf_helper_defs.h: $(BPFOBJ)
-	$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
+	$(Q)$(MAKE) -C $(BPFDIR) OUTPUT=$(OUTPUT)/ $(OUTPUT)/bpf_helper_defs.h
 
 # Get Clang's default includes on this system, as opposed to those seen by
 # '-target bpf'. This fixes "missing" files on some architectures/distros,
@@ -253,6 +256,7 @@ define DEFINE_TEST_RUNNER_RULES
 ifeq ($($(TRUNNER_OUTPUT)-dir),)
 $(TRUNNER_OUTPUT)-dir := y
 $(TRUNNER_OUTPUT):
+	$$(call msg,      MKDIR,,$$@)
 	mkdir -p $$@
 endif
 
-- 
2.17.1

