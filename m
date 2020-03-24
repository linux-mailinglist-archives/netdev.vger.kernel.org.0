Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68D56191667
	for <lists+netdev@lfdr.de>; Tue, 24 Mar 2020 17:28:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728718AbgCXQ2d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Mar 2020 12:28:33 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:39762 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728534AbgCXQ2d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 24 Mar 2020 12:28:33 -0400
Received: by mail-lj1-f195.google.com with SMTP id i20so7195954ljn.6;
        Tue, 24 Mar 2020 09:28:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=F4RDqLUZsSxRiEPC5uE5/znG8mVAMvfJqVjLtVuPTYI=;
        b=LuLLrr4er+BSGhKQjssI8NHtdlFNa4e25P6w8rHTsubuRQi9V8BqJQzt40rl89NpJi
         TUFxBSyW6blqX9rxpUa8KALUUkOoERwYy5okleCaFKiPS0eQF8mhZD9ELr4U2+vm0XX4
         zklFKOFjLfGXBjbaY4siIbb7tsK0BeShh2w9R9D2j4oRvUrlLNo5C+7cH4FfYF7qeTuo
         kWZlk5UGv8ZOZ7Uf+O9C0DnHXMpMwb52fs0BZ91dCysjWGpBPMMSB5X89iAYaUNt09Vd
         /ORqgTrpH2BznN/YlN+4p0bojHgjD4pZuFa+J9wq1OISsSbwcln0MlvDPICDXdRFXC0R
         P0bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=F4RDqLUZsSxRiEPC5uE5/znG8mVAMvfJqVjLtVuPTYI=;
        b=Rqdc2w2j1wuV8UklJAjDa2LslBNdS0HeYJNOI6fyCHLa4U7m83ckokXSgKufpl83UL
         qU6dGxlXjZjT3JVxUuHMYr+e2GDLCBQ+w0J+saKHZhJ0HbKLy8wPTouBcRZRF4n7kp3j
         KjVHN/DS2AnF28vHScrukt7bHo2/DV9eLojDlPofpmZe7cn9eKUFciuWisTgVNlE/A7b
         nLB9K3idOIG+zo3khqEV7u1U4n/FexIIrFeeW4fbz2Es1mO3YIJORL01/seaVFU8nhRP
         f1zUd4mH/a3byPPYm2xP8X8xp+DHHQ7J0QeSQZEDvaxeObvb3osT1XnxXtz0N3Y3rdD1
         LMWg==
X-Gm-Message-State: ANhLgQ2wdz185UIvCj5xLr/zhgqIC2qTBnt6iL1dlEf6WrV49gvJIo0w
        zn3XdC7SHduja0IF7yLZ5FUMYp606quljsGfhaA=
X-Google-Smtp-Source: ADFU+vv3dG23NpLsI31feEsoXfT8VQ+G9TfKP8XIgS8J/aJehLJHzaIF4s5x+DNyat0Dt1V6dnQNgBL+w6VWcAfNkJM=
X-Received: by 2002:a2e:9949:: with SMTP id r9mr18249406ljj.135.1585067309896;
 Tue, 24 Mar 2020 09:28:29 -0700 (PDT)
MIME-Version: 1.0
References: <20200324141722.21308-1-ap420073@gmail.com> <20200324154449.GC2513347@kroah.com>
In-Reply-To: <20200324154449.GC2513347@kroah.com>
From:   Taehee Yoo <ap420073@gmail.com>
Date:   Wed, 25 Mar 2020 01:28:18 +0900
Message-ID: <CAMArcTVhqxgZ1X+TgruDSGPEXbZS0M86h6y-4WAB8z8OOSgLzg@mail.gmail.com>
Subject: Re: [PATCH RESEND net 1/3] class: add class_find_and_get_file_ns()
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

On Wed, 25 Mar 2020 at 00:44, Greg KH <gregkh@linuxfoundation.org> wrote:
>

Hi Greg,
Thank you for the review!

> On Tue, Mar 24, 2020 at 02:17:22PM +0000, Taehee Yoo wrote:
> > The new helper function is to find and get a class file.
> > This function is useful for checking whether the class file is existing
> > or not. This function will be used by networking stack to
> > check "/sys/class/net/*" file.
> >
> > Reported-by: syzbot+830c6dbfc71edc4f0b8f@syzkaller.appspotmail.com
> > Fixes: b76cdba9cdb2 ("[PATCH] bonding: add sysfs functionality to bonding (large)")
> > Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> > ---
> >  drivers/base/class.c         | 12 ++++++++++++
> >  include/linux/device/class.h |  4 +++-
> >  2 files changed, 15 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/base/class.c b/drivers/base/class.c
> > index bcd410e6d70a..dedf41f32f0d 100644
> > --- a/drivers/base/class.c
> > +++ b/drivers/base/class.c
> > @@ -105,6 +105,17 @@ void class_remove_file_ns(struct class *cls, const struct class_attribute *attr,
> >               sysfs_remove_file_ns(&cls->p->subsys.kobj, &attr->attr, ns);
> >  }
> >
> > +struct kernfs_node *class_find_and_get_file_ns(struct class *cls,
> > +                                            const char *name,
> > +                                            const void *ns)
> > +{
> > +     struct kernfs_node *kn = NULL;
> > +
> > +     if (cls)
> > +             kn = kernfs_find_and_get_ns(cls->p->subsys.kobj.sd, name, ns);
> > +     return kn;
> > +}
> > +
>
> You can put the EXPORT_SYMBOL_GPL() under here.
>

Okay, I will change this.

> And can you document what this function actually is in some kerneldoc?
>

Thanks, I will add some kernel-doc comment.

> But, returning a kernfs_node from a driver core is _REALLY_ odd.  Why do
> you need this and who cares about kernfs here?
>

I fully agree with that.
My previous version of this function was here:

bool class_has_file_ns(struct class *cls, const char *name,
                       const void *ns)
{
        struct kernfs_node *kn = NULL;

        if (cls) {
                kn = kernfs_find_and_get_ns(cls->p->subsys.kobj.sd, name, ns);
                if (kn) {
                        kernfs_put(kn);
                        return true;
                }
        }
        return false;
}

I wanted this function could be used in general cases.
But I thought this function couldn't be used in general cases.
So, I made class_find_and_get_file_ns() but I couldn't find
a more appropriate return type.
I think I'd rather to use class_has_file_ns() instead of
class_find_and_get_file_ns() because of an awkward return type.
How do you think about it?

> thanks,
>
> greg k-h

Thanks a lot,
Taehee Yoo
