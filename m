Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 533BDD6ED6
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 07:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728964AbfJOFdY convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 15 Oct 2019 01:33:24 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:42255 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728672AbfJOFcV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 01:32:21 -0400
Received: from [5.158.153.53] (helo=tip-bot2.lab.linutronix.de)
        by Galois.linutronix.de with esmtpsa (TLS1.2:DHE_RSA_AES_256_CBC_SHA256:256)
        (Exim 4.80)
        (envelope-from <tip-bot2@linutronix.de>)
        id 1iKFRH-0000QF-N9; Tue, 15 Oct 2019 07:32:07 +0200
Received: from [127.0.1.1] (localhost [IPv6:::1])
        by tip-bot2.lab.linutronix.de (Postfix) with ESMTP id 0F7361C04D4;
        Tue, 15 Oct 2019 07:31:49 +0200 (CEST)
Date:   Tue, 15 Oct 2019 05:31:48 -0000
From:   tip-bot2 for =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= 
        <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/core] samples/bpf: fix build by setting HAVE_ATTR_TEST to zero
Cc:     =?utf-8?q?Bj=C3=B6rn_T=C3=B6pel?= <bjorn.topel@intel.com>,
        KP Singh <kpsingh@google.com>,
        Song Liu <songliubraving@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, Borislav Petkov <bp@alien8.de>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20191001113307.27796-3-bjorn.topel@gmail.com>
References: <20191001113307.27796-3-bjorn.topel@gmail.com>
MIME-Version: 1.0
Message-ID: <157111750893.12254.16541060201823244763.tip-bot2@tip-bot2>
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The following commit has been merged into the perf/core branch of tip:

Commit-ID:     fce9501aec6bdda45ef3a5e365a5e0de7de7fe2d
Gitweb:        https://git.kernel.org/tip/fce9501aec6bdda45ef3a5e365a5e0de7de7fe2d
Author:        Björn Töpel <bjorn.topel@intel.com>
AuthorDate:    Tue, 01 Oct 2019 13:33:07 +02:00
Committer:     Arnaldo Carvalho de Melo <acme@redhat.com>
CommitterDate: Mon, 07 Oct 2019 12:22:18 -03:00

samples/bpf: fix build by setting HAVE_ATTR_TEST to zero

To remove that test_attr__{enabled/open} are used by perf-sys.h, we
set HAVE_ATTR_TEST to zero.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: KP Singh <kpsingh@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Link: http://lore.kernel.org/lkml/20191001113307.27796-3-bjorn.topel@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 samples/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 1d9be26..42b571c 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -176,6 +176,7 @@ KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
+KBUILD_HOSTCFLAGS += -DHAVE_ATTR_TEST=0
 
 HOSTCFLAGS_bpf_load.o += -I$(objtree)/usr/include -Wno-unused-variable
 
