Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BEDD3069FD
	for <lists+netdev@lfdr.de>; Thu, 28 Jan 2021 02:13:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231439AbhA1BMe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Jan 2021 20:12:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:36256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231994AbhA1BKy (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 27 Jan 2021 20:10:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id E455064DDA;
        Thu, 28 Jan 2021 01:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611796211;
        bh=9LnjR7UeSkJTbX8XTyE6hWc7ofprRB8O8zhqb0pENyg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OdbIVB/zpRqa7qj6aedPDq0ZPJKLGZyjRQ5DsLMGyVR0NKYowJqBiY0p/oKe6PCH/
         VY1at08mMrF2JOg3YqoPkwwBqWiXf/n/KvDsjUejvLaOeoKli65zu/uEHy1tZH0OHo
         VwnVYSOE/Et3YUnpNRo3MKbxVW3WaAqn6mGCogAykxxFU50ATXcp96QSVlZpQVH0WP
         oTLK1/TzHCwH8mX4v09Gl/EvlzshxZmDPL79KFcrMqhpEMY5zLg5yIeJibD/hYwiCM
         Ehq6UM0Y9+dr8wgUiWZ1LsmbSiZEe2ANxyRcbqRELl7drzRIVFmBM0q3+8nsRQhpu5
         3io3RHd61LqAg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D03576531F;
        Thu, 28 Jan 2021 01:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: remove redundant 'depends on NET'
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161179621184.21299.11464742781853233216.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Jan 2021 01:10:11 +0000
References: <20210125232026.106855-1-masahiroy@kernel.org>
In-Reply-To: <20210125232026.106855-1-masahiroy@kernel.org>
To:     Masahiro Yamada <masahiroy@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 26 Jan 2021 08:20:26 +0900 you wrote:
> These Kconfig files are included from net/Kconfig, inside the
> if NET ... endif.
> 
> Remove 'depends on NET', which we know it is already met.
> 
> Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
> 
> [...]

Here is the summary with links:
  - net: remove redundant 'depends on NET'
    https://git.kernel.org/netdev/net-next/c/864e898ba3f6

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


