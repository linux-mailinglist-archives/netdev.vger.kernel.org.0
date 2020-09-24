Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0272779D3
	for <lists+netdev@lfdr.de>; Thu, 24 Sep 2020 21:59:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgIXT67 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 15:58:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725208AbgIXT67 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 15:58:59 -0400
Received: from mail-oi1-x244.google.com (mail-oi1-x244.google.com [IPv6:2607:f8b0:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36E90C0613CE
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 12:58:59 -0700 (PDT)
Received: by mail-oi1-x244.google.com with SMTP id x69so284121oia.8
        for <netdev@vger.kernel.org>; Thu, 24 Sep 2020 12:58:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:user-agent:mime-version
         :content-transfer-encoding;
        bh=auKHoKzZ6gvUpbw5zNIOBjgotPCVLgl0Ts4Fx/355FU=;
        b=t2Ctx0ZJZ5xCpHO+yNzy/Vwyf1S5zfKyIJh6Ztu2LDvXnrgN5GBsUe9X+WZoRInjfu
         s2gRf0X0yiJ/K91qkU22Cf+CIDcbCn+5u5gC93wPmjCAYcx3qSI/cKAE0QTrQpvV+1Fi
         VK18bQRh/WeBCzr8CU6s2t2o/M7bpZLbNnUeRZ5wSE48/wcfHbd7m65sgKFWFRJeM5ya
         0lbQvLpfjputVoRykASuaZPuvMRK+naDeySYTyPQdsNqTNSNvqeFBwXuHDZWYcxN05/y
         Lx2HABDfeyDWG9h4dlFiguupeCnda0Z0Fg2WChx/z+Vmoh2pUR1FC6qFrfbOhws1hNwj
         cwVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:user-agent
         :mime-version:content-transfer-encoding;
        bh=auKHoKzZ6gvUpbw5zNIOBjgotPCVLgl0Ts4Fx/355FU=;
        b=N0WvqAugQaCL5zBkpGTWzkq4vGb7bBf+B5Ikey2t8F9h/l+NszGorgsRZl8V3YUML8
         HNDvlH7gDBhHsIco3iAv1gJGdnMkWS8vZ9hDYXkOa0ry34xnRITPW83PdnZsJkENG0i1
         p9Xt82djlw/36KFqu2W8AaIPm0UXXTw8GBsBphvTJEgSPFbl/BoVoALBj0pyPr7M5AUp
         f2JDdp7/yefSAbpVfHN/B3XgND6q4ygmcBdcP8nidbmCt710PKAunigumK/kqBNb4sDp
         YBlSUxCzNKi07nG8nA4OECM/fXAWl1yj5E8UjAjz4iyVtREoTSfw02SGJMYxAf0+jdUB
         x0wg==
X-Gm-Message-State: AOAM531H5G4W7BXc7guAQqSpWlkPu+0je+GKrldj1sZ/3Y/qG+hCXE3S
        NyqMf4/IAnA7BtBvHJ8zZck=
X-Google-Smtp-Source: ABdhPJz8j1QU0TYkAbDnGQUWi1wkT6QRWz4O0rlWaABK/akGpJGSAOjDEv86YFuy3oVFHU6l3gD1ig==
X-Received: by 2002:aca:2106:: with SMTP id 6mr273707oiz.115.1600977538641;
        Thu, 24 Sep 2020 12:58:58 -0700 (PDT)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id o108sm79489ota.25.2020.09.24.12.58.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2020 12:58:58 -0700 (PDT)
Subject: [bpf-next PATCH] bpf: Add comment to document BTF type
 PTR_TO_BTF_ID_OR_NULL
From:   John Fastabend <john.fastabend@gmail.com>
To:     yhs@fb.com, andriin@fb.com, ast@kernel.org, daniel@iogearbox.net
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        lmb@cloudflare.com
Date:   Thu, 24 Sep 2020 12:58:40 -0700
Message-ID: <160097751992.13115.10446086919232254389.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The meaning of PTR_TO_BTF_ID_OR_NULL differs slightly from other types
denoted with the *_OR_NULL type. For example the types PTR_TO_SOCKET
and PTR_TO_SOCKET_OR_NULL can be used for branch analysis because the
type PTR_TO_SOCKET is guaranteed to _not_ have a null value.

In contrast PTR_TO_BTF_ID and BTF_TO_BTF_ID_OR_NULL have slightly
different meanings. A PTR_TO_BTF_TO_ID may be a pointer to NULL value,
but it is safe to read this pointer in the program context because
the program context will handle any faults. The fallout is for
PTR_TO_BTF_ID the verifier can assume reads are safe, but can not
use the type in branch analysis. Additionally, authors need to be
extra careful when passing PTR_TO_BTF_ID into helpers. In general
helpers consuming type PTR_TO_BTF_ID will need to assume it may
be null.

Seeing the above is not obvious to readers without the back knowledge
lets add a comment in the type definition.

Editorial comment, as networking and tracing programs get closer
and more tightly merged we may need to consider a new type that we
can ensure is non-null for branch analysis and also passing into
helpers.

Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 include/linux/bpf.h |   18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/include/linux/bpf.h b/include/linux/bpf.h
index fc5c901c7542..dd765ba1c730 100644
--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -382,8 +382,22 @@ enum bpf_reg_type {
 	PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
 	PTR_TO_TP_BUFFER,	 /* reg points to a writable raw tp's buffer */
 	PTR_TO_XDP_SOCK,	 /* reg points to struct xdp_sock */
-	PTR_TO_BTF_ID,		 /* reg points to kernel struct */
-	PTR_TO_BTF_ID_OR_NULL,	 /* reg points to kernel struct or NULL */
+	/* PTR_TO_BTF_ID points to a kernel struct that does not need
+	 * to be null checked by the BPF program. This does not imply the
+	 * pointer is _not_ null and in practice this can easily be a null
+	 * pointer when reading pointer chains. The assumption is program
+	 * context will handle null pointer dereference typically via fault
+	 * handling. The verifier must keep this in mind and can make no
+	 * assumptions about null or non-null when doing branch analysis.
+	 * Further, when passed into helpers the helpers can not, without
+	 * additional context, assume the value is non-null.
+	 */
+	PTR_TO_BTF_ID,
+	/* PTR_TO_BTF_ID_OR_NULL points to a kernel struct that has not
+	 * been checked for null. Used primarily to inform the verifier
+	 * an explicit null check is required for this struct.
+	 */
+	PTR_TO_BTF_ID_OR_NULL,
 	PTR_TO_MEM,		 /* reg points to valid memory region */
 	PTR_TO_MEM_OR_NULL,	 /* reg points to valid memory region or NULL */
 	PTR_TO_RDONLY_BUF,	 /* reg points to a readonly buffer */

