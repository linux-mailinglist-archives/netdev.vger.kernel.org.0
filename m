Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC8038D02E
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:50:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhEUVvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:51:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:40744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229788AbhEUVve (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 May 2021 17:51:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 74795613F3;
        Fri, 21 May 2021 21:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621633810;
        bh=crY0IHupctvOEdjFkzSRuLCBv/T56lNvYxXj6ZKUcAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KwtwCrHnETr1FRbOFYVvZWEyMpP0xEPuvKfRd1ieCD9od58faPmG8z/HkzX1bboOG
         qN2b768FO6dSDdo60jsgDN1KTuQrsYtn+Lu0yygyX+CSUqeB/YeVtFQ4dWnHDGFxyz
         Qtd5nVuU+pcC726H6duPEJAtVeUcEqA2k8mqv/hE8+UTS0muiFp5CvSBiQZc9mQqQ9
         WyVV9CUMeePJYT589EBs0cP8eZRrFX0cAlKCECWNcr8Mp1zDCah/t4kvyJYZ9pgh4u
         oJ8VNusdIohBHJveSJ65lsISwQNRdGyx5toMug5E6msCStzyTn965XWTwmCgGPYS0V
         ent8EIo0Hr11A==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6212360A56;
        Fri, 21 May 2021 21:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH RDS/TCP v1 1/1] RDS tcp loopback connection can hang
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162163381039.15260.17089891182472871741.git-patchwork-notify@kernel.org>
Date:   Fri, 21 May 2021 21:50:10 +0000
References: <20210521180806.80362-1-Rao.Shoaib@oracle.com>
In-Reply-To: <20210521180806.80362-1-Rao.Shoaib@oracle.com>
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 21 May 2021 11:08:06 -0700 you wrote:
> From: Rao Shoaib <rao.shoaib@oracle.com>
> 
> When TCP is used as transport and a program on the
> system connects to RDS port 16385, connection is
> accepted but denied per the rules of RDS. However,
> RDS connections object is left in the list. Next
> loopback connection will select that connection
> object as it is at the head of list. The connection
> attempt will hang as the connection object is set
> to connect over TCP which is not allowed
> 
> [...]

Here is the summary with links:
  - [RDS/TCP,v1,1/1] RDS tcp loopback connection can hang
    https://git.kernel.org/netdev/net/c/aced3ce57cd3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


