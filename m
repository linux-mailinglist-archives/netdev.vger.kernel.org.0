Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5DBA05B4AE4
	for <lists+netdev@lfdr.de>; Sun, 11 Sep 2022 01:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiIJXiv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Sep 2022 19:38:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbiIJXis (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Sep 2022 19:38:48 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E63A43FA11
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 16:38:47 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y15so894283iof.13
        for <netdev@vger.kernel.org>; Sat, 10 Sep 2022 16:38:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date;
        bh=Ll998bqg44uVvRHoYhaave3egGpn6S31XNcdXEohAlc=;
        b=TuvmfokSFANu9CUpl9sz1o80z3Qte5X22POghUW+oVYsEL4rNIfE2Luopk8hV2b5p+
         VGypylIbctMoCeCekgc1AYXAqTzdIjZaqftAENpHiz8KIl6POyyC93EL30wDaTRY5jHZ
         6VVFI+oOyrhpM+rzd8SX+AaJvIERnaawdoFjRwp7ChIxyNRzLDEcCyhOEq5dm7vjayvG
         2KLW5J+9goERKtewX2VAFwr9aChNaFx5LRK1iCrtx8wwXdm44tPGEyXrM9Rq2fZNEP4R
         qGMJQfX3mL56whi3RR0raG2hNeGo4eQUHeGNahFirYfKWVcbkpKxVbn7PlexOgHXFjL1
         59CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Ll998bqg44uVvRHoYhaave3egGpn6S31XNcdXEohAlc=;
        b=GICAh3iQsDOYD/tfhZWxF1MtC4r76lRtbeTZVXC9MhAZ+0sYJ/YR4GWcnwcw7t+4KD
         RyeIZlaAyHMA779ChzAn0Nt+YcX2Z4r+JMJ8xjgYXe9veYD2HTdp1kDSp3uFSsUcvy3Z
         g9XxuxAUUsgUgxsQPLQUKH8qn6tVvi88DvAmDPsf4zbyD5F9DfeZSQczJwi6bHNEqzSb
         a8x2u5bqURIRTvsfRev5F1bpwUYfA9SVhFPLsJBqY7G2BoWc8wC7byyyLp7PrmV5hZpd
         PZpQJDc++u7fwJtOiyDzUyppEMut22qdVh6p1MKD7QrNNgA5wXGlwHCPdeO/u66Bjan7
         mpbA==
X-Gm-Message-State: ACgBeo1lnmWV5Za+WfxMD3SCDdE9rLyWnPM3L4NDgJx/cayNG5JFTW93
        5l/gljv0XLpk7ogL1i+LTfPKV4WFt1r2IojCX6vtbcOc58Q=
X-Google-Smtp-Source: AA6agR5uF7pR1R8CX6kE5ma6AnB2gcwMxHIZKBS/9KanL5B95g6uee/trYAnBeufhMAbQpRASiVF6d8TwkuYiWLvro8=
X-Received: by 2002:a05:6638:1395:b0:34c:16ac:24f9 with SMTP id
 w21-20020a056638139500b0034c16ac24f9mr10653074jad.163.1662853127279; Sat, 10
 Sep 2022 16:38:47 -0700 (PDT)
MIME-Version: 1.0
References: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de>
In-Reply-To: <42776059-242c-cf49-c3ed-31e311b91f1c@tarent.de>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sun, 11 Sep 2022 02:38:38 +0300
Message-ID: <CAHNKnsQGwV9Z9dSrKusLV7qE+Xw_4eqEDtHKTVJxuuy6H+pWRA@mail.gmail.com>
Subject: Re: RFH, where did I go wrong?
To:     Thorsten Glaser <t.glaser@tarent.de>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Thorsten,

On Fri, Sep 9, 2022 at 12:19 AM Thorsten Glaser <t.glaser@tarent.de> wrote:
> under high load, my homegrown qdisc causes a system crash,
> but I=E2=80=99m a bit baffled at the message and location. Perhaps
> anyone has directly an idea where I could have messed up?
>
> Transcription of the most relevant info from the screen photo:
>
> virt_to_cache: Object is not a Slab page!
> =E2=80=A6 at mm/slab.h:435 kmem_cache_free+=E2=80=A6
>
> Call Trace:
> __rtnl_unlock+0x34/0x40
> netdev_run_todo+=E2=80=A6
> rtnetlink_rcv_msg
> ? _copy_to_iter
> ? __free_one_page
> ? rtnl_calcit.isra.0
> netlink_rcv_skb
> netlink_unicast
> netlink_sendmsg
> sock_sendmsg
> ____sys_sendmsg
> [=E2=80=A6]
>
> The trace is followed by two=E2=80=A6
>
> BUG: Bad rss-counter state mm:0000000001b817b09
> first one is type:MM_FILEPAGES val:81
> second one is type:MM_ANONPAGES val:30
>
>
> I guess I either messed up with pointers or locking, but I don=E2=80=99t
> have the Linux kernel coding experience to know where to even start
> looking for causes.
>
> Source in question is=E2=80=A6
> https://github.com/tarent/sch_jens/blob/iproute2_5.10.0-4jens14/janz/sch_=
janz.c
> =E2=80=A6 though I don=E2=80=99t exactly ask for someone to solve this fo=
r me (though
> that would, obviously, also be welcome =E2=98=BA) but to get to know enou=
gh
> for me to figure out the bug.
>
> I probably would start by adding lots of debugging printks, but the
> problem occurs when throwing iperf with 40 Mbit/s on this set to limit
> to 20 Mbit/s, which=E2=80=99d cause a lot of information=E2=80=8A=E2=80=
=94=E2=80=8Aplus I don=E2=80=99t even
> know what kind of error =E2=80=9CObject is not a Slab page=E2=80=9D is (i=
.e. what wrong
> thing is passed where or written to where).

At first glance, this looks like some memory access issue. Try to
enable KASAN. Maybe it will be able to provide some more details about
a source of issue.

BTW, the stack backtrace contains only RTNL related functions. Does
this warning appear when trying to reconfigure the qdisc? If so, then
the error is probably somewhere in the qdisc configuration code. Such
code is much easier to debug with printk than the packet processing
path.

If you still need some tracing support, take a look at the kernel
tracing capabilities. See Documentation/trace/tracepoints.rst for
documentation and, for example, net/mac80211/trace.h for reference.

--=20
Sergey
