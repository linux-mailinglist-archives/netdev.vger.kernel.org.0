Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96691699D0C
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 20:37:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbjBPTh0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 14:37:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjBPThZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 14:37:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426514CCBA;
        Thu, 16 Feb 2023 11:37:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D947B60AC5;
        Thu, 16 Feb 2023 19:37:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE2FFC433D2;
        Thu, 16 Feb 2023 19:37:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676576244;
        bh=RSBRE4ptB9DG2BuncwwCnJEELxZgV/b04B2gqSksNbg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=G775LD9Xmm5ZECigyXufxvlg5Wil4r2nymwdenGgPx6L7mTsLh6ig6ACh+5ybZQBZ
         2b3W0jBuqBRbNHzXXQD6q9tlX5ZYV1PBtfmgmKXKfpxGuSU9QTonGRDDk2RfEs5m//
         qmHu/46Z/OloTsd+jQFP/xgSqe01eAKfRVYmVvUzrwBekMUaaaj9SIisaEfDhOOEO8
         erfxPA3VMJpweRxjqdZxHEojuKXWqidP1/36qOU8njoZhPToPqxyjSLisbXKUYDj5m
         2XgFPnWshkA+/hDrpr2DZazCcGaWFlMSIvtG2alvcX6pbsbZJb7yJWN3xnSVpJ2K/m
         i0GzV2Jpsqbyg==
Date:   Thu, 16 Feb 2023 11:37:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>, Paolo Abeni <pabeni@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        Saeed Mahameed <saeedm@nvidia.com>,
        linux-netdev <netdev@vger.kernel.org>,
        RDMA mailing list <linux-rdma@vger.kernel.org>
Subject: Re: [GIT PULL] Please pull mlx5-next changes
Message-ID: <20230216113722.5468c863@kernel.org>
In-Reply-To: <20230215095624.1365200-1-leon@kernel.org>
References: <20230215095624.1365200-1-leon@kernel.org>
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

On Wed, 15 Feb 2023 11:56:24 +0200 Leon Romanovsky wrote:
> Following previous conversations [1] and our clear commitment to do the TC work [2],
> please pull mlx5-next shared branch, which includes low-level steering logic to allow
> RoCEv2 traffic to be encrypted/decrypted through IPsec.

I wish the assurances could have been given on the list but it is 
what it is. Pulling to net-next as well, thanks.
