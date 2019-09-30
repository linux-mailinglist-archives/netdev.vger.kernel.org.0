Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CFF15C2894
	for <lists+netdev@lfdr.de>; Mon, 30 Sep 2019 23:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731729AbfI3VS6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Sep 2019 17:18:58 -0400
Received: from mout.web.de ([212.227.17.12]:58629 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729326AbfI3VS5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Sep 2019 17:18:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1569878336;
        bh=ld0nkOh5IJxdvmrYJA0YSKFu/Ce+P7sqgUBwKBFA/uM=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=cIKvggl6Iu223aDLHopKr27lZcZZ9mYaxEgSSoDn830j9nsiH+4Ba9t++z5zypOad
         4vbDmpGfDgisXN1wodo+di3Xwp5PeazV7LnfJPpO5FA9ZYl6DKTtArtxpg4346E/r0
         X9baKMEOgH86HydtlBFBLAjgpIW8kiQRrrLOjZIs=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from minako.localnet ([95.91.225.238]) by smtp.web.de (mrweb103
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0MWj2N-1icu5w0dvH-00XvoZ; Mon, 30
 Sep 2019 20:34:35 +0200
From:   Jan Janssen <medhefgo@web.de>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Vedang Patel <vedang.patel@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Detlev Casanova <detlev.casanova@gmail.com>
Subject: Re: Regression: Network link not coming up after suspend/resume cycle
Date:   Mon, 30 Sep 2019 20:34:33 +0200
Message-ID: <3036994.I2UMLGIuuM@minako>
In-Reply-To: <CA+h21hqm9jaKu4PgzkgcgMyu5gEMLSVmL=9sti1X88EOWNakuQ@mail.gmail.com>
References: <71354431.m7NQiGp1Tu@minako> <CA+h21hqm9jaKu4PgzkgcgMyu5gEMLSVmL=9sti1X88EOWNakuQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V03:K1:QHf8GWhQya9qdeUSOlE1A1wlWxRWufj2FoZBsc0bXGccJ0RN0Kl
 3eyytyfShX9O0LjoYnHpt8omE6wRm4mnpxpyXph6uGv5XZOxJNKxPJedQILoDqnyi0XBoWo
 rAiNUzPd6VJKJRF+HqcFmXE3KrvN4TCkewxOyjK3fyv5OZKnhhSrNetDkTpDARQpwF5nHWJ
 OUUMWeuYRr5SR0xLVIL1w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:JtzPd3V9XsA=:/fRYIkyyAUxNrb5255EgkB
 nCw68heOM4GWuRj1qB9Jb6sFKZsDZMY1NdD1zcL+OWruiAWX0IkK+IF44J+U2q6VWGXdj05FE
 unqaDvPh58A2NjTNovG0FDwsMgXU6vY7GsXfbI7nxFbTYoc00VQWlD3v3LWQDM+fb6dF1bfor
 Q4bosVPnTeqGPC4dIZCe5K4b3jxM2qDYaoMz3ZwNyxVGt/gTgVmbveLLMgzDw1W5L7ZDgDVCz
 EEuHQ72cwfbKcC138unvARhbZutQ6EebfPjLwhNum1nbkSTTbFFCIETMixHo620tAQM2U5N7Y
 vZctoErdbHfbAjWu4hH3bLUnPPwZ6UqIa8WYB+GwXjR4fsEXIp594C8Yhd8hpfzOjYvrnPwl9
 MoFiaDZWZPeuEAcHLVoZElf1aOhvRkmHisUTWJSIagaW/y+jlBW+cyygJPXRRTtYcoOfv/DGn
 qyhHzj5NRh+Gn6zJxPko6+A4aBDkfhKVlA+CjbdJrWNafRuBixGJ02YJTSdfSIZp/ZZbqYcZt
 blnIrrCu7d8pXZYbgw0FtpI20i1WsgObO5pwHn3JCAw7sbhr56k127nKb3b9VTJEWoQBbsxSV
 UPq80ByGrGlhzzntm2YHioqWF/WO1VBs5oRC7eEi2LEizwDE5I3mNDEZ2gGJS8oxKLHKFgrnq
 z6Ui8wph/DdTbr+ohyYKuRX0+wVuFwg9os2zhuEcLTeVcUnyxqnoD1hfYFPPYRHOE0veScQHa
 LCyyKx+hGmCwwyOQ+KloU0sow96MaCQdQPQc8NclJqyuX/bQ079XddJ4hbBijMFyX9jBEseYO
 MC7lENMs7TRufpVeeCDBeDaV7GC8R/1jS17d77+s//blBLZ7nZbPPUnKLAIHtwnTmHNpgfCLE
 WamVooBP0hUL0KXaWhWWJ4EEBqNFs2rkm1m6PYTsHZnWqSSrqJVyiPtPfW93EXUiYTCYXvwwb
 ZORXR60LH2WohQnKukaYtLb8jphRJNaEK5wBZebAzPsooGfIRgd0751yiRas4nApT2WL4ZsFR
 niH6F2Co07qUzgUypqP8lnTbP/oYaQYsg1s37XCfqqzprlVoptjtS/JkUQutv0odClqJv4GOD
 LSo9doJrh5S5sn7G3PbCW12HZu/woUw8FdnHnJpHf9J4GOoMaytFeM0OGUyzpRTOPrAWJ10f1
 dhghCB9j8TFdaGmFKCzYexinNZKIXqJ8ac9mIX2xQrdt5Ur+hkkjOWJqCzH1tlAkCn+2CgAMo
 DVkmqXz7exVu6vWZHqOaz+fq8APrlAdyx52Bv6OTzWuRmVe+4snlB/g4/Y5s=
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Monday, 30 September 2019 01:26:21 CEST Vladimir Oltean wrote:
> Hi Jan,
>
> On Sun, 29 Sep 2019 at 22:25, Jan Janssen <medhefgo@web.de> wrote:
> > Hi,
> >
> > I've been noticing lately that my network link sometimes does not go u=
p
> > after a suspend resume cycle (roughly 1 or 2 out of 10 times). This al=
so
> > sometimes happens with a fresh boot too. Doing a manual
> > "ip link set down/up" cycle resolves this issue.
> >
> > I was able to bisect it to the commit below (or hope so) and also CCed
> > the maintainer for my driver too.
> >
> > This is happening on a up-to-date Arch Linux system with a Intel I219-=
V.
> >
> > Jan
> >
> >
> >
> > 7ede7b03484bbb035aa5be98c45a40cfabdc0738 is the first bad commit
> > commit 7ede7b03484bbb035aa5be98c45a40cfabdc0738
> > Author: Vedang Patel <vedang.patel@intel.com>
> > Date:   Tue Jun 25 15:07:18 2019 -0700
> >
> > taprio: make clock reference conversions easier
> >
> > Later in this series we will need to transform from
> > CLOCK_MONOTONIC (used in TCP) to the clock reference used in TAPRIO.
> >
> > Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> > Signed-off-by: Vedang Patel <vedang.patel@intel.com>
> > Signed-off-by: David S. Miller <davem@davemloft.net>
> >
> > net/sched/sch_taprio.c | 30 ++++++++++++++++++++++--------
> > 1 file changed, 22 insertions(+), 8 deletions(-)
>
> That is a mechanical patch that produces no behavior change.
> Furthermore, even if distributions were to build with
> CONFIG_NET_SCH_TAPRIO (which there aren't many reasons to), it is
> extremely likely that this qdisc is not enabled by default on your
> interface. Are you voluntarily using taprio?
> You might need to bisect again.
>
> Regards,
> -Vladimir

You were right. The module wasn't even built.

I did a more careful bisection this time and got me this commit:

59653e6497d16f7ac1d9db088f3959f57ee8c3db is the first bad commit
commit 59653e6497d16f7ac1d9db088f3959f57ee8c3db
Author: Detlev Casanova <detlev.casanova@gmail.com>
Date:   Sat Jun 22 23:14:37 2019 -0400

    e1000e: Make watchdog use delayed work

    Use delayed work instead of timers to run the watchdog of the e1000e
    driver.

    Simplify the code with one less middle function.

    Signed-off-by: Detlev Casanova <detlev.casanova@gmail.com>
    Tested-by: Aaron Brown <aaron.f.brown@intel.com>
    Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

 drivers/net/ethernet/intel/e1000e/e1000.h  |  5 +--
 drivers/net/ethernet/intel/e1000e/netdev.c | 54 +++++++++++++++
+--------------
 2 files changed, 32 insertions(+), 27 deletions(-)


This time I also went and reverted it on top of v5.3, which successfully m=
ade
the issue go away. I've CC'ed the author of the patch.

Jan


