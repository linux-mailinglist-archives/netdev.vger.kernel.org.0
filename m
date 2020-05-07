Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 895D11C7E89
	for <lists+netdev@lfdr.de>; Thu,  7 May 2020 02:26:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgEGA0H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 20:26:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725887AbgEGA0G (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 20:26:06 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40807C061A0F;
        Wed,  6 May 2020 17:26:06 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id f18so4341803lja.13;
        Wed, 06 May 2020 17:26:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pfuNYjdlBZcFqk3cO/TEthEGXzpFSbiEHwj3mFfvMIM=;
        b=WQOzqaD1bNkPrLiNymUSrOvoYL8v9RZ5DIbqm6e+y35APA13Wu2iysluRtHWg7CXpR
         5RCmIyGzJ0FCzQRSQvV/Z6r/8TVdQeM1jNcKxYb5yDyj0oCnS18IJi9JoQwoD1y+WcHT
         9cv1FJfPc26PN12J1QM/oNT1/qbocmZ0oBpYgErVh93I8NS40WPJXi92WDBLuNssnJXn
         1CVljgoD0z3t8bo/9kGlp+gIbfW58lSsd4fSWeUAaOwlkAFdybndiHyXPt+z+35AVMWv
         inl+q4VyuD+ZRkEkFTMRg/xl4KmBNBdFb2awQWTIUrrm/1DEuggkcPCnDQM0irYchvZk
         qWlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pfuNYjdlBZcFqk3cO/TEthEGXzpFSbiEHwj3mFfvMIM=;
        b=HrRoaXB0LW4mIubxVeDm9ZcFp21Z6Pkf6dZ+iJFj6l5Rl1HuruwVS8+xH0ROXM1Shq
         CCGlFJbjyacGkzYHYNVsmIxselgSk4FmvrxpBrsDXoYio3BeX2erF5sCRs8lhpMaw3N7
         zP64jzwnRVsv5RNuT9jd4A70fN0zvpdPk6TCWVRWHm3DrHtWgKSG76Kw1jZqE+Rt3UkX
         onyZWsHAntlBAJ+NFj/RuoyYRSYQy5hvsEfzgpJYu4ed26v7cQzwX/+vKvSBnGlVgcaN
         zSh0m8ry6+Q6J0x5J3miuQz3FWFMkzvkPO6qXBG0sWe6GFMH04ix874cVjJKC3peKrz9
         DW6w==
X-Gm-Message-State: AGi0Puae6UFDn5xOPLi0DdkN9caBhCqJ9fqiw0h1Yy91v/FtY+Ed6uaH
        xu93OH7ACMrZJ/u5gFUTRWaXw0q6zscPOW4L4Ug=
X-Google-Smtp-Source: APiQypLhjH/vAa1zWJ+FDG9tssyBz0PZl4fs87nSOZF9o9XXhyliTDUlA1+VEvqpOcKef2weN5AYgZ6UmgqCto1PpbI=
X-Received: by 2002:a2e:9011:: with SMTP id h17mr6889643ljg.138.1588811164575;
 Wed, 06 May 2020 17:26:04 -0700 (PDT)
MIME-Version: 1.0
References: <CAADnVQJfD1dLVsfg4=c4f6ftRNF_4z0wELjFq8z=7voi-Ak=7w@mail.gmail.com>
 <87sggdj8c6.fsf@nanos.tec.linutronix.de> <87h7wsk9z7.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87h7wsk9z7.fsf@nanos.tec.linutronix.de>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 6 May 2020 17:25:52 -0700
Message-ID: <CAADnVQL873t8h_RDUg7sJh4RS4a7eaV11Kq=PxdguOccb7VzmQ@mail.gmail.com>
Subject: Re: pulling cap_perfmon
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 6, 2020 at 2:51 PM Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Alexei,
>
> Thomas Gleixner <tglx@linutronix.de> writes:
> > Alexei Starovoitov <alexei.starovoitov@gmail.com> writes:
> >>
> >> I'd like to pull
> >> commit 980737282232 ("capabilities: Introduce CAP_PERFMON to kernel
> >> and user space")
> >> into bpf-next to base my CAP_BPF work on top of it.
> >> could you please prepare a stable tag for me to pull ?
> >> Last release cycle Thomas did a tag for bpf+rt prerequisite patches and
> >> it all worked well during the merge window.
> >> I think that one commit will suffice.
> >
> > I'll have a look.
>
> here you go.
>
>    git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git perf-for-bpf-2020-05-06

Awesome. Pulled.
Thanks a lot!
