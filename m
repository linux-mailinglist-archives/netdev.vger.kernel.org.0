Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5863DDAC1
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 16:20:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbhHBOUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 10:20:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234921AbhHBOUW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 10:20:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 82F41610CC;
        Mon,  2 Aug 2021 14:20:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627914007;
        bh=NfDZfjR0sUHnJkqTaXSLEjcmGyrcr7yymqNvT36xPgI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GU0MyHmwNs1MgavaMsxH4BGmuU1OFcqJ76jsJFH8eIqvuPs5BeXHxlK/WjQzt7KaD
         W0blE3QKmc4CrfXmk9LnrYwCMqULO8jSngV8jAKnvZP/7gSC70DvN/BH0xcsLVR1nC
         62UYHOp1M6HKSrGSD5LgRC2Lzu+6CTwlRP+BmW3DKknjO84Vr9Xyj+UWHGvI8/3228
         vl42EEZxKipFGUycKWoucoZLCDYmZffBq4rkg1vGoz2KZ6MVGuddzsxjeNcCv/TKAn
         +DxCnUtOODEC2G1kCMQMhUKPkVGqTmCSC00lJciYIPx0ixvKMsUXPV+F0Apy0sMR31
         xqoWmNDXpeKKg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7D12960A45;
        Mon,  2 Aug 2021 14:20:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] nfc: hci: pass callback data param as pointer in
 nci_request()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162791400750.18419.3531561992313522609.git-patchwork-notify@kernel.org>
Date:   Mon, 02 Aug 2021 14:20:07 +0000
References: <20210731102144.57764-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210731102144.57764-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, bongsu.jeon@samsung.com,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 31 Jul 2021 12:21:44 +0200 you wrote:
> The nci_request() receives a callback function and unsigned long data
> argument "opt" which is passed to the callback.  Almost all of the
> nci_request() callers pass pointer to a stack variable as data argument.
> Only few pass scalar value (e.g. u8).
> 
> All such callbacks do not modify passed data argument and in previous
> commit they were made as const.  However passing pointers via unsigned
> long removes the const annotation.  The callback could simply cast
> unsigned long to a pointer to writeable memory.
> 
> [...]

Here is the summary with links:
  - [v3] nfc: hci: pass callback data param as pointer in nci_request()
    https://git.kernel.org/netdev/net-next/c/35d7a6f1fb53

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


