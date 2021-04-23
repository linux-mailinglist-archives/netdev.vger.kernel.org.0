Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11B34368B18
	for <lists+netdev@lfdr.de>; Fri, 23 Apr 2021 04:35:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240007AbhDWCf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 22:35:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236624AbhDWCfr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 22:35:47 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0098C06174A;
        Thu, 22 Apr 2021 19:35:09 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id j4so35773905lfp.0;
        Thu, 22 Apr 2021 19:35:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=fT+wuI0S9Sab/F03h/fYstaaOmIfLT5tBqkj5kfQlQs=;
        b=IEM1r8TkEeF0wHB7Z4Wxu9v0xouZbWdWj8nTye2y4LQBQ+kfFkhmvwsckaahAc4HIp
         29KySjkyJiXpj973LmB55DncdRnnigojxBYc7ei3KvFeOGnVyFb+aumoLqoyhbVRbeZ5
         +D8AN+XqHXG02mFpW0RmC+2Nwqcpgq39e8Xr4MziKOuZPUAjMIomOqdroAVIrrVfSE8l
         6fFDE4nAts4+KG1k7uwJWFlGnS0DRjszBKn4bJ3B2fOYO1W/rHablfdjBmNOpmM1m3P2
         dcN6lxF0YFOC5n95dJHbw0a2Ft0zWD0p983mROWN1U/5Vu8meLiTWr3yLocxEIiP+ID1
         qc4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=fT+wuI0S9Sab/F03h/fYstaaOmIfLT5tBqkj5kfQlQs=;
        b=Cm5kIihVLGffvsVMLbGwhg94QGAACPHD9IOoquDwaMraJNiiJhDBv/wtDdaBpovT0Y
         Q7HFdmwgI3cBXCOUsmNU0pZ7HTWu7AQLS5BVE9yFP3jGQboNl1wZOAZgMzmieeKL4gDM
         nD4ifZVNbsBmQq5ePuoim+ejGAldzgMAumTfNuU/otV1y+5lqa3V0SpYjkV6fOjUyT+F
         eU68xOtJVjkarXsWIQBGbN7ssvdDU+PmlcIAIrF9jW9AIpphXtDf52gCIaYuhRBvu7LV
         D7+g9AK+8PJCzcGL6taZopK1apdexgGkAdzSCXqi9Ns5s0QhGKhp7caFoY13LdQgcFbT
         PzOQ==
X-Gm-Message-State: AOAM531WCbDKIVuHU8CacKjnVY0e2zYeFZkIsThPIHhgYyBmbv9jUkCz
        aYdkwv/6k+fAJZWb+GoWBx/gElGkZfWXwv8n+F8=
X-Google-Smtp-Source: ABdhPJwf7RckkYizgCEXAByYvtsrcJ84JePCkxFG+9CkAkCqzNL9ZhWdlwK6w2eAUb0jboCVHxuAwIv8t4yOMqiqQew=
X-Received: by 2002:ac2:510d:: with SMTP id q13mr1006276lfb.75.1619145308404;
 Thu, 22 Apr 2021 19:35:08 -0700 (PDT)
MIME-Version: 1.0
References: <20210416202404.3443623-1-andrii@kernel.org> <20210416202404.3443623-16-andrii@kernel.org>
 <3947e6ff-0b73-995e-630f-4a1252f8694b@fb.com>
In-Reply-To: <3947e6ff-0b73-995e-630f-4a1252f8694b@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 22 Apr 2021 19:34:57 -0700
Message-ID: <CAADnVQKjasq6sf_AFjGOkoWCeZ5_SJTYzuvWb_byHe32FHS5Vw@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 15/17] selftests/bpf: add function linking selftest
To:     Yonghong Song <yhs@fb.com>
Cc:     Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Apr 22, 2021 at 5:51 PM Yonghong Song <yhs@fb.com> wrote:
> > +
> > +/* weak and shared between two files */
> > +const volatile int my_tid __weak = 0;
> > +const volatile long syscall_id __weak = 0;
>
> Since the new compiler (llvm13) is recommended for this patch set.
> We can simplify the above two definition with
>    int my_tid __weak;
>    long syscall_id __weak;
> The same for the other file.
>
> But I am also okay with the current form
> to *satisfy* llvm10 some people may still use.

The test won't work with anything, but the latest llvm trunk,
so " = 0" is useless.
Let's remove it.
Especially from the tests that rely on the latest llvm.
No one can backport the latest llvm BPF backend to llvm10 front-end.
