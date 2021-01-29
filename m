Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56820308F99
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 22:48:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233472AbhA2Vry (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 16:47:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:54954 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232727AbhA2Vrw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 16:47:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A228964E0C;
        Fri, 29 Jan 2021 21:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611956831;
        bh=nyieGZsAbLuy2p9sZebRL0VsjciaF6FIhak2Prto2Q8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=tuyRXJmCqEjpzUQqZMnsXiMUjybDGIgtVCuMSAcqkHSn/kQ6EFcz4sUevgWxsgkqJ
         rukY9GPlZ3vQozFpfeaHctpUDIkrbqjjGK4BsJwVhZ+JB3SNQqOqDqU2HM52N6JXhm
         R5frbk+VfWGR+lyYvWgGObkmQ2FXKcH8sWHUfA6st6PtDd+RVcFtoSTyQyewptwJ2T
         WIzuyJVl4c54TzKKqhKZmTG4KU1AB6XFIaYUsvPqpsUXXSuyBA3nNDe93cSQyMX//G
         qKnkzQX3EwTKCL6NJ6JXmpEo+TuJS/1KmFS4ua0eV98K+abQVEnYNUqgXQErTg8fxs
         rIvF1qnS8is4w==
Date:   Fri, 29 Jan 2021 13:47:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Chris Mi <cmi@nvidia.com>, Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        jiri@nvidia.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210129134710.1510d26a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <c3eab4cb5c401a0273bf3b391d1b72dd46ee9921.camel@kernel.org>
References: <20210128014543.521151-1-cmi@nvidia.com>
        <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
        <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
        <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <c3eab4cb5c401a0273bf3b391d1b72dd46ee9921.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 12:44:59 -0800 Saeed Mahameed wrote:
> On Fri, 2021-01-29 at 12:30 -0800, Jakub Kicinski wrote:
> > On Fri, 29 Jan 2021 14:08:39 +0800 Chris Mi wrote:  
> > > Instead of discussing it several days, maybe it's better to review 
> > > current patch, so that we can move forward :)  
> > 
> > It took you 4 revisions to post a patch which builds cleanly and now
> > you want to hasten the review? My favorite kind of submission.
> > 
> > The mlxsw core + spectrum drivers are 65 times the size of psample 
> > on my system. Why is the dependency a problem?
> > 
> > What's going to make sure the module gets loaded when it's needed?  
> 
> The issue is with distros who ship modules independently.. having a
> hard dependency will make it impossible for basic mlx5_core.ko users to
> load the driver when psample is not installed/loaded.
> 
> I prefer to have 0 dependency on external modules in a HW driver.

I see. Well such distros are clearly broken, right? You can't ship 
a module without its dependencies.
