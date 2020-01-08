Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 60045134EF7
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727321AbgAHVfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:35:01 -0500
Received: from mail-io1-f65.google.com ([209.85.166.65]:37434 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726179AbgAHVfB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:35:01 -0500
Received: by mail-io1-f65.google.com with SMTP id k24so4866193ioc.4;
        Wed, 08 Jan 2020 13:35:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=/GvOoCT0xFD8/6aGwV3eh9rvuRXrlgmC3zJNi4p6MqU=;
        b=p5OnCGtwo2osB6lOQuBTrsN1GV5U7I6I6KeNJZNYTotwr0hNkGsPV5kuvJm5bAT05b
         ACULR9KBOf1Z9tkjUV4szZZ0KQFjn7E3U07RRUlj5pSL4ppAnbCPAnTudcUbIqLx7mQf
         2CfOMlsYpHXp+NojJgkCDmEmZuzIQ2Ic0bQ3BN99e2XXxMc+KWE+oZsK8YrRqOubEjFu
         Tw1tLkbf80h2Qg5GMG2sP3WCT1z4S43UYdvc8OTboCTbZZjKiU5gU53d8p6ysHx6e7yy
         moz/UFXv+HuZVAEH+m8ilXizda0czh5fr6N9Huv09kP3ADrQyvtKpS9aCwFs+dCrf7nF
         BlLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=/GvOoCT0xFD8/6aGwV3eh9rvuRXrlgmC3zJNi4p6MqU=;
        b=qj/GxiuATuCFuAGaXnbT5BBMuJ4vKlEiT+Kqpd9uRquJeWz+QXKebbTlvy8Kffbaa0
         sWT3erUyRxLRZzrrYhF3ucaxJtRBW/8rbh6Hk4s7/lmIZzWg6KHqRFo8/xeEiwTRfp7Z
         X4FgbOtKuiNJuSZj0SLR/VMGJP6kWfZQfwe/E/IamelMXxS1YtNGCQKKfCsAkpxjB3oS
         Pfg/yEL2IKwsGphmN0JWjMCRcW7LKMm81NIz2pdPkHhCB+wV9AkveocEZqgFG3x1tKI+
         d2lkSaBdshY2HPmBsRJuqKI8usC3a8TOKOnCblDlkJa1a8y6gsd6mIPqCJp+O7IVxl7g
         tORw==
X-Gm-Message-State: APjAAAVsBCnyUX+wX2OWRfC1cA7u14uAWt4nUQS0NnlcBhIH2JLzVnz5
        EEKTa2JLuhoE3CjzykU7B9g=
X-Google-Smtp-Source: APXvYqwZPEpoahMPAkA06VCszBoDXb8lkbW+oFb1qpd/Oit4UVw+OonStnY3OwfkIQ+h/bKI0umsOA==
X-Received: by 2002:a6b:3a8a:: with SMTP id h132mr4827450ioa.207.1578519300546;
        Wed, 08 Jan 2020 13:35:00 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id e7sm917601iot.71.2020.01.08.13.34.53
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 08 Jan 2020 13:35:00 -0800 (PST)
Subject: [bpf PATCH 1/2] bpf: xdp,
 update devmap comments to reflect napi/rcu usage
From:   John Fastabend <john.fastabend@gmail.com>
To:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Wed, 08 Jan 2020 13:34:46 -0800
Message-ID: <157851928650.21459.1089027650128166319.stgit@john-Precision-5820-Tower>
In-Reply-To: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
References: <157851907534.21459.1166135254069483675.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we rely on synchronize_rcu and call_rcu waiting to
exit perempt-disable regions (NAPI) lets update the comments
to reflect this.

Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
Signed-off-by: John Fastabend <john.fastabend@gmail.com>
---
 kernel/bpf/devmap.c |   21 +++++++++++----------
 1 file changed, 11 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index da9c832..f0bf525 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -193,10 +193,12 @@ static void dev_map_free(struct bpf_map *map)
 
 	/* At this point bpf_prog->aux->refcnt == 0 and this map->refcnt == 0,
 	 * so the programs (can be more than one that used this map) were
-	 * disconnected from events. Wait for outstanding critical sections in
-	 * these programs to complete. The rcu critical section only guarantees
-	 * no further reads against netdev_map. It does __not__ ensure pending
-	 * flush operations (if any) are complete.
+	 * disconnected from events. The following synchronize_rcu() guarantees
+	 * both rcu read critical sections complete and waits for
+	 * preempt-disable regions (NAPI being the relavent context here) so we
+	 * are certain there will be no further reads against the netdev_map and
+	 * all flush operations are complete. Flush operations can only be done
+	 * from NAPI context for this reason.
 	 */
 
 	spin_lock(&dev_map_lock);
@@ -498,12 +500,11 @@ static int dev_map_delete_elem(struct bpf_map *map, void *key)
 		return -EINVAL;
 
 	/* Use call_rcu() here to ensure any rcu critical sections have
-	 * completed, but this does not guarantee a flush has happened
-	 * yet. Because driver side rcu_read_lock/unlock only protects the
-	 * running XDP program. However, for pending flush operations the
-	 * dev and ctx are stored in another per cpu map. And additionally,
-	 * the driver tear down ensures all soft irqs are complete before
-	 * removing the net device in the case of dev_put equals zero.
+	 * completed as well as any flush operations because call_rcu
+	 * will wait for preempt-disable region to complete, NAPI in this
+	 * context.  And additionally, the driver tear down ensures all
+	 * soft irqs are complete before removing the net device in the
+	 * case of dev_put equals zero.
 	 */
 	old_dev = xchg(&dtab->netdev_map[k], NULL);
 	if (old_dev)

