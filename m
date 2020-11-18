Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFBBC2B7647
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 07:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726216AbgKRG1F (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 01:27:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgKRG1E (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 01:27:04 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD0E4C0613D4;
        Tue, 17 Nov 2020 22:27:02 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id c17so936163wrc.11;
        Tue, 17 Nov 2020 22:27:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lXz5B4qekJH/fk2qKK6NBevpB96KXoRz/s7GcLEF5U4=;
        b=DE4SAyk3XORT+kK0N5DWBXmPo3mdQuXKcv5cm9vQVv/HYCaTPMs7PBxfgL1HACzHBq
         axhkBL10gEOWJXh9c19JSHYK0MgqkmD/vrbWb3lOfkGUHhY4TfiLf9wwzA0C5vPKstpz
         0WZ0st23WcIWKtQH4IT1t4s0ffY8h0EPA6Ly85HLJLSgMPkfLJiakA6koh3e99SM/V6H
         nfq29rv+1FQqeTQmSTa3SDdtd40dcUD/IRPNldh6YSC/LjnoEktXHn1zOBItZEjN2m/0
         SAEqqoyclOhJOt2H7GoSgfFnWNZVHnTXena6XwZCN+ZOkNEs3bBi9CMwrjnsjqyUrkiu
         +RXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lXz5B4qekJH/fk2qKK6NBevpB96KXoRz/s7GcLEF5U4=;
        b=TEaRopx853f9fYGhxCc/KB8ID40EKsTRGz2843DMFCruJIg+QWHX2JVt5qnrlJArcK
         5GLdXhIyFap8OgNPLU2NWeE8po5jlFSbBuBt4HsdaUBPmGiHb155fCs3eBW5DlYtCB/p
         aChZH4I/QlKB4IvA+KBK4N16CYEiB2aZG3VHKAI4qGbmAEJOBAEeMsYuBXLuuP4DEMMy
         bL5ONKWdndbyREACryfO7DhfelBisN7FqoFPAeoKhHJti9wkzJ0RHv4+r6r8COTUyWtz
         zf9sJtVgX1m/mfACOY/+VTQQyamTcvXgyicGh58OgSeNQmCAgLixKFF/CTzWK8Cp2VD+
         eWvg==
X-Gm-Message-State: AOAM531yD6ugIImUsBXEv4QtHdtZvfTtfPba1ld/5aJY8F/VuodpiGCe
        gKiG4gpMUv7MlYF8/6M7cS/e4yDOuQkJaBQNqQI=
X-Google-Smtp-Source: ABdhPJxdy7gCitothb88OWtajGPi5c7klssjgVfpw5G21ZUc+qimbGysM4gJHTZxY9HqJOXMppOMZ8xNiTM228mjW6A=
X-Received: by 2002:adf:f241:: with SMTP id b1mr3080042wrp.248.1605680821480;
 Tue, 17 Nov 2020 22:27:01 -0800 (PST)
MIME-Version: 1.0
References: <20201117082638.43675-1-bjorn.topel@gmail.com> <20201117082638.43675-2-bjorn.topel@gmail.com>
 <CAEf4BzYJRqf4ho3hSmXWi2oTMts69ix8nODcoePmnUfg+jjdbQ@mail.gmail.com>
In-Reply-To: <CAEf4BzYJRqf4ho3hSmXWi2oTMts69ix8nODcoePmnUfg+jjdbQ@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 18 Nov 2020 07:26:49 +0100
Message-ID: <CAJ+HfNgL5a4o-EF3-F21dxsauG0cyNSyuNOp+HsrbXkjWCBG_w@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: Fix broken riscv build
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Xi Wang <xi.wang@gmail.com>,
        Luke Nelson <luke.r.nels@gmail.com>,
        linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 at 02:43, Andrii Nakryiko <andrii.nakryiko@gmail.com> w=
rote:
>
> On Tue, Nov 17, 2020 at 12:28 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail=
.com> wrote:
> >
> > The selftests/bpf Makefile includes system include directories from
> > the host, when building BPF programs. On RISC-V glibc requires that
> > __riscv_xlen is defined. This is not the case for "clang -target bpf",
> > which messes up __WORDSIZE (errno.h -> ... -> wordsize.h) and breaks
> > the build.
> >
> > By explicitly defining __risc_xlen correctly for riscv, we can
> > workaround this.
> >
> > Fixes: 167381f3eac0 ("selftests/bpf: Makefile fix "missing" headers on =
build with -idirafter")
> > Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com>
> > ---
> >  tools/testing/selftests/bpf/Makefile | 3 ++-
> >  1 file changed, 2 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selft=
ests/bpf/Makefile
> > index c1708ffa6b1c..9d48769ad268 100644
> > --- a/tools/testing/selftests/bpf/Makefile
> > +++ b/tools/testing/selftests/bpf/Makefile
> > @@ -219,7 +219,8 @@ $(RESOLVE_BTFIDS): $(BPFOBJ) | $(BUILD_DIR)/resolve=
_btfids  \
> >  # build would have failed anyways.
> >  define get_sys_includes
> >  $(shell $(1) -v -E - </dev/null 2>&1 \
> > -       | sed -n '/<...> search starts here:/,/End of search list./{ s|=
 \(/.*\)|-idirafter \1|p }')
> > +       | sed -n '/<...> search starts here:/,/End of search list./{ s|=
 \(/.*\)|-idirafter \1|p }') \
> > +       $(shell $(1) -dM -E - </dev/null | grep '#define __riscv_xlen '=
 |sed 's/#define /-D/' | sed 's/ /=3D/')
>
> just nits: second $(shell ) invocation should be at the same
> indentation level as the first one
>
> also '|sed' -> '| sed' ?
>
> Otherwise I have no idea what this does and no way to try it on
> RISC-V, but it doesn't break my setup, so I'm fine with it. ;)
>

:-) I'll fix it up in v2.
