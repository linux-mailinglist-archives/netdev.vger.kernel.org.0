Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AA56445DF3
	for <lists+netdev@lfdr.de>; Fri,  5 Nov 2021 03:30:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbhKECcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Nov 2021 22:32:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:38568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229587AbhKECcq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Nov 2021 22:32:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4C0CF611AE;
        Fri,  5 Nov 2021 02:30:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636079407;
        bh=bpOxBh4+l1D+uUqXMPFto5X4pv4MBB3feOnFtc+F4GU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IWEcl/BdfPWf2T4nBqnA5teXOfi36eQBg5sOLLnBj4TVZiWaIREPOwMUDZkR1DA2k
         KYU/Iq64ki5ekVDNXFr6NlWspgcwPQwpq26o6aR8/Ql10kQeMqx5uPPsTswxCcSK5d
         CLYGMpKnQooTCzaYz1PAkcfA34E0E4ZKeal739roo0Mu0DGPcILV9baUupeYNPF89w
         qGYKrjJNhvsD6PiIQVZkrh1VWSA+WDzc5GXMRXLkUqtBogzr32tYDaXVTC2liKn76X
         JD/Ts+YdThGmxFtyYzr3/Gf4OY2Q50XW9CAahdJNty+vE5Y6wbqhgugygfGVDUqezY
         UaXxgxyzA1IzQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 447AB60981;
        Fri,  5 Nov 2021 02:30:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] MCTP sockaddr padding check/initialisation
 fixup
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163607940727.4777.16083570466558280918.git-patchwork-notify@kernel.org>
Date:   Fri, 05 Nov 2021 02:30:07 +0000
References: <cover.1635965993.git.esyr@redhat.com>
In-Reply-To: <cover.1635965993.git.esyr@redhat.com>
To:     Eugene Syromiatnikov <esyr@redhat.com>
Cc:     jk@codeconstruct.com.au, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 3 Nov 2021 20:09:36 +0100 you wrote:
> Hello.
> 
> This pair of patches introduces checks for padding fields of struct
> sockaddr_mctp/sockaddr_mctp_ext to ease their re-use for possible
> extensions in the future;  as well as zeroing of these fields
> in the respective sockaddr filling routines.  While the first commit
> is definitely an ABI breakage, it is proposed in hopes that the change
> is made soon enough (the interface appeared only in Linux 5.15)
> to avoid affecting any existing user space.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] mctp: handle the struct sockaddr_mctp padding fields
    https://git.kernel.org/netdev/net/c/1e4b50f06d97
  - [net-next,v2,2/2] mctp: handle the struct sockaddr_mctp_ext padding field
    https://git.kernel.org/netdev/net/c/e9ea574ec1c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


