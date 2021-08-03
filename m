Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97A543DEB73
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 13:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235564AbhHCLA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 07:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:46220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235565AbhHCLAR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Aug 2021 07:00:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id BB29161053;
        Tue,  3 Aug 2021 11:00:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627988406;
        bh=engEtDy3bL12YPq3fHqs4nUdXxiNW3VL75oqJgPok3k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kiZodGT0xDzZT61r8MMrBKWzFsghCZ0S1oD3PnR4Hvq0jyYG+6oqIHOPgHsqdaF02
         5qHf/OkUlIM43U4F1fjTXyAx5rl1f2w3EvSkC6S3TsC+4x4yA4eNfhGZ5glL4rdK9J
         IjkX87YFs3uMquqHzXRec1D6x8N1COut9GzF0AtkZw/05WP2T+67UABd24jZBbLoIn
         KwdFQ2OvBldS3/E/07gKtiligPEYAApWU+RMhxw7IDcN/geT8Ci4M5cv+eP0uPwfsp
         rW8VAV9fqqIOLPdg1fSGuGi/Sdux/D8G8r/sTSJj2xbBul5ifJPvcGfyUZz/u1jf67
         lX0KGm2UXBi7g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id B5F7260A44;
        Tue,  3 Aug 2021 11:00:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net-next] bonding: add new option lacp_active
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162798840674.8237.461117241541268445.git-patchwork-notify@kernel.org>
Date:   Tue, 03 Aug 2021 11:00:06 +0000
References: <20210802030220.841726-1-liuhangbin@gmail.com>
In-Reply-To: <20210802030220.841726-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, jarod@redhat.com, davem@davemloft.net,
        kuba@kernel.org, jiri@resnulli.us
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon,  2 Aug 2021 11:02:19 +0800 you wrote:
> Add an option lacp_active, which is similar with team's runner.active.
> This option specifies whether to send LACPDU frames periodically. If set
> on, the LACPDU frames are sent along with the configured lacp_rate
> setting. If set off, the LACPDU frames acts as "speak when spoken to".
> 
> Note, the LACPDU state frames still will be sent when init or unbind port.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net-next] bonding: add new option lacp_active
    https://git.kernel.org/netdev/net-next/c/3a755cd8b7c6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


