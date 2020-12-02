Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B84A42CC79A
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 21:17:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387717AbgLBUP6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 15:15:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:60394 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729021AbgLBUP6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 15:15:58 -0500
Message-ID: <5fde80a4326c45950615918e6e51b5d28d4b9e96.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606940117;
        bh=k3Rc1LyK4I28s1TR4FrEgSZ4kRyzyqjilrld2C4EUT8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=E6CSekhNsJOC+HlG3Gj9nDpwolNvgiVvHRKL/LUMdOu8ph/QynMFf7WvwBtkderX0
         186l95R1L7X3FZs9KD3MrdMNMWRHZGO7eNGhK2gTTWJ0Ewyp/a54JsnhoiBOWNkpFW
         c4hiSe7bRiLQVXYvp3gDKw8yPTjXCrMZZumjm+QCuoeWOZ4qSWXcZY73kvafgOvSoh
         PjHdpY7cKq9zuzyXmTOhU0x1fqEE+UpBJA4qiYkF1mDeTjVaTNJ8SHkZKpzEG5OfVV
         ehC3ZLNunIZinRKaSWBRtdBKyLpLekTIbZAGmGC7jaEjI5r8d6uUydcANBBKj5RHqZ
         EAWGRhtKEng0g==
Subject: Re: [pull request][net-next 00/15] mlx5 updates 2020-12-01
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Wed, 02 Dec 2020 12:15:15 -0800
In-Reply-To: <20201202112059.0f9f7475@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201201224208.73295-1-saeedm@nvidia.com>
         <20201202104859.71a35d1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
         <0d6433ee05290e5fe109ca9fd379f5d1c7f797c8.camel@kernel.org>
         <20201202112059.0f9f7475@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-02 at 11:20 -0800, Jakub Kicinski wrote:
> On Wed, 02 Dec 2020 11:17:16 -0800 Saeed Mahameed wrote:
> > On Wed, 2020-12-02 at 10:48 -0800, Jakub Kicinski wrote:
> > > On Tue, 1 Dec 2020 14:41:53 -0800 Saeed Mahameed wrote:  
> > > > Please note that the series starts with a merge of mlx5-next
> > > > branch,
> > > > to resolve and avoid dependency with rdma tree.  
> > > 
> > > Why is that not a separate posting prior to this one?  
> > 
> > you mean this ? 
> > https://patchwork.kernel.org/project/linux-rdma/cover/20201120230339.651609-1-saeedm@nvidia.com/
> > 
> > it was posted and we discussed it.
> 
> Yeah but that's not a pull request, I can't pull that.
> 
> > > The patches as posted on the ML fail to build.  
> > 
> > Well, you need to pull the whole thing :/ .. 
> > this is how i used to work with Dave on the mlx5-next branch.
> 
> To be clear - I'm asking you to send a PR for the pre-reqs and then
> send the ethernet patches. So that the pre-reqs are in the tree
> already
> by the time the ethernet patches hit the ML. I thought that's what
> you
> did in the past, but either way it'd make my life easier.

Ok, Done, will submit two separate pull requests.

But to avoid any wait and to create full visibility, is there a way to
let the CI bot understand dependency between two separate pull requests
? or the base-commit of a pull request ?

I would like to send everything in one shot for full visibility.

Thanks,
Saeed.

