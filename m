Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40CE61DEF84
	for <lists+netdev@lfdr.de>; Fri, 22 May 2020 20:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730907AbgEVSwK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 May 2020 14:52:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38394 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730840AbgEVSwK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 May 2020 14:52:10 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29BBC061A0E;
        Fri, 22 May 2020 11:52:09 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id m44so9095088qtm.8;
        Fri, 22 May 2020 11:52:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=H9l2RHL3RwUhwdnEL4ID6y236+WizlVKxMIbMNtDmMw=;
        b=VswOmfZV6AneDGuqQcSjekUoQDsY9ZZSQ43axdd+o748et5SEDSYylsvh3FCAgN8bw
         ujGl5aAm2vavmODib3z4nHUaeECpfVtkAiN0cDB3NctOODOuUrshOf/0v2fyzyrFcbeJ
         1bCX/b6SPgOp7ePPXptnF7kk9fbGgxvQ3gTVZGZ59RBk1JfjG/Ek9A5NrjGoXBsOEGmW
         34WmGuGU4tNmQ0Kg+Rt7JEgS7726wA2X129qeu6BfusaMuJdSFJVmoHVAElGeTCc5ARs
         52iJFn1/q0mLM/eKrjGslofKwer2OHVZmigQDXnPybrl2E+9EEcjwrvAICAMmsYC4+n4
         bXbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=H9l2RHL3RwUhwdnEL4ID6y236+WizlVKxMIbMNtDmMw=;
        b=qC8K1eYjfbhLkETdsZkfQPwrrqjhjHd1H6RYjhyfDFiUqV5UdWMEAQSsBUd5alIueA
         SqLlK2vRD19662k7Ttb9II+nhUHQdRjDFg6ccrzHvdjm2yOzENxer3URdYFMTP8JirUP
         Xy3sFcYN5YB/BnJiuonavqolVuEwqSi2izwVZ6BJTuyhtpy6m9ZxXLqbnkauhJjNqX9F
         9113aR/7w6n/1m5Ndd7l8zFA2J1lwga+gwFLXUiwpfCVgcYI5ZCUFVJVxKeWc6ubIZo8
         V4Maq7Hr655UWtuQJBCn///n6/eyGmXOPxnZAl1w+T/sXj1+KYuInYST9V5aOBIcCA5a
         ihjQ==
X-Gm-Message-State: AOAM531KuWtAN5yK1gk1qAL+LtV2YNPe0hWUbvaRX4D+NXg/QRTZAieX
        /BHVpXmQ+XPBXX4h9nSNgB2Q1DrhySJhfUJJn8s=
X-Google-Smtp-Source: ABdhPJyssgWQuL2ICwIVLPz3ucTk7Z/DJXYlQGLSzKZOzbPktsyhRkQiKil0Kh1r4bYn0KsEKVgYB+IfRT0z/tgOSew=
X-Received: by 2002:ac8:7206:: with SMTP id a6mr219037qtp.59.1590173529158;
 Fri, 22 May 2020 11:52:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200517195727.279322-1-andriin@fb.com> <20200517195727.279322-3-andriin@fb.com>
 <20200522003433.GG2869@paulmck-ThinkPad-P72>
In-Reply-To: <20200522003433.GG2869@paulmck-ThinkPad-P72>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 22 May 2020 11:51:58 -0700
Message-ID: <CAEf4BzaVeFfa2=-M4FCgH5HX17TSkcGsBTDZcjrZxo=He2QESg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 2/7] tools/memory-model: add BPF ringbuf MPSC
 litmus tests
To:     "Paul E . McKenney" <paulmck@kernel.org>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 21, 2020 at 5:34 PM Paul E. McKenney <paulmck@kernel.org> wrote:
>
> On Sun, May 17, 2020 at 12:57:22PM -0700, Andrii Nakryiko wrote:
> > Add 4 litmus tests for BPF ringbuf implementation, divided into two different
> > use cases.
> >
> > First, two unbounded case, one with 1 producer and another with
> > 2 producers, single consumer. All reservations are supposed to succeed.
> >
> > Second, bounded case with only 1 record allowed in ring buffer at any given
> > time. Here failures to reserve space are expected. Again, 1- and 2- producer
> > cases, single consumer, are validated.
> >
> > Just for the fun of it, I also wrote a 3-producer cases, it took *16 hours* to
> > validate, but came back successful as well. I'm not including it in this
> > patch, because it's not practical to run it. See output for all included
> > 4 cases and one 3-producer one with bounded use case.
> >
> > Each litmust test implements producer/consumer protocol for BPF ring buffer
> > implementation found in kernel/bpf/ringbuf.c. Due to limitations, all records
> > are assumed equal-sized and producer/consumer counters are incremented by 1.
> > This doesn't change the correctness of the algorithm, though.
>
> Very cool!!!
>
> However, these should go into Documentation/litmus-tests/bpf-rb or similar.
> Please take a look at Documentation/litmus-tests/ in -rcu, -tip, and
> -next, including the README file.
>
> The tools/memory-model/litmus-tests directory is for basic examples,
> not for the more complex real-world ones like these guys.  ;-)

Oh, ok, I didn't realize there are more litmus tests under
Documentation/litmus-tests... Might have saved me some time (more
examples to learn from!) when I was writing mine :) Will check those
and move everything.

>
>                                                                 Thanx, Paul
>

[...]
