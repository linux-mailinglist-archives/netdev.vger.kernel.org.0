Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B53443FFF4F
	for <lists+netdev@lfdr.de>; Fri,  3 Sep 2021 13:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348344AbhICLlH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Sep 2021 07:41:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48140 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234758AbhICLlF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Sep 2021 07:41:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0BA19610CE;
        Fri,  3 Sep 2021 11:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630669206;
        bh=ZbEm+2nbPeStD6+X7T+DxuQ3gQ3W3sM/epKsqPLVTas=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YSCQjHFv7NfirerRe/F/X49yZ4P2UbJl+9qyVebry/HY/RtIWk4llGluIYVvmboPI
         /tekI9RVowYWMVMfeF+9QReQ3hrYApdGkocPD14bx4ws8wqNRAFiutDECJ/qwIVNfQ
         RcwcJoq2RDHppnFRvbatwOANA2pueGJ0YEAXisRyY8CkD03+ZVCy3DU944xJMScQ0d
         HGMBhwnFVw+gDHou0fX1tgS3q8LJYpf8CREJyCCs0bWvrfNgX3l6cJh7jEsaqYilpg
         DitSj2okBp4qarS7PeY8/gqINuSEplMS3Y7KEK6DlKeX7nTLlsxSIg5gXKRZOzumiQ
         O0b+JufgyVspA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F36CB60A17;
        Fri,  3 Sep 2021 11:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] seg6_iptunnel: Remove redundant initialization of variable
 err
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163066920599.926.10827496368400005217.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Sep 2021 11:40:05 +0000
References: <20210902143506.41956-1-colin.king@canonical.com>
In-Reply-To: <20210902143506.41956-1-colin.king@canonical.com>
To:     Colin King <colin.king@canonical.com>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu,  2 Sep 2021 15:35:05 +0100 you wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> The variable err is being initialized with a value that is never read, it
> is being updated later on. The assignment is redundant and can be removed.
> 
> Addresses-Coverity: ("Unused value")
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> 
> [...]

Here is the summary with links:
  - seg6_iptunnel: Remove redundant initialization of variable err
    https://git.kernel.org/netdev/net/c/bf0df73a2f0d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


