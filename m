Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94E823AF80A
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 23:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232027AbhFUVwX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 17:52:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:45560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230499AbhFUVwT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 17:52:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 60C09611BD;
        Mon, 21 Jun 2021 21:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624312204;
        bh=2XCCfSq+xiB5ANE8u/Uby+zn35F0YVwOXI6lfISGhZE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Nu+kX3shjzhyroY/S9KlZD36l7jv1MSZwmZuBr02N4gRZtdKgHfFT624jliRc/vPl
         DEJBaOE4KpkrmfNPUuHKD3k4LOwHDrSsy4CYQ0Blh+PLTjcQBN63+zkyL3ezHD7NoW
         W6FQT7NwSzGwmrFc0d02oc9U4JiPC4PLSVLThmKSAiiZrGeQPGNPk41vJ7NRftD2MI
         UCP+34BTJtPgytHdwCyv90nKSfkjug+a3KD/gz33dBnLLhPQAQP7vs5STVBrmBFekv
         ROcjoykVi9vyeqy1Tv5U0asSNU3NYJnuDNJ5svREq0FOXzCs0VU/SPPh9G541GVd0v
         /kqhsOVlBJSpw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 515C260952;
        Mon, 21 Jun 2021 21:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] vsock: notify server to shutdown when client has pending
 signal
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162431220432.17422.9844505657967304131.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Jun 2021 21:50:04 +0000
References: <20210621062601.1473-1-longpeng2@huawei.com>
In-Reply-To: <20210621062601.1473-1-longpeng2@huawei.com>
To:     Longpeng (Mike) <longpeng2@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        arei.gonglei@huawei.com, davem@davemloft.net, kuba@kernel.org,
        jhansen@vmware.com, nslusarek@gmx.net, andraprs@amazon.com,
        colin.king@canonical.com, dbrazdil@google.com,
        alex.popov@linux.com, sgarzare@redhat.com, lixianming5@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 21 Jun 2021 14:26:01 +0800 you wrote:
> The client's sk_state will be set to TCP_ESTABLISHED if the server
> replay the client's connect request.
> 
> However, if the client has pending signal, its sk_state will be set
> to TCP_CLOSE without notify the server, so the server will hold the
> corrupt connection.
> 
> [...]

Here is the summary with links:
  - [v2] vsock: notify server to shutdown when client has pending signal
    https://git.kernel.org/netdev/net/c/c7ff9cff7060

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


