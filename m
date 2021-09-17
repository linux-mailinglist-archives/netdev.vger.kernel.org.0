Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86A9440F31D
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 09:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240815AbhIQHWI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 03:22:08 -0400
Received: from mout.kundenserver.de ([217.72.192.73]:51335 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245232AbhIQHVn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 03:21:43 -0400
Received: from mail-wr1-f48.google.com ([209.85.221.48]) by
 mrelayeu.kundenserver.de (mreue108 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MZTua-1mMAcs3LDK-00WS52; Fri, 17 Sep 2021 09:20:20 +0200
Received: by mail-wr1-f48.google.com with SMTP id q11so13518569wrr.9;
        Fri, 17 Sep 2021 00:20:20 -0700 (PDT)
X-Gm-Message-State: AOAM532SPEcujl2QPc8IMXQq+pB0k0jfbvK/SuBo2KwYcL6z46u4ZTEU
        xZ8eNS4N/QpJ3cY/qjfn7bH78RuNQjyhLtIhNT8=
X-Google-Smtp-Source: ABdhPJzdJSJ6F33yjr0CdyRsW+lkSspPGo4OPRsF+cxt6MZwRHtL6vt7o+1q/fpUCntoF20xXvSiehvIPKe8B/Avb6s=
X-Received: by 2002:adf:f884:: with SMTP id u4mr9944710wrp.411.1631863220417;
 Fri, 17 Sep 2021 00:20:20 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYtFvJdtBknaDKR54HHMf4XsXKD4UD3qXkQ1KhgY19n3tw@mail.gmail.com>
 <CAHk-=wisUqoX5Njrnnpp0pDx+bxSAJdPxfgEUv82tZkvUqoN1w@mail.gmail.com>
 <CAHk-=whF9F89vsfH8E9TGc0tZA-yhzi2Di8wOtquNB5vRkFX5w@mail.gmail.com>
 <36aa5cb7-e3d6-33cb-9ac6-c9ff1169d711@linuxfoundation.org>
 <CAK8P3a1vNx1s-tcjtu6VDxak4NHyztF0XZGe3wOrNbigx1f4tw@mail.gmail.com>
 <120389b9-f90b-0fa3-21d5-1f789b4c984d@linuxfoundation.org>
 <CAFd5g47MgGCoenw08hehegstQSujT7AwksQkxA7mQgKhChimNw@mail.gmail.com>
 <3bad5d2f-8ce7-d0b9-19ad-def68d4193dd@linuxfoundation.org>
 <CAFd5g47bZbqGgMn8PVa=DaSFfjnJsLGVsLTYzmmCOpdv-TfUSQ@mail.gmail.com>
 <CAK8P3a0wQC+9_3wJEACgOLa9C5_zLSmDfU=_79h_KMSE_9JxRw@mail.gmail.com>
 <CAFd5g44udqkDiYBWh+VeDVJ=ELXeoXwunjv0f9frEN6HJODZng@mail.gmail.com> <CAFd5g45=vkZL-H3EDrvYXvhMM2ekM_CBGN0ySyKitq=z+V+EwQ@mail.gmail.com>
In-Reply-To: <CAFd5g45=vkZL-H3EDrvYXvhMM2ekM_CBGN0ySyKitq=z+V+EwQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 17 Sep 2021 09:20:03 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3Atk72vb=JkQjqhR4PL00aUBQLXfzDvh=4DL5=rp0FmQ@mail.gmail.com>
Message-ID: <CAK8P3a3Atk72vb=JkQjqhR4PL00aUBQLXfzDvh=4DL5=rp0FmQ@mail.gmail.com>
Subject: Re: ipv4/tcp.c:4234:1: error: the frame size of 1152 bytes is larger
 than 1024 bytes [-Werror=frame-larger-than=]
To:     Brendan Higgins <brendanhiggins@google.com>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Mathias Nyman <mathias.nyman@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ariel Elior <aelior@marvell.com>,
        GR-everest-linux-l2@marvell.com, Wei Liu <wei.liu@kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        open list <linux-kernel@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>, lkft-triage@lists.linaro.org,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        KUnit Development <kunit-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:NuzFJeT2aMzpmFAJp2FWhBboQZtDkCJ3CsY9dMo64jXv+b3OlFO
 wLArjBrjhW+OJ6FkE/gZgAKM4enM8I+N3MR4ao459xLvY/pbqzn0zvKvag8xyjibulHxBA5
 eCfYC8wESoyP3lNqK16uLh4fYcHErIK27l7I3FIMY+SVI5aVlR8ia2+bm/nCu4hKqh1BXZ1
 D0A83fVvDm6UFhBVafoVQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:1zdVGf48HAA=:uqg8nAYAAgG2DJ6eK2U1fU
 S9FS1ttaogLXKnWho96HiNIzqXi8cl5eq3RB0S0gzvqHsnZivEUhrzQ4fAF3pRnwOyYaPUEnZ
 3V3wLgcv5HMKzVGa/xRDM6PmFehpH0I1lPNRVdtIBaMaHVR0pxMPjtG/arVCMpWwo/9SGoCUW
 2HxRzAs/t3ijopGxrruoayi2Bq+1BSv+pjR8EGwH886LQUW19tzIlbm57PkV7/KWdypAMGqaE
 rlCPwJk+IdVO3tfXRHaZxjFHZDhtlqKO1RKalHhpZnDefatkD4MT3FWlFjypcOiaz6YxX9YL2
 T5PVJraRMhE5jkFjW+pJwSBUo4pMOE2eruFr+mz+e6Pb+OzZV6ulhkph3I1pFazb7TNZGw3Op
 xGvqIWhYzls6etVv5IPTbzTYp+WJvnkCcK7r330pKMpK40qNEC9Cb4OHT80IK+7Xg1//kReWP
 nAGrVP5W1OZwZXCc8HMYAf/d4hzqX96BRN4VDswiLFHMr9OZCpXN7hl+TLjBivSFx7sfguOoJ
 KaYsT9hsx/rQQnFRCFjoweCDw1YvDUkSqiZEcYZwuSSWEAhjdPdKeF6Jh6eUATbgo691Tq3ZM
 QNa1u2Zyc7SYqc4uTcHxIoygcBJjHvpUKuGPStrkus8WC1sm0+7XqK8hT4dxMb5n1zLIFr8uR
 B1EH9Ge6m1uWuKmB4Cnere0NXtJCuTQN1rfInS/0MX+KyAsnwSKPXd7p2ik/zMq6rxjvwhSKo
 OfM1vp8443ilWaSzcL8HzHxfZzZNSY/hVZsXW3u954nP7iATFbhEKw7ANIqDOA0j7yHWeJHk7
 pM3/7xUWsddCoIMM4rkxo3MgsOAz/MhUj0LY6COw8zImYOBme784tEtaBJyvqk/UkKT/2wnju
 v5Rx/d1IxiucLtUFAFnw==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 17, 2021 at 8:16 AM Brendan Higgins
<brendanhiggins@google.com> wrote:
>
> On Thu, Sep 16, 2021 at 10:39 PM Brendan Higgins
> <brendanhiggins@google.com> wrote:
> >
> > On Tue, Sep 14, 2021 at 3:04 PM Arnd Bergmann <arnd@arndb.de> wrote:
> > >
> > > On Tue, Sep 14, 2021 at 10:48 PM Brendan Higgins
> > > <brendanhiggins@google.com> wrote:
> > > >
> > > > On Mon, Sep 13, 2021 at 1:55 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
> > > > >
> > > > > On 9/8/21 3:24 PM, Brendan Higgins wrote:
> [...]
> > Alright, I incorporated all the above into a patchset that I think is
> > ready to send out, but I had a couple of issues with the above
> > suggestions:

Thanks a lot for those suggestions.

> > - I could not find a config which causes a stacksize warning for
> > sdhci-of-aspeed.

I keep a history of my randconfig builds. This one only happened
once before I fixed it, it may depend on some other combination of
options. See my original defconfig file at
https://pastebin.com/raw/XJxjVGYa
rand/0xAB2DD5A0-failure:/git/arm-soc/drivers/mmc/host/sdhci-of-aspeed-test.c:47:1:
error: the frame size of 1152 bytes is larger than 1024 bytes
[-Werror=frame-larger-than=]

> > - test_scanf is not a KUnit test.

I have three defconfigs for this one, all on x86-64:

rand86/0x30AD57FB-failure:/git/arm-soc/lib/test_scanf.c: In function
'numbers_list_field_width_val_width':
rand86/0x30AD57FB-failure:/git/arm-soc/lib/test_scanf.c:530:1: error:
the frame size of 2488 bytes is larger than 2048 bytes
[-Werror=frame-larger-than=]
rand86/0x30AD57FB-failure:/git/arm-soc/lib/test_scanf.c: In function
'numbers_list_field_width_typemax':
rand86/0x30AD57FB-failure:/git/arm-soc/lib/test_scanf.c:488:1: error:
the frame size of 2968 bytes is larger than 2048 bytes
[-Werror=frame-larger-than=]
rand86/0x30AD57FB-failure:/git/arm-soc/lib/test_scanf.c: In function
'numbers_list':
rand86/0x30AD57FB-failure:/git/arm-soc/lib/test_scanf.c:437:1: error:
the frame size of 2488 bytes is larger than 2048 bytes
[-Werror=frame-larger-than=]

https://pastebin.com/raw/jUdY6d3G is the worst one of those

> > - Linus already fixed the thunderbolt test by breaking up the test cases.

Ok.

> > I am going to send out patches for the thunderbolt test and for the
> > sdhci-of-aspeed test for the sake of completeness, but I am not sure
> > if we should merge those two. I'll let y'all decide on the patch
> > review.
>
> Just in case I missed any interested parties on this thread, I posted
> my patches here:
>
> https://lore.kernel.org/linux-kselftest/20210917061104.2680133-1-brendanhiggins@google.com/T/#t

Thanks! I'll reply to the particular patch as well, but I don't think
that this is
sufficient here:

+CFLAGS_bitfield_kunit.o := $(call
cc-option,-Wframe-larger-than=10240) $(DISABLE_STRUCTLEAK_PLUGIN)

If 10KB is actually needed, this definitely overflows the 8KB stack on
32-bit architectures.

         Arnd
