Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27A78E9A69
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 11:53:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726783AbfJ3Kxd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 06:53:33 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:37354 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726096AbfJ3Kxd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 06:53:33 -0400
Received: by mail-qk1-f194.google.com with SMTP id u184so2216606qkd.4;
        Wed, 30 Oct 2019 03:53:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=8zfQv3Xki4Cwco9FWvIu+r1BeLLDFHeAY3R7QSmiuMo=;
        b=Glb/pI8vDZQT+iB1Ltkzc9PN1qYd+MB8Z1qRCP/KQih+4RPEk4C3vkbB1NkMED7lSc
         ZBKjH7X+FVQgD/2vngEhE79Mw6QRMj4vrkgGte1f1jV+VqFajDkfHm/FJCykKak0wZQB
         A3m/fpAifNUHRXajaeNwdCyIMF+5LIjdx2hCarVmkAdGPOJRs/Ap2n9hX+t3j2jpgKRe
         fzJ2RZuc43Vvdb6jMTvw7YXoJHFXVjQwTg6a1NF6kqxRHqOVxTkUbrxxoDd1liOiNqUH
         iRKSB6p/5LL2QQiiUV1WqBG2h2hERCQoRhaXhxZAr9DEKnNpjGv1KaBGyzbwoudL9GSM
         seyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=8zfQv3Xki4Cwco9FWvIu+r1BeLLDFHeAY3R7QSmiuMo=;
        b=eJ+F2yuX8dLJHhP1upu4s2bF3uLPBedp2ppbyhOb0nQOATc1sD6ypIv3J3YLXwvJGU
         FD3tXtcm9h+G17gMPX5fWurV4YL2nn/YPodFeJCAdal1MBjF8e0t7F3B+onPF+p2SIe8
         lCfu47Vk/Ex+auepDYjZsZhEzbXEWwimMNv6h0GbpPMlGDhda9Dumf1twQq4WkUB7+RG
         mpPPDqnExOs83IHpurOTe//qdk9a94Q0iR1kOXUGfSoRI4yx7ktkIHrpH+pgiX/tY1RF
         GIFOTyq/p+HtX9nOq6K8LaVIBw0EJ6UwAL0QLa7IPJc1bpMmpRZqhlssfmvoB5G8zood
         C4dA==
X-Gm-Message-State: APjAAAWas+hFbxlMk/r8lzcIlF16kmSPeT2Yp9ZirVenmi5Wz1CJGJcX
        XqyYOCRN4BeFCRgqYSMEuLravwO622LRcT/7/44=
X-Google-Smtp-Source: APXvYqz1DHXJvOx3DQNntXZk6zfb54piZB5aA5siCOTzUlgd8mL4J9ciwq9W1fGLzrcU6fLeXPrkDJZCQJiT9hlGHCU=
X-Received: by 2002:a05:620a:1364:: with SMTP id d4mr26418046qkl.218.1572432812006;
 Wed, 30 Oct 2019 03:53:32 -0700 (PDT)
MIME-Version: 1.0
References: <20191030114313.75b3a886@carbon>
In-Reply-To: <20191030114313.75b3a886@carbon>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 30 Oct 2019 11:53:21 +0100
Message-ID: <CAJ+HfNhSsnFXFG1ZHYCxSmYjdv0bWWszToJzmH1KFn7G5CBavQ@mail.gmail.com>
Subject: Re: Compile build issues with samples/bpf/ again
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        BPF-dev-list <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Eric Sage <eric@sage.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        Ilias Apalodimas <ilias.apalodimas@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 at 11:43, Jesper Dangaard Brouer <brouer@redhat.com> wr=
ote:
>
> Hi Maintainers,
>
> It is annoy to experience that simply building kernel tree samples/bpf/
> is broken as often as it is.  Right now, build is broken in both DaveM
> net.git and bpf.git.  ACME have some build fixes queued from Bj=C3=B6rn
> T=C3=B6pel. But even with those fixes, build (for samples/bpf/task_fd_que=
ry_user.c)
> are still broken, as reported by Eric Sage (15 Oct), which I have a fix f=
or.
>

Hmm, something else than commit e55190f26f92 ("samples/bpf: Fix build
for task_fd_query_user.c")?

> Could maintainers add building samples/bpf/ to their build test scripts?
> (make headers_install && make M=3Dsamples/bpf)
>
> Also I discovered, the command to build have also recently changed:
> - Before : make samples/bpf/   or  simply make in subdir samples/bpf/
> - new cmd: make M=3Dsamples/bpf  and in subdir is broken
>
> Anyone knows what commit introduced this change?
> (I need it for a fixes tag, when updating README.rst doc)
>
> --
> Best regards,
>   Jesper Dangaard Brouer
>   MSc.CS, Principal Kernel Engineer at Red Hat
>   LinkedIn: http://www.linkedin.com/in/brouer
>
