Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE5D5318F9D
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 17:14:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231768AbhBKQLa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 11:11:30 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31335 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231432AbhBKQJD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 11:09:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613059651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=U5PLl0pnoPm3WuHY1EjyZO2JoihwnMKEwl2Dz7ozuvg=;
        b=botdyEwQdeQLdWKIRIYVLq4kSQjFkyrpA3ZrxmouJFynfKqLN8YkTorNST1FL7fsOwG/Fk
        20yWzRUU2UHRmaxRGxucHXITfD9B5RyONvuGBoPpXGmAIIVbBd+n6d3rTQlulN7Yh0Ar32
        U4gEW/8G6+E5u9bmeQXryhMGYwC2qKA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-55-e7neWtIkMRGbf99CUcnwAQ-1; Thu, 11 Feb 2021 11:07:27 -0500
X-MC-Unique: e7neWtIkMRGbf99CUcnwAQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A13BA107ACC7;
        Thu, 11 Feb 2021 16:07:24 +0000 (UTC)
Received: from krava (unknown [10.40.192.105])
        by smtp.corp.redhat.com (Postfix) with SMTP id 5EEEC5D9D2;
        Thu, 11 Feb 2021 16:07:21 +0000 (UTC)
Date:   Thu, 11 Feb 2021 17:07:20 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Veronika Kabatova <vkabatov@redhat.com>,
        Jiri Olsa <jolsa@kernel.org>
Subject: Re: FAILED unresolved symbol vfs_truncate on arm64 with LLVM
Message-ID: <YCVWONQEBLfO/i2z@krava>
References: <YCKB1TF5wz93EIBK@krava>
 <YCKlrLkTQXc4Cyx7@krava>
 <CAEf4BzaL=qsSyDc8OxeN4pr7+Lvv+de4f+hM5a56LY8EABAk3w@mail.gmail.com>
 <YCMEucGZVPPQuxWw@krava>
 <CAEf4BzacQrkSMnmeO3sunOs7sfhX1ZoD_Hnk4-cFUK-TpLNqUA@mail.gmail.com>
 <YCPfEzp3ogCBTBaS@krava>
 <CAEf4BzbzquqsA5=_UqDukScuoGLfDhZiiXs_sgYBuNUvTBuV6w@mail.gmail.com>
 <YCQ+d0CVgIclDwng@krava>
 <YCVIWzq0quDQm6bn@krava>
 <CA+icZUXdWHrNh-KoHtX2jC-4yjnMTtA0CjwzsjaXfCUpHgYJtg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUXdWHrNh-KoHtX2jC-4yjnMTtA0CjwzsjaXfCUpHgYJtg@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 11, 2021 at 04:43:48PM +0100, Sedat Dilek wrote:

SNIP

> > > filled with elf functions start/end values, right?
> > >
> > > >                         /*
> > > >                          * We iterate over sorted array, so we can easily skip
> > > >                          * not valid item and move following valid field into
> > > >
> > > >
> > > > So the idea is to use address segments and check whether there is a
> > > > segment that overlaps with a given address by first binary searching
> > > > for a segment with the largest starting address that is <= addr. And
> > > > then just confirming that segment does overlap with the requested
> > > > address.
> > > >
> > > > WDYT?
> >
> > heya,
> > with your approach I ended up with change below, it gives me same
> > results as with the previous change
> >
> > I think I'll separate the kmod bool address computation later on,
> > but I did not want to confuse this change for now
> >
> 
> I have applied your diff on top of pahole-v1.20 with Yonghong Son's
> "btf_encoder: sanitize non-regular int base type" applied.
> This is on x86-64 with LLVM-12, so I am not directly affected.
> If it is out of interest I can offer vmlinux (or .*btf* files) w/ and
> w/o your diff.

if you could run your tests/workloads and check the new change does not
break your stuff, that'd be great

we need soem testsuite ;-) I have some stupid test script which runs over
few vmlinux binaries and check the diff in BTF data.. problem is that these
vmlinux binaries are ~300M each, so it's not great for sharing

also I was checking if we could use BPF_BTF_LOAD syscall and load BTF in
kernel and back at the end of pahole processing to check it's valid ;-)

thanks,
jirka

