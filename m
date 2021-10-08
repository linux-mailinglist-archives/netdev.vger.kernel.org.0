Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 241BB426EFB
	for <lists+netdev@lfdr.de>; Fri,  8 Oct 2021 18:30:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230282AbhJHQcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Oct 2021 12:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229606AbhJHQcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Oct 2021 12:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9AEFB60F6C;
        Fri,  8 Oct 2021 16:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633710607;
        bh=IZz+szGKCj/zy4i8JrJzAkbouT1+2IFxqeFS+LG0plo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=m8DTCoEX5Hy0qEyjgEuzrv0jf9+ULQcFTSbJ/lninZ9bhJbghbG7kA2eBd/QkYeNB
         bKs34TZfATy/ppfidL+aGTXLi86U77Cs6TSlQhaKW+A/Zy9/B7PzF8LK0KKTEoZ5if
         GJcOidQCZwYPcnL9q7MfdeErRfcSI46Zhq6EJwhUFg28rl6P63XEpFmTqQBDWhSHJC
         UvonwoMefLHzZn3veEj93ZVX3wdROtvrwUlY2fjSDbh4dREJdmUreBMDPhTlrhEoIL
         VWyjLBWqVdLw+3EjoVpRiGyZakhsCqTqGA/pGwaf6LZ6M3b36JO9zv9k6aDQvz+2ZI
         TgfvS+Fvbd9JA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8711D60A44;
        Fri,  8 Oct 2021 16:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfc: nci: fix the UAF of rf_conn_info object
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163371060754.30754.13208229686280226764.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Oct 2021 16:30:07 +0000
References: <20211007174430.62558-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20211007174430.62558-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linma@zju.edu.cn,
        linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, greg@kroah.com, will@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu,  7 Oct 2021 19:44:30 +0200 you wrote:
> From: Lin Ma <linma@zju.edu.cn>
> 
> The nci_core_conn_close_rsp_packet() function will release the conn_info
> with given conn_id. However, it needs to set the rf_conn_info to NULL to
> prevent other routines like nci_rf_intf_activated_ntf_packet() to trigger
> the UAF.
> 
> [...]

Here is the summary with links:
  - nfc: nci: fix the UAF of rf_conn_info object
    https://git.kernel.org/netdev/net/c/1b1499a817c9

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


