Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0880E1D273C
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 08:09:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgENGI7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 May 2020 02:08:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41810 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725794AbgENGI6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 May 2020 02:08:58 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93CA5C061A0C;
        Wed, 13 May 2020 23:08:58 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id i14so1916563qka.10;
        Wed, 13 May 2020 23:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yZL+icgwJLrqBjGUBA9ZTMZd1LnDKb/MfQqU0xbNkyU=;
        b=REJGo4XgcCxRuqlolU2sCdvE7JrLbslmQxuWs0H5zz5kXVxZZBi7hQoOwvqY+IFq5x
         vEdp1WiVmLANBgdkMkxU7jFMCuA/x12VOGGrhgx2vzpIcR8y1T8MS0eieg60O6YsOBHW
         dv30eMF7gjQ+ftc/POHeKfzimgGdFKwrkgFsGO/gA/vSzbRIcIopm5uscP0jSNxzJeeZ
         nijoZosCF/QyXj6n35Dn7KXFL1p/EObldFxBPQYRczdJHb9oDTPhkc2+9P2cn/qlNdcq
         DOMh6tk8Wfze/p/v+YyCs2ZQytRg2Zxv47OwvSnrMUnqMKvPJSJYbIRQASIxxuAQ+TpF
         ZTfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yZL+icgwJLrqBjGUBA9ZTMZd1LnDKb/MfQqU0xbNkyU=;
        b=pp1lo5KbLIugN7SEQxafX7B1CPyNv+uuhu9ut2OisRXtUfFY+QJ5rGrn5rxqxfTLDb
         AANBkSu7A6lRXHQulg7Y2PmSjvLBgvLqQgCx2fT/oc7WLa5e52PjiEhSD0dDZ6JC54lO
         XARTKL0k2aRJTUEOpgfnkxGowjn+BoBqswqD2qZU3SXpfvdmtbUmc7HRWyHc7HoO7in7
         qJ7P4EA1TedCkfAT7XQt1oKK0RHspRsI1EyQhEUrC1K0MB1/Y1KcnrjrXaemmT8u/uFz
         1DKO5EhEW9cib0ZQlsO2kB5D4o1nDNNI+EsLmhqephxMR/QoiwLnNNgXBN3UM2+KM72W
         hGpQ==
X-Gm-Message-State: AOAM533gPYWXgfoUGtk6tekboEvsgvNUTZAue5bBNtEVR4I+Yjbz8Hji
        4T00zvib6bsLSoJefwn3PLPr4kzj5k7wJQQmt58b+w==
X-Google-Smtp-Source: ABdhPJypEgPC3InV3fz0mBjFeldGxPacnHYtckGqFCj68I8f85qry6eINmdHQ9DeGdaIgdwCp8uR7PaS/ewe1G42v/A=
X-Received: by 2002:a05:620a:14a1:: with SMTP id x1mr3213185qkj.92.1589436537797;
 Wed, 13 May 2020 23:08:57 -0700 (PDT)
MIME-Version: 1.0
References: <20200513192532.4058934-1-andriin@fb.com> <20200513224927.643hszw3q3cgx7e6@bsd-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200513224927.643hszw3q3cgx7e6@bsd-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 13 May 2020 23:08:46 -0700
Message-ID: <CAEf4BzaSEPNyBvXBduH2Bkr64=MbzFiR9hJ9DYwXwk4D2AtcDw@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/6] BPF ring buffer
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        "Paul E . McKenney" <paulmck@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 13, 2020 at 3:49 PM Jonathan Lemon <jonathan.lemon@gmail.com> wrote:
>
> On Wed, May 13, 2020 at 12:25:26PM -0700, Andrii Nakryiko wrote:
> > Implement a new BPF ring buffer, as presented at BPF virtual conference ([0]).
> > It presents an alternative to perf buffer, following its semantics closely,
> > but allowing sharing same instance of ring buffer across multiple CPUs
> > efficiently.
> >
> > Most patches have extensive commentary explaining various aspects, so I'll
> > keep cover letter short. Overall structure of the patch set:
> > - patch #1 adds BPF ring buffer implementation to kernel and necessary
> >   verifier support;
> > - patch #2 adds litmus tests validating all the memory orderings and locking
> >   is correct;
> > - patch #3 is an optional patch that generalizes verifier's reference tracking
> >   machinery to capture type of reference;
> > - patch #4 adds libbpf consumer implementation for BPF ringbuf;
> > - path #5 adds selftest, both for single BPF ring buf use case, as well as
> >   using it with array/hash of maps;
> > - patch #6 adds extensive benchmarks and provide some analysis in commit
> >   message, it build upon selftests/bpf's bench runner.
> >
> >   [0] https://docs.google.com/presentation/d/18ITdg77Bj6YDOH2LghxrnFxiPWe0fAqcmJY95t_qr0w
> >
> > Cc: Paul E. McKenney <paulmck@kernel.org>
> > Cc: Jonathan Lemon <jonathan.lemon@gmail.com>
>
> Looks very nice!  A few random questions:
>
> 1) Why not use a structure for the header, instead of 2 32bit ints?

hm... no reason, just never occurred to me it's necessary :)

>
> 2) Would it make sense to reserve X bytes, but only commit Y?
>    the offset field could be used to write the record length.
>
>    E.g.:
>       reserve 512 bytes    [BUSYBIT | 512][PG OFFSET]
>       commit  400 bytes    [ 512 ] [ 400 ]

It could be done, though I had tentative plans to use those second 4
bytes for something useful eventually.

But what's the use case? From ring buffer's perspective, X bytes were
reserved and are gone already and subsequent writers might have
already advanced producer counter with the assumption that all X bytes
are going to be used. So there are no space savings, even if record is
discarded or only portion of it is submitted. I can only see a bit of
added convenience for an application, because it doesn't have to track
amount of actual data in its record. But this doesn't seem to be a
common case either, so not sure how it's worth supporting... Is there
a particular case where this is extremely useful and extra 4 bytes in
record payload is too much?

>
> 3) Why have 2 separate pages for producer/consumer, instead of
>    just aligning to a smp cache line (or even 1/2 page?)

Access rights restrictions. Consumer page is readable/writable,
producer page is read-only for user-space. If user-space had ability
to write producer position, it could wreck a huge havoc for the
ringbuf algorithm.

>
> 4) The XOR of busybit makes me wonder if there is anything that
>    prevents the system from calling commit twice?

Yes, verifier checks this and will reject such BPF program.

> --
> Jonathan
