Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC5D13FEC4B
	for <lists+netdev@lfdr.de>; Thu,  2 Sep 2021 12:40:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245512AbhIBKlT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Sep 2021 06:41:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:60426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243737AbhIBKlE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Sep 2021 06:41:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id ADB91610CE;
        Thu,  2 Sep 2021 10:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630579206;
        bh=aDS2uZXdI0BjHa3s8TpvO8297CsKD+XQVlmENKzdoBo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ax+FpW9K36fZJ1pt4XL1mtmg4zwgtS2WQRy27Jz3+dteTdQ5DJtMFJgoabtYfoxk7
         Caw1zc5BXuHz6jzPDCekcKkB9CWmJLRUbTHkUnVnJa9z/w57f8Ab2Xz4oGuGqGF9N/
         u8oX8WZIHOx4XL83CG2sjy3enSii3gxZOBWpZfHOIRP5+yc7PAaAhb9xft9xOagqUD
         M745e/Yomii/JDUHR527AGaEKFK0qZ8Xz/Bc13I/FCGnFJ/hQclJzahR9mL/xQuRZ6
         1OUc7kE+2TITG8uI1pmMem7Pc6ejYUtS9JqVniE5yhsx8gyMGXlBJAAoxgpVMkzeAe
         Upp+476oRGhTQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A16F960A17;
        Thu,  2 Sep 2021 10:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] selftests: add simple GSO GRE test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163057920665.13463.5045726509921985369.git-patchwork-notify@kernel.org>
Date:   Thu, 02 Sep 2021 10:40:06 +0000
References: <20210901155501.353635-1-kuba@kernel.org>
In-Reply-To: <20210901155501.353635-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, dsahern@gmail.com, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Wed,  1 Sep 2021 08:55:01 -0700 you wrote:
> Test case for commit a6e3f2985a80 ("ip6_tunnel: fix GRE6 segmentation").
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
> Looks like I never sent this out.
> 
> v2: correct the script name in the Makefile
> 
> [...]

Here is the summary with links:
  - [net,v2] selftests: add simple GSO GRE test
    https://git.kernel.org/netdev/net/c/025efa0a82df

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


