Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A82C65F500
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 21:12:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235542AbjAEUMk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 15:12:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235607AbjAEUMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 15:12:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31EAB1AA37;
        Thu,  5 Jan 2023 12:12:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6792B81BBE;
        Thu,  5 Jan 2023 20:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0288C433D2;
        Thu,  5 Jan 2023 20:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672949554;
        bh=PMQ6KOTycpPt9waQ+UO1/XQAGqh79MTpNJYH2WLISWg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s8jmoH/MC1icg6b+C/IxfR/V9hZfPiZBENRUJ9TAhKiquTCwoWGsAKtLueZzSEMVM
         4qI3xVAP4k6OTf0ckefN+WlhifhfyE0SbEtYplQbg8F4gKcQgxqjzQxiQuU140SyRC
         He0h7Bu6NEY3Lz8gcMK2MjPvg0QKuoGiTYYr/9H55o6wom0YlUnzkqqBr0YCDZrHKa
         8/QRaryAzH02heOYeKZ0ncCIj/W2sSbsYW5wPYv5V+zlIoXytHkYlV/wM3WPRF4QI1
         PLK9DTuK4VpqApobGvnIhQcCukoPhzwIQJ/oBTjrdnRVNoJOtGTaL6vAabUmp1tHtc
         JOLO/F25Tb8Ug==
Date:   Thu, 5 Jan 2023 22:12:28 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev
 events fixes in RDMA
Message-ID: <Y7cvLGQwaWKrFixC@unreal>
References: <20230105041756.677120-1-saeed@kernel.org>
 <Y7bLMiB9Pb8EUfn0@unreal>
 <20230105103746.13c791d8@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230105103746.13c791d8@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 05, 2023 at 10:37:46AM -0800, Jakub Kicinski wrote:
> On Thu, 5 Jan 2023 15:05:54 +0200 Leon Romanovsky wrote:
> > > This series includes mlx5 modifications for both net-next and
> > > rdma-next trees.
> > > 
> > > In case of no objections, this series will be applied to net-mlx5 branch
> > > first then sent in PR to both rdma and net trees.  
> > 
> > PR should be based on Linus's -rcX tag and shouldn't include only this patchset.
> 
> FWIW I don't understand what you mean by this comment.
> PR should be based on a common ancestor, the -rc tags 
> are just a convenient shorthand.

Linus asked for more than once to use sensible ancestor which is -rc.

Thanks
