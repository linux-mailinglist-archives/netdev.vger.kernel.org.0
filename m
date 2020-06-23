Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8957F204744
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 04:29:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731434AbgFWC3K (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 22:29:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730456AbgFWC3J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 22:29:09 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59D69C061573;
        Mon, 22 Jun 2020 19:29:09 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id a14so2687091qvq.6;
        Mon, 22 Jun 2020 19:29:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Y34PuLuvoebTFHQz4NV34Ht84jRdx47rlhf4JZDyuZI=;
        b=pg+3wznSA9JX3kc7tzI6WmsnYb7R3HjwjQUJz6i87X/GdRH7AUnp5xrH/5o9Iq72TJ
         ecgIZvWwKNfGQdyu2ahShGPXxHrgVTrL3jKpw64Xrxc9xQ/30f083rgDfYyoxi3PNegI
         j/niEx1cqIL+WfKQxpcO+2RYOjb1uasK0yK1wkNbx3Hm7hcSaFWeO+ksbkwju52ykDiR
         D3vdOCbgKyjwvPim8kSQOipMAhh7wlgJmWQbJxtn5TjpKep1IJIL2lM8Lf4mYgW7rklr
         n9vj2DwKTBnbZDSOxS7K1d6+pOSVfgu0YFJfHX3cLd9q4lwM7mTg/HqhNL+FsuLLrY4T
         j3TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Y34PuLuvoebTFHQz4NV34Ht84jRdx47rlhf4JZDyuZI=;
        b=NoWeF8tP71/oqwkIC7nFxpR/dM9TB/ZTiaYeU/FRSgfJEhltKkixkllBTBNOR7yETP
         u5wr5QvXPm12dWov0JbzONXPUVswu4HQVOrUvwqwlQPoWFqbYsdjD6r/wtlGKzLP/UUF
         ITVXd2fwE/qI1CD2IrpnofvqFLKiF+xwvPsQdG2TlhnbXiKze2UgyaQOMM1bFITj0Iuv
         ZjSO5rG000VnaTDcDm389UnfI2M8R2+otVE6nZW5hZ/CjJNCyfrYRkpyV6XLUzvhfRyo
         6kGIOsVO2Ug16R/qvw54bVO3qS+g+/njpeAoohVhL8ON6VrgccIaFP34zNIDE10/8Xgu
         sURg==
X-Gm-Message-State: AOAM53115HPC1xv9OvaT/D6RHeB2uLb2vLLUv45/ZcOT4eV1Y5OXHPkR
        pFhxu1priDs7PEyQJYNMG20NClP59zF7wn44+nCayw==
X-Google-Smtp-Source: ABdhPJwRSDu5eC6xyDn8C4rnzIbdTs4Tf/UL2Zz7E4qSk5X0IobIglWrQ9BN5Ah16IiKEZyiCf3JdLlA38LEmB++4Fw=
X-Received: by 2002:ad4:598f:: with SMTP id ek15mr24483463qvb.196.1592879348496;
 Mon, 22 Jun 2020 19:29:08 -0700 (PDT)
MIME-Version: 1.0
References: <20200623000905.3076979-1-andriin@fb.com> <20200623000905.3076979-3-andriin@fb.com>
 <20200623003119.onlwey7ko5z6heyq@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200623003119.onlwey7ko5z6heyq@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 22 Jun 2020 19:28:57 -0700
Message-ID: <CAEf4BzZFPoqdvVBdyqY=t9Ccfvf-_VysJ7UR9L9qQ5-SxdPeKg@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next 3/3] selftests/bpf: add variable-length data
 concat pattern less than test
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        john fastabend <john.fastabend@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 5:31 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Jun 22, 2020 at 05:09:04PM -0700, Andrii Nakryiko wrote:
> > Extend original variable-length tests with a case to catch a common
> > existing pattern of testing for < 0 for errors. Note because
> > verifier also tracks upper bounds and we know it can not be greater
> > than MAX_LEN here we can skip upper bound check.
> >
> > In ALU64 enabled compilation converting from long->int return types
> > in probe helpers results in extra instruction pattern, <<= 32, s >>= 32.
> > The trade-off is the non-ALU64 case works. If you really care about
> > every extra insn (XDP case?) then you probably should be using original
> > int type.
> >
> > In addition adding a sext insn to bpf might help the verifier in the
> > general case to avoid these types of tricks.
> >
> > Signed-off-by: John Fastabend <john.fastabend@gmail.com>
>
> Please keep John's 'Author:' on the patch.
> git commit --author= --amend
> or keep 'From:' when you applied to your local git.

I manually re-did the patch, because it wasn't applying cleanly. I'll
use --author, though, I didn't know about it, thanks.

> Also add your SOB after John's.
> Even if you didn't change the patch at all.
> Same thing if you've reworked the patch.

ok, will do
