Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052CF1B7BAC
	for <lists+netdev@lfdr.de>; Fri, 24 Apr 2020 18:32:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728290AbgDXQcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Apr 2020 12:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbgDXQcw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Apr 2020 12:32:52 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E071EC09B046;
        Fri, 24 Apr 2020 09:32:51 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id 20so10734136qkl.10;
        Fri, 24 Apr 2020 09:32:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yvTKG4qIbs1fzHImShFCuuRFkRGUKN9i1kP4MfJ9u3E=;
        b=jZQRhFMoeu0rjcRJEVBgm0wPPw2jzUO7yoURe64rxwQFR6Zw6Su2ES92NQEmnt4bVW
         Z7g9F1dTJPRfQE0Bdl2yLFlaKZ+XNo4Odeg0ruKqm+Mdr+lOomUWjtUchFJ4SOhQOi1Q
         gZ/D0Z87qZTp/aMzSY3Yuq8k5oiOY5WQ8xtZSAea+XvDdXSCaTiT0XHpNgQxAc80haPG
         cKqmi8x/WWx8mOomussIglyUx3eQS5KgjHWgm0UMGd2fw72inQdg5GKfL5D+jec0j70F
         CYPwAjtYOJZObD+47DQ7J4nsLxll6Wn/xq9HL23h92Vwv71Xigu0Fga2qEgMyTUwH0ST
         pTzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yvTKG4qIbs1fzHImShFCuuRFkRGUKN9i1kP4MfJ9u3E=;
        b=iCDuyUM71G+M/HAxGvyVUh+BMLmg8U1+jGZ2EdiGplQ7mU7P0XV5I4vufvifqTEucq
         gXqA7wBFcdtBXueazQj0xJ2vN56AXD8lEnF1hLvhAue9c/ZQeUTHVJIeBazilnaBLnTt
         vat0smKzvRZ6JcQTol3aasFg8RTHrAOXgs6POtqMxolVNSoMCaCMyJiE8GmjFOHPCy5S
         mg9PpLZubj9E+LdvBL2NvA9SZfjBFKptxenXuXqrWWCRooqtOelBSDu9CIiifRDnje7g
         CKlUSaAojVe9gSImFKuJbon0oCyW4K0/jANjHJOzYu6XHFCOQklZgYey1dDUPtQCsRrI
         sJiw==
X-Gm-Message-State: AGi0PubMc0LJKgC6tKX/aJP811+2EDyqIBRmjj4/CQIbV98V+RV+C1At
        X0uJgoEvmoSXMlxaplG4DEXn9KGoRrM1/ck1MU4=
X-Google-Smtp-Source: APiQypJP9KNOKZVKdEQBEADkwpswPQS9MRai9jm0jDgxwDM7ro63rRVu5lU0omXZu30G+IK8dSw4CZabU0UDybZ5e+0=
X-Received: by 2002:ae9:e854:: with SMTP id a81mr9947548qkg.36.1587745971012;
 Fri, 24 Apr 2020 09:32:51 -0700 (PDT)
MIME-Version: 1.0
References: <20200424053505.4111226-1-andriin@fb.com> <20200424053505.4111226-10-andriin@fb.com>
 <43a50d28-4d23-fa23-6929-4f8a082de2a9@isovalent.com>
In-Reply-To: <43a50d28-4d23-fa23-6929-4f8a082de2a9@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 24 Apr 2020 09:32:39 -0700
Message-ID: <CAEf4BzYzo6zStudygctVaSj4ho0=2Qv5_9h4E4bbhEvh5pTERA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 09/10] bpftool: add bpftool-link manpage
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Apr 24, 2020 at 3:33 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> 2020-04-23 22:35 UTC-0700 ~ Andrii Nakryiko <andriin@fb.com>
> > Add bpftool-link manpage with information and examples of link-related
> > commands.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >  .../bpftool/Documentation/bpftool-link.rst    | 119 ++++++++++++++++++
> >  1 file changed, 119 insertions(+)
> >  create mode 100644 tools/bpf/bpftool/Documentation/bpftool-link.rst
> >
> > diff --git a/tools/bpf/bpftool/Documentation/bpftool-link.rst b/tools/bpf/bpftool/Documentation/bpftool-link.rst
> > new file mode 100644
> > index 000000000000..2866128cd6b2
> > --- /dev/null
> > +++ b/tools/bpf/bpftool/Documentation/bpftool-link.rst
> > @@ -0,0 +1,119 @@
> > +================
> > +bpftool-link
> > +================
> > +-------------------------------------------------------------------------------
> > +tool for inspection and simple manipulation of eBPF links
> > +-------------------------------------------------------------------------------
> > +
> > +:Manual section: 8
> > +
> > +SYNOPSIS
> > +========
> > +
> > +     **bpftool** [*OPTIONS*] **link *COMMAND*
>
> Missing the ending "**" after "**link", please fix.

will do

>
> > +
> > +     *OPTIONS* := { { **-j** | **--json** } [{ **-p** | **--pretty** }] | { **-f** | **--bpffs** } }
> > +
> > +     *COMMANDS* := { **show** | **list** | **pin** | **help** }
> > +
> > +LINK COMMANDS
> > +=============
> > +
> > +|    **bpftool** **link { show | list }** [*LINK*]
> > +|    **bpftool** **link pin** *LINK* *FILE*
> > +|    **bpftool** **link help**
> > +|
> > +|    *LINK* := { **id** *LINK_ID* | **pinned** *FILE* }
> > +
> > +
> > +DESCRIPTION
> > +===========
> > +     **bpftool link { show | list }** [*LINK*]
> > +               Show information about active links. If *LINK* is
> > +               specified show information only about given link,
> > +               otherwise list all links currently active on the system.
> > +
> > +               Output will start with link ID followed by link type and
> > +               zero or more named attributes, some of which depend on type
> > +                  of link.
>
> Nit: indent issue on the line above.

fixing

>
> > +
> > +     **bpftool link pin** *LINK* *FILE*
> > +               Pin link *LINK* as *FILE*.
> > +
> > +               Note: *FILE* must be located in *bpffs* mount. It must not
> > +               contain a dot character ('.'), which is reserved for future
> > +               extensions of *bpffs*.
> > +
> > +     **bpftool link help**
> > +               Print short help message.
> > +
> > +OPTIONS
> > +=======
> > +     -h, --help
> > +               Print short generic help message (similar to **bpftool help**).
> > +
> > +     -V, --version
> > +               Print version number (similar to **bpftool version**).
> > +
> > +     -j, --json
> > +               Generate JSON output. For commands that cannot produce JSON, this
> > +               option has no effect.
> > +
> > +     -p, --pretty
> > +               Generate human-readable JSON output. Implies **-j**.
> > +
> > +     -f, --bpffs
> > +               When showing BPF links, show file names of pinned
> > +               links.
> > +
> > +     -n, --nomount
> > +               Do not automatically attempt to mount any virtual file system
> > +               (such as tracefs or BPF virtual file system) when necessary.
> > +
> > +     -d, --debug
> > +               Print all logs available, even debug-level information. This
> > +               includes logs from libbpf.
> > +
> > +EXAMPLES
> > +========
> > +**# bpftool link show**
> > +
> > +::
> > +
> > +    10: cgroup  prog 25
> > +            cgroup_id 614  attach_type egress
> > +
> > +**# bpftool --json --pretty link show**
> > +
> > +::
> > +
> > +    [{
> > +            "type": "cgroup",
> > +            "prog_id": 25,
> > +            "cgroup_id": 614,
> > +            "attach_type": "egress"
> > +        }
> > +    ]
> > +
> > +|
> > +| **# mount -t bpf none /sys/fs/bpf/**
>
> [ Mounting should not be required, as you call
> do_pin_any()->do_pin_fd()->mount_bpffs_for_pin().
>
> Although on second thought I'm fine with keeping it, just in case users
> call bpftool --nomount. ]

It was a copy/paste from bpftool-prog.rst, but I think I'll drop it
for this one (and keep it in bpftool-prog.rst).

>
> > +| **# bpftool link pin id 10 /sys/fs/bpf/link**
> > +| **# ls -l /sys/fs/bpf/**
> > +
> > +::
> > +
> > +    -rw------- 1 root root 0 Apr 23 21:39 link
> > +
> > +
> > +SEE ALSO
> > +========
> > +     **bpf**\ (2),
> > +     **bpf-helpers**\ (7),
> > +     **bpftool**\ (8),
> > +     **bpftool-prog\ (8),
> > +     **bpftool-map**\ (8),
> > +     **bpftool-cgroup**\ (8),
> > +     **bpftool-feature**\ (8),
> > +     **bpftool-net**\ (8),
> > +     **bpftool-perf**\ (8),
> > +     **bpftool-btf**\ (8)
> >
>
