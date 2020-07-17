Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A432223105
	for <lists+netdev@lfdr.de>; Fri, 17 Jul 2020 04:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgGQCIu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 22:08:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgGQCIt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 22:08:49 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E6D5C061755;
        Thu, 16 Jul 2020 19:08:49 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ls15so5783325pjb.1;
        Thu, 16 Jul 2020 19:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=tq4m4h2a9TL5pXC8bkU2F7Xjx88fuMptJM1ziSfBc+I=;
        b=BLQpULXQn6FhYgZQFzAkJicFWxLoYxfuqtJ60XvjaNDS6vqkF5ze/GDUMqVkBKseQC
         sU38qYidKqz1KNn3eEAMZwok5rgEq1ihUyhx1I9w2hd6xxId57+dDrg9RwtRSZco+uDQ
         UVbb+WTpPjdURlpaIqX50tjui5RVEo5Pb8MvAGybrjKardQxfoNcZOLDFhqDRcBGBZSN
         DzGa9+DFFdj1dJrJ5pSijMnmlxl2L6VuV7Dc9FLp54AkXV+jAfElNpGSgJlgCgh0r4rP
         KS0d+SKSvDU/Mp2ppBB4leWNpVn2lo8V/gmb8Q655HQgOgNbh0wmalDpp8yeB1cHB1yz
         +beg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=tq4m4h2a9TL5pXC8bkU2F7Xjx88fuMptJM1ziSfBc+I=;
        b=EuOPU23Iexc+T1WOqmho47KOj4RfSipD/zEanW0KUIJNIly35AcQ4oPubK65wx4NRG
         jtpu+gsk1BIBBAm5YPHIGCW5L6rJzxIa3M9b9ku5VO8i7mPvdj7vC3/Nh5tsIgr1/0Kz
         JnObqbwmPbOzdfXYaTo4+RpHEd4Pv00X2NdExUNJ4+IUoTz56cXKsYiFS/LzbxDb5u38
         fpzbyKvXcQJUxh73KjiyMvAmLTfzR2N89w/Y146CxN3CD5A+FVzMFO974qjX/Kp+t1Sb
         J7V29iH77+7vWUStx6pte0e+pxzH542niHCDX1bkYlYOFgz7XqpZNwVZdWnYFzBhDBWB
         xuVg==
X-Gm-Message-State: AOAM5322XuYypL7S0cvu2OOQF8H+QmS9gj33EhttTOHv50Y5ZDUsTLhg
        QGaq4mxkdRihF+hHZljPyVY=
X-Google-Smtp-Source: ABdhPJx1xFOvDqifGjgy8vUu0iFeypqKlimb/iCgqrKDVMKGCO8pX4GP2UEyFxYkxqrIJSz9nKQE5A==
X-Received: by 2002:a17:902:788b:: with SMTP id q11mr6116353pll.216.1594951728753;
        Thu, 16 Jul 2020 19:08:48 -0700 (PDT)
Received: from vm_111_229_centos ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id r25sm1793183pgv.88.2020.07.16.19.08.45
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 19:08:47 -0700 (PDT)
Date:   Fri, 17 Jul 2020 10:08:42 +0800
From:   YangYuxi <yx.atom1@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ebpf: fix parameter naming confusing
Message-ID: <20200717020842.GA29747@vm_111_229_centos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: YangYuxi <yx.atom1@gmail.com>
---
 kernel/bpf/syscall.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0fd80ac81f70..300ae16baffc 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1881,13 +1881,13 @@ struct bpf_prog *bpf_prog_inc_not_zero(struct bpf_prog *prog)
 EXPORT_SYMBOL_GPL(bpf_prog_inc_not_zero);
 
 bool bpf_prog_get_ok(struct bpf_prog *prog,
-			    enum bpf_prog_type *attach_type, bool attach_drv)
+			    enum bpf_prog_type *prog_type, bool attach_drv)
 {
 	/* not an attachment, just a refcount inc, always allow */
-	if (!attach_type)
+	if (!prog_type)
 		return true;
 
-	if (prog->type != *attach_type)
+	if (prog->type != *prog_type)
 		return false;
 	if (bpf_prog_is_dev_bound(prog->aux) && !attach_drv)
 		return false;
@@ -1895,7 +1895,7 @@ bool bpf_prog_get_ok(struct bpf_prog *prog,
 	return true;
 }
 
-static struct bpf_prog *__bpf_prog_get(u32 ufd, enum bpf_prog_type *attach_type,
+static struct bpf_prog *__bpf_prog_get(u32 ufd, enum bpf_prog_type *prog_type,
 				       bool attach_drv)
 {
 	struct fd f = fdget(ufd);
@@ -1904,7 +1904,7 @@ static struct bpf_prog *__bpf_prog_get(u32 ufd, enum bpf_prog_type *attach_type,
 	prog = ____bpf_prog_get(f);
 	if (IS_ERR(prog))
 		return prog;
-	if (!bpf_prog_get_ok(prog, attach_type, attach_drv)) {
+	if (!bpf_prog_get_ok(prog, prog_type, attach_drv)) {
 		prog = ERR_PTR(-EINVAL);
 		goto out;
 	}
-- 
1.8.3.1

