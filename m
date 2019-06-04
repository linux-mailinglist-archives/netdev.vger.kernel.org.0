Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C6B76351F0
	for <lists+netdev@lfdr.de>; Tue,  4 Jun 2019 23:35:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbfFDVff (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jun 2019 17:35:35 -0400
Received: from mail-qt1-f201.google.com ([209.85.160.201]:44364 "EHLO
        mail-qt1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbfFDVfe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jun 2019 17:35:34 -0400
Received: by mail-qt1-f201.google.com with SMTP id p15so11837329qti.11
        for <netdev@vger.kernel.org>; Tue, 04 Jun 2019 14:35:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=XK0eih1n6zYzYlyLg0LkT0iv/L7hits8mcx9itm13cQ=;
        b=R9O5zBUvPhnbTvR6k9U2ClcE1X9YCIA7WmSNH9lNG4YnxKieTWBciH97ZfhBeCXVw3
         lnsTDtiA3kUs5VHXDlymMHhssxkc2HsEqUUiuej758yvSf2mI+i7TCPzii9FOLbooLvE
         qsWdyk119DwvLINnmppbjy/XL8+cr63s9UuQvG/3dE9QFBRsTj2b0kMQWRY32kbau8Q2
         4prJf5shnF+yDXRMieEuZEmZq93H2E42FoPb/QnZm5lAcACLCQI6cGZ+oZQv6eJI8m1M
         vai/hNaUcQbn29/v9AmV7aOdnMAn9OXMiaSF4Rt4z5W1qhzmcmFOC+pk84f2iRXAt6df
         ZJRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=XK0eih1n6zYzYlyLg0LkT0iv/L7hits8mcx9itm13cQ=;
        b=Ci4UX5W32LHPrEtvA/LnbmlLeoD/5YmiaTBXYQ4aEZ5x3eRz/NArOt6OzaxSzLI0UX
         q/dJrNex4AQioHhjZuyV5vf2V5tzwefq+Jaiptoxz1qoeMVyfwkpgnx4ni/b8Qbe9JeX
         z9W6IWnx7mnOqX0uZGliBgYgeYyz74rG053necHGJowA8+IOinRt6bsZwr5vNIqoNdt+
         LdMMp5xgX/dqWUoVxAfbmm/K6hDWZX2W3CPy/jDgohRB7B4tnraFpRAFyf/OV3FuAWVb
         55yl0ffdF0Np1ix0e11eALSIl4JC+epJBMQ+x5eGhwWqlnyILKjTjWq0jgUIYp5BpNpW
         y6Ew==
X-Gm-Message-State: APjAAAWaWI8bSSglnRfC4EiYsJJmr0S85YqR/VjHZaOIQx2YjNNMWf7G
        td4q5vhgi89QYQqk/JMtj5hmr7fhYlq4QkX04Z4zboIqmMXjhPsGg133A/dCElSKXhF+0UQLfvu
        vOutQLGqDdUYQsjwxHOtGYbLHO1maAzMR/gYkkO2xtTwCsUXr8QWxsg==
X-Google-Smtp-Source: APXvYqwAP1eOiV84kmjXmknhgYAj+J3DxfnDTGVLakiGp3ra337zgH1aA7jHJ5W/RNwCGpd4BYznyRU=
X-Received: by 2002:a37:b3c2:: with SMTP id c185mr29138123qkf.44.1559684134006;
 Tue, 04 Jun 2019 14:35:34 -0700 (PDT)
Date:   Tue,  4 Jun 2019 14:35:19 -0700
In-Reply-To: <20190604213524.76347-1-sdf@google.com>
Message-Id: <20190604213524.76347-3-sdf@google.com>
Mime-Version: 1.0
References: <20190604213524.76347-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc1.311.g5d7573a151-goog
Subject: [PATCH bpf-next 2/7] bpf: sync bpf.h to tools/
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export new prog type and hook points to the libbpf.

Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 7c6aef253173..b6c3891241ef 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_FLOW_DISSECTOR,
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 };
 
 enum bpf_attach_type {
@@ -192,6 +193,8 @@ enum bpf_attach_type {
 	BPF_LIRC_MODE2,
 	BPF_FLOW_DISSECTOR,
 	BPF_CGROUP_SYSCTL,
+	BPF_CGROUP_GETSOCKOPT,
+	BPF_CGROUP_SETSOCKOPT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -2815,7 +2818,8 @@ union bpf_attr {
 	FN(strtoul),			\
 	FN(sk_storage_get),		\
 	FN(sk_storage_delete),		\
-	FN(send_signal),
+	FN(send_signal),		\
+	FN(sockopt_handled),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
@@ -3533,4 +3537,15 @@ struct bpf_sysctl {
 				 */
 };
 
+struct bpf_sockopt {
+	__bpf_md_ptr(struct bpf_sock *, sk);
+
+	__s32	level;
+	__s32	optname;
+
+	__u32	optlen;
+	__u32	optval;
+	__u32	optval_end;
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.22.0.rc1.311.g5d7573a151-goog

