Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 291A7FCBD0
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 18:28:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726750AbfKNR2n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 12:28:43 -0500
Received: from mga03.intel.com ([134.134.136.65]:32570 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726599AbfKNR2n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Nov 2019 12:28:43 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga103.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 14 Nov 2019 09:28:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,304,1569308400"; 
   d="scan'208";a="288286417"
Received: from aguedesl-testbed1.jf.intel.com ([10.54.31.71])
  by orsmga001.jf.intel.com with ESMTP; 14 Nov 2019 09:28:42 -0800
From:   Andre Guedes <andre.guedes@intel.com>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org
Subject: [PATCH bpf-next 1/2] samples/bpf: Remove duplicate option from xdpsock
Date:   Thu, 14 Nov 2019 08:28:46 -0800
Message-Id: <20191114162847.221770-1-andre.guedes@intel.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The '-f' option is shown twice in the usage(). This patch removes the
outdated version.

Signed-off-by: Andre Guedes <andre.guedes@intel.com>
---
 samples/bpf/xdpsock_user.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/samples/bpf/xdpsock_user.c b/samples/bpf/xdpsock_user.c
index a1f96e55e43a..c5d0a006cafc 100644
--- a/samples/bpf/xdpsock_user.c
+++ b/samples/bpf/xdpsock_user.c
@@ -393,7 +393,6 @@ static void usage(const char *prog)
 		"  -n, --interval=n	Specify statistics update interval (default 1 sec).\n"
 		"  -z, --zero-copy      Force zero-copy mode.\n"
 		"  -c, --copy           Force copy mode.\n"
-		"  -f, --frame-size=n   Set the frame size (must be a power of two, default is %d).\n"
 		"  -m, --no-need-wakeup Turn off use of driver need wakeup flag.\n"
 		"  -f, --frame-size=n   Set the frame size (must be a power of two in aligned mode, default is %d).\n"
 		"  -u, --unaligned	Enable unaligned chunk placement\n"
-- 
2.24.0

