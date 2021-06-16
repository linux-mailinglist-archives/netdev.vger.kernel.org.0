Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 554283AA42A
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232664AbhFPTWM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:22:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232628AbhFPTWK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:22:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 584AD613C2;
        Wed, 16 Jun 2021 19:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623871204;
        bh=Cutqgtq1nDFUbNZhrjjIuilBC8+Pyq/0E0b3v0M4HkA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R6UZZsWeGaruZngi80q86c2gYHIE5RO7y+FAzbmEpQJ5UhLHcXAIylkDRL6JcQ1Gl
         KvxNZfLFl0CIeMhMC7frsycUmclv4HgyDr8y+gnmZEXL3kOqGRBvIdIa3e+0Wlpa7Q
         b+8bDA72ybbvzEuAmEvZvWldQaYzsqFwPl7Sla5z8BAM6triXr+rEWPHjtdGyRA9r2
         ipB+XdPufIVA7uq3nJv1eoG2qyHiXDD/7amesXq73evQbs1W1zBf187+djcBSHPkSB
         zB5PeZ6utvOWs2IFlqTyrmDghBpy8NcSPnTl5+MP5mNSzFJuV4IDCRYepk4iUQ4onj
         QUYW4YIGVwDUQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 450D060CAA;
        Wed, 16 Jun 2021 19:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: dsa: xrs700x: forward HSR supervision frames
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387120427.29488.8583760405715339736.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:20:04 +0000
References: <20210616013903.41564-1-george.mccollister@gmail.com>
In-Reply-To: <20210616013903.41564-1-george.mccollister@gmail.com>
To:     George McCollister <george.mccollister@gmail.com>
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 15 Jun 2021 20:39:03 -0500 you wrote:
> Forward supervision frames between redunant HSR ports. This was broken
> in the last commit.
> 
> Fixes: 1a42624aecba ("net: dsa: xrs700x: allow HSR/PRP supervision dupes for node_table")
> Signed-off-by: George McCollister <george.mccollister@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: dsa: xrs700x: forward HSR supervision frames
    https://git.kernel.org/netdev/net-next/c/a4fc566543c0

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


