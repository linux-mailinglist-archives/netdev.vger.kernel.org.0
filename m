Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A537916B898
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:46:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728956AbgBYEq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:46:27 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:46438 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728725AbgBYEq1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 23:46:27 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so4958555pll.13;
        Mon, 24 Feb 2020 20:46:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=/tBIPCAZc0laAnqgwSkq+gQyP8rdQEQry0AKY7Daoz0=;
        b=QslHQOPxgGfys9Mhqsb1XUyfjCkLshsJYP+bYy5CYiEwc7qxYcA3matCW7pPcDNOkT
         NjabxpXzFcpqP6kc78KWcA+rrWT9g4GvYy0lW6NDfmm+pkEOW8LnbtAkaexCZ9IPr3cN
         hWgvcdTffwfHuU9Ri/3+JhTpKLxK+MA012JRq78xoZghRKkJ0gTmX7q+yKdYkiLzq4SR
         qtHAVEfv3aZ9s5QB/EdRLPQkH/sfl4FwWir00menmpV27iKJCD3wnu6uacyWn2SCnBOE
         94TYdzjLl2EUIIndBcQ6E/4hhrFhvp7YDrcT8mhyIUI1HSg4HfqVb54rmpZa5NqmClPA
         ipcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=/tBIPCAZc0laAnqgwSkq+gQyP8rdQEQry0AKY7Daoz0=;
        b=LKUdX+hj1eCD0mrXwH9MRcyPhcWiSKvzYWXRSBlvngeK/c2cAfCJscQL7xrZQ3lCsw
         netL74FF58HG+pjZ1FvW+27v/+GixWIV2IOJ1vkUOISxj8fFpvrFvlA99Z1fWx/lgfux
         K8hrUGVP6KPCHW0ygbuvUJXspSXi93kN7+EdYjxW2sTe9HCfrBSEQIuWqSv1kusW/Rze
         Hkh1bejw9YDOPGYcDmV+s3zRM0sunZ2gKuIpCk2iXqsrpsVk1S5iu8vUJRVUDEG6bBmr
         pL0Uk2zUljA+iksa/qHCSu8cA7IvjV47qnMQeoSeaiByeykIK7L4+inyT9GR2uD7U2P3
         y7Dg==
X-Gm-Message-State: APjAAAVdqK//r8hsmEgnXinZKyQNrA/mL97lCG4s0lAlr4ZsblBxucE3
        1KLMt7OhW/CgJrkk7+SLS90XU8jcjb8=
X-Google-Smtp-Source: APXvYqzqdicsBD3ukoT0gBFzvYsWIS6vpaTrPm4S5WYxxUbs6QjXiCYUZmzsE6sc9mZybt0dPUBd9Q==
X-Received: by 2002:a17:90a:858c:: with SMTP id m12mr2783214pjn.127.1582605986004;
        Mon, 24 Feb 2020 20:46:26 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id l13sm1170879pjq.23.2020.02.24.20.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Feb 2020 20:46:25 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Song Liu <song@kernel.org>,
        Lingpeng Chen <forrest0579@gmail.com>,
        Song Liu <songliubraving@fb.com>
Subject: [PATCH v4 bpf-next 2/3] bpf: Sync uapi bpf.h to tools/
Date:   Tue, 25 Feb 2020 04:45:37 +0000
Message-Id: <20200225044538.61889-3-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200225044538.61889-1-forrest0579@gmail.com>
References: <CAPhsuW6QkQ8-pXamQVzTXLPzyb4-FCeF_6To7sa_=gd7Ea5VpA@mail.gmail.com>
 <20200225044538.61889-1-forrest0579@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch sync uapi bpf.h to tools/.

Signed-off-by: Lingpeng Chen <forrest0579@gmail.com>
Acked-by: Song Liu <songliubraving@fb.com>
---
 tools/include/uapi/linux/bpf.h | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
index 906e9f2752db..c53178f7585e 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2909,6 +2909,12 @@ union bpf_attr {
  *		of sizeof(struct perf_branch_entry).
  *
  *		**-ENOENT** if architecture does not support branch records.
+ *
+ * u64 bpf_get_netns_id(struct bpf_sock_ops *bpf_socket)
+ *  Description
+ *      Obtain netns id of sock
+ * Return
+ *      The current netns inum
  */
 #define __BPF_FUNC_MAPPER(FN)		\
 	FN(unspec),			\
@@ -3030,7 +3036,8 @@ union bpf_attr {
 	FN(tcp_send_ack),		\
 	FN(send_signal_thread),		\
 	FN(jiffies64),			\
-	FN(read_branch_records),
+	FN(read_branch_records),	\
+	FN(get_netns_id),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.20.1

