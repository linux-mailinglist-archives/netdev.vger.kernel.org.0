Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A6216885F9
	for <lists+netdev@lfdr.de>; Thu,  2 Feb 2023 19:03:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230454AbjBBSDl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Feb 2023 13:03:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229761AbjBBSDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Feb 2023 13:03:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A020D470BF;
        Thu,  2 Feb 2023 10:03:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F4B0B82760;
        Thu,  2 Feb 2023 18:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92E07C433EF;
        Thu,  2 Feb 2023 18:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675360987;
        bh=dDr81wSRND9UtsYUvH4dUg+ZdOt465RX/o4tJQiSZ9Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZE9u1E9aZAQQZuHO7HBGXZK65zxZqqHhgWuUygoSrn8ozapqmodLPsH613vgV2jSy
         UkKDhbEZwrpLH2AZd2FjvgsoNejr7CNy06w8tzLn/fXn2ealGQor75I/mh5UZcJ7Et
         ViRWQsjKygl2ziFxcR9eM2svgBMn+USdkb45QTqGQ0OVxAfYCHCYFKIU6zN6/+4shV
         DunslVViNr5gxZ83mK3PWDx1jIqz7xGF93CSHOXzPg1Ngt7k+Np3CYDtuLphD6bLcl
         6KEzAJ8UHmduUnRc721tvtrCd+iSXYoOKaLcXcjPhtMI6Wsi26CaLVJ4EPXScoqXk+
         eUbG5oZnB90Xw==
Date:   Thu, 2 Feb 2023 20:03:02 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        Saeed Mahameed <saeed@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: pull-request: mlx5-next 2023-01-24 V2
Message-ID: <Y9v61gb3ADT9rsLn@unreal>
References: <20230126230815.224239-1-saeed@kernel.org>
 <Y9tqQ0RgUtDhiVsH@unreal>
 <20230202091312.578aeb03@kernel.org>
 <Y9vvcSHlR5PW7j6D@nvidia.com>
 <20230202092507.57698495@kernel.org>
 <Y9v2ZW3mahPBXbvg@nvidia.com>
 <20230202095453.68f850bc@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230202095453.68f850bc@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 02, 2023 at 09:54:53AM -0800, Jakub Kicinski wrote:
> On Thu, 2 Feb 2023 13:44:05 -0400 Jason Gunthorpe wrote:
> > > You don't remember me trying to convince you to keep the RoCE stuff
> > > away from our open source IPsec implementation?  
> > 
> > Huh? What does this:
> > 
> > https://lore.kernel.org/all/cover.1673960981.git.leon@kernel.org/
> > 
> > Have to do with IPsec?
> 
> Dunno. But I don't know what it has to do with the PR we're commenting
> on either..

It has to do, because I need shared branch to put net/mlx5 patches from
that "special keys" series and I patiently waited for any response.

First, I didn't see any comment of not pulling Saeed's PR.
Second, I didn't see any not-pulling comments other IPsec patches which
Saeed posted prior issuing his PR.
Third, IPsec patches are pure mlx5_core changes. This is where flow
steering exists.

➜  kernel git:(rdma-next) git diff --stat bb2e8913dc40..ml/mlx5-next
 drivers/net/ethernet/mellanox/mlx5/core/Makefile             |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/diag/fs_tracepoint.c |   4 +
 drivers/net/ethernet/mellanox/mlx5/core/en/fs.h              |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.h     |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec_fs.c  |  59 ++++++--
 drivers/net/ethernet/mellanox/mlx5/core/fs_cmd.c             |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c            |  44 +++++-
 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.c  | 372 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/net/ethernet/mellanox/mlx5/core/lib/ipsec_fs_roce.h  |  20 +++
 include/linux/mlx5/fs.h                                      |   3 +
 10 files changed, 497 insertions(+), 15 deletions(-)

Thanks
