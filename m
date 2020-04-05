Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 508EF19EA2B
	for <lists+netdev@lfdr.de>; Sun,  5 Apr 2020 11:18:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726546AbgDEJSF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Apr 2020 05:18:05 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:46213 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbgDEJSF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Apr 2020 05:18:05 -0400
Received: by mail-lj1-f193.google.com with SMTP id r7so11297189ljg.13;
        Sun, 05 Apr 2020 02:18:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ezAeoP6FHV4AgjLzQuSOWjGz7T/3USe1LlIeyEWnVyY=;
        b=BJop5i+EaG3paQbNb4bN/ifD24C0PwLCf4+Fe1ldfM6T5WuJdO6h34bW8Mg3TT2j9a
         RTSZOePJPsJzM/ejFEoFXHzK4y7WW1IQjDrY5AeDsZtZcLuUJomZykzce7OY3U0FIeer
         sz3CwiDmFbmYJJ1dsHGqLtoN74nBjxpnCPLTXG7qE9tU/cKisiP5ovyQoFSlaTJtEWi1
         vlNmEU3ozk0LKP4qYL07NHUaKzYmCY+ZH501//0zXFvEeNke0kp9MbSWbiuQ9j8ZIz2d
         xLXItZEC+zgMrjwETAydoLc8vEedkihxqKq3bl+ivRp46f9i55SX20cXTipr3iPqHerY
         U+Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ezAeoP6FHV4AgjLzQuSOWjGz7T/3USe1LlIeyEWnVyY=;
        b=VNCT/uVTd0dm+uPy4zEluEArEWv925MnR842mjqTXnvBH4ByLF+QmZSbfPAj+hZSFk
         KfGSGYXRHwkn08hSL3hPc/AgU5uT9gg254pQwZ+dSZCijPUHvlZk5ky5G1hZp4/80VTb
         HmqS5z1dc/x8Zu0BGPaQOSpBkqB+l718UUh69zZ07Q2Rn6qMrJbaqD7Uu4IjVMPLNq1t
         7IZejh6AF1piiniO0PyJRuTfakqDrJT8KfN3Jmo2milzx9KQTNZut7EZHJUq6ur0wbyI
         heO38wd4qjAczs92189pFAMXjzSATLIrY64+Velj6EDtpZmG8QIjCcZ/KX0gKgs/pc3S
         GCNw==
X-Gm-Message-State: AGi0PubgPbSsdIUeC005+CGe/ijeEseDSQj8Ddxp0VcFGarhjUFrYBnl
        ty4BENfJChXkubU3qrVrYaLc9Bq99j63ZASZaKQIHn6d
X-Google-Smtp-Source: APiQypJPDLy6OKizWRXuz0X5VBBP6ERK7+B3E98bN+O0lraEpSbbuOTmRKhtm25oWPuHP62rY1+rK/uU5ZMUjYZTMRI=
X-Received: by 2002:a2e:9252:: with SMTP id v18mr9228042ljg.114.1586078282352;
 Sun, 05 Apr 2020 02:18:02 -0700 (PDT)
MIME-Version: 1.0
References: <20200404141909.26399-1-ap420073@gmail.com> <20200404155122.GD1476305@kroah.com>
 <CAMArcTVdn7FcfX-BCnZ+LUzdct4yj2BLyhpTu832_VGt_O+xWA@mail.gmail.com> <20200405073212.GA1551960@kroah.com>
In-Reply-To: <20200405073212.GA1551960@kroah.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 5 Apr 2020 18:17:50 +0900
Message-ID: <CAMArcTVp4Hvsg607+Robuw3wgajTBa-9LeD=50+b9NumDAF-Hg@mail.gmail.com>
Subject: Re: [PATCH net v2 2/3] net: core: add netdev_class_has_file_ns()
 helper function
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, rafael@kernel.org,
        j.vosburgh@gmail.com, vfalico@gmail.com,
        Andy Gospodarek <andy@greyhouse.net>,
        Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, mitch.a.williams@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 5 Apr 2020 at 16:32, Greg KH <gregkh@linuxfoundation.org> wrote:
>

Hi Greg,
Thank you for the review!

> On Sun, Apr 05, 2020 at 02:18:22AM +0900, Taehee Yoo wrote:
> > On Sun, 5 Apr 2020 at 00:51, Greg KH <gregkh@linuxfoundation.org> wrote:
> > >
> >
> > Hi Greg,
> > Thank you for your review!
> >
> > > On Sat, Apr 04, 2020 at 02:19:09PM +0000, Taehee Yoo wrote:
> > > > This helper function is to check whether the class file "/sys/class/net/*"
> > > > is existing or not.
> > > > In the next patch, this helper function will be used.
> > > >
> > > > Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
> > > > Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
> > > > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > > > ---
> > > >
> > > > v1 -> v2:
> > > >  - use class_has_file_ns(), which is introduced by the first patch.
> > > >
> > > >  include/linux/netdevice.h | 2 +-
> > > >  net/core/net-sysfs.c      | 6 ++++++
> > > >  2 files changed, 7 insertions(+), 1 deletion(-)
> > > >
> > > > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > > > index 130a668049ab..a04c487c0975 100644
> > > > --- a/include/linux/netdevice.h
> > > > +++ b/include/linux/netdevice.h
> > > > @@ -4555,7 +4555,7 @@ int netdev_class_create_file_ns(const struct class_attribute *class_attr,
> > > >                               const void *ns);
> > > >  void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
> > > >                                const void *ns);
> > > > -
> > > > +bool netdev_class_has_file_ns(const char *name, const void *ns);
> > > >  static inline int netdev_class_create_file(const struct class_attribute *class_attr)
> > > >  {
> > > >       return netdev_class_create_file_ns(class_attr, NULL);
> > > > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > > > index cf0215734ceb..8a20d658eff0 100644
> > > > --- a/net/core/net-sysfs.c
> > > > +++ b/net/core/net-sysfs.c
> > > > @@ -1914,6 +1914,12 @@ void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
> > > >  }
> > > >  EXPORT_SYMBOL(netdev_class_remove_file_ns);
> > > >
> > > > +bool netdev_class_has_file_ns(const char *name, const void *ns)
> > > > +{
> > > > +     return class_has_file_ns(&net_class, name, ns);
> > > > +}
> > > > +EXPORT_SYMBOL(netdev_class_has_file_ns);
> > >
> > > Again, this feels broken, it can not solve a race condition.
> > >
> >
> > This function is considered to be used under rtnl mutex and
> > I assume that no one could use "/sys/class/net/*" outside of rtnl mutex.
> > So, I think it returns the correct information under rtnl mutex.
>
> But you are creating a globally exported function that can be called
> from anywhere, and as such, is not useful because it has no locking or
> hints of how to use it correctly at all.
>

Yes, I agree with that.

> Again, don't push this "solution" down to sysfs to solve, you know if
> you have a device that is not cleaned up yet, so don't try to
> rename/create a device of the same name before that is finished.
>

Okay, Thank you for that.
I will find another way to fix it.

Thanks a lot!
Taehee Yoo
