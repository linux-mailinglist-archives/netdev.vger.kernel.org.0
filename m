Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7221019E67B
	for <lists+netdev@lfdr.de>; Sat,  4 Apr 2020 18:46:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726294AbgDDQfa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Apr 2020 12:35:30 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:33596 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbgDDQf3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Apr 2020 12:35:29 -0400
Received: by mail-lj1-f195.google.com with SMTP id f20so10203338ljm.0;
        Sat, 04 Apr 2020 09:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=TcZGIpZFtsXQnB9IM08ZO9Vrk1h6ZXgf7qgWlNa11hY=;
        b=hUY1lkeI80CHymemQMT2uF4IhmhhZhgY8dFrQIX+4laKtyHJNVGCd10YpYGNBDmf8d
         LKOLEObwgKE9KfsVT2Gk5vnQxkov3L7FkCbemeaM2p600g2ZXHDfFa4Tm9e1jx5uwjxX
         BHyug1lXYg9GJAGNttowFSA33mKP1QwLnV3CU+2GZoxId1KgHR9ctXERL06I+QEnQd03
         szDsKjH6W1VSKRvxtxzqBvFAftKjcnWUcWtxsqoFZwiSyQq7C1F62cDj3/bJu+yyWpSd
         xzK5hwXFV7H3LS4QZUZQHKfwp8VTSf+aDJoaUlaw42XWugoGCA1ebLpAZCLZ3IZtiaOx
         0bUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=TcZGIpZFtsXQnB9IM08ZO9Vrk1h6ZXgf7qgWlNa11hY=;
        b=F4x0zhTINI4XOGQzoWYDf8hnbH09/HDUmjCFTz/EDaiGdZHRhuSxFwbGfFv5/r2pWe
         Q1py+ZUNiADLOL963hKw2wQSqJvLMKBzpaYWcw/8BVu9rU1mVRa+UXAglEOR8GVldkA1
         M+wK2fPP6AISxAKyOty6crJ8P0e60LeZZaDljXjG+UdJ1qAUoSJAn/qITBx1QEpLqIHz
         wacjJk/LpSFrjHoUcNnfKuqbaHyaPxbMdwWajLEuTVK/Jug43CEKDG0IrujSht45+Taa
         6UzrYAErDW5mOHPQtJT+FkaGh2om4ZngZGVkgEGW+RbqgBOdm07BQ14wxCexSMU42nbz
         6IxA==
X-Gm-Message-State: AGi0PuYwRPCq59j691ZZKUn+yzZl1aYAZA9tgQS/D4/2gpEBNv4ZLM8Z
        FZRcewT2+w8zfl/gaS4CPNqTJCubC4Bbudtkud4=
X-Google-Smtp-Source: APiQypIe+DtLDZ6Yy6a7w+4neV8cfXmY7x+lCE8hWWOYcjUAAb0I8sPBi8KtcYImnj02TLzzvlScEeSl45FEjsLC5Z0=
X-Received: by 2002:a2e:4942:: with SMTP id b2mr8092892ljd.135.1586018127540;
 Sat, 04 Apr 2020 09:35:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200404141827.26255-1-ap420073@gmail.com> <20200404155040.GC1476305@kroah.com>
In-Reply-To: <20200404155040.GC1476305@kroah.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Sun, 5 Apr 2020 01:35:16 +0900
Message-ID: <CAMArcTX6j5bCLmLOcD13W8NkXtMHO-uouOnhnRAi4i5xdU+B3Q@mail.gmail.com>
Subject: Re: [PATCH net v2 1/3] class: add class_has_file_ns() helper function
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

On Sun, 5 Apr 2020 at 00:50, Greg KH <gregkh@linuxfoundation.org> wrote:
>

Hi Greg,
Thank you for your review!

> On Sat, Apr 04, 2020 at 02:18:27PM +0000, Taehee Yoo wrote:
> > The new helper function is to check whether the class file is existing
> > or not. This function will be used by networking stack to
> > check "/sys/class/net/*" file.
> >
> > Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
> > Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >
> > v1 -> v2:
> >  - Implement class_has_file_ns() instead of class_find_and_get_file_ns().
> >  - Change headline.
> >  - Add kernel documentation comment.
> >
> >  drivers/base/class.c         | 22 ++++++++++++++++++++++
> >  include/linux/device/class.h |  3 ++-
> >  2 files changed, 24 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/base/class.c b/drivers/base/class.c
> > index bcd410e6d70a..a2f2787f6aa7 100644
> > --- a/drivers/base/class.c
> > +++ b/drivers/base/class.c
> > @@ -105,6 +105,28 @@ void class_remove_file_ns(struct class *cls, const struct class_attribute *attr,
> >               sysfs_remove_file_ns(&cls->p->subsys.kobj, &attr->attr, ns);
> >  }
> >
> > +/**
> > + * class_has_file_ns - check whether file is existing or not
> > + * @cls: the compatibility class
> > + * @name: name to look for
> > + * @ns: the namespace tag to use
> > + */
> > +bool class_has_file_ns(struct class *cls, const char *name,
> > +                    const void *ns)
>
> Why would you use this?  And what happens if the file shows up, or goes
> away, instantly after this call is made?
>
> This feels very broken.
>

Ah, I missed considering other usescases.
If other users don't use locks, this function would return incorrect
information. The problem seems to become from that this function
calls kernfs_put().

Thanks a lot!
Taehee Yoo
