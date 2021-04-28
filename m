Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC26C36D17B
	for <lists+netdev@lfdr.de>; Wed, 28 Apr 2021 06:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235762AbhD1E4e (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Apr 2021 00:56:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47296 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232124AbhD1E4d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Apr 2021 00:56:33 -0400
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77452C061574;
        Tue, 27 Apr 2021 21:55:49 -0700 (PDT)
Received: by mail-pf1-x433.google.com with SMTP id q2so10948702pfk.9;
        Tue, 27 Apr 2021 21:55:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=CcYTOu1b38ebGLUtlhSKV6S0IeT5NY2d5w6ckQphKY8=;
        b=EYXa48VdS+lLz9y1e0otzrgt0rC6y4tNVQgJXB1hJ/IJJyK/Y7hfgJA2cZwAVeOVQL
         w+GXpapZ3De8n/lLDovRzZFmMmqTFRJJyYaZa9OQEjKGfsYrLt0MxeIUPFq2KFtta+eQ
         7IfCH+ylhCOu2H2vfQtjXdF1oJLKJeHKFKjeuvECHXkb1+gKRXOXNIxIOrhkQI6C9EGn
         SgNUKs0fJf5+SSf2BeymaVopI1fqQicF56UshX2A7vhTnoyB4rbs82OP4kooTWH1kLy2
         XST8eXLjCThbeS9Ko+BqknWwaHhTTEuUq4IfVv+AaGUS5PKIpW3s/YQ1lOL5Fg0/w6jt
         yl1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=CcYTOu1b38ebGLUtlhSKV6S0IeT5NY2d5w6ckQphKY8=;
        b=nADCqK1Z0WNwP09/V4XC12ZEr4iFcXk4xLJquCleOwsNqNPS033wEKeoRMY76eHybO
         yH4qwbZEjpJzCcEl0b5M3lzuv5zFxsQkwep8sGVRXBB5h/a9HFx/ZUnpxFEPyKnhRYNb
         AD33HeshMGsUKmNUaCHiW6JwYAekcKv42ibRzHQJ8+9Y06RhkCWEWMZnOyiHX6CMWy0r
         Nka3GGB/HVl1Vh/+bAcLXr03WzHejKFZZGU9/zeAmjqW0mJ9+9W8Ph5STBIArzYDTIhQ
         hBD6xVpADeewaqMb5HudCFQt6b+UsOtg2F3QxlMXHvwkkrgDIX/9ezRXJJnRCNeMnyOz
         2aXw==
X-Gm-Message-State: AOAM530GpSElbC7IyDoMpRJnSzBaBdJl4vwul6rOV2J/O2HylGgApVtk
        2UxO//eyRdGDixupI/bMCL0=
X-Google-Smtp-Source: ABdhPJy92USbNyCB9VcnQ/WHghasuwComnzkt8vnZuLKWx+cnVnecXyUskcKtMWNbOEvQ7jnWvCvTQ==
X-Received: by 2002:a63:40c1:: with SMTP id n184mr24957590pga.219.1619585748857;
        Tue, 27 Apr 2021 21:55:48 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:2e71])
        by smtp.gmail.com with ESMTPSA id 3sm3776575pff.132.2021.04.27.21.55.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 21:55:48 -0700 (PDT)
Date:   Tue, 27 Apr 2021 21:55:45 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during
 linking
Message-ID: <20210428045545.egqvhyulr4ybbad6@ast-mbp.dhcp.thefacebook.com>
References: <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
 <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com>
 <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
 <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
 <CAADnVQ+h78QijAjbkNqAWn+TAFxrd6vE=mXqWRcy815hkTFvOw@mail.gmail.com>
 <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com>
 <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzYZX9YJcoragK20cvQvr_tPTWYBQSRh7diKc1KoCtu4Dg@mail.gmail.com>
 <20210427022231.pbgtrdbxpgdx2zrw@ast-mbp.dhcp.thefacebook.com>
 <CAEf4BzZOwTp4vQxvCSXaS4-94fz_eZ7Q4n6uQfkAnMQnLRaTbQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZOwTp4vQxvCSXaS4-94fz_eZ7Q4n6uQfkAnMQnLRaTbQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 27, 2021 at 02:27:26PM -0700, Andrii Nakryiko wrote:
> 
> It's static for the purposes of BPF code, so no naming collisions in
> BPF code and no intentional or unintentional accesses beyond a single
> .bpf.c file. That's what we want. We don't want BPF library writers to
> worry about names colliding with some other library or user code. 

Who is 'we' ?
The skel gen by accident (probably) extended 'static' visibility
from .bpf.c into user space .c.
My point that it was a bad accident and I only realized it now.
The naming conflict in linking exposed this problem.
The selftests are relying on this 'feature' now.
Potentially some user could have used it as well.
Do I want to break that use case? Not really, but that's still an option.

I agree that library writers shouldn't worry about
naming conflicts in *.bpf.c space.
If they're exporting a static from .bpf.c into .c I think it's ok
to make them do extra steps.
Such 'static in .bpf.c' but 'extern into .c' should somehow work
without requiring people rename their vars.
I mean that the user of the library shouldn't need to do renames,
but the library author shouldn't rely on 'all statics are visible
in skel'.
In that sense what I proposed earlier to allow linking, but fail
skel gen is a step towards such development process.
Something like attr(alias()) or some other way hopefully can
help library authors create such library where static+something
is visible to library's skeleton, but users of the library
don't see its statics.
I think the static handling logic needs to be discussed
with your sub-skeleton idea.
If I got it correctly there will be something like this:
- lib.bpf.c compiled into lib.bpf.o
- main.bpf.c that links with lib.bpf.o
  It's all in *.bpf.c space and static has normal C scope.
  The static vars and maps in lib.bpf.c are not
  visible in main.bpf.c
- there is lib.c that works with lib.bpf.c via lib.skel.h
  that was generated out of lib.bpf.o
- main.c that links with lib.o
  main.c works with main.bpf.c via main.skel.h

I think lib.skel.h you were calling sub-skeleton.
pls correct me.
Since main.bpf.o was linked with lib.bpf.o
the main.skel.h will include the things from it.
But main.c shouldn't be accessing them, since that's the
point of the library.

At the same time lib.bpf.c and main.bpf.c could have been
just two files of the same project. If lib.bpf.o isn't a library
then main.skel.h should access it just fine.
So what is bpf library? How should it be defined?
And what is the scope and visibility of its vars/maps/funcs?
Unlike traditional C the bpf has two worlds .bpf.c and .c
So traditional 'static' doesn't cover these cases.

> And
> from the perspective of a user of two BPF libraries that have
> colliding names it's not great to have to somehow rename those
> libraries' internal variables through source code changes.

It's not great. That's why I'm trying to provoke a discussion
of more options and pick the best considering all + and -.

> 
> Omitting static variables from skeleton is a regression and will
> surprise existing users, we already went over this with you and
> Yonghong in previous emails.

Do I want to suffer this regression? No, but it could be the only option.

> Beyond that, it's not clear what exactly you are proposing. 

To discuss all options as a whole and hopefully you and others
can come up with more than what I proposed.

> For
> alias() seems like another variable with that "external_name" has to
> be already defined and you can't initialize var, it has to be just a
> declaration. And BTF doesn't capture attributes right now as well. And
> overall it sounds like an overly complicated approach both for users
> and for libbpf.

yes. supporting alias() would mean more work in clang, libbpf and
maybe new bits in BTF.

> As for the extra SEC() annotation. It's both not supported by libbpf
> right now, and it's not exactly clear how it helps with name conflicts
> (see example above with two libraries colliding). In that regard a
> prefix and ability to override it by user gives them an opportunity to
> resolve such naming conflicts. I know it's kind of ugly, but name
> overrides should hopefully be rarely needed.

Yes. it's not supported today. All I'm saying it's one of the options.

> What can I do to unblock BPF static linker work, though?

I believe that the way bpf toolchain interprets static is
a critical long term decision that shouldn't be done lightly.
There is no rush to define it quickly as an automatic prefix of filename
to all statics only because it's trivial to implement and sort-of works.
It's not something we can undo later. Today there are no libraries
and static definition of maps doesn't really work.
So the only regression (if we decide to change) would be the way skeleton
emits statics.

> I don't think we'll find an ideal solution that will satisfy everyone.

I think we didn't even start looking for that solution.
At least I'm only starting to grasp the complexity of the problem.
