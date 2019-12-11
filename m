Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 96BF511C0CC
	for <lists+netdev@lfdr.de>; Thu, 12 Dec 2019 00:50:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727166AbfLKXuE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 18:50:04 -0500
Received: from mail-lf1-f68.google.com ([209.85.167.68]:46230 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726989AbfLKXuE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 18:50:04 -0500
Received: by mail-lf1-f68.google.com with SMTP id f15so187166lfl.13
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 15:50:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=3ar8hSRxaWEDYYcaZhXo4D+jXpzHyiQxdbvMX4+sxbw=;
        b=J+3gOEj9//BN+ky7TtDHfiFUhcWKKXu2q0p6enY7O+oXtkHhmLpg6Ex0ksSgm9rXw9
         XUrVXLA1pS1Ifvi4qYIcqrMyHqRuwn3Ag46LEv62xxqIMCGnIMq+XrBZVuJN7HRW+X+9
         i4FYhYcEVv+GB6LUDzvvpD5yFvgzrpVf0dxGuLqLkHwitL1PaY7ScPRB2ztP3o8McMuJ
         AQMJuSVv8zBpVHFid1m/jyrbbxkxmW/eYqkaYFtUzjaY3ypVTu4XYti4SwFBJGCkrUQ9
         Uh5eKXayjbTimhfZ9/lHUWch1Oq97UNT5h1AE613YkuVJhsV2vo79d6KmdsLRFsxLnRw
         kowA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=3ar8hSRxaWEDYYcaZhXo4D+jXpzHyiQxdbvMX4+sxbw=;
        b=X+yocWfcjeTHEq+IfIgzP4PpRsgy9CXrOG8PgluhCrAREjGPvQYtTCV8A6o4NuLt5A
         Ryksms0VwTF8t1qB7yDCUHbXzN1MBxY+y9NbAlhzkmp1wBuev1HHXVVC+XcKGF3e8IFp
         82xG4KQ7ec8uII6O/KNNrMg4fU676E4Yx/1AbvKhPlaZEc7hsbAZSGDhLx8VMcOVWarm
         RwfjEHsywcV07kQ+eQwQhcYdL7ctbZrHwWUFsUfQUI4MQjpx0bK165FL5LBWyS3EjjPC
         ePoM58SXoeI+8AI35OA7rz9h3LrRzLQ1ELlnGgUH86w1c9RqAS6oNSlkcwu+0o+hMNFc
         0H/g==
X-Gm-Message-State: APjAAAVyBNrtRbIhbO6O+P95wpy05ByXrhICL8nd77R07lYetJsrjby/
        m4XijvDkaWc56NXqs3raEkjLlQ==
X-Google-Smtp-Source: APXvYqxLBlm2lDvETlbo6tR3SMfMEiRwEcggIuyy2hd+tE015YJ2jzRHZ0h2rdzwNuMk3KFs/l7V0Q==
X-Received: by 2002:a19:784:: with SMTP id 126mr3803119lfh.191.1576108200961;
        Wed, 11 Dec 2019 15:50:00 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 192sm1928868lfh.28.2019.12.11.15.49.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 15:50:00 -0800 (PST)
Date:   Wed, 11 Dec 2019 15:49:52 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Message-ID: <20191211154952.50109494@cakuba.netronome.com>
In-Reply-To: <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211111537.416bf078@cakuba.netronome.com>
        <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211142401.742189cf@cakuba.netronome.com>
        <AM6PR05MB51423D365FB5A8DB22B1DE62C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 23:25:09 +0000, Yuval Avnery wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Sent: Wednesday, December 11, 2019 2:24 PM
> > To: Yuval Avnery <yuvalav@mellanox.com>
> > Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
> > 
> > On Wed, 11 Dec 2019 19:57:34 +0000, Yuval Avnery wrote:  
> > > > -----Original Message-----
> > > > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > > > Sent: Wednesday, December 11, 2019 11:16 AM
> > > > To: Yuval Avnery <yuvalav@mellanox.com>
> > > > Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> > > > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > > > Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
> > > >
> > > > On Wed, 11 Dec 2019 18:19:56 +0000, Yuval Avnery wrote:  
> > > > > > On Wed, 11 Dec 2019 04:58:53 +0200, Yuval Avnery wrote:  
> > > > > > > Currently there is no limit to the number of VFs netdevsim can enable.  
> > > > > > > In a real systems this value exist and used by driver.
> > > > > > > Fore example, Some features might need to consider this value
> > > > > > > when allocating memory.  
> > > > > >
> > > > > > Thanks for the patch!
> > > > > >
> > > > > > Can you shed a little bit more light on where it pops up? Just
> > > > > > for my  
> > > > curiosity?  
> > > > >
> > > > > Yes, like we described in the subdev threads.
> > > > > User should be able to configure some attributes before the VF was  
> > > > enabled.  
> > > > > So all those (persistent) VF attributes should be available for
> > > > > query and configuration before VF was enabled.
> > > > > The driver can allocate an array according to max_vfs to hold all
> > > > > that data, like we do here in" vfconfigs".  
> > > >
> > > > I was after more practical reasoning, are you writing some tests for
> > > > subdev stuff that will depend on this change? :)  
> > >
> > > Yes we are writing tests for subdev with this.  
> > 
> > Okay, please post v2 together with the tests. We don't accept netdevsim
> > features without tests any more.  
> 
> I think the only test I can currently write is the enable SR-IOV max_vfs enforcement.
> Because subdev is not in yet.
> Will that be good enough?

It'd be good to test some netdev API rather than just the enforcement
itself which is entirely in netdevsim, I think.

So max_vfs enforcement plus checking that ip link lists the correct
number of entries (and perhaps the entries are in reset state after
enable) would do IMO.

> > > This is the way mlx5 works.. is that practical enough?
> > >  
> > > > > > > Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
> > > > > > > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > > > > > >
> > > > > > > diff --git a/drivers/net/netdevsim/bus.c
> > > > > > > b/drivers/net/netdevsim/bus.c index 6aeed0c600f8..f1a0171080cb
> > > > > > > 100644
> > > > > > > --- a/drivers/net/netdevsim/bus.c
> > > > > > > +++ b/drivers/net/netdevsim/bus.c
> > > > > > > @@ -26,9 +26,9 @@ static struct nsim_bus_dev
> > > > > > > *to_nsim_bus_dev(struct device *dev)  static int
> > > > > > > nsim_bus_dev_vfs_enable(struct nsim_bus_dev  
> > > > > > *nsim_bus_dev,  
> > > > > > >  				   unsigned int num_vfs)
> > > > > > >  {
> > > > > > > -	nsim_bus_dev->vfconfigs = kcalloc(num_vfs,
> > > > > > > -					  sizeof(struct  
> > nsim_vf_config),  
> > > > > > > -					  GFP_KERNEL);  
> > > > > >
> > > > > > You're changing the semantics of the enable/disable as well now.
> > > > > > The old values used to be wiped when SR-IOV is disabled, now
> > > > > > they will be retained across disable/enable pair.
> > > > > >
> > > > > > I think it'd be better if that wasn't the case. Users may expect
> > > > > > a system to be in the same state after they enable SR-IOV,
> > > > > > regardless if someone else used SR-IOV since last reboot.  
> > > > >
> > > > > Right,
> > > > > But some values should retain across enable/disable, for example
> > > > > MAC  
> > > > address which is persistent.  
> > > > > So maybe we need to retain some values, while resetting others on  
> > > > disable?  
> > > > > Would that work?  
> > > >
> > > > Mmm. That is a good question. For all practical purposes SR-IOV used
> > > > to be local to the host that enables it until Smart/middle box NICs  
> > emerged.  
> > > >
> > > > Perhaps the best way forward would be to reset the config that was
> > > > set via legacy APIs and keep only the MACs provisioned via persistent  
> > devlink API?  
> > > >
> > > > So for now we'd memset, and once devlink API lands reset selectively?  
> > >
> > > Legacy is also persistent.
> > > Currently when you set mac address with "ip link vf set mac" it is persistent  
> > (at least in mlx5).
> > 
> > "Currently in mlx5" - maybe, but this is netdevsim. Currently it clears the
> > config on re-enable which I believe to be preferable as explained before.
> >   
> > > But ip link only exposes enabled VFS, so driver on VF has to reload to  
> > acquire this MAC.  
> > > With devlink subdev it will be possible to set the MAC before VF was  
> > enabled.
> > 
> > Yup, sure. As I said, once subdev is implemented, we will treat the addresses
> > set by it differently. Those are inherently persistent or rather their life time is
> > independent of just the SR-IOV host.  
> 
> Ok, got it.
> I am just wondering how this works when you have "ip link" and devlink setting the MAC independently.
> Will they show the same MAC?
> Or ip link will show the non-persistent MAC And devlink the persistent?

My knee jerk reaction is that we should populate the values to those set
via devlink upon SR-IOV enable, but then if user overwrites those values
that's their problem.

Sort of mirror how VF MAC addrs work, just a level deeper. The VF
defaults to the MAC addr provided by the PF after reset, but it can
change it to something else (things may stop working because spoof
check etc. will drop all its frames, but nothing stops the VF in legacy
HW from writing its MAC addr register).

IOW the devlink addr is the default/provisioned addr, not necessarily
the addr the PF has set _now_.

Other options I guess are (a) reject the changes of the address from
the PF once devlink has set a value; (b) provide some device->control
CPU notifier which can ack/reject a request from the PF to change
devlink's value..?

You guys posted the devlink patches a while ago, what was your
implementation doing?
