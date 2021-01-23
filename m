Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 16DE23017EE
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 19:58:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726021AbhAWS5p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Jan 2021 13:57:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbhAWS5n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Jan 2021 13:57:43 -0500
X-Greylist: delayed 265 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 23 Jan 2021 10:57:03 PST
Received: from mx.der-flo.net (mx.der-flo.net [IPv6:2001:67c:26f4:224::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484FCC06174A;
        Sat, 23 Jan 2021 10:57:03 -0800 (PST)
Received: by mx.der-flo.net (Postfix, from userid 110)
        id ECBCA448C9; Sat, 23 Jan 2021 19:52:35 +0100 (CET)
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mx.der-flo.net
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=4.0 tests=ALL_TRUSTED,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.2
Received: from localhost (unknown [IPv6:2a02:1205:34c2:d100:56f5:35da:21bf:c38d])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx.der-flo.net (Postfix) with ESMTPSA id 17191448C0;
        Sat, 23 Jan 2021 19:52:26 +0100 (CET)
From:   Florian Lehner <dev@der-flo.net>
To:     bpf@vger.kernel.org
Cc:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, yhs@fb.com, Florian Lehner <dev@der-flo.net>
Subject: [PATCH bpf-next] tools headers: Sync struct bpf_perf_event_data
Date:   Sat, 23 Jan 2021 19:52:21 +0100
Message-Id: <20210123185221.23946-1-dev@der-flo.net>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Update struct bpf_perf_event_data with the addr field to match the
tools headers with the kernel headers.

Signed-off-by: Florian Lehner <dev@der-flo.net>
---
 tools/include/uapi/linux/bpf_perf_event.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/include/uapi/linux/bpf_perf_event.h b/tools/include/uapi/linux/bpf_perf_event.h
index 8f95303f9d80..eb1b9d21250c 100644
--- a/tools/include/uapi/linux/bpf_perf_event.h
+++ b/tools/include/uapi/linux/bpf_perf_event.h
@@ -13,6 +13,7 @@
 struct bpf_perf_event_data {
 	bpf_user_pt_regs_t regs;
 	__u64 sample_period;
+	__u64 addr;
 };
 
 #endif /* _UAPI__LINUX_BPF_PERF_EVENT_H__ */
-- 
2.29.2

