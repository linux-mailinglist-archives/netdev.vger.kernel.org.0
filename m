Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932BF331801
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 21:00:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231954AbhCHUA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 15:00:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:54818 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231445AbhCHUAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 8 Mar 2021 15:00:09 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1DEE665260;
        Mon,  8 Mar 2021 20:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615233609;
        bh=WOK51iPATmm/cTYzFeN5qfXiGou73SIlYxPP2qnzIns=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TQSdq5mpYB/eEBG7DmqC+lbMlVAWNRDUDS1brdHksfIBSrNulc9yLuhVvCaUY+GAE
         HKwb300iWPeNkQrK4RSV/nX9tp5QI+FCM+wPfLMHB6tp369hPJVbUNbrkdpe9v5jGB
         BPfYFi7uq1IJseo/KuDCrc/M1F8WzC5cVcvhYrvt/U+mbm3mi5rp4zx7p7NxsjBHMR
         jAb8hpphil+8DqSB12B3i3hDcEv0fyam8z4lx4djgLeDjjRV5rui63HjZ7r1VneBnb
         7lUVU4+WMe8hCf1ku/P8EGkVGvngLR1claJQm4bOTbRiOJoWzRZ/wsoTzqRbYtCwW/
         GPvv/NMl6ZTYA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0BAC060952;
        Mon,  8 Mar 2021 20:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: dsa: bcm_sf2: simplify optional reset handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161523360904.22994.3215150432108432430.git-patchwork-notify@kernel.org>
Date:   Mon, 08 Mar 2021 20:00:09 +0000
References: <20210305091448.19748-1-p.zabel@pengutronix.de>
In-Reply-To: <20210305091448.19748-1-p.zabel@pengutronix.de>
To:     Philipp Zabel <p.zabel@pengutronix.de>
Cc:     netdev@vger.kernel.org, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri,  5 Mar 2021 10:14:48 +0100 you wrote:
> As of commit bb475230b8e5 ("reset: make optional functions really
> optional"), the reset framework API calls use NULL pointers to describe
> optional, non-present reset controls.
> 
> This allows to unconditionally return errors from
> devm_reset_control_get_optional_exclusive.
> 
> [...]

Here is the summary with links:
  - net: dsa: bcm_sf2: simplify optional reset handling
    https://git.kernel.org/netdev/net/c/bf9279cd63dc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


