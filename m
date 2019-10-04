Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9459ECC19C
	for <lists+netdev@lfdr.de>; Fri,  4 Oct 2019 19:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388406AbfJDRWs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Oct 2019 13:22:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60512 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388348AbfJDRWr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Oct 2019 13:22:47 -0400
Received: from mail-ed1-f70.google.com (mail-ed1-f70.google.com [209.85.208.70])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id AA5B650F45
        for <netdev@vger.kernel.org>; Fri,  4 Oct 2019 17:22:46 +0000 (UTC)
Received: by mail-ed1-f70.google.com with SMTP id w12so4476945eda.6
        for <netdev@vger.kernel.org>; Fri, 04 Oct 2019 10:22:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=urnOQbCIqgN9VJJBEDXd9119kTpjIH20ynL4sw0ghD8=;
        b=s7X0PclqDd3OZH6WD8exQ9PCu9FV7tIqpFBa3kTGsTs4yAPIAg82bbn2oH79TMRnT8
         2SY0eYHgdHv67S8mK3d+EPrSsignEftRfeAJ1Mw1vysq6jGqO0b8xh2ysHt0HseDEyxq
         par2j33bSe82lT0qv+pZGnqcW/jcjA6GDW/nqFBqtzruuczGIXArfmlTRxj9ZQX/4RbS
         NoaWXjZaosPnOS2mT7BN4hRfdYrJVQ0qhWJecDBU/sukJZfdBdNu+nwjvyX7tDia5LJ8
         taUSr1NqBeU7G3NPfslgRLBRO3rcZ1NX9DMg0Y0WHcYH6h6YSDeBiXTRImDthrvvzULJ
         rbPg==
X-Gm-Message-State: APjAAAWeAXSfbMRGPfr6bOkBLKHlSq2wT6NlII6HaH2R4nlQ76JJa5Nb
        6qpZuwbkZBENaIhvAGcK+kH6qdr0OXGFbq9/rQyjgAUrn35G4ZSV8yWFbreCHve0SJa8VsuNQS4
        84KFdjAcjIE0drSfe
X-Received: by 2002:a17:906:d8a2:: with SMTP id qc2mr13450500ejb.10.1570209765160;
        Fri, 04 Oct 2019 10:22:45 -0700 (PDT)
X-Google-Smtp-Source: APXvYqxT4PXxUWEzxWHr405Rw0jH3MkMXLg4YbYxrh9RgZbNB5MDRapmcdQaxLwUt6uoBfjiShjHpQ==
X-Received: by 2002:a17:906:d8a2:: with SMTP id qc2mr13450486ejb.10.1570209764953;
        Fri, 04 Oct 2019 10:22:44 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk (borgediget.toke.dk. [85.204.121.218])
        by smtp.gmail.com with ESMTPSA id v8sm1249312edl.74.2019.10.04.10.22.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2019 10:22:44 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id BE1F3180640; Fri,  4 Oct 2019 19:22:43 +0200 (CEST)
Subject: [PATCH bpf-next v2 3/5] tools: Update bpf.h header for program chain
 calls
From:   =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Marek Majkowski <marek@cloudflare.com>,
        Lorenz Bauer <lmb@cloudflare.com>,
        Alan Maguire <alan.maguire@oracle.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Date:   Fri, 04 Oct 2019 19:22:43 +0200
Message-ID: <157020976367.1824887.285329296145540311.stgit@alrua-x1>
In-Reply-To: <157020976030.1824887.7191033447861395957.stgit@alrua-x1>
References: <157020976030.1824887.7191033447861395957.stgit@alrua-x1>
User-Agent: StGit/0.19-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Toke Høiland-Jørgensen <toke@redhat.com>

This updates the bpf.h UAPI header in tools/ to add the bpf chain
call-related definitions.

Signed-off-by: Toke Høiland-Jørgensen <toke@redhat.com>
---
 tools/include/uapi/linux/bpf.h |   16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 77c6be96d676..b5dbc49fa1a3 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -107,6 +107,9 @@ enum bpf_cmd {
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
 	BPF_BTF_GET_NEXT_ID,
+	BPF_PROG_CHAIN_ADD,
+	BPF_PROG_CHAIN_DEL,
+	BPF_PROG_CHAIN_GET,
 };
 
 enum bpf_map_type {
@@ -288,6 +291,12 @@ enum bpf_attach_type {
 /* The verifier internal test flag. Behavior is undefined */
 #define BPF_F_TEST_STATE_FREQ	(1U << 3)
 
+/* Whether to enable chain call injection at program return. If set, the
+ * verifier will rewrite program returns to check for and jump to chain call
+ * programs configured with the BPF_PROG_CHAIN_* commands to the bpf syscall.
+ */
+#define BPF_F_INJECT_CHAIN_CALLS	(1U << 4)
+
 /* When BPF ldimm64's insn[0].src_reg != 0 then this can have
  * two extensions:
  *
@@ -510,6 +519,13 @@ union bpf_attr {
 		__u64		probe_offset;	/* output: probe_offset */
 		__u64		probe_addr;	/* output: probe_addr */
 	} task_fd_query;
+
+	struct { /* anonymous struct used by BPF_PROG_CHAIN_* commands */
+		__u32		prev_prog_fd;
+		__u32		next_prog_fd;
+		__u32		retcode;
+		__u32		next_prog_id;   /* output: prog_id */
+	};
 } __attribute__((aligned(8)));
 
 /* The description below is an attempt at providing documentation to eBPF

