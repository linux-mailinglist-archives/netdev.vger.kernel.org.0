Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B16883B989
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 18:34:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbfFJQea (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 12:34:30 -0400
Received: from mail-pl1-f202.google.com ([209.85.214.202]:36498 "EHLO
        mail-pl1-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728200AbfFJQea (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 12:34:30 -0400
Received: by mail-pl1-f202.google.com with SMTP id a5so6052072pla.3
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 09:34:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rzQAcgfGN5K6LU4CelXji685pxXu/comsqrtS35LUIQ=;
        b=GbJtMFB5zQ02SKMkJf3EeDILDaUmtvRgmgM/J9VzEv1HLmAo3Ag50o384ggtnLJPOi
         f3K3f6qlTFgq0ff+ABXERnsH5rRt+zMN5WeIZ5OPK2/KytGzbU0XLXkK2zgIOGesFds7
         VNM3GRSRWgOWaEHEMQEdIPIBfmTO48Xk/RTNVPZjDE1sYNsyzJbk2i+DGGGXkn2yhNc0
         BkBr0APNER88c/cs17oLMNin0KQgwYc+vjAU3cKGcFNdN/tLG4wOQBjRmJm/X4IziUqY
         30uAmxOQHTlwf3ewA3ZVOznuKxd2ie0sRiUj8WKGssEkw8mO8Guz/br3Y2RAuwg38GA/
         xYUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rzQAcgfGN5K6LU4CelXji685pxXu/comsqrtS35LUIQ=;
        b=AkXHzHjikyO71eQr2JFquAUadB/85LWEDKqNa7rxADOD7JBfm7OIt7NaPw/DV3azYk
         rKas+7HQQT/fnriAXzSJ0wDDIVRbL4dFLiJ/t0bxupE7QRereSexRogPk7gCy86yWQDZ
         KGG7+ZgQwWrz3TAXL7K9hcypXqXZFSW1ajLzMNH4LmeDcbpddsJx75T/TcKO8u8cKtav
         6YXfGEowA891hcg4O+Zm4FmU94QYZLkJ3G2jQFgQ87ZNikbGor5P738AbOxshUAyBkBf
         ZkE1+lWBxw6T9RC/8S/hGVFQkhXQyETW+WnGf42HJRBvfjy5d9N0MZxc8X2uyjufo+He
         550w==
X-Gm-Message-State: APjAAAUBcCcQTstNuh/vApQUX9t4pPwphFGduYSD4BpjkybCCkS8Nmvy
        jmQsAoHlisswsuIouEpqzWahaxPwbtpeciC2XMm7KiWsT/nMiIHHhigH8O/Z9ZUJ5ozmdnh2uGO
        MmZfFvGaacFY1OkG3ZX8Aq3fxl4ttkhHeRUVhgKGlUWWgAd0DtPc5Bw==
X-Google-Smtp-Source: APXvYqyrVHjxMYQH10x5Cq3347EgblZ1moc+UbMeTkGUvsDhfcsR4z+HIk1WGDH+4TXcmy9Fx4aHbyA=
X-Received: by 2002:a65:408d:: with SMTP id t13mr16073782pgp.373.1560184468882;
 Mon, 10 Jun 2019 09:34:28 -0700 (PDT)
Date:   Mon, 10 Jun 2019 09:34:15 -0700
In-Reply-To: <20190610163421.208126-1-sdf@google.com>
Message-Id: <20190610163421.208126-3-sdf@google.com>
Mime-Version: 1.0
References: <20190610163421.208126-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next v4 2/8] bpf: sync bpf.h to tools/
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
index 7c6aef253173..174136aa6906 100644
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
 
@@ -3533,4 +3536,15 @@ struct bpf_sysctl {
 				 */
 };
 
+struct bpf_sockopt {
+	__bpf_md_ptr(struct bpf_sock *, sk);
+	__bpf_md_ptr(void *, optval);
+	__bpf_md_ptr(void *, optval_end);
+
+	__s32	level;
+	__s32	optname;
+
+	__u32	optlen;
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.22.0.rc2.383.gf4fbbf30c2-goog

