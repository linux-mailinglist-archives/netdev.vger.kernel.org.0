Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6956F39530C
	for <lists+netdev@lfdr.de>; Sun, 30 May 2021 23:30:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229920AbhE3Vbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 30 May 2021 17:31:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:44090 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229816AbhE3Vbm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 30 May 2021 17:31:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E00BF611AB;
        Sun, 30 May 2021 21:30:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622410203;
        bh=PPA1TClYLp6Td3JHzTOFhz5tR2jg4jbhaICIxDjfVAo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qXopatiAKzmzNdFXsJt0UxnkRzKby4eP/hInUdMEac+YORuI26MBMavtaX/K+XRV8
         a/YcHd4xMIRhlX1s5BSZIKNTHlCnoPtJ8/mbw53Vl9c9paSWd4rj/Oj9y8B5Z4vXDn
         Udb2pstLSRNv0ZqfE4pepL9LVXl8t0y28oisV9rLLH6rJu1qsgal03WsJplN7cFvJ9
         4NmMlIi2yUVbgNQdJ6UZC26PYLrvyFSGIZZO2F2EQTLS2qYOUViwbOM2gBB5AutNcH
         +3jRnFrmgC00detV3k8FFDQtxpdY0USdTkJ9fJcFExoONJXl8UkscDQTCVzRIUsnIO
         6u8m9J/ZTgTEA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id D350E609EA;
        Sun, 30 May 2021 21:30:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 0/2] fixes for yt8511 phy driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162241020386.28062.1219688691635725746.git-patchwork-notify@kernel.org>
Date:   Sun, 30 May 2021 21:30:03 +0000
References: <20210529110556.202531-1-pgwipeout@gmail.com>
In-Reply-To: <20210529110556.202531-1-pgwipeout@gmail.com>
To:     Peter Geis <pgwipeout@gmail.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, nathan@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        clang-built-linux@googlegroups.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 29 May 2021 07:05:54 -0400 you wrote:
> The Intel clang bot caught a few uninitialized variables in the new
> Motorcomm driver. While investigating the issue, it was found that the
> driver would have unintended effects when used in an unsupported mode.
> 
> Fixed the uninitialized ret variable and abort loading the driver in
> unsupported modes.
> 
> [...]

Here is the summary with links:
  - [v3,1/2] net: phy: fix yt8511 clang uninitialized variable warning
    https://git.kernel.org/netdev/net-next/c/546d6bad18c0
  - [v3,2/2] net: phy: abort loading yt8511 driver in unsupported modes
    https://git.kernel.org/netdev/net-next/c/0cc8bddb5b06

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


