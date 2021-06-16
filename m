Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3F713A9468
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 09:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232049AbhFPHwO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 03:52:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:55232 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231496AbhFPHwK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 03:52:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B4DAF613C2;
        Wed, 16 Jun 2021 07:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623829804;
        bh=0mKDEYuQohE/BR7SJLFmHnpbqI0CXC93E2lqLnRUq+M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JnIgg/VrfZ0OQTlf6mSnq6XQhxwldG6u+U+bypZDTt07KHh5Hx8MIoIGoWwHALhJ3
         iv1xVQgtd1CTS+zEwzfq8DRCYUEv4pqkEyCaDWzRiwTlPXmzLFLeXYXqc8gUYMaL5+
         q0uqxi5gX1Su8xooH7hj1aAhWNdXeJ16naOf1QKxcxz904gQW/R0Ly8DCyBrLSmD7M
         vrvkmj3yaVXn+YDDZb5r1A7xyvtt8Y0uCBpA97V7WlFkTNfAC5Iuz+kVEMFTEJSxSp
         q6+M2ZpKUJ40XiWF34UtPdxuWdrnyakxq5vXyVmoQ4LVfR9IXgBS4f60he1XszZ/st
         z9l1MCgZdUCFg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id ADFCC609E4;
        Wed, 16 Jun 2021 07:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: iosm: add missing MODULE_DEVICE_TABLE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162382980470.6206.1245624836344662922.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 07:50:04 +0000
References: <1623816447-66284-1-git-send-email-zou_wei@huawei.com>
In-Reply-To: <1623816447-66284-1-git-send-email-zou_wei@huawei.com>
To:     Zou Wei <zou_wei@huawei.com>
Cc:     m.chetan.kumar@intel.com, linuxwwan@intel.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 12:07:27 +0800 you wrote:
> This patch adds missing MODULE_DEVICE_TABLE definition which generates
> correct modalias for automatic loading of this driver when it is built
> as an external module.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Zou Wei <zou_wei@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: iosm: add missing MODULE_DEVICE_TABLE
    https://git.kernel.org/netdev/net-next/c/95d359ed5a0c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


