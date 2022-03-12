Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09DA4D6B91
	for <lists+netdev@lfdr.de>; Sat, 12 Mar 2022 02:06:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiCLBHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 20:07:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiCLBHc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 20:07:32 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77ED921D09D;
        Fri, 11 Mar 2022 17:06:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1201961588;
        Sat, 12 Mar 2022 01:06:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44CC4C340E9;
        Sat, 12 Mar 2022 01:06:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647047187;
        bh=S8F9yhuIfkt9RCQbOTNbYRp5abZCGc7974Mcau6XY+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jKyGuajd9ts2kYeForRfNibkohCg/vcYsj0b253QvXcAyPlOX5mGveds9AqysHX6S
         0+rGEztGKyG5PMPtkbW4DPrm/TRMKRGo417eALB67JsFFj+/VQ2dmR9YElCqcHc8na
         RDm3W/wMenNc/j6wPt6clJ+uFmMPvTgiKV0gPPvVDhJacOGkWNSZQN+tUK86lXBT4U
         z7TwKiPP8roJBjPxOIFa9So3KOas9OBus0mTvuqwoG3Vgq7P/fSObkydmKiK1XjIvP
         RwsBFejyXqCjkMjy0Bip/z7SiLNQlVZxPg8KnLw+Qwd9pF4XrZ+qE1Xv+hwWrGKgvb
         0CaSZilS3FEMQ==
Date:   Fri, 11 Mar 2022 17:06:25 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Johannes Berg <johannes@sipsolutions.net>, netdev@vger.kernel.org,
        linux-wireless@vger.kernel.org
Subject: Re: pull-request: wireless-next-2022-03-11
Message-ID: <20220311170625.4a3a626b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
References: <20220311124029.213470-1-johannes@sipsolutions.net>
        <164703362988.31502.5602906395973712308.git-patchwork-notify@kernel.org>
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

On Fri, 11 Mar 2022 21:20:29 +0000 patchwork-bot+netdevbpf@kernel.org
wrote:
> Hello:
> 
> This pull request was applied to netdev/net-next.git (master)
> by Jakub Kicinski <kuba@kernel.org>:
> 
> On Fri, 11 Mar 2022 13:40:28 +0100 you wrote:
> > Hi,
> > 
> > Here's another (almost certainly final for 5.8) set of
> > patches for net-next.
> > 
> > Note that there's a minor merge conflict - Stephen already
> > noticed it and resolved it here:
> > https://lore.kernel.org/linux-wireless/20220217110903.7f58acae@canb.auug.org.au/
> > 
> > [...]  
> 
> Here is the summary with links:
>   - pull-request: wireless-next-2022-03-11
>     https://git.kernel.org/netdev/net-next/c/0b3660695e80
> 
> You are awesome, thank you!

mumble, muble

Seems to break clang build.
