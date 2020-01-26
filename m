Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63D2D149A7C
	for <lists+netdev@lfdr.de>; Sun, 26 Jan 2020 12:54:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387435AbgAZLys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 26 Jan 2020 06:54:48 -0500
Received: from mail-ed1-f66.google.com ([209.85.208.66]:44433 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726436AbgAZLys (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 26 Jan 2020 06:54:48 -0500
Received: by mail-ed1-f66.google.com with SMTP id g19so3610810eds.11;
        Sun, 26 Jan 2020 03:54:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:date:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version:content-id;
        bh=yebpCXrtZX8bx3fQb5NWjS3jPJJayF5dsD82yx4g9kY=;
        b=K4FedAVyqeEd9VcH6t/5K1e9kdcf2VE+t2m/1s4BwLxfMMt9m0rxxr6+Epmbml5hyA
         LQNwSP4yirgcbKJncp48HdkyeDhj9MWB10hFMbL6dJLe6zIWZW/r45gYOvewzXw8Qj4o
         7jYfewofIYAKdsML3FSln6latL+kYWZWAKVCGUq1/UogAYv81LDoelceUltJFoxJlqB9
         cMbMoZab6n24EzCPtLYvVe8SEIjrV7+wKTOd3v7yTrN12u6W0x89+/kGRhs4OcKPfoA/
         UZHN+RD573fE+ieYwtq26Cc72LKe40rCH/ckaI/pT+OYpvgFMZgNOCjjLVSugUivkYsn
         0Rig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:date:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-id;
        bh=yebpCXrtZX8bx3fQb5NWjS3jPJJayF5dsD82yx4g9kY=;
        b=ukYTB5DLqxENQZMOelb9DgNuq9ljRLtUZrQETZpj1IAN41A8wEmCzN4Htd8VC1KOWZ
         cKbOso/1VLRdO89eWzqILBr0+o0w0ds8KyhwBa4hdZqghT8IBiZfueNHdE8oTrxAs0hC
         VBMFC38EcmB5Qy5RFezaJRBoXA98GdLaDyww53Demhz6v0UFoWLos0DSa+zk11/WM0P9
         HubItPR00ruvMcEOc6esU6JJA2/6PtcL/wKNWrRScKTMZHS7X3dGouqIHWthFOUwIIiD
         QF0SvUFMYUJ5BiFKvqsu8F0H8SCZNi76YVVxrbQixU/+2b1mokzp92WdNYAnmuUwqbAz
         f9bA==
X-Gm-Message-State: APjAAAVSdC2jFKcQJSICTRig5ApW/kGa8xmZFc1aIvJhmb0vpUHbErlk
        1PVKDGDvqVokCkKA4p9u/eM=
X-Google-Smtp-Source: APXvYqxfMz+LuhN79Em3ii/ilFnUf4Rw1aGe7WJUHbV187YP9KWdveWG1Oxgvj0kx/yc9rp+izn3pg==
X-Received: by 2002:a17:906:5586:: with SMTP id y6mr9416414ejp.343.1580039684935;
        Sun, 26 Jan 2020 03:54:44 -0800 (PST)
Received: from felia ([2001:16b8:2da0:3900:15f5:151e:3025:d216])
        by smtp.gmail.com with ESMTPSA id d19sm258868ejd.21.2020.01.26.03.54.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jan 2020 03:54:44 -0800 (PST)
From:   Lukas Bulwahn <lukas.bulwahn@gmail.com>
X-Google-Original-From: Lukas Bulwahn <lukas@gmail.com>
Date:   Sun, 26 Jan 2020 12:54:42 +0100 (CET)
X-X-Sender: lukas@felia
To:     =?ISO-8859-15?Q?Jouni_H=F6gander?= <jouni.hogander@unikie.com>
cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        open list <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        linux- stable <stable@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>, syzkaller@googlegroups.com
Subject: Re: [PATCH 4.19 000/306] 4.19.87-stable review
In-Reply-To: <87sgk8szhc.fsf@unikie.com>
Message-ID: <alpine.DEB.2.21.2001261236430.4933@felia>
References: <20191127203114.766709977@linuxfoundation.org> <CA+G9fYuAY+14aPiRVUcXLbsr5zJ-GLjULX=s9jcGWcw_vb5Kzw@mail.gmail.com> <20191128073623.GE3317872@kroah.com> <CAKXUXMy_=gVVw656AL5Rih_DJrdrFLoURS-et0+dpJ2cKaw6SQ@mail.gmail.com> <20191129085800.GF3584430@kroah.com>
 <87sgk8szhc.fsf@unikie.com>
User-Agent: Alpine 2.21 (DEB 202 2017-01-01)
MIME-Version: 1.0
Content-Type: multipart/mixed; BOUNDARY="8323329-62265607-1580039587=:4933"
Content-ID: <alpine.DEB.2.21.2001261254360.4933@felia>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323329-62265607-1580039587=:4933
Content-Type: text/plain; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.DEB.2.21.2001261254361.4933@felia>


On Wed, 22 Jan 2020, Jouni Högander wrote:

> Greg Kroah-Hartman <gregkh@linuxfoundation.org> writes:
> >> > Now queued up, I'll push out -rc2 versions with this fix.
> >> >
> >> > greg k-h
> >> 
> >> We have also been informed about another regression these two commits
> >> are causing:
> >> 
> >> https://lore.kernel.org/lkml/ace19af4-7cae-babd-bac5-cd3505dcd874@I-love.SAKURA.ne.jp/
> >> 
> >> I suggest to drop these two patches from this queue, and give us a
> >> week to shake out the regressions of the change, and once ready, we
> >> can include the complete set of fixes to stable (probably in a week or
> >> two).
> >
> > Ok, thanks for the information, I've now dropped them from all of the
> > queues that had them in them.
> >
> > greg k-h
> 
> I have now run more extensive Syzkaller testing on following patches:
> 
> cb626bf566eb net-sysfs: Fix reference count leak
> ddd9b5e3e765 net-sysfs: Call dev_hold always in rx_queue_add_kobject
> e0b60903b434 net-sysfs: Call dev_hold always in netdev_queue_add_kobje
> 48a322b6f996 net-sysfs: fix netdev_queue_add_kobject() breakage
> b8eb718348b8 net-sysfs: Fix reference count leak in rx|netdev_queue_add_kobject
> 
> These patches are fixing couple of memory leaks including this one found
> by Syzbot: https://syzkaller.appspot.com/bug?extid=ad8ca40ecd77896d51e2
> 
> I can reproduce these memory leaks in following stable branches: 4.14,
> 4.19, and 5.4.
> 
> These are all now merged into net/master tree and based on my testing
> they are ready to be taken into stable branches as well.
>

+ syzkaller list
Jouni et. al, please drop Linus in further responses; Linus, it was wrong 
to add you to this thread in the first place (reason is explained below)

Jouni, thanks for investigating.

It raises the following questions and comments:

- Does the memory leak NOT appear on 4.9 and earlier LTS branches (or did 
you not check that)? If it does not appear, can you bisect it with the 
reproducer to the commit between 4.14 and 4.9?

- Do the reproducers you found with your syzkaller testing show the same 
behaviour (same bisection) as the reproducers from syzbot?

- I fear syzbot's automatic bisection on is wrong, and Linus' commit 
0e034f5c4bc4 ("iwlwifi: fix mis-merge that breaks the driver") is not to 
blame here; that commit did not cause the memory leak, but fixed some 
unrelated issue that simply confuses syzbot's automatic bisection.

Just FYI: Dmitry Vyukov's evaluation of the syzbot bisection shows that 
about 50% are wrong, e.g., due to multiple bugs being triggered with one 
reproducer and the difficulty of automatically identifying them of being 
different due to different root causes (despite the smart heuristics of 
syzkaller & syzbot). So, to identify the actual commit on which the memory 
leak first appeared, you need to bisect manually with your own judgement 
if the reported bug stack trace fits to the issue you investigating. Or 
you use syzbot's automatic bisection but then with a reduced kernel config 
that cannot be confused by other issues. You might possibly also hit a 
"beginning of time" in your bisection, where KASAN was simply not 
supported, then the initially causing commit can simply not determined by 
bisection with the reproducer and needs some code inspection and 
archaeology with git. Can you go ahead try to identify the correct commit 
for this issue?


Lukas
--8323329-62265607-1580039587=:4933--
