Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3089E54E877
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 19:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376968AbiFPRNr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Jun 2022 13:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378101AbiFPRNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Jun 2022 13:13:37 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EF21E85;
        Thu, 16 Jun 2022 10:13:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 08A62CE266C;
        Thu, 16 Jun 2022 17:13:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE27FC34114;
        Thu, 16 Jun 2022 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655399613;
        bh=B2TZ65Uful5z33tEcYLHXw7v+7EPZqio8S4EguvHO9Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lQ02Lwn6MWPKztTHLATfF1lX1EHmGuMg5MBHEHZMd62pGi/dNH8nul5XgA+pssnZk
         LzMaThTyF6fjRUpYtxv2albFIjpm8pVumVYpwPZlMroW7mxYAY2GM1XUyhZ3ozQElm
         RMLus1RK2jod9KMVjoI4nWYGCEoJxkyX4hYFO6QU2eZLitX7NkaGUaSUaB2J3Pic9S
         24uKIPEWTyoNGccTeEOj5MM+nT9HROMzRXUQwwSZT2arUJuU+hTygjpmNHpOdIz/iu
         8544R3ZD+z+Og4PGCFD/2GsJiz60Hd+cIgEcUSkfMns0hlP9yG4pNCsNrNyfz9D1ll
         hvJrL6Uzi2yrw==
Date:   Thu, 16 Jun 2022 20:13:29 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     Jason Gunthorpe <jgg@nvidia.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org
Subject: Re: [GIT PULL][next-next][rdma-next] mlx5-next: updates 2022-06-14
Message-ID: <YqtkuTZI5eIudcFj@unreal>
References: <20220614184028.51548-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220614184028.51548-1-saeed@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 14, 2022 at 11:40:28AM -0700, Saeed Mahameed wrote:
> From: Saeed Mahameed <saeedm@nvidia.com>                                        
> 
> The following changes since commit f2906aa863381afb0015a9eb7fefad885d4e5a56:
> 
>   Linux 5.19-rc1 (2022-06-05 17:18:54 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/mellanox/linux.git mlx5-next
> 
> for you to fetch changes up to cdcdce948d64139aea1c6dfea4b04f5c8ad2784e:
> 
>   net/mlx5: Add bits and fields to support enhanced CQE compression (2022-06-13 14:59:06 -0700)
> 
> ----------------------------------------------------------------
> 
> This pull includes shared updates to net-next and rdma-next for upcoming mlx5   
> features.                                                                       
>                                                                                 
> Please pull and let me know if there's any problem                              
>                                                                                 

Thanks, pulled.
