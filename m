Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F43F1433D5
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 23:21:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727372AbgATWVJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 17:21:09 -0500
Received: from mail-qk1-f195.google.com ([209.85.222.195]:35310 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgATWVJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 17:21:09 -0500
Received: by mail-qk1-f195.google.com with SMTP id z76so833088qka.2;
        Mon, 20 Jan 2020 14:21:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=wvKfZKzY5I12j5SecEs/3JRExvNNhiJqlDDq3iBdhXo=;
        b=Fhdl7qM8LX4IpvsWr1dAEePrn5SGSIoS+8d0TlyQlPt13eQ7tARY4+HE6YuYgqcSdu
         foKFK+ghLxfMRowd4DXEVN1FkPSkcmmwsIrJLE+WCmNbWCsnc8U+BeJirtYaVdneTZ1/
         4T0rpqUmrJKQc0ejJ1JoBDEa2YAmNVzOyhGZr99MuHcsZUoIocUxJs2FaOPGNr2DRCgK
         sUvB8wfeJhOHREZH9FxmSDcMzXtzb9cjrA09HOtFpgGA8xG9k9YOKzUsFOfLVTro0VJ9
         guuFC6M3ZeMDFRPp9gK316GweOHR9EN6AuPKUd8fBmAB9qB89aqCDnhtGvcXgT9Lv90k
         Y+4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=wvKfZKzY5I12j5SecEs/3JRExvNNhiJqlDDq3iBdhXo=;
        b=MUv0wpHkptdsblcyUAKdEO6QWwccDulA+vu7ppEpgNihS0Ke1MaWhLidqJDrWYn4gF
         HhDBxGiOLLkha6+tnmPZyt8aj9UyrmD6Fbl+YMehPuzkOUOn/MYdpAkPeZoS1RTpz7Pj
         F+5DfPoXoIGW9168FxjpLGEXA44yZt3sKT5PB6SMnimiL9Lym8Or7nuB1Cfnmn1rOLB8
         C9DjKVKYjACE2Bk9pijy0Y4dCSFJIoW2RUxtIlrgQdLvhYkX1b0xamAeOWcM590OijtC
         ORoMqJic23TJxd/3cplMqLGcQYuX3l/khwIO8PhCfaV9xZuZyQgx4KEesx8hRIltXc/r
         yxwg==
X-Gm-Message-State: APjAAAWcKgtk82tDtN/3mHgKr501rwjjFQlKdUAWNOTAlTQU18IJa7DE
        PY6LXZ2Ljb1G/hFuudinRUQqi/wSXU/lyFbBHJE=
X-Google-Smtp-Source: APXvYqwN97ytmdm+m2yXmDP7lSbj2QlGHO0xeyPd+wXqrhIEOE6NB97NJ7ZutY+Q7HkQp+geBcZ/+KlaIwupDVI6X/Q=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr1755114qkq.437.1579558867281;
 Mon, 20 Jan 2020 14:21:07 -0800 (PST)
MIME-Version: 1.0
References: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
In-Reply-To: <157952560001.1683545.16757917515390545122.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Jan 2020 14:20:55 -0800
Message-ID: <CAEf4BzYNp81_bOFSEZR=AcruC2ms76fCWQGit+=2QZrFAXpGqg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v5 00/11] tools: Use consistent libbpf include
 paths everywhere
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Doug Ledford <dledford@redhat.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-rdma@vger.kernel.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        clang-built-linux@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 20, 2020 at 5:08 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> We are currently being somewhat inconsistent with the libbpf include path=
s,
> which makes it difficult to move files from the kernel into an external
> libbpf-using project without adjusting include paths.
>
> Having the bpf/ subdir of $INCLUDEDIR in the include path has never been =
a
> requirement for building against libbpf before, and indeed the libbpf pkg=
-config
> file doesn't include it. So let's make all libbpf includes across the ker=
nel
> tree use the bpf/ prefix in their includes. Since bpftool skeleton genera=
tion
> emits code with a libbpf include, this also ensures that those can be use=
d in
> existing external projects using the regular pkg-config include path.
>
> This turns out to be a somewhat invasive change in the number of files to=
uched;
> however, the actual changes to files are fairly trivial (most of them are=
 simply
> made with 'sed'). The series is split to make the change for one tool sub=
dir at
> a time, while trying not to break the build along the way. It is structur=
ed like
> this:
>
> - Patch 1-3: Trivial fixes to Makefiles for issues I discovered while cha=
nging
>   the include paths.
>
> - Patch 4-8: Change the include directives to use the bpf/ prefix, and up=
dates
>   Makefiles to make sure tools/lib/ is part of the include path, but with=
out
>   removing tools/lib/bpf
>
> - Patch 9-11: Remove tools/lib/bpf from include paths to make sure we don=
't
>   inadvertently re-introduce includes without the bpf/ prefix.
>
> Changelog:
>
> v5:
>   - Combine the libbpf build rules in selftests Makefile (using Andrii's
>     suggestion for a make rule).
>   - Re-use self-tests libbpf build for runqslower (new patch 10)
>   - Formatting fixes
>
> v4:
>   - Move runqslower error on missing BTF into make rule
>   - Make sure we don't always force a rebuild selftests
>   - Rebase on latest bpf-next (dropping patch 11)
>
> v3:
>   - Don't add the kernel build dir to the runqslower Makefile, pass it in=
 from
>     selftests instead.
>   - Use libbpf's 'make install_headers' in selftests instead of trying to
>     generate bpf_helper_defs.h in-place (to also work on read-only filesy=
stems).
>   - Use a scratch builddir for both libbpf and bpftool when building in s=
elftests.
>   - Revert bpf_helpers.h to quoted include instead of angled include with=
 a bpf/
>     prefix.
>   - Fix a few style nits from Andrii
>
> v2:
>   - Do a full cleanup of libbpf includes instead of just changing the
>     bpf_helper_defs.h include.
>
> ---
>

Looks good, it's a clear improvement on what we had before, thanks!

It doesn't re-build bpftool when bpftool sources changes, but I think
it was like that even before, so no need to block on that. Would be
nice to have a follow up fixing that, though. $(wildcard
$(BPFTOOL_DIR)/*.[ch] $(BPFTOOL_DIR)/Makefile) should do it, same as
for libbpf.

So, for the series:

Acked-by: Andrii Nakryiko <andriin@fb.com>
Tested-by: Andrii Nakryiko <andriin@fb.com>

> Toke H=C3=B8iland-J=C3=B8rgensen (11):
>       samples/bpf: Don't try to remove user's homedir on clean
>       tools/bpf/runqslower: Fix override option for VMLINUX_BTF
>       selftests: Pass VMLINUX_BTF to runqslower Makefile
>       tools/runqslower: Use consistent include paths for libbpf
>       selftests: Use consistent include paths for libbpf
>       bpftool: Use consistent include paths for libbpf
>       perf: Use consistent include paths for libbpf
>       samples/bpf: Use consistent include paths for libbpf
>       tools/runqslower: Remove tools/lib/bpf from include path
>       runsqslower: Support user-specified libbpf include and object paths
>       selftests: Refactor build to remove tools/lib/bpf from include path
>
>

[...]
