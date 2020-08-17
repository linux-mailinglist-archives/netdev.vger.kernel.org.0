Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3DC6245DD6
	for <lists+netdev@lfdr.de>; Mon, 17 Aug 2020 09:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726835AbgHQHVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Aug 2020 03:21:17 -0400
Received: from mout.gmx.net ([212.227.17.20]:32923 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726194AbgHQHVO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 Aug 2020 03:21:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1597648863;
        bh=LDcWdHJDKvbRXTcscXlY+66WEBzsgmri1TA1vVDn7MY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:References:Date:In-Reply-To;
        b=BwB6onwTkfOx2BrJAfJ5l0uRVFpjF/4OPw1ONlxAn3nW9juC5b3AjZh69iMNRcO63
         ormbok+vsD9Ekv5eATRZ7b1sg5ZXbQKtDeMgTel0nRBZ5DNjsV/xdHtsTDuylWB1AF
         HWJJYn7elivEGatvPI+7IKtTqVRN3fNon4DxxS1o=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from localhost.localdomain ([79.223.54.124]) by mail.gmx.com
 (mrgmx104 [212.227.17.168]) with ESMTPSA (Nemesis) id
 1MtfNf-1kxBKa32Br-00vB7g; Mon, 17 Aug 2020 09:21:03 +0200
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 75DC5800D9; Mon, 17 Aug 2020 09:20:59 +0200 (CEST)
From:   Sven Joachim <svenjoac@gmx.de>
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Brian Vazquez <brianvv@google.com>
Subject: Re: linux-next: build failure after merge of the net-next tree
References: <20200729212721.1ee4eef8@canb.auug.org.au>
Date:   Mon, 17 Aug 2020 09:20:59 +0200
In-Reply-To: <20200729212721.1ee4eef8@canb.auug.org.au> (Stephen Rothwell's
        message of "Wed, 29 Jul 2020 21:27:21 +1000")
Message-ID: <87ft8lwxes.fsf@turtle.gmx.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Provags-ID: V03:K1:+gMeo5T9ZZBMhvY3gxLb824G7oBZvNHYbIZviNetkD4ThGjJTtb
 d16OaFHdenKQ3Ufx87ia4cqNIM+INUVK+3Ni4KrHLyo+QjVc+YJxBVSmjv0tXSoBVd88LWT
 zyf/vb6aEygqglWm27aB4K12eRMUYQSpHHFAN0reOamIFJdldkPL9JP5LpcBrAvskeWulxm
 ioGyfEwKpOLEql6D/ukLA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:LJiQNcqpV6I=:ZE2E42FsBcKDzna8tFNlkj
 O5fjb3yF8RDFlWt+ed6CufAHrYWdazHkSIL+ir2Fwtzwc6HT3IS18WP65K3Uqn7Mtg4DPbJ2u
 HN+QvIhyQgviJUNgLk2QF/ToC0mRKaoPGJSZ4ny9leArpo+XVeXjl2OnISwf1T7GzDFDNLdDn
 3uKLAaYPj75YH834DjjJUgCpSK2uIA7SV4UPUyrrdzsilzK3JzTR/wOlrK5XRtG5fA7IscdO/
 zM8ae4SJly1cIpzNTOcf5MoruhhiX0/XOXU9AVHpgbbHzsD2xOIFZIm2fqTntwC72sTqtf+y3
 46XxsvvJjA57Rc91XDgUYbWnhZWbdLPGiL7+IQlRgEkqw0+N+YNdcdZncA9gWLZKVtcenTsib
 uASWBj4SVUA4yjd8OUqZni5VJgLIBhbt4vdhKv0//fwyj2FB6YSs4qd+55xeU5SX9ehY7114t
 l1i38JgnXdokpdIVuqqdoGWH0VUbCj04bvEllwAE9TI9C7YmcdCaik8TZKaR14AwQT56Nr2Ox
 CH+T1BvGtG4ykG3+w2ic7pNAqltMVc91PbxJ0yyLCo61pIUF2PveBtDba+Wp97wzlPfmlvJBK
 P3lytJN6sbvtoSqsivQy1XjxVqz7XwzEYJV+VChA9mDtSuTCSYNTSZkjRLU8qxeX2LcA5tIj6
 g+abJyvZ4tQhlzok2ylthf7ahVU978/GVQg6K0LLTGMQEQXhlT8yJLKx8Dcm0k5C6blIN+gVp
 m4E/z59b1yDlfxUOsxjFFsI/WTSI4TrZp1AvGfj8jMcMPDHsNX60H4gUiinfS1/Xn1gS/UzP3
 GJ5x8FxtBZg9yknzdgkuqFpERs6jdkXguxgKM2Q0bWDhMSqzK6GQQ1TagtsY0al2VdyhkVk0N
 j7mSdKqkTbCtC1v5hV5io0rNwybEvjw/VyzjL3q1w5UXG0EoqGty/n8KxLy2HK4p2D1+9eWKB
 doUE5k3s1m7WbYyhjSCLYj+pcLLNjPB95+HmSxglSKRMAY9aa+E1pHlKg97AWevMdsAEANTRb
 xAZYZS/YcFOA4HdPtdYlywpBwamw+Ud+SbWaIGtixYcilKj1gz5jvqpg/5z3amT4rELuFY+Y0
 azC3T0VzIHDyaL+ZDPlSMX/+GaKRGSA8TSoNULubI1xsZZnqxafAqp6JcScjcqUAyrmoILnZd
 nedslp8khoB1ka+Asez9KbOlPnIWOTMWlUY6g7+VI/SxMgl9xBoG+x6yYjzHkLVsSvBmbY0ZM
 raAxobcbT2NzByNoV
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2020-07-29 21:27 +1000, Stephen Rothwell wrote:

> Hi all,
>
> After merging the net-next tree, today's linux-next build (i386 defconfi=
g)
> failed like this:
>
> x86_64-linux-gnu-ld: net/core/fib_rules.o: in function `fib_rules_lookup=
':
> fib_rules.c:(.text+0x5c6): undefined reference to `fib6_rule_match'
> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x5d8): undefined reference to `=
fib6_rule_match'
> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x64d): undefined reference to `=
fib6_rule_action'
> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x662): undefined reference to `=
fib6_rule_action'
> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x67a): undefined reference to `=
fib6_rule_suppress'
> x86_64-linux-gnu-ld: fib_rules.c:(.text+0x68d): undefined reference to `=
fib6_rule_suppress'

FWIW, I saw these errors in 5.9-rc1 today, so the fix in commit
41d707b7332f ("fib: fix fib_rules_ops indirect calls wrappers") was
apparently not sufficient.

,----
| $ grep IPV6 .config
| CONFIG_IPV6=3Dm
| # CONFIG_IPV6_ROUTER_PREF is not set
| # CONFIG_IPV6_OPTIMISTIC_DAD is not set
| # CONFIG_IPV6_MIP6 is not set
| # CONFIG_IPV6_ILA is not set
| # CONFIG_IPV6_VTI is not set
| CONFIG_IPV6_SIT=3Dm
| # CONFIG_IPV6_SIT_6RD is not set
| CONFIG_IPV6_NDISC_NODETYPE=3Dy
| CONFIG_IPV6_TUNNEL=3Dm
| CONFIG_IPV6_MULTIPLE_TABLES=3Dy
| # CONFIG_IPV6_SUBTREES is not set
| # CONFIG_IPV6_MROUTE is not set
| # CONFIG_IPV6_SEG6_LWTUNNEL is not set
| # CONFIG_IPV6_SEG6_HMAC is not set
| # CONFIG_IPV6_RPL_LWTUNNEL is not set
| # CONFIG_NF_SOCKET_IPV6 is not set
| # CONFIG_NF_TPROXY_IPV6 is not set
| # CONFIG_NF_DUP_IPV6 is not set
| # CONFIG_NF_REJECT_IPV6 is not set
| # CONFIG_NF_LOG_IPV6 is not set
| CONFIG_NF_DEFRAG_IPV6=3Dm
`----

> Caused by commit
>
>   b9aaec8f0be5 ("fib: use indirect call wrappers in the most common fib_=
rules_ops")
>
> # CONFIG_IPV6_MULTIPLE_TABLES is not set
>
> I have reverted that commit for today.

Cheers,
       Sven
