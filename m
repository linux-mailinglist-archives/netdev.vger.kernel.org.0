Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79C55374F8C
	for <lists+netdev@lfdr.de>; Thu,  6 May 2021 08:47:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232529AbhEFGsS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 May 2021 02:48:18 -0400
Received: from mga01.intel.com ([192.55.52.88]:41049 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232569AbhEFGsQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 6 May 2021 02:48:16 -0400
IronPort-SDR: yTQstnWZHBoI01I9mwqVbRzwNUdfpAgV1SmHTuo+Iu8e9jCjGMPNCyVGIhoobjy5G4AolECe/J
 Q5rBlVMO5soQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9975"; a="219271699"
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="219271699"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 May 2021 23:47:18 -0700
IronPort-SDR: QV7EV8DKOppib5GoJmJaTQ+qL63Py6AkEY0HH26I07+nRbgI2oqmRt6YJVtK+keXnReDttHVZq
 cLPO+6ClfRQw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,276,1613462400"; 
   d="scan'208";a="452259518"
Received: from unknown (HELO intel-86.bj.intel.com) ([10.238.154.86])
  by fmsmga004.fm.intel.com with ESMTP; 05 May 2021 23:47:17 -0700
From:   Zhu Yanjun <yanjun.zhu@intel.com>
To:     mariuszx.dudek@intel.com, netdev@vger.kernel.org, bjorn@kernel.org,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com
Cc:     Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: [PATCH 1/1] samples: bpf: fix the compiling error
Date:   Thu,  6 May 2021 19:11:58 -0400
Message-Id: <20210506231158.250926-1-yanjun.zhu@intel.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <zyjzyj2000@gmail.com>

When compiling, the following error will appear.

"
samples/bpf//xdpsock_user.c:27:10: fatal error: sys/capability.h:
 No such file or directory
"
Now capability.h is in linux directory.

Fixes: 3627d9702d78 ("samples/bpf: Sample application for eBPF load and socket creation split")
Signed-off-by: Zhu Yanjun <zyjzyj2000@gmail.com>
---
 samples/bpf/xdpsock_user.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index aa696854be78..44200aa694cb 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -24,7 +24,7 @@
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
-#include <sys/capability.h>
+#include <linux/capability.h>
 #include <sys/mman.h>
 #include <sys/resource.h>
 #include <sys/socket.h>
-- 
2.27.0

