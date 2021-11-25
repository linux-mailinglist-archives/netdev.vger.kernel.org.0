Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3836445D274
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 02:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346394AbhKYBfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 20:35:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:34634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346773AbhKYBdU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 20:33:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 0072F6112D;
        Thu, 25 Nov 2021 01:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637803810;
        bh=px00AAB1zTS2XRMnnGT4MhaWcfSYFH580+pGharDR6g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RkIV3qVnbEJC9H7i/y5tXHaxmIajajOTg+QK1xQrfQqURRuzl7O+EKbJkJVIx0xCj
         5JKtFGBM+5c/m1qPa7mBxHyk4b4YGzLt/KncViPC1dRDCfXfqddVMX+MqSB46XKLOo
         qgC8kUOI2l4t3MdDjEmmkJwJ4qEoIBbeD1lmbUNaB9/A3XPpeoB15JRLmRGVWGNqms
         FQlNmPD1AuWNzyQinb7Q4O/VzIqtN0MHk8o57qv+jOAefIGlhdkgA25ctLA5TXx18q
         DoGdHVNRllL8V2aj2naDyM+HUN52/gzag6QtDD5cCnXxIckcZFPdyQN0obuMsvmoB2
         rEUBqF/UfX/Sg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E889860A4E;
        Thu, 25 Nov 2021 01:30:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tsnep: Fix resource_size cocci warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780380994.5226.6281808038853936061.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 01:30:09 +0000
References: <20211124205225.13985-1-gerhard@engleder-embedded.com>
In-Reply-To: <20211124205225.13985-1-gerhard@engleder-embedded.com>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, kuba@kernel.org, yang.lee@linux.alibaba.com,
        netdev@vger.kernel.org, lkp@intel.com, abaci@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 21:52:25 +0100 you wrote:
> From: Gerhard Engleder <gerhard@engleder-embedded.com>
> 
> The following warning is fixed, by removing the unused resource size:
> 
> drivers/net/ethernet/engleder/tsnep_main.c:1155:21-24:
> WARNING: Suspicious code. resource_size is maybe missing with io
> 
> [...]

Here is the summary with links:
  - [net-next] tsnep: Fix resource_size cocci warning
    https://git.kernel.org/netdev/net-next/c/1aad9634b94e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


