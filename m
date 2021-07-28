Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45D053D8F9F
	for <lists+netdev@lfdr.de>; Wed, 28 Jul 2021 15:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236989AbhG1NwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Jul 2021 09:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbhG1Ntv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Jul 2021 09:49:51 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5344C061757;
        Wed, 28 Jul 2021 06:49:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=5gAFhq7uxpygosvYi5fsP8TKJ4+Xv342mlFirtLR2YU=; b=fJQUuozmRpR8MormyH8buz5xzx
        /+ROEeWNCEWYdzKhhXlPEfaaa4AZj9YFiIdXYUsv2WmOzIyBBtLtk+WgdXGyRYHPT3USV7SruHk1D
        irJQTziFyhJcmijEKzvtEoWgZbW8pJBx7xr33C5qcdt2r/XixHBv72RlHXu4kHn5u02+uBYjuEWX8
        Uw5YmkDgSlh5XgxVFqWDa5AWNpa7gVI3umnucUiV3JmQUymFdIdY0NtjBW/+0QTioCVjUVInaS2/d
        6BSmeaIukdbwTt1d6t5V0ha/5W+sgC2s+aZtPRNPsfMnGNWrN2g29hTzTkVHydV4AS4L/U8guWXC6
        QSJMpWcg==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1m8jvj-000pwG-NP; Wed, 28 Jul 2021 13:49:03 +0000
Date:   Wed, 28 Jul 2021 06:49:03 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     David Laight <David.Laight@aculab.com>
Cc:     "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "tj@kernel.org" <tj@kernel.org>,
        "shuah@kernel.org" <shuah@kernel.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "andriin@fb.com" <andriin@fb.com>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "atenart@kernel.org" <atenart@kernel.org>,
        "alobakin@pm.me" <alobakin@pm.me>,
        "weiwan@google.com" <weiwan@google.com>,
        "ap420073@gmail.com" <ap420073@gmail.com>,
        "jeyu@kernel.org" <jeyu@kernel.org>,
        "ngupta@vflare.org" <ngupta@vflare.org>,
        "sergey.senozhatsky.work@gmail.com" 
        <sergey.senozhatsky.work@gmail.com>,
        "minchan@kernel.org" <minchan@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "mbenes@suse.com" <mbenes@suse.com>,
        "jpoimboe@redhat.com" <jpoimboe@redhat.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "keescook@chromium.org" <keescook@chromium.org>,
        "jikos@kernel.org" <jikos@kernel.org>,
        "rostedt@goodmis.org" <rostedt@goodmis.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Douglas Gilbert <dgilbert@interlog.com>,
        Hannes Reinecke <hare@suse.de>,
        "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kernel/module: add documentation for try_module_get()
Message-ID: <YQFgTxz62G+3Lc8G@bombadil.infradead.org>
References: <20210722221905.1718213-1-mcgrof@kernel.org>
 <dbf27fa2f8864e1d91f7015249b1a5f1@AcuMS.aculab.com>
 <YQBCvKgH481C7o1c@bombadil.infradead.org>
 <YQBGemOIF4sp/ges@kroah.com>
 <YQBN2/K4Ne5orgzS@bombadil.infradead.org>
 <YQBSutZfhqfTzKQa@kroah.com>
 <YQByfUaDaXCUqrlo@bombadil.infradead.org>
 <6054c136290346d581e276abbb2e3ff1@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6054c136290346d581e276abbb2e3ff1@AcuMS.aculab.com>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 28, 2021 at 08:28:11AM +0000, David Laight wrote:
> ...
> > sysfs files are safe to use try_module_get() because once they are
> > active a removal of the file cannot happen, and so removal will wait.
> 
> I doubt it.

But that is what happens.

> If the module_remove() function removes sysfs nodes then (something
> like) this has to happen.
> 
> 1) rmmod (or similar) tries to remove the module.
> 2) The reference count is zero so the remove is allowed.
> 3) Something tries to access a sysfs node in the module.
> 3a) If sysfs knew the nodes were in a module it could use
>     try_module_get() to ensure the module wasn't being unloaded.
>     Failure would cause the sysfs access to fail.
>     But I'm not sure it does,


It does, if a sysfs file had a try_module_get() it would fail as the
module is going.

>     and in any case it doesn't help.

Not clear how from your example.

> 3b) The sysfs thread calls into the module code and waits on a mutex.

If try_module_get() is used on the syfs files, the deadlock is escaped if
used on remove.

> 3c) The rmmod thread gets around to calling into sysfs to remove the nodes.
> 
> At this point we hit the standard 'deregistering a callback' issue.
> Exactly the same issue affects removal of per-device sysfs node
> from a driver's .remove function.
> 
> Typically this is solved by making the deregister routing sleep
> until all the callbacks have completed.
> 
> So this would require functions like sysfs_remove_group() and
> hwmon_device_unregister() to be allowed to sleep

Both can.

Both kernfs_find_and_get_ns() and kernfs_remove_by_name_ns() call
mutex_lock(), they certainly can sleep.

hwmon_device_unregister() calls device_del() which also holds a mutex.

> and not be
> called with any locks (of any kind) held that the callback
> functions acquire.

Not sure why you think this is a requirement.

> The module reference count is irrelevant.

To be clear, there were concerns that there were races here which would
make things murky on sysfs operations and module removal (null
deferences when accessing back the gendisk->private_data) however a
a new selftest driver for sysfs [0], and error injections to allow us to
test and verify all these things I just said are true. If you'd like
to extend the tests to include something you might be concerned about
and want to try, please send me a patch against my tree [1].

[0] https://lkml.kernel.org/r/20210703004632.621662-1-mcgrof@kernel.org
[1] https://git.kernel.org/pub/scm/linux/kernel/git/mcgrof/linux-next.git/log/?h=20210701-sysfs-fix-races-v2

  Luis
