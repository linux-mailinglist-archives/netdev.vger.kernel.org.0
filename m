Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B4C74FCBCF
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 18:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbfKNR2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 12:28:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:32570 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726598AbfKNR2m (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 12:28:42 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 09:28:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="288286418"
Received: from aguedesl-testbed1.jf.intel.com ([10.54.31.71])
  by orsmga001.jf.intel.com with ESMTP; 14 Nov 2019 09:28:42 -0800
From:   Andre Guedes <andre.guedes@intel.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH bpf-next 2/2] samples/bpf: Add missing option to xdpsock usage
Date:   Thu, 14 Nov 2019 08:28:47 -0800
Message-Id: <20191114162847.221770-2-andre.guedes@intel.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191114162847.221770-1-andre.guedes@intel.com>
References: <20191114162847.221770-1-andre.guedes@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Commit 743e568c1586 (samples/bpf: Add a "force" flag to XDP samples)
introduced the '-F' option but missed adding it to the usage() and the
'long_option' array.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
---
 samples/bpf/xdpsock_user.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index c5d0a006cafc..a15480010828 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -374,6 +374,7 @@ static struct option long_options[] = {
 	{"no-need-wakeup", no_argument, 0, 'm'},
 	{"unaligned", no_argument, 0, 'u'},
 	{"shared-umem", no_argument, 0, 'M'},
+	{"force", no_argument, 0, 'F'},
 	{0, 0, 0, 0}
 };
 
@@ -397,6 +398,7 @@ static void usage(const char *prog)
 		"  -f, --frame-size=n   Set the frame size (must be a power of two in aligned mode, default is %d).\n"
 		"  -u, --unaligned	Enable unaligned chunk placement\n"
 		"  -M, --shared-umem	Enable XDP_SHARED_UMEM\n"
+		"  -F, --force		Force loading the XDP prog\n"
 		"\n";
 	fprintf(stderr, str, prog, XSK_UMEM__DEFAULT_FRAME_SIZE);
 	exit(EXIT_FAILURE);
-- 
2.24.0

