Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4C3DBC73
	for <lists+netdev@lfdr.de>; Fri, 30 Jul 2021 17:40:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231500AbhG3PkM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Jul 2021 11:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:37226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229754AbhG3PkL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Jul 2021 11:40:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 82AE760F4A;
        Fri, 30 Jul 2021 15:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627659606;
        bh=rqDtx1NqEwJWxBjz0SxwahkSeJJ/XsxyMNgNVau03Kw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B8+JivPVtrWc5hC729Y86ULbMeZXGJ0Fmz/Lxwxxi1Lg+RsA7gvnxxvQ88oqCNIxz
         O7p8ms/qAuYSZnHyaJq8yAn91TxlmZhzumXaixGVHYatCBevyH8WYKxHunhItj10hW
         GLvIPrsFopJUAYywYLWG1GC0TVOM8doiTMROo0V8vLE6XJF6UBouSWoCKW0cOV5t8l
         vKcTC4uiS5Jygy4WAg9GnYymMPUfSNKSoZuUwIM77xImYLSF5d3IKCd+DHifvxKYP/
         QiocFg1f5qyCaw75oQcfKo3ems5r2wFffIMjHJOwEuHlGvRrOMbyY8aAgi1+D79bbP
         sDIps1mhNcheA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 775B7609F6;
        Fri, 30 Jul 2021 15:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/7] nfc: constify pointed data - missed part
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162765960648.4488.17394911523764149240.git-patchwork-notify@kernel.org>
Date:   Fri, 30 Jul 2021 15:40:06 +0000
References: <20210730144202.255890-1-krzysztof.kozlowski@canonical.com>
In-Reply-To: <20210730144202.255890-1-krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
Cc:     davem@davemloft.net, kuba@kernel.org, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 30 Jul 2021 16:41:55 +0200 you wrote:
> Hi,
> 
> This was previously sent [1] but got lost. It was a prerequisite to part two of NFC const [2].
> 
> Changes since v2:
> 1. Drop patch previously 7/8 which cases new warnings "warning: Using
>    plain integer as NULL pointer".
> 
> [...]

Here is the summary with links:
  - [v3,1/7] nfc: mrvl: correct nfcmrvl_spi_parse_dt() device_node argument
    https://git.kernel.org/netdev/net-next/c/3833b87408e5
  - [v3,2/7] nfc: annotate af_nfc_exit() as __exit
    https://git.kernel.org/netdev/net-next/c/bf6cd7720b08
  - [v3,3/7] nfc: hci: annotate nfc_llc_init() as __init
    https://git.kernel.org/netdev/net-next/c/4932c37878c9
  - [v3,4/7] nfc: constify several pointers to u8, char and sk_buff
    https://git.kernel.org/netdev/net-next/c/3df40eb3a2ea
  - [v3,5/7] nfc: constify local pointer variables
    https://git.kernel.org/netdev/net-next/c/f2479c0a2294
  - [v3,6/7] nfc: nci: constify several pointers to u8, sk_buff and other structs
    https://git.kernel.org/netdev/net-next/c/ddecf5556f7f
  - [v3,7/7] nfc: hci: cleanup unneeded spaces
    https://git.kernel.org/netdev/net-next/c/77411df5f293

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


