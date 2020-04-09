Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4B7EB1A2FB0
	for <lists+netdev@lfdr.de>; Thu,  9 Apr 2020 09:03:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726638AbgDIHDJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Apr 2020 03:03:09 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:46927 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726589AbgDIHDI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Apr 2020 03:03:08 -0400
Received: by mail-qt1-f196.google.com with SMTP id g7so1976154qtj.13
        for <netdev@vger.kernel.org>; Thu, 09 Apr 2020 00:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4T5kGWYuiWsD8ODG0rIT5wEJy5Zk5WzpdZY70XPYCsk=;
        b=nh7PHjWteqz8nFiHSjdWnVP7s/XkAfF1ymz+SC5KOF7ff+qFavN9xWvQtCveEZumqP
         Js0U5iOyiNiX0f5FDlsNU/xj0ioJRTCvg6fcTokSxpk7DAjMIOKJeDKLXT+qT5HauLa2
         TxJ4oI7IdnA8l0vUXq6P86eg+pENHwdeX8GPbsjiYVxhUHFrZE2NH87nmZsThIsfDySq
         6Ueeav8Fa2S+yIy+d31YRfW/Okz3ce8NTe6OSjELck4bUW2cYOTG3fiQl9ALKawhyAE/
         xV36Y62LGGOK8uHb6JB+w+LBDuZKdqq6PsZG6sS1vtfczJ+vl5DyjI1bIY5y0SNmNFay
         Uplg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4T5kGWYuiWsD8ODG0rIT5wEJy5Zk5WzpdZY70XPYCsk=;
        b=f8Ae9ZsMJP852970b3F6wdTPoj2df0zuVA1eBaHJygYRdLgmBO7iPgrcSkLIWnv+4f
         VARViA18Gj8LpZdCVGl80PhyG/cu/29nyyCJ1I/doWIz42PNEQgoA/ndZ5x1X9VvDvpl
         IdNNKCwia+GElizWNoPprtzVm5ocT1BKVAOObcFs+HSmV/sxhSkOiwUFubzXs6tI/CHM
         3EAhvxVwQhErS0LK0gTPrq/PSdEQAMtdvwh3j8AXA2iQmRuKPo08ByjnwBCgwonvt6jR
         Zgv8k5TA4tctuKM9PwwoUrf2YveJlVDY+Ou4jiRRHUNDRyrs3fIn1Gqq/7fbKrbqAESt
         JEFA==
X-Gm-Message-State: AGi0PuZtQr7r/u1TLyRWuYZezUd2WZHp6n+GqNW+HSV4AABYxOrhBP2y
        KNLE5sU+D2KrMhVRqcOxAXV/wdHJbpQgvBqevL718g==
X-Google-Smtp-Source: APiQypKJQ3a0N5JoQD3BUJRgBCjL9Mcwnw+lWcXfUjHl6fm5/ft1w+YZKYm17y/CnLUqFgVeQD/ed0MGFxfOHkB7mRE=
X-Received: by 2002:ac8:6c24:: with SMTP id k4mr3078643qtu.257.1586415786173;
 Thu, 09 Apr 2020 00:03:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200408152151.5780-1-christian.brauner@ubuntu.com>
 <CAG48ez0KWgLMOp1d3X1AcRNc4-eF1YiCw=PgWiGjtM6PqQqawg@mail.gmail.com> <CA+enf=uhTi1yWtOe+iuv2FvdZzo69pwsP-NNU2775jN01aDcVQ@mail.gmail.com>
In-Reply-To: <CA+enf=uhTi1yWtOe+iuv2FvdZzo69pwsP-NNU2775jN01aDcVQ@mail.gmail.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Thu, 9 Apr 2020 09:02:54 +0200
Message-ID: <CACT4Y+aDeSAARG0b9FjDFyWuhjb=YVxpGtsvBmoKnHo+0TF4gA@mail.gmail.com>
Subject: Re: [PATCH 0/8] loopfs
To:     =?UTF-8?Q?St=C3=A9phane_Graber?= <stgraber@ubuntu.com>
Cc:     Jann Horn <jannh@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        linux-block <linux-block@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Serge Hallyn <serge@hallyn.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>, Tejun Heo <tj@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Saravana Kannan <saravanak@google.com>,
        Jan Kara <jack@suse.cz>, David Howells <dhowells@redhat.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        David Rheinsberg <david.rheinsberg@gmail.com>,
        Tom Gundersen <teg@jklm.no>,
        Christian Kellner <ckellner@redhat.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Matthew Garrett <mjg59@google.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        syzkaller <syzkaller@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Apr 8, 2020 at 6:41 PM St=C3=A9phane Graber <stgraber@ubuntu.com> w=
rote:
>
> On Wed, Apr 8, 2020 at 12:24 PM Jann Horn <jannh@google.com> wrote:
> >
> > On Wed, Apr 8, 2020 at 5:23 PM Christian Brauner
> > <christian.brauner@ubuntu.com> wrote:
> > > One of the use-cases for loopfs is to allow to dynamically allocate l=
oop
> > > devices in sandboxed workloads without exposing /dev or
> > > /dev/loop-control to the workload in question and without having to
> > > implement a complex and also racy protocol to send around file
> > > descriptors for loop devices. With loopfs each mount is a new instanc=
e,
> > > i.e. loop devices created in one loopfs instance are independent of a=
ny
> > > loop devices created in another loopfs instance. This allows
> > > sufficiently privileged tools to have their own private stash of loop
> > > device instances. Dmitry has expressed his desire to use this for
> > > syzkaller in a private discussion. And various parties that want to u=
se
> > > it are Cced here too.
> > >
> > > In addition, the loopfs filesystem can be mounted by user namespace r=
oot
> > > and is thus suitable for use in containers. Combined with syscall
> > > interception this makes it possible to securely delegate mounting of
> > > images on loop devices, i.e. when a user calls mount -o loop <image>
> > > <mountpoint> it will be possible to completely setup the loop device.
> > > The final mount syscall to actually perform the mount will be handled
> > > through syscall interception and be performed by a sufficiently
> > > privileged process. Syscall interception is already supported through=
 a
> > > new seccomp feature we implemented in [1] and extended in [2] and is
> > > actively used in production workloads. The additional loopfs work wil=
l
> > > be used there and in various other workloads too. You'll find a short
> > > illustration how this works with syscall interception below in [4].
> >
> > Would that privileged process then allow you to mount your filesystem
> > images with things like ext4? As far as I know, the filesystem
> > maintainers don't generally consider "untrusted filesystem image" to
> > be a strongly enforced security boundary; and worse, if an attacker
> > has access to a loop device from which something like ext4 is mounted,
> > things like "struct ext4_dir_entry_2" will effectively be in shared
> > memory, and an attacker can trivially bypass e.g.
> > ext4_check_dir_entry(). At the moment, that's not a huge problem (for
> > anything other than kernel lockdown) because only root normally has
> > access to loop devices.
> >
> > Ubuntu carries an out-of-tree patch that afaik blocks the shared
> > memory thing: <https://git.launchpad.net/~ubuntu-kernel/ubuntu/+source/=
linux/+git/eoan/commit?id=3D4bc428fdf5500b7366313f166b7c9c50ee43f2c4>
> >
> > But even with that patch, I'm not super excited about exposing
> > filesystem image parsing attack surface to containers unless you run
> > the filesystem in a sandboxed environment (at which point you don't
> > need a loop device anymore either).
>
> So in general we certainly agree that you should never expose someone
> that you wouldn't trust with root on the host to syscall interception
> mounting of real kernel filesystems.
>
> But that's not all that our syscall interception logic can do. We have
> support for rewriting a normal filesystem mount attempt to instead use
> an available FUSE implementation. As far as the user is concerned,
> they ran "mount /dev/sdaX /mnt" and got that ext4 filesystem mounted
> on /mnt as requested, except that the container manager intercepted
> the mount attempt and instead spawned fuse2fs for that mount. This
> requires absolutely no change to the software the user is running.
>
> loopfs, with that interception mode, will let us also handle all cases
> where a loop would be used, similarly without needing any change to
> the software being run. If a piece of software calls the command
> "mount -o loop blah.img /mnt", the "mount" command will setup a loop
> device as it normally would (doing so through loopfs) and then will
> call the "mount" syscall, which will get intercepted and redirected to
> a FUSE implementation if so configured, resulting in the expected
> filesystem being mounted for the user.
>
> LXD with syscall interception offers both straight up privileged
> mounting using the kernel fs or using a FUSE based implementation.
> This is configurable on a per-filesystem and per-container basis.
>
> I hope that clarifies what we're doing here :)
>
> St=C3=A9phane


Hi Christian,

Our use case for loopfs in syzkaller would be isolation of several
test processes from each other.
Currently all loop devices and loop-control are global and cause test
processes to collide, which in turn causes non-reproducible coverage
and non-reproducible crashes. Ideally we give each test process its
own loopfs instance.
