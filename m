Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E2BD3BA4D3
	for <lists+netdev@lfdr.de>; Fri,  2 Jul 2021 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231631AbhGBUwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Jul 2021 16:52:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:46472 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230274AbhGBUwf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 2 Jul 2021 16:52:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 588BC613F5;
        Fri,  2 Jul 2021 20:50:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625259003;
        bh=+c8qKgOyi7r/Kcr0+2ETDkixMDrLcl3BfE0cDD1jsuA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JvfM33LhcWH0L/+S1Nki0NoNYFQ+zWxXN5NayseiThqSKbgUgGurRukyvy4TP9UBK
         7WTVYdxyx6uAjxQsDwSGFW5BdRvsREu8E4sC5lOTzSryDzAWYizUOuuIlnbTJn8Dk0
         +5JtAKWTf4mPiDJxBg9bbbjOXKAo9AsghiwFsLHYMU1LExKKS01J6a9Jm2Vl6o5DKw
         i8aK8ycTduyAHBNSHIIigyMSMF8yQM7Vmd7ZUTc0Cygu3vYSf2e7dGcsVicXlyuMOc
         mePDh9v1gji++uvKCBsQWEJ9DYvOvMRTVY+C76yk0BA+xwY5/OaFslK7l1UVRyrtfo
         A8wrDK0rHxnfQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4C0EB60283;
        Fri,  2 Jul 2021 20:50:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vmxnet3: fix cksum offload issues for tunnels with
 non-default udp ports
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162525900330.32544.14329304021795937679.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Jul 2021 20:50:03 +0000
References: <20210702064427.32378-1-doshir@vmware.com>
In-Reply-To: <20210702064427.32378-1-doshir@vmware.com>
To:     Ronak Doshi <doshir@vmware.com>
Cc:     netdev@vger.kernel.org, pv-drivers@vmware.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Thu, 1 Jul 2021 23:44:27 -0700 you wrote:
> Commit dacce2be3312 ("vmxnet3: add geneve and vxlan tunnel offload
> support") added support for encapsulation offload. However, the inner
> offload capability is to be restricted to UDP tunnels with default
> Vxlan and Geneve ports.
> 
> This patch fixes the issue for tunnels with non-default ports using
> features check capability and filtering appropriate features for such
> tunnels.
> 
> [...]

Here is the summary with links:
  - [net] vmxnet3: fix cksum offload issues for tunnels with non-default udp ports
    https://git.kernel.org/netdev/net/c/b22580233d47

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


