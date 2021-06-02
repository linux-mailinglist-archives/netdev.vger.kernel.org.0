Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B58397D91
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235512AbhFBAMR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:12:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:56040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235261AbhFBALu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:11:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 39C02613D6;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592608;
        bh=+lVRjw5jCjNulanyL9+Gaw7py+YwbEmSMkscw+q6zPA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J59fE55Lr62St4jn41koMctH7qwrAkFOIn9mkxmwuLQ4PZI30TegfA/3bxHkDmx7K
         A+bXzarCGwTEGAgUmIwVIt5iLgBb7gx9UiOwBU/ZisZNgIvMBLMbSPWdkp8I9bIVEp
         mUlFRR6K+M6qXJSFTiEWLiM20VvFrhhVC4ChQ39JvKCrs5syO8iD5UOCsIHX8STazi
         CrPYiWSOBLMPXg0I2uXCfisF4RzPemwK2V1cmUkkGdkkYpLX/EfLGu0ZNjFqT73Y7W
         piOrZMp7X9BFk8gIaZ8aqWEj/ED3cXjqQ9Lhy3dPAPNFcrHUiG1jqnuyLhKSBBcW4e
         JtaFDcrMbUgmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2EB30609EA;
        Wed,  2 Jun 2021 00:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] hamradio: bpqether: Fix -Wunused-const-variable
 warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259260818.22595.13878076192552604464.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:10:08 +0000
References: <20210601140052.31456-1-yuehaibing@huawei.com>
In-Reply-To: <20210601140052.31456-1-yuehaibing@huawei.com>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, xiyou.wangcong@gmail.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 22:00:52 +0800 you wrote:
> If CONFIG_PROC_FS is n, gcc warns:
> 
> drivers/net/hamradio/bpqether.c:437:36:
>  warning: ‘bpq_seqops’ defined but not used [-Wunused-const-variable=]
>  static const struct seq_operations bpq_seqops = {
>                                     ^~~~~~~~~~
> Use #ifdef macro to gurad this.
> 
> [...]

Here is the summary with links:
  - [net-next] hamradio: bpqether: Fix -Wunused-const-variable warning
    https://git.kernel.org/netdev/net-next/c/e516f5be5b17

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


