Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D78FE2632C6
	for <lists+netdev@lfdr.de>; Wed,  9 Sep 2020 18:50:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731059AbgIIQuv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Sep 2020 12:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730949AbgIIQuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Sep 2020 12:50:23 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BAEB4C061573;
        Wed,  9 Sep 2020 09:50:17 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id v78so2201310ybv.5;
        Wed, 09 Sep 2020 09:50:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HRhoqKOaMjUGo0wuV3BB9cOJsOhVfLiE9GqfrLMzhW4=;
        b=CbisMvt5v1YsgmAqwNx1AB25QKOrh21Fv3zMv+zugu7mzeVr3ycMMDQmmDtsxJr7o0
         c1ubgFZkfldY9yrdzFSkoKASKpcQ2VYmAgF+HUBpE8xZ1X5Ho+nay3asV4ZBvut/LHaK
         3YBNEKCsDNRVFoh1oi/Ex0aMEFS/sAYx3RG53AFdJARPTouoZGGqz8MC2aV8O//lixte
         c7CkqnumHCBeeWC7GagaGicFflrIGN/SmqTqiNkW2UHB+ihvvMLX7HCM0lZfyDZnl4op
         LDcYtDIymvfltocu5H8fF4waisjnV1jtc4Z76Mfr6VXUg+HdBfHIFlrxC48OOzTSoJnv
         n7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HRhoqKOaMjUGo0wuV3BB9cOJsOhVfLiE9GqfrLMzhW4=;
        b=Vt3iLjeUxkenOPj3wCwm0SFJkcf0Rc2JW4qC+vj2X6aYfqlOKfaoc7NQgK434laWMC
         NTA4d9o0V1bKWi4pGOQ+ivkvPrgxnZlQx3dHzXib4MEx2aaFQf80h+4lyRIUcEmiU8C2
         eeyGzS42vNWNVqiFxpaxpPOvDr+7d6zsg1+D4YjIWtKKfmcxZsbycC7KPhnwbkeZtXvO
         HSn2h7PEBoVkGA9BBcCdGobzcoWBevnKRl+PR1WbRDbsC8D78qTC37GrcKWqU0jSQYMy
         PW1CDmTexlg2DblAzgtoDWMXrjkPijBd3UXxuvBiEQyOhdzVuq1w71F81TRoVH8XmyH0
         X+IA==
X-Gm-Message-State: AOAM530U93ViXd2MM2gbsh3BaZ5MABS3Lz/k6eCi7mJ5rlCXUg+MOBXb
        4T6P9iBOLWmzHLTdyn5cTryUV2hFDyO3AZM5M30=
X-Google-Smtp-Source: ABdhPJzDITwtGkoK2+UkYTiQk4eq4BfAKmh720EHXw6Ixr1/ykj6m+C6RkA+1LkI7SJApAwstq2BcAbZKvu4JPm0L0c=
X-Received: by 2002:a25:ef43:: with SMTP id w3mr6303805ybm.230.1599670215738;
 Wed, 09 Sep 2020 09:50:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200909162500.17010-1-quentin@isovalent.com> <20200909162500.17010-2-quentin@isovalent.com>
In-Reply-To: <20200909162500.17010-2-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 9 Sep 2020 09:50:04 -0700
Message-ID: <CAEf4Bzak0hyia3EDFnT-HZrE=LHp=GbQ5yX_OWOkfOmtX8OC5g@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/3] tools: bpftool: print optional built-in
 features along with version
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 9:25 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Bpftool has a number of features that can be included or left aside
> during compilation. This includes:
>
> - Support for libbfd, providing the disassembler for JIT-compiled
>   programs.
> - Support for BPF skeletons, used for profiling programs or iterating on
>   the PIDs of processes associated with BPF objects.
>
> In order to make it easy for users to understand what features were
> compiled for a given bpftool binary, print the status of the two
> features above when showing the version number for bpftool ("bpftool -V"
> or "bpftool version"). Document this in the main manual page. Example
> invocations:
>
>     $ bpftool version
>     ./bpftool v5.9.0-rc1
>     features: libbfd, skeletons
>
>     $ bpftool -p version
>     {
>         "version": "5.9.0-rc1",
>         "features": {
>             "libbfd": true,
>             "skeletons": true
>         }
>     }
>
> Some other parameters are optional at compilation
> ("DISASM_FOUR_ARGS_SIGNATURE", LIBCAP support) but they do not impact
> significantly bpftool's behaviour from a user's point of view, so their
> status is not reported.
>
> Available commands and supported program types depend on the version
> number, and are therefore not reported either. Note that they are
> already available, albeit without JSON, via bpftool's help messages.
>
> v3:
> - Use a simple list instead of boolean values for plain output.
>
> v2:
> - Fix JSON (object instead or array for the features).
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/bpf/bpftool/Documentation/bpftool.rst |  8 ++++-
>  tools/bpf/bpftool/main.c                    | 33 +++++++++++++++++++--
>  2 files changed, 38 insertions(+), 3 deletions(-)
>

[...]
