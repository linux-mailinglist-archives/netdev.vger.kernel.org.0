Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6835A4D5323
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 21:37:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243696AbiCJUhx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 15:37:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243017AbiCJUhv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 15:37:51 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 714E115C1B5;
        Thu, 10 Mar 2022 12:36:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2DD96B82825;
        Thu, 10 Mar 2022 20:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AC0EFC340E8;
        Thu, 10 Mar 2022 20:36:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646944607;
        bh=R7TjY7X7xkUJ3VEXwebyVOrY0qbuPZcLfjyJPfTRFss=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ClV6sDcdL+BtmMqKi0nNzffHeLUryPytvA6vhj+sfRqxCmVKTEFktNEZuLvgLgaUU
         XIc7g1uceAg+/Tp1QjY0c3LWPz+W/q73o6k2IfqR2JltwFCgZ9xeD2YTvH4DtxQ78P
         zTGy1m8gBIeDSM7uaGfJ8JsLLZc64xm5TchvOGIFc/wjiZfdTK6aPaQKcp89kg3NZ4
         WaF2m2eGgk9DC6aOmcHfhR3nh3T0UWD2DKCcrL+D+/uw6qgtcWsc9+MjwjM3KDaLp4
         fYEva1gl3/PXt5ANceerDFnKI/FYzBBZh05Fid2F1QSv0D9KKz0mD26ZFgwUwb8Rcg
         qGF2SH+iuuZlQ==
Date:   Thu, 10 Mar 2022 12:36:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Miaoqian Lin <linmq006@gmail.com>, claudiu.manoil@nxp.com,
        davem@davemloft.net, yangbo.lu@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ethtool: Fix refcount leak in gfar_get_ts_info
Message-ID: <20220310123646.6cd8eda5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <164694421005.25928.8192632263617789696.git-patchwork-notify@kernel.org>
References: <20220309091149.775-1-linmq006@gmail.com>
        <164694421005.25928.8192632263617789696.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 10 Mar 2022 20:30:10 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This patch was applied to netdev/net.git (master)
> by Jakub Kicinski <kuba@kernel.org>:

No, it wasn't. Maybe I forgot to mark this version as Changes Requested
before applying v2.

> On Wed,  9 Mar 2022 09:11:49 +0000 you wrote:
> > The of_find_compatible_node() function returns a node pointer with
> > refcount incremented, We should use of_node_put() on it when done
> > Add the missing of_node_put() to release the refcount.
> > 
> > Fixes: 7349a74ea75c ("net: ethernet: gianfar_ethtool: get phc index through drvdata")
> > Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> > 
> > [...]  
> 
> Here is the summary with links:
>   - ethtool: Fix refcount leak in gfar_get_ts_info
>     https://git.kernel.org/netdev/net/c/2ac5b58e645c
> 
> You are awesome, thank you!

