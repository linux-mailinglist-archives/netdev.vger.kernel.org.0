Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68944348629
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239478AbhCYBA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:00:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:51064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239459AbhCYBAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id C465661A19;
        Thu, 25 Mar 2021 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634008;
        bh=yj1+ACKwaEz7l60B1ZnNcjF5MGh/v+u4BdMw7wF77Hw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o+Zsy8ye4MapXKGU2eaUUCXDfmbveAIeDo93p1jJPyEDyv7CONcZ+b9P1USt5XiXU
         JiE/EBN0J0lNKH1uTsYC3R+WNwprdtZ8TUkl8FrNvo35Jk4NmyDIqmlyzIXOs5aFQb
         dII0pw9LhJODo/zvlQj80mfgZSZtX0tLGiHEFuzBX+fjgHO6wK4wfiIRFlNY7BrOGO
         ZlizIgqCrssez94eqE5MUJJ47JUYeQqrIbeIWvUOQ1NNnSZHFiWKwnsgxa7tSUb4FS
         +1XcDRelYRoACAqFrZg7sO/FCJMCQOS9a9tCQiCHnFh6MxejQbvPv7TpmQ5k7rOTZh
         uSayMe9eFifwg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B6483626F5;
        Thu, 25 Mar 2021 01:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Simplify the code by using module_platform_driver macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161663400874.21739.4209836790576013044.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Mar 2021 01:00:08 +0000
References: <20210324023047.1337-1-tomstomsczc@163.com>
In-Reply-To: <20210324023047.1337-1-tomstomsczc@163.com>
To:     Zhichao Cai <tomstomsczc@163.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, caizhichao@yulong.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 10:30:47 +0800 you wrote:
> From: Zhichao Cai <caizhichao@yulong.com>
> 
> for ftmac100
> 
> Signed-off-by: Zhichao Cai <caizhichao@yulong.com>
> ---
>  drivers/net/ethernet/faraday/ftmac100.c | 13 +------------
>  1 file changed, 1 insertion(+), 12 deletions(-)

Here is the summary with links:
  - Simplify the code by using module_platform_driver macro
    https://git.kernel.org/netdev/net-next/c/d280a2c2b740

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


