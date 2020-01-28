Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4764D14B114
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 09:46:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725920AbgA1Iqe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jan 2020 03:46:34 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:39333 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725853AbgA1Iqd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jan 2020 03:46:33 -0500
Received: by mail-lj1-f196.google.com with SMTP id o11so13821545ljc.6
        for <netdev@vger.kernel.org>; Tue, 28 Jan 2020 00:46:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=SDBsxgSpYZSFr1ROXj8dVGyZsGMgCVC//9YDGkSiWcg=;
        b=HGnELdt8HlrpzP4ndtkJ7Wvh1GyMe5vSQZx7pSdGLhEAvOZ1fZ8fqHnMvplCAV7ik1
         dNp+bNgUu02Shms45KKKjf+lTu626ec+zLwZlvuNoomFnCGG5CC3cvV/fDs8cWcJsCuV
         XXnXvqPVfO+bpsK3darslnkbK0Gm4aPPcmn+4A8NpeLq0PVOr0kTgCAUlmhOl156CwVY
         PFUHG849UCeVpY6AubiyU70BoZp+xeRzOV7ltcTJvE3iggfVWZCoevVWztxsg/+Y7BrY
         dl520z2P4oZkghEPx6Sg+eX47RW2CG24QdALI+s6XLrBz3nQ7zDOXcWVCnAoEp10UA+p
         oz2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=SDBsxgSpYZSFr1ROXj8dVGyZsGMgCVC//9YDGkSiWcg=;
        b=JBuV3mmkGZmjWCQAqbZ3rsYgaP5Rq24FohcZrvfRCOrm7NboVOkEyHH+a+1GSUgMuh
         /ZtpuUkbsSSsE2kVwouXeXKMaUpAvjMoR0UdqXx/3/8ArR51t34Uua+UG9xctWjdT2qo
         7gITR2OftIuORAdiF7rm/ZROt46SmFo3pQej4FyFwdnC0tmFgx3jK//17T/qhkCJDB75
         F95op6QMNl5ETeQ1IDAvgB6VvfiAtGIeEOigiYEWZVSTzgQ2Fm/xEwa+WlguAdrRhY62
         UGnfD5KO8h9pV9Dx2MxM2/MrPC5Nq0U/zykhaPsnVPdRlScH3vAH6eSXPdB7KWN2HSRi
         jswA==
X-Gm-Message-State: APjAAAXcE5OTEOSbBAXDs3WQ9MZvor6Wbl2qNvW7CHVZzmkHszVHOmE6
        9JGLcx1ceeOtrT3DcGZ5VGnxtVUGFoVFQVTl
X-Google-Smtp-Source: APXvYqyt2aBzRqqHZepJ45mwWclGHx9VYi3zavQa87nf+WeEgvwZg1USKMiIA3JW/8FYm7eanS1N1g==
X-Received: by 2002:a2e:818e:: with SMTP id e14mr12558317ljg.2.1580201190711;
        Tue, 28 Jan 2020 00:46:30 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id f16sm9231922ljn.17.2020.01.28.00.46.29
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 28 Jan 2020 00:46:29 -0800 (PST)
From:   jouni.hogander@unikie.com (Jouni =?utf-8?Q?H=C3=B6gander?=)
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, syzkaller@googlegroups.com
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
References: <20191127203114.766709977@linuxfoundation.org>
        <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com>
        <20191128073623.GE3317872@kroah.com>
        <CAKXUXMy_=gVVw656AL5Rih_DJrdrFLoURS-et0+dpJ2cKaw6SQ@mail.gmail.com>
        <20191129085800.GF3584430@kroah.com> <87sgk8szhc.fsf@unikie.com>
        <alpine.DEB.2.21.2001261236430.4933@felia> <87h80h2suv.fsf@unikie.com>
        <alpine.DEB.2.21.2001272145260.2951@felia>
Date:   Tue, 28 Jan 2020 10:46:29 +0200
In-Reply-To: <alpine.DEB.2.21.2001272145260.2951@felia> (Lukas Bulwahn's
        message of "Mon, 27 Jan 2020 22:16:04 +0100 (CET)")
Message-ID: <874kwg2cka.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lukas Bulwahn <lukas.bulwahn@gmail.com> writes:

> On Mon, 27 Jan 2020, Jouni H=C3=B6gander wrote:
>
>> Lukas Bulwahn <lukas.bulwahn@gmail.com> writes:
>>=20
>> > On Wed, 22 Jan 2020, Jouni H=C3=B6gander wrote:
>> >
>> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> >> >> > Now queued up, I'll push out -rc2 versions with this fix.
>> >> >> >
>> >> >> > greg k-h
>> >> >>=20
>> >> >> We have also been informed about another regression these two comm=
its
>> >> >> are causing:
>> >> >>=20
>> >> >> https://lore.kernel.org/lkml/ace19af4-7cae-babd-bac5-cd3505dcd874@=
I-love.SAKURA.ne.jp/
>> >> >>=20
>> >> >> I suggest to drop these two patches from this queue, and give us a
>> >> >> week to shake out the regressions of the change, and once ready, we
>> >> >> can include the complete set of fixes to stable (probably in a wee=
k or
>> >> >> two).
>> >> >
>> >> > Ok, thanks for the information, I've now dropped them from all of t=
he
>> >> > queues that had them in them.
>> >> >
>> >> > greg k-h
>> >>=20
>> >> I have now run more extensive Syzkaller testing on following patches:
>> >>=20
>> >> cb626bf566eb net-sysfs: Fix reference count leak
>> >> ddd9b5e3e765 net-sysfs: Call dev_hold always in rx_queue_add_kobject
>> >> e0b60903b434 net-sysfs: Call dev_hold always in netdev_queue_add_kobje
>> >> 48a322b6f996 net-sysfs: fix netdev_queue_add_kobject() breakage
>> >> b8eb718348b8 net-sysfs: Fix reference count leak in rx|netdev_queue_a=
dd_kobject
>> >>=20
>> >> These patches are fixing couple of memory leaks including this one fo=
und
>> >> by Syzbot: https://syzkaller.appspot.com/bug?extid=3Dad8ca40ecd77896d=
51e2
>> >>=20
>> >> I can reproduce these memory leaks in following stable branches: 4.14,
>> >> 4.19, and 5.4.
>> >>=20
>> >> These are all now merged into net/master tree and based on my testing
>> >> they are ready to be taken into stable branches as well.
>> >>
>> >
>> > + syzkaller list
>> > Jouni et. al, please drop Linus in further responses; Linus, it was wr=
ong=20
>> > to add you to this thread in the first place (reason is explained belo=
w)
>> >
>> > Jouni, thanks for investigating.
>> >
>> > It raises the following questions and comments:
>> >
>> > - Does the memory leak NOT appear on 4.9 and earlier LTS branches (or =
did=20
>> > you not check that)? If it does not appear, can you bisect it with the=
=20
>> > reproducer to the commit between 4.14 and 4.9?
>>=20
>> I tested and these memory leaks are not reproucible in 4.9 and earlier.
>>=20
>> >
>> > - Do the reproducers you found with your syzkaller testing show the sa=
me=20
>> > behaviour (same bisection) as the reproducers from syzbot?
>>=20
>> Yes, they are same.
>>=20
>> >
>> > - I fear syzbot's automatic bisection on is wrong, and Linus' commit=20
>> > 0e034f5c4bc4 ("iwlwifi: fix mis-merge that breaks the driver") is not =
to=20
>> > blame here; that commit did not cause the memory leak, but fixed some=
=20
>> > unrelated issue that simply confuses syzbot's automatic bisection.
>> >
>> > Just FYI: Dmitry Vyukov's evaluation of the syzbot bisection shows tha=
t=20
>> > about 50% are wrong, e.g., due to multiple bugs being triggered with o=
ne=20
>> > reproducer and the difficulty of automatically identifying them of bei=
ng=20
>> > different due to different root causes (despite the smart heuristics o=
f=20
>> > syzkaller & syzbot). So, to identify the actual commit on which the me=
mory=20
>> > leak first appeared, you need to bisect manually with your own judgeme=
nt=20
>> > if the reported bug stack trace fits to the issue you investigating. O=
r=20
>> > you use syzbot's automatic bisection but then with a reduced kernel co=
nfig=20
>> > that cannot be confused by other issues. You might possibly also hit a=
=20
>> > "beginning of time" in your bisection, where KASAN was simply not=20
>> > supported, then the initially causing commit can simply not determined=
 by=20
>> > bisection with the reproducer and needs some code inspection and=20
>> > archaeology with git. Can you go ahead try to identify the correct com=
mit=20
>> > for this issue?
>>=20
>> These two commits (that are not in 4.9 and earlier) are intorducing thes=
e leaks:
>>=20
>> commit e331c9066901dfe40bea4647521b86e9fb9901bb
>> Author: YueHaibing <yuehaibing@huawei.com>
>> Date:   Tue Mar 19 10:16:53 2019 +0800
>>=20
>>     net-sysfs: call dev_hold if kobject_init_and_add success
>>=20=20=20=20=20
>>     [ Upstream commit a3e23f719f5c4a38ffb3d30c8d7632a4ed8ccd9e ]
>>=20=20=20=20=20
>>     In netdev_queue_add_kobject and rx_queue_add_kobject,
>>     if sysfs_create_group failed, kobject_put will call
>>     netdev_queue_release to decrease dev refcont, however
>>     dev_hold has not be called. So we will see this while
>>     unregistering dev:
>>=20=20=20=20=20
>>     unregister_netdevice: waiting for bcsh0 to become free. Usage count =
=3D -1
>>=20=20=20=20=20
>>     Reported-by: Hulk Robot <hulkci@huawei.com>
>>     Fixes: d0d668371679 ("net: don't decrement kobj reference count on i=
nit fail
>> ure")
>>     Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>=20
>> commit d0d6683716791b2a2761a1bb025c613eb73da6c3
>> Author: stephen hemminger <stephen@networkplumber.org>
>> Date:   Fri Aug 18 13:46:19 2017 -0700
>>=20
>>     net: don't decrement kobj reference count on init failure
>>=20=20=20=20=20
>>     If kobject_init_and_add failed, then the failure path would
>>     decrement the reference count of the queue kobject whose reference
>>     count was already zero.
>>=20=20=20=20=20
>>     Fixes: 114cf5802165 ("bql: Byte queue limits")
>>     Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
>>     Signed-off-by: David S. Miller <davem@davemloft.net>
>>=20
>
> But, it seems that we now have just a long sequences of fix patches.
>
> This commit from 2011 seems to be the initial buggy one:
>
> commit 114cf5802165ee93e3ab461c9c505cd94a08b800
> Author: Tom Herbert <therbert@google.com>
> Date:   Mon Nov 28 16:33:09 2011 +0000
>
>     bql: Byte queue limits
>
> And then we just have fixes over fixes:
>
> 114cf5802165ee93e3ab461c9c505cd94a08b800
> fixed by d0d6683716791b2a2761a1bb025c613eb73da6c3
> fixed by a3e23f719f5c4a38ffb3d30c8d7632a4ed8ccd9e
> fixed by the sequence of your five patches, mentioned above
>
>
> If that is right, we should be able to find a reproducer with syzkaller o=
n=20
> the versions before d0d668371679 ("net: don't decrement kobj reference=20
> count on init failure") with fault injection enabled or some manually=20
> injected fault by modifying the source code to always fail on init to=20
> really trigger the init failure, and see the reference count go below=20
> zero.
>
> All further issues should also have reproducers found with syzkaller.
> If we have a good feeling on the reproducers and this series of fixes=20
> really fixed the issue now here for all cases, we should suggest to=20
> backport all of the fixes to 4.4 and 4.9.
>
> We should NOT just have Greg pick up a subset of the patches and backport=
=20
> them to 4.4 and 4.9, that will likely break more than it fixes.

Yes, this is the case.

>
> Jouni, did you see Greg's bot inform you that he would pick up your lates=
t=20
> patch for 4.4 and 4.9? Please respond to those emails to make sure a=20
> complete set of patches is picked up, which we tested with all those=20
> intermediate reproducers and an extensive syzkaller run hitting the=20
> net-sysfs interface (e.g., by configuring the corpus and check
> coverage).

I already responded to not pick these patches into 4.4 and 4.9.=20

>
> If you cannot do this testing for 4.4 and 4.9 now quickly (you=20
> potentially have less than 24 hours), we should hold those new patches=20
> back for 4.4 and 4.9, as none of the fixes seem to be applied at all righ=
t=20
> now and the users have not complained yet on 4.4 and 4.9.
> Once testing of the whole fix sequence is done, we request to backport al=
l=20
> patches at once for 4.4 and 4.9.

If we want to pick whole set including older patches I think I need more
time for identifying which older patches (apart from these two I
identified causing the memory leak) should be taken in and for testing.

>
> Lukas

BR,

Jouni H=C3=B6gander
