Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 551F03052F1
	for <lists+netdev@lfdr.de>; Wed, 27 Jan 2021 07:14:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234223AbhA0GBb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 01:01:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:50376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235913AbhA0D0S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 Jan 2021 22:26:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id A6DA364D90;
        Wed, 27 Jan 2021 02:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611713411;
        bh=CNkLelesmnRZds1eDIzAlTgecqAnRvTpjmFkB5bB8v8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kdqyMblQJ+0EEThB7m/Qq2aZ+8xr37kvEksY9qwV+IsqHP+hLEiQG7fuwf1DPjstt
         FmxH2NdBOC40F25sEM0AKN2lBu47RkKLGYDrEhdxo2elp0dFsAIAZ+UjCBm1ILMlHj
         JNZNHjpUFlLJ6H6EysZAx3lbkpyMXFDNuvw1Tfgy1dnxYklNZSCeJrlaXSPs7HEi6b
         e7sKBngAcN9T0hoZu0o6r3dt2TB8KqMjBYm59H4VMKBj77BOhcFVd2ajK1Qom6pzFm
         upjDga+YrLZC6azS/9LvirNkh3ui6wxz33XXOR/xrNOPTC458nN8u7nfYQDnTUKV1I
         oViflI3u4lz3w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 97404652DC;
        Wed, 27 Jan 2021 02:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] net: usbnet: convert to new tasklet API
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161171341161.20940.5160141263465428058.git-patchwork-notify@kernel.org>
Date:   Wed, 27 Jan 2021 02:10:11 +0000
References: <20210123173221.5855-1-esmil@mailme.dk>
In-Reply-To: <20210123173221.5855-1-esmil@mailme.dk>
To:     Emil Renner Berthing <esmil@mailme.dk>
Cc:     linux-usb@vger.kernel.org, netdev@vger.kernel.org, kernel@esmil.dk,
        oneukum@suse.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 23 Jan 2021 18:32:19 +0100 you wrote:
> From: Emil Renner Berthing <kernel@esmil.dk>
> 
> This converts the usbnet driver to use the new tasklet API introduced in
> commit 12cc923f1ccc ("tasklet: Introduce new initialization API")
> 
> It is split into two commits for ease of reviewing.
> 
> [...]

Here is the summary with links:
  - [1/2] net: usbnet: initialize tasklet using tasklet_init
    https://git.kernel.org/netdev/net-next/c/90a586b8d741
  - [2/2] net: usbnet: use new tasklet API
    https://git.kernel.org/netdev/net-next/c/c955e329bb9d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


