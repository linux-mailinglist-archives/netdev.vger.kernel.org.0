Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52DB9345063
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 21:01:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231703AbhCVUAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 16:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:43300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230070AbhCVUAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 16:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B248761477;
        Mon, 22 Mar 2021 20:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616443208;
        bh=3HEd+iN2dNwIGLaKk8y6NWGQ4arBf6Kvnz2RoP6pciA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=keNpavVe/YXM0PmaKKnmCRJkUloMn+3Gv2IyBLG7WNnIiLFp/ZxTc9O5qWeT0RwA7
         TBVnKhBIUzH1PRJkm8m1U7ZZLh3Ucl8xLED0vGq+4hEv2vHhcXSC0yE6xB6fLh+6MS
         8zTAmFJrh5SGBNg1w47dBdhQNVEgjaIjUZNY6kHLvz0uUoZ/vFomxdMdoabwCLpLGK
         IVVlvN+xs7AszEdJ9cJYItQBx28WSvfvHckEXH+wED8EHh7UH7aRreLz3o29i6iinb
         EqGz00B7SoJAf4uGxgdJgDS7JAqdpjlEIW0fUPqdXP+/7CfTizZSHgJlJ7VCdCnMlu
         MgNbNlp7K0wmA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A344860A49;
        Mon, 22 Mar 2021 20:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/2] net/sched: cls_flower: use ntohs for struct
 flow_dissector_key_ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161644320866.18911.10418502358411416630.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Mar 2021 20:00:08 +0000
References: <20210321210549.3234265-1-olteanv@gmail.com>
In-Reply-To: <20210321210549.3234265-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sun, 21 Mar 2021 23:05:48 +0200 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> A make W=1 build complains that:
> 
> net/sched/cls_flower.c:214:20: warning: cast from restricted __be16
> net/sched/cls_flower.c:214:20: warning: incorrect type in argument 1 (different base types)
> net/sched/cls_flower.c:214:20:    expected unsigned short [usertype] val
> net/sched/cls_flower.c:214:20:    got restricted __be16 [usertype] dst
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net/sched: cls_flower: use ntohs for struct flow_dissector_key_ports
    https://git.kernel.org/netdev/net-next/c/6215afcb9a7e
  - [net-next,2/2] net/sched: cls_flower: use nla_get_be32 for TCA_FLOWER_KEY_FLAGS
    https://git.kernel.org/netdev/net-next/c/abee13f53e88

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


