Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2C709688615
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230121AbjBBSIA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231322AbjBBSH6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:07:58 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D9C11B9;
        Thu,  2 Feb 2023 10:07:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0542461B50;
        Thu,  2 Feb 2023 18:07:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17AFC433D2;
        Thu,  2 Feb 2023 18:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675361275;
        bh=qTP+uAfW3nZLKPHIqOVwltX2oVJGPrKPwZfJfEm3grg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=edy6GJ1Ca3rtt5i2cyviEseowxHqfwk4bn0SKy+1zG8ksY5We/4Xj5MOmv5hnic3z
         yvipqv1jzAbZrnB1VHTWHOywI4A17bTWnAtYGghc+36OjhArSc/SExKJE5JA8ucF1O
         XLvqrMCel0Io0JteApYuoEY+N8Ty82G5FNt/2OlsNcUWwcmMABHw2/1DZTW/JMKFot
         Ka7h1e9ya6+r8tm/ElJ7uwEfwBGz6jjM3qtSm1mf0M1gUk5G3Anhx0tyanp9c3Vkhe
         GFcVE3swzrqO5iDXZKsubrjWu0L53I6OEMqPkXkEw6Kf4MfeSYj2krELPIXcig5FOy
         bWvsi+XjnVKxA==
Date:   Thu, 2 Feb 2023 20:07:51 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y9v798CXBm/B8qjz@unreal>
References: <20230126230815.224239-1-saeed@kernel.org>
 <Y9tqQ0RgUtDhiVsH@unreal>
 <20230202091312.578aeb03@kernel.org>
 <Y9vvcSHlR5PW7j6D@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9vvcSHlR5PW7j6D@nvidia.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 01:14:25PM -0400, Jason Gunthorpe wrote:
> On Thu, Feb 02, 2023 at 09:13:12AM -0800, Jakub Kicinski wrote:
> > On Thu, 2 Feb 2023 09:46:11 +0200 Leon Romanovsky wrote:
> > > I don't see it in net-next yet, can you please pull it?
> > > 
> > > There are outstanding RDMA patches which depend on this shared branch.
> > > https://lore.kernel.org/all/cover.1673960981.git.leon@kernel.org
> > 
> > FWIW I'm not nacking this but I'm not putting my name on the merge,
> > either. You need to convince one of the other netdev maintainers to
> > pull.
> 
> What is the issue with this PR?

The PR which stuck is from Saeed. I waited for netdev to pull it, before
I will add new code and will pull it to RDMA repo.

> 
> It looks all driver internal to me?

Yes, it is.

> 
> Jason
