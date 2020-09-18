Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72E912703FA
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 20:28:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726280AbgIRS2T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 14:28:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726245AbgIRS2T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Sep 2020 14:28:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D616321D42;
        Fri, 18 Sep 2020 18:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600453699;
        bh=jIQCvfxwN4IxoHBYdaF+3BkrvxeKjqhYNfk7Cl1aByU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fa6bfPJBM8nndCou0/Bv/0LpODuNTjHQreSFdkrYwrgVxys7ooK4ZkUFoe6uEBWKU
         sGSOhfI16Im+ZDUAWG6/2xYQLUshQfS7DYGXU2iJzS0CKWzZNLiO84lqwnNQ0vrWyh
         DDRMA+YJlOpLMRDjc/LJFtFGHa4n0yn4N4J5vLvs=
Date:   Fri, 18 Sep 2020 11:28:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@nvidia.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2 0/8] devlink: Add SF add/delete devlink ops
Message-ID: <20200918112817.410ed3b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <BY5PR12MB43222DFADC76AE0780BC7C83DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
References: <20200917081731.8363-8-parav@nvidia.com>
        <20200917172020.26484-1-parav@nvidia.com>
        <20200918095212.61d4d60a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB4322941E1B2EFE8C0F3E38A0DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
        <20200918103723.618c7360@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <BY5PR12MB43222DFADC76AE0780BC7C83DC3F0@BY5PR12MB4322.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 18 Sep 2020 17:47:24 +0000 Parav Pandit wrote:
> > > What do you suggest?  
> > 
> > Start with real patches, not netdevsim.  
> 
> Hmm. Shall I split the series below, would that be ok?
> 
> First patchset,
> (a) devlink piece to add/delete port
> (b) mlx5 counter part
> 
> Second patchset,
> (a) devlink piece to set the state
> (b) mlx5 counter part
> 
> Follow on patchset to create/delete sf's netdev on virtbus in mlx5 + devlink plumbing.
> Netdevsim after that.
 
I'd start from the virtbus part so we can see what's being created.
