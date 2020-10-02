Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C917C281D02
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 22:37:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725791AbgJBUhX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 16:37:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:42496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725355AbgJBUhW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Oct 2020 16:37:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 38DB3206C9;
        Fri,  2 Oct 2020 20:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601671042;
        bh=SGslAtsdP5mje4+0c2EWlRRxx69HxatgILnm8pBjzhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kzROqWUolY+98TVod/CEgxWkYd3qubeqaB0dJdzdGHI+vHQXKb+EEKtGDH4pDJCvy
         h6cD85P0V8MCuyz9b1VfqFKqyrAQBhEEZCNZt9ZvE6q3+ujMsppvU0RsBR1eYh0r05
         e3hJYtVBa9W1uMDMCVd6fi3nGLXEu5JPu+z/m0k0=
Date:   Fri, 2 Oct 2020 13:37:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH 3/5] netlink: rework policy dump to support multiple
 policies
Message-ID: <20201002133720.7fb5818c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <580e017d3acc8dda58507f8c4d5bbe639a8cecb7.camel@sipsolutions.net>
References: <20201002090944.195891-1-johannes@sipsolutions.net>
        <20201002110205.2d0d1bd5027d.I525cd130f9c78d7a6acd90d735a67974e51fb73c@changeid>
        <20201002083926.603adbcb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <580e017d3acc8dda58507f8c4d5bbe639a8cecb7.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 02 Oct 2020 22:13:36 +0200 Johannes Berg wrote:
> > > +int netlink_policy_dump_add_policy(struct netlink_policy_dump_state **pstate,
> > > +				   const struct nla_policy *policy,
> > > +				   unsigned int maxtype);  
> > 
> > Personal preference perhaps, but I prefer kdoc with the definition.  
> 
> I realized recently that this is actually better, because then "make
> W=1" will in fact check the kernel-doc for consistency ... but it
> doesn't do it in header files.
> 
> Just have to get into the habit now ...

:o 

I was wondering why I didn't see errors from headers in the past!

I guess it's because of the volume of messages this would cause.
