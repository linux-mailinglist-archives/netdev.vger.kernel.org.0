Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9AEEE50A8
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 17:59:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503721AbfJYP70 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 11:59:26 -0400
Received: from mail-il1-f196.google.com ([209.85.166.196]:35138 "EHLO
        mail-il1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503539AbfJYP70 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 11:59:26 -0400
Received: by mail-il1-f196.google.com with SMTP id p8so2301218ilp.2;
        Fri, 25 Oct 2019 08:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=KRmEjEeRfORW7Zhwzm+56iwdVA+DMK8pNW+2olRUCp4=;
        b=SfZiftI6fHGsdlZjwUUehK4oQVkDe+GcUEk+Exvuz6f47K9Zt2Ug6DBxpaFijvTjjv
         XdeogX16PYIoiww/OuWRfqbb7RxRTwnPVujzXbhJqbcg84F6aFYKPmVxNgvQHITM94Pw
         4S5WEOVwZNi58t5HOqhW5lFWAYwRpCyy/NccDX/vOu4BlfP7tR4pC1aT2yEslWJYloHL
         8CMDgzrO+U+nAQmyHg3ocpI5uTY1RaXfOLyPknGiMflVUq99+RTWcYHUsseISkoq+PsS
         2ncuJlUjx9j0X9l6MG0DDOeRRMtDOqM08GuX9LaPG6OvlKEirbxgzQXXdTdMMIqLsms/
         8XsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=KRmEjEeRfORW7Zhwzm+56iwdVA+DMK8pNW+2olRUCp4=;
        b=Mk7H2ZTXXA6Bkw5TCwqQci5FNOeUgBQJlUGCOAeFb8KL0FyiVHCmtADeNTPPSK/cyH
         jOyvI9Kjbv3JDKqVzCVgmu3JFvWeOJWcDBvkvKTB0EG8wOgCcshdOCQiENfExAjh8lgZ
         17z8Gg6W7C0aznsb7uskQNLLUTzxIgWrhkArAxfiFb0NEVHWi4StNIHgUzZ4lH5OyNWP
         If1uCibKr9GH1D/EcEyWVz9AlZOizz7x/KYclQIrr1hGv8lLvRHW+WBjBH5saE/2rVG+
         X8waQVh4+MF9aTufsszL+0ZMpLVLs1OVDAkGQVjCIfz3k80KOZ0XXnrn1yMBlnVYnrQ3
         isXw==
X-Gm-Message-State: APjAAAUubYKfYzPC1AX/EBRVu3pQXeVyLxHhMV7580SlVAxRrC4DM1aw
        IUBWQ/toSNOF4Mcq1OLyqAs=
X-Google-Smtp-Source: APXvYqzBkVbIkEeNMmIIPAKKDFBDoq/QhCCNv5py+tutS6tUfAuAtkSN1PqczvXLysm7f+Dauts+pQ==
X-Received: by 2002:a92:6a04:: with SMTP id f4mr4928570ilc.252.1572019163695;
        Fri, 25 Oct 2019 08:59:23 -0700 (PDT)
Received: from localhost ([184.63.162.180])
        by smtp.gmail.com with ESMTPSA id b6sm200670ioc.79.2019.10.25.08.59.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Oct 2019 08:59:23 -0700 (PDT)
Date:   Fri, 25 Oct 2019 08:59:15 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Message-ID: <5db31bd33afbf_36802aec12c585b861@john-XPS-13-9370.notmuch>
In-Reply-To: <CAEf4BzZ2SrR0CBhbXo64bwWuBq-=JDS6p6=KRaLtH1bCGBwa3w@mail.gmail.com>
References: <157141046629.11948.8937909716570078019.stgit@john-XPS-13-9370>
 <CAEf4Bzbsg1dMBqPAL4NjXwAQ=nW-OX-Siv5NpC4Ad5ZY1ny4uQ@mail.gmail.com>
 <5dae8eafbf615_2abd2b0d886345b4b2@john-XPS-13-9370.notmuch>
 <20191022072023.GA31343@pc-66.home>
 <CAEf4BzbBoE=mVyxS9OHNn6eSvfEMgbcqiBh2b=nVmhWiLGEBNQ@mail.gmail.com>
 <5db1f389aa6f2_5c282ada047205c012@john-XPS-13-9370.notmuch>
 <CAEf4BzZ2SrR0CBhbXo64bwWuBq-=JDS6p6=KRaLtH1bCGBwa3w@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: libbpf, support older style kprobe load
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko wrote:
> On Thu, Oct 24, 2019 at 11:55 AM John Fastabend
> <john.fastabend@gmail.com> wrote:
> >
> > Andrii Nakryiko wrote:
> > > On Tue, Oct 22, 2019 at 12:20 AM Daniel Borkmann <daniel@iogearbox.net> wrote:
> > > >
> > > > On Mon, Oct 21, 2019 at 10:07:59PM -0700, John Fastabend wrote:
> > > > > Andrii Nakryiko wrote:
> > > > > > On Sat, Oct 19, 2019 at 1:30 AM John Fastabend <john.fastabend@gmail.com> wrote:
> > > > > > >
> > > > > > > Following ./Documentation/trace/kprobetrace.rst add support for loading
> > > > > > > kprobes programs on older kernels.
> > > > > >
> > > > > > My main concern with this is that this code is born bit-rotten,
> > > > > > because selftests are never testing the legacy code path. How did you
> > > > > > think about testing this and ensuring that this keeps working going
> > > > > > forward?
> > > > >
> > > > > Well we use it, but I see your point and actually I even broke the retprobe
> > > > > piece hastily fixing merge conflicts in this patch. When I ran tests on it
> > > > > I missed running retprobe tests on the set of kernels that would hit that
> > > > > code.
> > > >
> > > > If it also gets explicitly exposed as bpf_program__attach_legacy_kprobe() or
> > > > such, it should be easy to add BPF selftests for that API to address the test
> > > > coverage concern. Generally more selftests for exposed libbpf APIs is good to
> > > > have anyway.
> > > >
> > >
> > > Agree about tests. Disagree about more APIs, especially that the only
> > > difference will be which underlying kernel machinery they are using to
> > > set everything up. We should ideally avoid exposing that to users.
> >
> > Maybe a build flag to build with only the older style supported for testing?
> > Then we could build, test in selftests at least. Be clear the flag is only
> > for testing and can not be relied upon.
> 
> Build flag will necessitate another "flavor" of test_progs just to
> test this. That seems like an overkill.
> 
> How about this approach:

Sure sounds good. I'll do this next week along with the uprobe pieces
as well so we can get both kprobe/uprobe running on older kernels.

> 
> $ cat silent-features.c
> #include <stdio.h>
> 
> int __attribute__((weak)) __bpf_internal__force_legacy_kprobe;
> 
> int main() {
>         if (__bpf_internal__force_legacy_kprobe)
>                 printf("LEGACY MODE!\n");
>         else
>                 printf("FANCY NEW MODE!\n");
>         return 0;
> }
> $ cat silent-features-testing.c
> int __bpf_internal__force_legacy_kprobe = 1;
> $ cc -g -O2 silent-features.c -o silent-features && ./silent-features
> FANCY NEW MODE!
> $ cc -g -O2 silent-features.c silent-features-testing.c -o
> silent-features && ./silent-features
> LEGACY MODE!
> 
> This seems like an extensible mechanism without introducing any new
> public APIs or knobs, and we can control that in runtime. Some good
> naming convention to emphasize this is only for testing and internal
> needs, and I think it should be fine.
> 
> >
> > >
> > > > Cheers,
> > > > Daniel
