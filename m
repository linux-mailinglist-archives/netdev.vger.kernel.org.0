Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB9D22DB91
	for <lists+netdev@lfdr.de>; Sun, 26 Jul 2020 05:46:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728258AbgGZDqw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Jul 2020 23:46:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727101AbgGZDqw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Jul 2020 23:46:52 -0400
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DA4BC0619D2;
        Sat, 25 Jul 2020 20:46:52 -0700 (PDT)
Received: by mail-lf1-x143.google.com with SMTP id b30so7209501lfj.12;
        Sat, 25 Jul 2020 20:46:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ikuabT8VWStN+W6tQzPZZEVviS7mON42dmoBRas1K+8=;
        b=OEQJlVe+VsPN7v2t2zCG3VM5THnlYZe2FDKHJhKZViJE1DyrCRcNp18wSvwAXyVNkm
         mUAs7m/NpJnAxPGUB5gFG03iSOwgvuJK0dljmPyjJJymqnFeytdMF3BUJL1dlQGg5vyE
         /Hje70XiRVjORjoE9kWXwmy8bvrdMtnT7CTG7tG1E3sC6vIPrD7VV3nQv5g4RwCi2MQY
         e2FdHqtpe6cn3eljYEJ0hj0QiCTK5FRMert1DrsH2L2vGG3cEz1udhsrFUZhLN2x1YZE
         aZsMLAF25Qv1vWyzxsnKxLLWu6ZcGCqrwsnr/lsdl3ugdmRpkUOv7ahd2W6wfKd5FJNQ
         +fYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ikuabT8VWStN+W6tQzPZZEVviS7mON42dmoBRas1K+8=;
        b=K17RlndESEuujFXahv65W1HAjqF0CQkO5TByIgva37JdVegkleHlz2aTTUM5psS7/i
         XEzIOisrR4OjtN6qTHFSZkA3Nn2W3ibP1UasfU/vHSJ8xfiameSBcp+fk+MbdagAQJWk
         dTW3/PepxrbzNJxSK0uKkQwf6ceW6XCWQN8tyU4mBR7wKIepKv5rgBsP+5TpEKoY4axZ
         eipZo8n9bEvCk1iJ0mPzSvq6Hpc5y6ZF2oHiOQdEDLzFiwYwv5REX39clSokEpKfneSt
         Fe8h6xTdvvDmgc096CEjN0+3nEbDK7E+VUf9V2eFRqPG6mN21OyHJn1NrvADU2oiIECX
         kEvw==
X-Gm-Message-State: AOAM531qXzWvLLIQAa3DRIlLkfvkOTNTkdu4PaKYcJByBey97z7ePY9S
        Wf/D+tT6eAF32rbLtqOxgZFvmqu/RAJHoZU62tc=
X-Google-Smtp-Source: ABdhPJwu9WoP64XW2HQ0WL4P0mOdcel+R9MUVMXY+PNnY2jdIRrjRcF64qqLhW0u0yoqwl6izognUfSCqkg9EN4H4j4=
X-Received: by 2002:a05:6512:3610:: with SMTP id f16mr8587995lfs.8.1595735210604;
 Sat, 25 Jul 2020 20:46:50 -0700 (PDT)
MIME-Version: 1.0
References: <20200722064603.3350758-1-andriin@fb.com>
In-Reply-To: <20200722064603.3350758-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 25 Jul 2020 20:46:39 -0700
Message-ID: <CAADnVQLMMxCh36EgPqqL9hkXkbEX2C-nhzT5N7eVdr4Rf7nSug@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 0/9] BPF XDP link
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Ahern <dsahern@gmail.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 21, 2020 at 11:46 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Following cgroup and netns examples, implement bpf_link support for XDP.
>
> The semantics is described in patch #2. Program and link attachments are
> mutually exclusive, in the sense that neither link can replace attached
> program nor program can replace attached link. Link can't replace attached
> link as well, as is the case for any other bpf_link implementation.
>
> Patch #1 refactors existing BPF program-based attachment API and centralizes
> high-level query/attach decisions in generic kernel code, while drivers are
> kept simple and are instructed with low-level decisions about attaching and
> detaching specific bpf_prog. This also makes QUERY command unnecessary, and
> patch #8 removes support for it from all kernel drivers. If that's a bad idea,
> we can drop that patch altogether.
>
> With refactoring in patch #1, adding bpf_xdp_link is completely transparent to
> drivers, they are still functioning at the level of "effective" bpf_prog, that
> should be called in XDP data path.
>
> Corresponding libbpf support for BPF XDP link is added in patch #5.
>
> v3->v4:
> - fix a compilation warning in one of drivers (Jakub);

As far as I could review everything looks fine,
so I've applied the set.
The code is delicate. I wish people were more active doing code reviews.
So I encourage folks to still look at it. If there is anything missing I'm sure
Andrii will fix it up in the follow up.
