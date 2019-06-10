Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 760603BE12
	for <lists+netdev@lfdr.de>; Mon, 10 Jun 2019 23:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389901AbfFJVIj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jun 2019 17:08:39 -0400
Received: from mail-qk1-f201.google.com ([209.85.222.201]:42333 "EHLO
        mail-qk1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389884AbfFJVIi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jun 2019 17:08:38 -0400
Received: by mail-qk1-f201.google.com with SMTP id l16so9179788qkk.9
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 14:08:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rzQAcgfGN5K6LU4CelXji685pxXu/comsqrtS35LUIQ=;
        b=sVFOiHnAvl3NuPm1L85N7bRxgzUSn57kPTZX+v+JY1Lxs29FhzNWubIu0jJpVc3m7G
         Yl1ds7DUo5AZM1TKuPZ9s/B5lNSMUChsQWJc35u9bt5qKzptQipTovSrfm8hDRWsHJfC
         G0/fZRC9SLHSr2zkg3mtocv/fFmjQqxgkFMmGwxulY3+k0hWO6bXLWhFCpSkuh5I+wGX
         IJkYf54Uv73iVOW1j16jq7Blo+ImAEjRhqbCYL2R4ulDpqobpK+BS9ZN9S0mFIKaoSXg
         IVbrjcrhvCyyiKUQgJfOv1cqm/2SrOem45AJAyjrUuPhlIQSqbLiFqkbQLwIZ0STLn+F
         obng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rzQAcgfGN5K6LU4CelXji685pxXu/comsqrtS35LUIQ=;
        b=rD4yFqBejx5LdqHDWa5jspnMK4ou0VRiUYTIE21kNX8lbf4heoY5nQGpBAkvy7RcHt
         Ko1ZXPLaMOjPgTscYipdXqohPTVt+ak3gIyI5FnFfpe282VhzQ7uzhrcp7W/cJAamTC1
         GJI+LSYIYGMeOqu+pwXXdrBYtZ6VWm/dgst267wJKZoauiUibJYROzfZlBqtqf7O35sJ
         A1JIfhUFiILGhNAvV/h53mbHW/8kOkzjji/DV/+QZevEsX44tPhR1KkPs4hS2r6n66tt
         p1WdP/JlurOSYfga2UQx0FSMOIbGRQs9rtwzZI38AKmvfCtMFoIQ7fGRobrIq8Jsz6IZ
         gAUA==
X-Gm-Message-State: APjAAAWylVE7JNXaBRTpLIPPBZQxwDETZ96LoPqcKweQurzONVw/SLVW
        j6SZ2xU5mEaafCLLRKWRcYy77xXbSCRAB+/9B1zjuSz/STwachIjao1GMLTEXiU7BH8k5gE5HYt
        NVeoYH7VRNWLwdFX6HzLJSAt2271ieBG8lc3Ush0SOTIUiwQcJgpyQw==
X-Google-Smtp-Source: APXvYqxcLLAf2+6LYdol0+arO2v11ooaEH0UgCTVnMuAJ3W5chtgfqv74SCKhJMkswudUdWIaK09sC0=
X-Received: by 2002:a0c:fde5:: with SMTP id m5mr38293403qvu.192.1560200917576;
 Mon, 10 Jun 2019 14:08:37 -0700 (PDT)
Date:   Mon, 10 Jun 2019 14:08:24 -0700
In-Reply-To: <20190610210830.105694-1-sdf@google.com>
Message-Id: <20190610210830.105694-3-sdf@google.com>
Mime-Version: 1.0
References: <20190610210830.105694-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.rc2.383.gf4fbbf30c2-goog
Subject: [PATCH bpf-next v5 2/8] bpf: sync bpf.h to tools/
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

