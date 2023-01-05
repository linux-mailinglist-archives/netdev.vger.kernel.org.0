Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C603665F3D7
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 19:38:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234586AbjAESh7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Jan 2023 13:37:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234680AbjAEShu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Jan 2023 13:37:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 486B61CFD3;
        Thu,  5 Jan 2023 10:37:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 038BFB81B83;
        Thu,  5 Jan 2023 18:37:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53FF6C433D2;
        Thu,  5 Jan 2023 18:37:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672943867;
        bh=GnoLRHvHhJApnTuJ2oP4eYp+Mfb4nKLrRPfvinyq/Y8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Fcum8SnuZjZ7MuiwwgNsj2pgLaM67D0Gg2l+cZDtTsPDZpIl3mLlLOE5VuuJbEyP0
         ZMrlrq9sJpYhUFjCN4TDrbY2jHkPSAR5X4x3w5NLI3kJgxgMe4jnALwtbQLITQo3dn
         mtnFb2veqecOsbaqPD/4hjQ6IkFTy8sOKLncZYPa1dxRvBPTwPTGEwBQTZYkCmy06a
         9TP/Lr93QkGZ980pNvhft0nL/lc4T7AvbXckc2yvPj4GDJgEDAjNsc3Bd3ahGII5BX
         gUUeMcBWuu0p9vWcr6yMmeExDHGPAIp1tqTYg4CH1E7QgnXaYy/ZdMj8Ai7aclSlym
         +7eDu5m6mjfUw==
Date:   Thu, 5 Jan 2023 10:37:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leonro@nvidia.com>
Cc:     Saeed Mahameed <saeed@kernel.org>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Jason Gunthorpe <jgg@nvidia.com>, <linux-rdma@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH mlx5-next 0/8] mlx5 IPsec RoCEv2 support and netdev
 events fixes in RDMA
Message-ID: <20230105103746.13c791d8@kernel.org>
In-Reply-To: <Y7bLMiB9Pb8EUfn0@unreal>
References: <20230105041756.677120-1-saeed@kernel.org>
        <Y7bLMiB9Pb8EUfn0@unreal>
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

On Thu, 5 Jan 2023 15:05:54 +0200 Leon Romanovsky wrote:
> > This series includes mlx5 modifications for both net-next and
> > rdma-next trees.
> > 
> > In case of no objections, this series will be applied to net-mlx5 branch
> > first then sent in PR to both rdma and net trees.  
> 
> PR should be based on Linus's -rcX tag and shouldn't include only this patchset.

FWIW I don't understand what you mean by this comment.
PR should be based on a common ancestor, the -rc tags 
are just a convenient shorthand.
