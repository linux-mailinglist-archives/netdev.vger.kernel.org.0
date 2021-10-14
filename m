Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6897A42E322
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 23:12:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbhJNVOp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 17:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230094AbhJNVOp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Oct 2021 17:14:45 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB80EC061570;
        Thu, 14 Oct 2021 14:12:39 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id x27so32820822lfu.5;
        Thu, 14 Oct 2021 14:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UoqITOtfRIWnu7sS5eeVp0vzN+xmG9mZclxBq7/994U=;
        b=aXEDE4r8cYNd6JzJ+R1Kwa1UOlTUOo+Qd2ORae9HifJM80ygKB+jVElS8kASEzTnP8
         cgkuXtDHSBj8m+PWmljgJsq/FFY7gV6aXOFYTXOMaN29c3EUWblcNQPF5M4Nmt9h9vSw
         GYBYZ+sPg5tMI7TtIj5yzvnCLYwW10ntuVJkFqRp1RrV44yS9wlORMUpWpxtre8LsZf5
         U6SZmnmxCdLBDqBvW9qJ1yGCy+6pao03BtnG7XH0dZhyf2UWBybRUE7BDLv7qIcts29Q
         35ysaS+evW6apVrptrxsj7p1MOr31avEWe/64kEXLBL1Tjm0ke8bP5tN9LG8GUqFsBNn
         rcuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UoqITOtfRIWnu7sS5eeVp0vzN+xmG9mZclxBq7/994U=;
        b=KuWL7SS2XfEuoqg8XhqYh2VEMSKWoIvk7xiRb8/ySaaKUijklS/Xn/FXMTlJ1cWr89
         TEFnehUZOUyKX1YMobLd3vbNZHRUY/hrF0RbRDPCvDa2QJqp5Or1PwIaa0piDkxseWOc
         V4+uZZcDLkrzWnVHC2t/8n1mMXfLYNX/gStqu4T+5YzGLcD3m59wT4L/jIYMExvxBOQj
         uTJHe4MLHTEEEPsp7sUplnHd5RFR9Z5Qny8PrRLAhvmFh3vQC4LMwxlMskLSai5Vwi9c
         G0renF8fN/naIKT20wk73y/g4gcXPWOgT2W77wIk9gjUBcflMIlTl5mx+OrIXPLo0Rta
         Emiw==
X-Gm-Message-State: AOAM533x0vDLuNqqiuTrq3dBqqaoTKQcHIeWnWJj/g+ZHh8u5ubV5CLp
        R/5M1NyDh1rJzK2wClaWbr8Ehw8yrEh17G7j71M=
X-Google-Smtp-Source: ABdhPJzw8bDlIGNfl/O/swR1Vuv6buOkWuKo39YXtyR/hRaB3n6KGl7c16vwdl1f1ImBxEWAzx/roEvblFwUUdN42SY=
X-Received: by 2002:a2e:2f13:: with SMTP id v19mr8852385ljv.302.1634245958097;
 Thu, 14 Oct 2021 14:12:38 -0700 (PDT)
MIME-Version: 1.0
References: <20210928194727.1635106-1-cpp.code.lv@gmail.com>
 <20210928174853.06fe8e66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <d1e5b178-47f5-9791-73e9-0c1f805b0fca@6wind.com> <20210929061909.59c94eff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <CAASuNyVe8z1R6xyCfSAxZbcrL3dej1n8TXXkqS-e8QvA6eWd+w@mail.gmail.com>
 <b091ef39-dc29-8362-4d31-0a9cc498e8ea@6wind.com> <CAASuNyW81zpSu+FGSDuUrOsyqJj7SokZtvX081BbeXi0ARBaYg@mail.gmail.com>
 <a4894aef-b82a-8224-611d-07be229f5ebe@6wind.com>
In-Reply-To: <a4894aef-b82a-8224-611d-07be229f5ebe@6wind.com>
From:   Cpp Code <cpp.code.lv@gmail.com>
Date:   Thu, 14 Oct 2021 14:12:27 -0700
Message-ID: <CAASuNyUWP2HQLhGf29is3fG2+uG8SqOFoXHeHf-vC6HYJ1Wb7g@mail.gmail.com>
Subject: Re: [PATCH net-next v6] net: openvswitch: IPv6: Add IPv6 extension
 header support
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        pshelar@ovn.org, "David S. Miller" <davem@davemloft.net>,
        ovs dev <dev@openvswitch.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 4, 2021 at 11:41 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 01/10/2021 =C3=A0 22:42, Cpp Code a =C3=A9crit :
> > On Fri, Oct 1, 2021 at 12:21 AM Nicolas Dichtel
> > <nicolas.dichtel@6wind.com> wrote:
> >>
> >> Le 30/09/2021 =C3=A0 18:11, Cpp Code a =C3=A9crit :
> >>> On Wed, Sep 29, 2021 at 6:19 AM Jakub Kicinski <kuba@kernel.org> wrot=
e:
> >>>>
> >>>> On Wed, 29 Sep 2021 08:19:05 +0200 Nicolas Dichtel wrote:
> >>>>>> /* Insert a kernel only KEY_ATTR */
> >>>>>> #define OVS_KEY_ATTR_TUNNEL_INFO    __OVS_KEY_ATTR_MAX
> >>>>>> #undef OVS_KEY_ATTR_MAX
> >>>>>> #define OVS_KEY_ATTR_MAX            __OVS_KEY_ATTR_MAX
> >>>>> Following the other thread [1], this will break if a new app runs o=
ver an old
> >>>>> kernel.
> >>>>
> >>>> Good point.
> >>>>
> >>>>> Why not simply expose this attribute to userspace and throw an erro=
r if a
> >>>>> userspace app uses it?
> >>>>
> >>>> Does it matter if it's exposed or not? Either way the parsing policy
> >>>> for attrs coming from user space should have a reject for the value.
> >>>> (I say that not having looked at the code, so maybe I shouldn't...)
> >>>
> >>> To remove some confusion, there are some architectural nuances if we
> >>> want to extend code without large refactor.
> >>> The ovs_key_attr is defined only in kernel side. Userspace side is
> >>> generated from this file. As well the code can be built without kerne=
l
> >>> modules.
> >>> The code inside OVS repository and net-next is not identical, but I
> >>> try to keep some consistency.
> >> I didn't get why OVS_KEY_ATTR_TUNNEL_INFO cannot be exposed to userspa=
ce.
> >
> > OVS_KEY_ATTR_TUNNEL_INFO is compressed version of OVS_KEY_ATTR_TUNNEL
> > and for clarity purposes its not exposed to userspace as it will never
> > use it.
> > I would say it's a coding style as it would not brake anything if expos=
ed.
> In fact, it's the best way to keep the compatibility in the long term.
> You can define it like this:
> OVS_KEY_ATTR_TUNNEL_INFO,  /* struct ip_tunnel_info, reserved for kernel =
use */
>
> >
> >>
> >>>
> >>> JFYI This is the file responsible for generating userspace part:
> >>> https://github.com/openvswitch/ovs/blob/master/build-aux/extract-odp-=
netlink-h
> >>> This is the how corresponding file for ovs_key_attr looks inside OVS:
> >>> https://github.com/openvswitch/ovs/blob/master/datapath/linux/compat/=
include/linux/openvswitch.h
> >>> one can see there are more values than in net-next version.
> >> There are still some '#ifdef __KERNEL__'. The standard 'make headers_i=
nstall'
> >> filters them. Why not using this standard mechanism?
> >
> > Could you elaborate on this, I don't quite understand the idea!? Which
> > ifdef you are referring, the one along OVS_KEY_ATTR_TUNNEL_INFO or
> > some other?
> My understanding is that this file is used for the userland third party, =
thus,
> theoretically, there should be no '#ifdef __KERNEL__'. uapi headers gener=
ated
> with 'make headers_install' are filtered to remove them.

From https://lwn.net/Articles/507794/ I understand that is the goal,
but this part of the code is still used in the kernel part.

>
> >
> >>
> >> In this file, there are two attributes (OVS_KEY_ATTR_PACKET_TYPE and
> >> OVS_KEY_ATTR_ND_EXTENSIONS) that doesn't exist in the kernel.
> >> This will also breaks if an old app runs over a new kernel. I don't se=
e how it
> >> is possible to keep the compat between {old|new} {kernel|app}.
> >
> > Looks like this most likely is a bug while working on multiple
> > versions of code.  Need to do add more padding.
> As said above, just define the same uapi for everybody and the problem is=
 gone
> forever.
>

As this part of the code was already there, I think the correct way
would be to refactor that in a separate commit if necessary.

>
> Regards,
> Nicolas

Best,
Tom
