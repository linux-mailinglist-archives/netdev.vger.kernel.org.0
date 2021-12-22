Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3F9547CAC6
	for <lists+netdev@lfdr.de>; Wed, 22 Dec 2021 02:30:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235193AbhLVBaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Dec 2021 20:30:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbhLVBaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Dec 2021 20:30:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9259C061574
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 17:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A6AD617D4
        for <netdev@vger.kernel.org>; Wed, 22 Dec 2021 01:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C080AC36AE8;
        Wed, 22 Dec 2021 01:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640136611;
        bh=Xobj2PHbRe+a5JT58+ujfnqZKHFw1W/2AVOm/Wqs0+c=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L/TpBdn7tCSEzEuetWCcNGOo1NGVPhoAXpVkCSWQLr4jHSScGFTySAy/v+py5xFvA
         cVONo0wEH3oIWAEeRWjA61iOlGeTIqt+HznCLx0xwQDhR+XfE4hrZ3uUz0XCMVbfVZ
         BYqpBc3asf0vehpcxG1NVeYgLJ0zVL1bRzyq4SwId1sQ8K5j91Jk6TshxK06aSqnIG
         1Gnd4PlqiWL+MAbm+3hO/hUZS3biVb0O4ZOtjQ7RYnF3s9jr/l/T9LzzUkPyfudmJY
         gBKsjU+y1YYxHxtcbgiesBVtM5k2HdbUAv7ggQW8RTvSREr7DXpD/+tS3EVgGI7Ove
         XjT50+SBcBsTg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 990A760A49;
        Wed, 22 Dec 2021 01:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-12-21
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164013661162.32287.10479969997787761237.git-patchwork-notify@kernel.org>
Date:   Wed, 22 Dec 2021 01:30:11 +0000
References: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211221180200.3176851-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 21 Dec 2021 10:01:52 -0800 you wrote:
> This series contains updates to igc, igb, igbvf, and fm10k drivers.
> 
> Sasha removes unused defines and enum values from igc driver.
> 
> Jason Wang removes a variable whose value never changes and, instead,
> returns the value directly for igb.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] igc: Remove unused _I_PHY_ID define
    https://git.kernel.org/netdev/net-next/c/7a34cda1ee8a
  - [net-next,2/8] igc: Remove unused phy type
    https://git.kernel.org/netdev/net-next/c/8e153faf5827
  - [net-next,3/8] igc: Remove obsolete nvm type
    https://git.kernel.org/netdev/net-next/c/2a8807a76589
  - [net-next,4/8] igc: Remove obsolete mask
    https://git.kernel.org/netdev/net-next/c/d2a66dd3fdd6
  - [net-next,5/8] igc: Remove obsolete define
    https://git.kernel.org/netdev/net-next/c/b8773a66f651
  - [net-next,6/8] igb: remove never changed variable `ret_val'
    https://git.kernel.org/netdev/net-next/c/890781af31a0
  - [net-next,7/8] igbvf: Refactor trace
    https://git.kernel.org/netdev/net-next/c/630f6edc4851
  - [net-next,8/8] fm10k: Fix syntax errors in comments
    https://git.kernel.org/netdev/net-next/c/37cf276df101

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


