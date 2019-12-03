Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE619111FEF
	for <lists+netdev@lfdr.de>; Wed,  4 Dec 2019 00:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728428AbfLCWki (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 17:40:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:53680 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728410AbfLCWke (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Dec 2019 17:40:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F4F120865;
        Tue,  3 Dec 2019 22:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575412833;
        bh=aCuHffhspeFM8lqvonn/tz1sHFj1a5E3DwArfrnGxko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SOzlUg4V93dsW5Aub/vzm1jvZkuXBrafkRQdtBzq1cmFvqS0ia746V5lrwqs8CEV5
         px0S6FJtzaYVq6yabfexyHxGQ8K/xh1z8fZ3BmwGUlXmUxImItNC+zfMhy7yuuzZCf
         Mfq0HhWH9HSlEKukyKg7IiVa3e+CqPqDtPd8jywI=
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
Subject: [PATCH 5.3 033/135] samples/bpf: fix build by setting HAVE_ATTR_TEST to zero
Date:   Tue,  3 Dec 2019 23:34:33 +0100
Message-Id: <20191203213012.721079232@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191203213005.828543156@linuxfoundation.org>
References: <20191203213005.828543156@linuxfoundation.org>
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
index 1d9be26b4edd7..42b571cde1778 100644
--- a/samples/bpf/Makefile
+++ b/samples/bpf/Makefile
@@ -176,6 +176,7 @@ KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/bpf/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/testing/selftests/bpf/
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/lib/ -I$(srctree)/tools/include
 KBUILD_HOSTCFLAGS += -I$(srctree)/tools/perf
+KBUILD_HOSTCFLAGS += -DHAVE_ATTR_TEST=0
 
 HOSTCFLAGS_bpf_load.o += -I$(objtree)/usr/include -Wno-unused-variable
 
-- 
2.20.1



