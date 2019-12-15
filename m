Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4FECA11F9CA
	for <lists+netdev@lfdr.de>; Sun, 15 Dec 2019 18:42:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726346AbfLORms (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Dec 2019 12:42:48 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:37148 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbfLORms (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Dec 2019 12:42:48 -0500
Received: by mail-lf1-f66.google.com with SMTP id b15so2603872lfc.4;
        Sun, 15 Dec 2019 09:42:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=AUhydgvmr8d296EsM44KLtz5TapZKISR8Mk06Hsxmpw=;
        b=vWFc+ttySOUZBiFE/iWiSppbkP+sqNfBnoBw/J2iL3Hqn4Drlz+PSTvTjKoeD10YhC
         3csWHOkn+ooTHB0Jf6yLQJCRuUnfL7HGatXc6autez33cqhB0FG6joQQjnyuN1zZJFGO
         VG4xGVjI4NnpO0FY7fiXhS4h36Qs+khbbqtW69dIboGFkTPAq9zuqXv62BUVzmnNk7Lf
         ZFHXyQB/piXa+EiXO3wHJnIvjaWy9jG51X1lCbYn2X+UtjRLoFexDBIzDU5O+LCOpoCC
         OWCDq8F+YucbIjVP8gEqkdbDg+eLOrU6jF9oyLsXSM5uKOK+/xa2gQdTWCnwFrObtfuY
         ScZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=AUhydgvmr8d296EsM44KLtz5TapZKISR8Mk06Hsxmpw=;
        b=f48GNMusi0sWrlaN70M8aiLdES4418h6ZwZA1TMIa/w/h36SariKASxAUUkpJpLuOb
         3UU10pva5LSyyYe0xC1gicd8krb09eVHw0MSC17a9znqMPDC+b4rLNHQ+lQjKEOG5asw
         v1q4lzCP3XVveIEOC6oX3Qqbom7l2KplTZN9N0K1daw+a/KeY2kT3qVYZWNgxSMhC45v
         vb6k5M/jF17bCMV2a+TtZTgU4e0f0W6I6vyhua8ELpdAm3nIfMHXMdXiXrD2eZU9WP8k
         Id0fgzoSZpx5jTuv4kOKLJmwd/fxeMzHKIkc/CaxsswB+o62FSK/Fc+G41ckxq5PNjkF
         kuDg==
X-Gm-Message-State: APjAAAUiDKVB35gp5PpcA4u+2vaekrj6mOsgiP0BZs0skPkdRUms9xEk
        dutFJ9gkMGXjJ4A8wowc8N5DCaYU2/DGdO1AFFA=
X-Google-Smtp-Source: APXvYqxB9j2tqO8U7z+jhYOK+V++KM2dx+C8P8/kFICH+Gwd/b/A8Evh9Z1mIuzX8BRExtjVm/sbfnpJEeelvLvd5H8=
X-Received: by 2002:a19:48c5:: with SMTP id v188mr14502104lfa.100.1576431765980;
 Sun, 15 Dec 2019 09:42:45 -0800 (PST)
MIME-Version: 1.0
References: <20191201195728.4161537-1-aurelien@aurel32.net>
 <87zhgbe0ix.fsf@mpe.ellerman.id.au> <20191202093752.GA1535@localhost.localdomain>
 <CAFxkdAqg6RaGbRrNN3e_nHfHFR-xxzZgjhi5AnppTxxwdg0VyQ@mail.gmail.com>
 <20191210222553.GA4580@calabresa> <CAFxkdAp6Up0qSyp0sH0O1yD+5W3LvY-+-iniBrorcz2pMV+y-g@mail.gmail.com>
 <20191211160133.GB4580@calabresa> <CAFxkdAp9OGjJS1Sdny+TiG2+zU4n0Nj+ZVrZt5J6iVsS_zqqcw@mail.gmail.com>
 <20191213101114.GA3986@calabresa> <CAEf4BzY-JP+vYNjwShhgMs6sJ+Bdqc8FEd19BVf8uf+jSnX1Jw@mail.gmail.com>
In-Reply-To: <CAEf4BzY-JP+vYNjwShhgMs6sJ+Bdqc8FEd19BVf8uf+jSnX1Jw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 15 Dec 2019 09:42:34 -0800
Message-ID: <CAADnVQJY+URQfAk=372TUqVkB4dxNPqNVY8-eSe7mFXuY_XhRA@mail.gmail.com>
Subject: Re: [PATCH] libbpf: Fix readelf output parsing for Fedora
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Justin Forbes <jmforbes@linuxtx.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>, Yonghong Song <yhs@fb.com>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Aurelien Jarno <aurelien@aurel32.net>,
        debian-kernel@lists.debian.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 13, 2019 at 9:02 AM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Fri, Dec 13, 2019 at 2:11 AM Thadeu Lima de Souza Cascardo
> <cascardo@canonical.com> wrote:
> >
> > Fedora binutils has been patched to show "other info" for a symbol at the
> > end of the line. This was done in order to support unmaintained scripts
> > that would break with the extra info. [1]
> >
> > [1] https://src.fedoraproject.org/rpms/binutils/c/b8265c46f7ddae23a792ee8306fbaaeacba83bf8
> >
> > This in turn has been done to fix the build of ruby, because of checksec.
> > [2] Thanks Michael Ellerman for the pointer.
> >
> > [2] https://bugzilla.redhat.com/show_bug.cgi?id=1479302
> >
> > As libbpf Makefile is not unmaintained, we can simply deal with either
> > output format, by just removing the "other info" field, as it always comes
> > inside brackets.
> >
> > Cc: Aurelien Jarno <aurelien@aurel32.net>
> > Fixes: 3464afdf11f9 (libbpf: Fix readelf output parsing on powerpc with recent binutils)
> > Reported-by: Justin Forbes <jmforbes@linuxtx.org>
> > Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
> > ---
>
> I was briefly playing with it and trying to make it use nm to dump
> symbols, instead of parsing more human-oriented output of readelf, but
> somehow nm doesn't output symbols with @@LIBBPF.* suffix at the end,
> so I just gave up. So I think this one is good.
>
> This should go through bpf-next tree.
>
> Acked-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
