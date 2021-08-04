Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25A0F3DFD8E
	for <lists+netdev@lfdr.de>; Wed,  4 Aug 2021 11:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236906AbhHDJAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Aug 2021 05:00:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:48058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236060AbhHDJAT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Aug 2021 05:00:19 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4968F60F02;
        Wed,  4 Aug 2021 09:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628067607;
        bh=NF4OhEPEsfVQSEySOEmi7M4JdC1ZQDXxeJYIEEM31AA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qvOXmL+ZLjXE9Ye12j9GyO2JmcvkWmgMdwblWgTOdtLRGcQqeW2Qux95x9T80sBW/
         oBOsU356kEC/Xv3Uw2V2Z0j4p4Hfzpk+X//K0BLFNFvekVR4NH61x3hgdIS/g6QH2o
         h/Ky+jdvrY3Esmx5j3jn7o6hDOhoEZagH1Aa8YHCp0cTw/lyaWdeBCr4c5VKMdAHzU
         eOL877kXfc3fNuhCmm/tD/PTzFQiaovAuNSwgnCwImQNgdMXJX8Gyl7pQ+Sr+dsP3F
         Uf3KOb9BBv7p/VJMJUF3rANnQq9TUo1bdZtfcOgIopxtAIFdlmIAK9tIkgVu6F/21n
         ys/46Bf86ciaQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 364BA60A72;
        Wed,  4 Aug 2021 09:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next af_unix v1 0/1] af_unix: Add OOB support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162806760721.27431.16936293271474037892.git-patchwork-notify@kernel.org>
Date:   Wed, 04 Aug 2021 09:00:07 +0000
References: <20210801075707.176201-1-Rao.Shoaib@oracle.com>
In-Reply-To: <20210801075707.176201-1-Rao.Shoaib@oracle.com>
To:     Shoaib Rao <rao.shoaib@oracle.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        viro@zeniv.linux.org.uk, pabeni@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sun,  1 Aug 2021 00:57:06 -0700 you wrote:
> From: Rao Shoaib <rao.shoaib@oracle.com>
> 
> The original Berkeley paper on sockets by Bill Joy
> http://maibriz.de/unix/ultrix/_root/net.pdf
> defined OOB support for all streams sockets.
> However, this support was never added to AF_UNIX
> streams sockets, probably because it was not needed.
> 
> [...]

Here is the summary with links:
  - [net-next,af_unix,v1,1/1] af_unix: Add OOB support
    https://git.kernel.org/netdev/net-next/c/314001f0bf92

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


