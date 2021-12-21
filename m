Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB67247B8E4
	for <lists+netdev@lfdr.de>; Tue, 21 Dec 2021 04:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbhLUDKM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Dec 2021 22:10:12 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:35778 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234266AbhLUDKL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Dec 2021 22:10:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 875F4613FB
        for <netdev@vger.kernel.org>; Tue, 21 Dec 2021 03:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E26BDC36AF0;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640056210;
        bh=KnRELLM2ggUgHijBi+CgKScgLfVhaqDCtwfGY4J8VtQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vMNnFUWUc/d2nWvWPMDa0tLTHd+ZFFVTxAWU63x9HWRo3OD3KpIeiizFfwSzCDDpI
         Q/U+mbbv9GxXpJLb/d165E+szBI5GLog/H8OrW18UcR+WJ6MQer5DMwdVlPV8dgUwG
         VxIeyIHj3w88BhlgGEpoQFWasDB9Or7DQAxBF5/uY4J/+AB4E0HwmpRmhwnXJrW6yB
         VmhbJTt0kwoxZ8FQy+pTj7KFaG7q9myjIK5XnoBBMuf0Zkch+fIkhVEB/ErFFZQgs0
         vg5+gQ3q1bxTP1fzWxYY3Fdt19Wn7SeAXBnHtEfa4l4aJqYSaHutwg99/JzFcUDdcj
         w4/nWsek2K1Pg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C833B60A49;
        Tue, 21 Dec 2021 03:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gve: Correct order of processing device options
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164005621081.30905.11640992262718687250.git-patchwork-notify@kernel.org>
Date:   Tue, 21 Dec 2021 03:10:10 +0000
References: <20211220192746.2900594-1-jeroendb@google.com>
In-Reply-To: <20211220192746.2900594-1-jeroendb@google.com>
To:     Jeroen de Borst <jeroendb@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 20 Dec 2021 11:27:46 -0800 you wrote:
> The legacy raw addressing device option was processed before the
> new RDA queue format option.  This caused the supported features mask,
> which is provided only on the RDA queue format option, not to be set.
> 
> This disabled jumbo-frame support when using raw adressing.
> 
> Fixes: 255489f5b33c ("gve: Add a jumbo-frame device option")
> Signed-off-by: Jeroen de Borst <jeroendb@google.com>
> 
> [...]

Here is the summary with links:
  - [net] gve: Correct order of processing device options
    https://git.kernel.org/netdev/net/c/1f06f7d97f74

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


