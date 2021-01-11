Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACFCA2F24F7
	for <lists+netdev@lfdr.de>; Tue, 12 Jan 2021 02:18:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405423AbhALAZc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 19:25:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:34122 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404121AbhAKXat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 Jan 2021 18:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9F3C422D0B;
        Mon, 11 Jan 2021 23:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610407808;
        bh=6a5WJBOBgvT1n462G/OpD4T6KZkPpIkf+HphGquHnnQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ek4cVHf47GMd5eq481TpHcYAf+DUHZlukgjpfHubYQeva+A6maJ2NVDBCLKzBDu18
         MNjBXp01aZc1SC5oldgR3B60gJXFaBzmw6HOHSpmP6jTj53nnw0kAzELk3ECW8xuTx
         BHGTeZHHPQv2RDKFoYE+M2yCq8djZeWwQ8XNtucXVvnVysDlwcSgIRdlGF5Zc46r54
         JEwrbk0pwhF02N5GM8zaHkFxDMqrAQ0K5VXf+q4JO8I+5WeuLEtjYWBHYqz4Jux0+z
         lz/3+O5A4OvsKbZZeEY0qLpyCwO97OWHFQ93lGHdWfDN1sZKgNP3DlOWI8pgM49Tw4
         W3Kdbazlo7Tkg==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 8EBB96025A;
        Mon, 11 Jan 2021 23:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net] dt-bindings: net: dwmac: fix queue priority
 documentation
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161040780857.11400.14581803620222516276.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Jan 2021 23:30:08 +0000
References: <20210111081406.1348622-1-sebastien.laveze@oss.nxp.com>
In-Reply-To: <20210111081406.1348622-1-sebastien.laveze@oss.nxp.com>
To:     Sebastien Laveze <sebastien.laveze@oss.nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, robh+dt@kernel.org,
        alexandre.torgue@st.com, peppe.cavallaro@st.com,
        joabreu@synopsys.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 11 Jan 2021 09:14:07 +0100 you wrote:
> From: Seb Laveze <sebastien.laveze@nxp.com>
> 
> The priority field is not the queue priority (queue priority is fixed)
> but a bitmask of priorities assigned to this queue.
> 
> In receive, priorities relate to tagged frames priorities.
> 
> [...]

Here is the summary with links:
  - [v1,net] dt-bindings: net: dwmac: fix queue priority documentation
    https://git.kernel.org/netdev/net/c/938288349ca8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


