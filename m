Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22AE2CCBEF
	for <lists+netdev@lfdr.de>; Thu,  3 Dec 2020 03:01:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgLCCBH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 21:01:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:44342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726631AbgLCCBG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 2 Dec 2020 21:01:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606960826;
        bh=fdXNRIo99jv8+DfBBiZqUKOCXhd1br8qLkdqi7pL5LU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IjKrr1QzG1WmOvphpc7qpoKGlyFDcV0uQpWObCIdRAKIElXZQZBplIQNwSm/usJi2
         6o6j40vs/icMM+262Usv1XGeqS1zt1QqWmua4Z92GRtm+n2xIU3uGaRqtbI+MqYOLa
         WvXabwwQcinR+Sp8aMCXE0f9pjgXXeSKPTOngoEeg9OALNSSkb3eQob5pF9C8shhb9
         3v6WsHtfYeMw5f3S+Ubjf7aLOnh0vHvExzmehylcZDcphuO8RhKCB40lhHMOBqmfkY
         0S8KhKVB8WyWJ38t4OBbsK0DRqbLe7fcNwrnUvZhPF9qu9gtTmtVasI20JHThn2XlQ
         8YDmPpibrrX8w==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [pull request][net-next V2] mlx5 next 2020-12-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160696082617.27088.17853798636525189820.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Dec 2020 02:00:26 +0000
References: <20201203011010.213440-1-saeedm@nvidia.com>
In-Reply-To: <20201203011010.213440-1-saeedm@nvidia.com>
To:     Saeed Mahameed <saeedm@nvidia.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (refs/heads/master):

On Wed, 2 Dec 2020 17:10:10 -0800 you wrote:
> Hi Jakub,
> 
> v1->v2: Use a proper tag for the pull request
> 
> This pull request includes [1] low level mlx5 updates required by both netdev
> and rdma trees, needed for upcoming mlx5 netdev submission.
> 
> [...]

Here is the summary with links:
  - [pull,request,net-next,V2] mlx5 next 2020-12-02
    https://git.kernel.org/netdev/net-next/c/32e417024fe2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


