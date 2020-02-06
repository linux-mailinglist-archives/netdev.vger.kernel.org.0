Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7D78F154060
	for <lists+netdev@lfdr.de>; Thu,  6 Feb 2020 09:35:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728063AbgBFIfo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Feb 2020 03:35:44 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:39197 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728035AbgBFIfn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Feb 2020 03:35:43 -0500
Received: by mail-pl1-f193.google.com with SMTP id g6so2057511plp.6;
        Thu, 06 Feb 2020 00:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=8JdIDcaQJOI9SGybGwtADbclwcv4lgbPyHvfU1VK7dI=;
        b=sAkVj2qSLOauMRAerrVxhmeIk172Jj7DQKvID1xPnoA4fb8C3zQZyaEaE2wl4ZBpr4
         ppIO7e1eWFkuBj5UGyGRkC8Ry06fKQOw3HPE+AiF1wrghI+nB1S/FbXt9q0/lamA49yL
         AG6uSAQTJWxkztwucfi84BB3rROY8nIhY2uQy6yQY0jQJUHCV+s++5KXttozrJ7ERPRZ
         T73xD0GhcXIN2Gvts9aZSczmhoZ1X0TNB2CZrIhtBLZwujAbSHytokuvx6Y6z9XusSRh
         cwiHIDkXmEjoFdQHAOhxhm8MqDZ7yfOPt0Ty3DOjqndF2wPLWQ7ZfPEYpPBsoPq/oqbI
         TvYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=8JdIDcaQJOI9SGybGwtADbclwcv4lgbPyHvfU1VK7dI=;
        b=iC2VWw3wF+kvjqHLfn50zQznJ0PD8YjPg/j2LNfFJbHZxl9T2G1+ZNbYw7C3qt+mnI
         010Zkr4i3pyT05Riwj59DiWJrPxXJV5yUWYD23xlWy8Z4SjC72AjBIHWp5vPIjV3fyh/
         ZHeEkMb6W0LuOtSOw1YJVmVHGLO3u2/eIWkKPyLqiJqtqHbBOhVWtzrAyi5wu1+jAUhg
         W1QvPRS+vKGq1NKik3gUiXcxnRX+LFSKDTD1SSgwjWA/2vAafiJbbLmXeya13/cJniqt
         rg5GVhZxrhwKzV31YjFwXQUG3I6zEwjS9+FDdJnV9RRHqjNo1DMKHlD0VhZVAthhe1jt
         Onaw==
X-Gm-Message-State: APjAAAUZuCk6BdBWfSEmDLD8xVTAF11YgmGeBeaOkGEYLj4Ot5Z33HqJ
        Q9MBE3sTRtoSsHQDowUOOlFsRnGKImvyCQ==
X-Google-Smtp-Source: APXvYqwFXqiefqXgeVl0QsFYZ4JnL1+CaMS7/D7VWCwFgj9+6+O5iq+l8BTONUyLLo+8bIx0EDtJTg==
X-Received: by 2002:a17:90b:3d0:: with SMTP id go16mr2907497pjb.75.1580978142307;
        Thu, 06 Feb 2020 00:35:42 -0800 (PST)
Received: from localhost.localdomain ([124.156.165.26])
        by smtp.gmail.com with ESMTPSA id 5sm2292070pfx.163.2020.02.06.00.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Feb 2020 00:35:41 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH bpf-next 2/2] bpf: Sync uapi bpf.h to tools/
Date:   Thu,  6 Feb 2020 16:35:15 +0800
Message-Id: <20200206083515.10334-3-forrest0579@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200206083515.10334-1-forrest0579@gmail.com>
References: <20200206083515.10334-1-forrest0579@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sync uapi bpf.h to tools/.

Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f1d74a2bd234..b15a55051232 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2892,6 +2892,11 @@ union bpf_attr {
  *		Obtain the 64bit jiffies
  *	Return
  *		The 64 bit jiffies
+ * u32 bpf_sock_ops_get_netns(struct bpf_sock_ops *bpf_socket)
+ *  Description
+ *      Obtain netns id of sock
+ * Return
+ *      The current netns inum
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3012,7 +3017,8 @@ union bpf_attr {
 	FN(probe_read_kernel_str),	\
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
-	FN(jiffies64),
+	FN(jiffies64),		\
+	FN(sock_ops_get_netns),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.17.1

