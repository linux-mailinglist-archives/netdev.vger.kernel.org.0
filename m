Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0BFECAFE9
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 22:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388556AbfJCUTJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 16:19:09 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:46811 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729087AbfJCUTJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 16:19:09 -0400
Received: by mail-qt1-f193.google.com with SMTP id u22so5391421qtq.13;
        Thu, 03 Oct 2019 13:19:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GToSHS/qEA1Pc/jpqOSnISxSJdhkgkJcybPw8ptrh9U=;
        b=Iz2LUD3UYX4dlpiC7IVjW5Mk8AZt97vjHk7wElcKORcchmojDny4H4AS0l+5or8urf
         p+T3FgTGksEMUacaahyMLonIbjvieeqvjr9EWML5dgvE/9ip9e65bi80q+wSeo3Xd3ST
         9/L2WhcIFYZnioogQBCd2+N8shpf5wxpGSLPkuHMdLiN/KWDqL+3RNgFXq/+JieqnJc0
         4eICNPOiuGU058Jplaai4jfdxaGfxBglD655rmYhBPDl6Jitc09UgmeOyt5xgezLx45D
         WiyC65fmTlxQLIsSK9ENlMRNkoMsN0Nt4RsLZKC53x5H7eX8FV8ESQE1fDb6IpcV+rzu
         fXPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GToSHS/qEA1Pc/jpqOSnISxSJdhkgkJcybPw8ptrh9U=;
        b=Tjqi+ZbzpToC/MQu4vYIQ8P50nD8VgAtOSbUclNkV/JQLQuxbL/sT19zuyxDr+4/rn
         aVL5WdEWIs1YgpG4AL1raN4QU2iOz8XrNJoMG0dFKrbIDsopaO40Gddv30/8Qs2uK2NM
         L1vUfaksCokd+RdPwRYCYwZsfxNymES8Gj8R0pxMpJpMEnIdgDfIB+g9z0+b/rfeJ+VG
         UBIAQG0ePUwA6XMri6Ga0hr6TuJdRWmPQ0QzM6AAuQSB0UL4tLzpdPf/Qod7k3kVqWFn
         ZeceTOzrw/Lmmx8SUWaS9hsKt1h6rwGSOBewmQv/mNk+Ge7zJ5YHPSQjFu3MIe0d16JS
         xTvA==
X-Gm-Message-State: APjAAAW4XqH54kaowLNVAcs0NYK/cSz8VwHrp+UvJ4Gtz47zOxCcSSPa
        wvmYAUTLryhFVuGB+cy1erpXk1MMXdOV1DPLuFw=
X-Google-Smtp-Source: APXvYqxu/p/nvF3TicGSlw5zGbbmByhWaB1wxhzuvEjK1ore4O5tajUceiWFAG1FYtLl0xLiXoYrUbr4RGjlQ6UriUI=
X-Received: by 2002:aed:30ce:: with SMTP id 72mr11797373qtf.27.1570133947205;
 Thu, 03 Oct 2019 13:19:07 -0700 (PDT)
MIME-Version: 1.0
References: <20191002215041.1083058-1-andriin@fb.com> <20191002215041.1083058-5-andriin@fb.com>
 <5d9630ee7f2c2_55732aec43fe05c45e@john-XPS-13-9370.notmuch>
In-Reply-To: <5d9630ee7f2c2_55732aec43fe05c45e@john-XPS-13-9370.notmuch>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 3 Oct 2019 13:18:55 -0700
Message-ID: <CAPhsuW6EXJJr7qMpsTOmy2LCbY5zV70ZdfTSxyWXOPm3fRjXqA@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 4/7] selftests/bpf: split off tracing-only
 helpers into bpf_tracing.h
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 3, 2019 at 11:10 AM John Fastabend <john.fastabend@gmail.com> wrote:
>
> Andrii Nakryiko wrote:
> > Split-off PT_REGS-related helpers into bpf_tracing.h header. Adjust
> > selftests and samples to include it where necessary.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
>
> Acked-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Song Liu <songliubraving@fb.com>
