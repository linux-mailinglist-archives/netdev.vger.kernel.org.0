Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE05D540002
	for <lists+netdev@lfdr.de>; Tue,  7 Jun 2022 15:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243585AbiFGN3F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jun 2022 09:29:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241776AbiFGN3D (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jun 2022 09:29:03 -0400
Received: from mail-ua1-x941.google.com (mail-ua1-x941.google.com [IPv6:2607:f8b0:4864:20::941])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AC91CFE21;
        Tue,  7 Jun 2022 06:29:00 -0700 (PDT)
Received: by mail-ua1-x941.google.com with SMTP id d18so998388uaw.2;
        Tue, 07 Jun 2022 06:28:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=yEGHB2BrxKL7cY6kwmYKkzwTgijl/nVGelSJgZbIzBo=;
        b=lGJ7jXORiaDik/GNLcaeBlA9u6JLILUJTTL+MfTg3VoY4WdGNkAcPtB0M+XbiWOrzl
         uqlBylKILfTWFd4Wbv2BNMr1JjlqoZvooLmD4pPOfZoQaHaJKidpoMtG/cMj8F5W5W3E
         BWzeCid2CGXBlkcw5T76vcei8mbd/erVqnyt3z4WC4JJvFXmpM0x8beV2W0cdTdHYktC
         iOq6ZOMpdkvM1Tdvvp0vN7xFTiqxBU3qo2+E7dfp53UVBlFf5pUa9Py85ei73lK60WvC
         NoP1gx+6IsUeZusUi9lnGtHPgBM8pVgbNWzOweWfDxQx4oVyM6uGDqgzvxUhTH+A9ySh
         N5qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=yEGHB2BrxKL7cY6kwmYKkzwTgijl/nVGelSJgZbIzBo=;
        b=LU1NyzBzBA2+WbWi+az6QZIkhOS2HrFLQqJU0WJswBqUDVTzBSXS5Q50ZS8IudvDhP
         FByu33Pfw8v7qcNdNAvmD0onbVQ3/3gxfWZZ4dpuZCBmCXnjT7/r6uwM+wKFcMlFiC3X
         DblrTa3bxWopy7cHFH79cGRZiUZQ2Xycjn3fN/9+EWF2OdK9Y/YCQyNTyCNZAeA0eTXB
         JfOWswQL/O50g3MDr51F4x+FHoM/6c1QXOkIUkYrsE7KowP2q8L2ggVdKwzyl47NRpZe
         s73n1X3YFOmZ6rJHPi6QhfTFUxWtFS9iZKgrskodDtV/wlJHwUgQdaC7b7LW/wlaN07c
         zQyA==
X-Gm-Message-State: AOAM5330wDX6cWasHUw3EtWs8UzqH5sSbzcemOca8V8SVf6uUXUjG9SP
        rVfXKV2HgfBk2lYVLBzTYBwnlPnPCHPGsZHe9ecWHRwZRRWhBOr3
X-Google-Smtp-Source: ABdhPJzG5TWZ2RJwBrhNkuCYKHW//C8Gw4BuPOosxZlcgj31wGPEgLtuYp1JiAhKT6s4J7uiB6lSBbX5NdP7Lnjf2rc=
X-Received: by 2002:ab0:5971:0:b0:378:f212:dc6a with SMTP id
 o46-20020ab05971000000b00378f212dc6amr3991235uad.122.1654608539092; Tue, 07
 Jun 2022 06:28:59 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:612c:210c:b0:2c9:af1c:ae32 with HTTP; Tue, 7 Jun 2022
 06:28:58 -0700 (PDT)
From:   =?UTF-8?B?5bGx56u55bCP?= <mangosteen728@gmail.com>
Date:   Tue, 7 Jun 2022 21:28:58 +0800
Message-ID: <CAB8PBH+EVX3iTr7Nu-QFHAom+VnjPLEk0hpWSi0QiyD5u-bKag@mail.gmail.com>
Subject: [PATCH] bpf:add function
To:     ast <ast@kernel.org>, daniel <daniel@iogearbox.net>,
        andrii <andrii@kernel.org>
Cc:     bpf <bpf@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        mangosteen728 <mangosteen728@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add the absolute path to get the executable corresponding tothe task

Signed-off-by: mangosteen728 < mangosteen728@gmail.com>
---
Hi
This is my first attempt to submit patch, there are shortcomings
please more but wait.

In security audit often need to get the absolute path to the
executable of the process so I tried to add bpf_get_task_exe_path in
the helpers function to get.

The code currently only submits the implementation of the function and
how is this patch merge possible if I then add the relevant places=E3=80=82

thanks
mangosteen728
kernel/bpf/helpers.c | 37 +++++++++++++++++++++++++++++++++++++
1 file changed, 37 insertions(+)
diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index 225806a..797f 850 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -257,6 +257,43 @@
.arg2_type =3D ARG_CONST_SIZE,
};

+BPF_CALL_3(bpf_get_task_exe_path, struct task_struct *, task, char *,
buf, u32, sz)
+{
+ struct file *exe_file =3D NULL;
+ char *p =3D NULL;
+ long len =3D 0;
+
+ if (!sz)
+ return 0;
+ exe_file =3D get_task_exe_file(tsk);
+ if (IS_ERR_OR_NULL(exe_file))
+ return 0;
+ p =3D d_path(&exe_file->f_path, buf, sz);
+ if (IS_ERR_OR_NULL(path)) {
+ len =3D PTR_ERR(p);
+ } else {
+ len =3D buf + sz - p;
+ memmove(buf, p, len);
+ }
+ fput(exe_file);
+ return len;
+}
+
+static const struct bpf_func_proto bpf_get_task_exe_path_proto =3D {
+ .func       =3D bpf_get_task_exe_path,
+ .gpl_only   =3D false,
+ .ret_type   =3D RET_INTEGER,
+ .arg1_type  =3D ARG_PTR_TO_BTF_ID,
+ .arg2_type  =3D ARG_PTR_TO_MEM,
+ .arg3_type  =3D ARG_CONST_SIZE_OR_ZERO,
+};
+
--
