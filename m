Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6024427F611
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 01:38:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbgI3Xi0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Sep 2020 19:38:26 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:37042 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730424AbgI3Xi0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Sep 2020 19:38:26 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNlft-00Gyr6-GU; Thu, 01 Oct 2020 01:38:17 +0200
Date:   Thu, 1 Oct 2020 01:38:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Johannes Berg <johannes@sipsolutions.net>,
        Jiri Pirko <jiri@resnulli.us>,
        Michal Kubecek <mkubecek@suse.cz>, dsahern@kernel.org,
        pablo@netfilter.org, netdev@vger.kernel.org
Subject: Re: Genetlink per cmd policies
Message-ID: <20200930233817.GA3996795@lunn.ch>
References: <a772c03bfbc8cf8230df631fe2db6f2dd7b96a2a.camel@sipsolutions.net>
 <20200930094455.668b6bff@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <23b4d301ee35380ac21c898c04baed9643bd3651.camel@sipsolutions.net>
 <20200930120129.620a49f0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <563a2334a42cc5f33089c2bff172d92e118575ea.camel@sipsolutions.net>
 <20200930121404.221033a3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <c161e922491c1a2330dcef6741a8cfa7f92999be.camel@sipsolutions.net>
 <20200930124612.32b53118@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <48868126b563b1602093f6210ed957d7ed880584.camel@sipsolutions.net>
 <20200930134734.27bba000@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930134734.27bba000@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > +static void genl_op_from_full(const struct genl_family *family,
> > > +			      unsigned int i, struct genl_ops *op)
> > > +{
> > > +	memcpy(op, &family->ops[i], sizeof(*op));  
> > 
> > What's wrong with struct assignment? :)
> > 
> > 	*op = family->ops[i];
> 
> Code size :)
> 
>    text	   data	    bss	    dec	    hex
>   22657	   3590	     64	  26311	   66c7	memcpy
>   23103	   3590	     64	  26757	   6885	struct

You might want to show that to the compiler people. Did you look at
the assembly?

    Andrew
