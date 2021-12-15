Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69F5E475B0A
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 15:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243371AbhLOOuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 09:50:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55008 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243304AbhLOOuM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 09:50:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08BF6C06173E;
        Wed, 15 Dec 2021 06:50:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 19BB961926;
        Wed, 15 Dec 2021 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7552CC34606;
        Wed, 15 Dec 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639579809;
        bh=vUnC37gHKKNvpy4gcqFav+hWib3KYB4kJzeJ3maTVPY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ePEtyoGoeKzMbjUjbZ7wG07yS0mb9OYZxGTPuyFc2Cf9LroLcQXmW2dcV//Qigq7n
         HJJAJcWvLBIBO+GdtVigy8oPkUFsC3tS5TzAQ59iQc6nGpHFjeBPp65PQVi3xlU5Ah
         wgjk3pKNyReIOpWQvaxqykD+FYq0FU7b/F2AVpbC4cIwhi7NWfGz7mTO36e59o5h8n
         EDELkfADdF4t3CwZVG06EbvKc41FUj4/fCqi2VA9qLFkCVtntsKdvoPGhv1ZMT6xK7
         Aqp9kovM1fDLgJQxLKC9JhtA4PnCuuqGDCqlUJxw0wLZ1Fdf9hoSCadM+DJ9tLhQZD
         6DU6pJEtVTFyA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5898B60A4F;
        Wed, 15 Dec 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-drivers-2021-12-15
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163957980935.14546.14856648962480435122.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Dec 2021 14:50:09 +0000
References: <20211215141852.040D3C34604@smtp.kernel.org>
In-Reply-To: <20211215141852.040D3C34604@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Dec 2021 14:18:51 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-drivers-2021-12-15
    https://git.kernel.org/netdev/net/c/1d1c950faa81

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


