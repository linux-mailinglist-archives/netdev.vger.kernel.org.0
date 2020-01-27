Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E558A14AB7C
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 22:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbgA0VQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 16:16:20 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43175 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA0VQU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 16:16:20 -0500
Received: by mail-wr1-f68.google.com with SMTP id d16so13376491wre.10;
        Mon, 27 Jan 2020 13:16:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=81DUY2c9ZW9f7zPo1osSxiKRvvdo9rLFQnLTxxEr3HA=;
        b=PHgQraG7ew4Ok+osxRiL5gGVuArcTfpQmtcDcfLtwrxGuCQSmCl/ePQOiEfc/UB344
         cJ55zwrIBvxU+s1jxtukUMYkJXJW5PeDWi+vAgRm37dF+PhmhNH7Io/eUX/VCoAbQhvJ
         DQxGLH850YxfALv077fYueO7atlFXfiKlU0PWuiNVTCBX4udfFkjB9Q62y8bWUphlCG2
         mli4yv9yt5/nuczWjzvikK+X0dSJVjCsGaynMkCZUu44lHnPJD1IvOVFuW78VVSymi2D
         kb7mlENI9eJectKM9mQ4Igd7/T57dD8vNCXKMxUSOkYrAcIdvz5mcDuibBHHIaurvWR/
         4kKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version;
        bh=81DUY2c9ZW9f7zPo1osSxiKRvvdo9rLFQnLTxxEr3HA=;
        b=EOcxFw8H2anPZVOnqBm8/+mI0LUOOw0LosCftt3/nixT+75zPNf0MMfGMfv7TVnrw7
         +6/7pHyKZzOfHaOINBxJrYM99KXTd93A0aVtPPe1dOpgYOEinMymf9k2rSoxQsY1lTSU
         8gJMV2gC/j5xeuQb2hCVAmiPh8NxnMd/3O+fp2clvg0jQt29HcR4uQYQtj8DXvfemkfj
         bVsqngE32jAnfYM5CWU7Ey+R7aCzfDKD4gM67mBrU3Eu2N6MBDg/S1IzjRtx9yE9lerM
         /W60Vz3bOXtqx3bzK5nzBHwMlwEUlJIpq0xweFd03+P6GMhGtR1redes0nlentNT3err
         HiKA==
X-Gm-Message-State: APjAAAUYf5wE0dIxv79pJVEdMSPWjajS6H5tDtsoph7C9TMAwM9SYjxo
        kuwXFVV8PfGbbmFvvYltxjotY5HazT0=
X-Google-Smtp-Source: APXvYqza+0GIumRtV/WgC/siHrRCCJMNjwMyDziQ44OPZCYLe1nTsMeKS4x4oWbytILc5TJdphmycQ==
X-Received: by 2002:adf:f80b:: with SMTP id s11mr25389289wrp.12.1580159777788;
        Mon, 27 Jan 2020 13:16:17 -0800 (PST)
Received: from felia ([2001:16b8:2d9d:8c00:380d:4350:8c25:6615])
        by smtp.gmail.com with ESMTPSA id u16sm50960wmj.41.2020.01.27.13.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 13:16:17 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date:   Mon, 27 Jan 2020 22:16:04 +0100 (CET)
X-X-Sender: lukas@felia
To:     =?ISO-8859-15?Q?Jouni_H=F6gander?= <jouni.hogander@unikie.com>
cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, syzkaller@googlegroups.com
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
In-Reply-To: <87h80h2suv.fsf@unikie.com>
Message-ID: <alpine.DEB.2.21.2001272145260.2951@felia>
References: <20191127203114.766709977@linuxfoundation.org> <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com> <20191128073623.GE3317872@kroah.com> <CAKXUXMy_=gVVw656AL5Rih_DJrdrFLoURS-et0+dpJ2cKaw6SQ@mail.gmail.com> <20191129085800.GF3584430@kroah.com>
 <87sgk8szhc.fsf@unikie.com> <alpine.DEB.2.21.2001261236430.4933@felia> <87h80h2suv.fsf@unikie.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="8323329-600720457-1580159776=:2951"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-600720457-1580159776=:2951
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT



On Mon, 27 Jan 2020, Jouni Högander wrote:

> Lukas Bulwahn <lukas.bulwahn@gmail.com> writes:
> 
> > On Wed, 22 Jan 2020, Jouni Högander wrote:
> >
> >> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> >> >> > Now queued up, I'll push out -rc2 versions with this fix.
> >> >> >
> >> >> > greg k-h
> >> >> 
> >> >> We have also been informed about another regression these two commits
> >> >> are causing:
> >> >> 
> >> >> https://lore.kernel.org/lkml/ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp/
> >> >> 
> >> >> I suggest to drop these two patches from this queue, and give us a
> >> >> week to shake out the regressions of the change, and once ready, we
> >> >> can include the complete set of fixes to stable (probably in a week or
> >> >> two).
> >> >
> >> > Ok, thanks for the information, I've now dropped them from all of the
> >> > queues that had them in them.
> >> >
> >> > greg k-h
> >> 
> >> I have now run more extensive Syzkaller testing on following patches:
> >> 
> >> cb626bf566eb net-sysfs: Fix reference count leak
> >> ddd9b5e3e765 net-sysfs: Call dev_hold always in rx_queue_add_kobject
> >> e0b60903b434 net-sysfs: Call dev_hold always in netdev_queue_add_kobje
> >> 48a322b6f996 net-sysfs: fix netdev_queue_add_kobject() breakage
> >> b8eb718348b8 net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
> >> 
> >> These patches are fixing couple of memory leaks including this one found
> >> by Syzbot: https://syzkaller.appspot.com/bug?extid=ad8ca40ecd77896d51e2
> >> 
> >> I can reproduce these memory leaks in following stable branches: 4.14,
> >> 4.19, and 5.4.
> >> 
> >> These are all now merged into net/master tree and based on my testing
> >> they are ready to be taken into stable branches as well.
> >>
> >
> > + syzkaller list
> > Jouni et. al, please drop Linus in further responses; Linus, it was wrong 
> > to add you to this thread in the first place (reason is explained below)
> >
> > Jouni, thanks for investigating.
> >
> > It raises the following questions and comments:
> >
> > - Does the memory leak NOT appear on 4.9 and earlier LTS branches (or did 
> > you not check that)? If it does not appear, can you bisect it with the 
> > reproducer to the commit between 4.14 and 4.9?
> 
> I tested and these memory leaks are not reproucible in 4.9 and earlier.
> 
> >
> > - Do the reproducers you found with your syzkaller testing show the same 
> > behaviour (same bisection) as the reproducers from syzbot?
> 
> Yes, they are same.
> 
> >
> > - I fear syzbot's automatic bisection on is wrong, and Linus' commit 
> > 0e034f5c4bc4 ("iwlwifi: fix mis-merge that breaks the driver") is not to 
> > blame here; that commit did not cause the memory leak, but fixed some 
> > unrelated issue that simply confuses syzbot's automatic bisection.
> >
> > Just FYI: Dmitry Vyukov's evaluation of the syzbot bisection shows that 
> > about 50% are wrong, e.g., due to multiple bugs being triggered with one 
> > reproducer and the difficulty of automatically identifying them of being 
> > different due to different root causes (despite the smart heuristics of 
> > syzkaller & syzbot). So, to identify the actual commit on which the memory 
> > leak first appeared, you need to bisect manually with your own judgement 
> > if the reported bug stack trace fits to the issue you investigating. Or 
> > you use syzbot's automatic bisection but then with a reduced kernel config 
> > that cannot be confused by other issues. You might possibly also hit a 
> > "beginning of time" in your bisection, where KASAN was simply not 
> > supported, then the initially causing commit can simply not determined by 
> > bisection with the reproducer and needs some code inspection and 
> > archaeology with git. Can you go ahead try to identify the correct commit 
> > for this issue?
> 
> These two commits (that are not in 4.9 and earlier) are intorducing these leaks:
> 
> commit e331c9066901dfe40bea4647521b86e9fb9901bb
> Author: YueHaibing <yuehaibing@huawei.com>
> Date:   Tue Mar 19 10:16:53 2019 +0800
> 
>     net-sysfs: call dev_hold if kobject_init_and_add success
>     
>     [ Upstream commit a3e23f719f5c4a38ffb3d30c8d7632a4ed8ccd9e ]
>     
>     In netdev_queue_add_kobject and rx_queue_add_kobject,
>     if sysfs_create_group failed, kobject_put will call
>     netdev_queue_release to decrease dev refcont, however
>     dev_hold has not be called. So we will see this while
>     unregistering dev:
>     
>     unregister_netdevice: waiting for bcsh0 to become free. Usage count = -1
>     
>     Reported-by: Hulk Robot <hulkci@huawei.com>
>     Fixes: d0d668371679 ("net: don't decrement kobj reference count on init fail
> ure")
>     Signed-off-by: YueHaibing <yuehaibing@huawei.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> commit d0d6683716791b2a2761a1bb025c613eb73da6c3
> Author: stephen hemminger <stephen@networkplumber.org>
> Date:   Fri Aug 18 13:46:19 2017 -0700
> 
>     net: don't decrement kobj reference count on init failure
>     
>     If kobject_init_and_add failed, then the failure path would
>     decrement the reference count of the queue kobject whose reference
>     count was already zero.
>     
>     Fixes: 114cf5802165 ("bql: Byte queue limits")
>     Signed-off-by: Stephen Hemminger <sthemmin@microsoft.com>
>     Signed-off-by: David S. Miller <davem@davemloft.net>
> 

But, it seems that we now have just a long sequences of fix patches.

This commit from 2011 seems to be the initial buggy one:

commit 114cf5802165ee93e3ab461c9c505cd94a08b800
Author: Tom Herbert <therbert@google.com>
Date:   Mon Nov 28 16:33:09 2011 +0000

    bql: Byte queue limits

And then we just have fixes over fixes:

114cf5802165ee93e3ab461c9c505cd94a08b800
fixed by d0d6683716791b2a2761a1bb025c613eb73da6c3
fixed by a3e23f719f5c4a38ffb3d30c8d7632a4ed8ccd9e
fixed by the sequence of your five patches, mentioned above


If that is right, we should be able to find a reproducer with syzkaller on 
the versions before d0d668371679 ("net: don't decrement kobj reference 
count on init failure") with fault injection enabled or some manually 
injected fault by modifying the source code to always fail on init to 
really trigger the init failure, and see the reference count go below 
zero.

All further issues should also have reproducers found with syzkaller.
If we have a good feeling on the reproducers and this series of fixes 
really fixed the issue now here for all cases, we should suggest to 
backport all of the fixes to 4.4 and 4.9.

We should NOT just have Greg pick up a subset of the patches and backport 
them to 4.4 and 4.9, that will likely break more than it fixes.

Jouni, did you see Greg's bot inform you that he would pick up your latest 
patch for 4.4 and 4.9? Please respond to those emails to make sure a 
complete set of patches is picked up, which we tested with all those 
intermediate reproducers and an extensive syzkaller run hitting the 
net-sysfs interface (e.g., by configuring the corpus and check coverage).

If you cannot do this testing for 4.4 and 4.9 now quickly (you 
potentially have less than 24 hours), we should hold those new patches 
back for 4.4 and 4.9, as none of the fixes seem to be applied at all right 
now and the users have not complained yet on 4.4 and 4.9.
Once testing of the whole fix sequence is done, we request to backport all 
patches at once for 4.4 and 4.9.

Lukas


--8323329-600720457-1580159776=:2951--
