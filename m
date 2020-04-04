Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5D11819E6A9
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 19:18:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726370AbgDDRSg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 13:18:36 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:34420 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726057AbgDDRSg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 13:18:36 -0400
Received: by mail-lj1-f193.google.com with SMTP id p10so10275842ljn.1;
        Sat, 04 Apr 2020 10:18:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+uhxRGX6MPG3FC6JHWtiYmK6qLmp1QIoL6oQZjfRONY=;
        b=nd+WcLU8Nkb3NCybgzvxt5VvOktuAe/AqLpVnjLRMi1zhdqSwGot8V+Wntg2eoytm4
         UYw+VXJ6se7MqMNVECQGMqZyn4Dtfg3FBpju68UAzafwtNqJPASMLh6NoNAtnHDIx5Dc
         LisWSh2BUCh+q/qdErQZdpILL+qDYCibSb/ZaELWTwkDGSd104JClCdzlImF5lgGwYbM
         VY90nOWQj9th3yD97HjIp8kcx3AJhJeLugb1FGGnZVzu1JL+PkTEBQuwy0h16ejB5tp0
         UnTFokM4kcyiZJHcez78Qda6TEUOKgGvuRjpUbY0Ztf0jdCPUcFLewwUC6Rl1IdkxSz/
         U3EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+uhxRGX6MPG3FC6JHWtiYmK6qLmp1QIoL6oQZjfRONY=;
        b=heFe5iXOKv2oZldsxyuZJFKtKfVZzi3H9gfy3pcxVfvhiguK9+elOK2WA1HH1mft5o
         4S3930WfZCUBg+WFC8hZxZKMLlgeRrUbuLj1FnLDb9JE3nA3Oz86HblCMlozxROfNK6J
         OYbR70jUJKcQnKHkU5jxjUw3ISgOptvzccf7z5T/drn5HdqDvkVkTJKx3NJ0zBJcqqAd
         0jOnQkFF3xQtJGxpJBoHfmqBy09piWVf/dFsFxZxJpWN9QsSzNNeQ3J6odomdh2gOOMC
         7VZ/W+7tTGSxDBSLvA3Vhmpc9LzVzhWXfCsEjEN9E2TapP6k7XPLMEYN8nfvoMz9OFel
         HHPA==
X-Gm-Message-State: AGi0PuY9BmTKwycYmqjYAYi6D9E+wtIg4NbT89Vk6+UNDel00YekAMmd
        KEdnis9jYzFGrPE0pLRjRVWR0gOCh3BTXW45tEI=
X-Google-Smtp-Source: APiQypKbneMMaFHfEv8AYv4pXWPjoKLLu9YejArU/08n/11tmBWhsBVTZ41q0GYynLf1gxAoQxMR37qxtV7jCEj2kmI=
X-Received: by 2002:a2e:81cc:: with SMTP id s12mr7960117ljg.90.1586020713555;
 Sat, 04 Apr 2020 10:18:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200404141909.26399-1-ap420073@gmail.com> <20200404155122.GD1476305@kroah.com>
In-Reply-To: <20200404155122.GD1476305@kroah.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 5 Apr 2020 02:18:22 +0900
Message-ID: <CAMArcTVdn7FcfX-BCnZ+LUzdct4yj2BLyhpTu832_VGt_O+xWA@mail.gmail.com>
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

On Sun, 5 Apr 2020 at 00:51, Greg KH <gregkh@linuxfoundation.org> wrote:
>

Hi Greg,
Thank you for your review!

> On Sat, Apr 04, 2020 at 02:19:09PM +0000, Taehee Yoo wrote:
> > This helper function is to check whether the class file "/sys/class/net/*"
> > is existing or not.
> > In the next patch, this helper function will be used.
> >
> > Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
> > Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >
> > v1 -> v2:
> >  - use class_has_file_ns(), which is introduced by the first patch.
> >
> >  include/linux/netdevice.h | 2 +-
> >  net/core/net-sysfs.c      | 6 ++++++
> >  2 files changed, 7 insertions(+), 1 deletion(-)
> >
> > diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
> > index 130a668049ab..a04c487c0975 100644
> > --- a/include/linux/netdevice.h
> > +++ b/include/linux/netdevice.h
> > @@ -4555,7 +4555,7 @@ int netdev_class_create_file_ns(const struct class_attribute *class_attr,
> >                               const void *ns);
> >  void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
> >                                const void *ns);
> > -
> > +bool netdev_class_has_file_ns(const char *name, const void *ns);
> >  static inline int netdev_class_create_file(const struct class_attribute *class_attr)
> >  {
> >       return netdev_class_create_file_ns(class_attr, NULL);
> > diff --git a/net/core/net-sysfs.c b/net/core/net-sysfs.c
> > index cf0215734ceb..8a20d658eff0 100644
> > --- a/net/core/net-sysfs.c
> > +++ b/net/core/net-sysfs.c
> > @@ -1914,6 +1914,12 @@ void netdev_class_remove_file_ns(const struct class_attribute *class_attr,
> >  }
> >  EXPORT_SYMBOL(netdev_class_remove_file_ns);
> >
> > +bool netdev_class_has_file_ns(const char *name, const void *ns)
> > +{
> > +     return class_has_file_ns(&net_class, name, ns);
> > +}
> > +EXPORT_SYMBOL(netdev_class_has_file_ns);
>
> Again, this feels broken, it can not solve a race condition.
>

This function is considered to be used under rtnl mutex and
I assume that no one could use "/sys/class/net/*" outside of rtnl mutex.
So, I think it returns the correct information under rtnl mutex.

Thanks a lot!
Taehee Yoo
