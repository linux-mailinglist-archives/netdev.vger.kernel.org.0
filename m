Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB4A2CC668
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 20:21:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387728AbgLBTR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 14:17:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:49826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387672AbgLBTR6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 14:17:58 -0500
Message-ID: <0d6433ee05290e5fe109ca9fd379f5d1c7f797c8.camel@kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606936637;
        bh=zCh8bGMCanwq6B2BV7dtNTk69ZWgTghXTqapHJdznb8=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=HoyRBOcMj26iVmCaxg4es5yhPJuzpmKE6Db+WqJyXJnncg+yUucw3xB4eRwA0SUNd
         uDtDOQQmC0mSNwHAW4psbHfFnUhGHg3Pfrtb/56fqoSikvPzH1M6h/OreyfhsBHIYB
         idaXGIllPIwhq44OmbI4AB8u+q5C7DRcIIYg72vrq84asm3TJmoiJfGidD61VwCJVl
         2Zigpdk6D5UDDuP9qZ0UYjQuDoHNPEiRLWvaOagLrlxqpqO/pb/QLTlTJGYlfIPQ8c
         2/A5n8uF6DiDLIhdmPmnv77wU7bdnvuxL6YHk0w6hrz8eKfyXbHhGtZuIDpxjjiQ/W
         zOSTqD2O0QXBQ==
Subject: Re: [pull request][net-next 00/15] mlx5 updates 2020-12-01
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Date:   Wed, 02 Dec 2020 11:17:16 -0800
In-Reply-To: <20201202104859.71a35d1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
References: <20201201224208.73295-1-saeedm@nvidia.com>
         <20201202104859.71a35d1e@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2020-12-02 at 10:48 -0800, Jakub Kicinski wrote:
> On Tue, 1 Dec 2020 14:41:53 -0800 Saeed Mahameed wrote:
> > Please note that the series starts with a merge of mlx5-next
> > branch,
> > to resolve and avoid dependency with rdma tree.
> 
> Why is that not a separate posting prior to this one?

you mean this ? 
https://patchwork.kernel.org/project/linux-rdma/cover/20201120230339.651609-1-saeedm@nvidia.com/

it was posted and we discussed it.

> 
> The patches as posted on the ML fail to build.

Well, you need to pull the whole thing :/ .. 
this is how i used to work with Dave on the mlx5-next branch.

