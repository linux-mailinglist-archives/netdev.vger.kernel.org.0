Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 720E87345E
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 18:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728481AbfGXQ6g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 12:58:36 -0400
Received: from mail-pf1-f202.google.com ([209.85.210.202]:36094 "EHLO
        mail-pf1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387621AbfGXQ6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 12:58:34 -0400
Received: by mail-pf1-f202.google.com with SMTP id e20so28952504pfd.3
        for <netdev@vger.kernel.org>; Wed, 24 Jul 2019 09:58:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=HR+i5k9D3xN0HWRoWeihUWIzPrhjF/a9nve8ODtPhD0=;
        b=Sqj8KFoPc7hD63y6Ke6KRZCuC892AJWxBiBjXl9lm7e3VHw7v9+2CPKEKkIIGVduBM
         +RBU0OzJVulCwCav3ICiM0TTFqCVjHo32X+Gfur0MmkdF5f2GDgfrmT1WIagFWh/eLk/
         TfTRNQzkoI/Rmz8NQgzm6MtkfTWjehevn3uHkGkt71GlOorwiX63MNuUwmdGSK1TELYZ
         yZsjvh/nyXpdbATi79pq4jnwWfIB3+8JKgOd7lSJg16RSNjIDMyAHd2Wr/9b9d6aEVNe
         gVfwYSSWh8TBXcNRNU+IBM8ZgPWDd2ZdkP3MJYeVX+vkgj6Oq+OZ2br+9Ddj79zT7PRs
         HCuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=HR+i5k9D3xN0HWRoWeihUWIzPrhjF/a9nve8ODtPhD0=;
        b=ikFTtID3OJbNGVoiXsBRC0sM3dlw3ySf73qj8HWuRBOPVLwgnTQtVGiAIN4kbKAnHt
         DGAKIyoIoV1k5cheQccPsQ6LqE2pF4bz84Mz3jRU3SkTnIpy3wLyyevi//UIa9dv+TzG
         IRdfvS4vV6RmL02j8IaxjBsZEHhwTh2Mmlllrd3LeHYHfady0PBIjS5snaHHqTy3wAt4
         +gNe3BYIt1GSryxRkLjHVpdFxusANkRL3NwovKfXjAEo8uTFJ5trIw40vyD82fvvuvwx
         jp9XUmf6ePyFUxb1NqXxoSB0+kK19Pv3+ZoIZhR/y5q+lakdhjmq/10h6uqvXxHhnnQE
         9SjA==
X-Gm-Message-State: APjAAAXt2VQS7AsJaejovNIdytuaadSM/j5vWrZiW8aNfeDvY32lWFDp
        3h5ZaOn1m+c4Lj/zI3gmVqYPJNVBS8uI
X-Google-Smtp-Source: APXvYqzu5AQ+mRmZp518hex6IDEIzKbEvvBp9hLrjMi74On/5T8AvUdwkgxhlgx4t6PpiuEpqSWlNkQJPxJ2
X-Received: by 2002:a63:3009:: with SMTP id w9mr7663984pgw.260.1563987513746;
 Wed, 24 Jul 2019 09:58:33 -0700 (PDT)
Date:   Wed, 24 Jul 2019 09:58:00 -0700
In-Reply-To: <20190724165803.87470-1-brianvv@google.com>
Message-Id: <20190724165803.87470-4-brianvv@google.com>
Mime-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com>
X-Mailer: git-send-email 2.22.0.657.g960e92d24f-goog
Subject: [PATCH bpf-next 3/6] bpf: keep bpf.h in sync with tools/
From:   Brian Vazquez <brianvv@google.com>
To:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>
Cc:     Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Brian Vazquez <brianvv@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adds bpf_attr.dump structure to libbpf.

Suggested-by: Stanislav Fomichev <sdf@google.com>
Signed-off-by: Brian Vazquez <brianvv@google.com>
---
 tools/include/uapi/linux/bpf.h | 9 +++++++++
 tools/lib/bpf/libbpf.map       | 2 ++
 2 files changed, 11 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4e455018da65f..e127f16e4e932 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -106,6 +106,7 @@ enum bpf_cmd {
 	BPF_TASK_FD_QUERY,
 	BPF_MAP_LOOKUP_AND_DELETE_ELEM,
 	BPF_MAP_FREEZE,
+	BPF_MAP_DUMP,
 };
 
 enum bpf_map_type {
@@ -388,6 +389,14 @@ union bpf_attr {
 		__u64		flags;
 	};
 
+	struct { /* struct used by BPF_MAP_DUMP command */
+		__aligned_u64	prev_key;
+		__aligned_u64	buf;
+		__aligned_u64	buf_len; /* input/output: len of buf */
+		__u64		flags;
+		__u32		map_fd;
+	} dump;
+
 	struct { /* anonymous struct used by BPF_PROG_LOAD command */
 		__u32		prog_type;	/* one of enum bpf_prog_type */
 		__u32		insn_cnt;
diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
index f9d316e873d8d..cac3723d5c45c 100644
--- a/tools/lib/bpf/libbpf.map
+++ b/tools/lib/bpf/libbpf.map
@@ -183,4 +183,6 @@ LIBBPF_0.0.4 {
 		perf_buffer__new;
 		perf_buffer__new_raw;
 		perf_buffer__poll;
+		bpf_map_dump;
+		bpf_map_dump_flags;
 } LIBBPF_0.0.3;
-- 
2.22.0.657.g960e92d24f-goog

