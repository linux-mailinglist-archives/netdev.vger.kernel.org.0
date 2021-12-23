Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1AF447DC89
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 02:09:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239157AbhLWBJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 20:09:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241033AbhLWBJf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 20:09:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFA39C061574
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 17:09:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BF7F61D45
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 01:09:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65D96C36AE8;
        Thu, 23 Dec 2021 01:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640221773;
        bh=WO2Mh4eCQ8i2eH9RoZRfxzsNwPrfEZtNEAvBLNcTy6k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=iHAbPNH27O48z2aX2LAOEJiWH6j/51K/DYNbKAjVeFU46D1O+C9S9HvK8UhLYE3kD
         W2hAgig4j4Blr+9lKst4tuqj48/1HJwPIv8Kr18mK0x0KvP3jOfXa2P8PpOQ9xBYAz
         y6utURXMRBS9Kee8EI609QdLEIeRPppAzg5i3EiNrB/DBfx/LJ5ESt62owualESOMM
         Ntj/b6LErg9iiIW4Z5vCe8I9OONIYfEk5sUdEMs2VdHKRW/OED4IT07f3zchlyvWbW
         VgM0CRw+NtY/Z0GsHWCnUFPhI2nOWiabbGuWAtDqdN4JBwiaX0Dvea+J9muenUyfUi
         0HXca2xaSPDhA==
Date:   Wed, 22 Dec 2021 17:09:32 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Miaoqian Lin <linmq006@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [net 01/11] net/mlx5: DR, Fix NULL vs IS_ERR checking in
 dr_domain_init_resources
Message-ID: <20211222170932.1773d408@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211222170403.3ec2fe91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211222211201.77469-1-saeed@kernel.org>
        <20211222211201.77469-2-saeed@kernel.org>
        <20211222170403.3ec2fe91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 22 Dec 2021 17:04:03 -0800 Jakub Kicinski wrote:
> On Wed, 22 Dec 2021 13:11:51 -0800 Saeed Mahameed wrote:
> > From: Miaoqian Lin <linmq006@gmail.com>
> > 
> > The mlx5_get_uars_page() function  returns error pointers.
> > Using IS_ERR() to check the return value to fix this.
> > 
> > Fixes: 4ec9e7b02697("net/mlx5: DR, Expose steering domain functionality")  
> 
> Do you mind fixing this missing space? I'll cherry pick the change from
> net-next in the meantime.

I take that back, I thought the error was on our side but looks like
the patch was put in the wrong PR. Why not put it in the net PR
yourself? We'll handle the unavoidable conflict, but I don't see any
advantage to me cherry picking here (which I can't do directly anyway,
TBH, my local trees have only one remote to avoid false negative Fixes
tag checks).
