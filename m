Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E72EA3F6841
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 19:41:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242456AbhHXRlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 13:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:45140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242733AbhHXRjr (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 13:39:47 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CE54161247;
        Tue, 24 Aug 2021 17:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629826205;
        bh=STN5vzTMEKGr7Fy4E3gjxG8XS7mJtnBQUUW7elLKmIw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uAr1H3FXNQoIrYBYPVSOBZk7Ql3cj3+ue/1FkdUXUre4mUualoHxz/ETUVRuZY2EK
         3aPzCSZsjqoeEhstqUt1DpRweFLEGhosFTH4fP4sobUducCf2rq7JXGzN4D/fwI3C/
         4tV+D7hGo+hYS2TzolEksdvCEic+6dcajzvgYdNVQxe6gdRe8H24jjfVhYX0RV4fu7
         tgWhyMcShw7UC6r639VYCdVX/XHWyATQYA8nSVV2qnnwmgwpXkjcQhEm/WKVGOTmwK
         nqF7hrpFrTdhtDWVoNPtvt4/SAeYaPxGEDRIElc3TG0Dn9NVCfognGdQiR7IaUC/1g
         MVONR7zZ2aYeQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C3F5B6095B;
        Tue, 24 Aug 2021 17:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool] Remove trailing newline in perror messages
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162982620579.13896.15485986035984260825.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Aug 2021 17:30:05 +0000
References: <20210811144359.30419-1-jmaselbas@kalray.eu>
In-Reply-To: <20210811144359.30419-1-jmaselbas@kalray.eu>
To:     Jules Maselbas <jmaselbas@kalray.eu>
Cc:     mkubecek@suse.cz, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to ethtool/ethtool.git (refs/heads/master):

On Wed, 11 Aug 2021 16:43:59 +0200 you wrote:
> perror append additional text at the end of the error message,
> and will also include a newline. The newline in the error message
> it self is not needed and can be removed. This makes errors much
> nicer to read.
> 
> Signed-off-by: Jules Maselbas <jmaselbas@kalray.eu>
> 
> [...]

Here is the summary with links:
  - [ethtool] Remove trailing newline in perror messages
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=abe26809f5c7

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


