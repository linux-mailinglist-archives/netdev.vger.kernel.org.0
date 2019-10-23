Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D0A0E1CB7
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 15:35:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392050AbfJWNfZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 09:35:25 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:39535 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2392043AbfJWNfZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 09:35:25 -0400
Received: by mail-pg1-f196.google.com with SMTP id p12so12176675pgn.6
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 06:35:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vVilgvsFyNX8l3o19LPHCyMKXEOlo8DFL7KyI287g14=;
        b=QqK89MD/Yy/DM00W1esVEoeVn3WMhLsa0Vl3e77HqhpfXG1sxJ0v4cgzzmJTrf7pHQ
         HcpSZgN31RBFHk6C7UnejQDVK6ql1RlvQgrgDpRuB/5HN0jwZ4qnDwnaHbicV36UWhMu
         KwFlO69OYvODLWqaW+AIKdV+fmaq5vcqsd1PcbjMAAQarx1WdTLAbUb4dcb/kMGuqFyi
         qqUtZ9oYKNMoCYPjRS0LtILIQLBGu5ytKdhZg1UR7mtZh9zYg+zLmI5gowtGsbfT76ie
         /iChDTldOkR4Y0RQ/5JfueemrwEfFRlzAfFt3dAVNFnONLrl6PzrYvU6sG2AelLOrRPa
         I6Yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vVilgvsFyNX8l3o19LPHCyMKXEOlo8DFL7KyI287g14=;
        b=lg+fDPPOwMiA9SaRQhSq/KKfej6IgS9zTNljbzyu2nT1eUwFr24NIoVQOL7GZ8fJu9
         NAKppkP3xVuu5nAm7DwqLLDh/oxwpNbFV+xUoQ11WLGXgFlSxEQJ6aRwFPY3cWR8psRT
         AwfAARPGhPPDZ4RGwMfjQGxrixCo0Xy+L/VSt/lUCcfn9i31oy+QdVBCWSEDsX/nrwgV
         w8VLVdsi2PcMo8EWVU+3E9wOEaOriGh5OfopjRMV27yMNgQ0aYeMGg1aY1CFTmxNPveC
         2ZlSUyFhhfTjVa5ZuZMU/VQxF6B/nWfFJFy31AeGrZkX07y4/DQDlbYeWdbm8QbeMiN0
         I7TA==
X-Gm-Message-State: APjAAAUsff9yitU4tsJSylJ+YM94j7TUsbwW6gDYf06tHwrX9YXgjg3o
        ZNdIz4Z+x/C3UOU3l3/XVWEBbpXbJQ8MGdC7h6KpIw==
X-Google-Smtp-Source: APXvYqxsyojwtcUMv+o4xED6tZ63YIYmQojsChVXt9dxnYDWrRS7pWDqJ873W66V6rP/TblVEj2JJse9T5W9jYerCBg=
X-Received: by 2002:a17:90a:6509:: with SMTP id i9mr11551965pjj.47.1571837723368;
 Wed, 23 Oct 2019 06:35:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571762488.git.andreyknvl@google.com> <26e088ae3ebcaa30afe957aeabaa9f0c653df7d0.1571762488.git.andreyknvl@google.com>
 <CACT4Y+YntxT+cpESOBvbg+h=g-84ECJwQrFg7LM5tbq_zaMd3A@mail.gmail.com>
In-Reply-To: <CACT4Y+YntxT+cpESOBvbg+h=g-84ECJwQrFg7LM5tbq_zaMd3A@mail.gmail.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Wed, 23 Oct 2019 15:35:12 +0200
Message-ID: <CAAeHK+yUTZc+BrGDvvTQD4O0hsDzhp0V6GGFdtnmE6U4yWabKw@mail.gmail.com>
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

On Wed, Oct 23, 2019 at 10:36 AM Dmitry Vyukov <dvyukov@google.com> wrote:
>
> On Tue, Oct 22, 2019 at 6:46 PM Andrey Konovalov <andreyknvl@google.com> wrote:
> >
> > This patch adds kcov_remote_start()/kcov_remote_stop() annotations to the
> > vhost_worker() function, which is responsible for processing vhost works.
> > Since vhost_worker() threads are spawned per vhost device instance
> > the common kcov handle is used for kcov_remote_start()/stop() annotations
> > (see Documentation/dev-tools/kcov.rst for details). As the result kcov can
> > now be used to collect coverage from vhost worker threads.
> >
> > Signed-off-by: Andrey Konovalov <andreyknvl@google.com>
> > ---
> >  drivers/vhost/vhost.c | 6 ++++++
> >  drivers/vhost/vhost.h | 1 +
> >  2 files changed, 7 insertions(+)
> >
> > diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> > index 36ca2cf419bf..a5a557c4b67f 100644
> > --- a/drivers/vhost/vhost.c
> > +++ b/drivers/vhost/vhost.c
> > @@ -30,6 +30,7 @@
> >  #include <linux/sched/signal.h>
> >  #include <linux/interval_tree_generic.h>
> >  #include <linux/nospec.h>
> > +#include <linux/kcov.h>
> >
> >  #include "vhost.h"
> >
> > @@ -357,7 +358,9 @@ static int vhost_worker(void *data)
> >                 llist_for_each_entry_safe(work, work_next, node, node) {
> >                         clear_bit(VHOST_WORK_QUEUED, &work->flags);
> >                         __set_current_state(TASK_RUNNING);
> > +                       kcov_remote_start(dev->kcov_handle);
> >                         work->fn(work);
> > +                       kcov_remote_stop();
> >                         if (need_resched())
> >                                 schedule();
> >                 }
> > @@ -546,6 +549,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
> >
> >         /* No owner, become one */
> >         dev->mm = get_task_mm(current);
> > +       dev->kcov_handle = current->kcov_handle;
>
> kcov_handle is not present in task_struct if !CONFIG_KCOV
>
> Also this does not use KCOV_SUBSYSTEM_COMMON.
> We discussed something along the following lines:
>
> u64 kcov_remote_handle(u64 subsys, u64 id)
> {
>   WARN_ON(subsys or id has wrong bits set).

Hm, we can't have warnings in kcov_remote_handle() that is exposed in
uapi headers. What we can do is return 0 (invalid handle) if subsys/id
have incorrect bits set. And then we can either have another
kcov_remote_handle() internally (with a different name though) that
has a warning, or have warning in kcov_remote_start(). WDYT?

>   return ...;
> }
>
> kcov_remote_handle(KCOV_SUBSYSTEM_USB, bus);
> kcov_remote_handle(KCOV_SUBSYSTEM_COMMON, current->kcov_handle);
>
>
> >         worker = kthread_create(vhost_worker, dev, "vhost-%d", current->pid);
> >         if (IS_ERR(worker)) {
> >                 err = PTR_ERR(worker);
> > @@ -571,6 +575,7 @@ long vhost_dev_set_owner(struct vhost_dev *dev)
> >         if (dev->mm)
> >                 mmput(dev->mm);
> >         dev->mm = NULL;
> > +       dev->kcov_handle = 0;
> >  err_mm:
> >         return err;
> >  }
> > @@ -682,6 +687,7 @@ void vhost_dev_cleanup(struct vhost_dev *dev)
> >         if (dev->worker) {
> >                 kthread_stop(dev->worker);
> >                 dev->worker = NULL;
> > +               dev->kcov_handle = 0;
> >         }
> >         if (dev->mm)
> >                 mmput(dev->mm);
> > diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> > index e9ed2722b633..a123fd70847e 100644
> > --- a/drivers/vhost/vhost.h
> > +++ b/drivers/vhost/vhost.h
> > @@ -173,6 +173,7 @@ struct vhost_dev {
> >         int iov_limit;
> >         int weight;
> >         int byte_weight;
> > +       u64 kcov_handle;
> >  };
> >
> >  bool vhost_exceeds_weight(struct vhost_virtqueue *vq, int pkts, int total_len);
> > --
> > 2.23.0.866.gb869b98d4c-goog
> >
