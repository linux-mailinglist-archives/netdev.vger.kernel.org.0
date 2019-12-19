Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18766125B49
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 07:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726813AbfLSGKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Dec 2019 01:10:34 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:33638 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725821AbfLSGKe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Dec 2019 01:10:34 -0500
Received: by mail-pj1-f66.google.com with SMTP id u63so2164372pjb.0;
        Wed, 18 Dec 2019 22:10:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=RNOnFl4KY1BpFZfwRTGTpJA/o8g/e7g+uJT8L5hyaXM=;
        b=fR82z3P2qm0HbQ2Q1loFawWVaR6XmFvPYZ4SEO3utDPWVwjSO5x0iEXJ5w9y4DrKCq
         CrmU3qyHH6lTnpHJE5uCjQofjps9dlEW7KV7Lzw7jpEgIp48SNtTGoJAigRQ94hKf3CF
         KwKM4XCAbV4mfEra4B7bgRvX5aefY0Pd0s1PfF4N3iuCbLpKgGzq+/WQbRWZ939lRuBl
         natkZYk20sucluSydGkMUlQyCBAKIslqp+z3h+snHu6vFc67CbDEy517A/mpas5bf0DY
         ZV9ywxKJt+aA+U3DTrG9jlZub/nZycJnK/L2luO+cu2Bh7FFy88LIX+y8hTeWjmT6//J
         cZdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=RNOnFl4KY1BpFZfwRTGTpJA/o8g/e7g+uJT8L5hyaXM=;
        b=Zte8cCPhushpd+U8c7BQDubLNeXGBzjY3kcewy8L50Kx1aIDss2OUubwuQDHrvGDs6
         b4xy1BRs/jbRfWdA2Gc/XunPD2cmLqL7dea5re9o4tqvsdHYRjlfC0OwUGmj5fqYjimI
         Nc9gLwft7KR9xx1SQ65TLsRK75f33UxP5iI476JoGEi/eauCXj8jLDkCE/22daH+W3+6
         WiU1+5pL5D3ftl5/tm4zsq2yL3SUpei/kindATdClnhon2vezu9t95ZXIelZagccVyPD
         rOADfOY5kCWjrUpM050sj90nJ7f8ytCCS7CQ6lRKLYDOPHbT7QZUsvgroqD4yMKH2Wzg
         DB3A==
X-Gm-Message-State: APjAAAWC93K1zcSjXgGNtTNJGDAKCct+FcwWjgj/nSESCTBZT4zrbSVR
        Li7nAq39yi+c5buCw95M1+Et6qzrm5QEOA==
X-Google-Smtp-Source: APXvYqxs8M2ECnRbo4M62h6A66key1OUCUDHdXLG3q08iDGL2Ws9o62OoGAO7v7BtQyiAMqXT82xYQ==
X-Received: by 2002:a17:902:5a09:: with SMTP id q9mr7521486pli.322.1576735832968;
        Wed, 18 Dec 2019 22:10:32 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (fmdmzpr04-ext.fm.intel.com. [192.55.55.39])
        by smtp.gmail.com with ESMTPSA id t23sm6465062pfq.106.2019.12.18.22.10.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 22:10:32 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
Subject: [PATCH bpf-next v2 3/8] xdp: fix graze->grace type-o in cpumap comments
Date:   Thu, 19 Dec 2019 07:10:01 +0100
Message-Id: <20191219061006.21980-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191219061006.21980-1-bjorn.topel@gmail.com>
References: <20191219061006.21980-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Simple spelling fix.

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/cpumap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index 04c8eb11cd90..f9deed659798 100644
--- a/kernel/bpf/cpumap.c
+++ b/kernel/bpf/cpumap.c
@@ -401,7 +401,7 @@ static void __cpu_map_entry_free(struct rcu_head *rcu)
 	struct bpf_cpu_map_entry *rcpu;
 
 	/* This cpu_map_entry have been disconnected from map and one
-	 * RCU graze-period have elapsed.  Thus, XDP cannot queue any
+	 * RCU grace-period have elapsed.  Thus, XDP cannot queue any
 	 * new packets and cannot change/set flush_needed that can
 	 * find this entry.
 	 */
@@ -428,7 +428,7 @@ static void __cpu_map_entry_free(struct rcu_head *rcu)
  * percpu bulkq to queue.  Due to caller map_delete_elem() disable
  * preemption, cannot call kthread_stop() to make sure queue is empty.
  * Instead a work_queue is started for stopping kthread,
- * cpu_map_kthread_stop, which waits for an RCU graze period before
+ * cpu_map_kthread_stop, which waits for an RCU grace period before
  * stopping kthread, emptying the queue.
  */
 static void __cpu_map_entry_replace(struct bpf_cpu_map *cmap,
@@ -523,7 +523,7 @@ static void cpu_map_free(struct bpf_map *map)
 		if (!rcpu)
 			continue;
 
-		/* bq flush and cleanup happens after RCU graze-period */
+		/* bq flush and cleanup happens after RCU grace-period */
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
 	free_percpu(cmap->flush_list);
-- 
2.20.1

