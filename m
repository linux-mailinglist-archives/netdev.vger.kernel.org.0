Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 214C4CCC01
	for <lists+netdev@lfdr.de>; Sat,  5 Oct 2019 20:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387855AbfJES1O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Oct 2019 14:27:14 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:40035 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387486AbfJES1N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Oct 2019 14:27:13 -0400
Received: by mail-qt1-f193.google.com with SMTP id m61so2310349qte.7;
        Sat, 05 Oct 2019 11:27:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WiYxA8/Lc/2RKZGBWIDDHQzUjhgfV3db1iR4c7W/LTY=;
        b=mbA9c8eU8F8aetfsWaLJDATNxQTJnODH3KD7FHrJ4fv9SMDNRKd9QfvqY/H0aQGmZ8
         7qQMvTkyLsvfEPZCyIpw0J1u4O+s7yL4cF0kbp7dZTmGWu5LVyJa/67cLZYGDmcWOilh
         bO+4CIvVUqSmn3uzdOn+xb6UkCwUc/uSQbiERSbpOiYcnA7PtugddvfS9bz3axqerrvj
         JvpNrFQ2h6NaGhzr/Wpr+eAZJr+f+0LFI1vvN/Kwp2PMlz0cWyzeFgKamzRrIPeAauKn
         jeIPjQoRWARtQnaAiksBKKCHuwWOwK6MLYN1Wa6qcMqaQKUspTJvbHPXgUmhYXm3qkcU
         LgnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WiYxA8/Lc/2RKZGBWIDDHQzUjhgfV3db1iR4c7W/LTY=;
        b=apJ7ZdUS56s06eytqqVHV24m0lmDMtJw0OvSIWqv1ezdtb93T7tYUarJ5vwd3sK4La
         XkAMx+vkNBWrLShMKL1zNjv4LrMrOCzycfDSjVJf2iygdg/h5FyPHQzltQ4aW5tktczP
         6WpDro8PEnlT3MzKw7ndcfxmNV2obNtajub3Rps9go7NNt1Tpn+l66ufkcm2Zc3KiMq3
         Egr4RXFixMUwEAKMse7o/97uxQz55XdQHBbm7cEj2ItSFETderYiqofGlxroMhCZ6ne+
         pZZuCTIjF2ZVBhQJoHI8BF5K9X0A+QWjl4JbEhlOvrdyMAoRqzUiJDZPCxHOQfpGR0Ej
         kNRQ==
X-Gm-Message-State: APjAAAUVJEgpjldm0e/vJgexxEePajoHlDC0Os8VR4whFlRQSPZejuKn
        tMVvecdcWg7A6TIsPMQe8fsOenrFMrkU2aAmfD4U6978
X-Google-Smtp-Source: APXvYqy8cMkAjKtuH1d3/5HQFOCCK0Od14KUgtvblw7meVmV1ILSiZy4kPXEjC6XTccQxfF3LVVi4f1iHx6b1gRoHLQ=
X-Received: by 2002:ac8:1417:: with SMTP id k23mr21180914qtj.93.1570300032502;
 Sat, 05 Oct 2019 11:27:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAEKGpzhoYHrE4NTvaWSpy-R6CiLYehGHzLM6v+-9j8iemNyK0g@mail.gmail.com>
In-Reply-To: <CAEKGpzhoYHrE4NTvaWSpy-R6CiLYehGHzLM6v+-9j8iemNyK0g@mail.gmail.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 5 Oct 2019 11:27:01 -0700
Message-ID: <CAEf4BzbCoP6R0UbbW4HU6jqK8T3F-0SCTj_5ex8brnfCJLeBAA@mail.gmail.com>
Subject: Re: samples/bpf not working?
To:     "Daniel T. Lee" <danieltimlee@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>, xdp-newbies@vger.kernel.org,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 4, 2019 at 3:28 PM Daniel T. Lee <danieltimlee@gmail.com> wrote:
>
> Currently, building the bpf samples isn't working.
> Running make from the directory 'samples/bpf' will just shows following
> result without compiling any samples.
>
> $ make
> make -C ../../ /git/linux/samples/bpf/ BPF_SAMPLES_PATH=/git/linux/samples/bpf
> make[1]: Entering directory '/git/linux'
>   CALL    scripts/checksyscalls.sh
>   CALL    scripts/atomic/check-atomics.sh
>   DESCEND  objtool
> make[1]: Leaving directory '/git/linux'
> $ ls *kern.o
> ls: cannot access '*kern.o': No such file or directory
>
> By using 'git bisect', found the problem is derived from below commit.
> commit 394053f4a4b3 ("kbuild: make single targets work more correctly")
>
> > Currently, the single target build directly descends into the directory
> > of the target. For example,
> >
> >     $ make foo/bar/baz.o
> >
> > ... directly descends into foo/bar/.
> >
> > On the other hand, the normal build usually descends one directory at
> > a time, i.e. descends into foo/, and then foo/bar/.
> >
> > This difference causes some problems.
> >
> > [...]
> >
> > This commit fixes those problems by making the single target build
> > descend in the same way as the normal build does.
>
> Not familiar with kbuild, so I'm not sure why this led to build failure.
> My humble guess is, samples/bpf/Makefile tries to run make from current
> directory, 'sample/bpf', but somehow upper commit changed the way it works.
>
> samples/bpf/Makefile:232
> # Trick to allow make to be run from this directory
> all:
>         $(MAKE) -C ../../ $(CURDIR)/ BPF_SAMPLES_PATH=$(CURDIR)
>
> I've tried to figure out the problem with 'make --trace', but not sure why
> it's not working. Just a hunch with build directory.
>
> Any ideas to fix this problem?

Yes, it's now a known problem. You need to run it as `make
M=samples/bpf` from root directory, as well as have all the recent
fixes both from bpf and bpf-next trees (:(, this will be a bit better
once bpf is merged into bpf-next).
