Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B07AC2943A7
	for <lists+netdev@lfdr.de>; Tue, 20 Oct 2020 22:00:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405689AbgJTUAC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Oct 2020 16:00:02 -0400
Received: from www62.your-server.de ([213.133.104.62]:39162 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733109AbgJTUAC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Oct 2020 16:00:02 -0400
Received: from 75.57.196.178.dynamic.wline.res.cust.swisscom.ch ([178.196.57.75] helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1kUxnc-0008IX-HE; Tue, 20 Oct 2020 22:00:00 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH bpf] bpf, doc: Fix patchwork URL to point to kernel.org instance
Date:   Tue, 20 Oct 2020 21:59:55 +0200
Message-Id: <f73ae01c7e6f9cf0a3890f2ca988a8e69190c50b.1603223852.git.daniel@iogearbox.net>
X-Mailer: git-send-email 2.21.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.102.4/25963/Tue Oct 20 16:00:29 2020)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Follow-up on ebb034b15bfa ("bpf: Migrate from patchwork.ozlabs.org
to patchwork.kernel.org.") in order to fix up the patchwork URL (Q)
in the MAINTAINERS file for BPF subsystem.

While at it, also add the official website (W) entry.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 MAINTAINERS | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 0f59b0412953..6d50cbf198b5 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3244,7 +3244,8 @@ R:	KP Singh <kpsingh@chromium.org>
 L:	netdev@vger.kernel.org
 L:	bpf@vger.kernel.org
 S:	Supported
-Q:	https://patchwork.ozlabs.org/project/netdev/list/?delegate=77147
+W:	https://bpf.io/
+Q:	https://patchwork.kernel.org/project/netdevbpf/list/?delegate=121173
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf.git
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git
 F:	Documentation/bpf/
-- 
2.21.0

