Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED0B24633DD
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241393AbhK3MNd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:13:33 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:36276 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233232AbhK3MNb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:13:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 61E03CE191E;
        Tue, 30 Nov 2021 12:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B98DC53FCD;
        Tue, 30 Nov 2021 12:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274209;
        bh=PgS+nZgeT5V/ueZPIRQA7HhqwXFR4ewo69EuglngNzI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Axsh0DwJ5NbcE3H2XbIEDOYuknm5w4Y0NLLNKJbMnd3PdwCSLajtZ8Ji/gh7tQdzz
         I85PkxoOx+yMYemybZ1WnG/SJLEtKyw4Eg3a8dJau2RQ1kWXwhHk/mLGWPRCXW46KJ
         096jOs47yrfC6zc+eEA/Y7AiuUzL18Imbx3w3x9KDva6bcXnXpaz56GkCBSukEMFe3
         YkrYKoa2aD6SRQrbaqEWZ5BJwWo6JO8ms03wEh9DrtexkMF/kIIQexzkgQJlUM9b+e
         PIHnjhoaMM37VMzvzkMSbItQsjZtMecIBZP36TF8ZxBCa23ffq0RIqFYJ4QECqu4FY
         0WSXom8bF1LAQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 701F860A7E;
        Tue, 30 Nov 2021 12:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: marvell: mvpp2: Fix the computation of shared CPUs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827420945.23105.12464625635462017692.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:10:09 +0000
References: <1093499694f6b375617197eae87db2083a17aaf4.1638222729.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <1093499694f6b375617197eae87db2083a17aaf4.1638222729.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, atenart@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 22:53:27 +0100 you wrote:
> 'bitmap_fill()' fills a bitmap one 'long' at a time.
> It is likely that an exact number of bits is expected.
> 
> Use 'bitmap_set()' instead in order not to set unexpected bits.
> 
> Fixes: e531f76757eb ("net: mvpp2: handle cases where more CPUs are available than s/w threads")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> 
> [...]

Here is the summary with links:
  - net: marvell: mvpp2: Fix the computation of shared CPUs
    https://git.kernel.org/netdev/net/c/b83f5ac7d922

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


