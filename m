Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB257F57A5
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 21:06:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387539AbfKHTc4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 14:32:56 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:39043 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732295AbfKHTcz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Nov 2019 14:32:55 -0500
Received: by mail-lj1-f194.google.com with SMTP id p18so7405201ljc.6;
        Fri, 08 Nov 2019 11:32:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wIPAmnydTwnmaS2h0QU5i67rCEmbSQgSSfgLHMTGULY=;
        b=SnBhuJil4v4UmxWffYwyA+E3nLHXNi02DKLCfkcdsMSr9Iaoe2AYbbiwhcI9NHpCH3
         KMCuPfZeC18W3FuCjtN880RUNZLzyrxiEMu/1/cnuXPm9m4mSirw75TRQFWT7ayNSLM4
         ANGB4fTkRJNhyEUjTJA9A35SUK9BhvZFuKONSl7WW17rvCBn/560pFMjbAc2oTLP6p4b
         69nARIU/9/iUwrMt8X2nCyQ/ehwdLjvp1hxNUxQTN3L+NECjiCmi063JtxQMNGNO8OLQ
         pF8a4FczI1gSKtRQWgTALtFtwLS9yFtKhuhLxwpLXRon7HbmeyrYJRPbJFK3SnRxqlZe
         TQBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wIPAmnydTwnmaS2h0QU5i67rCEmbSQgSSfgLHMTGULY=;
        b=mxw5dD7bwLWJBFkKDyrr4dBX6dnIWhQi9c+Pfd0bBs86WNm3JeQTCtfXFtAZ0Qlb20
         Mj1LAK+7KNxrJHq+2DcUE39DS/H608HlXSZuYXvCov7sgLRbdTrVKh/Z7LzowQMz8DxQ
         GnmyCxd87kDaCCY8Di0XAT738gY1PotePtEoJUOL0C/wzWnyzvPIvAZaTc3M4dlKLBUG
         J964C5EucfIp5k++ltM/INeQZsrwMnEnsUlzZScY+in8xaI8lI/JIk45q8lHmuOEG42R
         WsWDfMrWGY649XZ91nT0Q6YnW1T4tTdLeKR8koGVW0LL1dlDR+zPYMPuI1PhnanyL02A
         4LCA==
X-Gm-Message-State: APjAAAWobYq9z1HFnT/n39zDJTc19/Qqpg0wYeomfvBpzW5QJs7T8MtC
        IJCKomKDO+eSCe+li7v1X2YcLOe1lCI1ir8CR/C4PdWl
X-Google-Smtp-Source: APXvYqzdfOCES9dJxYqTVT0FTRxt455cGMyiBFCCROsETkfqnDZwyXqphvRR7NhANSYNFDacZuhgwTi8odci9j7qJ+g=
X-Received: by 2002:a2e:85d5:: with SMTP id h21mr7994061ljj.243.1573241573660;
 Fri, 08 Nov 2019 11:32:53 -0800 (PST)
MIME-Version: 1.0
References: <20191108064039.2041889-1-ast@kernel.org> <20191108064039.2041889-3-ast@kernel.org>
 <20191108091156.GG4114@hirez.programming.kicks-ass.net> <20191108093607.GO5671@hirez.programming.kicks-ass.net>
 <59d3af80-a781-9765-4d01-4c8006cd574f@fb.com>
In-Reply-To: <59d3af80-a781-9765-4d01-4c8006cd574f@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Fri, 8 Nov 2019 11:32:41 -0800
Message-ID: <CAADnVQKmrVGVHM70OT0jc7reRp1LdWTM8dhE1Gde21oxw++jwg@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 02/18] bpf: Add bpf_arch_text_poke() helper
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "x86@kernel.org" <x86@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 8, 2019 at 5:42 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 11/8/19 1:36 AM, Peter Zijlstra wrote:
> > On Fri, Nov 08, 2019 at 10:11:56AM +0100, Peter Zijlstra wrote:
> >> On Thu, Nov 07, 2019 at 10:40:23PM -0800, Alexei Starovoitov wrote:
> >>> Add bpf_arch_text_poke() helper that is used by BPF trampoline logic to patch
> >>> nops/calls in kernel text into calls into BPF trampoline and to patch
> >>> calls/nops inside BPF programs too.
> >>
> >> This thing assumes the text is unused, right? That isn't spelled out
> >> anywhere. The implementation is very much unsafe vs concurrent execution
> >> of the text.
> >
> > Also, what NOP/CALL instructions will you be hijacking? If you're
> > planning on using the fentry nops, then what ensures this and ftrace
> > don't trample on one another? Similar for kprobes.
> >
> > In general, what ensures every instruction only has a single modifier?
>
> Looks like you didn't bother reading cover letter and missed a month
> of discussions between my and Steven regarding exactly this topic
> though you were directly cc-ed in all threads :(
> tldr for kernel fentry nops it will be converted to use
> register_ftrace_direct() whenever it's available.
> For all other nops, calls, jumps that are inside BPF programs BPF infra
> will continue modifying them through this helper.
> Daniel's upcoming bpf_tail_call() optimization will use text_poke as well.
>
>  > I'm very uncomfortable letting random bpf proglets poke around in the
> kernel text.
>
> 1. There is no such thing as 'proglet'. Please don't invent meaningless
> names.
> 2. BPF programs have no ability to modify kernel text.
> 3. BPF infra taking all necessary measures to make sure that poking
> kernel's and BPF generated text is safe.
> If you see specific issue please say so. We'll be happy to address
> all issues. Being 'uncomfortable' is not constructive.
>

I was thinking more about this.
Peter,
do you mind we apply your first patch:
https://lore.kernel.org/lkml/20191007081944.88332264.2@infradead.org/
to both tip and bpf-next trees?
Then I can use text_poke_bp() as-is without any additional ugliness
on my side that would need to be removed in few weeks.
Do you have it in tip already?
I can cherry-pick from there to make sure it's exactly the same commit log
then there will be no merge issues during merge window.
