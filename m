Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9336C545BF5
	for <lists+netdev@lfdr.de>; Fri, 10 Jun 2022 07:57:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345917AbiFJF5B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jun 2022 01:57:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239380AbiFJF5A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Jun 2022 01:57:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B65883968E;
        Thu,  9 Jun 2022 22:56:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53A9C61E74;
        Fri, 10 Jun 2022 05:56:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 628A2C34114;
        Fri, 10 Jun 2022 05:56:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654840618;
        bh=tqa2qEghji7NeZCEwmQNGRGe3Peh47Szj8Wj0xWJipk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SA4yX79lC4gBdjrAJmZHSkoJIB6XmnYR9Dkv3xys+wkMOaqA3IcKBiN31i1Va8/QI
         TNQJLAbLyJJl53jh8SU+ScDaJU8XZqikRq+2eVt2AvnvCUjIDhiNurQyZozib7oQo2
         aGgfy0gdQb6tH/qGTzcXkz/MCMUS8woh/6U2uWvldKMGyL8jgIQCHYDGLhujXaLaTn
         mUygU67M7OMfK9y2Eq+1csaf4HYwJrp+/EVuW9mnXATtPaHPAhnahTNVUFvob+/UbK
         edv+auyUSAYYA7V6tXXK6gpBWq/chCkbGb62jDfPuVvAuHfmilS+PGxOnixl/Dv9hO
         NBkn8KJOHsWOw==
Date:   Thu, 9 Jun 2022 22:56:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>, leonro@nvidia.com,
        borisp@nvidia.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to
 TLS support removal
Message-ID: <20220609225657.299278f7@kernel.org>
In-Reply-To: <165483841435.4442.11942577289291510346.git-patchwork-notify@kernel.org>
References: <20220601045738.19608-1-lukas.bulwahn@gmail.com>
        <165483841435.4442.11942577289291510346.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Jun 2022 05:20:14 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (master)
> by Saeed Mahameed <saeedm@nvidia.com>:
> 
> On Wed,  1 Jun 2022 06:57:38 +0200 you wrote:
> > Commit 40379a0084c2 ("net/mlx5_fpga: Drop INNOVA TLS support") removes all
> > files in the directory drivers/net/ethernet/mellanox/mlx5/core/accel/, but
> > misses to adjust its reference in MAINTAINERS.
> > 
> > Hence, ./scripts/get_maintainer.pl --self-test=patterns complains about a
> > broken reference.
> > 
> > [...]  
> 
> Here is the summary with links:
>   - MAINTAINERS: adjust MELLANOX ETHERNET INNOVA DRIVERS to TLS support removal
>     https://git.kernel.org/netdev/net/c/ed872f92fd09

What luck. I was trying to see if pw-bot will respond to the PR rather
than the series if I mark the series as accepted first but apparently
it found this random posting and replied to it instead :S

That's a roundabout way of saying that I pulled "mlx5 fixes 2022-06-08",
thanks!
