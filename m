Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F8423AA4FB
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 22:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233265AbhFPUMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 16:12:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:58470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233140AbhFPUMR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 16:12:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 90F5D613CD;
        Wed, 16 Jun 2021 20:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623874210;
        bh=MRlH059wm6G5vgnYnlnKpUqxuDx5Fqn/Wgq5h5H60Pc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QwfFx0+P1aCiPEEuhLOBwgWMpqSa7qYeQ8TFBOL2k6sRiYCi71h+wRFJU76J/YOo+
         H9qPk+3PuksnRQgg073X7MdQiLl7hRWUZVYgXMgnPp03QlM1j3O/eidY4hcEE1YDZ2
         J4XFucPAe1j+EjCkT4/TfFO8yoxREX17SfWvXiSGPuPDJPdn5COJ2MeVEyGc5FkvA3
         Y0WyTb/Px9ZTYWe0/odhbxd3qLySFs6fkUoMNzx7VhwGNqWXPhKRIYLPMWl4TCwWrF
         A1KOR9wCM/vrCsNAJZdluGYU441q9kazjL1+l4zTDF47hTLro1vE5mFM9XCtLiljjc
         lHpVTyu5wvMdQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8B6C760989;
        Wed, 16 Jun 2021 20:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] Marvell Prestera add flower and match all
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387421056.22643.14021281815591078414.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 20:10:10 +0000
References: <20210616160145.17376-1-vadym.kochan@plvision.eu>
In-Reply-To: <20210616160145.17376-1-vadym.kochan@plvision.eu>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        andrew@lunn.ch, olteanv@gmail.com, tchornyi@marvell.com,
        linux-kernel@vger.kernel.org, mickeyr@marvell.com,
        vkochan@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 19:01:43 +0300 you wrote:
> From: Vadym Kochan <vkochan@marvell.com>
> 
> Add ACL infrastructure for Prestera Switch ASICs family devices to
> offload cls_flower rules to be processed in the HW.
> 
> ACL implementation is based on tc filter api. The flower classifier
> is supported to configure ACL rules/matches/action.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: marvell: Implement TC flower offload
    https://git.kernel.org/netdev/net-next/c/8b474a9f6b37
  - [net-next,v2,2/2] net: marvell: prestera: Add matchall support
    https://git.kernel.org/netdev/net-next/c/13defa275eef

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


