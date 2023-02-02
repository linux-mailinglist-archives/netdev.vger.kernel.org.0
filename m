Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDEE1688555
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 18:25:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232618AbjBBRZ1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 12:25:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232585AbjBBRZQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 12:25:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26D6974A4F;
        Thu,  2 Feb 2023 09:25:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D03A9B82761;
        Thu,  2 Feb 2023 17:25:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 074A5C433D2;
        Thu,  2 Feb 2023 17:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675358708;
        bh=aFUKxEYj2bSJTHl1ZIDwksbFFAUrelSXYfcj1KzrkGk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G8zOcswmsshx1dc+j9LHmPe5OPyl2J/FiRH4MSLGIT3jr292a2xnkB5c/0EC/XR13
         lb+rcGN8LFuXAEga3ZDN2uWH3fQRgNR8/R+hfTq/X4X5DKnjF4J5cLPpUQTkM23QQz
         uydTtWtS5NArhae3ImpaIeQCAOhqbf+DFmzLpzvfcr10QlTLaWSh3JRMNOgPZG12U0
         K1R2APOPAn3LQ1k3orC6wcdXU3cTD2tW6xA01V3LZHX0cfU0lCjs0g0ygptuWLEQfb
         PnT2f/1mVXs+kNZecJ/rgTPJ+euHd+Td1obZngRhKpsRvIVKycueJawpUWGnVuAKeo
         82wCq9IAatQnw==
Date:   Thu, 2 Feb 2023 09:25:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <20230202092507.57698495@kernel.org>
In-Reply-To: <Y9vvcSHlR5PW7j6D@nvidia.com>
References: <20230126230815.224239-1-saeed@kernel.org>
        <Y9tqQ0RgUtDhiVsH@unreal>
        <20230202091312.578aeb03@kernel.org>
        <Y9vvcSHlR5PW7j6D@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2 Feb 2023 13:14:25 -0400 Jason Gunthorpe wrote:
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

You don't remember me trying to convince you to keep the RoCE stuff
away from our open source IPsec implementation?

> It looks all driver internal to me?

Typical in a proprietary world, like RDMA, isn't it?


I'm just letting you know why I'm not merging it. I'm not the only one
with the keys, find someone else to convince, please.
