Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4934C27F435
	for <lists+netdev@lfdr.de>; Wed, 30 Sep 2020 23:29:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730544AbgI3V3M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 17:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725814AbgI3V3M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Sep 2020 17:29:12 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0530C061755;
        Wed, 30 Sep 2020 14:29:11 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id u3so566524pjr.3;
        Wed, 30 Sep 2020 14:29:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=krdj2l9/zX3VNUJIqLj3f0BayCuF+6p4hi/ge2raD4w=;
        b=jJFIVcIlQQVMUQ9crfaQ4mixdGXNa+urxhdrKgox2G9Hj5wUXLA7I+a9patHPP6LF8
         dStWbR9wWSHqh3ljihj8ETwqVT2RJGwXVTXhU6i1VJXNpwJd2RNnwjPlSw7d5sj0ENBx
         MQF/NgnB6lKnB3zf7pda2Z3Ea1Q9f/pa8ynpZGMJr5a2u9l31tK90kL8rsaU4bLJUCB7
         15bz/oU0Q36NzCsJ8Kdb3og38Vbnbw4/+9wKYuNJi8C9L5LTGzrt4xMTzIy0kuyi/W/c
         Tmwg6a+X/cOSat3JziCwx6KB2Og4uWJzYS5Nu6HYmY6A7rO4+esUCZc8vHIqPgh70oU+
         MTCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=krdj2l9/zX3VNUJIqLj3f0BayCuF+6p4hi/ge2raD4w=;
        b=WCcg35AZEAL5KyGadnR/L7YKyW2MF4X1DtlS+R6MD/S2M8fPqV5ZBnL2pC8eEBCdex
         KIAOAc9q8L+ME3eVqsDfRMnLgjUWN25YtLycTfc5WAA6UtTuy/2AUV0n2FpxPNZkmOaL
         XFHcR9seAI7+tWWZ4cHPtgiZevzFkmpeSvBWCEuIsSCwKJqMKV1LbgVBfrnTqtn5jmqP
         ouQR4yd8sRY2F45WLgcaG93DJDGc5FXvuG5g/rmLdvPTX1JvOhDUqFlP16p6IOLqX5me
         4KncgZQSVroe7Mu5F1SR1vPJnK/U5j18lUp3cKAZ8o0uimkWH6WkJYBNLppwUHwNxs5Y
         kPxw==
X-Gm-Message-State: AOAM533xVmAYBHvmQNc0OjebRoc0l7u6b67mtNIleHDNxt1yiPBa9gVM
        46s9DOLdgyjtqp+mqowRIeyZv3jqD6w=
X-Google-Smtp-Source: ABdhPJxd3Lrt1Ay7fx+Ht+hXsJhMaefcouFk43yUVKrkkJCxtQSbjiZhF5FcBvMnrI1CNM9m1AcAHA==
X-Received: by 2002:a17:90b:1111:: with SMTP id gi17mr4294987pjb.109.1601501351393;
        Wed, 30 Sep 2020 14:29:11 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:af79])
        by smtp.gmail.com with ESMTPSA id x192sm3621077pfc.142.2020.09.30.14.29.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 14:29:09 -0700 (PDT)
Date:   Wed, 30 Sep 2020 14:29:07 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH bpf-next 0/4] libbpf: add raw BTF type dumping
Message-ID: <20200930212907.mzg3g5522x3oobco@ast-mbp.dhcp.thefacebook.com>
References: <20200929232843.1249318-1-andriin@fb.com>
 <20200930000329.bfcrg6qqvmbmlawk@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYByimHd+FogxVHdq2-L_GLjdGEa_ku7p_c1V-hpyJrWA@mail.gmail.com>
 <20200930031809.lto7v7e7vtyivjon@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYBccn5eMNeTZDgU62kokkdTEK3wv5422_kDky3c_KWHw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzYBccn5eMNeTZDgU62kokkdTEK3wv5422_kDky3c_KWHw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 30, 2020 at 11:22:50AM -0700, Andrii Nakryiko wrote:
> 
> If you are saying it should emit it in Go format, Rust format, or
> other language-specific way, then sure, 

Yes. that's what I'm saying. cloudflare and cilium are favoring golang.
Hopefully they can adopt skeleton when it's generated in golang.
It would probably mean some support from libbpf and vmlinux.go
Which means BTF dumping in golang.

> maybe, but it sure won't
> re-use C-specific logic of btf_dump__dump_type() as is, because it is
> C language specific. For Go there would be different logic, just as
> for any other language.

sure. that's fine.

> And someone will have to implement it (and
> there would need to be a compelling use case for that, of course). And
> it will be a different API, or at least a generic API with some enum
> specifying "format" (which is the same thing, really, but inferior for
> customizability reasons).

yes. New or reusing api doesn't matter much.
The question is what dumpers libbpf provides.

> But JSON is different from that. It's just a more machine-friendly
> output of textual low-level BTF dump. It could have been BSON or YAML,
> but I hope you don't suggest to emit in those formats as well.

why not. If libbpf does more than one there is no reason to restrict.

> 
> > I don't think that text and json formats bring much value comparing to C,
> > so I would be fine with C only.
> 
> Noted. I disagree and find it very useful all the time, it's pretty
> much the only way I look at BTF. C output is not complete: it doesn't
> show functions, data sections and variables. It's not a replacement
> for raw BTF dump. 

Ok, but it's easy to add dumping of these extra data into vmlinux.h
They can come inside /* */ or as 'extern'.
So C output can be complete and suitable for selftest's strcmp.

> Regardless, feel free to drop patches #2 and #3, but patch #1 fixes
> real issue, so would be nice to land it anyways. Patch #4 adds test
> for changes in patch #1. Let me know if you want me to respin with
> just those 2 patches.

Applied 1 and 4. I was waiting to patchwork bot to notice this partial
application, but looks like it's not that smart... yet.
