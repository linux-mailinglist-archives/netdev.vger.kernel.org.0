Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E58A711BCB9
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 20:15:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbfLKTPs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 14:15:48 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:42283 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbfLKTPr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 14:15:47 -0500
Received: by mail-lj1-f196.google.com with SMTP id e28so25300880ljo.9
        for <netdev@vger.kernel.org>; Wed, 11 Dec 2019 11:15:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=nJ/VWCmz71EpQ9QVZBA9BDeegL7NdVe7RbPuPTBMFb8=;
        b=KMPbSM+RTtQCtsZ+EOpry4KaHB4ciwutPzLElQIdeyKoETduWovwHScxT/XWI5rNvN
         eF7bdWi8ukAekR9UiOtDWXBw+13AjJXss6wLWJLlITQIca6enXWhk8Z9oTuHvmDNRSCZ
         MsSWmKHNJWGd5UqvLi20oamFGsHjUHwyXlblsKLoF5HalIwl56Hi+mQKOVjD0LNXmhkR
         LsGXS8DG8BAWJL2QtnArulm2UUhTH5R11Qb2aAJrxtHAxtXhjAJDHSKyMML/DK9fMQKc
         2qydHgUs66emUt7dHu1mgTHJSPh0qYK3nRjdUzOT2vpEOahACJXIG8fjtKsLq3WFmJ16
         PN+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=nJ/VWCmz71EpQ9QVZBA9BDeegL7NdVe7RbPuPTBMFb8=;
        b=FJil1Hy9Gpm6XGhKVCbs/+3CgzYqzg4GYHjZrdI88qRG0xDoNlfWeKvF6KtjIjdImb
         bW621p6Nn7fk+JQHnn9JvcESor5hGO0YelhXMWOk37eH7PyFAygagr72rGlZxkrnopui
         GBmeFOS/Q1gUoe4ALiKjgdWzuKy9ZmK8EcTWNYJSsF7UnzbWzZZX6RZSm6GBNYDm49C6
         ljI7XKBWbf0R3n/qX/SjkhlEaD1W9opmrP/SL5cNOBBlWlDepe9IgdJW352P+rwmkCaL
         xOHNbZZ1RuArVbi9Xee7J3In8ZBYyjKKxFgr5VIfdVI/HfxGRYt+K6+9AV9c3RRi3LJ/
         PwWA==
X-Gm-Message-State: APjAAAWncBhCaqemcMnRAs+Ytwtcu8uVjD47KuDmYVvL2ZawmBc4ePJc
        h44ZJvCBtHXG1W3oizPzqaYZqA==
X-Google-Smtp-Source: APXvYqxTp5F4Swjbm8LWzvdZAlAL3P4BSJ8wsGKdr885KWjVK5ejFjxkIeC6HYZfJ8GViWOP7UDDCg==
X-Received: by 2002:a2e:8613:: with SMTP id a19mr3268726lji.210.1576091745719;
        Wed, 11 Dec 2019 11:15:45 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id 138sm1689304lfa.76.2019.12.11.11.15.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 11:15:45 -0800 (PST)
Date:   Wed, 11 Dec 2019 11:15:37 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Yuval Avnery <yuvalav@mellanox.com>
Cc:     Jiri Pirko <jiri@mellanox.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] netdevsim: Add max_vfs to bus_dev
Message-ID: <20191211111537.416bf078@cakuba.netronome.com>
In-Reply-To: <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
References: <1576033133-18845-1-git-send-email-yuvalav@mellanox.com>
        <20191211095854.6cd860f1@cakuba.netronome.com>
        <AM6PR05MB514244DC6D25DDD433C0E238C55A0@AM6PR05MB5142.eurprd05.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Dec 2019 18:19:56 +0000, Yuval Avnery wrote:
> > On Wed, 11 Dec 2019 04:58:53 +0200, Yuval Avnery wrote:  
> > > Currently there is no limit to the number of VFs netdevsim can enable.
> > > In a real systems this value exist and used by driver.
> > > Fore example, Some features might need to consider this value when
> > > allocating memory.  
> > 
> > Thanks for the patch!
> > 
> > Can you shed a little bit more light on where it pops up? Just for my curiosity?  
> 
> Yes, like we described in the subdev threads.
> User should be able to configure some attributes before the VF was enabled.
> So all those (persistent) VF attributes should be available for query and configuration
> before VF was enabled.
> The driver can allocate an array according to max_vfs to hold all that data,
> like we do here in" vfconfigs".

I was after more practical reasoning, are you writing some tests for
subdev stuff that will depend on this change? :)

> > > Signed-off-by: Yuval Avnery <yuvalav@mellanox.com>
> > > Acked-by: Jiri Pirko <jiri@mellanox.com>  
> > >
> > > diff --git a/drivers/net/netdevsim/bus.c b/drivers/net/netdevsim/bus.c
> > > index 6aeed0c600f8..f1a0171080cb 100644
> > > --- a/drivers/net/netdevsim/bus.c
> > > +++ b/drivers/net/netdevsim/bus.c
> > > @@ -26,9 +26,9 @@ static struct nsim_bus_dev *to_nsim_bus_dev(struct
> > > device *dev)  static int nsim_bus_dev_vfs_enable(struct nsim_bus_dev  
> > *nsim_bus_dev,  
> > >  				   unsigned int num_vfs)
> > >  {
> > > -	nsim_bus_dev->vfconfigs = kcalloc(num_vfs,
> > > -					  sizeof(struct nsim_vf_config),
> > > -					  GFP_KERNEL);  
> > 
> > You're changing the semantics of the enable/disable as well now.
> > The old values used to be wiped when SR-IOV is disabled, now they will be
> > retained across disable/enable pair.
> > 
> > I think it'd be better if that wasn't the case. Users may expect a system to be
> > in the same state after they enable SR-IOV, regardless if someone else used
> > SR-IOV since last reboot.  
> 
> Right, 
> But some values should retain across enable/disable, for example MAC address which is persistent.
> So maybe we need to retain some values, while resetting others on disable?
> Would that work?

Mmm. That is a good question. For all practical purposes SR-IOV used 
to be local to the host that enables it until Smart/middle box NICs
emerged.

Perhaps the best way forward would be to reset the config that was set
via legacy APIs and keep only the MACs provisioned via persistent
devlink API?

So for now we'd memset, and once devlink API lands reset selectively?

> > Could you add a memset(,0,) here?
> >   
> > > +	if (nsim_bus_dev->max_vfs < num_vfs)
> > > +		return -ENOMEM;
> > > +
> > >  	if (!nsim_bus_dev->vfconfigs)
> > >  		return -ENOMEM;  
> > 
> > This check seems useless now, no? We will always have vfconfigs
