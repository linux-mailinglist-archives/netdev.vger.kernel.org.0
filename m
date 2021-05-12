Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA3C437EE9B
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 00:59:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347818AbhELVzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 17:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:45836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1390992AbhELVVT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 17:21:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6BAE6611C9;
        Wed, 12 May 2021 21:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620854410;
        bh=OnCsDf+VAf8Ue6lMnmXW3m8NpoDOwGtGbqdoWQzhseo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Y60ohL7/qQvTlGxeuJeVWVeyoMBqamkeesHcBcoJbMysVEX3fzRV1Me0ZUW6T7esq
         saUrTov2X4CuHmSLbJ7eXQnh4N9Prc9yFsoK59sDGFYKfkkicejEdTqyt+rZlkQTj/
         I75KBBoxA8xJCpL9JGJ5ib5gqUkrjSHLy9fQNNHSlHPbnGr9SfbMJlNWNxUOqBnQRM
         86U+furUtv4RZyRACuXuYlR5Ykv/kWFdTECBO6ZRRvmcF9pvDWHGlSJ+EbT2nTlPus
         453lUz++DSg2e+oQPnWjIh+/dEMp90fpoOHzDMbhwnbUoS2ACfvkt0ycUDL9dDoQst
         r7UBK4/G1en5Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 602AB609D8;
        Wed, 12 May 2021 21:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 1/2] MAINTAINERS: nfc: add Krzysztof Kozlowski as maintainer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162085441038.10928.7471974213298679002.git-patchwork-notify@kernel.org>
Date:   Wed, 12 May 2021 21:20:10 +0000
References: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210512144319.30852-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nfc@lists.01.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed, 12 May 2021 10:43:18 -0400 you wrote:
> The NFC subsystem is orphaned.  I am happy to spend some cycles to
> review the patches, send pull requests and in general keep the NFC
> subsystem running.
> 
> Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
> 
> 
> [...]

Here is the summary with links:
  - [1/2] MAINTAINERS: nfc: add Krzysztof Kozlowski as maintainer
    https://git.kernel.org/netdev/net/c/8aa5713d8b2c
  - [2/2] MAINTAINERS: nfc: include linux-nfc mailing list
    https://git.kernel.org/netdev/net/c/4a64541f2ceb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


