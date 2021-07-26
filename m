Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8FF3D5880
	for <lists+netdev@lfdr.de>; Mon, 26 Jul 2021 13:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233470AbhGZKtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Jul 2021 06:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:44214 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233271AbhGZKti (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Jul 2021 06:49:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DF34C60F55;
        Mon, 26 Jul 2021 11:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627299006;
        bh=RgLXR2qp2NNaA9I/DxL6nhliZZYpEn4KPaGtUL56fyM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h4Iekj8rkzDvkUEdYcaK443/fQM1LhmxeEjRsb+EIMKfXLMWMtuFrDMnkQLOHw1jA
         mgzf7ykAaZU1rFgOIilsbTVHJYnMQonYWgu5Z6v6fQpK5tzMz0ef23UhqQipaoisrd
         94TqsTCK8bX0lCHOOWg9pkKtFwNMziEBDi+o/t4AHhjCMiiEm6FVgr213slcM4sBMY
         cwYQlYXBLs4lbs6tU7qN2bItcAkk9vVcZyIxCvTUhmGE2tXGXiff0NJrWlsioum2xY
         IvzblbXKWgsCDRlB+uTHPi7kC9BhHvOtToBuJLNbDrrkC27wtg52wWwt16OBkEnhMj
         mQz+MjQiJjSuQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D1F8060A59;
        Mon, 26 Jul 2021 11:30:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: add support for coalesce adaptive feature
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162729900685.28679.331682777977917008.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Jul 2021 11:30:06 +0000
References: <20210726111634.24524-1-simon.horman@corigine.com>
In-Reply-To: <20210726111634.24524-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        oss-drivers@corigine.com, louis.peens@corigine.com,
        yinjun.zhang@corigine.com, yu.xiao@corigine.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 26 Jul 2021 13:16:34 +0200 you wrote:
> From: Yinjun Zhang <yinjun.zhang@corigine.com>
> 
> Use dynamic interrupt moderation library to implement coalesce
> adaptive feature for nfp driver.
> 
> Signed-off-by: Yinjun Zhang <yinjun.zhang@corigine.com>
> Signed-off-by: Yu Xiao <yu.xiao@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: add support for coalesce adaptive feature
    https://git.kernel.org/netdev/net-next/c/9d32e4e7e9e1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


