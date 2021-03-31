Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F41EF34F599
	for <lists+netdev@lfdr.de>; Wed, 31 Mar 2021 02:51:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232882AbhCaAui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Mar 2021 20:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:37754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232515AbhCaAuI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 30 Mar 2021 20:50:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A1678619CA;
        Wed, 31 Mar 2021 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617151808;
        bh=f+7DZ7JDKBb1kNtpPWaTVshdFjUaOyuu4vq9Tz2PVQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V6ycy6z4i/eCjq5e/PxGJkINQ3NLNiLFYCuQZpmXt7PPZLJgMs7PHjUAGfn6kB4EQ
         DQSxisNwNoRTfcA/FEbdxSSVyU9nuuLQB8AcHgFSIQm8xeLhDA4diqJkf9t4dv1l/I
         NFg3VFxcx0U/elEaleIuatR6kMJp0CgUUluDaoBeTS0OY9dIqt+NdG+BCtufMKSlwj
         OZ3jfb1GoQ5rlWp/mqg2LrieyROtTOG1DeFSOCpB8u6tdNbAxadHmWwuq0NxgznKAs
         aG9aGCml9gK0Ii6yq0qrn5+oxrTxCYWpWXH1T29fsSlKQ5dEDKr47vADW1V0mg3CUf
         uS48Piu4iFucQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 96D2860A6D;
        Wed, 31 Mar 2021 00:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ensure mac header is set in virtio_net_hdr_to_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161715180861.15741.13679206077307040864.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 00:50:08 +0000
References: <20210330234343.3273561-1-eric.dumazet@gmail.com>
In-Reply-To: <20210330234343.3273561-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, bnemeth@redhat.com, willemb@google.com,
        syzkaller@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue, 30 Mar 2021 16:43:43 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> Commit 924a9bc362a5 ("net: check if protocol extracted by virtio_net_hdr_set_proto is correct")
> added a call to dev_parse_header_protocol() but mac_header is not yet set.
> 
> This means that eth_hdr() reads complete garbage, and syzbot complained about it [1]
> 
> [...]

Here is the summary with links:
  - [net] net: ensure mac header is set in virtio_net_hdr_to_skb()
    https://git.kernel.org/netdev/net/c/61431a5907fc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


