Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2A4338DE00
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 01:20:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232080AbhEWXVm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 19:21:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:50258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231989AbhEWXVh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 19:21:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 46405611CC;
        Sun, 23 May 2021 23:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621812010;
        bh=ejIBJcNl77EsxhAkYvvGs7wVNcRagn1XsSjRISf/sX0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iKcThpU52lVFe//EugXnG/w+F/E0R5MUi/fTHatOafjEWvrMxu6qPy2z5yz3raXc4
         SE2/6mHAWPio9ea2Z7X43P/X01DltVLqsaZr/9lVDqHKZTF3L1mP4qHyvIMgeJEseh
         ZAzFpbQEwOcTQdpLwohx9Rh29+fJaN1fxQqNH6vFD/YyTq7Huwi416C3Kp94LhgA0a
         PzIVSbg7fv2ia2NUV2c+YyGEHKu4sE8L3PH5v4hejaVIRufnx00KXNYRu2qIvxDyP6
         IJVi4pK7BzbQJupPb7oppkWK9Zudnt5pt7R4BQ327mUuriN66l4ASSuYgDidVlkAMU
         QzYLHpZ3rmUPg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3026D60BE2;
        Sun, 23 May 2021 23:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] MAINTAINERS: Add entries for CBS,
 ETF and taprio qdiscs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162181201019.2631.17593940378870840155.git-patchwork-notify@kernel.org>
Date:   Sun, 23 May 2021 23:20:10 +0000
References: <20210522004654.2058118-1-vinicius.gomes@intel.com>
In-Reply-To: <20210522004654.2058118-1-vinicius.gomes@intel.com>
To:     Vinicius Costa Gomes <vinicius.gomes@intel.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 21 May 2021 17:46:54 -0700 you wrote:
> Add Vinicius Costa Gomes as maintainer for these qdiscs.
> 
> These qdiscs are all TSN (Time Sensitive Networking) related.
> 
> Signed-off-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
> ---
>  MAINTAINERS | 8 ++++++++
>  1 file changed, 8 insertions(+)

Here is the summary with links:
  - [net-next,v2] MAINTAINERS: Add entries for CBS, ETF and taprio qdiscs
    https://git.kernel.org/netdev/net/c/1e69abf98921

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


