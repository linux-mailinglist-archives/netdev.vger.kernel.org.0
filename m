Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AE42AB506
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 11:33:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729265AbgKIKdm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 05:33:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729050AbgKIKdl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 05:33:41 -0500
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E61C0613CF;
        Mon,  9 Nov 2020 02:33:41 -0800 (PST)
Received: by mail-io1-xd43.google.com with SMTP id s24so9202746ioj.13;
        Mon, 09 Nov 2020 02:33:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wkye27w2nAyIcjrhd3hfBHl4YeysiD/X9LyxFDbBQas=;
        b=OqRlee4MqSA7fZDWCF6CqdUSTCXoYD0diRAhsu5/Y7W/g2KuA+bJCPazJTzzu+ZzmV
         mIovg/IuUJTtyhh+Uue6ho2Oj21wr80ltk8yGxzGlQL/NbCB+CKd7CCetJSPbVSjvAD4
         8j+5N7HB1rpyffj20+nK7sxJE9Bqz9QhTgB9tpDlFvfUsAYlk4TgrcnW9BACfKgE3Xhi
         2QS+Ki2TRw0wu04D3aZw2eJGaESFUNt16tiQeFXYR/Kr9EC0eQLWtGXg7rviA0XTeHdH
         6tjed0PESdEiJTzDtD5P5Bi4mTY1QYeXlX4XTdaHJeDcr3yqwwuxQbDbBOfI5fOe4t+7
         g5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=wkye27w2nAyIcjrhd3hfBHl4YeysiD/X9LyxFDbBQas=;
        b=NX/hmMxC0yybAS3YMcZ0Kr7vJgGo44RCQEZfpvZoCxiBfrg9nGJKn0WCoOCi6FTHTi
         31o3fzyXmP4LWFPb7kKNEE2I0VEquvcDK4HsAS9l2r+Vu7RaVbI5diKY8nCmeK2yXD7E
         /32edaeJDXpsVs2UGLbVV9zZMU+rIzMZPNvHKjJXTxpKQKaFbF+v4kwtUo9RycCzgpgj
         eLJ7OO1KPd5GoUcRpK7Mpfy11uiRss+DCQ+aBQH94S22nWe+fj2vb99xZy20W8XtTQ3E
         SEI4svw0aWUEE2NTKBUJiXpuYxAfFjZG68MpYGR15NV6VLp8EmVyDQsY8JA5UlVHp8gF
         qMnA==
X-Gm-Message-State: AOAM5328h3ILpIEF/pXhuo52F8GKW9iwLzKHp/YkSu72IP9sg8eYYE3b
        CaK2Wnr7peWJg/DomN53BFM=
X-Google-Smtp-Source: ABdhPJx3u8n9iY0h3VNSOjcaxUcjatBsthD0e/jyc8IR2gl42ENShsI/H7RSJAqdzlqyjhoCkAFyAg==
X-Received: by 2002:a6b:c047:: with SMTP id q68mr5323755iof.189.1604918020810;
        Mon, 09 Nov 2020 02:33:40 -0800 (PST)
Received: from localhost.localdomain ([156.146.54.75])
        by smtp.gmail.com with ESMTPSA id l9sm6758483ilt.19.2020.11.09.02.33.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 02:33:40 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org,
        christian@brauner.io, ast@kernel.org, daniel@iogearbox.net,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andrii@kernel.org,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] kernel: cgroup: Mundane spelling fixes throughout the file
Date:   Mon,  9 Nov 2020 16:01:11 +0530
Message-Id: <20201109103111.10078-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Few spelling fixes throughout the file.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 kernel/cgroup/cgroup.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index f2eeff74d713..c4f1b7968981 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -244,7 +244,7 @@ bool cgroup_ssid_enabled(int ssid)
  *
  * The default hierarchy is the v2 interface of cgroup and this function
  * can be used to test whether a cgroup is on the default hierarchy for
- * cases where a subsystem should behave differnetly depending on the
+ * cases where a subsystem should behave differently depending on the
  * interface version.
  *
  * List of changed behaviors:
@@ -262,7 +262,7 @@ bool cgroup_ssid_enabled(int ssid)
  *   "cgroup.procs" instead.
  *
  * - "cgroup.procs" is not sorted.  pids will be unique unless they got
- *   recycled inbetween reads.
+ *   recycled in-between reads.
  *
  * - "release_agent" and "notify_on_release" are removed.  Replacement
  *   notification mechanism will be implemented.
@@ -345,7 +345,7 @@ static bool cgroup_is_mixable(struct cgroup *cgrp)
 	return !cgroup_parent(cgrp);
 }

-/* can @cgrp become a thread root? should always be true for a thread root */
+/* can @cgrp become a thread root? Should always be true for a thread root */
 static bool cgroup_can_be_thread_root(struct cgroup *cgrp)
 {
 	/* mixables don't care */
@@ -530,7 +530,7 @@ static struct cgroup_subsys_state *cgroup_e_css_by_mask(struct cgroup *cgrp,
  * the root css is returned, so this function always returns a valid css.
  *
  * The returned css is not guaranteed to be online, and therefore it is the
- * callers responsiblity to tryget a reference for it.
+ * callers responsibility to try get a reference for it.
  */
 struct cgroup_subsys_state *cgroup_e_css(struct cgroup *cgrp,
 					 struct cgroup_subsys *ss)
@@ -702,7 +702,7 @@ EXPORT_SYMBOL_GPL(of_css);
 			;						\
 		else

-/* walk live descendants in preorder */
+/* walk live descendants in pre order */
 #define cgroup_for_each_live_descendant_pre(dsct, d_css, cgrp)		\
 	css_for_each_descendant_pre((d_css), cgroup_css((cgrp), NULL))	\
 		if (({ lockdep_assert_held(&cgroup_mutex);		\
@@ -936,7 +936,7 @@ void put_css_set_locked(struct css_set *cset)

 	WARN_ON_ONCE(!list_empty(&cset->threaded_csets));

-	/* This css_set is dead. unlink it and release cgroup and css refs */
+	/* This css_set is dead. Unlink it and release cgroup and css refs */
 	for_each_subsys(ss, ssid) {
 		list_del(&cset->e_cset_node[ssid]);
 		css_put(cset->subsys[ssid]);
@@ -1061,7 +1061,7 @@ static struct css_set *find_existing_css_set(struct css_set *old_cset,

 	/*
 	 * Build the set of subsystem state objects that we want to see in the
-	 * new css_set. while subsystems can change globally, the entries here
+	 * new css_set. While subsystems can change globally, the entries here
 	 * won't change, so no need for locking.
 	 */
 	for_each_subsys(ss, i) {
@@ -1151,7 +1151,7 @@ static void link_css_set(struct list_head *tmp_links, struct css_set *cset,

 	/*
 	 * Always add links to the tail of the lists so that the lists are
-	 * in choronological order.
+	 * in chronological order.
 	 */
 	list_move_tail(&link->cset_link, &cgrp->cset_links);
 	list_add_tail(&link->cgrp_link, &cset->cgrp_links);
@@ -4137,7 +4137,7 @@ struct cgroup_subsys_state *css_next_child(struct cgroup_subsys_state *pos,
 	 * implies that if we observe !CSS_RELEASED on @pos in this RCU
 	 * critical section, the one pointed to by its next pointer is
 	 * guaranteed to not have finished its RCU grace period even if we
-	 * have dropped rcu_read_lock() inbetween iterations.
+	 * have dropped rcu_read_lock() in-between iterations.
 	 *
 	 * If @pos has CSS_RELEASED set, its next pointer can't be
 	 * dereferenced; however, as each css is given a monotonically
@@ -4385,7 +4385,7 @@ static struct css_set *css_task_iter_next_css_set(struct css_task_iter *it)
 }

 /**
- * css_task_iter_advance_css_set - advance a task itererator to the next css_set
+ * css_task_iter_advance_css_set - advance a task iterator to the next css_set
  * @it: the iterator to advance
  *
  * Advance @it to the next css_set to walk.
@@ -6320,7 +6320,7 @@ struct cgroup_subsys_state *css_from_id(int id, struct cgroup_subsys *ss)
  *
  * Find the cgroup at @path on the default hierarchy, increment its
  * reference count and return it.  Returns pointer to the found cgroup on
- * success, ERR_PTR(-ENOENT) if @path doens't exist and ERR_PTR(-ENOTDIR)
+ * success, ERR_PTR(-ENOENT) if @path doesn't exist and ERR_PTR(-ENOTDIR)
  * if @path points to a non-directory.
  */
 struct cgroup *cgroup_get_from_path(const char *path)
--
2.26.2

