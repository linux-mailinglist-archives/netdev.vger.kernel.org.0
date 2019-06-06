Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B42A381F1
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 01:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728008AbfFFXtb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Jun 2019 19:49:31 -0400
Received: from www62.your-server.de ([213.133.104.62]:47042 "EHLO
        www62.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726609AbfFFXtR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Jun 2019 19:49:17 -0400
Received: from [178.197.249.21] (helo=localhost)
        by www62.your-server.de with esmtpsa (TLSv1.2:DHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89_1)
        (envelope-from <daniel@iogearbox.net>)
        id 1hZ28C-0005Qw-6c; Fri, 07 Jun 2019 01:49:16 +0200
From:   Daniel Borkmann <daniel@iogearbox.net>
To:     alexei.starovoitov@gmail.com
Cc:     kafai@fb.com, rdna@fb.com, m@lambda.lt, bpf@vger.kernel.org,
        netdev@vger.kernel.org, Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH bpf v3 3/6] bpf, libbpf: enable recvmsg attach types
Date:   Fri,  7 Jun 2019 01:48:59 +0200
Message-Id: <20190606234902.4300-4-daniel@iogearbox.net>
X-Mailer: git-send-email 2.9.5
In-Reply-To: <20190606234902.4300-1-daniel@iogearbox.net>
References: <20190606234902.4300-1-daniel@iogearbox.net>
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.100.3/25472/Thu Jun  6 10:09:59 2019)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Another trivial patch to libbpf in order to enable identifying and
attaching programs to BPF_CGROUP_UDP{4,6}_RECVMSG by section name.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
---
 tools/lib/bpf/libbpf.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 5d046cc7b207..151f7ac1882e 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -3210,6 +3210,10 @@ static const struct {
 						BPF_CGROUP_UDP4_SENDMSG),
 	BPF_EAPROG_SEC("cgroup/sendmsg6",	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
 						BPF_CGROUP_UDP6_SENDMSG),
+	BPF_EAPROG_SEC("cgroup/recvmsg4",	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+						BPF_CGROUP_UDP4_RECVMSG),
+	BPF_EAPROG_SEC("cgroup/recvmsg6",	BPF_PROG_TYPE_CGROUP_SOCK_ADDR,
+						BPF_CGROUP_UDP6_RECVMSG),
 	BPF_EAPROG_SEC("cgroup/sysctl",		BPF_PROG_TYPE_CGROUP_SYSCTL,
 						BPF_CGROUP_SYSCTL),
 };
-- 
2.17.1

