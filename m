Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4BC82C94D9
	for <lists+netdev@lfdr.de>; Tue,  1 Dec 2020 02:52:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726151AbgLABuq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Nov 2020 20:50:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:40156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725918AbgLABuq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 30 Nov 2020 20:50:46 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606787405;
        bh=C+0hM4c5pTbx9POt2qCKZf14YmY1AZ0ydrQkHoGgLUU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RiLQH5yAj3LeCyl5QJQ2BHvztc43TyrU9qzlKLJO2VTj+NkOHRLWIXL/a0G0+ZNxL
         CeXsqNuwLx8H78TCawHfktahyiKKCEphnWwOwlPzBmoHbjX2HKSGp1wJW9vYSXPiLU
         tLXdaT3IQKhWUc+SYC6fPJqlHMMbuNq5wN40LFoA=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] chelsio/chtls: fix panic during unload reload chtls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160678740586.10783.14565960986840699090.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Dec 2020 01:50:05 +0000
References: <20201125214913.16938-1-vinay.yadav@chelsio.com>
In-Reply-To: <20201125214913.16938-1-vinay.yadav@chelsio.com>
To:     Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        secdev@chelsio.com, udai.sharma@chelsio.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 26 Nov 2020 03:19:14 +0530 you wrote:
> there is kernel panic in inet_twsk_free() while chtls
> module unload when socket is in TIME_WAIT state because
> sk_prot_creator was not preserved on connection socket.
> 
> Fixes: cc35c88ae4db ("crypto : chtls - CPL handler definition")
> Signed-off-by: Udai Sharma <udai.sharma@chelsio.com>
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
> 
> [...]

Here is the summary with links:
  - [net] chelsio/chtls: fix panic during unload reload chtls
    https://git.kernel.org/netdev/net/c/e3d5e971d2f8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


