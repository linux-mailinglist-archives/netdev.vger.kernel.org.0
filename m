Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D86E42E68B
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 04:30:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235037AbhJOCcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 22:32:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:58502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231331AbhJOCcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 22:32:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 415B661152;
        Fri, 15 Oct 2021 02:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634265008;
        bh=4FVO8qQ+ZnxAWkGbzDOBnUsWqDDsimQpVqlsLcI54BY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d56C6kMPgQYC8/KB9KGT2Uqz1Ld3HX6+0b05lXhMTAZ80y01Y9yO1Njxpbrzz1PiB
         e1A/wbjlfTu8RiODUE4qdMBKfl2fIdbAeLvn0pihaIfP5Oluwkmn8qzQR5esFbe2ie
         Z5cegklmiD98/VRq7H75b9mnVs/uo49PhRNDon4xcZdTUfzIb45pe8Pn2A+yPhLMvf
         XICXHhpbrchMB8qDh5+dZtsaHViGL+aZSXamA0OvdjYRofVDO7Net409ZrXuKOXk7w
         RlFdkR4w1kYDr/uX4/tQTsgECX9TCO53VWcSbNh+CGbA1xclIzYItAbne+Qr7c+fke
         fS1NtbIAB/DfA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 34BF660A44;
        Fri, 15 Oct 2021 02:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] Minor managed neighbor follow-ups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163426500821.31820.3009159456327599460.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 02:30:08 +0000
References: <20211013132140.11143-1-daniel@iogearbox.net>
In-Reply-To: <20211013132140.11143-1-daniel@iogearbox.net>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     davem@davemloft.net, kuba@kernel.org, roopa@nvidia.com,
        dsahern@kernel.org, m@lambda.lt, john.fastabend@gmail.com,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 15:21:37 +0200 you wrote:
> Minor follow-up series to address prior feedback from David and Jakub.
> Patch 1 adds a build time assertion to prevent overflows when shifting
> in extended flags, patch 2 is a cleanup to use NLA_POLICY_MASK instead
> of open-coding invalid flags rejection and patch 3 rejects creating new
> neighbors with NUD_PERMANENT & NTF_MANAGED. For details, see individual
> patches. Will push out iproute2 series after that. Thanks!
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] net, neigh: Add build-time assertion to avoid neigh->flags overflow
    https://git.kernel.org/netdev/net-next/c/507c2f1d2936
  - [net-next,2/3] net, neigh: Use NLA_POLICY_MASK helper for NDA_FLAGS_EXT attribute
    https://git.kernel.org/netdev/net-next/c/c8e80c1169b2
  - [net-next,3/3] net, neigh: Reject creating NUD_PERMANENT with NTF_MANAGED entries
    https://git.kernel.org/netdev/net-next/c/30fc7efa38f2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


