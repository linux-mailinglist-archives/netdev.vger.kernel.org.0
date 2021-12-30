Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FEA2481C7C
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 14:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239597AbhL3NaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Dec 2021 08:30:20 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:47132 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239520AbhL3NaN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Dec 2021 08:30:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D475616E7
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 13:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF637C36AF1;
        Thu, 30 Dec 2021 13:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640871013;
        bh=ECniVgbhDXNYcLJgVAoWDAPNb9lYf3NcVZ4ouathqIM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eJHFNgJi62UpELDpkSqJwBWyNsKTv6tGTLQp+J/N1/BUJ5Ir2299mMIczZw+8w56w
         9H1SyZ5WPTaX0iCMyox9NSxWf8Y/Hk1JSi8rWIXfRBIUgF2JII9xLP+SOFhPO/ms5U
         10rIQ6qB4P4x+pLN9pCl3qetbt7060qfdi+syJlTP9Jwu8niVC5BkzaXVTPlbteIIp
         kjnTkjDvq5jv09YDzEhD3eUa8v1UTjDs0hzbFYTFW6pjmzHpGGqXjGHWIOj0gI2YUD
         BfsrABvzrz5PKpb0i61Se5YWtUsaRFm+0shYM5AqizZ9hyBnbSgHPG5POrxVEk/XLN
         eHT6ODA/9mBxA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D85BAC395E6;
        Thu, 30 Dec 2021 13:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] ice: Add flow director support for channel mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164087101288.9335.11572997117674639575.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Dec 2021 13:30:12 +0000
References: <20211229185433.685930-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211229185433.685930-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, kiran.patil@intel.com,
        netdev@vger.kernel.org, sridhar.samudrala@intel.com,
        amritha.nambiar@intel.com, sudheer.mogilappagari@intel.com,
        bharathi.sreenivas@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 29 Dec 2021 10:54:33 -0800 you wrote:
> From: Kiran Patil <kiran.patil@intel.com>
> 
> Add support to enable flow-director filter when multiple TCs are
> configured. Flow director filter can be configured using ethtool
> (--config-ntuple option). When multiple TCs are configured, each
> TC is mapped to an unique HW VSI. So VSI corresponding to queue
> used in filter is identified and flow director context is updated
> with correct VSI while configuring ntuple filter in HW.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] ice: Add flow director support for channel mode
    https://git.kernel.org/netdev/net-next/c/40319796b732

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


