Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4D65E9129
	for <lists+netdev@lfdr.de>; Sun, 25 Sep 2022 07:50:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiIYFue (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Sep 2022 01:50:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIYFud (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 25 Sep 2022 01:50:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B34A31DC0;
        Sat, 24 Sep 2022 22:50:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1D6DF6104E;
        Sun, 25 Sep 2022 05:50:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF1CFC433C1;
        Sun, 25 Sep 2022 05:50:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664085031;
        bh=uqcpavZMntXIHc+k3/HWCfLq4+bt5NxHtU/IFZzSRuY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GvcxkYfMlcKuMO8+k/aBLgHTkuNLBYeWQI/TSw4SFbTBcJftpUWs/tePIOJDixbPA
         xL9q8sSc0j5mzEMh4MULv97jGR/c3/UuTc+6AIu5R1PaxnnaJu8v427n+Spg1aDIyR
         r8R8jlPJ0AIAtZSxmyVd3YEYmo+gpI6blGJ0azrEQxzF+IuUNHQNw2eGrG1xU/9Hjx
         qh1B6Nx0Wx2n3Mb7uETPAnwPnVplRgTmj5IxBTsGkpJaxehDdb9oiHDf32Qb/uEzru
         YfViilSy/rkCcF5mTqdyL7/4xJa7+DwY7u0f05bT28n6U2xPyCpnKrVYXfxv0sOOCJ
         zo5mmKSegR/6g==
Date:   Sun, 25 Sep 2022 08:50:26 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [GIT PULL] updates from mlx5-next 2022-09-24
Message-ID: <Yy/sImnr6Dv1Zgun@unreal>
References: <20220925053930.10320-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220925053930.10320-1-saeed@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 24, 2022 at 10:39:30PM -0700, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Please pull mlx5-next branch

<...>

> Chris Mi (1):
>       RDMA/mlx5: Move function mlx5_core_query_ib_ppcnt() to mlx5_ib

Please don't.

I see the change in SHA-1 from already pulled to RDMA:
8a2dd123f12f RDMA/mlx5: Move function mlx5_core_query_ib_ppcnt() to mlx5_ib

to something else:
7b1dfbbb45d1 RDMA/mlx5: Move function mlx5_core_query_ib_ppcnt() to mlx5_ib

Please restore original commit.

Thanks
