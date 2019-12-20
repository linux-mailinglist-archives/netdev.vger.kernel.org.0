Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CAE7D12818E
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 18:40:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727425AbfLTRkn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 12:40:43 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:42206 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727388AbfLTRkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 12:40:43 -0500
Received: by mail-qk1-f194.google.com with SMTP id z14so7029173qkg.9;
        Fri, 20 Dec 2019 09:40:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XZFNhoRrxtCB+S7FJpn65Ci+dD1qswIKRhfNfQY5Dqk=;
        b=O03o6qNcP4cmLtKJoFhgnrJA7j2YJJLc4U6sbm9s8msbCeMIM4j2NP0I9dYDx8XmX6
         Lxb7SFh75q5iQrTAkTCpaGBX8wFfOepvqouIC5X+U0237U4SRf1RP7VPOPemT1KYzTnH
         yAGqfN0bXBAmb5DuiQ/42MZKWsphIJYD9pA97ifgVRM03adWZaPR3iPtQ8yvR/3q5FSl
         jjApVoN8PzyWdmJ80z9MOLHon+J5cSJygc+W71k2Es3pP+V7GBVf1T2oMmn9DMTBLhPZ
         xvfW+8S06TSlctjQDiLUUXAJ1kFIe1mjm3K8c7AjfStJ3R8iZhySBqln8otOoNUcwC/y
         6fjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XZFNhoRrxtCB+S7FJpn65Ci+dD1qswIKRhfNfQY5Dqk=;
        b=hm04P/WzN8rxFSKW8Us0E1hNXwEOhii2+jufbSDhYkgkU6q8lZvv0U8z0IFDG7W9ls
         BXOSJIwVckVbB1zK600bJP/+aHBAXn6MQYZyzjRV0qEAs1n1kTHi/5Cq/Pb/W/cPsO7Q
         Azd0/0+DqzlW7ZTePyT5t99OTYt09NTvTrMZr/K2+v+lnuqypufOt5BLANRGupgzmE1S
         TE9IszQ5jcVbVXkdCQqWrfivKKbwIWasXJKB4S1071UbfLNlAprcnHF5d+H3V6lqeRNX
         GsdutCTV0VzWSp/YQoqaj9AjWKGakybJBvf9waqHMmODL57b/XriI9b+xRN96MMYuY0T
         WxqQ==
X-Gm-Message-State: APjAAAVZpupdGHnU0lWbUC0nd2wiuQwFVZC3N/9EBkI5cYewZ1FD9LcR
        4WSdFJ9HgIhhk413Mx4VpdjNe7eVmEXVaNxaFG50Ms2A
X-Google-Smtp-Source: APXvYqyaMJM6UECEqqisSOVjuh0v4cqFDn4yW/5pJGZXnJqp2MDyfh9BY4fge5ve58luEd6+JIlc7ZL6SemRyxgde1w=
X-Received: by 2002:a37:a685:: with SMTP id p127mr15044368qke.449.1576863642102;
 Fri, 20 Dec 2019 09:40:42 -0800 (PST)
MIME-Version: 1.0
References: <20191219070659.424273-1-andriin@fb.com> <20191219070659.424273-2-andriin@fb.com>
 <20191219170602.4xkljpjowi4i2e3q@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYKf=+WNZv5HMv=W8robWWTab1L5NURAT=N7LQNW4oeGQ@mail.gmail.com> <20191219220402.cdmxkkz3nmwmk6rc@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191219220402.cdmxkkz3nmwmk6rc@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 20 Dec 2019 09:40:31 -0800
Message-ID: <CAEf4Bzayg2UZi1H1NZaFgAUabtS5a=-yCE7NsUmtaO7kS5CJmw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] bpftool: add extra CO-RE mode to btf dump command
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
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

On Thu, Dec 19, 2019 at 2:04 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Thu, Dec 19, 2019 at 01:07:38PM -0800, Andrii Nakryiko wrote:
> > On Thu, Dec 19, 2019 at 9:06 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Wed, Dec 18, 2019 at 11:06:56PM -0800, Andrii Nakryiko wrote:
> > > > +     if (core_mode) {
> > > > +             printf("#if defined(__has_attribute) && __has_attribute(preserve_access_index)\n");
> > > > +             printf("#define __CLANG_BPF_CORE_SUPPORTED\n");
> > > > +             printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
> > > > +             printf("#endif\n\n");
> > >
> > > I think it's dangerous to automatically opt-out when clang is not new enough.
> > > bpf prog will compile fine, but it will be missing co-re relocations.
> > > How about doing something like:
> > >   printf("#ifdef NEEDS_CO_RE\n");
> > >   printf("#pragma clang attribute push (__attribute__((preserve_access_index)), apply_to = record)\n");
> > >   printf("#endif\n\n");
> > > and emit it always when 'format c'.
> > > Then on the program side it will look:
> > > #define NEEDS_CO_RE
> > > #include "vmlinux.h"
> > > If clang is too old there will be a compile time error which is a good thing.
> > > Future features will have different NEEDS_ macros.
> >
> > Wouldn't it be cleaner to separate vanilla C types dump vs
> > CO-RE-specific one? I'd prefer to have them separate and not require
> > every application to specify this #define NEEDS_CO_RE macro.
> > Furthermore, later we probably are going to add some additional
> > auto-generated types, definitions, etc, so plain C types dump and
> > CO-RE-specific one will deviate quite a bit. So it feels cleaner to
> > separate them now instead of polluting `format c` with irrelevant
> > noise.
>
> Say we do this 'format core' today then tomorrow another tweak to vmlinux.h
> would need 'format core2' ? I think adding new format to bpftool for every

No, not at all, it will stay within `format core`. If we need to do
some parameterized tweak to BPF CO-RE-targeted vmlinux.h, then we'll
have to add this parameter (even though I'd try to avoid
parameterizing it as much as possible, of course).


> little feature will be annoying to users. I think the output should stay as
> 'format c' and that format should be extensible/customizable by bpf progs via
> #define NEEDS_FEATURE_X. Then these features can grow without a need to keep
> adding new cmd line args. This preserve_access_index feature makes up for less
> than 1% difference in generated vmlinux.h. If some feature extension would
> drastically change generated .h then it would justify new 'format'. This one is
> just a small tweak. Also #define NEEDS_CO_RE is probably too broad. I think

This one is a small line-number-wise. But the big difference between
`format c` and `format core` is that the latter assumes we are dumping
*vmlinux's BTF* for use with *BPF CO-RE from BPF side*. `format c`
doesn't make any assumptions and faithfully dumps whatever BTF
information is provided, which can be some other BPF program, or just
any userspace program, on which pahole -J was executed.

This assumption is why I think we should separate those two formats.
For `format core` we can start auto-generating extra helper types,
similarly how BCC auto-generates them for tracepoint, for example.

Technically, sure, we can always guard everything behind extra
#ifdefs, but think about dumping BTF type info for your small BPF
program, and instead of seeing clean dump of types, you see all those
crazy #ifdefs and weird #pragma clang's, extra attributes and so on.
Not a great user experience for sure.


> #define CLANG_NEEDS_TO_EMIT_RELO would be more precise and less ambiguous.
