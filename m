Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2E1F3DADD7
	for <lists+netdev@lfdr.de>; Thu, 29 Jul 2021 22:40:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbhG2UkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Jul 2021 16:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:33656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233151AbhG2UkK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 29 Jul 2021 16:40:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4443660F4A;
        Thu, 29 Jul 2021 20:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627591207;
        bh=cPzNG+IhLAlTcUtbka4Lexeb6ZgrCfZYzznuCEuCmS4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EyZpsX28ooAGtXtWfjFYlHwhdeVDzMceE4JpNao+3kBhL7L/AFnSB7a47YKuYZXmF
         r390ZMJ4Ohw7ndMWlaI/cJT7rmojFosWjCYuuoWzYswoedVraeJ05XNBPgk+uYTzlS
         lLINHdxsuhCKDbEP3bLqfIobLn/fQAu2c1DEY7CilXu9JH5k8eQupsO8oUucFgsZUS
         7NxjVXyIJzgfTgx36RH/pPTdRau3KsBbYJOeOGtQqhWQuVOaYr6KqiKPtOAAryR/5w
         FFZvIYCS0cP6EuI8SfCrZbNZrskJXBMA/IiZqMYFHDutrGmRdc6JjITOFJq87BVfTF
         7vdwSpc3V7AUQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 35C6560A59;
        Thu, 29 Jul 2021 20:40:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] dpaa2-switch: add mirroring support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162759120721.28029.1939266274175120987.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Jul 2021 20:40:07 +0000
References: <20210729171901.3211729-1-ciorneiioana@gmail.com>
In-Reply-To: <20210729171901.3211729-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, corbet@lwn.net,
        netdev@vger.kernel.org, linux-doc@vger.kernel.org,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Thu, 29 Jul 2021 20:18:52 +0300 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch set adds per port and per VLAN mirroring in dpaa2-switch.
> 
> The first 4 patches are just cosmetic changes. We renamed the
> dpaa2_switch_acl_tbl structure into dpaa2_switch_filter_block so that we
> can reuse it for filters that do not use the ACL table and reorganized
> the addition of trap, redirect and drop filters into a separate
> function. All this just to make for a more streamlined addition of the
> support for mirroring.
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] dpaa2-switch: rename dpaa2_switch_tc_parse_action to specify the ACL
    https://git.kernel.org/netdev/net-next/c/3b5d8b448602
  - [net-next,2/9] dpaa2-switch: rename dpaa2_switch_acl_tbl into filter_block
    https://git.kernel.org/netdev/net-next/c/adcb7aa335af
  - [net-next,3/9] dpaa2-switch: reorganize dpaa2_switch_cls_flower_replace
    https://git.kernel.org/netdev/net-next/c/c5f6d490c578
  - [net-next,4/9] dpaa2-switch: reorganize dpaa2_switch_cls_matchall_replace
    https://git.kernel.org/netdev/net-next/c/3fa5514a2966
  - [net-next,5/9] dpaa2-switch: add API for setting up mirroring
    https://git.kernel.org/netdev/net-next/c/cbc2a8893b59
  - [net-next,6/9] dpaa2-switch: add support for port mirroring
    https://git.kernel.org/netdev/net-next/c/e0ead825a1f1
  - [net-next,7/9] dpaa2-switch: add VLAN based mirroring
    https://git.kernel.org/netdev/net-next/c/0f3faece5808
  - [net-next,8/9] dpaa2-switch: offload shared block mirror filters when binding to a port
    https://git.kernel.org/netdev/net-next/c/7a91f9078d4f
  - [net-next,9/9] docs: networking: dpaa2: document mirroring support on the switch
    https://git.kernel.org/netdev/net-next/c/d1626a1c273d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


