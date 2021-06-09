Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60FC63A1ED5
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 23:20:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229980AbhFIVWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 17:22:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:58090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229548AbhFIVWA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 17:22:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5053F613F0;
        Wed,  9 Jun 2021 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623273605;
        bh=gVTZC47iNtqoaLuBpr2U2s5p2x8x2qRIA+DneDgU3cg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DjLhUDVeDS1qH15TJMlNtBjiLQWMPbZfZPCGWD0rWOzWQnDyrERVXxfZ7uZOjyxMJ
         dG1G5O1gXd2rP7F9kZFyrLwVDJyihRJoQbrub3jgG/iVztY93CzlDEdyeFLM8MP13J
         pLrYz/E04xxk2HYXbMK7cNpSI/jBuE1oqQ0JXrdOPWve2s/ji2/kzLrOThV32A+ISi
         dPtxyiBxhi3kNtEEF1Yxq2zNUHq+naL88CrMsd3pUFitALBYsAgX3cAPk5+7DcURNc
         irpDoBtBYfnpkaW4JbeeEcxvqqXmoBImG2ogfZWjnXT+LSBDLkYR4j/WjD2greFqQf
         g6I8RDtsc+RcA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4622260A0E;
        Wed,  9 Jun 2021 21:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] net: lapbether: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327360528.22106.14874729066720704786.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 21:20:05 +0000
References: <1623231595-33851-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1623231595-33851-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xie.he.0141@gmail.com,
        ms@dev.tdt.de, willemb@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 17:39:46 +0800 you wrote:
> From: Peng Li <lipeng321@huawei.com>
> 
> This patchset clean up some code style issues.
> 
> Peng Li (9):
>   net: lapbether: remove redundant blank line
>   net: lapbether: add blank line after declarations
>   net: lapbether: move out assignment in if condition
>   net: lapbether: remove trailing whitespaces
>   net: lapbether: remove unnecessary out of memory message
>   net: lapbether: fix the comments style issue
>   net: lapbether: replace comparison to NULL with "lapbeth_get_x25_dev"
>   net: lapbether: fix the alignment issue
>   net: lapbether: fix the code style issue about line length
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: lapbether: remove redundant blank line
    https://git.kernel.org/netdev/net-next/c/eff57ab52cc4
  - [net-next,2/9] net: lapbether: add blank line after declarations
    https://git.kernel.org/netdev/net-next/c/5bc5f5f27b89
  - [net-next,3/9] net: lapbether: move out assignment in if condition
    https://git.kernel.org/netdev/net-next/c/a61bebc774cb
  - [net-next,4/9] net: lapbether: remove trailing whitespaces
    https://git.kernel.org/netdev/net-next/c/2e350780ae4f
  - [net-next,5/9] net: lapbether: remove unnecessary out of memory message
    https://git.kernel.org/netdev/net-next/c/d5e686e8b66d
  - [net-next,6/9] net: lapbether: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/4f9893c762f8
  - [net-next,7/9] net: lapbether: replace comparison to NULL with "lapbeth_get_x25_dev"
    https://git.kernel.org/netdev/net-next/c/d49859601d72
  - [net-next,8/9] net: lapbether: fix the alignment issue
    https://git.kernel.org/netdev/net-next/c/c564c049a34f
  - [net-next,9/9] net: lapbether: fix the code style issue about line length
    https://git.kernel.org/netdev/net-next/c/63a2bb15fe59

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


