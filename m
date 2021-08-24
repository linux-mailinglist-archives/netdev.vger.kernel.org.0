Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC1D53F5B48
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 11:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbhHXJuw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 05:50:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:47674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235698AbhHXJuu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 05:50:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9AD76613BD;
        Tue, 24 Aug 2021 09:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629798606;
        bh=bEsBkjwXJdrL4fXFRZnwScaiTadOBQteqlna1ABdqkI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cJGeB7e9w0/f6a+O5rydTaOpZezvflsYVAUjoqQfVk4/j/YX/sfc9CUssHeiGp+Ni
         W+O3Cb1s/iqhoaEfflhwMNtUKOAGXAAc+DomlIzjdngd62jXmP+qf9KRCHvOFLYj3Q
         oH6/5Icues0otdBLH6dtezpE+tgt+8lRUAd1bVGFDhXPhdlR7AZ8E1EiOVFZs/E00g
         OZjRZpTdax/5BnFtxS1O5Rrlh29m/aiaAb85r6p1sgFOftUNYoq5PGy+0IHucv4WKW
         iKwSSl7hgReA6CRj0MbTJciBOlUZpOttjSJsTGIwy6HH/KV3y9/FUxqGAreWW4mw2w
         8u4OC7EeMmG7A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 949A6608FC;
        Tue, 24 Aug 2021 09:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] page_pool: use relaxed atomic for release side
 accounting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162979860660.15454.10605630571460805131.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 09:50:06 +0000
References: <1629796009-11010-1-git-send-email-linyunsheng@huawei.com>
In-Reply-To: <1629796009-11010-1-git-send-email-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hawk@kernel.org,
        ilias.apalodimas@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, hkallweit1@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 24 Aug 2021 17:06:49 +0800 you wrote:
> There is no need to synchronize the account updating, so
> use the relaxed atomic to avoid some memory barrier in the
> data path.
> 
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] page_pool: use relaxed atomic for release side accounting
    https://git.kernel.org/netdev/net-next/c/7fb9b66dc9ce

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


