Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE39A397C7C
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 00:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235018AbhFAWlr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 18:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:34624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234714AbhFAWlp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 18:41:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0C184610E7;
        Tue,  1 Jun 2021 22:40:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622587203;
        bh=ywtmXo3Zcogeur9X+rnmtLDg5MjhJrHN8KGOkMG6SSw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=maZj6Nx5VqdTMIGIIDeykSHBYiRmrz3SrAvFlMFyfRXrP2ZGSiKZN1gOzxvsrmQ7s
         OEod4CX4U+k5uU/oASYcyBdBflWglrMqMo1aKw+SjEHxUdZW3RZaXlfJOYdKRTApef
         S1Ia0wsjPBW0z4y6PdKHLUe2x/fSALJ3Kif21eSiqJKqBqLP5OAufhwitQ8n7jc2oM
         mUkiZcBYrwD/UzOtTXCIdrCZZaiClRIpV6uh13OePf+DVlmjGagNqQQPoFcNH7KZZj
         yO45HYLZzyrTN5lg1t+T6MZKOqJZc1HHspOGlB1nSXC2xosWDiXa8iJSX7B+kzn57K
         h96C+FbrpqWxQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F332A60A6F;
        Tue,  1 Jun 2021 22:40:02 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next] net: vxge: Declare the function
 vxge_reset_all_vpaths as void
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258720299.16379.13555638109593005696.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 22:40:02 +0000
References: <20210601082304.4093866-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210601082304.4093866-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, jdmason@kudzu.us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 1 Jun 2021 16:23:04 +0800 you wrote:
> variable 'status' is unneeded and it's noneed to check the
> return value of function vxge_reset_all_vpaths,so declare
> it as void.
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  .../net/ethernet/neterion/vxge/vxge-main.c    | 27 +++++--------------
>  1 file changed, 6 insertions(+), 21 deletions(-)

Here is the summary with links:
  - [v2,net-next] net: vxge: Declare the function vxge_reset_all_vpaths as void
    https://git.kernel.org/netdev/net-next/c/52aa0b189288

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


