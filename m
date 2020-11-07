Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C26D2AA341
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 09:11:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728046AbgKGIK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 7 Nov 2020 03:10:59 -0500
Received: from m176115.mail.qiye.163.com ([59.111.176.115]:36550 "EHLO
        m176115.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727738AbgKGIK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 7 Nov 2020 03:10:59 -0500
Received: from vivo-HP-ProDesk-680-G4-PCI-MT.vivo.xyz (unknown [58.251.74.231])
        by m176115.mail.qiye.163.com (Hmail) with ESMTPA id 064C5665C31;
        Sat,  7 Nov 2020 16:10:55 +0800 (CST)
From:   Wang Qing <wangqing@vivo.com>
To:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Wang Qing <wangqing@vivo.com>
Subject: [PATCH] bpf: remove duplicate include
Date:   Sat,  7 Nov 2020 16:10:50 +0800
Message-Id: <1604736650-11197-1-git-send-email-wangqing@vivo.com>
X-Mailer: git-send-email 2.7.4
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZHktKSR0fGR5OQx1OVkpNS09MSE1NTk1NTEtVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKQ1VLWQY+
X-HM-Sender-Digest: e1kMHhlZQR0aFwgeV1kSHx4VD1lBWUc6MQw6Pgw6TD8qIxwdNSkfVhcM
        Tx0KFEtVSlVKTUtPTEhNTU5MSktPVTMWGhIXVQwaFRwKEhUcOw0SDRRVGBQWRVlXWRILWUFZTkNV
        SU5KVUxPVUlISllXWQgBWUFKTElCNwY+
X-HM-Tid: 0a75a1c224b79373kuws064c5665c31
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Remove duplicate header which is included twice.

Signed-off-by: Wang Qing <wangqing@vivo.com>
---
 kernel/bpf/btf.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index ed7d02e..6324de8
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -22,7 +22,6 @@
 #include <linux/skmsg.h>
 #include <linux/perf_event.h>
 #include <linux/bsearch.h>
-#include <linux/btf_ids.h>
 #include <net/sock.h>
 
 /* BTF (BPF Type Format) is the meta data format which describes
-- 
2.7.4

