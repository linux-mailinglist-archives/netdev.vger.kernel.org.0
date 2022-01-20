Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94AC24955CB
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 22:10:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377765AbiATVKL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 16:10:11 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:56580 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377764AbiATVKK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 16:10:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 887C261888
        for <netdev@vger.kernel.org>; Thu, 20 Jan 2022 21:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF085C340E3;
        Thu, 20 Jan 2022 21:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642713010;
        bh=vag0VxHcI2Sk7/RDigszxG3dhfDQTpyyvXOoDmo3hA8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ioJXtvXRif3p3QuprgAFsZqdb9Ao7HvM5jXP2kS/7Dex9AnTKJcVAu5/F/vT1sbVX
         jEA9dt29zPmhUldXWFzQZD9scuJ06+N5H+35AhXqnzq31rwX4nQ1RamfORsnujUBEl
         OKRMYglj44zOnYyJ4jqVQHrzOMwZcg4BD5es7h+YKTfC/jsUqsIB8vHOd8UgGZYnqA
         L8hcXHdd6/Fh8QvKnoW8sMbmUj0G4MXWty2GB9dKxte4uGJa4Lvm/6Hy4EOTW6cAvZ
         U05lwQK4dfYUkMggQW1Ga0SvJvUyd8RGRc06a++psrGrrCIxenIRYm8vSDe9UxnKSk
         xJTtHLFqHlY7g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8462F6079D;
        Thu, 20 Jan 2022 21:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2] tc/action: print error to stderr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164271300987.24582.6533222808514438018.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Jan 2022 21:10:09 +0000
References: <20220120210646.189197-1-stephen@networkplumber.org>
In-Reply-To: <20220120210646.189197-1-stephen@networkplumber.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, jiri@mellanox.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu, 20 Jan 2022 13:06:46 -0800 you wrote:
> Error messages should go to stderr even if using JSON.
> 
> Fixes: 2704bd625583 ("tc: jsonify actions core")
> Cc: jiri@mellanox.com
> Signed-off-by: Stephen Hemminger <stephen@networkplumber.org>
> ---
>  tc/m_action.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)

Here is the summary with links:
  - [iproute2] tc/action: print error to stderr
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=d542543bb5ec

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


