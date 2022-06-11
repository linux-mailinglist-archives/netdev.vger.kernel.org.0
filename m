Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9593B547232
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 07:20:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229565AbiFKFUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 01:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344922AbiFKFUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 01:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D40FBD5
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 22:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D27DB83898
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 05:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE4B0C341C4;
        Sat, 11 Jun 2022 05:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654924815;
        bh=2qw/haLKp8iw3nCyMNWtpUF1V4eUB2ix4MnasPETSAM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SgUw0NGT6Ia9IMclBj2tTmYEYZ9M+d+Z4J+cPXqKEfSFga0cbc/6mBUx1+fUBZy1l
         b9dlkaKFIiBTP4uc27hTw0q0C/3yzVtqH6F2UZWaxgregGdh3w7CxGZzarHH7+B867
         lmdKebN78LNJhwJCjJK6ly2hs1ERJVm2mLnaAurHVI75y9GuN4ukAluKxUq6QwqObe
         xe1lr2hVL9srul6OyapD5IWmwu9X+3XBxVk2r8bXAvvHaNjyKyQ3k3A1wlvEzU0A+S
         BUm9MxUZDnx4eBatbBmgSfF4QfBcVo+Lz/A8gGsbyFjA803x+hH36C8ILdQMnOdMVl
         +sxnuhLYFSyPQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9A9FE737F4;
        Sat, 11 Jun 2022 05:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6][pull request] 10GbE Intel Wired LAN Driver
 Updates 2022-06-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165492481582.17520.13100285555745814997.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Jun 2022 05:20:15 +0000
References: <20220609171257.2727150-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220609171257.2727150-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu,  9 Jun 2022 10:12:51 -0700 you wrote:
> This series contains updates to misc Intel drivers.
> 
> Maximilian Heyne adds reporting of VF statistics on ixgbe via iproute2
> interface.
> 
> Kai-Heng Feng removes duplicate defines from igb.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] drivers, ixgbe: export vf statistics
    https://git.kernel.org/netdev/net-next/c/37530030c0b6
  - [net-next,2/6] igb: Remove duplicate defines
    https://git.kernel.org/netdev/net-next/c/a413f2803d7c
  - [net-next,3/6] e1000: Fix typos in comments
    https://git.kernel.org/netdev/net-next/c/a66c46469012
  - [net-next,4/6] ixgb: Fix typos in comments
    https://git.kernel.org/netdev/net-next/c/864f1f9e88b1
  - [net-next,5/6] ixgbe: Fix typos in comments
    https://git.kernel.org/netdev/net-next/c/c2f1e80fd68b
  - [net-next,6/6] drivers/net/ethernet/intel: fix typos in comments
    https://git.kernel.org/netdev/net-next/c/138f9f50eb18

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


