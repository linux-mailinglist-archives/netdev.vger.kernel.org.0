Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78E8D4335FF
	for <lists+netdev@lfdr.de>; Tue, 19 Oct 2021 14:30:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235634AbhJSMcb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Oct 2021 08:32:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:58930 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235415AbhJSMca (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Oct 2021 08:32:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 98BA36137B;
        Tue, 19 Oct 2021 12:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634646613;
        bh=eugL9T3Vr9MAt7iQ9wK5Cepix0GbEaI9SlaUAY2SSjQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a3lL0ITys7v2bvhwOFauP+IU9PzCWPe5pH5MSlWxGwSHEVNYk4pPqT+gMldvJ1u+M
         M0AXQlYNsHrPDbpXkiS6ECW4S6cpdJUoFuZtuO4NUQ6Rkpm5jJL+S229o7UYZfIntY
         PqdlC21ozNcT+SiSQVYPmFyErht/FWVVyQx7dwVQ1cYDxuAzOMlFytRA1hjqCzLhnK
         KJpJVAVYtQbQJYqPSKap7vAFcOQjdfiV/daEnrbueVDxe2T3eUWIjgQTFIjkRLc1ZA
         aZp+jg4sKWwh3ryplqBo2HUzEa+iYEzH3nr8LPmQa4fZ+ekqXwDQD1rja8iebVywwz
         RniJWMEPJIQhA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8B62D609E3;
        Tue, 19 Oct 2021 12:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ieee802154: Remove redundant 'flush_workqueue()' calls
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163464661256.12016.17334842037871093626.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Oct 2021 12:30:12 +0000
References: <fedb57c4f6d4373e0d6888d13ad2de3a1d315d81.1634235880.git.christophe.jaillet@wanadoo.fr>
In-Reply-To: <fedb57c4f6d4373e0d6888d13ad2de3a1d315d81.1634235880.git.christophe.jaillet@wanadoo.fr>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     h.morris@cascoda.com, alex.aring@gmail.com,
        stefan@datenfreihafen.org, davem@davemloft.net, kuba@kernel.org,
        linux-wpan@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 14 Oct 2021 20:26:14 +0200 you wrote:
> 'destroy_workqueue()' already drains the queue before destroying it, so
> there is no need to flush it explicitly.
> 
> Remove the redundant 'flush_workqueue()' calls.
> 
> This was generated with coccinelle:
> 
> [...]

Here is the summary with links:
  - ieee802154: Remove redundant 'flush_workqueue()' calls
    https://git.kernel.org/netdev/net-next/c/07fab5a469a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


