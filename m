Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D059165843
	for <lists+netdev@lfdr.de>; Thu, 20 Feb 2020 08:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726779AbgBTHLt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Feb 2020 02:11:49 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:39072 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725942AbgBTHLt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Feb 2020 02:11:49 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so1184080plp.6;
        Wed, 19 Feb 2020 23:11:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=jflsua1e1ee8c4j1MYBaabhNN/9jv7GwX7hINElKrCY=;
        b=dHAupF++tw8cYwpgmGg7HuSumt0vP7gRhIo922LaDoo/oj4jSQKVk+IeV+D1QLAUqR
         Ib3qmzOgVETyUCAu1XZLq5l3Pn4p20OmqXJmKkU1ee/IyhNwAhFZzCM0bx39mDyQCgiH
         EzYMBSQyEf3Eny6mDvOM9LtvnfaBJ4ixPCHHToLGLJLowfBaorGYE/JoxKS62ARk2g9X
         FbfXLly6FYy2knWG5CuGtv8WpTcjWH86IbH0OyQ+9feohmaN39jgA3E2diUdtpvA29AU
         Fm+c1qDdDFmDnCTnHOpKFOfkgIY7xeVRdKbeM9YigzplVyGtv/D38yq7D869ecT6ey4D
         1jpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jflsua1e1ee8c4j1MYBaabhNN/9jv7GwX7hINElKrCY=;
        b=i9vuTQ3p3n3LIHnf5PKSN1hMSl8j30zaSB1xmQ0J0ZwNIn0qU5wrtv5WTSET5w5zhe
         Hg075U74pUc0wl08BSew1q+GI4JrswmqpyiltDVMHarDy4P/GlUZp6dl1P/ILQtxhyUk
         RujeOZEj4Z4seQjVXUkFTWps2zaCqQaDbAEtof48o5TshB8jEAQUM9QuWq3ZlY947fr6
         eS4KVyunfoQZruXxlt881UX737+ySadpn0jUrEWQDx5TgtiqVhypiz8KSMajdYqMK2uG
         UmwO/9noYVchKL0LCYNKeTH7WUY+oOcv1zuy7AqbIIjtulU0lew9yZQ+LWpyiRaqHTKh
         /rqA==
X-Gm-Message-State: APjAAAUVHXsm1GWv4PMt8AnIhDDkwRkqlkp5ppZ+D2XpYj7FH+amtgYX
        80ep/dZcTCwQ2jt2jgNun+CKGriIZKU=
X-Google-Smtp-Source: APXvYqw8/rX4YtdSqpt0g+QMr58bHWAfz+EEQV/u4dQqzCOSjzl5JP1JeDQgS6aarojorrflj4DxVw==
X-Received: by 2002:a17:90b:3cc:: with SMTP id go12mr1916022pjb.89.1582182708796;
        Wed, 19 Feb 2020 23:11:48 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id p4sm2148325pgh.14.2020.02.19.23.11.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Feb 2020 23:11:48 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH v3 bpf-next 2/3] bpf: Sync uapi bpf.h to tools/
Date:   Thu, 20 Feb 2020 07:10:53 +0000
Message-Id: <20200220071054.12499-3-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200220071054.12499-1-forrest0579@gmail.com>
References: <07e2568e-0256-29f5-1656-1ac80a69f229@iogearbox.net>
 <20200220071054.12499-1-forrest0579@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sync uapi bpf.h to tools/.

Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
---
 tools/include/uapi/linux/bpf.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index f1d74a2bd234..e79082f78b74 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2892,6 +2892,12 @@ union bpf_attr {
  *		Obtain the 64bit jiffies
  *	Return
  *		The 64 bit jiffies
+ *
+ * u64 bpf_get_netns_id(struct bpf_sock_ops *bpf_socket)
+ *  Description
+ *      Obtain netns id of sock
+ * Return
+ *      The current netns inum
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3012,7 +3018,8 @@ union bpf_attr {
 	FN(probe_read_kernel_str),	\
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
-	FN(jiffies64),
+	FN(jiffies64),			\
+	FN(get_netns_id),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.20.1

