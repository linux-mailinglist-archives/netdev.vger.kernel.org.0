Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EFA54BF22
	for <lists+netdev@lfdr.de>; Wed, 19 Jun 2019 19:00:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727244AbfFSRAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Jun 2019 13:00:06 -0400
Received: from mail-ua1-f73.google.com ([209.85.222.73]:51821 "EHLO
        mail-ua1-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726628AbfFSRAF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Jun 2019 13:00:05 -0400
Received: by mail-ua1-f73.google.com with SMTP id d5so3221uaj.18
        for <netdev@vger.kernel.org>; Wed, 19 Jun 2019 10:00:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tMqDNa0Osucsd24+UpX69LDy20u5Vx6rND//6ISv2cs=;
        b=hkfN2lMaVsLGtl79NR3NFSjucZrR+tSX5bBdOuqd1n9KBKFI+uxqyfVwEbAVtoiW4/
         MyRi7uaIqfRiYO5fAoIYp4BBynENCKjNGyYpQ14N4ICDiQxY0TXgY13lnFxCwy+kcB8L
         grNtq1h6pxsoYfedo3IzAD5CAlfekUE39NGtJLFfr0uZWn0M47lOnlXtn34bAj3SknyN
         /uxmnoIQJdIFv7ENV/uOPdl73i697b8L8J56BE9pMVOnrQ2pr3NCZXVOF/FOMVB/2Pxt
         4H5ZX9ZB6r5JsY0WRmYOAENj7WWUVh6Q2F2YFZXcRtLb2dT1OqVDp4gRsv2ZR5Ij+0EW
         Nl1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tMqDNa0Osucsd24+UpX69LDy20u5Vx6rND//6ISv2cs=;
        b=TSn8XxQXuuIeZttwAgUutTIJlj3Ppkusrs7URHAU7YrU+bmQIO6X/Hq8ygsq6VQfzw
         QH3x6fvPXMI+dWCu+ZfT9G+iGx5xSKN8yKEQg4aWd7FftGaTMVfiBNiWEto/3HtXZrus
         MRscGHA9jZsPb3g0IwMXIstYpJ2ZkfjdlA+4tinyzGvYdfDbkohOfuDhHdEBj3XaqR74
         VXqx36qSZQlKyW0lAcNeCjOrwpogzG063Z6s96N0zZNMf9/6tBSceK9vKUI8vN14CzTt
         ttm0cNgFMuoFOimJ8+N09nrD+YJKZ8z2sYh1lOThTBdQCiLP4oftkj2RGneN0ZLYInZa
         MOeg==
X-Gm-Message-State: APjAAAWef1Q0MQrXxoDJYDQK1lQSLTmkKacpcEMMc2qnt7PMkg7tSepJ
        MVL+K4djC7PgwDxR7Til/R+F8rW1lFm6RMufJPXPzydMPXr57N9RpKTe2KCvVUeAKDWiSvhMGdx
        2aEBgZFDBk5BcZcOy/ce7H2PUcC7EixFCARN6mbhbxnkkUwk7EHDwBA==
X-Google-Smtp-Source: APXvYqyyJ+czJr379RRD7qo0g9YLvn0zETfLBT05dn0aSYTFcp+Gw3jYJILm+ejQ8Vuoim33PwVvsE4=
X-Received: by 2002:a67:f68b:: with SMTP id n11mr49976426vso.160.1560963604773;
 Wed, 19 Jun 2019 10:00:04 -0700 (PDT)
Date:   Wed, 19 Jun 2019 09:59:50 -0700
In-Reply-To: <20190619165957.235580-1-sdf@google.com>
Message-Id: <20190619165957.235580-3-sdf@google.com>
Mime-Version: 1.0
References: <20190619165957.235580-1-sdf@google.com>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
Subject: [PATCH bpf-next v7 2/9] bpf: sync bpf.h to tools/
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
index d0a23476f887..67059b4c663f 100644
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
 
@@ -3539,4 +3542,15 @@ struct bpf_sysctl {
 				 */
 };
 
+struct bpf_sockopt {
+	__bpf_md_ptr(struct bpf_sock *, sk);
+	__bpf_md_ptr(void *, optval);
+	__bpf_md_ptr(void *, optval_end);
+
+	__s32	level;
+	__s32	optname;
+	__u32	optlen;
+	__s32	retval;
+};
+
 #endif /* _UAPI__LINUX_BPF_H__ */
-- 
2.22.0.410.gd8fdbe21b5-goog

