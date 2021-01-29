Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81DD4308E7F
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:32:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233102AbhA2UcD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:32:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:39334 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233242AbhA2UbB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Jan 2021 15:31:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D2C964DD8;
        Fri, 29 Jan 2021 20:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611952210;
        bh=866bsDa5Gwch3W1vt+K5P2ZlW4W4AoS0Pka7gwV9FYc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MQc2UMJ3lCNAJIIZQXkVslQhC9zBWK5WpVAdnAfm4QXusYrX27uUKIGuqmtC09rZQ
         NwqMaPlk0oBtABYmlNa/nNwpm8wE3aUWCwLyfFNR5T7KGIbHrOW62ciOEDxkKdj7wq
         m1a82eF6Niq46M2v79kvNO7q/2L6AfDdeyVGzSXVZ0hs79QyrNsPD6ysrd3tp5++CH
         YdPvMRVFlgFtQoHEg1Y/I379VJqa3T3UEcpI6X8gLL9zaVcZ99QP9GP900APxnN4Jk
         8LOEz0G6MoIRLo6Jk3KZMjRdqdnn1+K/mWWaPXLr96pXnAhHKz2KuqAOhRj4uVhRk4
         Gqyyb+KPl4aUw==
Date:   Fri, 29 Jan 2021 12:30:09 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Chris Mi <cmi@nvidia.com>
Cc:     Cong Wang <xiyou.wangcong@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        <jiri@nvidia.com>, Saeed Mahameed <saeedm@nvidia.com>,
        kernel test robot <lkp@intel.com>
Subject: Re: [PATCH net-next v4] net: psample: Introduce stubs to remove NIC
 driver dependency
Message-ID: <20210129123009.3c07563d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
References: <20210128014543.521151-1-cmi@nvidia.com>
        <CAM_iQpWQe1W+x_bua+OfjTR-tCgFYgj_8=eKz7VJdKHPRKuMYw@mail.gmail.com>
        <6c586e9a-b672-6e60-613b-4fb6e6db8c9a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jan 2021 14:08:39 +0800 Chris Mi wrote:
> Instead of discussing it several days, maybe it's better to review 
> current patch, so that we can move forward :)

It took you 4 revisions to post a patch which builds cleanly and now
you want to hasten the review? My favorite kind of submission.

The mlxsw core + spectrum drivers are 65 times the size of psample 
on my system. Why is the dependency a problem?

What's going to make sure the module gets loaded when it's needed?
