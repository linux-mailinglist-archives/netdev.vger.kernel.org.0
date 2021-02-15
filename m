Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6B8431C45A
	for <lists+netdev@lfdr.de>; Tue, 16 Feb 2021 00:25:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230138AbhBOXWy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 18:22:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:33720 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230015AbhBOXVf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Feb 2021 18:21:35 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 2584E64E0F;
        Mon, 15 Feb 2021 23:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613431209;
        bh=iACck1P0hnI5PXqNmAQtt7nbapkHhKTNxlNL9IONW/I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c0jesDVtB/QzcswYIBYiiCFQuoAQY7KGEV3h2m3UDM921PSQIw9c5s6eHd2NPHWZX
         94gpAD99b5kizT2cYaiKG2hk5X70F8ZJucbvfIzSu+CjMcHkKb3PgYltwnI2Jh5XJI
         QFTCGHhVKKWQYhqDI+eXAhbCYwZn3FAuWIP7lWBrTfEIKXTeiqwno6le0y5bSIF+KO
         HvYprJwsLAlniTrCGFnaIVxd8FVAg8LwTda088+QMlWWdUQ18ZL7svyaBxtQh9X1L0
         i9aC/G5oYYI1TovqvZwPs6HY7AzaajNfNpQW1m6GfiyVa0+ZDv2cZGe7SHUiPWZv7p
         EWmZHGCbBoYSw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 1908F609D9;
        Mon, 15 Feb 2021 23:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ibmvnic: simplify reset_long_term_buff function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161343120909.10830.15364264541282401781.git-patchwork-notify@kernel.org>
Date:   Mon, 15 Feb 2021 23:20:09 +0000
References: <20210213023610.55911-1-ljp@linux.ibm.com>
In-Reply-To: <20210213023610.55911-1-ljp@linux.ibm.com>
To:     Lijun Pan <ljp@linux.ibm.com>
Cc:     netdev@vger.kernel.org, sukadev@linux.ibm.com, drt@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 12 Feb 2021 20:36:10 -0600 you wrote:
> The only thing reset_long_term_buff() should do is set
> buffer to zero. After doing that, it is not necessary to
> send_request_map again to VIOS since it actually does not
> change the mapping. So, keep memset function and remove all
> others.
> 
> Signed-off-by: Lijun Pan <ljp@linux.ibm.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ibmvnic: simplify reset_long_term_buff function
    https://git.kernel.org/netdev/net-next/c/1c7d45e7b2c2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


