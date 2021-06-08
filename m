Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9919B3A0190
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 21:17:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbhFHSyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 14:54:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:49370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236345AbhFHSwE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 14:52:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 89CB161585;
        Tue,  8 Jun 2021 18:40:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623177604;
        bh=M+tyoiwpnw1CNe5s7FipeGgbyoH4CHqjoKfv/w0URig=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JCCOVcrglHFPiImVBOtUZiy2KRCtAZJVuVwKNAdts5GwYVxZqklo1FP8YVgszQAae
         giIIcg+/p7vT5V3Y71z306BBojQvUxa4tSo9GeB9za10JwugCJrbVBDb+NSfVL/ywk
         6BYm9FeoklkgKDzA6aQX8dTun62CNOyk2aXb+dIHGLbNjV4SUqWmy6VsYZ5KknxqUW
         5ojEoMN3T2NP+4w8Rg68CBZ0tcZ5u10brNddQ6HzIIPcjLphjZSlVMHgZ/aUKkNJKG
         N6vu0el7TVkBQiGuF0bAVPYccrbnwlCXGoSZkg2QSLVHWbEj/1nlbOxKiOdywEM0kw
         ebpOJMbfejQxg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 82769609E4;
        Tue,  8 Jun 2021 18:40:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Kconfig: indent with tabs instead of spaces
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162317760452.20688.14671810946773039702.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 18:40:04 +0000
References: <20210608012648.17177-1-kabel@kernel.org>
In-Reply-To: <20210608012648.17177-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue,  8 Jun 2021 03:26:48 +0200 you wrote:
> The BAREUDP config option uses spaces instead of tabs for indentation.
> The rest of this file uses tabs. Fix this.
> 
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/net/Kconfig | 22 +++++++++++-----------
>  1 file changed, 11 insertions(+), 11 deletions(-)

Here is the summary with links:
  - [net-next] net: Kconfig: indent with tabs instead of spaces
    https://git.kernel.org/netdev/net-next/c/d6dd33ffa33b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


