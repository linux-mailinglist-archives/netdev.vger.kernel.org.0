Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD8A740DB7D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 15:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240323AbhIPNle (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 09:41:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:37886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240260AbhIPNl2 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 09:41:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6B5CD61260;
        Thu, 16 Sep 2021 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631799608;
        bh=Hjx0c8lg9dMGRA6F8WMlYVGhCIGaUfqHQ6mBeueCLH0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uxTIRTq46purS7okSlW2xY5he2axiOTeXCvjmztrfCfsWyYWZI1q/LP6AJzv84V4z
         G9JZFHayyC2KxiJmFSrrnY/Tn8Ia9Nios1Lg8NB8RXntLeeEzdIRPu1sXRdQwn45wV
         Ju/PDdpYkM639WjHBg7MZCJIxh1SNG3VvXX0fiSwTxPVhc9FUbHNQlSojj+v5rVO6T
         BNXIuowFTF1A5Z4zUOlQ3IKDVc5L0Rwg5osjn4Ue2ysIUwFpui7qK0HBtPXZgB3UkP
         EqvHC9Dj2x9Z2tLT8QYLKX7qZxzi/rTJvW7lQAEwQBfFpCpy1s+W3jMH3YmIk2D7qE
         MK4LoQvpd8imQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 613D360BCF;
        Thu, 16 Sep 2021 13:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net/tls: support SM4 GCM/CCM algorithm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179960839.17264.853854954765919907.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 13:40:08 +0000
References: <20210916033738.11971-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20210916033738.11971-1-tianjia.zhang@linux.alibaba.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, daniel@iogearbox.net,
        kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kaishen.yy@antfin.com,
        zhang.jia@linux.alibaba.com, YiLin.Li@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 16 Sep 2021 11:37:38 +0800 you wrote:
> The RFC8998 specification defines the use of the ShangMi algorithm
> cipher suites in TLS 1.3, and also supports the GCM/CCM mode using
> the SM4 algorithm.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Acked-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2] net/tls: support SM4 GCM/CCM algorithm
    https://git.kernel.org/netdev/net-next/c/227b9644ab16

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


