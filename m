Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B9B965F52B
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 21:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbjAEUZW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 15:25:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231523AbjAEUZU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 15:25:20 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 252806338E;
        Thu,  5 Jan 2023 12:25:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9264C61C3D;
        Thu,  5 Jan 2023 20:25:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C31E1C433EF;
        Thu,  5 Jan 2023 20:25:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672950319;
        bh=2odOzcq8pMt/mnub2NHy4gdw4ONA/D/wUibSRbp79KM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=PFoGMmJcQ78b1slFwEI7mSKjAN8dkPNlziUaSa4IYAfZ9asrUsTgUC5nroAk890rs
         MjGMM4lXogOupFbAm2BFDp9od09fbWWyBj/t9uG4JOX/VCmpoK1d3mmpHb2WrCaUPm
         FAfB3QKCXxz4JTYIZw3wqkuPhDHA0ahFKUNgu4wRgW0jq/KM0zI2G+5Bha8PdDXT/O
         4jYKCn9xeHzAOW2r+CPxlpYmb341I2s8oCZ/cgVRfTGe8JdDBH9P5QYA8PZAP6iKSn
         Ml/vEKnitajKypdCLuFRFeHY8ti+qdnUOPXy9uxpqiDCVNdmZJFLLiPI36SswMfHxO
         HsP+0cMTdw4pA==
Date:   Thu, 5 Jan 2023 12:25:17 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev
 events fixes in RDMA
Message-ID: <20230105122517.235208c3@kernel.org>
In-Reply-To: <Y7cvLGQwaWKrFixC@unreal>
References: <20230105041756.677120-1-saeed@kernel.org>
        <Y7bLMiB9Pb8EUfn0@unreal>
        <20230105103746.13c791d8@kernel.org>
        <Y7cvLGQwaWKrFixC@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 5 Jan 2023 22:12:28 +0200 Leon Romanovsky wrote:
> > > PR should be based on Linus's -rcX tag and shouldn't include only this patchset.  
> > 
> > FWIW I don't understand what you mean by this comment.
> > PR should be based on a common ancestor, the -rc tags 
> > are just a convenient shorthand.  
> 
> Linus asked for more than once to use sensible ancestor which is -rc.

I mean.. as I said using -rc tags makes sanity checking the PRs easier,
so definitely encouraged.

I was asking more about the second part of your sentence, what do you
mean by "shouldn't include only this patchset" ?
