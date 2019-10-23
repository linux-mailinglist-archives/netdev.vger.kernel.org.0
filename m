Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3257FE1EBC
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 17:00:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391697AbfJWPAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 11:00:19 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:44256 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390851AbfJWPAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 11:00:19 -0400
Received: by mail-pl1-f194.google.com with SMTP id q15so10208364pll.11
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 08:00:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N+w72TNzpRjbI10b0jitVHs/ZztNdVqny0Vx93sBfHk=;
        b=LkFiQMFlNCbmBcSny+BOcbJp4l+Y7hxmhJpwbh+oZKj4dclcUmkgKvgYT/+UYb+gC2
         gyHdiiQA0zgCVq5edOVaCswUbLLDVp5XxK7S64xHl5B14kzfNFd1rQGeDZSDltZr/3Wu
         JUlYM9V7bShYYsBBni9hVzN4el8+a0sJvdIGSmvxXXC+hQroujJZ3Ku4IzspLg14V4pP
         rO5w9PLppQQ6gwzqvOxY2udruUJiYhNLNVz1w2QSMCchaEg4Q1G6HlbIZru6HKxG+aS9
         CXqkZ33YbTEGVGVz3EaMmpMU7IxVFS79ScHmIC/CAFsX2auB9k4I7uGZczMJuJ1biDdh
         KMQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N+w72TNzpRjbI10b0jitVHs/ZztNdVqny0Vx93sBfHk=;
        b=BrlUyVFadNf7ZDe/MdK5IX/FH0+4Ehpfwe5VspDySo5sJeePYaavMGdr/mTWgqR9/h
         +w4JGhZ87+axOtPIayPZc0pN1Eu2jbLQcUvN1pPwO44vRV8MDs/SqDp5jsZUdhHcciCk
         jhHeEtO/QyYGwgfZHS2Lbuojonry7WF2mbWujkzRydgWT4A4XPmui+it5MwW9i2yA0S6
         Fo5+YazlWcQLHMW57AZQXMPkVausfHor53V97ZF0VsqTqAwgNITGYBF/z72/BtxTmXdp
         d4yO+X6uMFviF74Qla18+nrPFzG3DBEfboO7rBWl7S10OzkxxxPLY4yGtKImcUuHuk7w
         BfaQ==
X-Gm-Message-State: APjAAAVYQZxFbi45+azkDBKRqr4ddNyRaKDX0AQiFzd5+V+jIG++mE2Z
        OJuJsJ/Jaygtxq8/sR14ht5KIAha0Dp5YIaLnfl/GQ==
X-Google-Smtp-Source: APXvYqzT4S2F+jsQrBIZuP+l7T+33RUZhHDDMRCf+924fdyQ7ByNNyi84Cz1xTdKu0cUzV3k5+G7LjvdIr/BATafnwk=
X-Received: by 2002:a17:902:9002:: with SMTP id a2mr10495952plp.147.1571842817724;
 Wed, 23 Oct 2019 08:00:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571762488.git.andreyknvl@google.com> <26e088ae3ebcaa30afe957aeabaa9f0c653df7d0.1571762488.git.andreyknvl@google.com>
 <CACT4Y+YntxT+cpESOBvbg+h=g-84ECJwQrFg7LM5tbq_zaMd3A@mail.gmail.com>
 <CAAeHK+yUTZc+BrGDvvTQD4O0hsDzhp0V6GGFdtnmE6U4yWabKw@mail.gmail.com> <CACT4Y+b+RTYjUyB1h0SYjEq8vmOZas3ByjeJqVU1LrjxpRKy2Q@mail.gmail.com>
In-Reply-To: <CACT4Y+b+RTYjUyB1h0SYjEq8vmOZas3ByjeJqVU1LrjxpRKy2Q@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 23 Oct 2019 17:00:06 +0200
Message-ID: <CAAeHK+x-dihJ5+Zb1JBNaL5VK1zB87BR5kPX2B=q+FyVW+WHnw@mail.gmail.com>
Subject: Re: [PATCH 3/3] vhost, kcov: collect coverage from vhost_worker
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     USB list <linux-usb@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 3:50 PM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Wed, Oct 23, 2019 at 3:35 PM Andrey Konovalov <andreyknvl@google.com> wrote:
> >
> > On Wed, Oct 23, 2019 at 10:36 AM Dmitry Vyukov <dvyukov@google.com> wrote:
> > >
> > > On Tue, Oct 22, 2019 at 6:46 PM Andrey Konovalov <andreyknvl@google.com> wrote:
> > > >
> > > > This patch adds kcov_remote_start()/kcov_remote_stop() annotations to the
> > > > vhost_worker() function, which is responsible for processing vhost works.
> > > > Since vhost_worker() threads are spawned per vhost device instance
> > > > the common kcov handle is used for kcov_remote_start()/stop() annotations
> > > > (see Documentation/dev-tools/kcov.rst for details). As the result kcov can
> > > > now be used to collect coverage from vhost worker threads.
> > > >
> > > > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > > > ---
> > > >  drivers/vhost/vhost.c | 6 ++++++
> > > >  drivers/vhost/vhost.h | 1 +
> > > >  2 files changed, 7 insertions(+)
> > > >
> > > > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > > > index 36ca2cf419bf..a5a557c4b67f 100644
> > > > --- a/drivers/vhost/vhost.c
> > > > +++ b/drivers/vhost/vhost.c
> > > > @@ -30,6 +30,7 @@
> > > >  #include <linux/sched/signal.h>
> > > >  #include <linux/interval_tree_generic.h>
> > > >  #include <linux/nospec.h>
> > > > +#include <linux/kcov.h>
> > > >
> > > >  #include "vhost.h"
> > > >
> > > > @@ -357,7 +358,9 @@ static int vhost_worker(void *data)
> > > >                 llist_for_each_entry_safe(work, work_next, node, node) {
> > > >                         clear_bit(VHOST_WORK_QUEUED, &work->flags);
> > > >                         __set_current_state(TASK_RUNNING);
> > > > +                       kcov_remote_start(dev->kcov_handle);
> > > >                         work->fn(work);
> > > > +                       kcov_remote_stop();
> > > >                         if (need_resched())
> > > >                                 schedule();
> > > >                 }
> > > > @@ -546,6 +549,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
> > > >
> > > >         /* No owner, become one */
> > > >         dev->mm = get_task_mm(current);
> > > > +       dev->kcov_handle = current->kcov_handle;
> > >
> > > kcov_handle is not present in task_struct if !CONFIG_KCOV
> > >
> > > Also this does not use KCOV_SUBSYSTEM_COMMON.
> > > We discussed something along the following lines:
> > >
> > > u64 kcov_remote_handle(u64 subsys, u64 id)
> > > {
> > >   WARN_ON(subsys or id has wrong bits set).
> >
> > Hm, we can't have warnings in kcov_remote_handle() that is exposed in
> > uapi headers. What we can do is return 0 (invalid handle) if subsys/id
> > have incorrect bits set. And then we can either have another
> > kcov_remote_handle() internally (with a different name though) that
> > has a warning, or have warning in kcov_remote_start(). WDYT?
>
> I would probably add the warning to kcov_remote_start(). This avoids
> the need for another function and will catch a wrong ID if caller
> generated it by some other means.
> And then ioctls should also detect bad handles passed in and return
> EINVAL. Then we will cover errors for both kernel and user programs.

OK, will do in v2.

>
> >
> > >   return ...;
> > > }
> > >
> > > kcov_remote_handle(KCOV_SUBSYSTEM_USB, bus);
> > > kcov_remote_handle(KCOV_SUBSYSTEM_COMMON, current->kcov_handle);

I'll add internal kcov_remote_handle_common() and
kcov_remote_handle_usb() helpers to simplify kcov hooks in usb/vhost
code though.

> > >
> > >
> > > >         worker = kthread_create(vhost_worker, dev, "vhost-%d", current->pid);
> > > >         if (IS_ERR(worker)) {
> > > >                 err = PTR_ERR(worker);
> > > > @@ -571,6 +575,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
> > > >         if (dev->mm)
> > > >                 mmput(dev->mm);
> > > >         dev->mm = NULL;
> > > > +       dev->kcov_handle = 0;
> > > >  err_mm:
> > > >         return err;
> > > >  }
> > > > @@ -682,6 +687,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> > > >         if (dev->worker) {
> > > >                 kthread_stop(dev->worker);
> > > >                 dev->worker = NULL;
> > > > +               dev->kcov_handle = 0;
> > > >         }
> > > >         if (dev->mm)
> > > >                 mmput(dev->mm);
> > > > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > > > index e9ed2722b633..a123fd70847e 100644
> > > > --- a/drivers/vhost/vhost.h
> > > > +++ b/drivers/vhost/vhost.h
> > > > @@ -173,6 +173,7 @@ struct vhost_dev {
> > > >         int iov_limit;
> > > >         int weight;
> > > >         int byte_weight;
> > > > +       u64 kcov_handle;
> > > >  };
> > > >
> > > >  bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
> > > > --
> > > > 2.23.0.866.gb869b98d4c-goog
> > > >
