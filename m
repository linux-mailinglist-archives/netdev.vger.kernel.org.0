Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C2D360294C
	for <lists+netdev@lfdr.de>; Tue, 18 Oct 2022 12:26:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229865AbiJRK0T (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Oct 2022 06:26:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229752AbiJRK0R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Oct 2022 06:26:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8C5895D5;
        Tue, 18 Oct 2022 03:26:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8C73C61517;
        Tue, 18 Oct 2022 10:26:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29E45C433C1;
        Tue, 18 Oct 2022 10:26:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666088774;
        bh=O+F9PZUtZ1aoM1l0AUhHXjYWG/zaP+5OTgFirZPQLkU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oT4axrZfBywUV8Z0rA5hBF4fjTRgDxQIZgp11Dq1HZhotk/ZglH7tjqXCr1Y3EnIS
         Lx9B0xYNMyUn4sl2lqomEGhbHO/IHqrHC6pAncfMVjinxW+jAfaNYGjAKrm+Ug5T1F
         kXKvKVobP4NQXtW0nxlHR9Hs/3Dj4hR00HWoGTqWOJTtQ2dUiV0wLLY9P/90rN2QqR
         JbgdSF1QQjfRlh7235JxvOcOHTBdeNYXs2RY94P7vLfULKSChHWhEiiMwoLTlzeJdZ
         zOqjOSA5T7EixCTuxAz+nGutMNkBoUwyr1lrzCSFN8dXy0BY5cNox8KQHbmBIz6fb+
         vS1ieLyjLS7rg==
Date:   Tue, 18 Oct 2022 13:26:09 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Emeel Hakim <ehakim@nvidia.com>, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, Raed Salem <raeds@nvidia.com>,
        Saeed Mahameed <saeedm@nvidia.com>,
        Tariq Toukan <tariqt@nvidia.com>
Subject: Re: [PATCH net] net/mlx5e: Cleanup MACsec uninitialization routine
Message-ID: <Y05/QTz6qEoUINTw@unreal>
References: <b43b1c5aadd5cfdcd2e385ce32693220331700ba.1665645548.git.leonro@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b43b1c5aadd5cfdcd2e385ce32693220331700ba.1665645548.git.leonro@nvidia.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 13, 2022 at 10:21:00AM +0300, Leon Romanovsky wrote:
> From: Leon Romanovsky <leonro@nvidia.com>
> 
> The mlx5e_macsec_cleanup() routine has pointer dereferencing if mlx5 device
> doesn't support MACsec (priv->macsec will be NULL) together with useless
> comment line, assignment and extra blank lines.
> 
> Fix everything in one patch.
> 
> Fixes: 1f53da676439 ("net/mlx5e: Create advanced steering operation (ASO) object for MACsec")
> Reported-by: Dan Carpenter <dan.carpenter@oracle.com>
> Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
> ---
>  .../net/ethernet/mellanox/mlx5/core/en_accel/macsec.c | 11 +----------
>  1 file changed, 1 insertion(+), 10 deletions(-)

Gentle ping.

Thanks
