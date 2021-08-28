Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DE363FA57C
	for <lists+netdev@lfdr.de>; Sat, 28 Aug 2021 13:30:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234171AbhH1LbA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Aug 2021 07:31:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:45172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233949AbhH1La5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 28 Aug 2021 07:30:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A568060F14;
        Sat, 28 Aug 2021 11:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630150207;
        bh=M/HjYRzrmYNQl2OwunmUwNzy33dA2G9oeuHHtUztByA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rTPh6muWsyHvI9hoJ6BlBEWs4TS/w4qFbwaDdAwETl1911YiALsvgTFuw/ADt6XAq
         mswYWXB+lQ0pWFw9vntBh7VzUhZaW4VK/zzbRPCminXPw92hxI/RFqXxMWYofvX4Lv
         L0hB1YyeCagTLqV4PZx4baeJxCTn5q7Ras4ptcwDT5mMF1Ef4DEKNGhNCnSHVKIY0A
         WZceNfOLnOmjdEIhO8uAYY4zVVrs5Y3rokBPQgwpq8QmLJltlfO2IB5A5qQ88jeDno
         2AXdhXCriv+WoMXRc5SkjE4M97t1kN2FZkTrqz6lgUv0WJ+kPz+G2WfaCgWsa0INPQ
         VbbQJ7wP8tVNA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A22A60A3C;
        Sat, 28 Aug 2021 11:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/7] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163015020762.6002.7204106144886247674.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Aug 2021 11:30:07 +0000
References: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1630133721-9260-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 28 Aug 2021 14:55:14 +0800 you wrote:
> This series includes some updates for the HNS3 ethernet driver.
> 
> #1 add a trace in  hclge_gen_resp_to_vf().
> #2~#4 refactor some functions.
> #5~#7 add some cleanups.
> 
> This series includes some optimizations, cleanups and one
> 
> [...]

Here is the summary with links:
  - [net-next,1/7] net: hns3: add trace event in hclge_gen_resp_to_vf()
    https://git.kernel.org/netdev/net-next/c/0fc36e37d5c0
  - [net-next,2/7] net: hns3: refactor function hclge_parse_capability()
    https://git.kernel.org/netdev/net-next/c/e1d93bc6ef3b
  - [net-next,3/7] net: hns3: refactor function hclgevf_parse_capability()
    https://git.kernel.org/netdev/net-next/c/81414ba71356
  - [net-next,4/7] net: hns3: add new function hclge_get_speed_bit()
    https://git.kernel.org/netdev/net-next/c/aec35aecc3cc
  - [net-next,5/7] net: hns3: don't config TM DWRR twice when set ETS
    https://git.kernel.org/netdev/net-next/c/7f2f8cf6ef66
  - [net-next,6/7] net: hns3: remove unnecessary "static" of local variables in function
    https://git.kernel.org/netdev/net-next/c/1026b1534fa1
  - [net-next,7/7] net: hns3: add required space in comment
    https://git.kernel.org/netdev/net-next/c/0cb0704149f0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


