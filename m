Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B9A128AFB9
	for <lists+netdev@lfdr.de>; Mon, 12 Oct 2020 10:12:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728929AbgJLIMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Oct 2020 04:12:13 -0400
Received: from mout.kundenserver.de ([212.227.126.133]:33193 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726680AbgJLIMM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Oct 2020 04:12:12 -0400
Received: from mail-lj1-f181.google.com ([209.85.208.181]) by
 mrelayeu.kundenserver.de (mreue009 [212.227.15.129]) with ESMTPSA (Nemesis)
 id 1MfHIZ-1k0Fof3MUN-00grJn; Mon, 12 Oct 2020 10:12:10 +0200
Received: by mail-lj1-f181.google.com with SMTP id h20so16053270lji.9;
        Mon, 12 Oct 2020 01:12:10 -0700 (PDT)
X-Gm-Message-State: AOAM5319sCPFCO1m/EFZQJETJ9qxWIAYFT+81/0dxYCqYqZCsYAotpHj
        dovE/s9X6YEeJ3oRZ28e9hWzxINJcNBM4O6qbAA=
X-Google-Smtp-Source: ABdhPJzIbqkTuWB97PfBo7gju3+aGiKTNM1pYfIzgns4fQt7o6rczfccMS4P0CKvZwocCS9gab3dhvwjqV5QwnP1gQQ=
X-Received: by 2002:a2e:83c9:: with SMTP id s9mr9732795ljh.168.1602490330242;
 Mon, 12 Oct 2020 01:12:10 -0700 (PDT)
MIME-Version: 1.0
References: <20201001011232.4050282-1-andrew@lunn.ch> <20201001011232.4050282-2-andrew@lunn.ch>
 <CAKwvOdnVC8F1=QT03W5Zh9pJdTxxNfRcqXeob5_b4CXycvG1+g@mail.gmail.com>
 <20201002014411.GG4067422@lunn.ch> <CAKwvOdmdfwWsRtJHtJ16B0RMyoxUi1587OKnyunQd5gfwmnGsA@mail.gmail.com>
 <20201005194913.GC56634@lunn.ch> <CAK8P3a1qS8kaXNqAtqMKpWGx05DHVHMYwKBD_j-Zs+DHbL5CNw@mail.gmail.com>
 <20201005210808.GE56634@lunn.ch> <CAK7LNASB6ashOzmL5XntkPSq9a+8VoWCowP5CAt+oX0o=0y=dA@mail.gmail.com>
In-Reply-To: <CAK7LNASB6ashOzmL5XntkPSq9a+8VoWCowP5CAt+oX0o=0y=dA@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Mon, 12 Oct 2020 10:11:53 +0200
X-Gmail-Original-Message-ID: <CAK8P3a2LxR7BXhMktQN-Q-JpYq0ziMZVPHhu47k3CQ9OuKWUTg@mail.gmail.com>
Message-ID: <CAK8P3a2LxR7BXhMktQN-Q-JpYq0ziMZVPHhu47k3CQ9OuKWUTg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 1/2] Makefile.extrawarn: Add symbol for W=1
 warnings for today
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Nick Desaulniers <ndesaulniers@google.com>,
        netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Rohit Maheshwari <rohitm@chelsio.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:Sz/4HpuF9P/8YEsnst7dQ9gcRH+VX6Ilep+tWTvxNsXk54N094a
 VrSB99Ayx4smNRrJirD07ho+R3ArnJAqwsomp1GmdTRZcNcMEqimGvspWQhVZgwHzxGG6Mp
 AtsGNl5GTzU8O9CcKwL/nBj9tXb6GWQ8XrWxACOp4vwOkLMbdPwAqFELQj2gWAoeW4ZhaO4
 lXAYZyQh0EFzSWtIfiTUQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:e2R8m4lqZqM=:PqQ+D/PrTk66rQSLp5Kai3
 9nxGtE32LGI4bgjiuR0lmjF1US42V52PjUDuYXf0skN5+PX5ghvQ+dzwd92OMVLosFC75Pbfv
 mEwJ0dziobI1ubMXDHU1nscXReP9bNbWC33Z3CRZU2+M4FAqgprQuZs81NM2pjOhYqmHV3J22
 Rji1NcWXCJrgRiRUBkMx8UkGvfXQWc8EUwN0QbAu4BsPSkz52iRj8gmQlxWWzwdx9BNTOG8zP
 kjPc0oEV1q34Xap3jGsznhKO1/c+7tV+cO1HYwHl1htYY+AEx5fN8FHO0kLlkqxIMMfbZuQby
 3npTgoeiVDMew3OcnllCJj/DZCvLxZ4EDqFs87vStXFucVSLnlX5sdYZR1IFCCZLjeRspMVEE
 tikebACMLA2q6UdebRJmfgEq4y5pWXqPDbrhY1FppCejrveH8yHkqwjbGe4KhLPWPVq8v6sqS
 93dyt86APivtsdaBUjz0e+Mp5ocle9IzEi9ALvgjbsq39dqaXnVf7nl6XYClDTmrYnXrLdRxq
 7kTvDi8vsD8JvhcOatsXR+UJ/Mo9WY14mEAkcaDOKqExkNScxof/e6xSaJIQyP2nYjaNmWeJy
 3JQ5MkyAy/0D5/MyLAGfkgyITemTkr7mw1+FG4tH5bWt7o1KgGckr1Xd4EJyqB48UQ8LOxMiw
 rbbMcH1+F+trtMyr1CVRTtOu9JzfIZ325oAp6ZMDSAQJaClNrzKmztB6WS3BAiJWSsHLEoiDf
 igsffxiPpud9ZMHMdRMWr/eIiPt/fzPUTJwRjNoo7LqjP7kdg8C26PMuVcrLZTBnInzk0zbMB
 QfWzHCMsxOp3aNmGi37Cb2ZaYNP/y6TZXzkhENFC00Extxf9aDG9W0kBcHOJZxxGxVDbEhch5
 cj9o+5dpdpH0FA1Tagm+FKTHc/ogAYhgh8xkMxb/umbQmUnzkzjLVQ1ElhrDh6M71zmsdUVyB
 o64+PxaCFFtC3hmED0fNQenZaZHqB8VSogF0Sj1Oc2hb+k9brIWax
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 11, 2020 at 3:04 PM Masahiro Yamada <masahiroy@kernel.org> wrote:
> On Tue, Oct 6, 2020 at 6:08 AM Andrew Lunn <andrew@lunn.ch> wrote:
>
>
> I am not a big fan of KBUILD_CFLAGS_W1_<timestamp>
> since it is ugly.
>
> I'd like to start with adding individual flags
> like drivers/gpu/drm/i915/Makefile, and see
> how difficult it would be to maintain it.

I don't really like that either, to be honest, mostly because that is
somewhat incompatible with my plan to move all the warning flags
out the command line and into _Pragma() lines in header files.

> One drawback of your approach is that
> you cannot set KBUILD_CFLAGS_W1_20200930
> until you eliminate all the warnings in the
> sub-directory in interest.
> (i.e. all or nothing approach)
>
> At best, you can only work out from 'old -> new' order
> because KBUILD_CFLAGS_W1_20200326 is a suer-set of
> KBUILD_CFLAGS_W1_20190907, which is a suer-set of
> KBUILD_CFLAGS_W1_20190617 ...
>
>
>
> If you add flags individually, you can start with
> low-hanging fruits, or ones with higher priority
> as Arnd mentions about -Wmissing-{declaration,prototypes}.
>
>
> For example, you might be able to set
> 'subdir-ccflags-y += -Wmissing-declarations'
> to drivers/net/Makefile, while
> 'subdir-ccflags-y += -Wunused-but-set-variable'
> stays in drivers/net/ethernet/Makefile.

I agree with the goal though. In particular it may be helpful to pick
a set of warning flags to always be enabled without also setting
-Wextra, which has different meanings depending on compiler
version, or between gcc and clang.

I wonder how different they really are, and we can probably find
out from https://github.com/Barro/compiler-warnings, but I have
not checked myself.

      Arnd
