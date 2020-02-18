Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23C80162334
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 10:16:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgBRJQb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Feb 2020 04:16:31 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:42274 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726186AbgBRJQa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Feb 2020 04:16:30 -0500
Received: by mail-pl1-f193.google.com with SMTP id e8so7827264plt.9;
        Tue, 18 Feb 2020 01:16:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Mq2JqQod+vpVxRW+X/4KsnEzSEWAXO4I99MeuXsb2Bo=;
        b=FtskL+Zvh5qfsPQ/aSAbcJvJstbRMSs1LQJPA1OeuN6Ta/t1M36qY/IhWG1P74Ahh9
         aZt7CzQVlYxLTkQX1Kx+401ILFqR9aRqIBNTKYsZ9uwDDJnVtt5a6r+T+55BBlC3Nbnc
         LtBTG+BzmfrSqMnhjObAa+lkiHWVi48yxiCrAMW+nGDHp4KdqQKM01pTm4QLnpal62BL
         B5A9F0Y6Nlg6gFrHSHUEmU1jA8PSEXkXnpupGd9bsY675ILy/DOcqvSFYIqLpdB8SWK9
         Fhm7gA8Fed/cbK6MvFsWsXGrzq0hDZkL8lXvyxbd7N/tpskyUlHMnDRNK244l1mpbPLB
         056g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Mq2JqQod+vpVxRW+X/4KsnEzSEWAXO4I99MeuXsb2Bo=;
        b=mq16NEkKZcBvfGYNapbGJ5P4gBcijAPiWBbI/n3A7q16/h/LakSUVfzLRUMxJMYLfA
         e5W5C7GGdKG1rnUMjkyKZGC9e7dIy6zmGt+r69MNK5lV8P928HHDHCDJyOnSecUpcITm
         Y2BQjGzWZexW8/wyKxT9DCxWxQfSD1YIjnkMWpyHWIWzIemjLP1Mr5qy29LNoXesfU9G
         SVa/A9B30V/mLFJYilxuIIYE6ATL8XTA9ua3/LtrPOJr76ns67VM/8lgsZnGT98l2wde
         XtD3gWqlEVIqTgrobbG41V3Cj7HGOjEA6vOJvDagNLsxKSZL9H2f67zQVluy9QhdK94U
         BedQ==
X-Gm-Message-State: APjAAAVPPJ1EUmvGY6HsCwKN71ZoMLTgwdHxg+dP+GCJe2BBSGArcayg
        v0OvLEkQE7dYJP0pyR/n5LmNaf3Hn06ymw==
X-Google-Smtp-Source: APXvYqzOJcvjjQS32d+ywiN6k09gaNXhVDCtkpiklWxXDQ6pyxDwLX9FW/C3XsBQ6XXvDv4538aRTw==
X-Received: by 2002:a17:90a:8547:: with SMTP id a7mr1635868pjw.0.1582017389777;
        Tue, 18 Feb 2020 01:16:29 -0800 (PST)
Received: from kernel.rdqbwbcbjylexclmhxlbqg5jve.hx.internal.cloudapp.net ([65.52.171.215])
        by smtp.gmail.com with ESMTPSA id h191sm1992110pge.85.2020.02.18.01.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Feb 2020 01:16:29 -0800 (PST)
From:   Lingpeng Chen <forrest0579@gmail.com>
To:     bpf <bpf@vger.kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        John Fastabend <john.fastabend@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Petar Penkov <ppenkov.kernel@gmail.com>,
        Lingpeng Chen <forrest0579@gmail.com>
Subject: [PATCH v2 bpf-next 2/3] bpf: Sync uapi bpf.h to tools/
Date:   Tue, 18 Feb 2020 09:15:40 +0000
Message-Id: <20200218091541.107371-3-forrest0579@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200218091541.107371-1-forrest0579@gmail.com>
References: <20200206083515.10334-1-forrest0579@gmail.com>
 <20200218091541.107371-1-forrest0579@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
index f1d74a2bd234..3573907d15e0 100644
--- a/tools/include/uapi/linux/bpf.h
+++ b/tools/include/uapi/linux/bpf.h
@@ -2892,6 +2892,11 @@ union bpf_attr {
  *		Obtain the 64bit jiffies
  *	Return
  *		The 64 bit jiffies
+ * u64 bpf_sock_ops_get_netns(struct bpf_sock_ops *bpf_socket)
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
+	FN(jiffies64),			\
+	FN(sock_ops_get_netns),
 
 /* integer value in 'imm' field of BPF_CALL instruction selects which helper
  * function eBPF program intends to call
-- 
2.20.1

