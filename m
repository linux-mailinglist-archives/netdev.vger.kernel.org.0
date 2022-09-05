Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F725AD1D3
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 13:52:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238302AbiIELuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 07:50:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237481AbiIELuu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 07:50:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BD414BA73;
        Mon,  5 Sep 2022 04:50:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2720AB8110B;
        Mon,  5 Sep 2022 11:50:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5469FC433D6;
        Mon,  5 Sep 2022 11:50:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662378646;
        bh=Krbqhoh+LQbWbhIoknEaWwuMIBfVc2rHxu8QG845L4w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FNNLP8HMkv7Bva9dnHgyeJjiFo/+CKmqb48k3i8UvPuaE3bm07PYYQVZhAb8Ia/Nu
         XRcEYFNF43g+sMS1e5YBV1GU4jHOOFt1VQY+zgRAPeLtbd89jiPVB/eFeM+Ober4l5
         ndv8on3abfOevKDIK7hBWtu04eY/50HYPP2en4e74yYLu5kthH2UEUvxVukuok2mHP
         8IcvXfE0s5sLRz5ZKXSwTjm2uyQYI2zGLS8aUYtCizrvKW0GdNXGYI5GfT+HDjm49j
         4NQ06D5f+0J+YPVDfUptbtAjr3AA9UPxAoyEFf1wpkrs4yl3i1ZKtT66NWRb2zXGPw
         3U6ohed9JJq8Q==
Date:   Mon, 5 Sep 2022 14:50:42 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Jason Gunthorpe <jgg@nvidia.com>
Cc:     Chris Mi <cmi@nvidia.com>, linux-rdma@vger.kernel.org,
        Maher Sanalla <msanalla@nvidia.com>,
        Maor Gottlieb <maorg@nvidia.com>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [PATCH rdma-rc 0/3] Batch of fixes to mlx5_ib
Message-ID: <YxXikif2QKrUPVhN@unreal>
References: <cover.1661763459.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1661763459.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 12:02:26PM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> Hi,
> 
> This is batch of independent fixes related to mlx5_ib driver.
> 
> Thanks
> 
> Chris Mi (1):
>   RDMA/mlx5: Set local port to one when accessing counters
> 
> Maher Sanalla (1):
>   RDMA/mlx5: Rely on RoCE fw cap instead of devlink when setting profile
> 
> Maor Gottlieb (1):
>   RDMA/mlx5: Fix UMR cleanup on error flow of driver init
> 
>  drivers/infiniband/hw/mlx5/mad.c              |  6 +++++
>  drivers/infiniband/hw/mlx5/main.c             |  2 +-
>  drivers/infiniband/hw/mlx5/mlx5_ib.h          |  1 +
>  drivers/infiniband/hw/mlx5/umr.c              |  3 +++
>  .../net/ethernet/mellanox/mlx5/core/main.c    | 23 +++++++++++++++++--
>  include/linux/mlx5/driver.h                   | 19 +++++++--------
>  6 files changed, 42 insertions(+), 12 deletions(-)

Thanks, applied to rdma-rc.

> 
> -- 
> 2.37.2
> 
