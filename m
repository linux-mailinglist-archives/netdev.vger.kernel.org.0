Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB1772CC67A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:23:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731051AbgLBTVl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:21:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:51380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726157AbgLBTVl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 14:21:41 -0500
Date:   Wed, 2 Dec 2020 11:20:59 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606936860;
        bh=1CAt+4+rYEgG5BNHHPiLyMBHLbgFSOa76xmasEMn1WA=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=hcvMzKU7gV70c6SMkzwfayZa9AV19tW54Zb6Z7TZzy7czPOqbP/1DHKdUkNvozFe3
         ymmd3/cAQ3hBv+Yx1WPvumFw2TuY4kVQXGG8OBn2iz9m3nyHp84sZ9nCb4oXzEQVBk
         l/axJTiXPZjcrYDrAYte0H3buuP0tj7KQ31k2DoMDuXX9zvSIx7HNn9T0Sl5m5vcjx
         sht2gBszJmlVdBdys6AbaRA6n2YQd2tDG/l6TQXTyFwdF5QKn1VQ5KSZtZGWIfREHC
         8F1AaYf/bsmQz7AGIzloxurRgMnNKvCIFKKBTgv4KeT57Cc9kGePztrw4p5YXWHkPn
         ioU5QPv/LnjkA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [pull request][net-next 00/15] mlx5 updates 2020-12-01
Message-ID: <20201202112059.0f9f7475@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <0d6433ee05290e5fe109ca9fd379f5d1c7f797c8.camel@kernel.org>
References: <20201201224208.73295-1-saeedm@nvidia.com>
        <20201202104859.71a35d1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
        <0d6433ee05290e5fe109ca9fd379f5d1c7f797c8.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 02 Dec 2020 11:17:16 -0800 Saeed Mahameed wrote:
> On Wed, 2020-12-02 at 10:48 -0800, Jakub Kicinski wrote:
> > On Tue, 1 Dec 2020 14:41:53 -0800 Saeed Mahameed wrote:  
> > > Please note that the series starts with a merge of mlx5-next
> > > branch,
> > > to resolve and avoid dependency with rdma tree.  
> > 
> > Why is that not a separate posting prior to this one?  
> 
> you mean this ? 
> https://patchwork.kernel.org/project/linux-rdma/cover/20201120230339.651609-1-saeedm@nvidia.com/
> 
> it was posted and we discussed it.

Yeah but that's not a pull request, I can't pull that.

> > The patches as posted on the ML fail to build.  
> 
> Well, you need to pull the whole thing :/ .. 
> this is how i used to work with Dave on the mlx5-next branch.

To be clear - I'm asking you to send a PR for the pre-reqs and then
send the ethernet patches. So that the pre-reqs are in the tree already
by the time the ethernet patches hit the ML. I thought that's what you
did in the past, but either way it'd make my life easier.
