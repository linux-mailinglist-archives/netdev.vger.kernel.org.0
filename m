Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 41F6869ED8D
	for <lists+netdev@lfdr.de>; Wed, 22 Feb 2023 04:36:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbjBVDgi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Feb 2023 22:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjBVDgg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Feb 2023 22:36:36 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 548BF1A5;
        Tue, 21 Feb 2023 19:36:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A2757CE1B6F;
        Wed, 22 Feb 2023 03:36:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E11C433EF;
        Wed, 22 Feb 2023 03:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677036991;
        bh=HYsbCvi2zAj5B7jKjFizGkFac4DiIBFoPSIAH6+1ZaQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C/y7Vx+gUgmbl5k73UYKhbGTwuXTHeskqxuRlNhpFP2hSbgMcQOs6xcfTv+KN5Q8i
         Jiq1bHeg7BRJw4SeYhVAoHx6IomN3D3mSwyrMyuAR2ULxrccJZMRRcy6mFmKBRu9h6
         dzSptMlAlLwCH8R9WzH+165NiNCqHJ1ckKMcNWHN7TsWq/c9dFNIC32fhTkEmm2Loi
         T6gDuSrV1Fa072eABsOaOu/9lLFFJdgEEyiEVhyxvs3L5aN+NOnyRBG9668mJrkpm6
         S6zjTRdKVE45byEYdz5zbdzGx2bhqNQJl6iKZUMUrg0bLUVhn/XskSwL8NJ+zB5EZ3
         jqpHtWJAcVUFw==
Date:   Tue, 21 Feb 2023 19:36:30 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gavin Li <gavinl@nvidia.com>
Cc:     <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <roopa@nvidia.com>, <eng.alaamohamedsoliman.am@gmail.com>,
        <bigeasy@linutronix.de>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <gavi@nvidia.com>,
        <roid@nvidia.com>, <maord@nvidia.com>, <saeedm@nvidia.com>
Subject: Re: [PATCH net-next v4 0/4] net/mlx5e: Add GBP VxLAN HW offload
 support
Message-ID: <20230221193630.5f210ea5@kernel.org>
In-Reply-To: <20230222025653.20425-1-gavinl@nvidia.com>
References: <20230222025653.20425-1-gavinl@nvidia.com>
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

On Wed, 22 Feb 2023 04:56:49 +0200 Gavin Li wrote:
> Patch-1: Remove unused argument from functions.
> Patch-2: Expose helper function vxlan_build_gbp_hdr.
> Patch-3: Add helper function for encap_info_equal for tunnels with options.
> Patch-4: Add HW offloading support for TC flows with VxLAN GBP encap/decap
>         in mlx ethernet driver.

# Form letter - net-next is closed

The merge window for v6.3 has begun and therefore net-next is closed
for new drivers, features, code refactoring and optimizations.
We are currently accepting bug fixes only.

Please repost when net-next reopens after Mar 6th.

RFC patches sent for review only are obviously welcome at any time.
