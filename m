Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2E0111BFC0
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 23:24:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726883AbfLKWYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 17:24:14 -0500
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38350 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726141AbfLKWYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 17:24:13 -0500
Received: by mail-lf1-f67.google.com with SMTP id r14so86214lfm.5
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 14:24:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nCoSE00vetFY6N24a0PBJQVBAX8gwJHe+ZxdD5MCb8c=;
        b=jr06c+uQyVdYk187Ce37yIfy0HQ3rOTtUOMy0ZA53H1mk/SpflTs1l6KtD0vNVrxCh
         XwT2xLdTP4bB0C5cVV51I3uEGvCjBwYUn2pPNpLrPpaIWdxMswi1EiDdjTEPtHFdYwWy
         OOl8JCFSgx7kvybHro+CXVQdC9qB6heELkI14TUS8a7ssF1o3Y417jr7Ne8A5DTdxEO7
         z6nJ5DwHhwVh+IKRVjgNUuVNVOZsyIE/UvIHsUfso/12F39tvA99ZJfSvPsaPJz4RDYM
         ydidlvQv9HLrjZ3IiC7iYnb8iuW/D55Itx6x65mqF60TGj3L/al3qIQGxij2qBoX5URp
         +Izw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nCoSE00vetFY6N24a0PBJQVBAX8gwJHe+ZxdD5MCb8c=;
        b=Jm/GLhR/yFqfSVC4tDtS6F6gxR4U09kinn2FNzDj/oFWI2rdjUpy3NUBEhn4Q/vskE
         6Xr6EKYKNldJcQmc3X/ahRU1rbbzdTSPjOd24gBhkPSXaBb/WnfCfVLFMSGX18VRB2t3
         R1Hj/ymsrK/aOqL6hoqkEQ8wkLLE1U723KSLwvhdBv/0LZANL71Hk4QbiFCn1t62Kkxz
         4k+376cG18A8V6y+eiZlKVsrji6XcR1+BMl9lZkYMOAq2DE7FelGD6njNvYTfQcIq3z9
         Z20MMWJ3PzOca9d9Vah9PRuqrHNuG4z6T2kdXghKFWhOisbDNjOPKSGkJ4yGO8WYDdY2
         RgdA==
X-Gm-Message-State: APjAAAVUEEUSlW9z/+DAZfdQZpC6ow6n9NsZ5LXz9SrFnki4DNrmHhlX
        tHY/+oA6OETVXbSOAqD5bwl+/Q==
X-Google-Smtp-Source: APXvYqwYgUs0AOyU357cM28/siG2F0/KsVT0sRIxpSk2JqpcsGHM9MYRc5najp5MEPgn3uqme+e8xg==
X-Received: by 2002:a05:6512:21d:: with SMTP id a29mr3843981lfo.186.1576103051489;
        Wed, 11 Dec 2019 14:24:11 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id m8sm1847115lfp.4.2019.12.11.14.24.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 14:24:11 -0800 (PST)
Date:   Wed, 11 Dec 2019 14:24:01 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Message-ID: <20191211142401.742189cf@cakuba.netronome.com>
In-Reply-To: <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
        <20191211111537.416bf078@cakuba.netronome.com>
        <AM6PR05MB5142CCAB9A06DAC199F7100CC55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 19:57:34 +0000, Yuval Avnery wrote:
> > -----Original Message-----
> > From: Jakub Kicinski <jakub.kicinski@netronome.com>
> > Sent: Wednesday, December 11, 2019 11:16 AM
> > To: Yuval Avnery <yuvalav@mellanox.com>
> > Cc: Jiri Pirko <jiri@mellanox.com>; davem@davemloft.net;
> > netdev@vger.kernel.org; linux-kernel@vger.kernel.org
> > Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
> > 
> > On Wed, 11 Dec 2019 18:19:56 +0000, Yuval Avnery wrote:  
> > > > On Wed, 11 Dec 2019 04:58:53 +0200, Yuval Avnery wrote:  
> > > > > Currently there is no limit to the number of VFs netdevsim can enable.
> > > > > In a real systems this value exist and used by driver.
> > > > > Fore example, Some features might need to consider this value when
> > > > > allocating memory.  
> > > >
> > > > Thanks for the patch!
> > > >
> > > > Can you shed a little bit more light on where it pops up? Just for my  
> > curiosity?  
> > >
> > > Yes, like we described in the subdev threads.
> > > User should be able to configure some attributes before the VF was  
> > enabled.  
> > > So all those (persistent) VF attributes should be available for query
> > > and configuration before VF was enabled.
> > > The driver can allocate an array according to max_vfs to hold all that
> > > data, like we do here in" vfconfigs".  
> > 
> > I was after more practical reasoning, are you writing some tests for subdev
> > stuff that will depend on this change? :)  
> 
> Yes we are writing tests for subdev with this.

Okay, please post v2 together with the tests. We don't accept netdevsim
features without tests any more.

> This is the way mlx5 works.. is that practical enough?
> 
> > > > > Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
> > > > > Acked-by: Jiri Pirko <jiri@mellanox.com>
> > > > >
> > > > > diff --git a/drivers/net/netdevsim/bus.c
> > > > > b/drivers/net/netdevsim/bus.c index 6aeed0c600f8..f1a0171080cb
> > > > > 100644
> > > > > --- a/drivers/net/netdevsim/bus.c
> > > > > +++ b/drivers/net/netdevsim/bus.c
> > > > > @@ -26,9 +26,9 @@ static struct nsim_bus_dev
> > > > > *to_nsim_bus_dev(struct device *dev)  static int
> > > > > nsim_bus_dev_vfs_enable(struct nsim_bus_dev  
> > > > *nsim_bus_dev,  
> > > > >  				   unsigned int num_vfs)
> > > > >  {
> > > > > -	nsim_bus_dev->vfconfigs = kcalloc(num_vfs,
> > > > > -					  sizeof(struct nsim_vf_config),
> > > > > -					  GFP_KERNEL);  
> > > >
> > > > You're changing the semantics of the enable/disable as well now.
> > > > The old values used to be wiped when SR-IOV is disabled, now they
> > > > will be retained across disable/enable pair.
> > > >
> > > > I think it'd be better if that wasn't the case. Users may expect a
> > > > system to be in the same state after they enable SR-IOV, regardless
> > > > if someone else used SR-IOV since last reboot.  
> > >
> > > Right,
> > > But some values should retain across enable/disable, for example MAC  
> > address which is persistent.  
> > > So maybe we need to retain some values, while resetting others on  
> > disable?  
> > > Would that work?  
> > 
> > Mmm. That is a good question. For all practical purposes SR-IOV used to be
> > local to the host that enables it until Smart/middle box NICs emerged.
> > 
> > Perhaps the best way forward would be to reset the config that was set via
> > legacy APIs and keep only the MACs provisioned via persistent devlink API?
> > 
> > So for now we'd memset, and once devlink API lands reset selectively?  
> 
> Legacy is also persistent.
> Currently when you set mac address with "ip link vf set mac" it is persistent (at least in mlx5).

"Currently in mlx5" - maybe, but this is netdevsim. Currently it clears
the config on re-enable which I believe to be preferable as explained
before.

> But ip link only exposes enabled VFS, so driver on VF has to reload to acquire this MAC.
> With devlink subdev it will be possible to set the MAC before VF was enabled.

Yup, sure. As I said, once subdev is implemented, we will treat the
addresses set by it differently. Those are inherently persistent or
rather their life time is independent of just the SR-IOV host.

> I think we need to distinguish here between:
> - PF sets MAC to a VF - persistent.
> - VF sets MAC to itself - not persistent.
> 
> But is the second case relevant in netdevsim?

Not sure where you're going with this. Second case, i.e. if VF sets its
MAC, is not exposed in the hypervisor. I think iproute2 should still
list the MAC it provisioned, or 00:00.. if unset.

The two cases I'm differentiating is reset behaviour for addresses set
via PF vs via devlink.

> > > > Could you add a memset(,0,) here?
> > > >  
> > > > > +	if (nsim_bus_dev->max_vfs < num_vfs)
> > > > > +		return -ENOMEM;
> > > > > +
> > > > >  	if (!nsim_bus_dev->vfconfigs)
> > > > >  		return -ENOMEM;  
> > > >
> > > > This check seems useless now, no? We will always have vfconfigs  
