Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B1F71CB65A
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 19:50:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727117AbgEHRuT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 13:50:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726767AbgEHRuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 13:50:19 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3163C061A0C;
        Fri,  8 May 2020 10:50:18 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id z2so2610020iol.11;
        Fri, 08 May 2020 10:50:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GGWy4VZOpHsVd+xj3i6ggOaj9bm+2rEjr485bLzuqIA=;
        b=GhTsm8hcBtjyeiAzd97yL0uHRferOcywJkejfeWkBHqm7uM0pe0WfDUcy3rkq+0N+v
         SbX6fNBXvNUbyIfXZ2wIfxdXETBlMAt9cxf29ILYeYyJxZgPp4m84uTM9v9iUV5wJSEs
         9Wg2wZoM/mv1Q4axoJBXes7FPK6p+SbpOCKz+PtvkiwxEahsDYOJBhdupLUgu15kS6U5
         eBVjkOKvJSUAvLZmNvjg+QKd/wAWtrsw135WKh09oKZkUutgJ+krPA9kyVm+3q6shfOA
         outvP2Oiaf6TC8ZvaiX3hfIs2KnVn3wROHJskH+crS34vcNKZOnU3reFndaaTm8BNvzQ
         sF/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GGWy4VZOpHsVd+xj3i6ggOaj9bm+2rEjr485bLzuqIA=;
        b=Tr2aMTcKYL9yKhV7/+DYqBzC+QGGBA/xSZtWqQXqA9U/oOi7R7HMksPHBKU9lN7vzL
         1eIYkPm7l1iZo9lis0KbE30YRtfBVVWjVc0FovzUyTBYdZZRGnVxc6/ToOmFbQuWG3nC
         VVlOMHzDvlMQ0T42m1ZcKWopRkQBIBlCsa3wXgGkyvTFIPFUMm4ijAMiX8mGNGDV/aLW
         sdTKFkpQ+BCPPDVdtyVcs6n2G26YCopiMv8dhUzIW0LrtkT0jHu8GiYb6nxjarnSumG0
         EHRzEUJvTPCdtLORcBo3D7EvrtdvI0+tuiiCNaEDckDdgPd1MADta3poII6w2euFMFiJ
         A51g==
X-Gm-Message-State: AGi0Pub6jdgRN5035U0frIyjJ7zRanW6ADHI9Sn3SEeWR4+bmH0btQ9S
        TSkQAVlACNK72x8thdUgl8rusRI5hd9gD20xMqA=
X-Google-Smtp-Source: APiQypJiA8tXoiUBWfJvBUlVnhJKrXtCritavb8vYe3ex/HKeLtrzhsNW0BxIi1yhq4rYi3RO72VgY/VGzH46Bw1eRE=
X-Received: by 2002:a05:6638:228:: with SMTP id f8mr3875638jaq.38.1588960218280;
 Fri, 08 May 2020 10:50:18 -0700 (PDT)
MIME-Version: 1.0
References: <20200508070548.2358701-1-andriin@fb.com> <20200508070548.2358701-4-andriin@fb.com>
 <35e656a9-91d1-203d-44d4-ea5f002ad232@fb.com>
In-Reply-To: <35e656a9-91d1-203d-44d4-ea5f002ad232@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 8 May 2020 10:50:07 -0700
Message-ID: <CAEf4BzZoMZNADA6-_4CUtV+YuBWeuNF9EqDT-SbUNhOMmw_uTQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftest/bpf: add BPF triggring benchmark
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 8, 2020 at 9:40 AM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 5/8/20 12:05 AM, Andrii Nakryiko wrote:
> >
> > base      :    9.200 =C2=B1 0.319M/s
> > fentry    :    8.955 =C2=B1 0.241M/s
>
> > +SEC("fentry/__x64_sys_getpgid")
> > +int bench_trigger_fentry(void *ctx)
> > +{
> > +     __sync_add_and_fetch(&hits, 1);
> > +     return 0;
> > +}
>
> adding 'lock xadd' is not cheap.
> I wonder how much of the delta come from it and from the rest of
> trampoline.

Yeah, could be, though count-global/count-local benchmarks get to
150Mops/s under no-sharing scenario, so effect shouldn't be that high.
Well, in any case, 9Mops/s is more than enough for my cases :)
