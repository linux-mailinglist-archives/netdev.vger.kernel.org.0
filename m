Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25D333813B0
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 00:20:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233958AbhENWV3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 May 2021 18:21:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:48618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233896AbhENWV0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 14 May 2021 18:21:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id EBBB061454;
        Fri, 14 May 2021 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621030814;
        bh=Qcsk/dc4brdj7gVSyJ28vUg80joR0/w6nyn4Tj1XkXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L9tyE3ItAkguu8tI45GrWFKbHSE7Ci7tLDz3UAMcXX6TTGoUJvSGRQP77LBZBMGRK
         OZzb8eIGvUuqy/X/MvrLZn7YDZY5bApVnBcRutktArrIzosS45rAzZn1cBF/3Awx/y
         DJv68F8ee4QAtuME1iLKUSEi1AbUBz401kFwZ4Qp2Idh6X8Xgt+0T2RBJyqqj194vL
         TE6huvsmm7eHu1gKrMUVkb+n1BquuDla3vU9erU7WtNX8BlhBJGx6IXk5BGUIBHFyi
         aWD1DGM7vVpLTEc1x3cN19AA+PaFghTHC/0vBGhzy8HKzD7kBdZCt8PUmGqqDLhM8z
         /R0RQ43Hzv5Cw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E62936095D;
        Fri, 14 May 2021 22:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: hns: clean up some code style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162103081393.6483.118787856225039543.git-patchwork-notify@kernel.org>
Date:   Fri, 14 May 2021 22:20:13 +0000
References: <1620977502-27236-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1620977502-27236-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, salil.mehta@huawei.com,
        lipeng321@huawei.com, tanhuazhong@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 14 May 2021 15:31:38 +0800 you wrote:
> This patchset clean up some code style issues.
> 
> Peng Li (4):
>   net: hns: fix the comments style issue
>   net: hns: fix some code style issue about space
>   net: hns: space required before the open brace '{'
>   net: hns: remove redundant return int void function
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: hns: fix the comments style issue
    https://git.kernel.org/netdev/net-next/c/699e803e9a4d
  - [net-next,2/4] net: hns: fix some code style issue about space
    https://git.kernel.org/netdev/net-next/c/510fe8e70b0b
  - [net-next,3/4] net: hns: space required before the open brace '{'
    https://git.kernel.org/netdev/net-next/c/5caab55a2979
  - [net-next,4/4] net: hns: remove redundant return int void function
    https://git.kernel.org/netdev/net-next/c/cb0672697601

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


