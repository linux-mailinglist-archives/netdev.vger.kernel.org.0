Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E054313FC1D
	for <lists+netdev@lfdr.de>; Thu, 16 Jan 2020 23:22:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388885AbgAPWWS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jan 2020 17:22:18 -0500
Received: from mail-qk1-f193.google.com ([209.85.222.193]:33971 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730215AbgAPWWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jan 2020 17:22:18 -0500
Received: by mail-qk1-f193.google.com with SMTP id j9so20866101qkk.1;
        Thu, 16 Jan 2020 14:22:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qu8zsYEQSOGvlAbndsI8B4OVOYDln+jaEykMs8+9aA0=;
        b=MUppkF8fgonZXa65+K2SwN3Fynh8vrRWPCyusCTq5jPUpHXI4TyaLsR/tnoXfAybjH
         G4UkfQgJdweg97OPxc8Sw6CmS4FwFCiAlFMrQZIBHybCxF+Y9DZgwvyQxS936WjpJ0/g
         tXBDsm5zyPX2VXhJrFd0JXegD9jNXAplE0hxPfNcDblhvrGeNVtEoE0S8bMmqRZxCqW3
         gvEElVgJ9THBA9q2Wx58ZJe7gOExZMftxs78M4JW3XM7kh7o5xFBf0Fu5+ww0SLi3XkS
         03K1AcuM2UVeBrsk8UpmXNDh6bJOI03q9oM2+aLdEige+HaokXStaSoWXo8n3vrVkgBH
         6HQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qu8zsYEQSOGvlAbndsI8B4OVOYDln+jaEykMs8+9aA0=;
        b=PkQHno+5lwVNRowEZUBuwOw5dWIHbLYPnNmHTPhN/Mv0bOeHdShP88OtR9kKyrEE9K
         M7kEHMxNzoC18DoDg9df17VF79RWjJ6hPBx87ZO6IvYz99xg8UyAjAQWK/3Ecp2WhYLy
         u7SKR77vT8ct9dzoVt7G14j1CzavG1Hm8hSVKkwsoyL/LwuIz9A6YtbljfscEUrxJQiR
         QTifh/O4JamY70tCLHJFBNEm3QPr4OkEO5uE76xooo6Fz041A0zNZXULuwJHBSqvJt+u
         SrwtOjunFU87N+H/7UMaqLjVYZqeDHqJOCxE7cfDCaJc1PsOR+EMem35aKmIKxDLzwz6
         MbWg==
X-Gm-Message-State: APjAAAU+TU/le9Zsg22JaKcqT8ZFBaggKZ0bO9cW4T3iCFL5Vrmy7swJ
        Otf/frpQKxKUsB9erelLwS7CfRNIOlQ5X92ds3M=
X-Google-Smtp-Source: APXvYqxtid0fvv+v5tQ70OhH2B5eczuqAo31GP4tfo4vZa5+OnKdFsUhTm/s93hAWg7deXqPzrFv7FuAzVqhC/hLAV4=
X-Received: by 2002:a37:e408:: with SMTP id y8mr35164194qkf.39.1579213337033;
 Thu, 16 Jan 2020 14:22:17 -0800 (PST)
MIME-Version: 1.0
References: <157918093154.1357254.7616059374996162336.stgit@toke.dk> <157918093952.1357254.13512235914811343382.stgit@toke.dk>
In-Reply-To: <157918093952.1357254.13512235914811343382.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Jan 2020 14:22:05 -0800
Message-ID: <CAEf4BzZZLt4_ZdFgN7eJhHnAdpkZJROUNCozeMbZ-qTUr_7-mA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 07/11] perf: Use consistent include paths for libbpf
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

On Thu, Jan 16, 2020 at 5:23 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> Fix perf to include libbpf header files with the bpf/ prefix, to
> be consistent with external users of the library.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/perf/examples/bpf/5sec.c             |    2 +-
>  tools/perf/examples/bpf/empty.c            |    2 +-
>  tools/perf/examples/bpf/sys_enter_openat.c |    2 +-
>  tools/perf/include/bpf/pid_filter.h        |    2 +-
>  tools/perf/include/bpf/stdio.h             |    2 +-
>  tools/perf/include/bpf/unistd.h            |    2 +-
>  6 files changed, 6 insertions(+), 6 deletions(-)
>

[...]
