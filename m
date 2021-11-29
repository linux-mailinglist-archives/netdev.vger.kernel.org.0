Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 966614617AB
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 15:13:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244713AbhK2OQU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Nov 2021 09:16:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232698AbhK2OOR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Nov 2021 09:14:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFC04C08EAE4;
        Mon, 29 Nov 2021 04:50:11 -0800 (PST)
Received: from mail.kernel.org (unknown [198.145.29.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 88F64B8108B;
        Mon, 29 Nov 2021 12:50:10 +0000 (UTC)
Received: by mail.kernel.org (Postfix) with ESMTPS id 3744D60E0B;
        Mon, 29 Nov 2021 12:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638190209;
        bh=/E789i+PNyKyhJrfBFFVE3mTO7+Nt2BX4/IJi4jp8wM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BoHt1+JQHDzVPD7Fhq7Qf7YZROIX806QVLCM7GP/1d1UC2SmgeV7Ba8IDyoJIxozB
         /P19nHsGcfkiaYV40Slf4c7uIBHmruteItZPuVXsD4ubfryYXB3f8xft8yAS4v7dUv
         /lafLDti7cmU6mPNvvTr+IUYrU3+4EpFAAC+5LTSQW2sCZk45azFU8emED4HOv86zW
         RU6jqZE0QT+Z8DZQizM2kzQ6S0gGsNHbDBo6kUjNvYnotxgkRibav7JgOO0U5fchfh
         +Gz4DdCRNFoz8URl2eMI6seChZL6sequYBqlM921KT85+qNm9Vqd4B6akRKwto5q+a
         as+jJBOasV5aA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 22A2660A4D;
        Mon, 29 Nov 2021 12:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/tls: Fix authentication failure in CCM mode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163819020913.1533.18284775328146941390.git-patchwork-notify@kernel.org>
Date:   Mon, 29 Nov 2021 12:50:09 +0000
References: <20211129093212.4053-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20211129093212.4053-1-tianjia.zhang@linux.alibaba.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     davem@davemloft.net, kuba@kernel.org, borisp@nvidia.com,
        john.fastabend@gmail.com, daniel@iogearbox.net, vakul.garg@nxp.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 17:32:12 +0800 you wrote:
> When the TLS cipher suite uses CCM mode, including AES CCM and
> SM4 CCM, the first byte of the B0 block is flags, and the real
> IV starts from the second byte. The XOR operation of the IV and
> rec_seq should be skip this byte, that is, add the iv_offset.
> 
> Fixes: f295b3ae9f59 ("net/tls: Add support of AES128-CCM based ciphers")
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> Cc: Vakul Garg <vakul.garg@nxp.com>
> Cc: stable@vger.kernel.org # v5.2+
> 
> [...]

Here is the summary with links:
  - net/tls: Fix authentication failure in CCM mode
    https://git.kernel.org/netdev/net/c/5961060692f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


