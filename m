Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C1354138496
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 03:37:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732007AbgALChh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jan 2020 21:37:37 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:41833 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731985AbgALChh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jan 2020 21:37:37 -0500
Received: by mail-il1-f195.google.com with SMTP id f10so5004152ils.8;
        Sat, 11 Jan 2020 18:37:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:date:message-id:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Ahgxc1mJ0wFyA7jnb8Fsb+g7dNCEBA2eOuNysg7JNsY=;
        b=tAcxWY9hyPqEDDLz9vF+5vhnd1jCt75tdFbCKyAQ9LXBFBxhwLLzWeKUOW+8iPqmkn
         z3HlYRrFELIjEuWyo3Z0rtrnhbB9SJbPfNFKBcFjn4+WnSVwLTzgGR4PULZR+k528s+p
         vGO/hd5JSooUNIhT5pO7c6/ACg21wazuyMaPOMnqb2fgOKeNcbt2VEw08xy7pScOoUGS
         VXHNgEr/4xFF/riqalHm5T9DzTLZp+8/bMfpIOJHDmhBSvfoDY6djco8RAGCVQ/98Bll
         iV0gWqR9qATMwMJ1yxjqdEZFeWimnKqFMkjvLCnOwy5UhjSfPrivK+fLs3GSxC5Fpekp
         SrUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Ahgxc1mJ0wFyA7jnb8Fsb+g7dNCEBA2eOuNysg7JNsY=;
        b=LdhGCrXhc5ABI2TiLjd16ERQD9coDQXnS7JwvUJ2WGTgjJRzVjb6kY8Gj+UxYWUJNf
         9fMDwpnRpXEFgncLsIw6WxNKsrnePyN7EY5djnvxmSDRJc1n5jGMlvjmv6HHCQ3cM16L
         vxFPcXVL+fRQnpEqDCBw36ACf/9XLFJw7VkPDZRoBUwvdclYOU3cibaZwhdyIZ355xO4
         NBrW+nS2hRQsuc6Ei99wSxXNx7RP41pTu9C88HfdYcfx2SlxNwSb///57CNUnIDcIGb0
         zCTsZqieeGqdUwA7SqrJdVuQDooRqTStWxv+Kpu3CBHe3hsMNnhgv0XH14PMQiSefOBX
         BZvQ==
X-Gm-Message-State: APjAAAXEzCeSThtujg6g9NspdlDTaE9U896QRaYNVfb5CwVpNPb9cTjq
        Dka9JBkq+1CAKEF5d+67rto=
X-Google-Smtp-Source: APXvYqxqe6ISn4AyimBnrI0ScVN+XMZzpsBEAKcw9RXkKPI2A4Za6MgWBn0qLNLYEPIh0L+2f/3Hmg==
X-Received: by 2002:a92:901:: with SMTP id y1mr9135799ilg.274.1578796656687;
        Sat, 11 Jan 2020 18:37:36 -0800 (PST)
Received: from [127.0.1.1] ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id r10sm1713660iot.28.2020.01.11.18.37.27
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 11 Jan 2020 18:37:36 -0800 (PST)
Subject: [bpf-next PATCH v2 1/2] bpf: xdp,
 update devmap comments to reflect napi/rcu usage
From:   John Fastabend <john.fastabend@gmail.com>
To:     bjorn.topel@gmail.com, bpf@vger.kernel.org, toke@redhat.com,
        toshiaki.makita1@gmail.com
Cc:     netdev@vger.kernel.org, john.fastabend@gmail.com, ast@kernel.org,
        daniel@iogearbox.net
Date:   Sat, 11 Jan 2020 18:37:21 -0800
Message-ID: <157879664156.8200.4955971883120344808.stgit@john-Precision-5820-Tower>
In-Reply-To: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower>
References: <157879606461.8200.2816751890292483534.stgit@john-Precision-5820-Tower>
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Now that we rely on synchronize_rcu and call_rcu waiting to
exit perempt-disable regions (NAPI) lets update the comments
to reflect this.

Fixes: 0536b85239b84 ("xdp: Simplify devmap cleanup")
Acked-by: Björn Töpel <bjorn.topel@intel.com>
Acked-by: Song Liu <songliubraving@fb.com>
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

