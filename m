Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E4288141D8F
	for <lists+netdev@lfdr.de>; Sun, 19 Jan 2020 12:30:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbgASL2o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jan 2020 06:28:44 -0500
Received: from mail-lf1-f66.google.com ([209.85.167.66]:36428 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgASL2o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jan 2020 06:28:44 -0500
Received: by mail-lf1-f66.google.com with SMTP id f24so651050lfh.3
        for <netdev@vger.kernel.org>; Sun, 19 Jan 2020 03:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6Ts8qlV6Gn9QGUG97LYwJR+vBwIVRFSsblChTwTFmuQ=;
        b=JdOeYeOVXcgvo68N2cC1JnOiXS6FHmc7wSnBo3hJ1scu4oyJDCIyxyrE8uMFsSEdm8
         fafKuzQ91q11iP7TeUXPcQ8zY53R/u0XDg1zlhQsKGThatOckoiWq0/iHGldRBd9P76d
         SF8wqI2Sm1pxDqGiR0WhxS1C+3NQBLKA9uByjs1FX26ScpdB/mq2P95b50gzmc8M3n7K
         fiRCopk5q6Qi/kMt2UTnbLRn2W1iMzp7L7cjk6HqFbRf2iYcgKXYGvh42J8diyo8VESb
         61avPnkQCO04qyABrku4jASuc+dZfBqjvlOLjgV2LpmMdpi/7zb0F6r1JUL5GSFMgA/9
         YC7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6Ts8qlV6Gn9QGUG97LYwJR+vBwIVRFSsblChTwTFmuQ=;
        b=cQuQdisniu91xbJJ08WEhgwnArZnlwqedlbtkszjtRC3C3HC1LE+tJXZtVTMjpNs1Z
         4IXPzZsUBrH7mWCGm+pTYkG/NfzmACl3etVtKEI5iUYL1ri68aiKIOWBopvGqB9Kr3z8
         k3FMDRY8As0ybV2mkOi5x67fZ3byepP3b1ljPJw0Ww8YFYiuDUJDm8Z3KZZ8EQK7WmFP
         NKicwKkMHOOqSA6UIJAwMx5xk8TUJuLADVSq98mQMd8tM11rH/z7FW575lmbZ7S+vnpD
         IX3tM98CedYdtOERz7PmklkjOUdh0Ipm7bS5sWyiJg8Prqc7JeZCI+iefm459g/ORGiR
         8PwA==
X-Gm-Message-State: APjAAAVpurJHUR97Lhsc6VTiHjuGdAetP8PLlNZ21sA6L7SwIIFDuMbt
        nbZv1Vnr2S6w/4T8GrM33XiK3CYprf9+wsHgVOGpSvis
X-Google-Smtp-Source: APXvYqxeotNkUErEO1/u4J6Nv8k7BXEtMdRDZB4OczedOPlB9L7S08xIqdXU4/heM/rwwf5mjEq0eaFc9nDp5c8tdsM=
X-Received: by 2002:a19:7401:: with SMTP id v1mr10676431lfe.129.1579433322257;
 Sun, 19 Jan 2020 03:28:42 -0800 (PST)
MIME-Version: 1.0
References: <20200111163723.4260-1-ap420073@gmail.com> <20200112064110.43245268@cakuba>
 <CAMArcTUZ476vinLb2f+JfGB209=qYeSWFgAHgb4DJdt4o9OHKw@mail.gmail.com>
In-Reply-To: <CAMArcTUZ476vinLb2f+JfGB209=qYeSWFgAHgb4DJdt4o9OHKw@mail.gmail.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 19 Jan 2020 20:28:30 +0900
Message-ID: <CAMArcTUAmv2x6bTeLSVK9_3L4v562NpYiKqyu-e8_30PA3uqSg@mail.gmail.com>
Subject: Re: [PATCH net 3/5] netdevsim: avoid debugfs warning message when
 module is remove
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     David Miller <davem@davemloft.net>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 16 Jan 2020 at 23:54, Taehee Yoo <ap420073@gmail.com> wrote:
>
> On Sun, 12 Jan 2020 at 23:45, Jakub Kicinski <kuba@kernel.org> wrote:
> >
>
> Hi Jakub,

Hi again!

> Thank you for catching the problem!
>
> > On Sat, 11 Jan 2020 16:37:23 +0000, Taehee Yoo wrote:
> > > When module is being removed, it couldn't be held by try_module_get().
> > > debugfs's open function internally tries to hold file_operation->owner
> > > if .owner is set.
> > > If holding owner operation is failed, it prints a warning message.
> >
> > > [  412.227709][ T1720] debugfs file owner did not clean up at exit: ipsec
> >
> > > In order to avoid the warning message, this patch makes netdevsim module
> > > does not set .owner. Unsetting .owner is safe because these are protected
> > > by inode_lock().
> >
> > So inode_lock will protect from the code getting unloaded/disappearing?
> > At a quick glance at debugs code it doesn't seem that inode_lock would
> > do that. Could you explain a little more to a non-fs developer like
> > myself? :)
> >
> > Alternatively should we perhaps hold a module reference for each device
> > created and force user space to clean up the devices? That may require
> > some fixes to the test which use netdevsim.
> >
>
> Sorry, I misunderstood the debugfs logic.
> inode_lock() is called by debugfs_remove() and debugfs_create_file().
> It doesn't protect read and write operations.
>
> Currently, I have been taking look at debugfs_file_{get/put}() function,
> which increases and decreases the reference counter.
> In the __debugfs_file_removed(), this reference counter is used for
> waiting read and write operations. Unfortunately, the
> __debugfs_file_removed() isn't used because of "dentry->d_flags" value.
> So, I'm looking for a way to use these functions.

I will drop this patch from this patchset because .owner should be set.
If I understood debugfs logic correctly, only .owner protect the whole
.owner module. There are other locks in there, which are "d_lockref"
and "active_users" counter.

1. "active_users" protects it "temporarily" when operations are
being executed. So, it doesn't protect the whole .owner module.

static ret_type full_proxy_ ## name(proto)                              \
{                                                                       \
        struct dentry *dentry = F_DENTRY(filp);                 \
        const struct file_operations *real_fops;                        \
        ret_type r;                                                     \
                                                                        \
        r = debugfs_file_get(dentry);                                   \
        if (unlikely(r))                                                \
                return r;                                               \
        real_fops = debugfs_real_fops(filp);                            \
        r = real_fops->name(args);                                      \
        debugfs_file_put(dentry);                                       \
        return r;                                                       \
}

2. "d_lockref.count" means how many users are using this dentry.
This is also a counter value.
This is increased when ->open() is being called.
And this is decreased when ->released() is being called.
I think this counter is a good way to protect the .owner module.
But, debugfs_remove() doesn't wait for ->release() with this value.
So actually it couldn't protect the module.

So, there is no other way to protect the module disappearing while the
file is being used.
I think avoiding a warning message is up to the debugfs code.

So, I will drop this patch from the patchset.

Thanks again for the review.
Taehee Yoo
