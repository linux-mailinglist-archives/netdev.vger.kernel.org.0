Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D5277285209
	for <lists+netdev@lfdr.de>; Tue,  6 Oct 2020 21:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726963AbgJFTFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Oct 2020 15:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726760AbgJFTFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Oct 2020 15:05:35 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4213C061755;
        Tue,  6 Oct 2020 12:05:34 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id u8so16266563lff.1;
        Tue, 06 Oct 2020 12:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dbgm9EPpdn69MOQOGW1NmOkPRWAvrhHZv3YgGUWUYO4=;
        b=nCuVvffNUqX3JHoJTL9N3FEG+N30Jd67eXqBiN11gRdobkj619iU7qnZfhWN2CSEyh
         IyJhCzb9gliT0Hm24v2E+9076qVfyt08uSMi6g502CXaooTTt/s/riIq+fnwdt+LvWw0
         xg3lQ5LM38VN/83InIxsW33CTndDLDt+uLVSrAjiy/Hfbj5tuhMO1vb46/88sGJbPmoQ
         oLcQokDa8/8s7nHNZYPUE2LqIkKukXI64kI/Bg3Yltk58eNsCaVVZTNWK8AliJwUJCjF
         znWN2uG/Bfym9eoD6L5xgV4Nl6YUxKrN5p3FXF+KqjJ34pWwSGy2ypFvtUCAWjcmOC3O
         x2RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dbgm9EPpdn69MOQOGW1NmOkPRWAvrhHZv3YgGUWUYO4=;
        b=Uzxp3uARMDC6WwQV5yzziD44cjP0oQxNtUcj1kUG2Y0cjCKXpUrPDwViVnD1iAe4lZ
         zeFtufERoLvtc0vXWGfqsh9p24f93moAEFqpCZ57D49cEBguJ0S47xnfElTdP+cIguR3
         k+Bzj+aVXM6/kp+62PjQ24nXaP5Nnh70ot6COJbfj4exvcJWxF6YEIgXDyOObbGrswOO
         Tpv4Xk7IEuPtH0+HO8xMxQ8Qa06yCmz60XxmGuZtc/MqTQMKUbeh+lxwqv7z8ijNEZTT
         6Ikp1mDECjVCSoLDFPyYW0geUcI02wDrfBq5gGBjaq3YDiR/GC/58g5i7jjPnTauAA01
         tkFA==
X-Gm-Message-State: AOAM532jgeylR6abF9/s0LHMjW7elemkIo8gH115puiODQ46NysOzWoD
        +rtAYa5lxWgere7ximHUHucPJJKbkt2cqNvun4U=
X-Google-Smtp-Source: ABdhPJwjRtjH65ntww7uSgF852KSTpZTpwRT5o9+a5Afmw3wub9NAuaJ2GJkzguay1vK1/vQdch8KAwchaYlo+9Ohr4=
X-Received: by 2002:a19:8457:: with SMTP id g84mr890012lfd.500.1602011132919;
 Tue, 06 Oct 2020 12:05:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200929235049.2533242-1-haoluo@google.com> <20200929235049.2533242-2-haoluo@google.com>
In-Reply-To: <20200929235049.2533242-2-haoluo@google.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 6 Oct 2020 12:05:21 -0700
Message-ID: <CAADnVQKc4m6X62udhpPE3EBBvuOA2ngyWSOKQ7fc-rtqdeQj6w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v4 1/6] bpf: Introduce pseudo_btf_id
To:     Hao Luo <haoluo@google.com>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, Shuah Khan <shuah@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 29, 2020 at 4:50 PM Hao Luo <haoluo@google.com> wrote:
>
> -       ret = replace_map_fd_with_map_ptr(env);
> -       if (ret < 0)
> -               goto skip_full_check;
> -
>         if (bpf_prog_is_dev_bound(env->prog->aux)) {
>                 ret = bpf_prog_offload_verifier_prep(env->prog);
>                 if (ret)
> @@ -11662,6 +11757,10 @@ int bpf_check(struct bpf_prog **prog, union bpf_attr *attr,
>         if (ret)
>                 goto skip_full_check;
>
> +       ret = resolve_pseudo_ldimm64(env);
> +       if (ret < 0)
> +               goto skip_full_check;
> +

Hao,

this change broke several tests in test_verifier:
#21/u empty prog FAIL
Unexpected error message!
    EXP: unknown opcode 00
    RES: last insn is not an exit or jmp

#656/u test5 ld_imm64 FAIL
Unexpected error message!
    EXP: invalid bpf_ld_imm64 insn
    RES: last insn is not an exit or jmp

#656/p test5 ld_imm64 FAIL
Unexpected error message!
    EXP: invalid bpf_ld_imm64 insn
    RES: last insn is not an exit or jmp

Please send a fix.
Thanks
