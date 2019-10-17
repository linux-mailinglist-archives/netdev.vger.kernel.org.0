Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6BD70DA47C
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 06:10:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392242AbfJQEKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 00:10:20 -0400
Received: from mail-ed1-f42.google.com ([209.85.208.42]:34073 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726982AbfJQEKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 00:10:19 -0400
Received: by mail-ed1-f42.google.com with SMTP id j8so573861eds.1
        for <netdev@vger.kernel.org>; Wed, 16 Oct 2019 21:10:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=W7+mMd07QQJd8UgLyD1KwD/q5N7onv9q9No08G+KUnI=;
        b=N2vzlJhcjF5BWDAJ+YjBM262MTgA528w8V7+VHtpKNCsHwKtognA1a0hYC7tHq/BsU
         jalXWtDj40unH25fytiD1ZexCqfn+ieP0P/31YxX++0p7JtQ3rMltxhIQZiN8CjICPUy
         HCiylt4naxZpSbNsdQhpF++DE41QW2tb107Qc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=W7+mMd07QQJd8UgLyD1KwD/q5N7onv9q9No08G+KUnI=;
        b=TSNh2DdfVKip6Xt29NodRkySLAxTZN3qN5ufovP+JeHFdWRaOTQD8MgEjZ/UEfkvAT
         hVQKTMdvQycD9BaMOqzdyk/OM8uuOr22Swn78qOTXEaPgp1amIsBoG21JJW8rch9mw59
         wx2d4IHHKL7tXFnTVCuPoG06s121/Flny4Z66VDYkyrqqo7tUNA1haNvTkNxvxyJ4vrc
         UzevdfGfydJXfjXHcmNc5zyOaQ4TRBobqjJT2MzbYv6eJwm5i/2TgI0CyWtDwBh22u5s
         azrDk+Wu7YDnDXRQi0FoDHwYp+DfD+NJmDlkcE/RLzL6SafD4J80S2aG6Nu1WPh3c91S
         C7IA==
X-Gm-Message-State: APjAAAVgZV4PzP1bxcJsFIzhr558XA9wmK6aeM8kd6U3XQSRPKqqYO9m
        /QiT8eGHkGYQWt2mNdYn903mpJJ5evR6caIvGSz7gg==
X-Google-Smtp-Source: APXvYqyGyfakKJFS3qRfEkQO3UG0tSmeZTUcVFIXifswlu9i/foM6JC3GaUe7Qfrhdhwcb+splajtJrRsp8MMATIRg4=
X-Received: by 2002:a17:906:7e17:: with SMTP id e23mr1597332ejr.205.1571285417202;
 Wed, 16 Oct 2019 21:10:17 -0700 (PDT)
MIME-Version: 1.0
References: <CAFLxGvwnOi6dSq5yLM78XskweQOY6aPbRt==G9wv5qS+dfj8bw@mail.gmail.com>
 <3A7BDEE0-7C07-4F23-BA01-F32AD41451BB@cumulusnetworks.com>
 <5A4A5745-5ADC-4AAC-B060-1BC9907C153C@cumulusnetworks.com>
 <CAJieiUi-b5vcOTGqXcDpn9fxVwA9jyoMWEDM2F_ZgVfzdgFgeA@mail.gmail.com> <910194713.25283.1571260614731.JavaMail.zimbra@nod.at>
In-Reply-To: <910194713.25283.1571260614731.JavaMail.zimbra@nod.at>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Wed, 16 Oct 2019 21:10:06 -0700
Message-ID: <CAJieiUjvamKds6+hbsKhwCJ_MDC9_9Wfy8ogyB1f3OrSgXKC6w@mail.gmail.com>
Subject: Re: Bridge port userspace events broken?
To:     Richard Weinberger <richard@nod.at>
Cc:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        Richard Weinberger <richard.weinberger@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        bridge@lists.linux-foundation.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 16, 2019 at 2:16 PM Richard Weinberger <richard@nod.at> wrote:
>
> Roopa, Nikolay,
>
> ----- Urspr=C3=BCngliche Mail -----
> > +1,  this can be fixed....but in general all new bridge and link
> > attributes have better support with netlink.
> > In this case its IFLA_BRPORT_GROUP_FWD_MASK link attribute available
> > via ip monitor or bridge monitor.
> > you probably cannot use it with udev today.
> >
> > For the future, I think having udev listen to netlink link and devlink
> > events would make sense (Not sure if anybody is working on it).
> > AFAIK the sysfs uevent mechanism for link attributes don't  receive
> > the required attention and testing like the equivalent netlink events.
>
> I understand that netlink works best for you but sysfs notifications are =
still
> useful.
> Please let me explain my use case a little bit more.
>
> The application I work on operates on network interfaces, in this case th=
e
> interface happens to be a bridge.
> systemd-networkd sets up the bridge as soon all slave interfaces emerge.
>
> Therefore the systemd service file of the application depends on the brid=
ge.
> i.e.
> Requires=3Dsys-subsystem-net-devices-br0.device
>

interesting. We do have a lot of applications that depend on network
interfaces and we
 simply make them depend on the networking service eg with
"After=3Dnetworking.service".

we don't use systemd-networkd today..but our network interface
management software (https://packages.debian.org/buster/ifupdown2)
registers itself as  networking.service. For unsupported options the
network interface manager provides hooks to invoke pre and post
commands
which takes care of the unsupported attributes case you mention above.
In absence of that, we would probably use systemd ExecStartPost


> In one specific setup the bridge needs to forward more than usual and
> group_fwd_mask needs to be altered. Sadly this is nothing systemd-network=
d
> can do right now, so I added the following line to the service file of
> the application:
> ExecStartPre=3D/bin/bash -c "echo 0xfffd > /sys/class/net/eth0/brport/gro=
up_fwd_mask"

ok, yeah the right thing here will be for your network manager
(systemd-networkd)  to support this config attribute.

But understand that there will always be an attribute that your
network interface manager does not support :)

>
> Here comes the problem, the unit is activated as soon br0 is created but
> at this time eth0 is sometimes not yet a slave or br0. It takes some time=
.
>
> So I need a way to model this dependency in a systemd environment.
> A common approach to do so is setting up an udev rule which set a systemd=
 notify
> as soon a specific sysfs file arrives.

That is cleaver. But, you now have systemd-networkd and udevd to get
your interfaces configured right.
You may be able to get past this for now to find more problems later.

>
> Teaching the application to listen for bridge specific netlink messages i=
s
> another possible approach but seems overkill to me.

understood. In your case, the ideal thing to do is have all your
configuration done via systemd-networkd.
that will also make sure your config persists in a single place.
Agreed that having your application understand netlink to just deal
with this attribute is overkill.

> Or maybe there is some nice wrapper/helper?

There are many netlink libraries from libnl, python-nlmanager, pyroute2 etc

>
> It would be nice to have sysfs notifications for bridge devices too.
> I can understand that not everyone likes this approach but this is the wa=
y
> how *many* systems out there work these day. Actually almost any (embedde=
d)
> system with systemd.
>

I think if you are using systemd, systemd-networkd which uses netlink
is the best
option to deal with interface link events.

Regardless, for existing bridge sysfs attribute files, Nikolay might
have a solution after he is back from vacation.
This should help your  immediate problem with group_fwd_mask.
