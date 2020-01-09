Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E0DC136310
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 23:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729028AbgAIWJk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jan 2020 17:09:40 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:47053 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgAIWJk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jan 2020 17:09:40 -0500
Received: by mail-pl1-f193.google.com with SMTP id y8so3213pll.13;
        Thu, 09 Jan 2020 14:09:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=6x2nzt/IgqQsDL2AgajsJQAamXv/hJ+H+mrlbWRzayQ=;
        b=rnWzozpdzGcFHKvW5hTisRybfPRT+BTk91Ss3uxvNHLHCJZld8Ll8VAwkr6oNDrT17
         vobqa67tdzxsdZBLK1bfmrIMe5shVhreHjO+DB1aYq4j4PGNHl+V8zMlnEozVxr5xykN
         OO5KTR/jyNnX0v2BZjJ6kTCP3pwcBGWbD92SYJXbKN/YUTGb1ycN1g9efg7x6DI24QRT
         JI8O0/j6IDh0nvmPPtsQ6F8nLgxDgcKE6keL07sXDjrHb8WIYFc0D5pkMyR1ydglOYJG
         s0EYz1b466znEj2xt8KUWsywwLwlDbm1DaX7FW5CseGVULE+b/kVJ+fXnrKq2szpOzOM
         NTwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=6x2nzt/IgqQsDL2AgajsJQAamXv/hJ+H+mrlbWRzayQ=;
        b=gFKyTrlFX1Q18XvxqbvL6vBG6AYkVc8WbkWIe3QZSVUswTNsNfaInmQcAkdGgPnvZt
         x1ZsEwtWL29kXwymM6JsvsgsW8iCIYnY05yP77CxW2ImG8Z0ushpeTeDOZYsdBfIWShn
         CdCG5aYdrlO3d8XG6i/P7UNhoKUTb2rMdfEST7UCvEI8DTreMZz6HBvTyE8IZPS7R1x6
         rzOBTeiRs2tmX4ZYu2J3gO34VQliQMzj3XSVqXVDtpSixtZ8Dyzz/B7vgCSv6MncTjDi
         q449YKlgzKp5L0wjSSRvpvderdKfJ71o6MeKlxazU8V2P3MXhSOcXJ6suhmg+ncNsXLR
         042A==
X-Gm-Message-State: APjAAAX/xWUkd6gtyBEUSEu1Ar+dHxV3dqhID0iY2S7/m45+zN3B7Ood
        Sljev6+yGwtLFfJdhAc/As8=
X-Google-Smtp-Source: APXvYqxrTsiQJ2VL7caXsg90NxsKSeUtFOh4mShw9buAb/aqV4YASVBFynXqOc//MpGCNb42IdPqug==
X-Received: by 2002:a17:90a:1a14:: with SMTP id 20mr370556pjk.33.1578607779361;
        Thu, 09 Jan 2020 14:09:39 -0800 (PST)
Received: from ast-mbp ([2620:10d:c090:200::3:d3c9])
        by smtp.gmail.com with ESMTPSA id d4sm16560pjz.12.2020.01.09.14.09.37
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 09 Jan 2020 14:09:38 -0800 (PST)
Date:   Thu, 9 Jan 2020 14:09:37 -0800
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Song Liu <song@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 7/7] selftests/bpf: Add unit tests for global
 functions
Message-ID: <20200109220935.iyabjybd5bsesszy@ast-mbp>
References: <20200109063745.3154913-1-ast@kernel.org>
 <20200109063745.3154913-8-ast@kernel.org>
 <CAPhsuW67HfWZ7JLMWtXSURc97SSP4MOT7d65F+r075qGqpW9Cg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPhsuW67HfWZ7JLMWtXSURc97SSP4MOT7d65F+r075qGqpW9Cg@mail.gmail.com>
User-Agent: NeoMutt/20180223
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 09, 2020 at 09:27:26AM -0800, Song Liu wrote:
> On Wed, Jan 8, 2020 at 10:39 PM Alexei Starovoitov <ast@kernel.org> wrote:
> >
> > test_global_func[12] - check 512 stack limit.
> > test_global_func[34] - check 8 frame call chain limit.
> > test_global_func5    - check that non-ctx pointer cannot be passed into
> >                        a function that expects context.
> > test_global_func6    - check that ctx pointer is unmodified.
> >
> > Signed-off-by: Alexei Starovoitov <ast@kernel.org>
> 
> Acked-by: Song Liu <songliubraving@fb.com>
> 
> > ---
> >  .../bpf/prog_tests/test_global_funcs.c        | 81 +++++++++++++++++++
> >  .../selftests/bpf/progs/test_global_func1.c   | 45 +++++++++++
> >  .../selftests/bpf/progs/test_global_func2.c   |  4 +
> >  .../selftests/bpf/progs/test_global_func3.c   | 65 +++++++++++++++
> >  .../selftests/bpf/progs/test_global_func4.c   |  4 +
> >  .../selftests/bpf/progs/test_global_func5.c   | 31 +++++++
> >  .../selftests/bpf/progs/test_global_func6.c   | 31 +++++++
> >  7 files changed, 261 insertions(+)
> >  create mode 100644 tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func1.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func2.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func3.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func4.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func5.c
> >  create mode 100644 tools/testing/selftests/bpf/progs/test_global_func6.c
> >
> > diff --git a/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > new file mode 100644
> > index 000000000000..bc588fa87d65
> > --- /dev/null
> > +++ b/tools/testing/selftests/bpf/prog_tests/test_global_funcs.c
> > @@ -0,0 +1,81 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/* Copyright (c) 2020 Facebook */
> > +#include <test_progs.h>
> > +
> > +const char *err_str;
> > +bool found;
> > +
> > +static int libbpf_debug_print(enum libbpf_print_level level,
> > +                             const char *format, va_list args)
> > +{
> > +       char *log_buf;
> > +
> > +       if (level != LIBBPF_WARN ||
> > +           strcmp(format, "libbpf: \n%s\n")) {
> > +               vprintf(format, args);
> > +               return 0;
> > +       }
> > +
> > +       log_buf = va_arg(args, char *);
> > +       if (!log_buf)
> > +               goto out;
> > +       if (strstr(log_buf, err_str) == 0)
> > +               found = true;
> > +out:
> > +       printf(format, log_buf);
> > +       return 0;
> > +}
> 
> libbpf_debug_print() looks very useful. Maybe we can move it to some
> header files?

I think it's hack that goes deep into libbpf internals that should be
discouraged. It's clearly very useful for selftests, but imo libbpf's log_buf
api should be redesigned instead. It's imo the worst part of the library.
