Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 899292DC72F
	for <lists+netdev@lfdr.de>; Wed, 16 Dec 2020 20:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388792AbgLPTdL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Dec 2020 14:33:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:57270 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388761AbgLPTdL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Dec 2020 14:33:11 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608145806;
        bh=eJ0XjOF2lZpcHQMMjUkNRywQVwOL0jhhBbEnwM9Rdm4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qYqBPuz/hNnvLedYaOwPYC+J9rKnUZGApJc84mK25VM6mSJlcX9t1rNqAYkbKp6jz
         l8FLycmzJayqyiG+uf4EWW9vgtOEjARBZIiOFOmkVmNdLYIamCMCl/qneVCFXd4lx8
         xL9iB5TbgpQ+lUlQE6t/QrxEfq+7un7jaDFcTmKMzejbIrzNeJEsbKB3Mc5N42kuVV
         aG1XvcusFkNlJU7lopDu3AnaYqroQFlBRHnkBb4w0odOJ/vFvwI7F7WaPXpJeIq5F2
         J5TZ1pwXSBqWowENRqnFFQHH0H9O09N0x4CDvZEmym2P2NONd52X1o677kFRHmpKip
         +hDEAJ/OQiAEg==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dpaa2-eth: fix the size of the mapped SGT buffer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160814580676.32605.13201225903605668119.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Dec 2020 19:10:06 +0000
References: <20201211171607.108034-1-ciorneiioana@gmail.com>
In-Reply-To: <20201211171607.108034-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jon@solid-run.com, ioana.ciornei@nxp.com,
        daniel.thompson@linaro.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 11 Dec 2020 19:16:07 +0200 you wrote:
> From: Ioana Ciornei <ioana.ciornei@nxp.com>
> 
> This patch fixes an error condition triggered when the code path which
> transmits a S/G frame descriptor when the skb's headroom is not enough
> for DPAA2's needs.
> 
> We are greated with a splat like the one below when a SGT structure is
> recycled and that is because even though a dma_unmap is performed on the
> Tx confirmation path, the unmap is not done with the proper size.
> 
> [...]

Here is the summary with links:
  - [net] dpaa2-eth: fix the size of the mapped SGT buffer
    https://git.kernel.org/netdev/net/c/54a57d1c4492

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


