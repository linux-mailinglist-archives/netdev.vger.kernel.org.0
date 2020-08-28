Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11800255D78
	for <lists+netdev@lfdr.de>; Fri, 28 Aug 2020 17:09:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728148AbgH1PJj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Aug 2020 11:09:39 -0400
Received: from mout.gmx.net ([212.227.15.18]:60873 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726219AbgH1PJa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 28 Aug 2020 11:09:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1598627357;
        bh=DHSogVUMzi78zWpOvfc2B22bD8Dq+/gVSofX3y66LXU=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:References:Date:In-Reply-To;
        b=ErOi0fxPP1YpdT9V07unCJ0N9Os1f4mT/xtZbIX6cJRsLfC9g2NOP3mFwH5iy7mHI
         ksYEjNKGdr88znfd4bmOhZJpPUB12/Qwi0DKhQKyO5wyJtaFxhKvPR7kylGnLRvD5I
         safvKLKNMmzDodKVeXAtOQ1FxgLG+qrYgTmE1VcA=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.223.54.124]) by mail.gmx.com
 (mrgmx005 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1MKsjH-1jslAf46ov-00LDvN; Fri, 28 Aug 2020 17:09:17 +0200
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 71D46800D6; Fri, 28 Aug 2020 17:09:12 +0200 (CEST)
From:   Sven Joachim <svenjoac@gmx.de>
To:     Brian Vazquez <brianvv@google.com>
Cc:     Stephen Rothwell <sfr@canb.auug.org.au>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the net-next tree
References: <20200729212721.1ee4eef8@canb.auug.org.au>
        <87ft8lwxes.fsf@turtle.gmx.de>
        <CAMzD94Rz4NYnhheS8SmuL14MNM4VGxOnAW-WZ9k1JEqrbwyrvw@mail.gmail.com>
        <87y2m7gq86.fsf@turtle.gmx.de> <87pn7gh3er.fsf@turtle.gmx.de>
        <CAMzD94Rkq1RTZJG5UsEz9VhaCBbvObD1azqU2gsJzZ6gPYcfag@mail.gmail.com>
Date:   Fri, 28 Aug 2020 17:09:12 +0200
In-Reply-To: <CAMzD94Rkq1RTZJG5UsEz9VhaCBbvObD1azqU2gsJzZ6gPYcfag@mail.gmail.com>
        (Brian Vazquez's message of "Thu, 27 Aug 2020 11:12:56 -0700")
Message-ID: <878sdyn6xz.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:JAwh0hO15KyXnI+YQ9StJR5PyVDu7BN/7rSGMcTAOqWwvXh2Lhq
 ZzR/y6xBpLpTtpf+M0qi0m7FcMRiXbdOm+LGgc68CCu9qF5fR/O4G7tirFGYsFV2k6E5ZFT
 6cVNf7o/URDdamyT/GLIy7tCrzQiiPFqfEbIvZFUDM7Hp6yLaR38hWe1J27JsOl5/tMJ+ZR
 f75MC22e2ynWBzoxjOxXg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:8wWBQwxm/q8=:UE8ywlmhjuveV4TEIhiLdL
 cX/ZCLJwYtJ07/UF6gluxo3y690dlMvFTe2yHdUO28EPmnPRedHshh5FRX38aiQ/8YPWtgeyQ
 KsjvR7OtfGAJIxMs88Yx1bPgzL4yl1EqgAX0ZIP4xq6zqbMX1mqDdyJtBp9Z7Dhr3Be9aR3Gj
 YWPFJhR+QjDKMP2LoiOKxhwU07lWE91HnYSBmGyocFoqmIop4fbvop5eid1BTie10QhAChFxR
 1/DnTckf0mqRRhIZ6vgHqvLzWvrwtP0ES40MPqVoSofzqKOB7FlSaukQVO8MeWwXV0fRZIK13
 FkYMehUjBudzOduO00n97Vl56D2IezTJ5ho4r/YzPWVq5axBjThfe6ElzNL6W0lKoZ/LIPy8S
 0ToxfS8avkoebeSfvZoWMAMD04LmRzN/aKx8/kD8SUuJacVqjbpA2HrAp3jk4MkrjxhRTtE40
 Wzj0uTPpnUsUCNhFwDEpOtau/3XZ7yTLsWPQ29Y9NtjmVQc3vM/99qv7HRqsFJHAQD73Exaxs
 v4sLLt4n+nxCsdCKCYVNEiuSWufO2AoMC7/Jm6s8NbDH8XXyjMjh0H4hVmYjkGjvilCt9dTmc
 RIHbl196wDOWXb6qngJyRYS3JfRXe1xTREARZvlJr0AMRlFZ10tUUJaCT3WbOkGpgjwWRQaCe
 /o4i413fKaMVfO9aooyMnk59tNxOBvT0yF5FgbjSMJkHyGhFVVStEHv44K+3aI15Lzd+88lrw
 uJ9uI0mID/OHpYVveP9OpaF2BruQZ4ID0EkbKIHrwiA18gwroT1cDmJQnoy++ubfqRh6UrL+s
 XLq335JNrXvOz7u/5r+HFJLB7Pl9I5t0fdrnc0drMJxNGHsTRaJf7IGEddHpeLww1IWrxRkOM
 fh6L7lpeod9Yee18dQdahWQ+uYo1A24oRMfM3l95C9Xau07tWAp51tk3KMaUxFrTihfq9Wnz0
 I6IDtb5iQPPN9AjL8h09pWNuA2CZQUN6tnoWUhCf3AycfUJ/bDRNb6K/nuFcyP3whqola3ir7
 k7Au8n7vk60ZujE6Y4JxYWY1FRgQLHdWA0vuEfnpw/uoDwpfLU1iNXS2MzvqoOQpmHQvDRhkZ
 GQ9fdEaWQaZM1lqSKEaQxvimRXxpxFlDW1Vc2AoQhhOzCR/iu4zQWtOCBClZ/gFuUrHRqalmB
 8oaPGA7pYh55gjKQlbe1xPUPOyUaj8qGx0Y8XIwoBYIaWC9kWe8RWI60CJTNi2E6tB3mN1TJB
 ikDjFRHg5LYXvo5MC
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-27 11:12 -0700, Brian Vazquez wrote:

> I've been trying to reproduce it with your config but I didn't
> succeed. I also looked at the file after the preprocessor and it
> looked good:
>
> ret = ({ __builtin_expect(!!(ops->match == fib6_rule_match), 1) ?
> fib6_rule_match(rule, fl, flags) : ops->match(rule, fl, flags); })

However, in my configuration I have CONFIG_IPV6=m, and so
fib6_rule_match is not available as a builtin.  I think that's why ld is
complaining about the undefined reference.

Changing the configuration to CONFIG_IPV6=y helps, FWIW.

> Note that fib4_rule_match doesn't appear as the
> CONFIG_IP_MULTIPLE_TABLES is not there.
>
> Could you share more details on how you're compiling it and what
> compiler you're using??

Tried with both gcc 9 and gcc 10 under Debian unstable, binutils 2.35.
I usually use "make bindebpkg", but just running "make" is sufficient to
reproduce the problem, as it happens when linking vmlinux.

Cheers,
       Sven


> On Mon, Aug 24, 2020 at 1:08 AM Sven Joachim <svenjoac@gmx.de> wrote:
>>
>> On 2020-08-22 08:16 +0200, Sven Joachim wrote:
>>
>> > On 2020-08-21 09:23 -0700, Brian Vazquez wrote:
>> >
>> >> Hi Sven,
>> >>
>> >> Sorry for the late reply, did you still see this after:
>> >> https://patchwork.ozlabs.org/project/netdev/patch/20200803131948.41736-1-yuehaibing@huawei.com/
>> >> ??
>> >
>> > That patch is apparently already in 5.9-rc1 as commit 80fbbb1672e7, so
>> > yes I'm still seeing it.
>>
>> Still present in 5.9-rc2 as of today, I have attached my .config for
>> reference.  Note that I have CONFIG_IPV6_MULTIPLE_TABLES=y, but
>> CONFIG_IP_MULTIPLE_TABLES is not mentioned at all there.
>>
>> To build the kernel, I have now deselected IPV6_MULTIPLE_TABLES.  Not
>> sure why this was enabled in my .config which has grown organically over
>> many years.
>>
>> Cheers,
>>        Sven
>>
>>
>> >> On Mon, Aug 17, 2020 at 12:21 AM Sven Joachim <svenjoac@gmx.de> wrote:
>> >>
>> >>> On 2020-07-29 21:27 +1000, Stephen Rothwell wrote:
>> >>>
>> >>> > Hi all,
>> >>> >
>> >>> > After merging the net-next tree, today's linux-next build (i386
>> >>> defconfig)
>> >>> > failed like this:
>> >>> >
>> >>> > x86_64-linux-gnu-ld: net/core/fib_rules.o: in function
>> >>> `fib_rules_lookup':
>> >>> > fib_rules.c:(.text+0x5c6): undefined reference to `fib6_rule_match'
>> >>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x5d8): undefined reference to
>> >>> `fib6_rule_match'
>> >>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x64d): undefined reference to
>> >>> `fib6_rule_action'
>> >>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x662): undefined reference to
>> >>> `fib6_rule_action'
>> >>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x67a): undefined reference to
>> >>> `fib6_rule_suppress'
>> >>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x68d): undefined reference to
>> >>> `fib6_rule_suppress'
>> >>>
>> >>> FWIW, I saw these errors in 5.9-rc1 today, so the fix in commit
>> >>> 41d707b7332f ("fib: fix fib_rules_ops indirect calls wrappers") was
>> >>> apparently not sufficient.
>> >>>
>> >>> ,----
>> >>> | $ grep IPV6 .config
>> >>> | CONFIG_IPV6=m
>> >>> | # CONFIG_IPV6_ROUTER_PREF is not set
>> >>> | # CONFIG_IPV6_OPTIMISTIC_DAD is not set
>> >>> | # CONFIG_IPV6_MIP6 is not set
>> >>> | # CONFIG_IPV6_ILA is not set
>> >>> | # CONFIG_IPV6_VTI is not set
>> >>> | CONFIG_IPV6_SIT=m
>> >>> | # CONFIG_IPV6_SIT_6RD is not set
>> >>> | CONFIG_IPV6_NDISC_NODETYPE=y
>> >>> | CONFIG_IPV6_TUNNEL=m
>> >>> | CONFIG_IPV6_MULTIPLE_TABLES=y
>> >>> | # CONFIG_IPV6_SUBTREES is not set
>> >>> | # CONFIG_IPV6_MROUTE is not set
>> >>> | # CONFIG_IPV6_SEG6_LWTUNNEL is not set
>> >>> | # CONFIG_IPV6_SEG6_HMAC is not set
>> >>> | # CONFIG_IPV6_RPL_LWTUNNEL is not set
>> >>> | # CONFIG_NF_SOCKET_IPV6 is not set
>> >>> | # CONFIG_NF_TPROXY_IPV6 is not set
>> >>> | # CONFIG_NF_DUP_IPV6 is not set
>> >>> | # CONFIG_NF_REJECT_IPV6 is not set
>> >>> | # CONFIG_NF_LOG_IPV6 is not set
>> >>> | CONFIG_NF_DEFRAG_IPV6=m
>> >>> `----
>> >>>
>> >>> > Caused by commit
>> >>> >
>> >>> >   b9aaec8f0be5 ("fib: use indirect call wrappers in the most common
>> >>> fib_rules_ops")
>> >>> >
>> >>> > # CONFIG_IPV6_MULTIPLE_TABLES is not set
>> >>> >
>> >>> > I have reverted that commit for today.
>> >>>
>> >>> Cheers,
>> >>>        Sven
>> >>>
