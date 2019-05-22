Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B085B25B68
	for <lists+netdev@lfdr.de>; Wed, 22 May 2019 02:56:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728027AbfEVA4P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 May 2019 20:56:15 -0400
Received: from mail-qk1-f195.google.com ([209.85.222.195]:33067 "EHLO
        mail-qk1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbfEVA4O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 May 2019 20:56:14 -0400
Received: by mail-qk1-f195.google.com with SMTP id p18so463751qkk.0;
        Tue, 21 May 2019 17:56:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UcsW6XhQiuBgEwwFMZJ9DR9uDKMcByzy/BIkt2l5OFk=;
        b=p8mPEg2vUVu5GGyCDVr0SxAmjGzOTpSjCAURKnck5YIwNOcPmnSSG7Vqu2kKk6o/0D
         gWHr6pgaQylnDKs8yLWt/GaCgIxdAiAHKtMH4Qrs5xmn6nyJiNwalH2/y5r2qp3PZKcO
         I6u5H3OBMEvvAbvIHnsJ+WzHkTt7MXCN4fYCgFVTKan6voy9AdJTwzs5P4SO6qA+rM77
         2Dx9PfPyBsxqoN0St1o79vjrDbM7OK2vsrTjI72h8mkGyXPOEI9bkAvYYH2+EZ+KV7En
         Zlhz4coqKnMeYK57i2JISid+B9CNq1F/+M9umwKPCFVR4kQNBKGBMswxDSUIMBLngX5V
         WOdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UcsW6XhQiuBgEwwFMZJ9DR9uDKMcByzy/BIkt2l5OFk=;
        b=uEWQryVsbasb4BmrvYPlwUgV5lcMNz6/uRZidJKKdGd5LFADLbUGP8woKgjF42c6yd
         i1fs4FUsa4LulGqNnbfiALcFlpruxmGRVxqnZmUxtQz2oV3STuYfLA52UsswxGtnozd+
         c5AYhlqmIr/pZTJ7BhG/ggOTytNkC3aIAdBsShF+rVtVyTj4U80EgmuAvTkF+YubgIfU
         LAfnwbDiRA5qeRlK/uF6PmIHR2LXl2pFdlDEvKRujl9LnYvkYzuY/bruJq923PvIzpXA
         M7UY1W611No0eJXeaHuFEJ4LZgv8qv2z10Lqaj5F0FUW7bNcwmbaPKHUPSF5xWqNSfqd
         J8sw==
X-Gm-Message-State: APjAAAVpTUfwMQSt5AZmSUAOzTAilbjKkWOiZnag8KQYCExoDzY/FULf
        uuod7nYl9S0h2WMDkj907TJb2LeehpRePyjddjfqDx8hQ4o=
X-Google-Smtp-Source: APXvYqzZvfLS+8VnKHXJ/gKRV68+/+ZR0qAM+q3szoJTvYMSf7xZjvmvXkY8/dwYTxinJNbbv1kWxEhXGa1cLdaHsHE=
X-Received: by 2002:a37:66c7:: with SMTP id a190mr67245391qkc.44.1558486573857;
 Tue, 21 May 2019 17:56:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190521230939.2149151-1-ast@kernel.org> <20190521230939.2149151-4-ast@kernel.org>
 <CAEf4BzZrK1Fw211ef9psBxOoP_vV9tH2Hre1DJSqUsp7iX7bSg@mail.gmail.com> <2a067f93-c607-34fc-1c34-611ed4a8f6a0@fb.com>
In-Reply-To: <2a067f93-c607-34fc-1c34-611ed4a8f6a0@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 21 May 2019 17:56:02 -0700
Message-ID: <CAEf4BzZ1r2brvaJvdXnpUD=Et9Ysp6361esRrDD_rPG4u4h7tA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/3] selftests/bpf: add pyperf scale test
To:     Alexei Starovoitov <ast@fb.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        Kernel Team <Kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 21, 2019 at 5:50 PM Alexei Starovoitov <ast@fb.com> wrote:
>
> On 5/21/19 5:36 PM, Andrii Nakryiko wrote:
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/bpf/progs/pyperf.h
> >> @@ -0,0 +1,268 @@
> >> +// SPDX-License-Identifier: GPL-2.0
> >> +// Copyright (c) 2019 Facebook
> >
> > Maybe let's include a link to an up-to-date real tool, that was used
> > to create this scale test in BCC:
> > https://github.com/iovisor/bcc/blob/master/examples/cpp/pyperf/PyPerfBPFProgram.cc
>
> I thought about it, but decided not to,
> since this hack is not exactly the same.
> I tried to keep an idea of the loop though
> with roughly the same number of probe_reads
> and 'if' conditions, but was chopping all bcc-ism out of it.
> In the commit log: "Add a snippet of pyperf bpf program"
> By "a snippet" I meant that it's not the same thing,
> but close enough from verifier complexity point of view.
> Existing pyperf works around the lack of loops with tail-calls :(
> I'm thinking to reuse this hack as future bounded loop test too.
>
> Another reason to avoid the link is I'm hoping that pyperf
> will move from 'examples' directory there into proper tool,
> so the link will become broken.

Ok, fair enough.
