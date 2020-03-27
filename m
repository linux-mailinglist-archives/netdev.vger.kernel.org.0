Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53C80196112
	for <lists+netdev@lfdr.de>; Fri, 27 Mar 2020 23:26:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728167AbgC0W0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Mar 2020 18:26:14 -0400
Received: from mail-pj1-f68.google.com ([209.85.216.68]:55761 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727798AbgC0WZD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Mar 2020 18:25:03 -0400
Received: by mail-pj1-f68.google.com with SMTP id mj6so4435835pjb.5;
        Fri, 27 Mar 2020 15:25:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6wHgbUU8hfjvU2VSB/Vcj7AG1zPAtkX9XgjHdHGVJro=;
        b=Qce3fUWKaR+uXGShy3/LzjaJOvH5Kp3QTAZgyrVlrwJmvZLMcSqHRvFcNBpl3XXWsQ
         UFS0eK1PNpTZ95y9MVNOo7UEFLL44AYPEggKpx7AcTS8qOmuGSfARPU5eaORMpoTh4Za
         wFiF+jsQbhis54DAESmvj4ZZ4DZnhIyBZeD3TWTWsDZBgePEKzoMtQt2ROi9eAnf9ERY
         1vk2dN7ARp1afaaL/XuDydf3k5Z55l3L5x62qvJ1z0VQmLOyLBf2AD3LzTGACvjFMGbl
         POs1i+HXaq+qriMsiNqU9Pfx9DO76miiVCOMnk8dFp7AfKcXdL75WEqeTaV5FNauW7V2
         kTng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6wHgbUU8hfjvU2VSB/Vcj7AG1zPAtkX9XgjHdHGVJro=;
        b=ny++DxbpmDAq1b+ar5mTvUpZiths6zVKtjZLq6KJ/dcYATTaN5mDxoh4qXexAMMtPB
         Lib77Qn1C5/dXdJ5mPFHfJ0mlCpyRFXtyQ6gFg1kleaweGw5plLIxWjyGV9FuF/0dHZo
         Qvtw7fhmlvNoeh/86JcMTqYWcJPgvzGBKR9VwCmjvloKXegCOgUR3YZdiRr9maDmKbok
         VV2s+RbAVdMcsp2FIxEo/5UdcPIevOZCjc70G0yLJnR4XuewcpQBRec7vJtJxZ/tSIZ6
         bKJAdDrxogBYLGsNav42+0C110hEm6MzutKqMQ+daizVSBq/3NBtAk+NNHRDaYZH9122
         X3eQ==
X-Gm-Message-State: ANhLgQ2+vuxRM29ngodAsnSjzayhiEGa2eOEFVA6tt18cOX3Wu5ukYd6
        U19ijW3dpXmo2ddxFhZNhtY=
X-Google-Smtp-Source: ADFU+vut01tUTrDL1NXVF5paOhvhZ0HknFLlDEsD21TQFWypBUTpPq1UmUZkyIT/R2hu+yA1ifVhhw==
X-Received: by 2002:a17:90a:f98d:: with SMTP id cq13mr1697182pjb.105.1585347902020;
        Fri, 27 Mar 2020 15:25:02 -0700 (PDT)
Received: from ast-mbp ([2620:10d:c090:400::5:4ef7])
        by smtp.gmail.com with ESMTPSA id 74sm4854125pfy.120.2020.03.27.15.25.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2020 15:25:01 -0700 (PDT)
Date:   Fri, 27 Mar 2020 15:24:58 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Joe Stringer <joe@wand.net.nz>, Lorenz Bauer <lmb@cloudflare.com>,
        Yonghong Song <yhs@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Martin Lau <kafai@fb.com>,
        john fastabend <john.fastabend@gmail.com>
Subject: Re: call for bpf progs. Re: [PATCHv2 bpf-next 5/5] selftests: bpf:
 add test for sk_assign
Message-ID: <20200327222458.2m5zccyctqsk3xzx@ast-mbp>
References: <20200325055745.10710-1-joe@wand.net.nz>
 <20200325055745.10710-6-joe@wand.net.nz>
 <82e8d147-b334-3d29-0312-7b087ac908f3@fb.com>
 <CACAyw99Eeu+=yD8UKazRJcknZi3D5zMJ4n=FVsxXi63DwhdxYA@mail.gmail.com>
 <20200326210719.den5isqxntnoqhmv@ast-mbp>
 <CAOftzPjyCNGEjBm4k3aKK+=AB-1STDbYbQK5sZbK6gTAo13XuA@mail.gmail.com>
 <c5e50f60-3872-b3ec-7038-737ca08f3077@iogearbox.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c5e50f60-3872-b3ec-7038-737ca08f3077@iogearbox.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 27, 2020 at 09:16:52PM +0100, Daniel Borkmann wrote:
> 
> Perhaps that would be more useful and always up to date than a copy of the
> code base that would get stale next day? In the end in this context kernel
> changes and/or llvm changes might be of interest to check whether anything
> potentially blows up, so having a self-contained packaging might be useful.
> Thoughts?

Right now we have zero cilium progs in selftest :)
so any number of progs is better than nothing.

> > Do we just parachute the ~11K LoC of Cilium datapath into the kernel
> > tree once per cycle? 

I don't think 11k progs updated every kernel release will catch
much more than basic reduced set.
selftests/bpf is not a substitute for cilium CI.
I would prefer .c tests to be developed once and frozen.
More tests can be added every 6 month or so.
I think copy-paste is ok-ish too, but would be much better
to think through about aspects of the code first.
It worked well for fb xdp/tc progs. I took some of them,
refactored them to selftest/Makefile and they were kept as-is for
the last 3 years. While real progs kept being actively changed.
For example: progs/test_l4lb.c is about 1/10th of the real deal here:
https://github.com/facebookincubator/katran/tree/master/katran/lib/bpf
In terms of lines code, number of includes and so on.
While hacking katran into selftest I tried to capture the _style_ of C code.
Like:
 bool get_packet_dst(struct real_definition **real,
                     struct packet_description *pckt,
                     struct vip_meta *vip_info,
                     bool is_ipv6)
I wouldn't have written the prototype this way.
Passing double pointer as a return value as a first argument is not my style :)
The style of nested 'if', etc. Those are the things that make clang
generate specific code patterns that I was trying to preserve in selftests.

Example 2: progs/strobemeta.h is about 1/4 of real thing.
Yet frozen it was super useful for the work on bounded loops.

Example 3: progs/test_get_stack_rawtp.c is one specific code pattern
that used in our profiling prog.
This one was immensely helpful to track down jmp32/alu32 bugs.
It's the one that we're still fixing (see John's jmp32 work).

and so on.
selftests/bpf/progs don't need to be full copy-paste. Ideally the capture
the essence of the progs in the short form.

clang bpf backend and verifier smartness keep changing. So having
frozen selftests is necessary to see the trend and capture bugs
in the backend and in the verifier.
