Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB3554C5438
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 07:30:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230060AbiBZGau (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 01:30:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230022AbiBZGaq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 01:30:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CC0E5AA69
        for <netdev@vger.kernel.org>; Fri, 25 Feb 2022 22:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D91560C94
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 06:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B9E6C340F2;
        Sat, 26 Feb 2022 06:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645857011;
        bh=Ngr0RBd8BdmOPiwRHqF3pd+Cx8gjMCy+kHllpEUm6Tc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=drCKa0Z8ZCGsTILylFRIbRE6krLj4loDrAeOyXzeND399LeNNQ6OZf+O5ukb1Jq1u
         32qdPZXprMcYFjwDcTbKeR/4+2VrKMZGyeZrrYEKjYD+wCrIUiMV1ZlqL5nKQHTlF7
         Rzbh89PaMfEqiBEFWaxTTaAEyaImdVWTA6f8i1kj2amGGjqeXh+gk2L+OXjfyhySBv
         yErkKLtzwpqPKOMPx07PU8HcVMcbtDzoYqzGQnv235caz/cCIPmiGe/1kaeabDK0xu
         zZ7U/wa7puIPm2xn7GngM5BpXOf+jCPYScrE5ySblXM2tDxz8C0sRonLAFL7C6c0TZ
         1Y/iQQpO1VdwQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 68DF8EAC095;
        Sat, 26 Feb 2022 06:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Small fixes for MCTP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164585701142.29742.2647756314243588093.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Feb 2022 06:30:11 +0000
References: <20220225053938.643605-1-matt@codeconstruct.com.au>
In-Reply-To: <20220225053938.643605-1-matt@codeconstruct.com.au>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        jk@codeconstruct.com.au
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 25 Feb 2022 13:39:35 +0800 you wrote:
> Hi,
> 
> This series has 3 fixes for MCTP.
> 
> Cheers,
> Matt
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] mctp: Avoid warning if unregister notifies twice
    https://git.kernel.org/netdev/net-next/c/f62457df5cc4
  - [net-next,2/3] mctp i2c: Fix potential use-after-free
    https://git.kernel.org/netdev/net-next/c/06bf1ce69d55
  - [net-next,3/3] mctp i2c: Fix hard head TX bounds length check
    https://git.kernel.org/netdev/net-next/c/33f5d1a9d970

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


