Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C57451882
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 18:24:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728544AbfFXQYl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 12:24:41 -0400
Received: from mail-pg1-f201.google.com ([209.85.215.201]:41131 "EHLO
        mail-pg1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728530AbfFXQYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Jun 2019 12:24:38 -0400
Received: by mail-pg1-f201.google.com with SMTP id x3so9690439pgp.8
        for <netdev@vger.kernel.org>; Mon, 24 Jun 2019 09:24:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=/Eylx6+0D7kZv88osTKqMtF2ZMgTLfN0SWLygaNlJGA=;
        b=ADkRBpw7WPHalNpxuvTx+zX2vZFUiZfVapzG0e7t2w15Y4SO5fxYFFymbSspOVWukN
         GTUN+hncXmcyOLYhrpdwJHla2wEytr1HARhtYl85CKltLRxJZgixQPkvmJ6jW2/Tk5OJ
         4cD9gOE/GGVh053dAzQvepHL48zUikrdivif0MFtvrdBquDNcJf7wk81N2LGh9irTRYn
         R89cMqbJBosaSmR5RT+SeSO2jzp0KZ8DW12Fbcwh2nSoEowqEWmMWfmEONL0ULpk8gzJ
         tqafKBIU0fvHq3ryv4eus6fKtlTk6MdWdsZ7EbFeNwHQHS7fQ++lkecqFHLZdF45nlAi
         YGLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=/Eylx6+0D7kZv88osTKqMtF2ZMgTLfN0SWLygaNlJGA=;
        b=OgNOdZ5GK3XIbkJ+3f4w7uWureMoRMlkCSVVJs8kNCtQxsFZQ4sv/ZmTSqOr48AIBG
         IHks111UbQN4TXKu7y3qQ4ifulYZ965+35kOdduXV/aEHcydmnDnhBZg7zs5mPJzoEP0
         /g9Ud/Puj+JFGzK24V1pvqI9fCiLIopKkEYQguHxHmS1m/wJ79Tu+uEwQinBGTRh1rso
         5nm7x8L5NaqKRyNtM+DcPdZuNSw3d03g7dmJYD42PCUJ7YplwJDe3nn7Rxk0TY8zu0xf
         lbC3WiNCOToZNMsJWPr5FjRyMGaXGX9l485tbPQb1sAPaF3x3X2jPAXstB0+7KvInskv
         cIOQ==
X-Gm-Message-State: APjAAAX+HZrTgLvpuGmUNnEZ8UGKzxVbpc8CTXLue6QkWO2kqa6qgy8F
        bfqKxNYaHr9q63OM4+JULm4FPOGTuvfli9eXfANZDiRGq13MKOlzpC1911I2BitbT6Z1DoV1tCw
        AhYsTMZwSsR4iSvWCIIn99aVNQLYEwQUPe3/fkrqS4B7vc+sgrgwUbA==
X-Google-Smtp-Source: APXvYqwnSHZ03+IkgEw9bNgDKmjPbLyI66eVm0yyYh5+8CpqEQ17DzbVh++wAMG+O0vev36A3i4vkqo=
X-Received: by 2002:a63:1450:: with SMTP id 16mr34928262pgu.52.1561393477518;
 Mon, 24 Jun 2019 09:24:37 -0700 (PDT)
Date:   Mon, 24 Jun 2019 09:24:22 -0700
In-Reply-To: <20190624162429.16367-1-sdf@google.com>
Message-Id: <20190624162429.16367-3-sdf@google.com>
Mime-Version: 1.0
References: <20190624162429.16367-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v8 2/9] bpf: sync bpf.h to tools/
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Export new prog type and hook points to the libbpf.

Cc: Martin Lau <kafai@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index b077507efa3f..a396b516a2b2 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -170,6 +170,7 @@ enum bpf_prog_type {
 	BPF_PROG_TYPE_FLOW_DISSECTOR,
 	BPF_PROG_TYPE_CGROUP_SYSCTL,
 	BPF_PROG_TYPE_RAW_TRACEPOINT_WRITABLE,
+	BPF_PROG_TYPE_CGROUP_SOCKOPT,
 };
 
 enum bpf_attach_type {
@@ -194,6 +195,8 @@ enum bpf_attach_type {
 	BPF_CGROUP_SYSCTL,
 	BPF_CGROUP_UDP4_RECVMSG,
 	BPF_CGROUP_UDP6_RECVMSG,
+	BPF_CGROUP_GETSOCKOPT,
+	BPF_CGROUP_SETSOCKOPT,
 	__MAX_BPF_ATTACH_TYPE
 };
 
@@ -3541,4 +3544,15 @@ struct bpf_sysctl {
 				 */
 };
 
+struct bpf_sockopt {
+	__bpf_md_ptr(struct bpf_sock *, sk);
+	__bpf_md_ptr(void *, optval);
+	__bpf_md_ptr(void *, optval_end);
+
+	__s32	level;
+	__s32	optname;
+	__s32	optlen;
+	__s32	retval;
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.22.0.410.gd8fdbe21b5-goog

