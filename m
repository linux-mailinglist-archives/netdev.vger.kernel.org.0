Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD3894FC8
	for <lists+netdev@lfdr.de>; Mon, 19 Aug 2019 23:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728579AbfHSVV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 17:21:29 -0400
Received: from lekensteyn.nl ([178.21.112.251]:32881 "EHLO lekensteyn.nl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728376AbfHSVV2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Aug 2019 17:21:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lekensteyn.nl; s=s2048-2015-q1;
        h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From; bh=CPhDF5jnURDhjAxSFhJHWKq3/SRRecFjjjdMVgviX/E=;
        b=RpJXXkmzoFgbBUx1sJBeRcHJKuT3/TD6/lyleO5gyECCe5Im1ZGtsgioV7qOQNSOQ9H8LaNRFUpvCyaAI5XWirTUJRmHqgykZG0bncQM6g7OTi/uywPq9eskKMNeNw2mPUIAoTt4rCvsVXnFA93SsSHF+dxJ7WCwl+X1l4x9AsHZ6oG4Cz2Z/EOMcDuM/Qqhr1xj1NpDtweWRh72S1y/+xwr0rVYWjv2c0Xsvz6Cz9/r7lJLQJsV49/MBi6PgbuUG2CoPgZYUSlS6489CWe4iTLWndmoljJoVEuXwsYfOBgWx5iYEkg8EfRsJ6nKzsObRqRWVGPVBLWexQZMJd489g==;
Received: by lekensteyn.nl with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.84_2)
        (envelope-from <peter@lekensteyn.nl>)
        id 1hzp5h-0005T6-0w; Mon, 19 Aug 2019 23:21:25 +0200
From:   Peter Wu <peter@lekensteyn.nl>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: [PATCH 2/2] bpf: clarify description for CONFIG_BPF_EVENTS
Date:   Mon, 19 Aug 2019 22:21:22 +0100
Message-Id: <20190819212122.10286-3-peter@lekensteyn.nl>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190819212122.10286-1-peter@lekensteyn.nl>
References: <20190819212122.10286-1-peter@lekensteyn.nl>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -0.0 (/)
X-Spam-Status: No, hits=-0.0 required=5.0 tests=NO_RELAYS=-0.001 autolearn=unavailable autolearn_force=no
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

PERF_EVENT_IOC_SET_BPF supports uprobes since v4.3, and tracepoints
since v4.7 via commit 04a22fae4cbc ("tracing, perf: Implement BPF
programs attached to uprobes"), and commit 98b5c2c65c29 ("perf, bpf:
allow bpf programs attach to tracepoints") respectively.

Signed-off-by: Peter Wu <peter@lekensteyn.nl>
---
 kernel/trace/Kconfig | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/Kconfig b/kernel/trace/Kconfig
index 98da8998c25c..b09d7b1ffffd 100644
--- a/kernel/trace/Kconfig
+++ b/kernel/trace/Kconfig
@@ -520,7 +520,8 @@ config BPF_EVENTS
 	bool
 	default y
 	help
-	  This allows the user to attach BPF programs to kprobe events.
+	  This allows the user to attach BPF programs to kprobe, uprobe, and
+	  tracepoint events.
 
 config DYNAMIC_EVENTS
 	def_bool n
-- 
2.22.0

