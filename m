Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 525C187F10
	for <lists+netdev@lfdr.de>; Fri,  9 Aug 2019 18:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437081AbfHIQKv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Aug 2019 12:10:51 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:45239 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2437078AbfHIQKt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Aug 2019 12:10:49 -0400
Received: by mail-pl1-f201.google.com with SMTP id y9so57705239plp.12
        for <netdev@vger.kernel.org>; Fri, 09 Aug 2019 09:10:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zozR5939lKPKijWCEA8Kq+6lgaUz4pI7IwG97p6anoI=;
        b=uDd+3pS3kdOwCNXjCzjVY7gjWOgZu4xS+1w3J1HbUrh288Gou6qSIPKAEEC8hbTGWu
         gNDvtxLJ4d58G0fd8ok/tuYSvirYjXJ8kfgoynABAad02dAuZ5sd2YVZlvi4GwzTxGFf
         tkAMVCw1NDgosiDJO0si20tx8W0yK3rTpx4wEOzd2xkNOH4FZ9vT7ezcK8M9rBmnvu3Z
         hFVxzq9Op2W9CKKyd6T1IiPOfwgeOQ+4PtZ+mZ/JccWt63n67xLly4k3TEuoGDCvzp8O
         xjlgWuVi0rg2lVEH5nNYMOjJ/m8WrlBrRNne3yzpc1EizYVeh7MW6ObW1vgvwcImzRYD
         2iFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zozR5939lKPKijWCEA8Kq+6lgaUz4pI7IwG97p6anoI=;
        b=r7Lu+lDF6+cfWeuZ6/DIHw9pA6exq17pvAzKqOSiUPvx+r7vjr2EjVrIiEiIQTwAYj
         N64D3XDB1zIdtLJBAlXlSRLr/Z78M4qG68w/YFwkBYV5RWU1Y8/V47RwIKZdzaFlxOqN
         HGISX4wbdoEI9rUeXj8UcFDL9xCaEOxgGHgyv0EAENfMB+BOPpI6UrW92nqGeob1CiiO
         cgJWD8jzaGB/EWgHSHr+746mIN97Uu4Og1m/rlo9PscYKb14YMb6yzXpknyuK9j7LbKl
         FO8wpTRALY5tTY8S6NX4lrgIc1+by3VUjiN+Q57ddvPtk4HnklprFDsGl/AmkXB1W3eV
         C7gg==
X-Gm-Message-State: APjAAAXKULmGWyPsVsBcQJZlEir+deJeLWPFexl1wlP7kbMKXPq7bYWh
        YbkwzGkNWTLwcAM1s/Rr6f45ig8P+n5cSjO0Rn360JrriK2aBXjclsTRQcHBImWOMsqyDV//WRs
        3PLrHyFim3bJQk49uH1KQYDxqRAWsEwPvN9rZT7ORgd2k5q1TGwKM2A==
X-Google-Smtp-Source: APXvYqzG/D6qCm8/9ijnTCNRrJdNiqTvmg+mzM6tGiT0QbTrJaGHQMQo6O3oYj1P1acud/IKZu8udpo=
X-Received: by 2002:a63:3c5:: with SMTP id 188mr17701789pgd.394.1565367048184;
 Fri, 09 Aug 2019 09:10:48 -0700 (PDT)
Date:   Fri,  9 Aug 2019 09:10:37 -0700
In-Reply-To: <20190809161038.186678-1-sdf@google.com>
Message-Id: <20190809161038.186678-4-sdf@google.com>
Mime-Version: 1.0
References: <20190809161038.186678-1-sdf@google.com>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
Subject: [PATCH bpf-next v2 3/4] bpf: sync bpf.h to tools/
From:   Stanislav Fomichev <sdf@google.com>
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     davem@davemloft.net, ast@kernel.org, daniel@iogearbox.net,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>, Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sync new sk storage clone flag.

Cc: Martin KaFai Lau <kafai@fb.com>
Cc: Yonghong Song <yhs@fb.com>
Acked-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Stanislav Fomichev <sdf@google.com>
---
 tools/include/uapi/linux/bpf.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 4393bd4b2419..0ef594ac3899 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -337,6 +337,9 @@ enum bpf_attach_type {
 #define BPF_F_RDONLY_PROG	(1U << 7)
 #define BPF_F_WRONLY_PROG	(1U << 8)
 
+/* Clone map from listener for newly accepted socket */
+#define BPF_F_CLONE		(1U << 9)
+
 /* flags for BPF_PROG_QUERY */
 #define BPF_F_QUERY_EFFECTIVE	(1U << 0)
 
-- 
2.23.0.rc1.153.gdeed80330f-goog

