Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 697A41D1EFC
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 21:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390601AbgEMTXs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 15:23:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732218AbgEMTXr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 15:23:47 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0BD3C061A0C;
        Wed, 13 May 2020 12:23:46 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id c21so514643lfb.3;
        Wed, 13 May 2020 12:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/jOv1NOLRsHqsQztqH64EpYSKbBy9HAYKF//rByts0Q=;
        b=K7RiASkbBK2tXe8OycWpQPpaXXFiR6YNmO35L2M00Ji8VBWj7ysefCaB3Il91zlLb4
         GDLnGfFZ2WhXiBqcpRbl4PKY5uMZHvW+CrviJLlQudZK+t31iNNzoH0bTAGUHl/FCz1K
         B1KHgwliaQVXJpys11PgJ5dGkdvKu2L9IIPJR+LOvKgOOxXbb5OIfKelHM6JXMU4gx3w
         HLCRQIxkxNrA1WJp4Wh9JHPFW5GSp/tX51+6JpIC7Snpn8DOvXkiSdO8UXzIlA1nJTX2
         vff07IcpTg/jBPEEOg7b12mNBYA0qtGYQ8lvRC7M3oKYkN2y4/DvOuCSCflx32i6Faxt
         VHFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/jOv1NOLRsHqsQztqH64EpYSKbBy9HAYKF//rByts0Q=;
        b=HXrjD31AtK9F1xyi7nntySoymvILZprsUGrala3fWpb9F6qegCSr8lWl5O1ybJM1Mo
         rLvsiaMaYLf5DfCECcyGZ+Tv20iWv7mUlY1fgUzeHpO67nJjk1IleKULFEWI6nZ/SUQN
         CR6vQi9mUGE6CJJwC3ONOHSGw4PvjK8dcaGV4BAzb93TZgoZDd9F+uF7+EvJooq3RHSf
         ZfTJsM1N4TNScXEbLPl/xgAIIGjrZ1Zv87LkEMmn4RYhKG3W7/3IEzmu/G2k8bcdYD26
         okEN0QwZV52mG9OfMCV5d3eRrSabdeCdXK0NiBq+q5UoLv2qT1XmQygjyS9F4ev3Bu1T
         pFww==
X-Gm-Message-State: AOAM533W2n6M6WTVKcjmMPWZK3n3AQMekXnvbq5ohT4bxReep+xutdq9
        dWBdgV44g0twutQjaFDysN/XTJgH5gPN/eXRhZE=
X-Google-Smtp-Source: ABdhPJxio/iAUEBqH8MyKFCMZgaSRsh/wl9IxqeQZg+B8euNs6pLkdaTfqEIbmaOTKDJzFARM1ScwgKmeVEfA0mEfn0=
X-Received: by 2002:ac2:442f:: with SMTP id w15mr646882lfl.73.1589397825344;
 Wed, 13 May 2020 12:23:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200512192445.2351848-1-andriin@fb.com>
In-Reply-To: <20200512192445.2351848-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 13 May 2020 12:23:33 -0700
Message-ID: <CAADnVQ+VdbzyRh0vUAZb4CaAUa9yncwSudswXozD+eS17yRT4Q@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 0/4] Add benchmark runner and few benchmarks
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 12, 2020 at 12:47 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add generic benchmark runner framework which simplifies writing various
> performance benchmarks in a consistent fashion.  This framework will be used
> in follow up patches to test performance of perf buffer and ring buffer as
> well.
>
> Patch #1 extracts parse_num_list to be re-used between test_progs and bench.
>
> Patch #2 adds generic runner implementation and atomic counter benchmarks to
> validate benchmark runner's behavior.
>
> Patch #3 implements test_overhead benchmark as part of bench runner. It also
> add fmod_ret BPF program type to a set of benchmarks.
>
> Patch #4 tests faster alternatives to set_task_comm() approach, tested in
> test_overhead, in search for minimal-overhead way to trigger BPF program
> execution from user-space on demand.
>
> v2->v3:
>   - added --prod-affinity and --cons-affinity (Yonghong);
>   - removed ringbuf-related options leftovers (Yonghong);
>   - added more benchmarking results for test_overhead performance discrepancies;

Applied. Thanks
