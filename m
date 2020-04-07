Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0BE91A0E06
	for <lists+netdev@lfdr.de>; Tue,  7 Apr 2020 14:57:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728736AbgDGM5t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Apr 2020 08:57:49 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:37334 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728146AbgDGM5s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Apr 2020 08:57:48 -0400
Received: by mail-wm1-f68.google.com with SMTP id j19so1728677wmi.2;
        Tue, 07 Apr 2020 05:57:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=NJgFiHGVdEHVoPHsjcjQFPUVIguP3zuu0mFKw20AE/I=;
        b=vBaMQQlfPEOTUUXSzYIRq4G4kDrCj4VmuSnRz3BAzJkT0orChsQF6W5INidkHLNPW7
         nqTyfzXBdohezy0lOGI3lsaO3OXyZ6MdPUHTa1tcM2ngqPFMKVvkUY1s0dXNxJgocRgO
         Gx5sYtkoAVX+xl/QN/Hz+fspEgaZqIcIQbVGDG5oGJ8HV45f9zFNSbU9c7NNqwKVF5Yi
         0K3exelQTcqOpeP5+huVBYoOda9yUg+AiGiV3ezLl1QSpsaHcj97JsmWdaHoj5AP8c5u
         Te9qraRr03mED15QGisiH2MQZobn32netPPlIBXXmbbaQBwVOatO/8ev0uu42D3dYGBN
         RWEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=NJgFiHGVdEHVoPHsjcjQFPUVIguP3zuu0mFKw20AE/I=;
        b=Vyr/TmkQhAvU1NHPqqyB9d9aSsha+imcteGun1aqNAoI8GgG1uXWjbO9q+otC2FpK6
         EUKI7Qlwq6bCzGQfBsWqlaqGrVx2qvevW5YRg4wCh/OjzJpt95Bn6dqbMLxcdRgV7CLi
         3omADt1XgTukdJu4Nw5dEXymP0UQbmp9KUykU6wmD1odHEC7+Rdoue/ZCLmY75feKxi8
         ix6L09RQSHZmLDDiNI5L3c3threSfuPdMsOpzWOZn1DMcqxlIGQVRtXaPbjkfaPTtF+f
         dXaEaut872tdfu9U/ksHPanJX5i5ZFfl+UkeBIdIMS9L1KbQYn4+a5AgGNGKfqPRsjJw
         b8hw==
X-Gm-Message-State: AGi0PuYbEfFls2vJhiqucth+Jz4RLeKOqWGzPoJgjyy+ZkBWVkONkPpk
        3fwGaGBNXZgQ2orqE/dMbz28vEnMbAKICiNNqZU=
X-Google-Smtp-Source: APiQypLf2n32gkj/40LPaOXiDFIUwBtDEXVa9iT+o0zSQGe98lpZiv9eO+Dg4KTGdklo81hElYAdZ5EZ/fvR5qsk8rE=
X-Received: by 2002:a1c:7c0d:: with SMTP id x13mr2251285wmc.44.1586264266277;
 Tue, 07 Apr 2020 05:57:46 -0700 (PDT)
MIME-Version: 1.0
References: <20200407023512.GA25005@ubuntu> <20200407030504.GX23230@ZenIV.linux.org.uk>
 <20200407031318.GY23230@ZenIV.linux.org.uk> <CAM7-yPQas7hvTVLa4U80t0Em0HgLCk2whLQa4O3uff5J3OYiAA@mail.gmail.com>
 <20200407040354.GZ23230@ZenIV.linux.org.uk> <CAM7-yPRaQsNgZKjru40nM1N_u8HVLVKmJCAzu20DcPL=jzKjWQ@mail.gmail.com>
In-Reply-To: <CAM7-yPRaQsNgZKjru40nM1N_u8HVLVKmJCAzu20DcPL=jzKjWQ@mail.gmail.com>
From:   Yun Levi <ppbuk5246@gmail.com>
Date:   Tue, 7 Apr 2020 21:57:35 +0900
Message-ID: <CAM7-yPQ4DNNBHd2=QJpCLAmRRLSVuxKjnH6kJmuBdQ8iP0TRSA@mail.gmail.com>
Subject: Fwd: [PATCH] netns: dangling pointer on netns bind mount point.
To:     daniel@iogearbox.net, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

---------- Forwarded message ---------
From: Yun Levi <ppbuk5246@gmail.com>
Date: Tue, Apr 7, 2020 at 9:53 PM
Subject: Re: [PATCH] netns: dangling pointer on netns bind mount point.
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: David S. Miller <davem@davemloft.net>, Jakub Kicinski
<kuba@kernel.org>, Guillaume Nault <gnault@redhat.com>, Nicolas
Dichtel <nicolas.dichtel@6wind.com>, Eric Dumazet
<edumazet@google.com>, Li RongQing <lirongqing@baidu.com>, Thomas
Gleixner <tglx@linutronix.de>, Johannes Berg
<johannes.berg@intel.com>, David Howells <dhowells@redhat.com>,
<daniel@iogearbox.net>, <linux-fsdevel@vger.kernel.org>,
<linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>


BTW, It's my question.

>Look: we call ns_get_path(), which calls ns_get_path_cb(), which
>calls the callback passed to it (ns_get_path_task(), in this case),
>which grabs a reference to ns.  Then we pass that reference to
>__ns_get_path().
>
>__ns_get_path() looks for dentry stashed in ns.  If there is one
>and it's still alive, we grab a reference to that dentry and drop
>the reference to ns - no new inodes had been created, so no new
>namespace references have appeared.  Existing inode is pinned
>by dentry and dentry is pinned by _dentry_ reference we've got.

actually ns_get_path is called in unshare(2). and it makes new dentry
and inode in __ns_get_path finally (Cuz it create new network
namespace)
In that case, when I mount with --bind option to this
proc/self/ns/net, it only increase dentry refcount on
do_loopback->clone_mnt finally (not call netns_operation->get)
That means it's not increase previous created network namespace
reference count but only increase reference count of _dentry_
In that situation, If I exit the child process it definitely frees the
net_namespace previous created at the same time it decrease
net_namespace's refcnt in exit_task_namespace().
It means it's possible that bind mount point can hold the dentry with
inode having net_namespace's dangling pointer in another process.
In above situation, parent who know that binded mount point calls
setns(2) then it sets the net_namespace which is refered by the inode
of the dentry increased by do_loopback.
That makes set the net_namespace which was freed already.

The Kernel Panic log is happend NOT in child kill but in Parent killed
after I setns(2) with the net_namespace made by child process.

Thanks you for your reviewing, But Please forgive that I couldn't
share .config right now (I try to make for x86....)
I try to understand your comments But Please forgive my fault because
of my ignorant...
If my explain is wrong, please rebuke me... and Please share your knowledge...

Thank you.

On Tue, Apr 7, 2020 at 1:04 PM Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> On Tue, Apr 07, 2020 at 12:29:34PM +0900, Yun Levi wrote:
>
> > sock_prot_inuse_add+0x10/0x20
> > __sock_release+0x44/0xc0
> > sock_close+0x14/0x20
> > __fput+0x8c/0x1b8
> > ____fput+0xc/0x18
> > task_work_run+0xa8/0xd8
> > do_exit+0x2e4/0xa50
> > do_group_exit+0x34/0xc8
> > get_signal+0xd4/0x600
> > do_signal+0x174/0x268
> > do_notify_resume+0xcc/0x110
> > work_pending+0x8/0x10
> > Code: b940c821 f940c000 d538d083 8b010800 (b8606861) ---[ end trace
> > 0b98c9ccbfd9f6fd ]---
> > Date/Time : 02-14-0120 06:35:47 Kernel panic - not syncing: Fatal
> > exception in interrupt SMP: stopping secondary CPUs Kernel Offset:
> > disabled CPU features: 0x0,21806000 Memory Limit: none
> >
> > What I saw is when I try to bind on some mount point to
> > /proc/{pid}/ns/net which made by child process, That's doesn't
> > increase the netns' refcnt.
>
> Why would it?  Increase of netns refcount should happen when you
> follow /proc/*/ns/net and stay for as long as nsfs inode is alive,
> not by cloning that mount.  And while we are at it, you don't need
> to bind it anywhere in order to call setns() - just open the
> sucker and then feed the resulting descriptor to setns(2).  No
> mount --bind involved and if child exiting between open() and
> setns() would free netns, we would have exact same problem.
>
> > And when the child process's going to exit, it frees the netns But
> > Still bind mount point's inode's private data point to netns which was
> > freed by child when it exits.
>
> Look: we call ns_get_path(), which calls ns_get_path_cb(), which
> calls the callback passed to it (ns_get_path_task(), in this case),
> which grabs a reference to ns.  Then we pass that reference to
> __ns_get_path().
>
> __ns_get_path() looks for dentry stashed in ns.  If there is one
> and it's still alive, we grab a reference to that dentry and drop
> the reference to ns - no new inodes had been created, so no new
> namespace references have appeared.  Existing inode is pinned
> by dentry and dentry is pinned by _dentry_ reference we've got.
>
> If dentry is not there or is already in the middle of being destroyed,
> we allocate a new inode, stash our namespace reference into it,
> create a dentry referencing that new inode, stash it into namespace
> and return that dentry.  Without dropping namespace reference we'd
> obtained in ns_get_path_task() - it went into new inode.
>
> If inode or dentry creation fails (out of memory), we drop what
> we'd obtained (namespace if inode creation fails, just the inode
> if dentry creation fails - namespace reference that went into
> inode will be dropped by inode destructor in the latter case) and
> return an error.
>
> If somebody else manages to get through the entire thing while
> we'd been allocating stuff and we see _their_ dentry already
> stashed into namespace, we just drop our dentry (its destructor
> will drop inode reference, which will lead to inode destructor,
> which will drop namespace reference) and bugger off with -EAGAIN.
> The caller (ns_get_path_cb()) will retry the entire thing.
>
> The invariant to be preserved here is "each of those inodes
> holds a reference to namespace for as long as the inode exists".
> ns_get_path() increments namespace refcount if and only if it
> has allocated an nsfs inode.  If it grabs an existing dentry
> instead, the namespace refcount remains unchanged.
>
> Anyway, I would really like to see .config and C (or shell)
> reproducer.  Ideally - .config that could be run in a KVM.
