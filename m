Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB21768E361
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 23:20:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229975AbjBGWU2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 17:20:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229969AbjBGWU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 17:20:27 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93462402E3;
        Tue,  7 Feb 2023 14:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2ADE3612CB;
        Tue,  7 Feb 2023 22:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8881EC433EF;
        Tue,  7 Feb 2023 22:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675808417;
        bh=x0bMWF+tktAmz6O1xl5ZLrPvsaKxL5QlTUbgRKYLJT8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GIb3gPv/mvlUQPCEslJ3odo4uij77JJm3QCBZq6e1M4872O00AVQkNUPw2op2Pj65
         xQmNMhCetHj+5DOC4K3Z0sRRiRSnIxp3tPe/XIoF8NYWRoIQ3izFGv2sF9guikc7OE
         f5mzFAY1hlp6eXDxVnnfIgCA7rqs7eZyP1fRKpmuEyyAjos2CcJa9dYCmdRfPKHJsr
         G6lakG7Px7WExmmXntZy3fAMC8xM6rI35Ov1w0GUfpUwetD4pu94y+ytllzE9ulxqy
         /3Ty5rUEYqM2Lraa3MyCMp61+S4/DOvam1FdXRDfy8UjQ5x10eLPFcNMDH0Px8YdpT
         kdD6Z5td/V0cQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6808CE55EFD;
        Tue,  7 Feb 2023 22:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 bpf-next] net: add missing xdp_features description
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167580841742.25365.8614134796580185555.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Feb 2023 22:20:17 +0000
References: <7878544903d855b49e838c9d59f715bde0b5e63b.1675705948.git.lorenzo@kernel.org>
In-Reply-To: <7878544903d855b49e838c9d59f715bde0b5e63b.1675705948.git.lorenzo@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
        lorenzo.bianconi@redhat.com, sfr@canb.auug.org.au
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Mon,  6 Feb 2023 19:00:06 +0100 you wrote:
> Add missing xdp_features field description in the struct net_device
> documentation. This patch fix the following warning:
> 
> ./include/linux/netdevice.h:2375: warning: Function parameter or member 'xdp_features' not described in 'net_device'
> 
> Fixes: d3d854fd6a1d ("netdev-genl: create a simple family for netdev stuff")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2,bpf-next] net: add missing xdp_features description
    https://git.kernel.org/bpf/bpf-next/c/26759bee43ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


