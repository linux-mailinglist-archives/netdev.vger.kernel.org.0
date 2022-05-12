Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F7D85255A3
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 21:22:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357971AbiELTWP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 15:22:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbiELTWN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 15:22:13 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5A1468F95;
        Thu, 12 May 2022 12:22:10 -0700 (PDT)
Received: from mail-yb1-f169.google.com ([209.85.219.169]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1Mj8a5-1oIluv3iCL-00fElD; Thu, 12 May 2022 21:22:09 +0200
Received: by mail-yb1-f169.google.com with SMTP id m128so11591007ybm.5;
        Thu, 12 May 2022 12:22:08 -0700 (PDT)
X-Gm-Message-State: AOAM5331aHptf+lw3AX9aPXN0HrSnFIWobeG8UJsbDTHryfTGoVWFcFL
        HMTQLwEiD1BCZkGEteQN6KWwCJrZbXK4HlRqfQY=
X-Google-Smtp-Source: ABdhPJzoF6z4JQCWRSwljX3/FJlSLwjXIkDzitEtgdhb7tvIxKk1FfPhJUdb+6KPaTTEYn0vEU7vm15YINajDJQHVl4=
X-Received: by 2002:a25:c604:0:b0:645:d969:97a7 with SMTP id
 k4-20020a25c604000000b00645d96997a7mr1319828ybf.134.1652383327455; Thu, 12
 May 2022 12:22:07 -0700 (PDT)
MIME-Version: 1.0
References: <20220509150130.1047016-1-kuba@kernel.org> <CAK8P3a0FVM8g0LG3_mHJ1xX3Bs9cxae8ez7b9qvGOD+aJdc8Dw@mail.gmail.com>
 <20220509103216.180be080@kernel.org> <9cac4fbd-9557-b0b8-54fa-93f0290a6fb8@schmorgal.com>
 <CAK8P3a1AA181LqQSxnToSVx0e5wmneUsOKfmnxVMsUNh465C_Q@mail.gmail.com>
 <d7076f95-b25b-3694-1ec2-9b9ff93633b7@schmorgal.com> <CAK8P3a3Tj=aJM_-x17uw1yJ-5+DgKX6APgEaO0sa=aRBKya1XQ@mail.gmail.com>
 <0078ff43-f9fa-1deb-b64d-170d3d93ee6f@workingcode.com>
In-Reply-To: <0078ff43-f9fa-1deb-b64d-170d3d93ee6f@workingcode.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 12 May 2022 21:21:50 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0xmXYU5iNki3BX25J73jcy+xJ=bf67G6PqAHjRwckFRA@mail.gmail.com>
Message-ID: <CAK8P3a0xmXYU5iNki3BX25J73jcy+xJ=bf67G6PqAHjRwckFRA@mail.gmail.com>
Subject: Re: [PATCH net-next] net: appletalk: remove Apple/Farallon LocalTalk
 PC support
To:     James Carlson <carlsonj@workingcode.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, Doug Brown <doug@schmorgal.com>,
        Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>, linux-ppp@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:5HAwyDECutgGFX3S3eiyWYePbhjvOXDKRx/s5A+2yM9OIhaG+u2
 EuseHFdgzz5T2p51sSiKYQ/Wr6HmzPHOew06e7LYCcQ/urGbshpc4DAUQrckDvE/S+fmA4L
 lymbH2NHZCztC4P22O4ZaLjLYTcBNnMd1/WQfMUJGMLS64PKPt0A5gRxHMNN2T2hVlDgRBp
 LXvmB8qOO6jqayIKyPgHA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:VqJ9cU6dS1A=:2I5LodyTyEBJq0MrsjXMdi
 FIuYLPWU49B189L+E89Gbi38OyiSWad3+8gX+0yQmT/l0PN5T/BAkof6Y5tt89QaFlyiBkI7k
 ffCm/wUmBoncf2fjhkJ86STAguwFnt6sFppr30gdXecxz1CjIalUT6HTWh0xllNWYWQ8+KPyQ
 RIeAeHPFY6n0Zk3wX0agmfAychF7JHFwPLGuxb+KC2k+XdztYKcBlWopJF80SYf5zcp9QMcxQ
 HEDzniGxs1lFaWsnX6TPNoNlXWaTMlmAqyhDM1w0afkA5GIsBepnbX67zj1dXxJTDKnVleWCu
 3o0J3oE2+ARialzCJZUoK+AkibrXYVXcq/ZOuMJRSRoxaZvHqY6J0xjNvVXgNEgLU8QafdvR3
 1xM1IUK7SA1GsscuyZk/I623VZ6o7eMnG3nMxL6IhdVd334MSHO/ztdp7bNZ8RBeh51JH6cLd
 4Eysvb4P4lnKcXVGxij88qwmWM8zGB3n5gnRNsyuzEzjA8vUZxh6rNMjiY6iw2gWG4EVV7o/S
 GHJxvIvFVQmFNNQSCIt+W7Y26jcZvPxkRpYFmFRbsR4LYGpgxWJXYY/Fi9wzZjKLt4lvcdYLO
 /hkeVqI01nPQu0DdbTBo0MRIFwpWSTEAFB8tT7+J/kbnbnVe6pHLDoajl6LXfA1qDZSC7FWqT
 49zkemvtfjmOZpGoCqoUBhCXw3frJ3A66ykXXJM0cL+uUDFrJz+yPASQrWfc4bo7XeHOZ16NE
 gm5iIgDTSIM+KDG8+TeSVASOuym6+v663ihMgu16j/05pIcOUf7byrdHCRG01XqcOQa6YFyH4
 2cDTniUAEElxitYzRH739LFH4IkSvYippwqGZR0MoKugGNiCEA=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 12, 2022 at 8:11 PM James Carlson <carlsonj@workingcode.com> wrote:
>
> On 5/11/22 04:23, Arnd Bergmann wrote:
> > indication of appletalk ever being supported there, this all looks
> > IPv4/IPv6 specific. There was support for PPP_IPX until it was
> > dropped this year (the kernel side got removed in 2018), but never
> > for PPP_AT.
> > Adding Paul Mackerras to Cc, he might know more about it.
>
> I waited a bit before chipping in, as I think Paul would know more.
>
> The ATCP stuff was in at least a few vendor branches, but I don't think
> it ever made it into the main distribution. These commits seem to be
> where the (disabled by default) references to it first appeared:
>
> commit 50c9469f0f683c7bf8ebad9b7f97bfc03c6a4122
> Author: Paul Mackerras <paulus@samba.org>
> Date:   Tue Mar 4 03:32:37 1997 +0000
>
>     add defs for appletalk
>
> commit 01548ef15e0f41f9f6af33860fb459a7f578f004
> Author: Paul Mackerras <paulus@samba.org>
> Date:   Tue Mar 4 03:41:17 1997 +0000
>
>     connect time stuff gone to auth.c,
>     don't die on EINTR from opening tty,
>     ignore NCP packets during authentication,
>     fix recursive signal problem in kill_my_pg

Right, I had seen those in the git history, but neither of them actually
does anything with appletak.

> The disabled-by-default parts were likely support contributions for
> those other distributions. (Very likely in BSD.)
>
> I would've thought AppleTalk was completely gone by now, and I certainly
> would not be sad to see the dregs removed from pppd, but there was a
> patch release on the netatalk package just last month, so what do I know?

I think netatalk 3.0 dropped all appletalk protocol stuff a long time ago and
only supports AFP over IP.

         Arnd
