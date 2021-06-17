Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBF8C3ABBF3
	for <lists+netdev@lfdr.de>; Thu, 17 Jun 2021 20:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbhFQSmT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Jun 2021 14:42:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:51768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232198AbhFQSmN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 17 Jun 2021 14:42:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DC567613F3;
        Thu, 17 Jun 2021 18:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623955205;
        bh=kPjp/fAV8kta/X0hv3+VJZc0w2uQUMMvoWVgT6LcENo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FJYGPURvOUJnYnf1YbfRDmc6X81Tv+W3uPJ0k8H6BLtf4uAD9QUAWjxOuDHT6ClRe
         kOHbc1/mtZ7CCZSaiELpALTmYptbPGj4xgnqLQyb2pWvv2VdcnPllR2Vtlmv/IbMrf
         B2vC2NIcwpvqcYCUqVnwHcmwlr4kNJRbVM7vgCh0O15qvU6uV67dh/nmQEK15ZvPJ3
         SIHn09n+IKQoXcfVIQstbzyR62f6Zyi7mb20r63kjaO7vwPQU5BHLorp5ZCxi7ZDpo
         i9+JC+X4YS4jR5a2eI1ZIsf4dBCKjdsItAXg5AJoXw9JNs24NMQKwccnKrHKh2QQml
         vePPDniWJ4rCA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D6E3260CD0;
        Thu, 17 Jun 2021 18:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ipa: Add missing of_node_put() in
 ipa_firmware_load()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162395520587.2276.15652604965329237162.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Jun 2021 18:40:05 +0000
References: <20210617051119.1153120-1-yangyingliang@huawei.com>
In-Reply-To: <20210617051119.1153120-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        elder@kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 13:11:19 +0800 you wrote:
> This node pointer is returned by of_parse_phandle() with refcount
> incremented in this function. of_node_put() on it before exiting
> this function.
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ipa: Add missing of_node_put() in ipa_firmware_load()
    https://git.kernel.org/netdev/net-next/c/b244163f2c45

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


