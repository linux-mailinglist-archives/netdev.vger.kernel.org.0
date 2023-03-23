Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC226C6199
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 09:25:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjCWIZn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 04:25:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjCWIZl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 04:25:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB45AFF19;
        Thu, 23 Mar 2023 01:25:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 497B6624E0;
        Thu, 23 Mar 2023 08:25:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3FAC433D2;
        Thu, 23 Mar 2023 08:25:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679559939;
        bh=gHqcBOx/kuOiDU7OapUEo1SJy/zg/ZDwi3pkgsioYXs=;
        h=From:To:Cc:In-Reply-To:References:Subject:Date:From;
        b=i0Hk+DnR5S72uqbXkzP9evruIZoHMe4SmeirboKIxyGHCyY0vwjyfk0zNT6jHBsk6
         M8kTyNlRSAGBy3g1IywLWJiMBrQrhj1u4eZHisflIdGQiucn0hnOPES0NYK+O9BUNh
         RyR4C0N4PwQ4nblhm9LNBmVnj9Y+46A7xWRJ7DzddZtckITs2NsRbNkK5K9O3jDZb5
         IXBC780wb1DgO8h4uVJF8hKxYZW4ganBZEt+jQvI+B5LnAMmtYzs/fSchHeFCtooSt
         ide9cOuiY61US5gHz15kvxDv14B+QfPvqRO99rOUq1RO3HrT9PZLU9AlJ3s+qnoqM2
         UD6NFW3ajD0SQ==
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        Or Har-Toov <ohartoov@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Leon Romanovsky <leon@kernel.org>
In-Reply-To: <cover.1679230449.git.leon@kernel.org>
References: <cover.1679230449.git.leon@kernel.org>
Subject: Re: [PATCH rdma-next 0/3] Enable IB out-of-order by default in mlx5
Message-Id: <167955993510.1725006.144017826417177540.b4-ty@kernel.org>
Date:   Thu, 23 Mar 2023 10:25:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12-dev-a055d
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sun, 19 Mar 2023 14:59:29 +0200, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> This series from Or changes default of IB out-of-order feature and
> allows to the RDMA users to decide if they need to wait for completion
> for all segments or it is enough to wait for last segment completion only.
> 
> [...]

Applied, thanks!

[1/3] net/mlx5: Expose bits for enabling out-of-order by default
      https://git.kernel.org/rdma/rdma/c/6e2a3a324aab9d
[2/3] RDMA/mlx5: Disable out-of-order in integrity enabled QPs
      https://git.kernel.org/rdma/rdma/c/742948cc02d523
[3/3] net/mlx5: Set out of order (ooo) by default
      https://git.kernel.org/rdma/rdma/c/f4244e55e4c3a1

Best regards,
-- 
Leon Romanovsky <leon@kernel.org>
