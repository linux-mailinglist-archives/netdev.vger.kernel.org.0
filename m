Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34A1885799
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 03:25:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730623AbfHHBZZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 21:25:25 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:42808 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388123AbfHHBZZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 21:25:25 -0400
Received: by mail-lf1-f67.google.com with SMTP id s19so2821778lfb.9;
        Wed, 07 Aug 2019 18:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=WALHYbL6Vte2cCvcL12sTP7SZuLz/kywiqxZgre8dac=;
        b=WaE2E25a/XQLbhz+KRClhx9IQzbUisle6+JsonQkA9e/ZX8/SuOc6eWrV5pd1gvLtA
         EjG7SOr+fWr5Lwhse5+1gCOwQ5eeQXuI1uMcI5DJRiXhciUiljwSompr7bKTUOz1Ue2i
         clTkNLHHPrbN/TXqdz5X5W7/bcBsQ0oGDkFFkt6NraPbh5aFhfamru1KM9+1nsVdt5fi
         xYEk98ecaD7hYYGTWmglccTed1BmP9DCEyHBfpKP41yUWQj745/86lg0xcKwnUx9Icra
         0fRXL9bPhH/vaXtnzW6wercvbMzPY/XLbvDCnGLofvPLv4hHzdKrPlr2NI4K/pyTVcCC
         WEcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=WALHYbL6Vte2cCvcL12sTP7SZuLz/kywiqxZgre8dac=;
        b=Wth+kksdgv/99RyqlA7Th8P6TtXzFO57jf3hwPip3zLbIDR7rS281LuaFpdXXZxwby
         62ZyjK+6u6vsvAYGS5nRNTC7z/qpBZPSz3/43RLOExnBOb7uKXhBzbKKK1O8CiUSL3+A
         8ccXfe+OJGU8lvrtPbvWvROpWk5yEgOOUjjYqtmnCMssKATS2dddG+UsjeqMSE08KKBf
         F1nUh0FdVBH1Dt7kSQ2wWh5DGPphD15XIfzbUtN7qmB39HO3LAK8E+kCkQgg+9xfwlFc
         wHl9kaQJipvEwgP0IqwWT3gj9SwFNFJRCjDC8Mrxmw+KgSQK1YAqpvp5FC+KdejnoB/9
         6Ehg==
X-Gm-Message-State: APjAAAWg1SKni217fqcOaKb5iv6T1YKuScxU/cTLSz7pqWsrh0yhYdHk
        3TLK5poU2EjiIMNxyyViasR6OmKCsxbnBPGpug5CZg==
X-Google-Smtp-Source: APXvYqwNA1pNFjPW3qrWYh3Pv1x//20EKmaPrJrk66WuONfbcbUPhPx+zbokR4x1lrUbF6LXPBLdw18VqB85fWqST/0=
X-Received: by 2002:ac2:465e:: with SMTP id s30mr7729531lfo.19.1565227522808;
 Wed, 07 Aug 2019 18:25:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190808003856.555097-1-yhs@fb.com>
In-Reply-To: <20190808003856.555097-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 7 Aug 2019 18:25:11 -0700
Message-ID: <CAADnVQKaKKHJrVd4Gi5-1hC42S02LPYEGzwn1MEaRB49FS43bw@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools/bpf: fix core_reloc.c compilation error
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 5:42 PM Yonghong Song <yhs@fb.com> wrote:
>
> On my local machine, I have the following compilation errors:
> =3D=3D=3D=3D=3D
>   In file included from prog_tests/core_reloc.c:3:0:
>   ./progs/core_reloc_types.h:517:46: error: expected =E2=80=98=3D=E2=80=
=99, =E2=80=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=
=80=98__attribute__=E2=80=99 before =E2=80=98fancy_char_ptr_t=E2=80=99
>  typedef const char * const volatile restrict fancy_char_ptr_t;
>                                               ^
>   ./progs/core_reloc_types.h:527:2: error: unknown type name =E2=80=98fan=
cy_char_ptr_t=E2=80=99
>     fancy_char_ptr_t d;
>     ^
> =3D=3D=3D=3D=3D
>
> I am using gcc 4.8.5. Later compilers may change their behavior not emitt=
ing the
> error. Nevertheless, let us fix the issue. "restrict" can be tested
> without typedef.
>
> Fixes: 9654e2ae908e ("selftests/bpf: add CO-RE relocs modifiers/typedef t=
ests")
> Cc: Andrii Nakryiko <andriin@fb.com>
> Signed-off-by: Yonghong Song <yhs@fb.com>

Applied. Thanks.
