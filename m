Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A087F14318C
	for <lists+netdev@lfdr.de>; Mon, 20 Jan 2020 19:36:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727665AbgATSgJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jan 2020 13:36:09 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:33601 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726642AbgATSgI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jan 2020 13:36:08 -0500
Received: by mail-qk1-f194.google.com with SMTP id d71so219404qkc.0;
        Mon, 20 Jan 2020 10:36:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=nypa0fmcU1qrcDA/69y5vVyGSxEYCTlbnT0MYvisCOY=;
        b=n6OHQmi2Lqnt+u56UyfOnq36LdLY/90AjbbbAuc8Yi+Sexy1YUz2TZnz29vuv8c1GA
         AFxN+hfJx4ikYoOkGw7RUtlqRcJLAU/8edx7OLCcMNGYFxMzSoJpUXhWzcN0YthgGkTT
         qEG84m7Cz0WHjv1u3YwE01A4d+lgJveFYMf0YXHdOnienwPstAziOMIilVGV9PtJIHIX
         MWbMRgb1+F9w+EbiEoulZtnb+bSp/exAEqak/Jojul1Q2WjNv/tuHtTTmGFgrRZyJ2RA
         GeHNnfD1qa4l6Jnpoh8S515/p62ljovXd7MmiSVhmFRm0EnrBj4naN92dsKCe9y0YJ/9
         bxeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=nypa0fmcU1qrcDA/69y5vVyGSxEYCTlbnT0MYvisCOY=;
        b=AvFxy3JI4ndXddh7C+xS/Ort3iUVKd4c4uyCrMdlzI5NixWe24+LCFzTgfPNBh3H0v
         SBj1w4QV7K768V4sX+gDOHfZyft9vcyiHrUKBiiUNrKYvvjqdHM0HGZKIdotrkx6RRSZ
         xScC/v9cDO4kILvr4220z/Wt71CM2x2LSHle2mWvYx+PYcSNgnOvfIiwGaXwoCrxWxRH
         oLDMUY2s1jsJMn7ZEqswtG/9gMmpb8WgjAEPp6qXVBq0sMguinP03ywXCxFe9ZmBXpp5
         PdmTRqj266vPr1Nkcry2fWquDS4VrxURcJUHWQGA1HwstboKGgnI9SHIuAk0/xgNptwR
         TT9w==
X-Gm-Message-State: APjAAAWj6lBVlV5b4J1XCK/dEfr++Y6hAVW/n16lJuWMky2ggSvygR4I
        SwecOcl818WSEgeBPrZg80n3DyLI/h2Y+On1HN0=
X-Google-Smtp-Source: APXvYqyGHYkSXOZiJvAONUelyvaLJfv9/CZYkyPdYsL0xeUScApGmNT8/JruIuZcQj5K1GGwsZvg7mP2yjaYIUQCMas=
X-Received: by 2002:a05:620a:5ae:: with SMTP id q14mr871914qkq.437.1579545367408;
 Mon, 20 Jan 2020 10:36:07 -0800 (PST)
MIME-Version: 1.0
References: <157926819690.1555735.10756593211671752826.stgit@toke.dk>
 <157926820131.1555735.1177228853838027248.stgit@toke.dk> <CAEf4BzbAV0TmEUL=62jz+RD6SPmu927z-dhGL9JHepcAOGMSJA@mail.gmail.com>
 <875zh6p9pg.fsf@toke.dk>
In-Reply-To: <875zh6p9pg.fsf@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 20 Jan 2020 10:35:56 -0800
Message-ID: <CAEf4BzZ7x4F_-bjGg7TdzXcin6c1BAT6OKe53ujh1tx-GB6-ZQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 04/10] tools/runqslower: Use consistent
 include paths for libbpf
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

On Mon, Jan 20, 2020 at 4:57 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Andrii Nakryiko <andrii.nakryiko@gmail.com> writes:
>
> > On Fri, Jan 17, 2020 at 5:37 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@=
redhat.com> wrote:
> >>
> >> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >>
> >> Fix the runqslower tool to include libbpf header files with the bpf/
> >> prefix, to be consistent with external users of the library. Also ensu=
re
> >> that all includes of exported libbpf header files (those that are expo=
rted
> >> on 'make install' of the library) use bracketed includes instead of qu=
oted.
> >>
> >> To not break the build, keep the old include path until everything has=
 been
> >> changed to the new one; a subsequent patch will remove that.
> >>
> >> Fixes: 6910d7d3867a ("selftests/bpf: Ensure bpf_helper_defs.h are take=
n from selftests dir")
> >> Acked-by: Andrii Nakryiko <andriin@fb.com>
> >> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> >> ---
> >>  tools/bpf/runqslower/Makefile         |    5 +++--
> >>  tools/bpf/runqslower/runqslower.bpf.c |    2 +-
> >>  tools/bpf/runqslower/runqslower.c     |    4 ++--
> >>  3 files changed, 6 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/tools/bpf/runqslower/Makefile b/tools/bpf/runqslower/Make=
file
> >> index b62fc9646c39..9f022f7f2593 100644
> >> --- a/tools/bpf/runqslower/Makefile
> >> +++ b/tools/bpf/runqslower/Makefile
> >> @@ -5,6 +5,7 @@ LLC :=3D llc
> >>  LLVM_STRIP :=3D llvm-strip
> >>  DEFAULT_BPFTOOL :=3D $(OUTPUT)/sbin/bpftool
> >>  BPFTOOL ?=3D $(DEFAULT_BPFTOOL)
> >> +INCLUDES :=3D -I$(OUTPUT) -I$(abspath ../../lib) -I$(abspath ../../li=
b/bpf)
> >>  LIBBPF_SRC :=3D $(abspath ../../lib/bpf)
> >
> > drop LIBBPF_SRC, it's not used anymore
>
> It is: in the rule for building libbpf there's a '-C $(LIBBPF_SRC)'
>

Ah, right, missed that one. Looked a bit weird to have $(abspath
../../lib/bpf) used in INCLUDES and then separate LIBBPF_SRC
definition there, maybe

LIBBPF_SRC :=3D $(abspath ../../lib/bpf)
INCLUDES :=3D -I$(OUTPUT) -I$(abspath ../../lib) -I$(LIBBPF_SRC)

> -Toke
>
