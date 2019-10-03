Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C7E8C983D
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 08:28:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726119AbfJCG21 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 02:28:27 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36421 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfJCG21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Oct 2019 02:28:27 -0400
Received: by mail-qt1-f196.google.com with SMTP id o12so2090484qtf.3;
        Wed, 02 Oct 2019 23:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=dgpU7h9PioQW3CizRRaaufetm3YcqCHPVa7SstLyeu4=;
        b=QFdYmEH9dLqwAW9/I4SEPQx3lC0CfSY7dqPcbeO7+nYIj3TXlYZPdoIJHT4CSYgb4r
         vHVN40f8grBFb3bxJsx24MzMr//M46ho6dggrSicn53UsHqjDHUpyXURQoUxQwfShAUq
         ScC/vOBQdw5tqGGtPSLzufEYAcrOLq35/so3ZFeOJPNjKCRooIDB3Exj0wyGQKuxvOWh
         39AA5xIpL8njnStqveYTDOlLVQ2RST8KIm1U2rkLWdeUHyuCZsuw7YPqH0lv7vj8EJ5E
         W/CKZZStdSjr/qXCDjs0CVt3FVTueEiOSi2tmlD8uBLgSGuMsG+EtaiN+uLplX2ZiFs9
         Ke6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=dgpU7h9PioQW3CizRRaaufetm3YcqCHPVa7SstLyeu4=;
        b=jbVG3LjWjI87PJ872sPAECtpgXlOaLk39eY+B8/VuAidqib4GD6842ptfh/NgIN2za
         6Mk53J6oM93baluLCN102dWP9r3reXpFBsUTUbauO4dSVUN4oLZa3YNcd9qf/Zu8cjD+
         cnhi5HIibDpt4IFxUvrBMfYVsyLU8vg8Mo6Yo7rQBLdtJ1KvacdLcatu/xibFoQrMXpd
         0i0FTitdyqef9DQAZ4l2O47cVjbXgj9jgVh+rUMgo9cwaPannrKkHJSXruC2YMujCSSG
         HbsY+DuPp8gsXaKVApjklLE4FqrYMKgvFSirxAw7KHnd9gMkVLSk6d65Drr11T1dVTEG
         7PPg==
X-Gm-Message-State: APjAAAVe9jKEYhywO9dABZd1JhhM4OznGjYwjIab0IEBeLRPjowq8Ezt
        Oxor0bbSYOT3w6vVjJaiImxACZc/35NfumSWAIGmrBntH60WrQ==
X-Google-Smtp-Source: APXvYqysVuWAtPazJUsDrDS0BrXrwv3wVkdZJfligraFHUVD6BGj/+KQq/1DWWkwZJfvbeCIOa15+hYIBckJc7eu994=
X-Received: by 2002:ac8:3061:: with SMTP id g30mr8376963qte.46.1570084105800;
 Wed, 02 Oct 2019 23:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <20191001101429.24965-1-bjorn.topel@gmail.com> <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
 <CAJ+HfNgvxornSfqnbAthNy6u6=-enGCdA8K1e6rLXhCzGgmONQ@mail.gmail.com>
 <CAK7LNATD4vCQnNsHXP8A2cyWDkCNX=LGh0ej-dkDajm-+Lfw8Q@mail.gmail.com>
 <CAJ+HfNgem7ijzQkz7BU-Z_A-CqWXY_uMF6_p0tGZ6eUMx_N3QQ@mail.gmail.com> <20191002231448.GA10649@khorivan>
In-Reply-To: <20191002231448.GA10649@khorivan>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Thu, 3 Oct 2019 08:28:14 +0200
Message-ID: <CAJ+HfNiCrcVDwQw4nxsntnTSy2pUgV2n6pW206==hUmq1=ZUTA@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
To:     Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 3 Oct 2019 at 01:14, Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org> w=
rote:
>
> On Wed, Oct 02, 2019 at 09:41:15AM +0200, Bj=C3=B6rn T=C3=B6pel wrote:
> >On Wed, 2 Oct 2019 at 03:49, Masahiro Yamada
> ><yamada.masahiro@socionext.com> wrote:
> >>
> >[...]
> >> > Yes, the BPF samples require clang/LLVM with BPF support to build. A=
ny
> >> > suggestion on a good way to address this (missing tools), better tha=
n
> >> > the warning above? After the commit 394053f4a4b3 ("kbuild: make sing=
le
> >> > targets work more correctly"), it's no longer possible to build
> >> > samples/bpf without support in the samples/Makefile.
> >>
> >>
> >> You can with
> >>
> >> "make M=3Dsamples/bpf"
> >>
> >
> >Oh, I didn't know that. Does M=3D support "output" builds (O=3D)?
> >
> >I usually just build samples/bpf/ with:
> >
> >  $ make V=3D1 O=3D/home/foo/build/bleh samples/bpf/
> >
> >
> >Bj=C3=B6rn
>
> Shouldn't README be updated?
>

Hmm, the M=3D variant doesn't work at all for me. The build is still
broken for me. Maybe I'm missing anything obvious...


> --
> Regards,
> Ivan Khoronzhuk
