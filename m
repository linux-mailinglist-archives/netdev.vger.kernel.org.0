Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8DA452831
	for <lists+netdev@lfdr.de>; Tue, 16 Nov 2021 04:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243758AbhKPDH3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Nov 2021 22:07:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241471AbhKPDH1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Nov 2021 22:07:27 -0500
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE738C10C15D
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 15:34:23 -0800 (PST)
Received: by mail-ua1-x92d.google.com with SMTP id az37so38440130uab.13
        for <netdev@vger.kernel.org>; Mon, 15 Nov 2021 15:34:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Gk0g0DKEdeIqcOvpjNEByG1CUB5EVh/VZGBCMhQPuJ4=;
        b=PBuAeDLu5r7QBWtyFMw68r5RV/j1VyEaZOYG/ZOA9XSdzEY1dMI6oQj2umH0sUMKzk
         26SIxB+VaxqPjL7sh/6Gefn/wQ1PCChMlE3yZxU8fvbfKuuIFj9XkL0nckNIOC2ud1pG
         fzcxklkffFFlkbftq5HSxE0rZuwxdBKG8kCi7xq8U48OuWrp/C4hFt+dHNdi2nypDtVw
         eNhPn7QBAVgcW1i9T8qBJGdDw8p1QO2UjavBUMIx6QS2rXOSVy3cnQf7s20qxAXhmC2L
         8MZj9MAfAjqxYOizaIiZh0rKPolxJU5m2i6XOPHNF9fB/rdEwM1zz9MCu5Kuj97jOXVm
         u3cA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Gk0g0DKEdeIqcOvpjNEByG1CUB5EVh/VZGBCMhQPuJ4=;
        b=ZZofXNd+XpKXTCe9dIzWK1sU6ovvNlMvVPJ7e0PL6SmCLcJP7fpJrGzyeqMP6UJRAZ
         TM9vs7q9JTaWHxuavy5hBpm+x2Bryd40ex0j2fssSfszDjujw9SpQBpLVL574AFdUBBf
         eWvEcVGE3KWYwvwAnzzWSfmeUS/ZfvDVl2y41NCO+DzwdDeyolu55heGjpCGvW23h6J7
         lPEZt8e+h3qV63QwC9vs32PLPpLGvO3i9zTguvNLBetMqYytd4DZqwWzlD3tt9XNNhpM
         nsBBK1qejkurvU3gLnjD4yhl+OZ9ztq2GJWaV9peAeVepzQaxJsWz4PryhlKf4gGm/Zp
         uMFQ==
X-Gm-Message-State: AOAM530D1G01C7OsP+Z4NpGexl+da2sIYQgw6n5h3KDhWIQMVTb2Y9OV
        umqq7fWSBvuvekXRp2eSMsop/UoLoNFK65UC1Qy1PQ==
X-Google-Smtp-Source: ABdhPJxNh0DI3qbvR7QEl0lPUl9F1BWGEZ1wnBt1yuTPkHQZu8F/FeVqYTgYIOmTKnfamyPqCqJPsdIwjLP9TTz7YT8=
X-Received: by 2002:ab0:70cd:: with SMTP id r13mr3992803ual.99.1637019262917;
 Mon, 15 Nov 2021 15:34:22 -0800 (PST)
MIME-Version: 1.0
References: <20211115193105.1952656-1-sdf@google.com>
In-Reply-To: <20211115193105.1952656-1-sdf@google.com>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Mon, 15 Nov 2021 23:34:11 +0000
Message-ID: <CACdoK4L0YOKXbKdLdBgGpZd_nrVq39wiZ+KoWUtAHP2CsR6RCg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] bpftool: add current libbpf_strict mode to
 version output
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 at 19:31, Stanislav Fomichev <sdf@google.com> wrote:
>
> + bpftool --legacy --version
> bpftool v5.15.0
> features: libbfd, skeletons
> + bpftool --version
> bpftool v5.15.0
> features: libbfd, libbpf_strict, skeletons
>
> + bpftool --legacy --help
> Usage: bpftool [OPTIONS] OBJECT { COMMAND | help }
>        bpftool batch file FILE
>        bpftool version
>
>        OBJECT := { prog | map | link | cgroup | perf | net | feature | btf | gen | struct_ops | iter }
>        OPTIONS := { {-j|--json} [{-p|--pretty}] | {-d|--debug} | {-l|--legacy} |
>                     {-V|--version} }
> + bpftool --help
> Usage: bpftool [OPTIONS] OBJECT { COMMAND | help }
>        bpftool batch file FILE
>        bpftool version
>
>        OBJECT := { prog | map | link | cgroup | perf | net | feature | btf | gen | struct_ops | iter }
>        OPTIONS := { {-j|--json} [{-p|--pretty}] | {-d|--debug} | {-l|--legacy} |
>                     {-V|--version} }
>
> + bpftool --legacy
> Usage: bpftool [OPTIONS] OBJECT { COMMAND | help }
>        bpftool batch file FILE
>        bpftool version
>
>        OBJECT := { prog | map | link | cgroup | perf | net | feature | btf | gen | struct_ops | iter }
>        OPTIONS := { {-j|--json} [{-p|--pretty}] | {-d|--debug} | {-l|--legacy} |
>                     {-V|--version} }
> + bpftool
> Usage: bpftool [OPTIONS] OBJECT { COMMAND | help }
>        bpftool batch file FILE
>        bpftool version
>
>        OBJECT := { prog | map | link | cgroup | perf | net | feature | btf | gen | struct_ops | iter }
>        OPTIONS := { {-j|--json} [{-p|--pretty}] | {-d|--debug} | {-l|--legacy} |
>                     {-V|--version} }
>
> + bpftool --legacy version
> bpftool v5.15.0
> features: libbfd, skeletons
> + bpftool version
> bpftool v5.15.0
> features: libbfd, libbpf_strict, skeletons
>
> + bpftool --json --legacy version
> {"version":"5.15.0","features":{"libbfd":true,"libbpf_strict":false,"skeletons":true}}
> + bpftool --json version
> {"version":"5.15.0","features":{"libbfd":true,"libbpf_strict":true,"skeletons":true}}
>
> v2:
> - fixes for -h and -V (Quentin Monnet)
>
> Suggested-by: Quentin Monnet <quentin@isovalent.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

The behaviour will change in a few cases where both the help and
version commands and/or options are provided, e.g. "bpftool -h
version" used to print the help and will do the version instead,
"bpftool -V help" changes in an opposite fashion. Given that there's
no practical interest in having both commands/options, and that the
behaviour was not really consistent so far, I consider that this is
not an issue.

However, we now have "bpftool --version" returning -1 (instead of 0).
Any chance we can fix that? Maybe simply something like the change
below instead?

------
diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
index 473791e87f7d..b2e67b0f02cf 100644
--- a/tools/bpf/bpftool/main.c
+++ b/tools/bpf/bpftool/main.c
@@ -400,6 +400,7 @@ int main(int argc, char **argv)
         { "legacy",    no_argument,    NULL,    'l' },
         { 0 }
     };
+    bool version_requested = false;
     int opt, ret;

     last_do_help = do_help;
@@ -414,7 +415,8 @@ int main(int argc, char **argv)
                   options, NULL)) >= 0) {
         switch (opt) {
         case 'V':
-            return do_version(argc, argv);
+            version_requested = true;
+            break;
         case 'h':
             return do_help(argc, argv);
         case 'p':
@@ -479,6 +481,9 @@ int main(int argc, char **argv)
     if (argc < 0)
         usage();

+    if (version_requested)
+        return do_version(argc, argv);
+
     ret = cmd_select(cmds, argc, argv, do_help);

     if (json_output)
