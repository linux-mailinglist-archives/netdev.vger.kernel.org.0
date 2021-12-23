Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6ED0147DE3D
	for <lists+netdev@lfdr.de>; Thu, 23 Dec 2021 05:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346322AbhLWE2U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Dec 2021 23:28:20 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:57492 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346298AbhLWE2U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Dec 2021 23:28:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DE02B81E6C
        for <netdev@vger.kernel.org>; Thu, 23 Dec 2021 04:28:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1731DC36AE9;
        Thu, 23 Dec 2021 04:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640233697;
        bh=CoHpzMjnGK6vS2/zfy56qlmOfOBtiXIxh5+OBgkZ6lU=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=Ay5kZZR2tFFPeBOLEs7auGzXP4VRbG4UHq0T+qTJzAJGQ/SGq/9qbBqEJvUT3d1Fd
         pjQieZGbY4N9O2lhqtv6EIbJIf2zSZVkm5czEdbI9RA6beParVRwvT/dQ5qJzuiqqx
         o5aQmM1BiYRJMVF19TzKNhcIOr95rZYRNN0TSA6ijqETwIR7FdUpeYFBCG5W+/UFSE
         1p2KUEVZj58DbFBW1FTL0m7x54/+SMIb5s7gs7VjOdPAlnqwj5VXJasP2EVOV2X98y
         veesbVFGssGCXN3AlQKt5IffrBURkBnVb7Eqx8DTvLkz9HFU8bBXU1Z6AtcNAHqioM
         5fe8XoNOrhYAw==
Message-ID: <eaa0dfacd5df9ac76469575ddb8bbbcfae21ad25.camel@kernel.org>
Subject: Re: [net 01/11] net/mlx5: DR, Fix NULL vs IS_ERR checking in
 dr_domain_init_resources
From:   Saeed Mahameed <saeed@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Roi Dayan <roid@nvidia.com>, Miaoqian Lin <linmq006@gmail.com>,
        Saeed Mahameed <saeedm@nvidia.com>
Date:   Wed, 22 Dec 2021 20:28:16 -0800
In-Reply-To: <20211222170932.1773d408@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20211222211201.77469-1-saeed@kernel.org>
         <20211222211201.77469-2-saeed@kernel.org>
         <20211222170403.3ec2fe91@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
         <20211222170932.1773d408@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.2 (3.42.2-1.fc35) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2021-12-22 at 17:09 -0800, Jakub Kicinski wrote:
> On Wed, 22 Dec 2021 17:04:03 -0800 Jakub Kicinski wrote:
> > On Wed, 22 Dec 2021 13:11:51 -0800 Saeed Mahameed wrote:
> > > From: Miaoqian Lin <linmq006@gmail.com>
> > > 
> > > The mlx5_get_uars_page() function  returns error pointers.
> > > Using IS_ERR() to check the return value to fix this.
> > > 
> > > Fixes: 4ec9e7b02697("net/mlx5: DR, Expose steering domain
> > > functionality")  
> > 
> > Do you mind fixing this missing space? I'll cherry pick the change
> > from

Sure, I will submit v2.

> > net-next in the meantime.
> 
> I take that back, I thought the error was on our side but looks like
> the patch was put in the wrong PR. Why not put it in the net PR

Yes, my mistake, the bug only existed in net-next when I accepted the
patch, I mistakenly left it in my net-next tree after rc1 was out.

> yourself? We'll handle the unavoidable conflict, but I don't see any
> advantage to me cherry picking here (which I can't do directly
> anyway,

This how I remember we used to do it.
Sure i will attach it in v2. I already checked, there will be no
conflicts.

