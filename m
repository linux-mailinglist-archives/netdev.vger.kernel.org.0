Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4968943B3A9
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 16:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236416AbhJZOMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Oct 2021 10:12:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234708AbhJZOMc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Oct 2021 10:12:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3F93B60F46;
        Tue, 26 Oct 2021 14:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635257408;
        bh=FFJnADgPLJo4DqKk8qn2qFJ/ALCH+PSU+vvWfDpSowQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lnI50V44naYPyMZ1nimPG/HWziGlnFycVz/eHRnOMkY1rjwdJlyZjJyTyBip8Lf3t
         Y9uxwYiE2c1QrTFSrktq4ZkCWCk62iBkICunau9LG8EifD9x4w+dYjgXjfgq3HUlDD
         XoE+6+UTurVgF3MfB1IJlBS9+Q/mztOSY9owhatKFUyDmRPF6ZD3hfGUK6+tO/KUP3
         1gmEETM6SOtNCF8u7gQFh6GyE9VKzQBQgPGbm80BGz3v1ZrDNORvQt6JLQCnImZVGO
         h5hDmvT3/ygyLSYggzgJPZAJjXRRrboP6OjyQoEkG/Yld4Wwm2rVUnMGJtwzrfRcqx
         hl2XuxFPQnFxA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 34600609CC;
        Tue, 26 Oct 2021 14:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ifb: Depend on netfilter alternatively to tc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163525740820.12899.4671888384340688200.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Oct 2021 14:10:08 +0000
References: <c8b883e60f7b143ed438fd6b032a054572acee47.1635225091.git.lukas@wunner.de>
In-Reply-To: <c8b883e60f7b143ed438fd6b032a054572acee47.1635225091.git.lukas@wunner.de>
To:     Lukas Wunner <lukas@wunner.de>
Cc:     davem@davemloft.net, kuba@kernel.org, pablo@netfilter.org,
        kadlec@netfilter.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, daniel@iogearbox.net, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 07:15:32 +0200 you wrote:
> IFB originally depended on NET_CLS_ACT for traffic redirection.
> But since v4.5, that may be achieved with NFT_FWD_NETDEV as well.
> 
> Fixes: 39e6dea28adc ("netfilter: nf_tables: add forward expression to the netdev family")
> Signed-off-by: Lukas Wunner <lukas@wunner.de>
> Cc: <stable@vger.kernel.org> # v4.5+: bcfabee1afd9: netfilter: nft_fwd_netdev: allow to redirect to ifb via ingress
> Cc: <stable@vger.kernel.org> # v4.5+
> 
> [...]

Here is the summary with links:
  - [net-next] ifb: Depend on netfilter alternatively to tc
    https://git.kernel.org/netdev/net-next/c/046178e726c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


