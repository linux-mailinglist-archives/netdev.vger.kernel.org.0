Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C57B111F38
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 00:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729102AbfLCWpt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 17:45:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:34582 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728492AbfLCWpr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 17:45:47 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0B9B220803;
        Tue,  3 Dec 2019 22:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575413146;
        bh=gLRE7oHBtNQW2SoCK6VfPIZbi0YK/e97Ex2u9wJeTTg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vSb/5uZuTIx5STbe9ghhZDSRDSpzxOfcB0QDTznnwd47r8qaVbcac45gRtW/mQRBI
         KQbYDYWsVAOmQ7F/4sKaIfkvHx3LgoPyqxuly4LK3Rb4rXMrlDHbZYGE7gwB8+34B1
         kJGjzeZ+nNjBbdT3mVpRL6vzxXtAj2eyjp7IfPlA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        KP Singh <kpsingh@google.com>,
        Song Liu <songliubraving@fb.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 017/321] samples/bpf: fix build by setting HAVE_ATTR_TEST to zero
Date:   Tue,  3 Dec 2019 23:31:23 +0100
Message-Id: <20191203223428.016403897@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203223427.103571230@linuxfoundation.org>
References: <20191203223427.103571230@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

[ Upstream commit 04ec044b7d30800296824783df7d9728d16d7567 ]

To remove that test_attr__{enabled/open} are used by perf-sys.h, we
set HAVE_ATTR_TEST to zero.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
Tested-by: KP Singh <kpsingh@google.com>
Acked-by: Song Liu <songliubraving@fb.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: bpf@vger.kernel.org
Cc: netdev@vger.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: http://lore.kernel.org/bpf/20191001113307.27796-3-bjorn.topel@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 samples/bpf/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
index 36f9f41d094b2..75d4b48601aaa 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -172,6 +172,7 @@ KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
+KBUILD_HOSTCFLAGS += -DHAVE_ATTR_TEST=0
 
 HOSTCFLAGS_bpf_load.o += -I$(objtree)/usr/include -Wno-unused-variable
 HOSTCFLAGS_trace_helpers.o += -I$(srctree)/tools/lib/bpf/
-- 
2.20.1



