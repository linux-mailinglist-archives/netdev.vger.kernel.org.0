Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47C3C48B3
	for <lists+netdev@lfdr.de>; Wed,  2 Oct 2019 09:41:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726981AbfJBHl2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Oct 2019 03:41:28 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:43350 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726933AbfJBHl2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Oct 2019 03:41:28 -0400
Received: by mail-qt1-f193.google.com with SMTP id c3so25110106qtv.10;
        Wed, 02 Oct 2019 00:41:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qUqxejXCWWOZwizJyqCtQinix21SQ9Npf4IfNuwlbEU=;
        b=GIV/78XFhAdZYpwjknajQcq61aU2k0XhewBadc7/N4SPJje+c5PoeHPd++UwFrxgCm
         h6nLrLAxV0aZ0OHM9R3peJ0JXoDNu5cSl2HPsZstdpVGytReUMlkI9VgH7MVMHtsi5V8
         aELOluuNzlzouZh4UQsd8cjDfwrHV+Id66JeKwi76e03cs/Y8vMHeIimjroXXV0xUs/J
         ydNt8uz50ffv7jyCa2xCY6QL1HdXI8O31o9ZAbEoXV+hnQvdSdub0MS4du82UJIG8ues
         wBwrgaq7CQ0S41UYCeCTx3BNq+6Avtipl7UouU0o5JIQXgW/Hb5jXuAU3PTkJZnHOEsO
         EiCA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qUqxejXCWWOZwizJyqCtQinix21SQ9Npf4IfNuwlbEU=;
        b=QFlW41z3M0wHr1MLpxHanVgfTInEqzCbqT3/ZmPWUAYI4Yx2ff7dsIyojpUVkbfgLD
         EBOLyDHenN4PXRtVZjyccI9o822muuYcEVTbDIdtnsqnVrTmFmVWIR1o3rlmi6WYl95g
         zrB0bd15GQF0NgG/TNhf9Z/1nQQ6NGvGc1wsoYkIs/IloaWsY1okLwiaUA2DiCise5du
         EL3Y1JULwRFXqBLXWyOP2hY2KME6VAXAFsdN8NUZjBfMj4ia2YcBfLR+vwT3TCpNrvQa
         WQjFFIHPbTg08N3jgR3q8b4F4Aqc55Nrf2uwyJp9wE/unJp48iJ3Hmc/4cpz1FwTr4qz
         Wm8A==
X-Gm-Message-State: APjAAAXcsFKq5InKcfcqmWW2SAabC6jsDGj/xvuoyTQTFYalq3VztWeg
        e3BcEwyJCobp7F77lccqmycQGei/zipa/CoUzRx4LQt8uzodTOTc
X-Google-Smtp-Source: APXvYqyM5XlageXxsPCyZ0V0fsnO7FrSU69xKOJjb/wMW1GUYyvQiXoNMh9xaMg/e76ratnvv/cDdpdNNpYCzQ0fXSA=
X-Received: by 2002:ac8:3f96:: with SMTP id d22mr2730687qtk.36.1570002087071;
 Wed, 02 Oct 2019 00:41:27 -0700 (PDT)
MIME-Version: 1.0
References: <20191001101429.24965-1-bjorn.topel@gmail.com> <CAK7LNATNw4Qysj1Q2dXd4PALfbtgMXPwgvmW=g0dRcrczGW-Fg@mail.gmail.com>
 <CAJ+HfNgvxornSfqnbAthNy6u6=-enGCdA8K1e6rLXhCzGgmONQ@mail.gmail.com> <CAK7LNATD4vCQnNsHXP8A2cyWDkCNX=LGh0ej-dkDajm-+Lfw8Q@mail.gmail.com>
In-Reply-To: <CAK7LNATD4vCQnNsHXP8A2cyWDkCNX=LGh0ej-dkDajm-+Lfw8Q@mail.gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Wed, 2 Oct 2019 09:41:15 +0200
Message-ID: <CAJ+HfNgem7ijzQkz7BU-Z_A-CqWXY_uMF6_p0tGZ6eUMx_N3QQ@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     Networking <netdev@vger.kernel.org>,
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

On Wed, 2 Oct 2019 at 03:49, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
[...]
> > Yes, the BPF samples require clang/LLVM with BPF support to build. Any
> > suggestion on a good way to address this (missing tools), better than
> > the warning above? After the commit 394053f4a4b3 ("kbuild: make single
> > targets work more correctly"), it's no longer possible to build
> > samples/bpf without support in the samples/Makefile.
>
>
> You can with
>
> "make M=3Dsamples/bpf"
>

Oh, I didn't know that. Does M=3D support "output" builds (O=3D)?

I usually just build samples/bpf/ with:

  $ make V=3D1 O=3D/home/foo/build/bleh samples/bpf/


Bj=C3=B6rn
