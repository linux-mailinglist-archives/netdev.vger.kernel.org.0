Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7CCA397CD8
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 01:00:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbhFAXBx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 19:01:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:40936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235040AbhFAXBp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 19:01:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 814A5613CE;
        Tue,  1 Jun 2021 23:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622588403;
        bh=OqGPkzz/q3IdeDGGfpXB0hBPjlvI7VdxcI004GqH/tM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OOJT8aYMlDV3TqYcQHOf14/IoWcxAZhfAX6YejGdRJ0h3eNCzBf0C0IcOHIYaAfvs
         ardPKK9TPo5N6yzrbEdUerp/R8FgqQq8xNI98XgtDT0sPLvKuTpJpq+9ktL88raxBK
         XourpPd1zcvC+Usv9RQRvP7vhAyau+cYt8TGfOOd4Jp2a8Y10mTG9eQEczhg/CJaak
         2LqVVkKovUWsbqlvb807pyHMwoOVT97VaxRB8I/A7M3kHPg7A9UQxVl4nJv+c7Q/S3
         EZWi3YWSOYVQRTaJKybZVwz3NCL9SXOhdt1RoTZRrdPY2DxfmJjIVsS9GcSbZ0GmgG
         f9SiRtK+ogl/A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 76A7260BFB;
        Tue,  1 Jun 2021 23:00:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: nci: Remove redundant assignment to len
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162258840347.25475.11870620814207718768.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Jun 2021 23:00:03 +0000
References: <1622540990-102660-1-git-send-email-yang.lee@linux.alibaba.com>
In-Reply-To: <1622540990-102660-1-git-send-email-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     krzysztof.kozlowski@canonical.com, davem@davemloft.net,
        kuba@kernel.org, nathan@kernel.org, ndesaulniers@google.com,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  1 Jun 2021 17:49:50 +0800 you wrote:
> Variable 'len' is set to conn_info->max_pkt_payload_len but this
> value is never read as it is overwritten with a new value later on,
> hence it is a redundant assignment and can be removed.
> 
> Clean up the following clang-analyzer warning:
> 
> net/nfc/nci/hci.c:164:3: warning: Value stored to 'len' is never read
> [clang-analyzer-deadcode.DeadStores]
> 
> [...]

Here is the summary with links:
  - NFC: nci: Remove redundant assignment to len
    https://git.kernel.org/netdev/net-next/c/7cf85f8caa04

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


