Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E25A73034F6
	for <lists+netdev@lfdr.de>; Tue, 26 Jan 2021 06:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726226AbhAZFbJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Jan 2021 00:31:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731954AbhAZB1P (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Jan 2021 20:27:15 -0500
Received: from mail-yb1-xb33.google.com (mail-yb1-xb33.google.com [IPv6:2607:f8b0:4864:20::b33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A26C0698D4;
        Mon, 25 Jan 2021 17:26:26 -0800 (PST)
Received: by mail-yb1-xb33.google.com with SMTP id e67so15203083ybc.12;
        Mon, 25 Jan 2021 17:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TJ1MOV1sLhRzD9dsnoNfW9onPTJTHyufrbfsglTYLYQ=;
        b=EfJnubrvjHb/BqtUfrnZejoWcTf9CKQc0Og7bC1Qegt44CrVRVvWyCj+mpxY3JyQqk
         fYPnLZcyGJqg1VImtwoi5KWF7G270cHWfxzfe9DvqrtYiUVaF2sQqydLA55F13TGwzWg
         9CA4KjsskKyLY4SOtQY6jvr5dAF5thLrqC1xCilHbXryaud7WU1XZjpLqyxFpx/jLWRU
         BgvVfLoZx0WL5Ca6z7K25AMl4G5MKzVOMuGMNJID0m/gC0slR2u6DMb4q4PpyG3ealyg
         SGTNKV6tqkdv7OHJPB6fhpWzKmpJ5K35iqQUN8/EDdUPWvsCxiMSTabSSPc6Dg2kzgHJ
         JC6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TJ1MOV1sLhRzD9dsnoNfW9onPTJTHyufrbfsglTYLYQ=;
        b=KSx1B8XM4FiEdzVRwpTqm5FiIifSUVDuV86w6n1JrGukAg+zcKsuC+3EiRFhyo1Z0C
         2WicrjiPDo/QZ0rjy2BREOC/7lEQU4kmpgkFTWqccVz4kHloM4oSd2Gtq8Jv4PPSUCrl
         7bUWpDSuyfSzAy44iFeM8ntEQ5GpkJ8LeMygmmwHgvIAr1GP8ENGWD9ph4cc7ZTo3HSa
         2EJhyQlrBFWk519I1X/p9caVuFN6AXXw+zFtYlMFJZu7sE656t6JOx84aaUrpAwovqBI
         wRHFTuunREcjXHytqzWUwqUPu5I93p0N3BRzXGy9yx13wQ4Dz2pKj+439qWlkJnaWLsE
         jIrw==
X-Gm-Message-State: AOAM530jc3CgNpP1bX6Lj/dTDLoIltBgchc85jS9oaOqSr+0ZHuoH0mF
        JiU6v//IZuLmdBuXDdYBMtXrWO6WSv0xjWtYMew=
X-Google-Smtp-Source: ABdhPJx04na/2x4JVJ5DEA6knJaGMhDp8y0R7IZqRkqqcdm2FlMlj1ZM8po33S7jTgUBspPx+yrOMQNV6cTrs6GkENY=
X-Received: by 2002:a25:a183:: with SMTP id a3mr4771090ybi.459.1611624386074;
 Mon, 25 Jan 2021 17:26:26 -0800 (PST)
MIME-Version: 1.0
References: <20210110070341.1380086-1-andrii@kernel.org> <161048280875.1131.14039972740532054006.git-patchwork-notify@kernel.org>
 <4f19b649-a837-48af-90d1-c4692580053d@www.fastmail.com>
In-Reply-To: <4f19b649-a837-48af-90d1-c4692580053d@www.fastmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 25 Jan 2021 17:26:15 -0800
Message-ID: <CAEf4BzY4LWhyHfd3OpvrM5DB7qieOemcxzp0GBtqWJTw56PMCg@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] bpf: allow empty module BTFs
To:     Christopher William Snowhill <chris@kode54.net>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Andrii Nakryiko <andrii@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 24, 2021 at 2:28 AM Christopher William Snowhill
<chris@kode54.net> wrote:
>
> When is this being applied to an actual kernel? 5.11 is still quite broken without these two patches. Unless you're not using a vfat EFI partition, I guess.
>

It's in v5.11-rc5.

> On Tue, Jan 12, 2021, at 12:20 PM, patchwork-bot+netdevbpf@kernel.org wrote:
> > Hello:
> >
> > This series was applied to bpf/bpf.git (refs/heads/master):
> >
> > On Sat, 9 Jan 2021 23:03:40 -0800 you wrote:
> > > Some modules don't declare any new types and end up with an empty BTF,
> > > containing only valid BTF header and no types or strings sections. This
> > > currently causes BTF validation error. There is nothing wrong with such BTF,
> > > so fix the issue by allowing module BTFs with no types or strings.
> > >
> > > Reported-by: Christopher William Snowhill <chris@kode54.net>
> > > Fixes: 36e68442d1af ("bpf: Load and verify kernel module BTFs")
> > > Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
> > >
> > > [...]
> >
> > Here is the summary with links:
> >   - [bpf,1/2] bpf: allow empty module BTFs
> >     https://git.kernel.org/bpf/bpf/c/bcc5e6162d66
> >   - [bpf,2/2] libbpf: allow loading empty BTFs
> >     https://git.kernel.org/bpf/bpf/c/b8d52264df85
> >
> > You are awesome, thank you!
> > --
> > Deet-doot-dot, I am a bot.
> > https://korg.docs.kernel.org/patchwork/pwbot.html
> >
> >
> >
