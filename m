Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE88577B38
	for <lists+netdev@lfdr.de>; Sat, 27 Jul 2019 20:49:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388088AbfG0Std (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 27 Jul 2019 14:49:33 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:40683 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387794AbfG0Stc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 27 Jul 2019 14:49:32 -0400
Received: by mail-qk1-f195.google.com with SMTP id s145so41477994qke.7;
        Sat, 27 Jul 2019 11:49:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DjGOwapSBWmiiH2GGhbziWFl3zNdPVVxiHxGofJYERI=;
        b=OVQlyF1u+7/1OFAXG1Ncq+UaeFsFXX1WSzoXsQ3Pz+kC6UH0bB5hdrJKIz5tdL//zW
         5zmo061wXKBtVHqr/eh1PQSzGCQ+PxV0UnMiMeuBt7GKG8UcYEW8RUBWjgBe8vIbK8N7
         33/AUkzGq0NGogmBX1+f4c2zP/o94OjM+WdYmgOy7/CyaBSscb4KIvnsldqynRflTz3g
         oS8hF1fvCGA2qrwjbqUMzWg/fkgwlj3Nyd42OqFSvnMnQFlxAetrLDWvOO8rmrV9LNMK
         W8SpOT4D2Mwv+1Xzj/F2RDZ7mF6y3nt5MDIGigYaGLYh36Id8omDIJdBxAoI7NN4BxWk
         ZISw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DjGOwapSBWmiiH2GGhbziWFl3zNdPVVxiHxGofJYERI=;
        b=ZxKtzycopoFRyHFP3T1/Q7zIxNkuNaLOZBMDPO9nGhkJDj+TMUh+IdlnQEtqGedK28
         pYpEc26dXTvPvTcwBL2vH2sCEbkRoLFu6gNeMnFoa3f3iIWElqobdHk/fEs5/Cn4X6uO
         Lhf4kVP/HyTtqc0J/R/qf3DvyNizen0IFR2Vb6TL9ZQiy1pS6YizeISAkwpYTrCv5M+R
         ju044SfUT2h5b9BGXZP5GSVaOkIiWJLn04THfZ2mvXWvcSamNfmm4zSLo2FicLFJzX7T
         Csc5itDuL4BQuljT7CW1GUoFjsXcACtp+BokmUbaUDZQWeNZVrPfgl+hOEHDCyLZXRV/
         KU1A==
X-Gm-Message-State: APjAAAUxJndznrZpybHtyE6GTsQcT9xdTc/rjc8VZVx5M5tmIbZKN4FC
        U7XXWG9odd49T3RgFfPdoBtlWSxOm1nCglTAecRMRxWqXm+1Vg==
X-Google-Smtp-Source: APXvYqx8Jk3pKc4YzmbgwMB9sttcjSt7w2f8gAIojEW8SmngUas/STt5kgx1Hp8xPDYddkk3AbKaN95pSWTuW3G73ZI=
X-Received: by 2002:a37:b646:: with SMTP id g67mr66287065qkf.92.1564253371671;
 Sat, 27 Jul 2019 11:49:31 -0700 (PDT)
MIME-Version: 1.0
References: <20190726203747.1124677-1-andriin@fb.com> <20190726203747.1124677-5-andriin@fb.com>
 <20190726212818.GC24397@mini-arch> <CAEf4BzYoiL7XAXFdLaf5TDDas42u+jUTy2WydgmJT7WiniqOqQ@mail.gmail.com>
 <20190727003045.63s6qau6kcnpkgxq@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20190727003045.63s6qau6kcnpkgxq@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 27 Jul 2019 11:49:20 -0700
Message-ID: <CAEf4BzaoFOyUnaNE2k3_E6f6Ozf0V4X3TGC5nrEMD9wbxuM9LQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/9] libbpf: add libbpf_swap_print to get
 previous print func
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Stanislav Fomichev <sdf@fomichev.me>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 26, 2019 at 5:30 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Fri, Jul 26, 2019 at 02:47:28PM -0700, Andrii Nakryiko wrote:
> > On Fri, Jul 26, 2019 at 2:28 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
> > >
> > > On 07/26, Andrii Nakryiko wrote:
> > > > libbpf_swap_print allows to restore previously set print function.
> > > > This is useful when running many independent test with one default print
> > > > function, but overriding log verbosity for particular subset of tests.
> > > Can we change the return type of libbpf_set_print instead and return
> > > the old function from it? Will it break ABI?
> >
> > Yeah, thought about that, but I wasn't sure about ABI breakage. It
> > seems like it shouldn't, so I'll just change libbpf_set_print
> > signature instead.
>
> I think it's ok to change return value of libbpf_set_print() from void
> to useful pointer.

Some googling gave inconclusive results. StackOverflow answers claim
it is compatible ABI change ([0]), but I also found some guidelines
for Android that designate any return type change as incompatible
([1]). [2] wasn't very helpful about defining compatibility rules,
unfortunately. I'm going with [0], though, and changing return type.

  [0] https://stackoverflow.com/questions/15626579/c-abi-is-changing-a-void-function-to-return-an-int-a-breaking-change
  [1] https://source.android.com/devices/architecture/vndk/abi-stability
  [2] https://www.cs.dartmouth.edu/~sergey/cs258/ABI/UlrichDrepper-How-To-Write-Shared-Libraries.pdf

> This function is not marked as __attribute__((__warn_unused_result__)),
> so there should be no abi issues.
>
> Please double check by compiler perf with different gcc-s as Arnaldo's setup does.
>

Compiled (make -C tools/perf) with GCC 4.8.5, GCC 7, and Clang 8. None
of them produced any warning, so I'm going forward with just return
type change.
