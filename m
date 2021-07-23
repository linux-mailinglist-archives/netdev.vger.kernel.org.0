Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA2233D321A
	for <lists+netdev@lfdr.de>; Fri, 23 Jul 2021 05:06:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233477AbhGWCZ7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Jul 2021 22:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233368AbhGWCZ5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Jul 2021 22:25:57 -0400
Received: from mail-yb1-xb32.google.com (mail-yb1-xb32.google.com [IPv6:2607:f8b0:4864:20::b32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A31C061575;
        Thu, 22 Jul 2021 20:06:30 -0700 (PDT)
Received: by mail-yb1-xb32.google.com with SMTP id w17so170589ybl.11;
        Thu, 22 Jul 2021 20:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LZXY42YBEngbYJDDiDOrHLr/szJYXhTWzKVS5ihVIug=;
        b=n+dYLGKG0sbGUV4QHQ78inYVsafxHvAZt3ibq7ber69yMYVbECitEOydacpk2RPQC0
         NX/8u6RrUcS+bhsZVcSueF2zKpFOmRyg/8GIlnG8+fDZDdS2PigriAjoby5PTAOyBMY+
         2k+b3+NGKeiolCDgqas7tNednhAP/oV1qW3g1uXVQTewxLsi8v8Ql/vsoxveJQUOxiFE
         W8zuYNI+vNE8Shke1rSHxX4v/zq6awPZQCmhtpf909aAhKLp4rsHNXfzlPVPSc5QqRDX
         x3mrfhm+3GFWUvUZBZxMDZWxOpEwl6kjiob0CVUCGLN9Jz/XFeaiqnJzkd8E9zNTYiwi
         RNVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LZXY42YBEngbYJDDiDOrHLr/szJYXhTWzKVS5ihVIug=;
        b=XDIFMA+jpNAtiUHTszZ1sOsnqzpgucitc1Qo+wLlEguoQhBqtQpMeX9dJEC55mXyTZ
         hTmYdiPU6x7L88TCAHvBOgZn2eTPnuiFVhXTv5j4UFku0NEaS7GBQmtsErPmxnBW0aS4
         k/8IAN84Zec5gkiizV9oN5Avs/wwBaGXpBby++Z4LjleQwPEnEDKAvLFn96RdVtNUOe4
         6khfywsbvhObLsXUBDBu9aln24S+DVEG+DeuhZFNsu6I9PYlwnmzzYlMFkBB7IPGZDpY
         q8UVdyInP2Ec8alBKYBVtD97ZSbHQhVMChiQXfRQ/EQXOX2e8KzKNzBnrU5RrA1EPdsc
         zJKg==
X-Gm-Message-State: AOAM530Do9c7/xFrq7zfsNL0UdbTS1qiTlKaDuTtfy4R6Hrd2mhyaO91
        2Fh9NB8a5vuk/xBALqDztmx06sYMLDsfn5cYQA8=
X-Google-Smtp-Source: ABdhPJxX/leaTPqfcczErJqdEkClGoic1yAeJpux/0bd8bQ7tv//ORqoR1u89f++Sv70H9smmrdTJSCw6YxlEYjFpAk=
X-Received: by 2002:a25:1455:: with SMTP id 82mr3583599ybu.403.1627009589802;
 Thu, 22 Jul 2021 20:06:29 -0700 (PDT)
MIME-Version: 1.0
References: <20210721215810.889975-1-jolsa@kernel.org> <20210721215810.889975-4-jolsa@kernel.org>
In-Reply-To: <20210721215810.889975-4-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 22 Jul 2021 20:06:18 -0700
Message-ID: <CAEf4BzadLVhNV4Ub+DsRn38dfBUFRM9=t8e7-GP1qMU6DmHVmQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] libbpf: Export bpf_program__attach_kprobe_opts
 function
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Alan Maguire <alan.maguire@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 21, 2021 at 2:58 PM Jiri Olsa <jolsa@redhat.com> wrote:
>
> Exporting bpf_program__attach_kprobe_opts function.

I've updated all commits to use more customary imperative language
("export" instead of "exporting", "add" instead of "adding"). Also
fixed a few styling issues and changed the order of kprobe_opts field
(offset first, bool retprobe next), so that we don't have unnecessary
internal padding.

Pushed to bpf-next, thanks!

>
> Renaming bpf_program_attach_kprobe_opts to bpf_kprobe_opts
> and adding 'sz' field for forward/backward compatiblity.
>
> Suggested-by: Andrii Nakryiko <andrii@kernel.org>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---
>  tools/lib/bpf/libbpf.c   | 31 +++++++++++++++++--------------
>  tools/lib/bpf/libbpf.h   | 14 ++++++++++++++
>  tools/lib/bpf/libbpf.map |  1 +
>  3 files changed, 32 insertions(+), 14 deletions(-)
>

[...]
