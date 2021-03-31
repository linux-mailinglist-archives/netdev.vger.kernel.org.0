Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3B0434F53B
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:00:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232553AbhCaAAP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:00:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:39974 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232246AbhCaAAL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:00:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 68269619D3;
        Wed, 31 Mar 2021 00:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617148811;
        bh=lZGT1h7Fo4Bg2GmFBv8zwjHLBFE3yEIu8UCYetbGDTM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ERADJgQAAt5EYs8n1yNnN4BChkzx+Z8Vcvdx2oSqM52EQmm4QmgPh7jVn6QHYMjg9
         oJehoso5ayigTeN8CaGSc+yy0CvIkU/2XpBy1B+5x0mI/bkw948qmm8kbAcbKErtDQ
         NrI2A6PLpb8h35KQXBuhc479CYkAya3j7YXnZkyOmSq/n2MRuu45xXOyK9zCixz13d
         JqjeZOYcZGXC6+ovsa2GbKO+1bJh8JeawPl0Kqse/5fx6voxwTn5ljmMPbhE5OOXpB
         Bbgg5hOe+dqqCW4RNFzHv/4cYQXBuciFC1b7g76fny1T0Z9cZyjs8A7eHgB4R9pzrN
         fuhmYtOYLqtEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5E96260A6D;
        Wed, 31 Mar 2021 00:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [RESEND net-next 0/4] net: remove repeated words
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161714881138.29090.15457966847464209647.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:00:11 +0000
References: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
In-Reply-To: <1617089276-30268-1-git-send-email-tanhuazhong@huawei.com>
To:     Huazhong Tan <tanhuazhong@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jesse.brandeburg@intel.com,
        j.vosburgh@gmail.com, vfalico@gmail.com, andrew@lunn.ch,
        elder@kernel.org, netdev@vger.kernel.org, salil.mehta@huawei.com,
        yisen.zhuang@huawei.com, huangdaode@huawei.com,
        linuxarm@openeuler.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 30 Mar 2021 15:27:52 +0800 you wrote:
> This patch-set removes some repeated words in comments.
> 
> Peng Li (4):
>   net: i40e: remove repeated words
>   net: bonding: remove repeated word
>   net: phy: remove repeated word
>   net: ipa: remove repeated words
> 
> [...]

Here is the summary with links:
  - [RESEND,net-next,1/4] net: i40e: remove repeated words
    https://git.kernel.org/netdev/net-next/c/059ff70c8cab
  - [RESEND,net-next,2/4] net: bonding: remove repeated word
    https://git.kernel.org/netdev/net-next/c/252b5d373564
  - [RESEND,net-next,3/4] net: phy: remove repeated word
    https://git.kernel.org/netdev/net-next/c/fec76125baf7
  - [RESEND,net-next,4/4] net: ipa: remove repeated words
    https://git.kernel.org/netdev/net-next/c/497abc87cf99

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


