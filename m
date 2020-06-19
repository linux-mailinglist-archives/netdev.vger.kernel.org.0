Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEF31201E6C
	for <lists+netdev@lfdr.de>; Sat, 20 Jun 2020 00:59:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730312AbgFSW6N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jun 2020 18:58:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:53398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730284AbgFSW6H (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jun 2020 18:58:07 -0400
Received: from localhost.localdomain.com (unknown [151.48.138.186])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D92D2247F;
        Fri, 19 Jun 2020 22:58:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592607486;
        bh=qZHCdCE36PhDb3CNB6bdd7j+4Hmh4w1zsxMaXmTPi28=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fzesbRn5wVlh3zJK/OaGMspfQ0wVR4QxvyxYFGo9XhHqumk0kq/PkWiDD73yzkled
         /f87a9BPEnrJf/IzBzopXxi5eyfo9S+emS1HWV/3zblRuOJoAUYhR75MnA/J1m+Jhc
         qj/wU6488tx5fp8/7L0srMA72IBtFNyRa06a5rN8=
From:   Lorenzo Bianconi <lorenzo@kernel.org>
To:     bpf@vger.kernel.org, netdev@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, brouer@redhat.com,
        daniel@iogearbox.net, toke@redhat.com, lorenzo.bianconi@redhat.com,
        dsahern@kernel.org
Subject: [PATCH v2 bpf-next 6/8] libbpf: add SEC name for xdp programs attached to CPUMAP
Date:   Sat, 20 Jun 2020 00:57:22 +0200
Message-Id: <02a278b08d7c33a8cf0faf2a16931cd11addbc47.1592606391.git.lorenzo@kernel.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <cover.1592606391.git.lorenzo@kernel.org>
References: <cover.1592606391.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

As for DEVMAP, support SEC("xdp_cpumap*") as a short cut for loading
the program with type BPF_PROG_TYPE_XDP and expected attach type
BPF_XDP_CPUMAP.

Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
---
 tools/lib/bpf/libbpf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 477c679ed945..0cd13cad8375 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6655,6 +6655,8 @@ static const struct bpf_sec_def section_defs[] = {
 		.attach_fn = attach_iter),
 	BPF_EAPROG_SEC("xdp_devmap",		BPF_PROG_TYPE_XDP,
 						BPF_XDP_DEVMAP),
+	BPF_EAPROG_SEC("xdp_cpumap",		BPF_PROG_TYPE_XDP,
+						BPF_XDP_CPUMAP),
 	BPF_PROG_SEC("xdp",			BPF_PROG_TYPE_XDP),
 	BPF_PROG_SEC("perf_event",		BPF_PROG_TYPE_PERF_EVENT),
 	BPF_PROG_SEC("lwt_in",			BPF_PROG_TYPE_LWT_IN),
-- 
2.26.2

