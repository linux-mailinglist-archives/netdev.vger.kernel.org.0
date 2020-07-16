Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F504222420
	for <lists+netdev@lfdr.de>; Thu, 16 Jul 2020 15:42:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728829AbgGPNmD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jul 2020 09:42:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40312 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726537AbgGPNmD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jul 2020 09:42:03 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD94C061755;
        Thu, 16 Jul 2020 06:42:03 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o13so4890788pgf.0;
        Thu, 16 Jul 2020 06:42:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=tdZ5atcYmkHDWD75u9CN+9LB8lA8YvS/gtJmV0KCUEU=;
        b=RcOx8bvKvkR/mVCBWIYeOX0vWefVIqLx8DYbd0S64GG1tDa2e1GwYlxJNCvbjVt9Mq
         /TFYlJz3vVu+xaMh95Qso21ghU6xPHw1jHPclzhKWHhVHe10Qkbe/x/Aq7MGnRGIEV9T
         IDd2SAG2JBVNxTTNTJxGUOLEs0MrTePqz0LLnPb06xxTFfXDinGG6UvqZQv9l6n7LVxB
         WBzJBcHB1iuCTrhs4oTh3A2E0uiaWW1LObGM9e3AJFGD9Q+6HOFzKCuBXqwySokT1LGn
         YrHiZGtaG14xlshqi13iPDizi+jf6TZuBMA+eDe2qvBUFQDL8+Dk6RUWY4uEsQI8qxyc
         LvzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=tdZ5atcYmkHDWD75u9CN+9LB8lA8YvS/gtJmV0KCUEU=;
        b=tsbvKadEDVjdxrGMXcKeR0pKQUBKOd3bWYuO9gVveD02mITkTqajNBdaa3lJHSk6gD
         AldF9Rij0SU9xZ/xiUl1+euyeBVlCbuCMGRswsIPPgi0nhaTwiTKv4q6y8nEnGP77NR7
         fOJIrZRVn/ZEYq6304wUG4wVjeYpqeVq6/a7XXQlfXl0yXnsE7j7ytrnv898TFOsg2Ua
         IauEmszx2udU4pxhCQTRbemA1ih8wf0th90emW1+f53434lij7zwadPe2cKdKZDSKJho
         Vdzos50vzHQk7HWdAH1Jw2wwoU0lrzmmRk+vvLd4/WVlH1ItxxhlS8O/v8dN2uS/HfD3
         Wm4g==
X-Gm-Message-State: AOAM531Crc0OYBcj8T0q4u2XSaHBZFqcxgN5uqBp1WRlQ7Ub7YqB/NTB
        feKCeSzRgs9tp4LZ7njLDGI=
X-Google-Smtp-Source: ABdhPJwFr5xcS/OGf6NXQXDzh1UTdkKrkaezqiDI4uvqb0LtgnSvJBDxjWFOC73ayoUX52ZP/37AmQ==
X-Received: by 2002:a63:db46:: with SMTP id x6mr4171830pgi.265.1594906922719;
        Thu, 16 Jul 2020 06:42:02 -0700 (PDT)
Received: from vm_111_229_centos ([203.205.141.39])
        by smtp.gmail.com with ESMTPSA id io3sm229510pjb.22.2020.07.16.06.42.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 16 Jul 2020 06:42:02 -0700 (PDT)
Date:   Thu, 16 Jul 2020 21:41:54 +0800
From:   YangYuxi <yx.atom1@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        john.fastabend@gmail.com, kpsingh@chromium.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] ebpf: fix parameter naming confusing
Message-ID: <20200716134154.GA7123@vm_111_229_centos>
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
 kernel/bpf/syscall.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 0fd80ac81f70..42406f7275b7 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -1881,13 +1881,13 @@ struct bpf_prog *bpf_prog_inc_not_zero(struct bpf_prog *prog)
 EXPORT_SYMBOL_GPL(bpf_prog_inc_not_zero);
 
 bool bpf_prog_get_ok(struct bpf_prog *prog,
-			    enum bpf_prog_type *attach_type, bool attach_drv)
+			    enum bpf_prog_type *prog_type, bool attach_drv)
 {
 	/* not an attachment, just a refcount inc, always allow */
 	if (!attach_type)
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

