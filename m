Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A95D15C32B
	for <lists+netdev@lfdr.de>; Mon,  1 Jul 2019 20:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726970AbfGASkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jul 2019 14:40:04 -0400
Received: from mail-io1-f66.google.com ([209.85.166.66]:45949 "EHLO
        mail-io1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbfGASkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jul 2019 14:40:04 -0400
Received: by mail-io1-f66.google.com with SMTP id e3so31034382ioc.12;
        Mon, 01 Jul 2019 11:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uR2VCsJqLC5hH3BjSnUJ0SX9V/YuHMonqp4MnY/9zPo=;
        b=uaa8j8RSEmdx+3hPTajoin94mcySFGsHxzTKGTJibTf9a7AM3CKalIzRPt8oZ+BuZ8
         lPW79jsdsTQwCuiSZW5LYXQdI1qqz6tU8al2XR8vxEGkUTzUdPZZqur2sycNp4CqNr7p
         Nb6W3E/B3Mbl6fhl7TBsrft5VijZ7socnxOWq1myo2/xJ5dh0j6nzwCx+VjSBQ1GrbBi
         jp74Lc4wgv+Rb9dMuZ2LZ+sxqkLeDnH25SUQ+/Kp41YZD6pEeUtgT03iJIwFZVNoa07K
         3Gvcq6CHak30W/adYe608APFUHQ+YXlBdYHZqwlaGbeL8UTyO+/1c8uXMsQ487M59aPi
         aciA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uR2VCsJqLC5hH3BjSnUJ0SX9V/YuHMonqp4MnY/9zPo=;
        b=iAqgXLThP/r3a1DhqanTdnQZGfsGKjCTrE3ILMLbGsALXuVDkXGN7KB1bAae7TqB6Y
         UMAUt5P/SRspGmFzbbWiQUO1kYqrVWKFojLQ/yISUUtnA5ZXADvc7dC+WPY2mXTwNwTH
         svylFKXIdpISFcGmwqgRUIrzE2L80WiBrnAaonFBatyBmN3CllIqn1JgEmP5CgMlGTkX
         uYTawpBb688SzvS5xmUcqQdu0iTBPPu4JlHIbKQX2067IuvqYCIeCpy5jQohqL/CSs4K
         53SpqFJT2bKb9bsmW0CyCgYSkZMF/YfmL3L0VKGXLRKgZv4eAVVD4DFB4qtnd/jaokgZ
         skUw==
X-Gm-Message-State: APjAAAWmabU4NCj0SGwf08lkpsRRI+OxVk4oTUoQR1PXBiOmT+B/x2DG
        bZwNPAa+9x5n6c5Tfo18nNHXKr7bO8r7kA7dX+nc/O8D
X-Google-Smtp-Source: APXvYqwla8PKg9TGHKwpnLVufFBMd6UK00uPhNWO+XkaWaCr1XWfD3GL8Sl2fVlvw24U9FqTr2COgeewneyc9f351nU=
X-Received: by 2002:a5e:aa15:: with SMTP id s21mr26584810ioe.221.1562006403485;
 Mon, 01 Jul 2019 11:40:03 -0700 (PDT)
MIME-Version: 1.0
References: <4fdda0547f90e96bd2ef5d5533ee286b02dd4ce2.1561819374.git.jbenc@redhat.com>
 <CAPhsuW4ncpfNCvbYHF36pb6ZEBJMX-iJP5sD0x3PbmAds+WGOQ@mail.gmail.com> <CAPhsuW4Ric_nMGxpKf3mEJw3JDBZYpbeAQwTW_Nrsz79T2zisw@mail.gmail.com>
In-Reply-To: <CAPhsuW4Ric_nMGxpKf3mEJw3JDBZYpbeAQwTW_Nrsz79T2zisw@mail.gmail.com>
From:   Y Song <ys114321@gmail.com>
Date:   Mon, 1 Jul 2019 11:39:27 -0700
Message-ID: <CAH3MdRUbkswKAYiDSmhe9cdd-Jd=YmC0_PSLhzfY7vKv-zxCCA@mail.gmail.com>
Subject: Re: [PATCH bpf] selftests: bpf: fix inlines in test_lwt_seg6local
To:     Song Liu <liu.song.a23@gmail.com>
Cc:     Jiri Benc <jbenc@redhat.com>, Networking <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Mathieu Xhonneux <m.xhonneux@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 29, 2019 at 11:05 AM Song Liu <liu.song.a23@gmail.com> wrote:
>
> On Sat, Jun 29, 2019 at 11:04 AM Song Liu <liu.song.a23@gmail.com> wrote:
> >
> > On Sat, Jun 29, 2019 at 7:43 AM Jiri Benc <jbenc@redhat.com> wrote:
> > >
> > > Selftests are reporting this failure in test_lwt_seg6local.sh:
> > >
> > > + ip netns exec ns2 ip -6 route add fb00::6 encap bpf in obj test_lwt_seg6local.o sec encap_srh dev veth2
> > > Error fetching program/map!
> > > Failed to parse eBPF program: Operation not permitted
> > >
> > > The problem is __attribute__((always_inline)) alone is not enough to prevent
> > > clang from inserting those functions in .text. In that case, .text is not
> > > marked as relocateable.
> > >
> > > See the output of objdump -h test_lwt_seg6local.o:
> > >
> > > Idx Name          Size      VMA               LMA               File off  Algn
> > >   0 .text         00003530  0000000000000000  0000000000000000  00000040  2**3
> > >                   CONTENTS, ALLOC, LOAD, READONLY, CODE
> > >
> > > This causes the iproute bpf loader to fail in bpf_fetch_prog_sec:
> > > bpf_has_call_data returns true but bpf_fetch_prog_relo fails as there's no
> > > relocateable .text section in the file.
> > >
> > > Add 'static inline' to fix this.
> > >
> > > Fixes: c99a84eac026 ("selftests/bpf: test for seg6local End.BPF action")
> > > Signed-off-by: Jiri Benc <jbenc@redhat.com>
> >
> > Maybe use "__always_inline" as most other tests do?
>
> I meant "static __always_inline".

By default, we have
# define __always_inline        inline __attribute__((always_inline))

So just use __always_inline should be less verbose in your patch.

BTW, what compiler did you use have this behavior?
Did you have issues with `static __attribute__((always_inline))`?

>
> Song
