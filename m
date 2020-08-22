Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E52224E5D3
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 08:16:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726878AbgHVGQm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 02:16:42 -0400
Received: from mout.gmx.net ([212.227.15.15]:46905 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725863AbgHVGQk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 22 Aug 2020 02:16:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1598076989;
        bh=Pds2nMEdMqJGmiN8TaXP+FYbIXOVvaSmTp36080KACw=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:References:Date:In-Reply-To;
        b=KnDAM6vkKh2/9L58XEF/UYN8Q1S0PXbNotY7T3ktmxy7dzQ+fIFQfAcQCorWmCIjm
         bw3yo1thRmLkvvsxgeZPG/fC8OtHO3N0ombjn3R+6dQyIp2cPlKJWrx1XvY0sKOkmO
         rdmZXLazgKfuGNq7CQLIerw3Jv6tvhxuRGDymVcc=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.223.54.124]) by mail.gmx.com
 (mrgmx004 [212.227.17.190]) with ESMTPSA (Nemesis) id
 1Mk0JW-1ktNsT1jzs-00kMlr; Sat, 22 Aug 2020 08:16:29 +0200
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 75AE5800D6; Sat, 22 Aug 2020 08:16:25 +0200 (CEST)
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
Date:   Sat, 22 Aug 2020 08:16:25 +0200
In-Reply-To: <CAMzD94Rz4NYnhheS8SmuL14MNM4VGxOnAW-WZ9k1JEqrbwyrvw@mail.gmail.com>
        (Brian Vazquez's message of "Fri, 21 Aug 2020 09:23:17 -0700")
Message-ID: <87y2m7gq86.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:vXMPwaa+GWBvgfx31Fh6V/bMiIMoiS8S+gl3mgGSj199RHnhCOX
 L8E71us4f9DvfWkSzMw4W1001t8xAt11HCeskYJa55GfHcTWfVVGflM/8DjckK32WkWM+yL
 MYUDKGcq6NGSrjwtvs3taO2PBg9o4HLA23+TDRemfhq4T/Io+xDvNM/HL/v7nc16jMUu08e
 gNlFdLYx6RFPKy3qbgExw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:V8drswwBsOE=:cNNLwN/v9CH3zRXLNN9gln
 2sfXCSHGM8/OaV5hjhzS8tPyImxRIThNQlaDAXUMdB5IfZre69tAzs5/pRjIw/riJUUD3mp1J
 vRBx+YdMKuVUM4ieR7fHs46Ohbqfxh1ahbB58Z155YZ92fPySnomhlF4ITqTqkzci3pDETajc
 scgc+z54PKUgghEo0AmoRTi/Xdo6ScIZ+KQZymzYL59HscsjNaviyhYNIYN2BcYjpY3CcImFB
 0Q0e1y0532vRBbXa+iZTZm0mZfwUK8blPO0MlyNaLfDCcoIv3MMlH4k440Hsw7+1Kb1W6k9vu
 nDC34pONadhbg0bDXFMFClHqrg3ZqnaEwdU75ZOKyu82b0fNjQOJHE991xjZLxw5WZC1/fz8s
 kerjT2Buu86GYEQGYqzYy72Z5XLJ+HuzMC1lHwQpKrEcTavZzt7vC/Lr/h6dnYbZld9lSaUUy
 IzOct6FYlJVefslSX78JviXjRJhMZ+RK6I+4eRkLi9Haj4BqTzaMgRcl4M9bP1i89P0K7YkHd
 UF+bgpMzN3UyyF4HOlHBfcc5bcSkCKkKm4mfkvsQ/McrStQm/mwYERGfUt0OIbnQvgAs7mJRk
 U4sPVTCvT1OqMfpimKnul+YEQglHj9FT/mvJRJYWygekSU3Php1hzRzSTrShwbyJeCxPPfEj3
 TmxE+vIi7iFvISpryQ0fC8bfcV6JF2qDxt82Y2tRtYFL8jmpyGPw3/8oSzwxW/WA990XO1PjK
 xUV2l2vubBj5DFHarn9PGMth3IKNf+KxfvF6nPpk9FCAY+hvwUEQhCoPFiDxQwrrqRDf2fhLv
 CVvZLyCYPJl7m1hIdIe+fVF8lttnIiGiikuTVSF2bxhDwJcyDfH3KMdFmHvUvR2Kn63MIlRXM
 dNFYJAiFaC0SK6SSlZ/8tEXFfgb8vZ63F+XgmJkfdwUS+H+NJc9KTBWEd9BS4gL0NrUjpAtAS
 sWd+VwGvZDd4BfQhOq8OvxTvPMkQjDyy0BTikpWPoe2eW006l/UiPFhGrxKquIT4JUH9/ntz+
 G0wHEZm0BAhblXhX8G3lLft2REica24vsi0p0aJppyDsBYjJ8lC+XPSZYbGnZxt2rBSchFdGx
 +WWAaZsBNZdyICryIqZaz9YhdLmf0U4EG5Tw6azegmBKBhTGbbBYqmQU/NwvYHJwSxSLIJ8Om
 eV1HQ5lfnyqy1vfntXtReyLKJdiyoydQvGx8nOz20FOsdz0ddieq2ICmDDsHHd603kF7oBjhr
 bs6fCkHtv5D9BIiQK
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-08-21 09:23 -0700, Brian Vazquez wrote:

> Hi Sven,
>
> Sorry for the late reply, did you still see this after:
> https://patchwork.ozlabs.org/project/netdev/patch/20200803131948.41736-1-yuehaibing@huawei.com/
> ??

That patch is apparently already in 5.9-rc1 as commit 80fbbb1672e7, so
yes I'm still seeing it.

Cheers,
       Sven

> On Mon, Aug 17, 2020 at 12:21 AM Sven Joachim <svenjoac@gmx.de> wrote:
>
>> On 2020-07-29 21:27 +1000, Stephen Rothwell wrote:
>>
>> > Hi all,
>> >
>> > After merging the net-next tree, today's linux-next build (i386
>> defconfig)
>> > failed like this:
>> >
>> > x86_64-linux-gnu-ld: net/core/fib_rules.o: in function
>> `fib_rules_lookup':
>> > fib_rules.c:(.text+0x5c6): undefined reference to `fib6_rule_match'
>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x5d8): undefined reference to
>> `fib6_rule_match'
>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x64d): undefined reference to
>> `fib6_rule_action'
>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x662): undefined reference to
>> `fib6_rule_action'
>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x67a): undefined reference to
>> `fib6_rule_suppress'
>> > x86_64-linux-gnu-ld: fib_rules.c:(.text+0x68d): undefined reference to
>> `fib6_rule_suppress'
>>
>> FWIW, I saw these errors in 5.9-rc1 today, so the fix in commit
>> 41d707b7332f ("fib: fix fib_rules_ops indirect calls wrappers") was
>> apparently not sufficient.
>>
>> ,----
>> | $ grep IPV6 .config
>> | CONFIG_IPV6=m
>> | # CONFIG_IPV6_ROUTER_PREF is not set
>> | # CONFIG_IPV6_OPTIMISTIC_DAD is not set
>> | # CONFIG_IPV6_MIP6 is not set
>> | # CONFIG_IPV6_ILA is not set
>> | # CONFIG_IPV6_VTI is not set
>> | CONFIG_IPV6_SIT=m
>> | # CONFIG_IPV6_SIT_6RD is not set
>> | CONFIG_IPV6_NDISC_NODETYPE=y
>> | CONFIG_IPV6_TUNNEL=m
>> | CONFIG_IPV6_MULTIPLE_TABLES=y
>> | # CONFIG_IPV6_SUBTREES is not set
>> | # CONFIG_IPV6_MROUTE is not set
>> | # CONFIG_IPV6_SEG6_LWTUNNEL is not set
>> | # CONFIG_IPV6_SEG6_HMAC is not set
>> | # CONFIG_IPV6_RPL_LWTUNNEL is not set
>> | # CONFIG_NF_SOCKET_IPV6 is not set
>> | # CONFIG_NF_TPROXY_IPV6 is not set
>> | # CONFIG_NF_DUP_IPV6 is not set
>> | # CONFIG_NF_REJECT_IPV6 is not set
>> | # CONFIG_NF_LOG_IPV6 is not set
>> | CONFIG_NF_DEFRAG_IPV6=m
>> `----
>>
>> > Caused by commit
>> >
>> >   b9aaec8f0be5 ("fib: use indirect call wrappers in the most common
>> fib_rules_ops")
>> >
>> > # CONFIG_IPV6_MULTIPLE_TABLES is not set
>> >
>> > I have reverted that commit for today.
>>
>> Cheers,
>>        Sven
>>
