Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1772B12451E
	for <lists+netdev@lfdr.de>; Wed, 18 Dec 2019 11:54:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726802AbfLRKyZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Dec 2019 05:54:25 -0500
Received: from mail-pg1-f195.google.com ([209.85.215.195]:35999 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726701AbfLRKyY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Dec 2019 05:54:24 -0500
Received: by mail-pg1-f195.google.com with SMTP id k3so1077514pgc.3;
        Wed, 18 Dec 2019 02:54:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cptuS3gx2ZAH9t+h/JLl0P3ml44OP5bSJzkDO+68Zwo=;
        b=WwQ7e0ob39UWjt5asi76dFoNjDEcxULrI3GRO8M3RbgxU+orGCF/7oNK4W12LsirrX
         nNM7N77dFWaQ//IUXRo6/rfxQ/Tf2JFbc1X1jn6iIIbixVUIWQ5N2r0cPFJgZxQyaZJh
         gI5HVyY2awnGZ02HPlbybGrEZjdi5nRspbmEbiYaILa4Pjjw9kboeJWOxafdEIVvNNFv
         PPmvAgHbh4f2iCPh72g1ZjmJnO6KVq3qwAw0KIPn1BNh2vz8scni2CjIT/CAKJBAAK20
         NoyWbYqArJbL/+12eJefWIbyxzlIXh57pmz/eHfl+Xd8+BNFmJTUDvz5SIwljF1Vh+3C
         qnfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cptuS3gx2ZAH9t+h/JLl0P3ml44OP5bSJzkDO+68Zwo=;
        b=k1Et2fjEoQVuzCuhQlFOdnfcl/kN8OOtmLL+Z1d01oVbRnmJqhl4EUFlkTmCH1U5dQ
         l4GKCO3sSJBRLtcmHdgUxrSeiRW0OnVK0eXJLbRY4fST2k4ScjMk/nUNQr8Mdu+dvU2B
         9mGvRV5pcpxdBaej8Gf7JAuetoQcS7/B06iS95KoAyU9ujlVG5KL7/UvZ7YxJWiVmnxA
         dZnlh0WnArujPjjLGuyzQSALXDqyz5VhYiRYh+AlhUbK+EC/DCQ02bLGLNnX/fYy7eO0
         rj0ulMUJhifcx73HNbIkCtjX/Rp2qVLtji9znCA/hde4o2UDXsownMF9Vk2IemUP1CE/
         e74g==
X-Gm-Message-State: APjAAAVwRR3tyhFRZv47MnLILPa9qETp3uarfqn4sGZkS83xgsxJXbVv
        Ys9bhZXkp/09jEg8OS4cUgXOsGVZYqqMQw==
X-Google-Smtp-Source: APXvYqwVuONYIhAVbng0k9Uf6hxtz5ULw6uxZi58lYsrsyJqtFg+ehHZQ2/M0dULKz0Xc9yhecljZg==
X-Received: by 2002:aa7:9315:: with SMTP id 21mr2269066pfj.187.1576666463748;
        Wed, 18 Dec 2019 02:54:23 -0800 (PST)
Received: from btopel-mobl.ger.intel.com ([192.55.55.41])
        by smtp.gmail.com with ESMTPSA id k9sm2339000pje.26.2019.12.18.02.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 02:54:23 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     netdev@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        bpf@vger.kernel.org, davem@davemloft.net,
        jakub.kicinski@netronome.com, hawk@kernel.org,
        john.fastabend@gmail.com, magnus.karlsson@intel.com,
        jonathan.lemon@gmail.com
Subject: [PATCH bpf-next 3/8] xdp: fix graze->grace type-o in cpumap comments
Date:   Wed, 18 Dec 2019 11:53:55 +0100
Message-Id: <20191218105400.2895-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191218105400.2895-1-bjorn.topel@gmail.com>
References: <20191218105400.2895-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Simple spelling fix.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 kernel/bpf/cpumap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/cpumap.c b/kernel/bpf/cpumap.c
index fbf176e0a2ab..66948fbc58d8 100644
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
@@ -524,7 +524,7 @@ static void cpu_map_free(struct bpf_map *map)
 		if (!rcpu)
 			continue;
 
-		/* bq flush and cleanup happens after RCU graze-period */
+		/* bq flush and cleanup happens after RCU grace-period */
 		__cpu_map_entry_replace(cmap, i, NULL); /* call_rcu */
 	}
 	free_percpu(cmap->flush_list);
-- 
2.20.1

