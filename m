Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8366514A001
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 09:42:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729281AbgA0ImX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 03:42:23 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:37730 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729263AbgA0ImV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 03:42:21 -0500
Received: by mail-lj1-f193.google.com with SMTP id v17so9728609ljg.4
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 00:42:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=unikie-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-transfer-encoding;
        bh=MzyRcxue6yjRTY/bsxuSjERm4XTh8vYxPrOpGhEyNzU=;
        b=GE4NNOB0RtsaSVq35OM2g+7Ru31Cosnv8xj7IIwpyF6JMX3nUX2v4EUkqokAfN+MPa
         ODFfrSEhw+QrxpHOfW30ebsoi4zvFdusMREDaqSZLy/cPOMcBlj398Dn+T2XuRBoPlcl
         rlE2Y1xWuZgwiRZDNQ+EHfCBHCkERjlOqhz7IGBjMZmwu8iYQvNO4abktTcKUabUaBLQ
         PcC4WvpOLt4eUXXDb7wB84GRxrdV2ezF5wBP3edLZV5cAp17907HMrJIB1BeMO+zJAja
         AtOqUOINiLwja+HbiQXMo8JcxDvX4ZMLHegbb+wmduAZM/pruCk6PQGSDnz+ZSpfhnZu
         v0NQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:references:date:in-reply-to
         :message-id:user-agent:mime-version:content-transfer-encoding;
        bh=MzyRcxue6yjRTY/bsxuSjERm4XTh8vYxPrOpGhEyNzU=;
        b=E0bdAtlfKsRaSbW9mSRZTA3KB8MQGipL8BaKFwy4jZKsAjD3mI98/4jkIZSqndmuMk
         WL0O0HCRhDQ3pOq/+B77FUiURVH50Vuqyl2mNDvIrmRPXPqbcn8cAdPVdgWS7RPR9xKk
         Y6sefWrvKnCUa5lL7SSwJ+3XYR1EsQgS7L/BY+kGXvQ60FB35ntEDpQHKsDeHbz1v5vG
         3qiEqFAmqe2wkpbfwK6CEjkTzf6EktgUpq3CmE22ORWYoYt2hP5UNB55pcGFLxHPLlbg
         tUmW8K60hwFp9l+bTRki53L/rv2lY6MCqGyyzKRkmLaHiCP/B++MP7UcakT5Uj/02Otp
         HVjw==
X-Gm-Message-State: APjAAAVCf1ijh3o8IShhx4ixlcB/ES+Bbw1oS50KrPbvb2I/VkeyCSB6
        H78LfOKoXd8Nun+Z7UTXrOYrGQ==
X-Google-Smtp-Source: APXvYqxnj9br9Mg1/EsRuO8SEA91vWzMOxUEGZY5/ukHuE4YcujoiqiQKblp2ea//ooFnKway8udOw==
X-Received: by 2002:a05:651c:111a:: with SMTP id d26mr9512082ljo.153.1580114538132;
        Mon, 27 Jan 2020 00:42:18 -0800 (PST)
Received: from GL-434 ([109.204.235.119])
        by smtp.gmail.com with ESMTPSA id y7sm754860ljy.92.2020.01.27.00.42.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 27 Jan 2020 00:42:17 -0800 (PST)
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
        <alpine.DEB.2.21.2001261236430.4933@felia>
Date:   Mon, 27 Jan 2020 10:42:16 +0200
In-Reply-To: <alpine.DEB.2.21.2001261236430.4933@felia> (Lukas Bulwahn's
        message of "Sun, 26 Jan 2020 12:54:42 +0100 (CET)")
Message-ID: <87h80h2suv.fsf@unikie.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/25.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Lukas Bulwahn <lukas.bulwahn@gmail.com> writes:

> On Wed, 22 Jan 2020, Jouni H=C3=B6gander wrote:
>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
>> >> > Now queued up, I'll push out -rc2 versions with this fix.
>> >> >
>> >> > greg k-h
>> >>=20
>> >> We have also been informed about another regression these two commits
>> >> are causing:
>> >>=20
>> >> https://lore.kernel.org/lkml/ace19af4-7cae-babd-bac5-cd3505dcd874@I-l=
ove.SAKURA.ne.jp/
>> >>=20
>> >> I suggest to drop these two patches from this queue, and give us a
>> >> week to shake out the regressions of the change, and once ready, we
>> >> can include the complete set of fixes to stable (probably in a week or
>> >> two).
>> >
>> > Ok, thanks for the information, I've now dropped them from all of the
>> > queues that had them in them.
>> >
>> > greg k-h
>>=20
>> I have now run more extensive Syzkaller testing on following patches:
>>=20
>> cb626bf566eb net-sysfs: Fix reference count leak
>> ddd9b5e3e765 net-sysfs: Call dev_hold always in rx_queue_add_kobject
>> e0b60903b434 net-sysfs: Call dev_hold always in netdev_queue_add_kobje
>> 48a322b6f996 net-sysfs: fix netdev_queue_add_kobject() breakage
>> b8eb718348b8 net-sysfs: Fix reference count leak in rx|netdev_queue_add_=
kobject
>>=20
>> These patches are fixing couple of memory leaks including this one found
>> by Syzbot: https://syzkaller.appspot.com/bug?extid=3Dad8ca40ecd77896d51e2
>>=20
>> I can reproduce these memory leaks in following stable branches: 4.14,
>> 4.19, and 5.4.
>>=20
>> These are all now merged into net/master tree and based on my testing
>> they are ready to be taken into stable branches as well.
>>
>
> + syzkaller list
> Jouni et. al, please drop Linus in further responses; Linus, it was wrong=
=20
> to add you to this thread in the first place (reason is explained below)
>
> Jouni, thanks for investigating.
>
> It raises the following questions and comments:
>
> - Does the memory leak NOT appear on 4.9 and earlier LTS branches (or did=
=20
> you not check that)? If it does not appear, can you bisect it with the=20
> reproducer to the commit between 4.14 and 4.9?

I tested and these memory leaks are not reproucible in 4.9 and earlier.

>
> - Do the reproducers you found with your syzkaller testing show the same=
=20
> behaviour (same bisection) as the reproducers from syzbot?

Yes, they are same.

>
> - I fear syzbot's automatic bisection on is wrong, and Linus' commit=20
> 0e034f5c4bc4 ("iwlwifi: fix mis-merge that breaks the driver") is not to=
=20
> blame here; that commit did not cause the memory leak, but fixed some=20
> unrelated issue that simply confuses syzbot's automatic bisection.
>
> Just FYI: Dmitry Vyukov's evaluation of the syzbot bisection shows that=20
> about 50% are wrong, e.g., due to multiple bugs being triggered with one=
=20
> reproducer and the difficulty of automatically identifying them of being=
=20
> different due to different root causes (despite the smart heuristics of=20
> syzkaller & syzbot). So, to identify the actual commit on which the memor=
y=20
> leak first appeared, you need to bisect manually with your own judgement=
=20
> if the reported bug stack trace fits to the issue you investigating. Or=20
> you use syzbot's automatic bisection but then with a reduced kernel confi=
g=20
> that cannot be confused by other issues. You might possibly also hit a=20
> "beginning of time" in your bisection, where KASAN was simply not=20
> supported, then the initially causing commit can simply not determined by=
=20
> bisection with the reproducer and needs some code inspection and=20
> archaeology with git. Can you go ahead try to identify the correct commit=
=20
> for this issue?

These two commits (that are not in 4.9 and earlier) are intorducing these l=
eaks:

commit e331c9066901dfe40bea4647521b86e9fb9901bb
Author: YueHaibing <yuehaibing@huawei.com>
Date:   Tue Mar 19 10:16:53 2019 +0800

    net-sysfs: call dev_hold if kobject_init_and_add success
=20=20=20=20
    [ Upstream commit a3e23f719f5c4a38ffb3d30c8d7632a4ed8ccd9e ]
=20=20=20=20
    In netdev_queue_add_kobject and rx_queue_add_kobject,
    if sysfs_create_group failed, kobject_put will call
    netdev_queue_release to decrease dev refcont, however
    dev_hold has not be called. So we will see this while
    unregistering dev:
=20=20=20=20
    unregister_netdevice: waiting for bcsh0 to become free. Usage count =3D=
 -1
=20=20=20=20
    Reported-by: Hulk Robot <hulkci@huawei.com>
    Fixes: d0d668371679 ("net: don't decrement kobj reference count on init=
 fail
ure")
    Signed-off-by: YueHaibing <yuehaibing@huawei.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit d0d6683716791b2a2761a1bb025c613eb73da6c3
Author: stephen hemminger <stephen@networkplumber.org>
Date:   Fri Aug 18 13:46:19 2017 -0700

    net: don't decrement kobj reference count on init failure
=20=20=20=20
    If kobject_init_and_add failed, then the failure path would
    decrement the reference count of the queue kobject whose reference
    count was already zero.
=20=20=20=20
    Fixes: 114cf5802165 ("bql: Byte queue limits")
    Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
    Signed-off-by: David S. Miller <davem@davemloft.net>

>
>
> Lukas

BR,

Jouni H=C3=B6gander
